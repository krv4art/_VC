import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart';

/// Сервис для отслеживания использования приложения Math AI Solver бесплатными пользователями
///
/// Отслеживает:
/// - Количество решенных задач за день (daily solutions)
/// - Количество отправленных сообщений в чат за день (daily chat messages)
///
/// Автоматически сбрасывает счетчики в полночь
class UsageTrackingService {
  static final UsageTrackingService _instance = UsageTrackingService._internal();
  factory UsageTrackingService() => _instance;
  UsageTrackingService._internal();

  // SharedPreferences ключи
  static const String _dailySolutionsCountKey = 'daily_solutions_count';
  static const String _dailySolutionsResetDateKey = 'daily_solutions_reset_date';
  static const String _dailyMessagesCountKey = 'daily_messages_count';
  static const String _dailyMessagesResetDateKey = 'daily_messages_reset_date';
  static const String _dailyChecksCountKey = 'daily_checks_count';
  static const String _dailyChecksResetDateKey = 'daily_checks_reset_date';

  /// Инициализация сервиса
  Future<void> initialize() async {
    // Инициализируем AppConfig, если это еще не сделано
    await AppConfig().initialize();

    await _checkAndResetCounters();
    debugPrint('✅ UsageTrackingService initialized');
  }

  /// Проверить и сбросить счетчики, если прошел период
  Future<void> _checkAndResetCounters() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();

    // Проверка дневного счетчика решений
    final solutionsResetDateStr = prefs.getString(_dailySolutionsResetDateKey);
    if (solutionsResetDateStr != null) {
      final resetDate = DateTime.parse(solutionsResetDateStr);
      if (!_isSameDay(now, resetDate)) {
        await prefs.setInt(_dailySolutionsCountKey, 0);
        await prefs.setString(
          _dailySolutionsResetDateKey,
          now.toIso8601String(),
        );
        debugPrint('🔄 Daily solutions counter reset');
      }
    } else {
      // Первый запуск - устанавливаем дату
      await prefs.setString(
        _dailySolutionsResetDateKey,
        now.toIso8601String(),
      );
    }

    // Проверка дневного счетчика сообщений
    final messagesResetDateStr = prefs.getString(_dailyMessagesResetDateKey);
    if (messagesResetDateStr != null) {
      final resetDate = DateTime.parse(messagesResetDateStr);
      if (!_isSameDay(now, resetDate)) {
        await prefs.setInt(_dailyMessagesCountKey, 0);
        await prefs.setString(
          _dailyMessagesResetDateKey,
          now.toIso8601String(),
        );
        debugPrint('🔄 Daily messages counter reset');
      }
    } else {
      // Первый запуск - устанавливаем дату
      await prefs.setString(
        _dailyMessagesResetDateKey,
        now.toIso8601String(),
      );
    }

    // Проверка дневного счетчика проверок решений
    final checksResetDateStr = prefs.getString(_dailyChecksResetDateKey);
    if (checksResetDateStr != null) {
      final resetDate = DateTime.parse(checksResetDateStr);
      if (!_isSameDay(now, resetDate)) {
        await prefs.setInt(_dailyChecksCountKey, 0);
        await prefs.setString(
          _dailyChecksResetDateKey,
          now.toIso8601String(),
        );
        debugPrint('🔄 Daily checks counter reset');
      }
    } else {
      // Первый запуск - устанавливаем дату
      await prefs.setString(
        _dailyChecksResetDateKey,
        now.toIso8601String(),
      );
    }
  }

  /// Проверить, совпадает ли день
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  // ========== РЕШЕНИЯ ЗАДАЧ ==========

  /// Получить количество решенных задач за сегодня
  Future<int> getDailySolutionsCount() async {
    await _checkAndResetCounters();
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_dailySolutionsCountKey) ?? 0;
  }

  /// Увеличить счетчик решений
  Future<void> incrementSolutionsCount() async {
    final prefs = await SharedPreferences.getInstance();
    final currentCount = await getDailySolutionsCount();
    final newCount = currentCount + 1;
    await prefs.setInt(_dailySolutionsCountKey, newCount);

    final limit = AppConfig().freeSolutionsPerDay;
    debugPrint('📊 Solutions count incremented: $newCount/$limit');
  }

  /// Проверить, может ли пользователь решить задачу
  Future<bool> canUserSolveProblem() async {
    final count = await getDailySolutionsCount();
    final limit = AppConfig().freeSolutionsPerDay;
    final canSolve = count < limit;

    if (!canSolve) {
      debugPrint('❌ Daily solution limit reached: $count/$limit');
    }

    return canSolve;
  }

  /// Получить сколько решений осталось
  Future<int> getRemainingSolutionsCount() async {
    final count = await getDailySolutionsCount();
    final limit = AppConfig().freeSolutionsPerDay;
    final remaining = limit - count;
    return remaining > 0 ? remaining : 0;
  }

  // ========== ПРОВЕРКА РЕШЕНИЙ ==========

  /// Получить количество проверок решений за сегодня
  Future<int> getDailyChecksCount() async {
    await _checkAndResetCounters();
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_dailyChecksCountKey) ?? 0;
  }

  /// Увеличить счетчик проверок
  Future<void> incrementChecksCount() async {
    final prefs = await SharedPreferences.getInstance();
    final currentCount = await getDailyChecksCount();
    final newCount = currentCount + 1;
    await prefs.setInt(_dailyChecksCountKey, newCount);

    final limit = AppConfig().freeSolutionsPerDay; // Используем тот же лимит
    debugPrint('📊 Checks count incremented: $newCount/$limit');
  }

  /// Проверить, может ли пользователь проверить решение
  Future<bool> canUserCheckSolution() async {
    final count = await getDailyChecksCount();
    final limit = AppConfig().freeSolutionsPerDay; // Используем тот же лимит
    final canCheck = count < limit;

    if (!canCheck) {
      debugPrint('❌ Daily check limit reached: $count/$limit');
    }

    return canCheck;
  }

  /// Получить сколько проверок осталось
  Future<int> getRemainingChecksCount() async {
    final count = await getDailyChecksCount();
    final limit = AppConfig().freeSolutionsPerDay;
    final remaining = limit - count;
    return remaining > 0 ? remaining : 0;
  }

  // ========== СООБЩЕНИЯ В ЧАТЕ ==========

  /// Получить количество сообщений за сегодня
  Future<int> getDailyMessagesCount() async {
    await _checkAndResetCounters();
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_dailyMessagesCountKey) ?? 0;
  }

  /// Увеличить счетчик сообщений
  Future<void> incrementMessagesCount() async {
    final prefs = await SharedPreferences.getInstance();
    final currentCount = await getDailyMessagesCount();
    final newCount = currentCount + 1;
    await prefs.setInt(_dailyMessagesCountKey, newCount);

    final limit = AppConfig().freeChatMessagesPerDay;
    debugPrint('💬 Messages count incremented: $newCount/$limit');
  }

  /// Проверить, может ли пользователь отправить сообщение
  Future<bool> canUserSendMessage() async {
    final count = await getDailyMessagesCount();
    final limit = AppConfig().freeChatMessagesPerDay;
    final canSend = count < limit;

    if (!canSend) {
      debugPrint('❌ Daily message limit reached: $count/$limit');
    }

    return canSend;
  }

  /// Получить сколько сообщений осталось
  Future<int> getRemainingMessagesCount() async {
    final count = await getDailyMessagesCount();
    final limit = AppConfig().freeChatMessagesPerDay;
    final remaining = limit - count;
    return remaining > 0 ? remaining : 0;
  }

  // ========== СТАТИСТИКА ==========

  /// Получить общую статистику использования за сегодня
  Future<Map<String, dynamic>> getTodayUsageStats() async {
    final solutionsCount = await getDailySolutionsCount();
    final checksCount = await getDailyChecksCount();
    final messagesCount = await getDailyMessagesCount();

    final solutionsLimit = AppConfig().freeSolutionsPerDay;
    final messagesLimit = AppConfig().freeChatMessagesPerDay;

    return {
      'solutions': {
        'count': solutionsCount,
        'limit': solutionsLimit,
        'remaining': getRemainingSolutionsCount(),
        'percentage': (solutionsCount / solutionsLimit * 100).round(),
      },
      'checks': {
        'count': checksCount,
        'limit': solutionsLimit,
        'remaining': getRemainingChecksCount(),
        'percentage': (checksCount / solutionsLimit * 100).round(),
      },
      'messages': {
        'count': messagesCount,
        'limit': messagesLimit,
        'remaining': getRemainingMessagesCount(),
        'percentage': (messagesCount / messagesLimit * 100).round(),
      },
    };
  }

  // ========== СБРОС (для тестирования) ==========

  /// Сбросить все счетчики (для тестирования)
  Future<void> resetAllCounters() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_dailySolutionsCountKey);
    await prefs.remove(_dailySolutionsResetDateKey);
    await prefs.remove(_dailyMessagesCountKey);
    await prefs.remove(_dailyMessagesResetDateKey);
    await prefs.remove(_dailyChecksCountKey);
    await prefs.remove(_dailyChecksResetDateKey);
    debugPrint('🔄 All usage counters reset');
  }

  /// Сбросить счетчик решений
  Future<void> resetSolutionsCount() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_dailySolutionsCountKey, 0);
    debugPrint('🔄 Daily solutions counter reset');
  }

  /// Сбросить счетчик проверок
  Future<void> resetChecksCount() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_dailyChecksCountKey, 0);
    debugPrint('🔄 Daily checks counter reset');
  }

  /// Сбросить счетчик сообщений
  Future<void> resetMessagesCount() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_dailyMessagesCountKey, 0);
    debugPrint('🔄 Daily messages counter reset');
  }
}
