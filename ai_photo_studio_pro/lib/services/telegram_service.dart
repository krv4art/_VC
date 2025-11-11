import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/telegram_config.dart';
import '../services/local_data_service.dart';

/// Сервис для отправки сообщений в Telegram бота
class TelegramService {
  static final TelegramService _instance = TelegramService._internal();
  factory TelegramService() => _instance;
  TelegramService._internal();

  /// Базовый URL для Telegram Bot API
  String get _baseUrl =>
      'https://api.telegram.org/bot${TelegramConfig.botToken}';

  /// Отправка негативного отзыва в Telegram
  ///
  /// [rating] - оценка пользователя (1-5)
  /// [feedback] - текст отзыва
  /// [userInfo] - дополнительная информация о пользователе (опционально)
  Future<bool> sendNegativeFeedback({
    required int rating,
    required String feedback,
    Map<String, dynamic>? userInfo,
  }) async {
    // Проверка, включена ли отправка
    if (!TelegramConfig.enabled) {
      debugPrint('Telegram notifications disabled');
      return false;
    }

    // Проверка конфигурации
    if (!TelegramConfig.isConfigured) {
      debugPrint(
        '❌ Telegram not configured properly. Check telegram_config.dart',
      );
      return false;
    }

    try {
      // Формирование сообщения
      final message = _formatFeedbackMessage(
        rating: rating,
        feedback: feedback,
        userInfo: userInfo,
      );

      // Отправка сообщения
      final response = await http.post(
        Uri.parse('$_baseUrl/sendMessage'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'chat_id': TelegramConfig.chatId,
          'text': message,
          'parse_mode': 'HTML',
        }),
      );

      if (response.statusCode == 200) {
        debugPrint('✅ Negative feedback sent to Telegram (rating: $rating)');
        return true;
      } else {
        debugPrint(
          '❌ Failed to send to Telegram: ${response.statusCode} - ${response.body}',
        );
        return false;
      }
    } catch (e) {
      debugPrint('❌ Error sending to Telegram: $e');
      return false;
    }
  }

  /// Форматирование сообщения для отправки
  String _formatFeedbackMessage({
    required int rating,
    required String feedback,
    Map<String, dynamic>? userInfo,
  }) {
    final buffer = StringBuffer();

    // Заголовок с эмодзи в зависимости от оценки
    final emoji = _getRatingEmoji(rating);
    buffer.writeln('$emoji <b>Negative Feedback</b>');
    buffer.writeln('');

    // Оценка с хештегом
    final hashtag = _getRatingHashtag(rating);
    buffer.writeln('⭐ <b>Rating:</b> $rating/5 $hashtag');
    buffer.writeln('');

    // Текст отзыва
    buffer.writeln('💬 <b>Feedback:</b>');
    buffer.writeln(feedback.isNotEmpty ? feedback : '<i>No comment</i>');
    buffer.writeln('');

    // Дополнительная информация
    if (userInfo != null && userInfo.isNotEmpty) {
      buffer.writeln('ℹ️ <b>Info:</b>');
      userInfo.forEach((key, value) {
        buffer.writeln('  • $key: $value');
      });
      buffer.writeln('');
    }

    // Время
    final now = DateTime.now();
    buffer.writeln(
      '🕐 ${now.day}.${now.month}.${now.year} ${now.hour}:${now.minute.toString().padLeft(2, '0')}',
    );

    return buffer.toString();
  }

  /// Получение эмодзи в зависимости от оценки
  String _getRatingEmoji(int rating) {
    switch (rating) {
      case 1:
        return '😡';
      case 2:
        return '😞';
      case 3:
        return '😐';
      case 4:
        return '🙂';
      case 5:
        return '😍';
      default:
        return '❓';
    }
  }

  /// Получение хештега для фильтрации по оценке
  String _getRatingHashtag(int rating) {
    switch (rating) {
      case 0:
        return '#rating0 #not_really';
      case 1:
        return '#rating1 #very_bad';
      case 2:
        return '#rating2 #bad';
      case 3:
        return '#rating3 #neutral';
      case 4:
        return '#rating4 #good';
      case 5:
        return '#rating5 #excellent';
      default:
        return '#rating_unknown';
    }
  }

  /// Тестовая отправка сообщения для проверки настройки
  Future<bool> sendTestMessage() async {
    if (!TelegramConfig.enabled) {
      debugPrint('Telegram notifications disabled');
      return false;
    }

    if (!TelegramConfig.isConfigured) {
      debugPrint('Telegram not configured properly');
      return false;
    }

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/sendMessage'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'chat_id': TelegramConfig.chatId,
          'text':
              '✅ <b>Telegram bot successfully configured!</b>\n\n'
              'Negative feedback from ACS app will now be sent here.',
          'parse_mode': 'HTML',
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Error sending test message: $e');
      return false;
    }
  }

  /// Отправка уведомления о нажатии на кнопку "создать тему"
  Future<bool> sendCustomThemeRequest() async {
    debugPrint('🎨 sendCustomThemeRequest() called');

    // Проверка, включена ли отправка
    if (!TelegramConfig.enabled) {
      debugPrint('Telegram notifications disabled');
      return false;
    }

    // Проверка конфигурации
    if (!TelegramConfig.isConfigured) {
      debugPrint(
        '❌ Telegram not configured properly. Check telegram_config.dart',
      );
      return false;
    }

    try {
      // Проверяем, отправлял ли уже пользователь запрос
      bool alreadySent = false;

      if (kIsWeb) {
        // Для веб-версии используем SharedPreferences
        debugPrint('📝 Using SharedPreferences for web');
        try {
          final prefs = await SharedPreferences.getInstance();
          alreadySent = prefs.getBool('custom_theme_request_sent') ?? false;
          debugPrint('📝 Web already sent check result: $alreadySent');
        } catch (e) {
          debugPrint('📝 SharedPreferences error: $e');
          // Если SharedPreferences не работает, продолжаем без проверки
          alreadySent = false;
        }
      } else {
        // Для мобильной версии используем LocalDataService
        debugPrint('📝 Using LocalDataService for mobile');
        final localDataService = LocalDataService();
        alreadySent = await localDataService.getCustomThemeRequestSent();
        debugPrint('📝 Mobile already sent check result: $alreadySent');
      }

      if (alreadySent) {
        debugPrint('📝 Custom theme request already sent by this user');
        return false;
      }

      // Формирование сообщения
      final message = _formatCustomThemeRequestMessage();
      debugPrint('📝 Message formatted: ${message.length} characters');

      // Отправка сообщения
      debugPrint('📝 Sending HTTP request to Telegram...');
      final response = await http.post(
        Uri.parse('$_baseUrl/sendMessage'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'chat_id': TelegramConfig.chatId,
          'text': message,
          'parse_mode': 'HTML',
        }),
      );

      debugPrint('📝 HTTP Response status: ${response.statusCode}');
      debugPrint('📝 HTTP Response body: ${response.body}');

      if (response.statusCode == 200) {
        debugPrint('✅ Custom theme request sent to Telegram');

        // Отмечаем, что пользователь отправил запрос
        if (kIsWeb) {
          try {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setBool('custom_theme_request_sent', true);
            debugPrint('📝 Flag set in SharedPreferences');
          } catch (e) {
            debugPrint('📝 Error setting flag in SharedPreferences: $e');
          }
        } else {
          final localDataService = LocalDataService();
          await localDataService.setCustomThemeRequestSent(true);
          debugPrint('📝 Flag set in database');
        }

        return true;
      } else {
        debugPrint(
          '❌ Failed to send custom theme request to Telegram: ${response.statusCode} - ${response.body}',
        );
        return false;
      }
    } catch (e) {
      debugPrint('❌ Error sending custom theme request to Telegram: $e');
      debugPrint('❌ Stack trace: ${StackTrace.current}');
      return false;
    }
  }

  /// Форматирование сообщения о запросе кастомной темы
  String _formatCustomThemeRequestMessage() {
    final buffer = StringBuffer();

    // Заголовок
    buffer.writeln('🎨 <b>Custom Theme Request</b>');
    buffer.writeln('');

    // Основное сообщение
    buffer.writeln(
      '📝 <b>Action:</b> User clicked "Create Custom Theme" button',
    );
    buffer.writeln('');

    // Дополнительная информация
    buffer.writeln('ℹ️ <b>Info:</b>');
    buffer.writeln('  • Feature: Custom Theme Creation');
    buffer.writeln('  • Status: In Development');
    buffer.writeln('  • User Interest: High');
    buffer.writeln('');

    // Хештег для удобного поиска
    buffer.writeln('#custom_theme_request');
    buffer.writeln('');

    // Время
    final now = DateTime.now();
    buffer.writeln(
      '🕐 ${now.day}.${now.month}.${now.year} ${now.hour}:${now.minute.toString().padLeft(2, '0')}',
    );

    return buffer.toString();
  }
}
