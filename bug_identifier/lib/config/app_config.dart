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
  bool? _enableRemotePrompts;
  bool? _enableDebugMode;
  int? _promptsCacheDurationHours;
  String? _appVersion;
  int? _maxRatingDialogShows;
  String? _googlePlayPackageId;
  int? _freeScansPerWeek;
  int? _freeMessagesPerDay;
  int? _freeVisibleScans;

  /// Инициализация конфигурации из .env файла
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await dotenv.load(fileName: 'assets/config/.env');

      _environment = dotenv.env['ENVIRONMENT'] ?? 'development';
      _enableRemotePrompts =
          dotenv.env['ENABLE_REMOTE_PROMPTS']?.toLowerCase() == 'true';
      _enableDebugMode =
          dotenv.env['ENABLE_DEBUG_MODE']?.toLowerCase() == 'true';
      _promptsCacheDurationHours =
          int.tryParse(dotenv.env['PROMPTS_CACHE_DURATION_HOURS'] ?? '24') ??
          24;
      _appVersion = dotenv.env['APP_VERSION'] ?? '1.0.0';
      _maxRatingDialogShows =
          int.tryParse(dotenv.env['MAX_RATING_DIALOG_SHOWS'] ?? '3') ?? 3;
      _googlePlayPackageId = dotenv.env['GOOGLE_PLAY_PACKAGE_ID'] ??
          'com.ai.cosmetic.scanner.beauty.ingredients.analyzer';
      _freeScansPerWeek = getEnvInt('FREE_SCANS_PER_WEEK', defaultValue: 5);
      _freeMessagesPerDay = getEnvInt('FREE_MESSAGES_PER_DAY', defaultValue: 5);
      _freeVisibleScans = getEnvInt('FREE_VISIBLE_SCANS', defaultValue: 1);

      _isInitialized = true;

      if (_enableDebugMode == true) {
        debugPrint('AppConfig initialized with environment: $_environment');
      }
    } catch (e) {
      debugPrint('Error initializing AppConfig: $e');
      // Устанавливаем значения по умолчанию в случае ошибки
      _environment = 'development';
      _enableRemotePrompts = false;
      _enableDebugMode = true;
      _promptsCacheDurationHours = 24;
      _appVersion = '1.0.0';
      _maxRatingDialogShows = 3;
      _isInitialized = true;
    }
  }

  /// Проверка, что конфигурация инициализирована
  bool get isInitialized => _isInitialized;

  /// Текущее окружение (development, production, etc.)
  String get environment => _environment ?? 'development';

  /// Включено ли удаленное обновление промптов
  bool get enableRemotePrompts => _enableRemotePrompts ?? false;

  /// Включен ли режим отладки
  bool get enableDebugMode => _enableDebugMode ?? true;

  /// Длительность кеширования промптов в часах
  int get promptsCacheDurationHours => _promptsCacheDurationHours ?? 24;

  /// Версия приложения
  String get appVersion => _appVersion ?? '1.0.0';

  /// Максимальное количество показов диалога оценки
  int get maxRatingDialogShows => _maxRatingDialogShows ?? 3;

  /// Google Play package ID для открытия страницы оценки
  String get googlePlayPackageId => _googlePlayPackageId ??
      'com.ai.cosmetic.scanner.beauty.ingredients.analyzer';

  /// Лимит сканов для бесплатных пользователей
  int get freeScansPerWeek => _freeScansPerWeek ?? 5;

  /// Лимит сообщений в чате для бесплатных пользователей
  int get freeMessagesPerDay => _freeMessagesPerDay ?? 5;

  /// Количество доступных позиций в истории для бесплатных
  int get freeVisibleScans => _freeVisibleScans ?? 1;

  /// Получить значение из .env по ключу с значением по умолчанию
  String? getEnvValue(String key, {String? defaultValue}) {
    return dotenv.env[key] ?? defaultValue;
  }

  /// Получить булево значение из .env по ключу
  bool getEnvBool(String key, {bool defaultValue = false}) {
    final value = dotenv.env[key]?.toLowerCase();
    return value == 'true' || value == '1';
  }

  /// Получить числовое значение из .env по ключу
  int getEnvInt(String key, {int defaultValue = 0}) {
    return int.tryParse(dotenv.env[key] ?? '') ?? defaultValue;
  }
}
