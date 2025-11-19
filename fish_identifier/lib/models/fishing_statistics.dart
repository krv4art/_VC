/// Model for fishing statistics and analytics
class FishingStatistics {
  final String userId;
  final DateTime periodStart;
  final DateTime periodEnd;
  final OverallStats overall;
  final List<SpeciesStats> bySpecies;
  final List<LocationStats> byLocation;
  final List<TimeStats> byTime;
  final WeatherCorrelation weatherCorrelation;
  final PersonalRecords records;

  FishingStatistics({
    required this.userId,
    required this.periodStart,
    required this.periodEnd,
    required this.overall,
    required this.bySpecies,
    required this.byLocation,
    required this.byTime,
    required this.weatherCorrelation,
    required this.records,
  });

  factory FishingStatistics.fromJson(Map<String, dynamic> json) {
    return FishingStatistics(
      userId: json['user_id'] as String,
      periodStart: DateTime.parse(json['period_start'] as String),
      periodEnd: DateTime.parse(json['period_end'] as String),
      overall: OverallStats.fromJson(json['overall'] as Map<String, dynamic>),
      bySpecies: (json['by_species'] as List<dynamic>)
          .map((e) => SpeciesStats.fromJson(e as Map<String, dynamic>))
          .toList(),
      byLocation: (json['by_location'] as List<dynamic>)
          .map((e) => LocationStats.fromJson(e as Map<String, dynamic>))
          .toList(),
      byTime: (json['by_time'] as List<dynamic>)
          .map((e) => TimeStats.fromJson(e as Map<String, dynamic>))
          .toList(),
      weatherCorrelation: WeatherCorrelation.fromJson(
          json['weather_correlation'] as Map<String, dynamic>),
      records:
          PersonalRecords.fromJson(json['records'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'period_start': periodStart.toIso8601String(),
      'period_end': periodEnd.toIso8601String(),
      'overall': overall.toJson(),
      'by_species': bySpecies.map((s) => s.toJson()).toList(),
      'by_location': byLocation.map((l) => l.toJson()).toList(),
      'by_time': byTime.map((t) => t.toJson()).toList(),
      'weather_correlation': weatherCorrelation.toJson(),
      'records': records.toJson(),
    };
  }
}

/// Overall statistics
class OverallStats {
  final int totalCatches;
  final int uniqueSpecies;
  final int uniqueLocations;
  final double averageLength; // cm
  final double averageWeight; // kg
  final double totalWeight; // kg
  final int daysActive;
  final double catchesPerDay;

  OverallStats({
    required this.totalCatches,
    required this.uniqueSpecies,
    required this.uniqueLocations,
    required this.averageLength,
    required this.averageWeight,
    required this.totalWeight,
    required this.daysActive,
    required this.catchesPerDay,
  });

  factory OverallStats.fromJson(Map<String, dynamic> json) {
    return OverallStats(
      totalCatches: json['total_catches'] as int,
      uniqueSpecies: json['unique_species'] as int,
      uniqueLocations: json['unique_locations'] as int,
      averageLength: (json['average_length'] as num).toDouble(),
      averageWeight: (json['average_weight'] as num).toDouble(),
      totalWeight: (json['total_weight'] as num).toDouble(),
      daysActive: json['days_active'] as int,
      catchesPerDay: (json['catches_per_day'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_catches': totalCatches,
      'unique_species': uniqueSpecies,
      'unique_locations': uniqueLocations,
      'average_length': averageLength,
      'average_weight': averageWeight,
      'total_weight': totalWeight,
      'days_active': daysActive,
      'catches_per_day': catchesPerDay,
    };
  }
}

/// Statistics by species
class SpeciesStats {
  final String speciesName;
  final int count;
  final double percentage;
  final double averageLength;
  final double averageWeight;
  final double maxLength;
  final double maxWeight;

  SpeciesStats({
    required this.speciesName,
    required this.count,
    required this.percentage,
    required this.averageLength,
    required this.averageWeight,
    required this.maxLength,
    required this.maxWeight,
  });

  factory SpeciesStats.fromJson(Map<String, dynamic> json) {
    return SpeciesStats(
      speciesName: json['species_name'] as String,
      count: json['count'] as int,
      percentage: (json['percentage'] as num).toDouble(),
      averageLength: (json['average_length'] as num).toDouble(),
      averageWeight: (json['average_weight'] as num).toDouble(),
      maxLength: (json['max_length'] as num).toDouble(),
      maxWeight: (json['max_weight'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'species_name': speciesName,
      'count': count,
      'percentage': percentage,
      'average_length': averageLength,
      'average_weight': averageWeight,
      'max_length': maxLength,
      'max_weight': maxWeight,
    };
  }
}

/// Statistics by location
class LocationStats {
  final String locationName;
  final double latitude;
  final double longitude;
  final int count;
  final int uniqueSpecies;
  final double successRate; // 0.0 to 1.0

  LocationStats({
    required this.locationName,
    required this.latitude,
    required this.longitude,
    required this.count,
    required this.uniqueSpecies,
    required this.successRate,
  });

  factory LocationStats.fromJson(Map<String, dynamic> json) {
    return LocationStats(
      locationName: json['location_name'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      count: json['count'] as int,
      uniqueSpecies: json['unique_species'] as int,
      successRate: (json['success_rate'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'location_name': locationName,
      'latitude': latitude,
      'longitude': longitude,
      'count': count,
      'unique_species': uniqueSpecies,
      'success_rate': successRate,
    };
  }
}

/// Statistics by time period
class TimeStats {
  final DateTime date;
  final int catches;
  final int species;

  TimeStats({
    required this.date,
    required this.catches,
    required this.species,
  });

  factory TimeStats.fromJson(Map<String, dynamic> json) {
    return TimeStats(
      date: DateTime.parse(json['date'] as String),
      catches: json['catches'] as int,
      species: json['species'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'catches': catches,
      'species': species,
    };
  }
}

/// Weather correlation data
class WeatherCorrelation {
  final Map<String, int> byCondition; // "Clear" -> count
  final Map<String, int> byTemperatureRange; // "10-20°C" -> count
  final Map<String, int> byPressureRange; // "990-1010 hPa" -> count
  final String mostSuccessfulCondition;
  final String bestTemperatureRange;
  final String bestPressureRange;

  WeatherCorrelation({
    required this.byCondition,
    required this.byTemperatureRange,
    required this.byPressureRange,
    required this.mostSuccessfulCondition,
    required this.bestTemperatureRange,
    required this.bestPressureRange,
  });

  factory WeatherCorrelation.fromJson(Map<String, dynamic> json) {
    return WeatherCorrelation(
      byCondition: Map<String, int>.from(json['by_condition'] as Map),
      byTemperatureRange:
          Map<String, int>.from(json['by_temperature_range'] as Map),
      byPressureRange:
          Map<String, int>.from(json['by_pressure_range'] as Map),
      mostSuccessfulCondition: json['most_successful_condition'] as String,
      bestTemperatureRange: json['best_temperature_range'] as String,
      bestPressureRange: json['best_pressure_range'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'by_condition': byCondition,
      'by_temperature_range': byTemperatureRange,
      'by_pressure_range': byPressureRange,
      'most_successful_condition': mostSuccessfulCondition,
      'best_temperature_range': bestTemperatureRange,
      'best_pressure_range': bestPressureRange,
    };
  }
}

/// Personal records
class PersonalRecords {
  final FishRecord? longestFish;
  final FishRecord? heaviestFish;
  final FishRecord? rarest Fish;
  final int biggestDayCount;
  final DateTime? biggestDayDate;
  final int currentStreak;
  final int longestStreak;

  PersonalRecords({
    this.longestFish,
    this.heaviestFish,
    this.rarestFish,
    required this.biggestDayCount,
    this.biggestDayDate,
    required this.currentStreak,
    required this.longestStreak,
  });

  factory PersonalRecords.fromJson(Map<String, dynamic> json) {
    return PersonalRecords(
      longestFish: json['longest_fish'] != null
          ? FishRecord.fromJson(json['longest_fish'] as Map<String, dynamic>)
          : null,
      heaviestFish: json['heaviest_fish'] != null
          ? FishRecord.fromJson(json['heaviest_fish'] as Map<String, dynamic>)
          : null,
      rarestFish: json['rarest_fish'] != null
          ? FishRecord.fromJson(json['rarest_fish'] as Map<String, dynamic>)
          : null,
      biggestDayCount: json['biggest_day_count'] as int,
      biggestDayDate: json['biggest_day_date'] != null
          ? DateTime.parse(json['biggest_day_date'] as String)
          : null,
      currentStreak: json['current_streak'] as int,
      longestStreak: json['longest_streak'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'longest_fish': longestFish?.toJson(),
      'heaviest_fish': heaviestFish?.toJson(),
      'rarest_fish': rarestFish?.toJson(),
      'biggest_day_count': biggestDayCount,
      'biggest_day_date': biggestDayDate?.toIso8601String(),
      'current_streak': currentStreak,
      'longest_streak': longestStreak,
    };
  }
}

/// Fish record
class FishRecord {
  final String speciesName;
  final double length;
  final double weight;
  final DateTime caughtAt;
  final String? location;
  final String? imageUrl;

  FishRecord({
    required this.speciesName,
    required this.length,
    required this.weight,
    required this.caughtAt,
    this.location,
    this.imageUrl,
  });

  factory FishRecord.fromJson(Map<String, dynamic> json) {
    return FishRecord(
      speciesName: json['species_name'] as String,
      length: (json['length'] as num).toDouble(),
      weight: (json['weight'] as num).toDouble(),
      caughtAt: DateTime.parse(json['caught_at'] as String),
      location: json['location'] as String?,
      imageUrl: json['image_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'species_name': speciesName,
      'length': length,
      'weight': weight,
      'caught_at': caughtAt.toIso8601String(),
      'location': location,
      'image_url': imageUrl,
    };
  }
}
