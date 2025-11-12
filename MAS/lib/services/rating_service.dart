import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import '../config/app_config.dart';

/// Сервис для управления показами диалога оценки Math AI Scanner
class RatingService {
  static final RatingService _instance = RatingService._internal();
  factory RatingService() => _instance;
  RatingService._internal();

  static const String _ratingDialogShowsKey = 'rating_dialog_shows_count';
  static const String _lastRatingDateKey = 'last_rating_dialog_date';
  static const String _ratingCompletedKey = 'rating_completed';
  static const String _appInstallDateKey = 'app_install_date';

  // Минимальный интервал между показами в днях
  static const int _minDaysBetweenShows = 3;
  // Минимальное время использования приложения перед первым показом в часах
  // TODO: Для тестирования установлено 0, вернуть на 24 для продакшена!
  static const int _minHoursBeforeFirstShow = 0;

  /// Инициализация сервиса
  Future<void> initialize() async {
    // Инициализируем AppConfig, если это еще не сделано
    await AppConfig().initialize();

    // Устанавливаем дату установки приложения, если она еще не установлена
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(_appInstallDateKey)) {
      await prefs.setString(
        _appInstallDateKey,
        DateTime.now().toIso8601String(),
      );
    }
  }

  /// Проверить, нужно ли показать диалог оценки
  Future<bool> shouldShowRatingDialog() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      debugPrint('=== RATING SERVICE: Checking if should show rating dialog ===');

      // 1. Проверяем, не завершил ли пользователь уже оценку
      final isRatingCompleted = prefs.getBool(_ratingCompletedKey) ?? false;
      debugPrint('=== RATING SERVICE: Rating completed: $isRatingCompleted ===');
      if (isRatingCompleted) {
        debugPrint('=== RATING SERVICE: Rating already completed, not showing dialog ===');
        return false;
      }

      // 2. Проверяем количество показов
      final showsCount = prefs.getInt(_ratingDialogShowsKey) ?? 0;
      final maxShows = AppConfig().maxRatingDialogShows;
      debugPrint('=== RATING SERVICE: Shows count: $showsCount / $maxShows ===');
      if (showsCount >= maxShows) {
        debugPrint('=== RATING SERVICE: Max shows reached ($showsCount/$maxShows), not showing dialog ===');
        return false;
      }

      // 3. Проверяем, прошло ли минимальное время с установки приложения
      final installDateString = prefs.getString(_appInstallDateKey);
      debugPrint('=== RATING SERVICE: Install date: $installDateString ===');
      if (installDateString != null) {
        final installDate = DateTime.parse(installDateString);
        final hoursSinceInstall = DateTime.now().difference(installDate).inHours;
        debugPrint('=== RATING SERVICE: Hours since install: $hoursSinceInstall (required: $_minHoursBeforeFirstShow) ===');
        if (hoursSinceInstall < _minHoursBeforeFirstShow) {
          debugPrint('=== RATING SERVICE: Too soon since install ($hoursSinceInstall hours), not showing dialog ===');
          return false;
        }
      } else {
        debugPrint('=== RATING SERVICE: WARNING - No install date found! ===');
      }

      // 4. Проверяем интервал с последнего показа (только если был хотя бы один показ)
      if (showsCount > 0) {
        final lastShowDateString = prefs.getString(_lastRatingDateKey);
        debugPrint('=== RATING SERVICE: Last show date: $lastShowDateString ===');
        if (lastShowDateString != null) {
          final lastShowDate = DateTime.parse(lastShowDateString);
          final daysSinceLastShow = DateTime.now().difference(lastShowDate).inDays;
          debugPrint('=== RATING SERVICE: Days since last show: $daysSinceLastShow (required: $_minDaysBetweenShows) ===');
          if (daysSinceLastShow < _minDaysBetweenShows) {
            debugPrint('=== RATING SERVICE: Too soon since last show ($daysSinceLastShow days), not showing dialog ===');
            return false;
          }
        }
      }

      debugPrint('=== RATING SERVICE: ✅ All checks passed, CAN show rating dialog ===');
      return true;
    } catch (e) {
      debugPrint('=== RATING SERVICE: ❌ Error checking rating dialog: $e ===');
      return false;
    }
  }

  /// Увеличить счетчик показов диалога оценки
  Future<void> incrementRatingDialogShows() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Увеличиваем счетчик показов
      final currentShows = prefs.getInt(_ratingDialogShowsKey) ?? 0;
      await prefs.setInt(_ratingDialogShowsKey, currentShows + 1);

      // Сохраняем текущую дату последнего показа
      await prefs.setString(
        _lastRatingDateKey,
        DateTime.now().toIso8601String(),
      );

      debugPrint('Rating dialog shows count: ${currentShows + 1}');
    } catch (e) {
      debugPrint('Error incrementing rating dialog shows: $e');
    }
  }

  /// Получить текущее количество показов диалога оценки
  Future<int> getRatingDialogShowsCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_ratingDialogShowsKey) ?? 0;
    } catch (e) {
      debugPrint('Error getting rating dialog shows count: $e');
      return 0;
    }
  }

  /// Получить дату последнего показа диалога оценки
  Future<DateTime?> getLastRatingDialogDate() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final dateString = prefs.getString(_lastRatingDateKey);

      if (dateString != null) {
        return DateTime.parse(dateString);
      }
      return null;
    } catch (e) {
      debugPrint('Error getting last rating dialog date: $e');
      return null;
    }
  }

  /// Отметить, что пользователь завершил оценку (больше не показывать диалог)
  Future<void> markRatingCompleted() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_ratingCompletedKey, true);
      debugPrint('Rating marked as completed');
    } catch (e) {
      debugPrint('Error marking rating as completed: $e');
    }
  }

  /// Сбросить счетчик показов диалога оценки (для тестирования)
  Future<void> resetRatingDialogShows() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_ratingDialogShowsKey);
      await prefs.remove(_lastRatingDateKey);
      await prefs.remove(_ratingCompletedKey);
      debugPrint('Rating dialog shows count reset');
    } catch (e) {
      debugPrint('Error resetting rating dialog shows: $e');
    }
  }
}
