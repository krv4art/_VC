import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// App configuration
class AppConfig {
  static final AppConfig _instance = AppConfig._internal();
  factory AppConfig() => _instance;
  AppConfig._internal();

  late SharedPreferences _prefs;
  bool _initialized = false;

  bool get isInitialized => _initialized;

  /// Initialize app config
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      _prefs = await SharedPreferences.getInstance();
      _initialized = true;
      debugPrint('✅ AppConfig initialized');
    } catch (e) {
      debugPrint('❌ AppConfig initialization failed: $e');
      rethrow;
    }
  }

  /// Check if onboarding is complete
  bool get isOnboardingComplete {
    return _prefs.getBool('onboarding_complete') ?? false;
  }

  /// Set onboarding complete
  Future<void> setOnboardingComplete() async {
    await _prefs.setBool('onboarding_complete', true);
  }

  /// Reset onboarding (for testing)
  Future<void> resetOnboarding() async {
    await _prefs.setBool('onboarding_complete', false);
  }

  /// Get first launch status
  bool get isFirstLaunch {
    return _prefs.getBool('first_launch') ?? true;
  }

  /// Set first launch complete
  Future<void> setFirstLaunchComplete() async {
    await _prefs.setBool('first_launch', false);
  }
}
