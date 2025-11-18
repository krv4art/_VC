import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import '../config/app_config.dart';

/// Service for managing rating dialog displays
class RatingService {
  static final RatingService _instance = RatingService._internal();
  factory RatingService() => _instance;
  RatingService._internal();

  static const String _ratingDialogShowsKey = 'rating_dialog_shows_count';
  static const String _lastRatingDateKey = 'last_rating_dialog_date';
  static const String _ratingCompletedKey = 'rating_completed';
  static const String _appInstallDateKey = 'app_install_date';

  // Minimum interval between shows in days
  static const int _minDaysBetweenShows = 3;
  // Minimum app usage time before first show in hours
  static const int _minHoursBeforeFirstShow = 0; // TODO: Change to 24 for production

  /// Initialize service
  Future<void> initialize() async {
    await AppConfig().initialize();

    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(_appInstallDateKey)) {
      await prefs.setString(
        _appInstallDateKey,
        DateTime.now().toIso8601String(),
      );
    }
  }

  /// Check if rating dialog should be shown
  Future<bool> shouldShowRatingDialog() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      debugPrint('=== RATING SERVICE: Checking if should show rating dialog ===');

      // 1. Check if rating already completed
      final isRatingCompleted = prefs.getBool(_ratingCompletedKey) ?? false;
      if (isRatingCompleted) {
        debugPrint('=== RATING SERVICE: Rating already completed ===');
        return false;
      }

      // 2. Check show count
      final showsCount = prefs.getInt(_ratingDialogShowsKey) ?? 0;
      final maxShows = AppConfig().maxRatingDialogShows;
      if (showsCount >= maxShows) {
        debugPrint('=== RATING SERVICE: Max shows reached ($showsCount/$maxShows) ===');
        return false;
      }

      // 3. Check minimum time since install
      final installDateString = prefs.getString(_appInstallDateKey);
      if (installDateString != null) {
        final installDate = DateTime.parse(installDateString);
        final hoursSinceInstall = DateTime.now().difference(installDate).inHours;
        if (hoursSinceInstall < _minHoursBeforeFirstShow) {
          debugPrint('=== RATING SERVICE: Too soon since install ===');
          return false;
        }
      }

      // 4. Check interval since last show
      if (showsCount > 0) {
        final lastShowDateString = prefs.getString(_lastRatingDateKey);
        if (lastShowDateString != null) {
          final lastShowDate = DateTime.parse(lastShowDateString);
          final daysSinceLastShow = DateTime.now().difference(lastShowDate).inDays;
          if (daysSinceLastShow < _minDaysBetweenShows) {
            debugPrint('=== RATING SERVICE: Too soon since last show ===');
            return false;
          }
        }
      }

      debugPrint('=== RATING SERVICE: ✅ CAN show rating dialog ===');
      return true;
    } catch (e) {
      debugPrint('=== RATING SERVICE: ❌ Error: $e ===');
      return false;
    }
  }

  /// Increment rating dialog shows count
  Future<void> incrementRatingDialogShows() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentShows = prefs.getInt(_ratingDialogShowsKey) ?? 0;
      await prefs.setInt(_ratingDialogShowsKey, currentShows + 1);
      await prefs.setString(
        _lastRatingDateKey,
        DateTime.now().toIso8601String(),
      );
      debugPrint('Rating dialog shows count: ${currentShows + 1}');
    } catch (e) {
      debugPrint('Error incrementing rating dialog shows: $e');
    }
  }

  /// Mark rating as completed
  Future<void> markRatingCompleted() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_ratingCompletedKey, true);
      debugPrint('Rating marked as completed');
    } catch (e) {
      debugPrint('Error marking rating as completed: $e');
    }
  }

  /// Reset rating dialog shows (for testing)
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
