import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'dart:convert';

/// Service for offline caching and viewing
class OfflineCacheService {
  static final OfflineCacheService _instance = OfflineCacheService._internal();
  factory OfflineCacheService() => _instance;
  OfflineCacheService._internal();

  Directory? _cacheDir;
  final Map<String, dynamic> _memoryCache = {};

  /// Initialize cache directory
  Future<void> initialize() async {
    final appDir = await getApplicationDocumentsDirectory();
    _cacheDir = Directory(path.join(appDir.path, 'offline_cache'));

    if (!await _cacheDir!.exists()) {
      await _cacheDir!.create(recursive: true);
    }

    debugPrint('Offline cache initialized: ${_cacheDir!.path}');
  }

  /// Cache an image from URL
  Future<String?> cacheImage({
    required String url,
    required String cacheKey,
  }) async {
    try {
      if (_cacheDir == null) await initialize();

      // Check if already cached
      final cached = await getCachedImagePath(cacheKey);
      if (cached != null) return cached;

      // Download image
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) return null;

      // Save to cache
      final filePath = path.join(_cacheDir!.path, '$cacheKey.jpg');
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);

      debugPrint('Image cached: $cacheKey');
      return filePath;
    } catch (e) {
      debugPrint('Error caching image: $e');
      return null;
    }
  }

  /// Get cached image path
  Future<String?> getCachedImagePath(String cacheKey) async {
    try {
      if (_cacheDir == null) await initialize();

      final filePath = path.join(_cacheDir!.path, '$cacheKey.jpg');
      final file = File(filePath);

      if (await file.exists()) {
        return filePath;
      }

      return null;
    } catch (e) {
      debugPrint('Error getting cached image: $e');
      return null;
    }
  }

  /// Cache JSON data
  Future<bool> cacheJson({
    required String cacheKey,
    required Map<String, dynamic> data,
  }) async {
    try {
      if (_cacheDir == null) await initialize();

      // Save to memory cache
      _memoryCache[cacheKey] = data;

      // Save to disk
      final filePath = path.join(_cacheDir!.path, '$cacheKey.json');
      final file = File(filePath);
      await file.writeAsString(jsonEncode(data));

      debugPrint('JSON cached: $cacheKey');
      return true;
    } catch (e) {
      debugPrint('Error caching JSON: $e');
      return false;
    }
  }

  /// Get cached JSON data
  Future<Map<String, dynamic>?> getCachedJson(String cacheKey) async {
    try {
      // Check memory cache first
      if (_memoryCache.containsKey(cacheKey)) {
        return _memoryCache[cacheKey];
      }

      // Check disk cache
      if (_cacheDir == null) await initialize();

      final filePath = path.join(_cacheDir!.path, '$cacheKey.json');
      final file = File(filePath);

      if (await file.exists()) {
        final content = await file.readAsString();
        final data = jsonDecode(content) as Map<String, dynamic>;

        // Store in memory cache
        _memoryCache[cacheKey] = data;

        return data;
      }

      return null;
    } catch (e) {
      debugPrint('Error getting cached JSON: $e');
      return null;
    }
  }

  /// Cache multiple images
  Future<Map<String, String>> cacheMultipleImages({
    required Map<String, String> urlsWithKeys,
    void Function(int current, int total)? onProgress,
  }) async {
    final cachedPaths = <String, String>{};
    int current = 0;
    final total = urlsWithKeys.length;

    for (final entry in urlsWithKeys.entries) {
      current++;
      onProgress?.call(current, total);

      final cached = await cacheImage(
        url: entry.value,
        cacheKey: entry.key,
      );

      if (cached != null) {
        cachedPaths[entry.key] = cached;
      }
    }

    return cachedPaths;
  }

  /// Check if cached
  Future<bool> isCached(String cacheKey) async {
    final imagePath = await getCachedImagePath(cacheKey);
    if (imagePath != null) return true;

    final jsonData = await getCachedJson(cacheKey);
    return jsonData != null;
  }

  /// Clear cache for specific key
  Future<bool> clearCache(String cacheKey) async {
    try {
      if (_cacheDir == null) await initialize();

      // Remove from memory
      _memoryCache.remove(cacheKey);

      // Remove image file
      final imagePath = path.join(_cacheDir!.path, '$cacheKey.jpg');
      final imageFile = File(imagePath);
      if (await imageFile.exists()) {
        await imageFile.delete();
      }

      // Remove JSON file
      final jsonPath = path.join(_cacheDir!.path, '$cacheKey.json');
      final jsonFile = File(jsonPath);
      if (await jsonFile.exists()) {
        await jsonFile.delete();
      }

      debugPrint('Cache cleared: $cacheKey');
      return true;
    } catch (e) {
      debugPrint('Error clearing cache: $e');
      return false;
    }
  }

  /// Clear all cache
  Future<bool> clearAllCache() async {
    try {
      if (_cacheDir == null) await initialize();

      // Clear memory cache
      _memoryCache.clear();

      // Delete cache directory
      if (await _cacheDir!.exists()) {
        await _cacheDir!.delete(recursive: true);
        await _cacheDir!.create(recursive: true);
      }

      debugPrint('All cache cleared');
      return true;
    } catch (e) {
      debugPrint('Error clearing all cache: $e');
      return false;
    }
  }

  /// Get cache size in bytes
  Future<int> getCacheSize() async {
    try {
      if (_cacheDir == null) await initialize();

      int totalSize = 0;

      if (await _cacheDir!.exists()) {
        await for (final entity in _cacheDir!.list(recursive: true)) {
          if (entity is File) {
            totalSize += await entity.length();
          }
        }
      }

      return totalSize;
    } catch (e) {
      debugPrint('Error getting cache size: $e');
      return 0;
    }
  }

  /// Format cache size for display
  String formatCacheSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(2)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }

  /// Get cached files count
  Future<int> getCachedFilesCount() async {
    try {
      if (_cacheDir == null) await initialize();

      int count = 0;

      if (await _cacheDir!.exists()) {
        await for (final entity in _cacheDir!.list()) {
          if (entity is File) {
            count++;
          }
        }
      }

      return count;
    } catch (e) {
      debugPrint('Error getting cached files count: $e');
      return 0;
    }
  }

  /// Clean old cache (older than specified days)
  Future<int> cleanOldCache({int daysToKeep = 30}) async {
    try {
      if (_cacheDir == null) await initialize();

      final cutoffDate = DateTime.now().subtract(Duration(days: daysToKeep));
      int deletedCount = 0;

      if (await _cacheDir!.exists()) {
        await for (final entity in _cacheDir!.list()) {
          if (entity is File) {
            final stat = await entity.stat();
            if (stat.modified.isBefore(cutoffDate)) {
              await entity.delete();
              deletedCount++;
            }
          }
        }
      }

      debugPrint('Cleaned $deletedCount old cache files');
      return deletedCount;
    } catch (e) {
      debugPrint('Error cleaning old cache: $e');
      return 0;
    }
  }

  /// Pre-cache essential data for offline use
  Future<void> preCacheEssentialData({
    required List<String> imageUrls,
    required Map<String, dynamic> essentialJson,
  }) async {
    debugPrint('Pre-caching essential data...');

    // Cache JSON data
    for (final entry in essentialJson.entries) {
      await cacheJson(cacheKey: entry.key, data: entry.value);
    }

    // Cache images
    int index = 0;
    for (final url in imageUrls) {
      await cacheImage(
        url: url,
        cacheKey: 'essential_$index',
      );
      index++;
    }

    debugPrint('Pre-caching completed');
  }
}
