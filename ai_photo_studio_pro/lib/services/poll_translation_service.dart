import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Сервис для перевода вариантов опроса через Gemini
class PollTranslationService {
  static final PollTranslationService _instance =
      PollTranslationService._internal();

  factory PollTranslationService() {
    return _instance;
  }

  PollTranslationService._internal();

  final SupabaseClient _client = Supabase.instance.client;

  /// Поддерживаемые языки (совпадают с локализацией приложения)
  static const List<String> supportedLanguages = [
    'en', // English
    'ru', // Russian
    'uk', // Ukrainian
    'es', // Spanish
    'de', // German
    'fr', // French
    'it', // Italian
  ];

  /// Переводит текст варианта опроса на все поддерживаемые языки
  /// Отправляет запрос на Edge Function, которая затем обращается к Gemini
  Future<Map<String, String>> translateOptionText(
    String text,
    String sourceLanguage,
  ) async {
    try {
      debugPrint(
        '=== POLL TRANSLATION: Translating "$text" from $sourceLanguage ===',
      );

      // Список языков для перевода (исключаем исходный язык)
      final targetLanguages = supportedLanguages
          .where((lang) => lang != sourceLanguage)
          .toList();

      if (targetLanguages.isEmpty) {
        debugPrint('=== POLL TRANSLATION: No target languages to translate ===');
        return {sourceLanguage: text};
      }

      // Вызываем Edge Function для перевода
      final response = await _client.functions.invoke(
        'poll-translate-option',
        body: {
          'text': text,
          'sourceLanguage': sourceLanguage,
          'targetLanguages': targetLanguages,
        },
      );

      final result = response as Map<String, dynamic>;

      if (result['success'] != true) {
        final error = result['error'] as String;
        debugPrint('=== POLL TRANSLATION: Translation failed: $error ===');
        return {sourceLanguage: text};
      }

      final translations = result['translations'] as Map<String, dynamic>? ?? {};
      final convertedTranslations = <String, String>{};

      // Добавляем исходный текст
      convertedTranslations[sourceLanguage] = text;

      // Преобразуем переводы в Map<String, String>
      translations.forEach((lang, data) {
        if (data is Map<String, dynamic>) {
          final translatedText = data['text'] as String?;
          if (translatedText != null && translatedText.isNotEmpty) {
            convertedTranslations[lang] = translatedText;
          }
        } else if (data is String) {
          convertedTranslations[lang] = data;
        }
      });

      debugPrint(
        '=== POLL TRANSLATION: Successfully translated to ${convertedTranslations.length} languages ===',
      );

      return convertedTranslations;
    } catch (e) {
      debugPrint('=== POLL TRANSLATION: Error translating: $e ===');
      return {sourceLanguage: text};
    }
  }

  /// Сохраняет переводы варианта опроса в базу данных
  Future<bool> saveTranslations(
    String optionId,
    Map<String, String> translations,
  ) async {
    try {
      debugPrint(
        '=== POLL TRANSLATION: Saving ${translations.length} translations for option $optionId ===',
      );

      // Преобразуем Map в формат JSONB для RPC функции
      final translationsJsonb = <String, dynamic>{};
      translations.forEach((lang, text) {
        translationsJsonb[lang] = {'text': text};
      });

      // Вызываем RPC функцию для добавления переводов
      final response = await _client.rpc(
        'add_option_translations',
        params: {
          'p_option_id': optionId,
          'p_translations': translationsJsonb,
          'p_translation_status': 'completed',
        },
      );

      if (response == null) {
        debugPrint('=== POLL TRANSLATION: Empty response from RPC ===');
        return false;
      }

      final result = response as Map<String, dynamic>;
      final success = result['success'] as bool? ?? false;

      if (success) {
        final added = result['translations_added'] as int? ?? 0;
        debugPrint(
          '=== POLL TRANSLATION: Successfully saved $added translations ===',
        );
      } else {
        final error = result['error'] as String? ?? 'Unknown error';
        debugPrint('=== POLL TRANSLATION: Failed to save translations: $error ===');
      }

      return success;
    } catch (e) {
      debugPrint('=== POLL TRANSLATION: Error saving translations: $e ===');
      return false;
    }
  }

  /// Транслирует и сохраняет текст варианта опроса за один раз
  Future<bool> translateAndSave(
    String optionId,
    String text,
    String sourceLanguage,
  ) async {
    try {
      debugPrint(
        '=== POLL TRANSLATION: Starting translation and save for option $optionId ===',
      );

      // Переводим текст
      final translations = await translateOptionText(text, sourceLanguage);

      // Сохраняем переводы
      final saved = await saveTranslations(optionId, translations);

      return saved;
    } catch (e) {
      debugPrint(
        '=== POLL TRANSLATION: Error in translateAndSave: $e ===',
      );
      return false;
    }
  }

  /// Получает список опций, требующих перевода
  /// Используется для фонового перевода
  Future<List<Map<String, dynamic>>> getPendingOptions({int limit = 10}) async {
    try {
      debugPrint(
        '=== POLL TRANSLATION: Fetching pending translations (limit: $limit) ===',
      );

      final response = await _client.rpc(
        'get_pending_translations',
        params: {'p_limit': limit},
      ) as List<dynamic>?;

      if (response == null || response.isEmpty) {
        debugPrint('=== POLL TRANSLATION: No pending translations ===');
        return [];
      }

      final options = response
          .cast<Map<String, dynamic>>()
          .toList();

      debugPrint(
        '=== POLL TRANSLATION: Found ${options.length} options pending translation ===',
      );

      return options;
    } catch (e) {
      debugPrint(
        '=== POLL TRANSLATION: Error fetching pending options: $e ===',
      );
      return [];
    }
  }
}
