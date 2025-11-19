import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

/// Service for caching processed images and data
class CacheService {
  static final CacheService _instance = CacheService._internal();
  factory CacheService() => _instance;
  CacheService._internal();

  static const String _cacheDirectory = 'image_cache';
  static const String _cacheIndexKey = 'cache_index';
  static const int _maxCacheSize = 100 * 1024 * 1024; // 100 MB
  static const Duration _cacheExpiry = Duration(days: 7);

  Directory? _cacheDir;
  final Map<String, CacheEntry> _memoryCache = {};

  /// Initialize cache service
  Future<void> initialize() async {
    final appDir = await getApplicationDocumentsDirectory();
    _cacheDir = Directory('${appDir.path}/$_cacheDirectory');

    if (!await _cacheDir!.exists()) {
      await _cacheDir!.create(recursive: true);
    }

    await _loadCacheIndex();
    await _cleanExpiredCache();
  }

  /// Generate cache key from file path and options
  String _generateCacheKey(String filePath, Map<String, dynamic>? options) {
    final combined = '$filePath${jsonEncode(options ?? {})}';
    return md5.convert(utf8.encode(combined)).toString();
  }

  /// Cache processed image
  Future<bool> cacheImage({
    required String originalPath,
    required File processedFile,
    Map<String, dynamic>? options,
  }) async {
    if (_cacheDir == null) await initialize();

    try {
      final cacheKey = _generateCacheKey(originalPath, options);
      final cacheFilePath = '${_cacheDir!.path}/$cacheKey.png';
      final cacheFile = File(cacheFilePath);

      // Copy processed file to cache
      await processedFile.copy(cacheFilePath);

      // Create cache entry
      final entry = CacheEntry(
        key: cacheKey,
        filePath: cacheFilePath,
        originalPath: originalPath,
        options: options,
        createdAt: DateTime.now(),
        size: await cacheFile.length(),
      );

      _memoryCache[cacheKey] = entry;
      await _saveCacheIndex();

      // Check cache size and clean if necessary
      await _enforceCacheSize();

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get cached image
  Future<File?> getCachedImage({
    required String originalPath,
    Map<String, dynamic>? options,
  }) async {
    if (_cacheDir == null) await initialize();

    final cacheKey = _generateCacheKey(originalPath, options);
    final entry = _memoryCache[cacheKey];

    if (entry == null) return null;

    // Check if cache expired
    if (DateTime.now().difference(entry.createdAt) > _cacheExpiry) {
      await _removeCacheEntry(cacheKey);
      return null;
    }

    final cacheFile = File(entry.filePath);
    if (await cacheFile.exists()) {
      // Update access time
      entry.lastAccessed = DateTime.now();
      await _saveCacheIndex();
      return cacheFile;
    } else {
      // File doesn't exist, remove from index
      await _removeCacheEntry(cacheKey);
      return null;
    }
  }

  /// Check if image is cached
  Future<bool> isCached({
    required String originalPath,
    Map<String, dynamic>? options,
  }) async {
    final cached = await getCachedImage(
      originalPath: originalPath,
      options: options,
    );
    return cached != null;
  }

  /// Remove specific cache entry
  Future<void> _removeCacheEntry(String cacheKey) async {
    final entry = _memoryCache[cacheKey];
    if (entry != null) {
      final file = File(entry.filePath);
      if (await file.exists()) {
        await file.delete();
      }
      _memoryCache.remove(cacheKey);
      await _saveCacheIndex();
    }
  }

  /// Clean expired cache entries
  Future<void> _cleanExpiredCache() async {
    final now = DateTime.now();
    final expiredKeys = <String>[];

    for (final entry in _memoryCache.entries) {
      if (now.difference(entry.value.createdAt) > _cacheExpiry) {
        expiredKeys.add(entry.key);
      }
    }

    for (final key in expiredKeys) {
      await _removeCacheEntry(key);
    }
  }

  /// Enforce maximum cache size
  Future<void> _enforceCacheSize() async {
    int totalSize = 0;
    for (final entry in _memoryCache.values) {
      totalSize += entry.size;
    }

    if (totalSize <= _maxCacheSize) return;

    // Sort by last accessed time (LRU)
    final sortedEntries = _memoryCache.entries.toList()
      ..sort((a, b) => a.value.lastAccessed.compareTo(b.value.lastAccessed));

    // Remove oldest entries until under size limit
    for (final entry in sortedEntries) {
      if (totalSize <= _maxCacheSize) break;

      totalSize -= entry.value.size;
      await _removeCacheEntry(entry.key);
    }
  }

  /// Clear all cache
  Future<void> clearAll() async {
    if (_cacheDir == null) await initialize();

    // Delete all cached files
    if (await _cacheDir!.exists()) {
      await _cacheDir!.delete(recursive: true);
      await _cacheDir!.create(recursive: true);
    }

    _memoryCache.clear();
    await _saveCacheIndex();
  }

  /// Get cache statistics
  Future<Map<String, dynamic>> getCacheStats() async {
    if (_cacheDir == null) await initialize();

    int totalSize = 0;
    int fileCount = 0;

    for (final entry in _memoryCache.values) {
      totalSize += entry.size;
      fileCount++;
    }

    return {
      'totalSize': totalSize,
      'totalSizeMB': (totalSize / (1024 * 1024)).toStringAsFixed(2),
      'fileCount': fileCount,
      'maxSizeMB': (_maxCacheSize / (1024 * 1024)).toStringAsFixed(2),
      'usagePercent': ((totalSize / _maxCacheSize) * 100).toStringAsFixed(1),
    };
  }

  /// Load cache index from SharedPreferences
  Future<void> _loadCacheIndex() async {
    final prefs = await SharedPreferences.getInstance();
    final indexJson = prefs.getString(_cacheIndexKey);

    if (indexJson != null) {
      try {
        final List<dynamic> entries = jsonDecode(indexJson);
        for (final entry in entries) {
          final cacheEntry = CacheEntry.fromMap(entry);
          _memoryCache[cacheEntry.key] = cacheEntry;
        }
      } catch (e) {
        // If loading fails, start with empty cache
        _memoryCache.clear();
      }
    }
  }

  /// Save cache index to SharedPreferences
  Future<void> _saveCacheIndex() async {
    final prefs = await SharedPreferences.getInstance();
    final entries = _memoryCache.values.map((e) => e.toMap()).toList();
    await prefs.setString(_cacheIndexKey, jsonEncode(entries));
  }
}

/// Cache entry model
class CacheEntry {
  final String key;
  final String filePath;
  final String originalPath;
  final Map<String, dynamic>? options;
  final DateTime createdAt;
  DateTime lastAccessed;
  final int size;

  CacheEntry({
    required this.key,
    required this.filePath,
    required this.originalPath,
    this.options,
    required this.createdAt,
    DateTime? lastAccessed,
    required this.size,
  }) : lastAccessed = lastAccessed ?? createdAt;

  Map<String, dynamic> toMap() {
    return {
      'key': key,
      'filePath': filePath,
      'originalPath': originalPath,
      'options': options,
      'createdAt': createdAt.toIso8601String(),
      'lastAccessed': lastAccessed.toIso8601String(),
      'size': size,
    };
  }

  factory CacheEntry.fromMap(Map<String, dynamic> map) {
    return CacheEntry(
      key: map['key'],
      filePath: map['filePath'],
      originalPath: map['originalPath'],
      options: map['options'],
      createdAt: DateTime.parse(map['createdAt']),
      lastAccessed: DateTime.parse(map['lastAccessed']),
      size: map['size'],
    );
  }
}
