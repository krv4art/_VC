import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Application configuration
/// Uses singleton pattern for unified access to settings
class AppConfig {
  static final AppConfig _instance = AppConfig._internal();
  factory AppConfig() => _instance;
  AppConfig._internal();

  bool _isInitialized = false;
  String? _environment;
  bool? _enableDebugMode;
  String? _appVersion;
  int? _maxRatingDialogShows;
  bool? _enableNotifications;
  bool? _enableOfflineMode;

  /// Initialize app configuration from .env file
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await dotenv.load(fileName: 'assets/config/.env');

      _environment = dotenv.env['ENVIRONMENT'] ?? 'development';
      _enableDebugMode =
          dotenv.env['ENABLE_DEBUG_MODE']?.toLowerCase() == 'true';
      _appVersion = dotenv.env['APP_VERSION'] ?? '1.0.0';
      _maxRatingDialogShows =
          int.tryParse(dotenv.env['MAX_RATING_DIALOG_SHOWS'] ?? '3') ?? 3;
      _enableNotifications =
          dotenv.env['ENABLE_NOTIFICATIONS']?.toLowerCase() == 'true';
      _enableOfflineMode =
          dotenv.env['ENABLE_OFFLINE_MODE']?.toLowerCase() == 'true';

      _isInitialized = true;

      if (_enableDebugMode == true) {
        debugPrint('AppConfig initialized with environment: $_environment');
      }
    } catch (e) {
      debugPrint('Error initializing AppConfig: $e');
      // Set default values in case of error
      _environment = 'development';
      _enableDebugMode = true;
      _appVersion = '1.0.0';
      _maxRatingDialogShows = 3;
      _enableNotifications = true;
      _enableOfflineMode = true;
      _isInitialized = true;
    }
  }

  /// Check if configuration is initialized
  bool get isInitialized => _isInitialized;

  /// Current environment (development, production, etc.)
  String get environment => _environment ?? 'development';

  /// Debug mode enabled
  bool get enableDebugMode => _enableDebugMode ?? true;

  /// App version
  String get appVersion => _appVersion ?? '1.0.0';

  /// Maximum number of rating dialog shows
  int get maxRatingDialogShows => _maxRatingDialogShows ?? 3;

  /// Notifications enabled
  bool get enableNotifications => _enableNotifications ?? true;

  /// Offline mode enabled
  bool get enableOfflineMode => _enableOfflineMode ?? true;

  // App metadata
  static const String appName = 'Plant Identifier';

  // Default settings
  static const String defaultLanguage = 'en';
  static const String defaultTheme = 'green_nature';

  // API settings
  static const Duration apiTimeout = Duration(seconds: 30);
  static const int maxRetries = 3;

  // Database settings
  static const int maxHistoryItems = 100;

  /// Get Supabase URL from environment
  String getSupabaseUrl() {
    return dotenv.env['SUPABASE_URL'] ??
        'https://yerbryysrnaraqmbhqdm.supabase.co';
  }

  /// Get Supabase anon key from environment
  String getSupabaseAnonKey() {
    return dotenv.env['SUPABASE_ANON_KEY'] ?? '';
  }

  /// Get value from .env by key with default value
  String? getEnvValue(String key, {String? defaultValue}) {
    return dotenv.env[key] ?? defaultValue;
  }

  /// Get boolean value from .env by key
  bool getEnvBool(String key, {bool defaultValue = false}) {
    final value = dotenv.env[key]?.toLowerCase();
    return value == 'true' || value == '1' || value == 'yes';
  }

  /// Get integer value from .env by key
  int getEnvInt(String key, {int defaultValue = 0}) {
    return int.tryParse(dotenv.env[key] ?? '') ?? defaultValue;
  }

  /// Get double value from .env by key
  double getEnvDouble(String key, {double defaultValue = 0.0}) {
    return double.tryParse(dotenv.env[key] ?? '') ?? defaultValue;
  }
}
