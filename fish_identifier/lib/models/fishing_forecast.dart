/// Model for fishing forecast data
class FishingForecast {
  final String location;
  final double latitude;
  final double longitude;
  final DateTime timestamp;
  final WeatherConditions weather;
  final SolunarData solunar;
  final TideData? tides;
  final FishingRating rating;
  final List<String> recommendations;
  final DateTime generatedAt;

  FishingForecast({
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    required this.weather,
    required this.solunar,
    this.tides,
    required this.rating,
    required this.recommendations,
    required this.generatedAt,
  });

  factory FishingForecast.fromJson(Map<String, dynamic> json) {
    return FishingForecast(
      location: json['location'] as String,
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      timestamp: DateTime.parse(json['timestamp'] as String),
      weather: WeatherConditions.fromJson(
          json['weather'] as Map<String, dynamic>),
      solunar:
          SolunarData.fromJson(json['solunar'] as Map<String, dynamic>),
      tides: json['tides'] != null
          ? TideData.fromJson(json['tides'] as Map<String, dynamic>)
          : null,
      rating: FishingRating.fromJson(json['rating'] as Map<String, dynamic>),
      recommendations: (json['recommendations'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      generatedAt: DateTime.parse(json['generated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': timestamp.toIso8601String(),
      'weather': weather.toJson(),
      'solunar': solunar.toJson(),
      'tides': tides?.toJson(),
      'rating': rating.toJson(),
      'recommendations': recommendations,
      'generated_at': generatedAt.toIso8601String(),
    };
  }
}

/// Weather conditions
class WeatherConditions {
  final double temperature; // Celsius
  final double feelsLike;
  final double humidity; // Percentage
  final double pressure; // hPa
  final double windSpeed; // m/s
  final int windDirection; // degrees
  final double cloudCover; // Percentage
  final String condition; // "Clear", "Clouds", "Rain", etc.
  final String description;
  final double? precipitation; // mm
  final double? waterTemperature; // Celsius (if available)

  WeatherConditions({
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.pressure,
    required this.windSpeed,
    required this.windDirection,
    required this.cloudCover,
    required this.condition,
    required this.description,
    this.precipitation,
    this.waterTemperature,
  });

  factory WeatherConditions.fromJson(Map<String, dynamic> json) {
    return WeatherConditions(
      temperature: (json['temperature'] as num).toDouble(),
      feelsLike: (json['feels_like'] as num).toDouble(),
      humidity: (json['humidity'] as num).toDouble(),
      pressure: (json['pressure'] as num).toDouble(),
      windSpeed: (json['wind_speed'] as num).toDouble(),
      windDirection: json['wind_direction'] as int,
      cloudCover: (json['cloud_cover'] as num).toDouble(),
      condition: json['condition'] as String,
      description: json['description'] as String,
      precipitation: (json['precipitation'] as num?)?.toDouble(),
      waterTemperature: (json['water_temperature'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'temperature': temperature,
      'feels_like': feelsLike,
      'humidity': humidity,
      'pressure': pressure,
      'wind_speed': windSpeed,
      'wind_direction': windDirection,
      'cloud_cover': cloudCover,
      'condition': condition,
      'description': description,
      'precipitation': precipitation,
      'water_temperature': waterTemperature,
    };
  }

  /// Check if weather is favorable for fishing
  bool get isFavorable {
    return windSpeed < 10 && // Not too windy
        (condition == 'Clear' || condition == 'Clouds') && // No rain
        temperature > 5 && // Not too cold
        temperature < 35; // Not too hot
  }
}

/// Solunar data for fishing predictions
class SolunarData {
  final DateTime date;
  final MoonPhase moonPhase;
  final double moonIllumination; // 0.0 to 1.0
  final List<SolunarPeriod> majorPeriods;
  final List<SolunarPeriod> minorPeriods;
  final DateTime? sunrise;
  final DateTime? sunset;
  final DateTime? moonrise;
  final DateTime? moonset;

  SolunarData({
    required this.date,
    required this.moonPhase,
    required this.moonIllumination,
    required this.majorPeriods,
    required this.minorPeriods,
    this.sunrise,
    this.sunset,
    this.moonrise,
    this.moonset,
  });

  factory SolunarData.fromJson(Map<String, dynamic> json) {
    return SolunarData(
      date: DateTime.parse(json['date'] as String),
      moonPhase: MoonPhase.values.firstWhere(
        (e) => e.toString() == 'MoonPhase.${json['moon_phase']}',
      ),
      moonIllumination: (json['moon_illumination'] as num).toDouble(),
      majorPeriods: (json['major_periods'] as List<dynamic>)
          .map((e) => SolunarPeriod.fromJson(e as Map<String, dynamic>))
          .toList(),
      minorPeriods: (json['minor_periods'] as List<dynamic>)
          .map((e) => SolunarPeriod.fromJson(e as Map<String, dynamic>))
          .toList(),
      sunrise: json['sunrise'] != null
          ? DateTime.parse(json['sunrise'] as String)
          : null,
      sunset: json['sunset'] != null
          ? DateTime.parse(json['sunset'] as String)
          : null,
      moonrise: json['moonrise'] != null
          ? DateTime.parse(json['moonrise'] as String)
          : null,
      moonset: json['moonset'] != null
          ? DateTime.parse(json['moonset'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'moon_phase': moonPhase.toString().split('.').last,
      'moon_illumination': moonIllumination,
      'major_periods': majorPeriods.map((p) => p.toJson()).toList(),
      'minor_periods': minorPeriods.map((p) => p.toJson()).toList(),
      'sunrise': sunrise?.toIso8601String(),
      'sunset': sunset?.toIso8601String(),
      'moonrise': moonrise?.toIso8601String(),
      'moonset': moonset?.toIso8601String(),
    };
  }

  /// Check if current time is in a peak period
  bool isInPeakPeriod(DateTime time) {
    return majorPeriods.any((p) => p.isActive(time)) ||
        minorPeriods.any((p) => p.isActive(time));
  }
}

/// Moon phases
enum MoonPhase {
  newMoon,
  waxingCrescent,
  firstQuarter,
  waxingGibbous,
  fullMoon,
  waningGibbous,
  lastQuarter,
  waningCrescent,
}

/// Solunar period (major or minor)
class SolunarPeriod {
  final DateTime startTime;
  final DateTime endTime;
  final bool isMajor;

  SolunarPeriod({
    required this.startTime,
    required this.endTime,
    required this.isMajor,
  });

  factory SolunarPeriod.fromJson(Map<String, dynamic> json) {
    return SolunarPeriod(
      startTime: DateTime.parse(json['start_time'] as String),
      endTime: DateTime.parse(json['end_time'] as String),
      isMajor: json['is_major'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'is_major': isMajor,
    };
  }

  bool isActive(DateTime time) {
    return time.isAfter(startTime) && time.isBefore(endTime);
  }

  Duration get duration => endTime.difference(startTime);
}

/// Tide data
class TideData {
  final List<TideEvent> events;
  final double? currentHeight; // meters

  TideData({
    required this.events,
    this.currentHeight,
  });

  factory TideData.fromJson(Map<String, dynamic> json) {
    return TideData(
      events: (json['events'] as List<dynamic>)
          .map((e) => TideEvent.fromJson(e as Map<String, dynamic>))
          .toList(),
      currentHeight: (json['current_height'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'events': events.map((e) => e.toJson()).toList(),
      'current_height': currentHeight,
    };
  }
}

/// Tide event (high/low tide)
class TideEvent {
  final DateTime time;
  final TideType type;
  final double height; // meters

  TideEvent({
    required this.time,
    required this.type,
    required this.height,
  });

  factory TideEvent.fromJson(Map<String, dynamic> json) {
    return TideEvent(
      time: DateTime.parse(json['time'] as String),
      type: TideType.values.firstWhere(
        (e) => e.toString() == 'TideType.${json['type']}',
      ),
      height: (json['height'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time.toIso8601String(),
      'type': type.toString().split('.').last,
      'height': height,
    };
  }
}

enum TideType { high, low }

/// Fishing rating
class FishingRating {
  final int score; // 0-100
  final String rating; // "Excellent", "Good", "Fair", "Poor"
  final Map<String, int> factors; // Factor contributions

  FishingRating({
    required this.score,
    required this.rating,
    required this.factors,
  });

  factory FishingRating.fromJson(Map<String, dynamic> json) {
    return FishingRating(
      score: json['score'] as int,
      rating: json['rating'] as String,
      factors: Map<String, int>.from(json['factors'] as Map),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'score': score,
      'rating': rating,
      'factors': factors,
    };
  }

  static String getRatingText(int score) {
    if (score >= 80) return 'Excellent';
    if (score >= 60) return 'Good';
    if (score >= 40) return 'Fair';
    return 'Poor';
  }
}
