import 'package:flutter/foundation.dart';

/// Класс для управления конфигурацией приложения
/// Использует синглтон паттерн для единого доступа к настройкам
class AppConfig {
  factory AppConfig() => _instance;
  AppConfig._();

  static final AppConfig _instance = AppConfig._();

  bool _isInitialized = false;

  /// Инициализация конфигурации
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // В Fish Identifier используем статические значения
      _isInitialized = true;

      if (kDebugMode) {
        debugPrint('AppConfig initialized');
      }
    } catch (e) {
      debugPrint('Error initializing AppConfig: $e');
      _isInitialized = true;
    }
  }

  /// Проверка, что конфигурация инициализирована
  bool get isInitialized => _isInitialized;

  /// Максимальное количество показов диалога оценки
  int get maxRatingDialogShows => 3;

  /// Лимит идентификаций для бесплатных пользователей (в день)
  int get freeIdentificationsPerDay => 5;

  /// Лимит сообщений в чате для бесплатных пользователей (в день)
  int get freeChatMessagesPerDay => 10;

  /// Версия приложения
  String get appVersion => '1.0.0';
}
