import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';

/// Класс для управления конфигурацией приложения Math AI Solver
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
  int? _freeSolutionsPerDay;
  int? _freeChatMessagesPerDay;

  /// Инициализация конфигурации из .env файла
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Пытаемся загрузить .env файл, если он существует
      await dotenv.load(fileName: '.env');

      _environment = dotenv.env['ENVIRONMENT'] ?? 'development';
      _enableDebugMode =
          dotenv.env['ENABLE_DEBUG_MODE']?.toLowerCase() == 'true';
      _appVersion = dotenv.env['APP_VERSION'] ?? '1.0.0';
      _maxRatingDialogShows =
          int.tryParse(dotenv.env['MAX_RATING_DIALOG_SHOWS'] ?? '3') ?? 3;
      _freeSolutionsPerDay = getEnvInt('FREE_SOLUTIONS_PER_DAY', defaultValue: 10);
      _freeChatMessagesPerDay = getEnvInt('FREE_CHAT_MESSAGES_PER_DAY', defaultValue: 5);

      _isInitialized = true;

      if (_enableDebugMode == true) {
        debugPrint('✅ AppConfig initialized with environment: $_environment');
      }
    } catch (e) {
      debugPrint('⚠️ Error loading .env file: $e');
      debugPrint('📋 Using default configuration values');
      // Устанавливаем значения по умолчанию в случае ошибки
      _environment = 'development';
      _enableDebugMode = kDebugMode;
      _appVersion = '1.0.0';
      _maxRatingDialogShows = 3;
      _freeSolutionsPerDay = 10;
      _freeChatMessagesPerDay = 5;
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

  /// Лимит решений задач для бесплатных пользователей
  int get freeSolutionsPerDay => _freeSolutionsPerDay ?? 10;

  /// Лимит сообщений в чате для бесплатных пользователей
  int get freeChatMessagesPerDay => _freeChatMessagesPerDay ?? 5;

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
