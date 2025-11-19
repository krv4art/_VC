import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import '../models/fishing_regulation.dart';
import 'database_service.dart';

/// Service for fishing regulations and compliance
class RegulationsService {
  static final RegulationsService instance = RegulationsService._internal();

  factory RegulationsService() => instance;

  RegulationsService._internal();

  // Cache for loaded regulations
  final Map<String, List<FishingRegulation>> _cache = {};

  /// Get regulations for a specific species and location
  Future<FishingRegulation?> getRegulation({
    required String speciesName,
    required String region,
    String? subRegion,
  }) async {
    try {
      // Try cache first
      final cacheKey = '$speciesName-$region-${subRegion ?? "all"}';
      if (_cache.containsKey(cacheKey)) {
        return _cache[cacheKey]?.firstWhere(
          (r) => r.speciesName.toLowerCase() == speciesName.toLowerCase(),
          orElse: () => _cache[cacheKey]!.first,
        );
      }

      // Try local database
      final db = await DatabaseService.instance.database;
      final results = await db.query(
        'regulations',
        where: 'species_name = ? AND region = ?',
        whereArgs: [speciesName, region],
        limit: 1,
      );

      if (results.isNotEmpty) {
        return _regulationFromMap(results.first);
      }

      // Fetch from API (if available)
      // For now, return null and let apps handle offline gracefully
      return null;
    } catch (e) {
      print('Error getting regulation: $e');
      return null;
    }
  }

  /// Get all regulations for a region
  Future<List<FishingRegulation>> getRegulationsForRegion(String region) async {
    // Check cache
    if (_cache.containsKey(region)) {
      return _cache[region]!;
    }

    try {
      final db = await DatabaseService.instance.database;
      final results = await db.query(
        'regulations',
        where: 'region = ?',
        whereArgs: [region],
        orderBy: 'species_name ASC',
      );

      final regulations = results.map(_regulationFromMap).toList();
      _cache[region] = regulations;

      return regulations;
    } catch (e) {
      print('Error getting regulations for region: $e');
      return [];
    }
  }

  /// Check if a fish meets regulation requirements
  Future<RegulationCompliance> checkCompliance({
    required String speciesName,
    required double fishLength, // in cm
    required String region,
    String? subRegion,
    DateTime? catchDate,
  }) async {
    final regulation = await getRegulation(
      speciesName: speciesName,
      region: region,
      subRegion: subRegion,
    );

    if (regulation == null) {
      return RegulationCompliance(
        isCompliant: true,
        violations: ['No regulations found for this species in this region'],
        warnings: ['Regulations data not available - check local laws'],
        regulation: _createDefaultRegulation(speciesName, region),
      );
    }

    final violations = <String>[];
    final warnings = <String>[];

    // Check size requirements
    if (!regulation.meetsSizeRequirements(fishLength)) {
      if (regulation.minSize != null && fishLength < regulation.minSize!) {
        violations.add(
          'Fish is too small: ${fishLength.toStringAsFixed(1)}cm (minimum: ${regulation.minSize}cm)',
        );
      }
      if (regulation.maxSize != null && fishLength > regulation.maxSize!) {
        violations.add(
          'Fish exceeds maximum size: ${fishLength.toStringAsFixed(1)}cm (maximum: ${regulation.maxSize}cm)',
        );
      }
    }

    // Check season
    final date = catchDate ?? DateTime.now();
    if (!regulation.isInSeason(date)) {
      violations.add('Out of season: ${regulation.getSeasonStatus(date)}');
    }

    // License warning
    if (regulation.licenseRequired) {
      warnings.add(
        'License required${regulation.licenseType != null ? ': ${regulation.licenseType}' : ''}',
      );
    }

    // Bag limit warning
    if (regulation.bagLimit != null) {
      warnings.add('Daily bag limit: ${regulation.bagLimit} fish');
    }

    return RegulationCompliance(
      isCompliant: violations.isEmpty,
      violations: violations,
      warnings: warnings,
      regulation: regulation,
    );
  }

  /// Save regulation to local database
  Future<void> saveRegulation(FishingRegulation regulation) async {
    try {
      final db = await DatabaseService.instance.database;
      await db.insert(
        'regulations',
        _regulationToMap(regulation),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Error saving regulation: $e');
    }
  }

  /// Bulk import regulations from JSON
  Future<void> importRegulations(List<FishingRegulation> regulations) async {
    final db = await DatabaseService.instance.database;
    final batch = db.batch();

    for (final regulation in regulations) {
      batch.insert(
        'regulations',
        _regulationToMap(regulation),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
    _cache.clear(); // Clear cache after import
  }

  /// Search regulations
  Future<List<FishingRegulation>> searchRegulations(String query) async {
    try {
      final db = await DatabaseService.instance.database;
      final results = await db.query(
        'regulations',
        where: 'species_name LIKE ? OR scientific_name LIKE ?',
        whereArgs: ['%$query%', '%$query%'],
        orderBy: 'species_name ASC',
        limit: 50,
      );

      return results.map(_regulationFromMap).toList();
    } catch (e) {
      print('Error searching regulations: $e');
      return [];
    }
  }

  /// Convert database map to FishingRegulation
  FishingRegulation _regulationFromMap(Map<String, dynamic> map) {
    return FishingRegulation(
      id: map['id'] as String,
      speciesName: map['species_name'] as String,
      scientificName: map['scientific_name'] as String? ?? '',
      region: map['region'] as String,
      subRegion: map['sub_region'] as String? ?? '',
      minSize: map['min_size'] as double?,
      maxSize: map['max_size'] as double?,
      bagLimit: map['bag_limit'] as int?,
      possessionLimit: map['possession_limit'] as int?,
      allowedGear: map['allowed_gear'] != null
          ? (jsonDecode(map['allowed_gear'] as String) as List<dynamic>)
              .cast<String>()
          : [],
      seasons: map['seasons'] != null
          ? (jsonDecode(map['seasons'] as String) as List<dynamic>)
              .map((e) => FishingSeason.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
      licenseRequired: (map['license_required'] as int) == 1,
      licenseType: map['license_type'] as String?,
      specialRestrictions: map['special_restrictions'] != null
          ? (jsonDecode(map['special_restrictions'] as String) as List<dynamic>)
              .cast<String>()
          : null,
      lastUpdated: DateTime.parse(map['last_updated'] as String),
      offlineAvailable: (map['offline_available'] as int? ?? 0) == 1,
      sourceUrl: map['source_url'] as String?,
    );
  }

  /// Convert FishingRegulation to database map
  Map<String, dynamic> _regulationToMap(FishingRegulation regulation) {
    return {
      'id': regulation.id,
      'species_name': regulation.speciesName,
      'scientific_name': regulation.scientificName,
      'region': regulation.region,
      'sub_region': regulation.subRegion,
      'min_size': regulation.minSize,
      'max_size': regulation.maxSize,
      'bag_limit': regulation.bagLimit,
      'possession_limit': regulation.possessionLimit,
      'allowed_gear': jsonEncode(regulation.allowedGear),
      'seasons': jsonEncode(regulation.seasons.map((s) => s.toJson()).toList()),
      'license_required': regulation.licenseRequired ? 1 : 0,
      'license_type': regulation.licenseType,
      'special_restrictions': regulation.specialRestrictions != null
          ? jsonEncode(regulation.specialRestrictions)
          : null,
      'last_updated': regulation.lastUpdated.toIso8601String(),
      'offline_available': regulation.offlineAvailable ? 1 : 0,
      'source_url': regulation.sourceUrl,
    };
  }

  /// Create default regulation when none found
  FishingRegulation _createDefaultRegulation(String speciesName, String region) {
    return FishingRegulation(
      id: 'default-${speciesName.toLowerCase().replaceAll(' ', '-')}',
      speciesName: speciesName,
      scientificName: '',
      region: region,
      subRegion: '',
      lastUpdated: DateTime.now(),
    );
  }

  /// Clear cache
  void clearCache() {
    _cache.clear();
  }
}
