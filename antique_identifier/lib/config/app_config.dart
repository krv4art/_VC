import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';

/// Класс для управления конфигурацией приложения
/// Использует синглтон паттерн для единого доступа к настройкам
class AppConfig {
  factory AppConfig() => _instance;
  AppConfig._();

  static final AppConfig _instance = AppConfig._();

  bool _isInitialized = false;
  String? _environment;
  bool? _enableDebugMode;
  String? _appVersion;
  int? _maxRatingDialogShows;
  String? _googlePlayPackageId;
  int? _freeIdentificationsPerDay;

  /// Инициализация конфигурации из .env файла
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
      _googlePlayPackageId = dotenv.env['GOOGLE_PLAY_PACKAGE_ID'] ??
          'com.example.antique_identifier';
      _freeIdentificationsPerDay = getEnvInt('FREE_IDENTIFICATIONS_PER_DAY', defaultValue: 5);

      _isInitialized = true;

      if (_enableDebugMode == true) {
        debugPrint('AppConfig initialized with environment: $_environment');
      }
    } catch (e) {
      debugPrint('Error initializing AppConfig: $e');
      // Устанавливаем значения по умолчанию в случае ошибки
      _environment = 'development';
      _enableDebugMode = kDebugMode;
      _appVersion = '1.0.0';
      _maxRatingDialogShows = 3;
      _googlePlayPackageId = 'com.example.antique_identifier';
      _freeIdentificationsPerDay = 5;
      _isInitialized = true;
    }
  }

  /// Проверка, что конфигурация инициализирована
  bool get isInitialized => _isInitialized;

  /// Текущее окружение (development, production, etc.)
  String get environment => _environment ?? 'development';

  /// Включен ли режим отладки
  bool get enableDebugMode => _enableDebugMode ?? kDebugMode;

  /// Версия приложения
  String get appVersion => _appVersion ?? '1.0.0';

  /// Максимальное количество показов диалога оценки
  int get maxRatingDialogShows => _maxRatingDialogShows ?? 3;

  /// Google Play package ID для открытия страницы оценки
  String get googlePlayPackageId => _googlePlayPackageId ??
      'com.example.antique_identifier';

  /// Лимит идентификаций для бесплатных пользователей (в день)
  int get freeIdentificationsPerDay => _freeIdentificationsPerDay ?? 5;

  /// Получить значение из .env по ключу с значением по умолчанию
  String? getEnvValue(String key, {String? defaultValue}) {
    try {
      return dotenv.env[key] ?? defaultValue;
    } catch (e) {
      return defaultValue;
    }
  }

  /// Получить булево значение из .env по ключу
  bool getEnvBool(String key, {bool defaultValue = false}) {
    try {
      final value = dotenv.env[key]?.toLowerCase();
      return value == 'true' || value == '1';
    } catch (e) {
      return defaultValue;
    }
  }

  /// Получить числовое значение из .env по ключу
  int getEnvInt(String key, {int defaultValue = 0}) {
    try {
      return int.tryParse(dotenv.env[key] ?? '') ?? defaultValue;
    } catch (e) {
      return defaultValue;
    }
  }
}
