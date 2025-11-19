/// Model for fishing regulations and legal requirements
class FishingRegulation {
  final String id;
  final String speciesName;
  final String scientificName;
  final String region; // State/Province/Country
  final String subRegion; // County/District
  final double? minSize; // in cm
  final double? maxSize; // in cm
  final int? bagLimit; // daily catch limit
  final int? possessionLimit; // total possession limit
  final List<String> allowedGear;
  final List<FishingSeason> seasons;
  final bool licenseRequired;
  final String? licenseType;
  final List<String>? specialRestrictions;
  final DateTime lastUpdated;
  final bool offlineAvailable;
  final String? sourceUrl;

  FishingRegulation({
    required this.id,
    required this.speciesName,
    required this.scientificName,
    required this.region,
    required this.subRegion,
    this.minSize,
    this.maxSize,
    this.bagLimit,
    this.possessionLimit,
    this.allowedGear = const [],
    this.seasons = const [],
    this.licenseRequired = true,
    this.licenseType,
    this.specialRestrictions,
    required this.lastUpdated,
    this.offlineAvailable = false,
    this.sourceUrl,
  });

  factory FishingRegulation.fromJson(Map<String, dynamic> json) {
    return FishingRegulation(
      id: json['id'] as String,
      speciesName: json['species_name'] as String,
      scientificName: json['scientific_name'] as String,
      region: json['region'] as String,
      subRegion: json['sub_region'] as String,
      minSize: json['min_size'] as double?,
      maxSize: json['max_size'] as double?,
      bagLimit: json['bag_limit'] as int?,
      possessionLimit: json['possession_limit'] as int?,
      allowedGear: (json['allowed_gear'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      seasons: (json['seasons'] as List<dynamic>?)
              ?.map((e) => FishingSeason.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      licenseRequired: json['license_required'] as bool? ?? true,
      licenseType: json['license_type'] as String?,
      specialRestrictions: (json['special_restrictions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      lastUpdated: DateTime.parse(json['last_updated'] as String),
      offlineAvailable: json['offline_available'] as bool? ?? false,
      sourceUrl: json['source_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'species_name': speciesName,
      'scientific_name': scientificName,
      'region': region,
      'sub_region': subRegion,
      'min_size': minSize,
      'max_size': maxSize,
      'bag_limit': bagLimit,
      'possession_limit': possessionLimit,
      'allowed_gear': allowedGear,
      'seasons': seasons.map((s) => s.toJson()).toList(),
      'license_required': licenseRequired,
      'license_type': licenseType,
      'special_restrictions': specialRestrictions,
      'last_updated': lastUpdated.toIso8601String(),
      'offline_available': offlineAvailable,
      'source_url': sourceUrl,
    };
  }

  /// Check if a fish meets the size requirements
  bool meetsSize Requirements(double fishLength) {
    if (minSize != null && fishLength < minSize!) return false;
    if (maxSize != null && fishLength > maxSize!) return false;
    return true;
  }

  /// Check if currently in season
  bool isInSeason(DateTime date) {
    if (seasons.isEmpty) return true; // No restrictions
    return seasons.any((season) => season.isInSeason(date));
  }

  /// Get current season status
  String getSeasonStatus(DateTime date) {
    if (seasons.isEmpty) return 'Open year-round';
    if (isInSeason(date)) return 'Currently in season';
    final nextSeason = seasons.firstWhere(
      (s) => s.startDate.isAfter(date),
      orElse: () => seasons.first,
    );
    return 'Closed until ${nextSeason.startDate.month}/${nextSeason.startDate.day}';
  }
}

/// Model for fishing seasons
class FishingSeason {
  final DateTime startDate;
  final DateTime endDate;
  final String? description;

  FishingSeason({
    required this.startDate,
    required this.endDate,
    this.description,
  });

  factory FishingSeason.fromJson(Map<String, dynamic> json) {
    return FishingSeason(
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'description': description,
    };
  }

  bool isInSeason(DateTime date) {
    return date.isAfter(startDate) && date.isBefore(endDate);
  }
}

/// Regulation compliance check result
class RegulationCompliance {
  final bool isCompliant;
  final List<String> violations;
  final List<String> warnings;
  final FishingRegulation regulation;

  RegulationCompliance({
    required this.isCompliant,
    required this.violations,
    required this.warnings,
    required this.regulation,
  });

  bool get canKeep => isCompliant && violations.isEmpty;
}
