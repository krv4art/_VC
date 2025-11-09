import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info_plus/device_info_plus.dart';
import '../models/poll_option.dart';
import '../models/poll_vote.dart';
import 'poll_supabase_service.dart';

/// Сервис-обертка для работы с опросом
/// Делегирует вызовы к PollSupabaseService и управляет кэшированием
class PollService {
  static final PollService _instance = PollService._internal();
  factory PollService() => _instance;
  PollService._internal();

  final PollSupabaseService _supabaseService = PollSupabaseService.instance;

  static const String _optionsKey = 'poll_options_cache_v2';
  static const String _votesKey = 'poll_votes_cache_v2';
  static const String _deviceIdKey = 'device_id_v1';

  String? _deviceId;
  List<PollOption> _cachedOptions = [];
  List<PollVote> _cachedVotes = [];
  String? _cachedLanguage;

  /// Получить или сгенерировать device ID
  Future<String> getDeviceId() async {
    if (_deviceId != null) {
      return _deviceId!;
    }

    final prefs = await SharedPreferences.getInstance();
    String? storedId = prefs.getString(_deviceIdKey);

    if (storedId != null && storedId.isNotEmpty) {
      _deviceId = storedId;
      return _deviceId!;
    }

    // Генерируем уникальный ID на основе информации об устройстве
    try {
      final deviceInfo = DeviceInfoPlugin();
      String uniqueId;

      if (kIsWeb) {
        final webInfo = await deviceInfo.webBrowserInfo;
        uniqueId = 'web_${webInfo.userAgent?.hashCode ?? DateTime.now().millisecondsSinceEpoch}';
      } else if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        uniqueId = 'android_${androidInfo.id}';
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        uniqueId = 'ios_${iosInfo.identifierForVendor ?? DateTime.now().millisecondsSinceEpoch.toString()}';
      } else if (Platform.isWindows) {
        final windowsInfo = await deviceInfo.windowsInfo;
        uniqueId = 'windows_${windowsInfo.deviceId}';
      } else if (Platform.isLinux) {
        final linuxInfo = await deviceInfo.linuxInfo;
        uniqueId = 'linux_${linuxInfo.machineId ?? DateTime.now().millisecondsSinceEpoch.toString()}';
      } else if (Platform.isMacOS) {
        final macInfo = await deviceInfo.macOsInfo;
        uniqueId = 'macos_${macInfo.systemGUID ?? DateTime.now().millisecondsSinceEpoch.toString()}';
      } else {
        // Fallback для неизвестных платформ
        uniqueId = 'unknown_${DateTime.now().millisecondsSinceEpoch}';
      }

      await prefs.setString(_deviceIdKey, uniqueId);
      _deviceId = uniqueId;
      debugPrint('=== POLL SERVICE: Generated device ID: $uniqueId ===');
      return uniqueId;
    } catch (e) {
      debugPrint('=== POLL SERVICE: Error getting device info: $e ===');
      // Fallback: генерируем случайный ID
      final fallbackId = 'fallback_${DateTime.now().millisecondsSinceEpoch}';
      await prefs.setString(_deviceIdKey, fallbackId);
      _deviceId = fallbackId;
      return fallbackId;
    }
  }

  /// Получить все варианты опроса для указанного языка
  Future<List<PollOption>> getOptions(String languageCode) async {
    // Если кэш валиден (тот же язык и есть данные), возвращаем его
    if (_cachedOptions.isNotEmpty && _cachedLanguage == languageCode) {
      debugPrint('=== POLL SERVICE: Returning cached options ===');
      return _cachedOptions;
    }

    try {
      // Загружаем из Supabase
      final options = await _supabaseService.getOptions(languageCode);

      if (options.isNotEmpty) {
        // Обновляем кэш
        _cachedOptions = options;
        _cachedLanguage = languageCode;
        await _saveOptionsToLocal(options, languageCode);
        return options;
      } else {
        // Если Supabase вернул пустой список, пробуем загрузить из локального кэша
        debugPrint('=== POLL SERVICE: Empty response from Supabase, trying local cache ===');
        return await _loadOptionsFromLocal(languageCode);
      }
    } catch (e) {
      debugPrint('=== POLL SERVICE: Error loading options from Supabase: $e ===');
      // При ошибке загружаем из локального кэша
      return await _loadOptionsFromLocal(languageCode);
    }
  }

  /// Сохранить варианты в локальный кэш
  Future<void> _saveOptionsToLocal(List<PollOption> options, String languageCode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheData = {
        'language': languageCode,
        'options': options.map((o) => o.toJson()).toList(),
        'timestamp': DateTime.now().toIso8601String(),
      };
      await prefs.setString(_optionsKey, jsonEncode(cacheData));
      debugPrint('=== POLL SERVICE: Saved ${options.length} options to local cache ===');
    } catch (e) {
      debugPrint('=== POLL SERVICE: Error saving options to local cache: $e ===');
    }
  }

  /// Загрузить варианты из локального кэша
  Future<List<PollOption>> _loadOptionsFromLocal(String languageCode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_optionsKey);

      if (jsonString == null || jsonString.isEmpty) {
        debugPrint('=== POLL SERVICE: No local cache found ===');
        return [];
      }

      final cacheData = jsonDecode(jsonString) as Map<String, dynamic>;
      final cachedLanguage = cacheData['language'] as String;

      // Проверяем, совпадает ли язык
      if (cachedLanguage != languageCode) {
        debugPrint('=== POLL SERVICE: Cached language mismatch ===');
        return [];
      }

      final List<dynamic> jsonList = cacheData['options'] as List;
      final options = jsonList
          .map((json) => PollOption.fromJson(json as Map<String, dynamic>))
          .toList();

      _cachedOptions = options;
      _cachedLanguage = languageCode;
      debugPrint('=== POLL SERVICE: Loaded ${options.length} options from local cache ===');
      return options;
    } catch (e) {
      debugPrint('=== POLL SERVICE: Error loading options from local cache: $e ===');
      return [];
    }
  }

  /// Получить информацию о голосовании текущего пользователя
  Future<List<PollVote>> getUserVotes() async {
    final deviceId = await getDeviceId();

    // Если кэш не пустой, возвращаем его
    if (_cachedVotes.isNotEmpty) {
      debugPrint('=== POLL SERVICE: Returning cached votes ===');
      return _cachedVotes;
    }

    try {
      // Загружаем из Supabase
      final votes = await _supabaseService.getUserVotes(deviceId);

      // Обновляем кэш
      _cachedVotes = votes;
      await _saveVotesToLocal(votes);
      return votes;
    } catch (e) {
      debugPrint('=== POLL SERVICE: Error loading votes from Supabase: $e ===');
      // При ошибке загружаем из локального кэша
      return await _loadVotesFromLocal();
    }
  }

  /// Сохранить голоса в локальный кэш
  Future<void> _saveVotesToLocal(List<PollVote> votes) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = votes.map((v) => v.toJson()).toList();
      await prefs.setString(_votesKey, jsonEncode(jsonList));
      debugPrint('=== POLL SERVICE: Saved ${votes.length} votes to local cache ===');
    } catch (e) {
      debugPrint('=== POLL SERVICE: Error saving votes to local cache: $e ===');
    }
  }

  /// Загрузить голоса из локального кэша
  Future<List<PollVote>> _loadVotesFromLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_votesKey);

      if (jsonString == null || jsonString.isEmpty) {
        debugPrint('=== POLL SERVICE: No local votes cache found ===');
        return [];
      }

      final List<dynamic> jsonList = jsonDecode(jsonString) as List;
      final votes = jsonList
          .map((json) => PollVote.fromJson(json as Map<String, dynamic>))
          .toList();

      _cachedVotes = votes;
      debugPrint('=== POLL SERVICE: Loaded ${votes.length} votes from local cache ===');
      return votes;
    } catch (e) {
      debugPrint('=== POLL SERVICE: Error loading votes from local cache: $e ===');
      return [];
    }
  }

  /// Проголосовать за вариант (с умным обновлением кэша)
  Future<bool> vote(String optionId) async {
    try {
      final deviceId = await getDeviceId();
      final newVote = await _supabaseService.vote(deviceId, optionId);

      if (newVote != null) {
        // ОПТИМИЗАЦИЯ: Обновляем кэш локально вместо полной инвалидации
        _cachedVotes.add(newVote);

        // Обновляем vote_count в кэше опций
        final optionIndex = _cachedOptions.indexWhere((o) => o.id == optionId);
        if (optionIndex != -1) {
          final updatedOption = _cachedOptions[optionIndex];
          _cachedOptions[optionIndex] = PollOption(
            id: updatedOption.id,
            text: updatedOption.text,
            voteCount: updatedOption.voteCount + 1,
            createdAt: updatedOption.createdAt,
            isUserCreated: updatedOption.isUserCreated,
          );
        }

        // Сохраняем обновленный кэш
        await _saveVotesToLocal(_cachedVotes);
        await _saveOptionsToLocal(_cachedOptions, _cachedLanguage ?? 'en');

        debugPrint('=== POLL SERVICE: Vote successful, cache updated locally ===');
        return true;
      }

      return false;
    } catch (e) {
      debugPrint('=== POLL SERVICE: Error voting: $e ===');
      // При ошибке инвалидируем кэш для перезагрузки
      _cachedOptions = [];
      _cachedVotes = [];
      return false;
    }
  }

  /// Отменить голос за вариант (с умным обновлением кэша)
  Future<bool> unvote(String optionId) async {
    try {
      final deviceId = await getDeviceId();
      final success = await _supabaseService.unvote(deviceId, optionId);

      if (success) {
        // ОПТИМИЗАЦИЯ: Обновляем кэш локально вместо полной инвалидации
        _cachedVotes.removeWhere((vote) => vote.optionId == optionId);

        // Обновляем vote_count в кэше опций
        final optionIndex = _cachedOptions.indexWhere((o) => o.id == optionId);
        if (optionIndex != -1) {
          final updatedOption = _cachedOptions[optionIndex];
          _cachedOptions[optionIndex] = PollOption(
            id: updatedOption.id,
            text: updatedOption.text,
            voteCount: (updatedOption.voteCount - 1).clamp(0, double.infinity).toInt(),
            createdAt: updatedOption.createdAt,
            isUserCreated: updatedOption.isUserCreated,
          );
        }

        // Сохраняем обновленный кэш
        await _saveVotesToLocal(_cachedVotes);
        await _saveOptionsToLocal(_cachedOptions, _cachedLanguage ?? 'en');

        debugPrint('=== POLL SERVICE: Unvote successful, cache updated locally ===');
        return true;
      }

      return false;
    } catch (e) {
      debugPrint('=== POLL SERVICE: Error unvoting: $e ===');
      // При ошибке инвалидируем кэш для перезагрузки
      _cachedOptions = [];
      _cachedVotes = [];
      return false;
    }
  }

  /// Добавить пользовательский вариант
  /// Возвращает ID созданного варианта или null в случае ошибки
  Future<String?> addCustomOption(String text, String languageCode) async {
    try {
      final optionId = await _supabaseService.addCustomOption(text, languageCode);

      if (optionId != null) {
        // Инвалидируем кэш
        _cachedOptions = [];
        debugPrint('=== POLL SERVICE: Custom option added with ID: $optionId, cache invalidated ===');
      }

      return optionId;
    } catch (e) {
      debugPrint('=== POLL SERVICE: Error adding custom option: $e ===');
      return null;
    }
  }

  static const int _maxVotes = 3;

  /// Получить все данные опроса одним запросом (оптимизированная версия)
  Future<Map<String, dynamic>> getPollData(String languageCode) async {
    try {
      final deviceId = await getDeviceId();

      // Вызываем оптимизированную функцию, которая возвращает все данные одним запросом
      final data = await _supabaseService.getPollData(deviceId, languageCode);

      if (data != null) {
        // Парсим опции
        final optionsJson = data['options'] as List;
        final options = optionsJson
            .map((json) => PollOption.fromJson(json as Map<String, dynamic>))
            .toList();

        // Парсим голоса
        final votesJson = data['votes'] as List;
        final votes = votesJson
            .map((json) => PollVote.fromJson(json as Map<String, dynamic>))
            .toList();

        final remainingVotes = data['remaining_votes'] as int? ?? _maxVotes;

        // Обновляем кэш
        _cachedOptions = options;
        _cachedVotes = votes;
        _cachedLanguage = languageCode;

        // Сохраняем в локальное хранилище
        await _saveOptionsToLocal(options, languageCode);
        await _saveVotesToLocal(votes);

        debugPrint('=== POLL SERVICE: Poll data loaded with optimized single query ===');

        return {
          'options': options,
          'votes': votes,
          'remaining_votes': remainingVotes,
        };
      } else {
        // Fallback на локальный кэш при ошибке
        debugPrint('=== POLL SERVICE: Failed to load poll data, using local cache ===');
        final options = await _loadOptionsFromLocal(languageCode);
        final votes = await _loadVotesFromLocal();

        return {
          'options': options,
          'votes': votes,
          'remaining_votes': _maxVotes - votes.length,
        };
      }
    } catch (e) {
      debugPrint('=== POLL SERVICE: Error loading poll data: $e ===');
      // Fallback на локальный кэш
      final options = await _loadOptionsFromLocal(languageCode);
      final votes = await _loadVotesFromLocal();

      return {
        'options': options,
        'votes': votes,
        'remaining_votes': _maxVotes - votes.length,
      };
    }
  }

  /// Получить количество голосов пользователя
  Future<int> getUserVoteCount() async {
    final votes = await getUserVotes();
    return votes.length;
  }

  /// Проверить, проголосовал ли пользователь
  Future<bool> hasVoted() async {
    final votes = await getUserVotes();
    return votes.isNotEmpty;
  }

  /// Очистить кэш (для тестирования)
  void clearCache() {
    _cachedOptions = [];
    _cachedVotes = [];
    _cachedLanguage = null;
    debugPrint('=== POLL SERVICE: Cache cleared ===');
  }

  /// Сбросить все данные опроса (для тестирования)
  Future<void> resetPoll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_optionsKey);
      await prefs.remove(_votesKey);
      clearCache();
      debugPrint('=== POLL SERVICE: Poll reset ===');
    } catch (e) {
      debugPrint('=== POLL SERVICE: Error resetting poll: $e ===');
    }
  }
}
