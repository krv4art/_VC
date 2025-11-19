import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/fishing_forecast.dart';
import 'solunar_service.dart';

/// Service for weather data and fishing forecasts
class WeatherService {
  static final WeatherService instance = WeatherService._internal();

  factory WeatherService() => instance;

  WeatherService._internal();

  // OpenWeatherMap API (free tier)
  static const String _apiKey = 'YOUR_OPENWEATHERMAP_API_KEY'; // TODO: Move to .env
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';

  /// Get fishing forecast for location
  Future<FishingForecast> getFishingForecast({
    required double latitude,
    required longitude,
    String? locationName,
  }) async {
    try {
      // Get current weather
      final weather = await _getCurrentWeather(latitude, longitude);

      // Get solunar data
      final solunar = await SolunarService.instance
          .getSolunarData(DateTime.now(), latitude, longitude);

      // Calculate fishing rating
      final rating = _calculateFishingRating(weather, solunar);

      // Generate recommendations
      final recommendations = _generateRecommendations(weather, solunar, rating);

      return FishingForecast(
        location: locationName ?? '${latitude.toStringAsFixed(2)}, ${longitude.toStringAsFixed(2)}',
        latitude: latitude,
        longitude: longitude,
        timestamp: DateTime.now(),
        weather: weather,
        solunar: solunar,
        tides: null, // TODO: Add tide API integration
        rating: rating,
        recommendations: recommendations,
        generatedAt: DateTime.now(),
      );
    } catch (e) {
      throw Exception('Failed to get fishing forecast: $e');
    }
  }

  /// Get current weather conditions
  Future<WeatherConditions> _getCurrentWeather(
    double latitude,
    double longitude,
  ) async {
    final url = Uri.parse(
      '$_baseUrl/weather?lat=$latitude&lon=$longitude&appid=$_apiKey&units=metric',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;

      return WeatherConditions(
        temperature: (data['main']['temp'] as num).toDouble(),
        feelsLike: (data['main']['feels_like'] as num).toDouble(),
        humidity: (data['main']['humidity'] as num).toDouble(),
        pressure: (data['main']['pressure'] as num).toDouble(),
        windSpeed: (data['wind']['speed'] as num).toDouble(),
        windDirection: data['wind']['deg'] as int,
        cloudCover: (data['clouds']['all'] as num).toDouble(),
        condition: data['weather'][0]['main'] as String,
        description: data['weather'][0]['description'] as String,
        precipitation: data['rain'] != null
            ? (data['rain']['1h'] as num?)?.toDouble()
            : null,
      );
    } else {
      throw Exception('Failed to fetch weather data: ${response.statusCode}');
    }
  }

  /// Get 7-day weather forecast
  Future<List<FishingForecast>> getWeeklyForecast({
    required double latitude,
    required double longitude,
    String? locationName,
  }) async {
    final url = Uri.parse(
      '$_baseUrl/forecast?lat=$latitude&lon=$longitude&appid=$_apiKey&units=metric',
    );

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch forecast data: ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final forecasts = <FishingForecast>[];

    // Group by day and take one forecast per day
    final dailyForecasts = <String, Map<String, dynamic>>{};

    for (final item in data['list'] as List<dynamic>) {
      final dt = DateTime.fromMillisecondsSinceEpoch(
        (item['dt'] as int) * 1000,
      );
      final dateKey = '${dt.year}-${dt.month}-${dt.day}';

      // Take midday forecast for each day
      if (dt.hour == 12 || !dailyForecasts.containsKey(dateKey)) {
        dailyForecasts[dateKey] = item as Map<String, dynamic>;
      }
    }

    // Convert to FishingForecast objects
    for (final entry in dailyForecasts.entries.take(7)) {
      final item = entry.value;
      final dt = DateTime.fromMillisecondsSinceEpoch(
        (item['dt'] as int) * 1000,
      );

      final weather = WeatherConditions(
        temperature: (item['main']['temp'] as num).toDouble(),
        feelsLike: (item['main']['feels_like'] as num).toDouble(),
        humidity: (item['main']['humidity'] as num).toDouble(),
        pressure: (item['main']['pressure'] as num).toDouble(),
        windSpeed: (item['wind']['speed'] as num).toDouble(),
        windDirection: item['wind']['deg'] as int,
        cloudCover: (item['clouds']['all'] as num).toDouble(),
        condition: item['weather'][0]['main'] as String,
        description: item['weather'][0]['description'] as String,
        precipitation: item['rain'] != null
            ? (item['rain']['3h'] as num?)?.toDouble()
            : null,
      );

      final solunar =
          await SolunarService.instance.getSolunarData(dt, latitude, longitude);

      final rating = _calculateFishingRating(weather, solunar);
      final recommendations = _generateRecommendations(weather, solunar, rating);

      forecasts.add(FishingForecast(
        location: locationName ?? '${latitude.toStringAsFixed(2)}, ${longitude.toStringAsFixed(2)}',
        latitude: latitude,
        longitude: longitude,
        timestamp: dt,
        weather: weather,
        solunar: solunar,
        tides: null,
        rating: rating,
        recommendations: recommendations,
        generatedAt: DateTime.now(),
      ));
    }

    return forecasts;
  }

  /// Calculate fishing rating based on weather and solunar data
  FishingRating _calculateFishingRating(
    WeatherConditions weather,
    SolunarData solunar,
  ) {
    int score = 50; // Start at neutral
    final factors = <String, int>{};

    // Weather factors
    if (weather.isFavorable) {
      score += 15;
      factors['weather'] = 15;
    } else {
      score -= 10;
      factors['weather'] = -10;
    }

    // Temperature (optimal: 15-25°C)
    if (weather.temperature >= 15 && weather.temperature <= 25) {
      score += 10;
      factors['temperature'] = 10;
    } else if (weather.temperature < 5 || weather.temperature > 35) {
      score -= 15;
      factors['temperature'] = -15;
    }

    // Pressure (rising pressure is good)
    if (weather.pressure > 1015) {
      score += 10;
      factors['pressure'] = 10;
    } else if (weather.pressure < 1000) {
      score -= 10;
      factors['pressure'] = -10;
    }

    // Wind (light wind is good)
    if (weather.windSpeed >= 2 && weather.windSpeed <= 5) {
      score += 5;
      factors['wind'] = 5;
    } else if (weather.windSpeed > 15) {
      score -= 15;
      factors['wind'] = -15;
    }

    // Solunar factors
    final now = DateTime.now();
    if (solunar.isInPeakPeriod(now)) {
      score += 20;
      factors['solunar'] = 20;
    }

    // Moon phase (full and new moon are best)
    if (solunar.moonPhase == MoonPhase.fullMoon ||
        solunar.moonPhase == MoonPhase.newMoon) {
      score += 10;
      factors['moon_phase'] = 10;
    }

    // Clamp score between 0-100
    score = score.clamp(0, 100);

    return FishingRating(
      score: score,
      rating: FishingRating.getRatingText(score),
      factors: factors,
    );
  }

  /// Generate fishing recommendations
  List<String> _generateRecommendations(
    WeatherConditions weather,
    SolunarData solunar,
    FishingRating rating,
  ) {
    final recommendations = <String>[];

    // Time recommendations
    if (solunar.majorPeriods.isNotEmpty) {
      final nextMajor = solunar.majorPeriods.first;
      recommendations.add(
        'Best fishing time: ${nextMajor.startTime.hour}:${nextMajor.startTime.minute.toString().padLeft(2, '0')} - ${nextMajor.endTime.hour}:${nextMajor.endTime.minute.toString().padLeft(2, '0')}',
      );
    }

    // Weather recommendations
    if (weather.condition == 'Clouds') {
      recommendations.add('Overcast conditions - great for fishing!');
    } else if (weather.condition == 'Clear') {
      recommendations.add('Clear skies - fish deeper waters');
    } else if (weather.condition == 'Rain') {
      recommendations.add('Light rain can improve fishing, but be safe');
    }

    // Wind recommendations
    if (weather.windSpeed >= 2 && weather.windSpeed <= 5) {
      recommendations.add('Light wind - perfect conditions');
    } else if (weather.windSpeed > 15) {
      recommendations.add('Strong winds - seek sheltered areas');
    }

    // Pressure recommendations
    if (weather.pressure > 1015) {
      recommendations.add('Rising pressure - fish are active');
    } else if (weather.pressure < 1000) {
      recommendations.add('Low pressure - try surface lures');
    }

    // Moon phase recommendations
    switch (solunar.moonPhase) {
      case MoonPhase.fullMoon:
        recommendations.add('Full moon - excellent night fishing');
        break;
      case MoonPhase.newMoon:
        recommendations.add('New moon - fish are extra active');
        break;
      case MoonPhase.firstQuarter:
      case MoonPhase.lastQuarter:
        recommendations.add('Quarter moon - moderate activity');
        break;
      default:
        break;
    }

    // General tip
    if (rating.score >= 80) {
      recommendations.add('🎣 Exceptional conditions - don\'t miss this!');
    } else if (rating.score >= 60) {
      recommendations.add('👍 Good fishing expected');
    } else if (rating.score < 40) {
      recommendations.add('🤔 Challenging conditions - try proven spots');
    }

    return recommendations;
  }
}
