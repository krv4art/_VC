import 'package:flutter/foundation.dart';
import '../models/fishing_forecast.dart';
import '../services/weather_service.dart';
import '../services/database_service.dart';

/// Provider for weather and fishing forecasts
class ForecastProvider extends ChangeNotifier {
  FishingForecast? _currentForecast;
  List<FishingForecast>? _weeklyForecast;
  bool _isLoading = false;
  String? _error;
  DateTime? _lastUpdate;

  // Getters
  FishingForecast? get currentForecast => _currentForecast;
  List<FishingForecast>? get weeklyForecast => _weeklyForecast;
  bool get isLoading => _isLoading;
  String? get error => _error;
  DateTime? get lastUpdate => _lastUpdate;

  bool get hasData => _currentForecast != null;
  bool get needsUpdate {
    if (_lastUpdate == null) return true;
    return DateTime.now().difference(_lastUpdate!).inHours > 1;
  }

  /// Load forecast for current location
  Future<void> loadForecast({
    required double latitude,
    required double longitude,
    String? locationName,
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && !needsUpdate && hasData) {
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Try to load from cache first
      if (!forceRefresh) {
        final cachedForecast = await _loadFromCache(latitude, longitude);
        if (cachedForecast != null) {
          _currentForecast = cachedForecast;
          _isLoading = false;
          _lastUpdate = DateTime.now();
          notifyListeners();
          return;
        }
      }

      // Fetch from API
      _currentForecast = await WeatherService.instance.getFishingForecast(
        latitude: latitude,
        longitude: longitude,
        locationName: locationName,
      );

      _lastUpdate = DateTime.now();

      // Cache the forecast
      await _saveToCache(_currentForecast!);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      debugPrint('Error loading forecast: $e');
    }
  }

  /// Load 7-day forecast
  Future<void> loadWeeklyForecast({
    required double latitude,
    required double longitude,
    String? locationName,
  }) async {
    try {
      _weeklyForecast = await WeatherService.instance.getWeeklyForecast(
        latitude: latitude,
        longitude: longitude,
        locationName: locationName,
      );
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading weekly forecast: $e');
    }
  }

  /// Load forecast from cache
  Future<FishingForecast?> _loadFromCache(
    double latitude,
    double longitude,
  ) async {
    try {
      final db = await DatabaseService.instance.database;
      final results = await db.query(
        'weather_cache',
        where: 'latitude = ? AND longitude = ?',
        whereArgs: [latitude, longitude],
        orderBy: 'cached_at DESC',
        limit: 1,
      );

      if (results.isEmpty) return null;

      final cached = results.first;
      final expiresAt = DateTime.parse(cached['expires_at'] as String);

      // Check if cache is still valid
      if (DateTime.now().isAfter(expiresAt)) {
        return null;
      }

      final forecastData = cached['forecast_data'] as String;
      // Parse JSON and return forecast
      // Note: You'll need to implement fromJson in FishingForecast
      // For now, return null to trigger API fetch
      return null;
    } catch (e) {
      debugPrint('Error loading from cache: $e');
      return null;
    }
  }

  /// Save forecast to cache
  Future<void> _saveToCache(FishingForecast forecast) async {
    try {
      final db = await DatabaseService.instance.database;
      await db.insert(
        'weather_cache',
        {
          'location': forecast.location,
          'latitude': forecast.latitude,
          'longitude': forecast.longitude,
          'forecast_data': forecast.toJson().toString(),
          'cached_at': DateTime.now().toIso8601String(),
          'expires_at': DateTime.now()
              .add(const Duration(hours: 2))
              .toIso8601String(),
        },
      );
    } catch (e) {
      debugPrint('Error saving to cache: $e');
    }
  }

  /// Clear cache
  Future<void> clearCache() async {
    try {
      final db = await DatabaseService.instance.database;
      await db.delete('weather_cache');
      _currentForecast = null;
      _weeklyForecast = null;
      _lastUpdate = null;
      notifyListeners();
    } catch (e) {
      debugPrint('Error clearing cache: $e');
    }
  }

  /// Get fishing rating color
  Color getRatingColor(int score) {
    if (score >= 80) return const Color(0xFF4CAF50); // Green
    if (score >= 60) return const Color(0xFF8BC34A); // Light green
    if (score >= 40) return const Color(0xFFFFC107); // Amber
    return const Color(0xFFF44336); // Red
  }

  /// Get rating icon
  String getRatingIcon(int score) {
    if (score >= 80) return '🎣';
    if (score >= 60) return '👍';
    if (score >= 40) return '🤔';
    return '⚠️';
  }
}
