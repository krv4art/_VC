import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/poll_option.dart';
import '../models/poll_vote.dart';

/// Сервис для работы с опросом через Supabase
class PollSupabaseService {
  static final PollSupabaseService instance = PollSupabaseService._internal();

  factory PollSupabaseService() {
    return instance;
  }

  PollSupabaseService._internal();

  final SupabaseClient _client = Supabase.instance.client;

  /// Получить варианты опроса с переводами на указанный язык
  /// Возвращает только те варианты, для которых есть переводы
  Future<List<PollOption>> getOptions(String languageCode) async {
    try {
      debugPrint('=== POLL SUPABASE: Fetching options for language: $languageCode ===');

      // JOIN с poll_option_translations для получения переведенных текстов
      final response = await _client
          .from('poll_options')
          .select('''
            id,
            vote_count,
            created_at,
            is_user_created,
            poll_option_translations!inner(text)
          ''')
          .eq('poll_option_translations.language_code', languageCode)
          .order('created_at', ascending: false);

      final List<dynamic> data = response as List;

      final options = data.map((item) {
        // Получаем текст из вложенного объекта переводов
        final translations = item['poll_option_translations'] as List;
        final text = translations.isNotEmpty
            ? translations[0]['text'] as String
            : 'No translation';

        return PollOption(
          id: item['id'] as String,
          text: text,
          voteCount: item['vote_count'] as int? ?? 0,
          createdAt: DateTime.parse(item['created_at'] as String),
          isUserCreated: item['is_user_created'] as bool? ?? false,
        );
      }).toList();

      debugPrint('=== POLL SUPABASE: Loaded ${options.length} options ===');
      return options;
    } catch (e) {
      debugPrint('=== POLL SUPABASE: Error fetching options: $e ===');
      return [];
    }
  }

  /// Получить голоса пользователя по device ID
  Future<List<PollVote>> getUserVotes(String deviceId) async {
    try {
      debugPrint('=== POLL SUPABASE: Fetching votes for device: $deviceId ===');

      final response = await _client
          .from('poll_votes')
          .select()
          .eq('device_id', deviceId)
          .order('created_at', ascending: false);

      final List<dynamic> data = response as List;
      final votes = data
          .map((json) => PollVote.fromJson(json as Map<String, dynamic>))
          .toList();

      debugPrint('=== POLL SUPABASE: Found ${votes.length} votes ===');
      return votes;
    } catch (e) {
      debugPrint('=== POLL SUPABASE: Error fetching votes: $e ===');
      return [];
    }
  }

  /// Проголосовать за вариант (оптимизированная версия с RPC)
  Future<PollVote?> vote(String deviceId, String optionId) async {
    try {
      debugPrint('=== POLL SUPABASE: Voting for option $optionId by device $deviceId ===');

      // Вызываем RPC функцию, которая выполняет все операции атомарно
      final response = await _client.rpc('vote_for_option', params: {
        'p_device_id': deviceId,
        'p_option_id': optionId,
      });

      final result = response as Map<String, dynamic>;
      final success = result['success'] as bool;

      if (!success) {
        final error = result['error'] as String?;
        debugPrint('=== POLL SUPABASE: Vote failed: $error ===');
        return null;
      }

      final voteId = result['vote_id'] as String?;
      if (voteId == null) {
        debugPrint('=== POLL SUPABASE: Vote successful but no vote_id returned ===');
        return null;
      }

      debugPrint('=== POLL SUPABASE: Vote successful ===');

      // Возвращаем созданный объект голоса
      return PollVote(
        id: voteId,
        optionId: optionId,
        deviceId: deviceId,
        createdAt: DateTime.now(),
      );
    } catch (e) {
      debugPrint('=== POLL SUPABASE: Error voting: $e ===');
      return null;
    }
  }

  /// Отменить голос за вариант (оптимизированная версия с RPC)
  Future<bool> unvote(String deviceId, String optionId) async {
    try {
      debugPrint('=== POLL SUPABASE: Unvoting for option $optionId by device $deviceId ===');

      // Вызываем RPC функцию, которая выполняет все операции атомарно
      final response = await _client.rpc('unvote_for_option', params: {
        'p_device_id': deviceId,
        'p_option_id': optionId,
      });

      final result = response as Map<String, dynamic>;
      final success = result['success'] as bool;

      if (!success) {
        final error = result['error'] as String?;
        debugPrint('=== POLL SUPABASE: Unvote failed: $error ===');
        return false;
      }

      debugPrint('=== POLL SUPABASE: Unvote successful ===');
      return true;
    } catch (e) {
      debugPrint('=== POLL SUPABASE: Error unvoting: $e ===');
      return false;
    }
  }

  /// Добавить пользовательский вариант с переводом (оптимизированная версия с RPC)
  /// Возвращает ID созданного варианта или null в случае ошибки
  Future<String?> addCustomOption(String text, String languageCode) async {
    try {
      debugPrint('=== POLL SUPABASE: Adding custom option: $text (lang: $languageCode) ===');

      if (text.trim().isEmpty) {
        debugPrint('=== POLL SUPABASE: Empty option text ===');
        return null;
      }

      // Используем RPC функцию для создания варианта и первого перевода
      final response = await _client.rpc(
        'add_custom_option_with_translation',
        params: {
          'p_text': text.trim(),
          'p_language_code': languageCode,
        },
      );

      final result = response as Map<String, dynamic>;
      final success = result['success'] as bool;

      if (!success) {
        final error = result['error'] as String;
        debugPrint('=== POLL SUPABASE: Failed to add option: $error ===');
        return null;
      }

      final optionId = result['option_id'] as String;
      debugPrint('=== POLL SUPABASE: Custom option added successfully with ID: $optionId ===');

      // Асинхронно запускаем перевод на остальные языки через Edge Function
      _translateOptionAsync(optionId, text.trim(), languageCode);

      return optionId;
    } catch (e) {
      debugPrint('=== POLL SUPABASE: Error adding custom option: $e ===');
      return null;
    }
  }

  /// Асинхронно переводит вариант опроса на все поддерживаемые языки
  Future<void> _translateOptionAsync(String optionId, String text, String sourceLanguage) async {
    try {
      debugPrint('=== POLL SUPABASE: Starting async translation for option: $optionId ===');

      // Список всех поддерживаемых языков кроме исходного
      final allLanguages = ['en', 'ru', 'uk', 'es', 'de', 'fr', 'it'];
      final targetLanguages = allLanguages.where((lang) => lang != sourceLanguage).toList();

      if (targetLanguages.isEmpty) {
        debugPrint('=== POLL SUPABASE: No target languages for translation ===');
        return;
      }

      debugPrint('=== POLL SUPABASE: Translating from $sourceLanguage to: ${targetLanguages.join(", ")} ===');

      // Вызываем Edge Function для перевода
      final translationResponse = await _client.functions.invoke(
        'poll-translate-option',
        body: {
          'text': text,
          'sourceLanguage': sourceLanguage,
          'targetLanguages': targetLanguages,
        },
      );

      if (translationResponse.status != 200) {
        debugPrint('=== POLL SUPABASE: Translation Edge Function failed with status: ${translationResponse.status} ===');
        return;
      }

      final translationData = translationResponse.data as Map<String, dynamic>;
      final translationSuccess = translationData['success'] as bool;

      if (!translationSuccess) {
        final error = translationData['error'];
        debugPrint('=== POLL SUPABASE: Translation failed: $error ===');
        return;
      }

      final translations = translationData['translations'] as Map<String, dynamic>;
      debugPrint('=== POLL SUPABASE: Received ${translations.length} translations ===');

      // Сохраняем переводы в БД через RPC функцию
      final saveResponse = await _client.rpc(
        'add_option_translations',
        params: {
          'p_option_id': optionId,
          'p_translations': translations,
          'p_translation_status': 'completed',
        },
      );

      final saveResult = saveResponse as Map<String, dynamic>;
      final saveSuccess = saveResult['success'] as bool;

      if (saveSuccess) {
        final translationsAdded = saveResult['translations_added'] as int;
        debugPrint('=== POLL SUPABASE: Successfully added $translationsAdded translations ===');
      } else {
        final error = saveResult['error'];
        debugPrint('=== POLL SUPABASE: Failed to save translations: $error ===');
      }
    } catch (e) {
      debugPrint('=== POLL SUPABASE: Error during async translation: $e ===');
    }
  }

  /// Получить все данные опроса одним запросом (оптимизированная версия)
  Future<Map<String, dynamic>?> getPollData(String deviceId, String languageCode) async {
    try {
      debugPrint('=== POLL SUPABASE: Fetching poll data for device: $deviceId, language: $languageCode ===');

      // Вызываем RPC функцию, которая возвращает все данные сразу
      final response = await _client.rpc('get_poll_data', params: {
        'p_device_id': deviceId,
        'p_language_code': languageCode,
      });

      final result = response as Map<String, dynamic>;

      debugPrint('=== POLL SUPABASE: Poll data loaded successfully ===');
      return result;
    } catch (e) {
      debugPrint('=== POLL SUPABASE: Error fetching poll data: $e ===');
      return null;
    }
  }

  /// Получить количество голосов пользователя
  Future<int> getUserVoteCount(String deviceId) async {
    try {
      final votes = await getUserVotes(deviceId);
      return votes.length;
    } catch (e) {
      debugPrint('=== POLL SUPABASE: Error getting vote count: $e ===');
      return 0;
    }
  }
}
