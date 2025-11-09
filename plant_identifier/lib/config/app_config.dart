import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Application configuration
class AppConfig {
  static final AppConfig _instance = AppConfig._internal();
  factory AppConfig() => _instance;
  AppConfig._internal();

  SharedPreferences? _prefs;

  /// Initialize app configuration
  Future<void> initialize() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      debugPrint('App configuration initialized');
    } catch (e) {
      debugPrint('Error initializing app configuration: $e');
    }
  }

  /// Get shared preferences instance
  SharedPreferences? get prefs => _prefs;

  // App metadata
  static const String appName = 'Plant Identifier';
  static const String appVersion = '1.0.0';

  // Default settings
  static const String defaultLanguage = 'en';
  static const String defaultTheme = 'green_nature';

  // Feature flags
  static const bool enableDarkMode = true;
  static const bool enableOfflineMode = true;
  static const bool enableNotifications = true;

  // API settings
  static const Duration apiTimeout = Duration(seconds: 30);
  static const int maxRetries = 3;

  // Database settings
  static const int maxHistoryItems = 100;
}
