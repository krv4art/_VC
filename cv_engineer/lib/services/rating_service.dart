import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for managing app rating dialog shows
class RatingService {
  static final RatingService _instance = RatingService._internal();
  factory RatingService() => _instance;
  RatingService._internal();

  static const String _ratingDialogShowsKey = 'rating_dialog_shows_count';
  static const String _lastRatingDateKey = 'last_rating_dialog_date';
  static const String _ratingCompletedKey = 'rating_completed';
  static const String _appInstallDateKey = 'app_install_date';

  // Minimum interval between shows in days
  static const int _minDaysBetweenShows = 7;
  // Minimum app usage time before first show in hours
  static const int _minHoursBeforeFirstShow = 24;
  // Maximum number of times to show rating dialog
  static const int _maxShowsCount = 3;

  /// Initialize rating service
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();

    // Set app install date if not already set
    if (!prefs.containsKey(_appInstallDateKey)) {
      await prefs.setString(
        _appInstallDateKey,
        DateTime.now().toIso8601String(),
      );
      debugPrint('Rating Service: App install date set');
    }
  }

  /// Check if rating dialog should be shown
  Future<bool> shouldShowRatingDialog() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      debugPrint('=== RATING SERVICE: Checking if should show rating dialog ===');

      // 1. Check if rating is already completed
      final isRatingCompleted = prefs.getBool(_ratingCompletedKey) ?? false;
      debugPrint('Rating completed: $isRatingCompleted');
      if (isRatingCompleted) {
        return false;
      }

      // 2. Check number of shows
      final showsCount = prefs.getInt(_ratingDialogShowsKey) ?? 0;
      debugPrint('Shows count: $showsCount / $_maxShowsCount');
      if (showsCount >= _maxShowsCount) {
        return false;
      }

      // 3. Check minimum time since install
      final installDateString = prefs.getString(_appInstallDateKey);
      if (installDateString != null) {
        final installDate = DateTime.parse(installDateString);
        final hoursSinceInstall = DateTime.now().difference(installDate).inHours;
        debugPrint('Hours since install: $hoursSinceInstall (required: $_minHoursBeforeFirstShow)');
        if (hoursSinceInstall < _minHoursBeforeFirstShow) {
          return false;
        }
      }

      // 4. Check interval since last show
      if (showsCount > 0) {
        final lastShowDateString = prefs.getString(_lastRatingDateKey);
        if (lastShowDateString != null) {
          final lastShowDate = DateTime.parse(lastShowDateString);
          final daysSinceLastShow = DateTime.now().difference(lastShowDate).inDays;
          debugPrint('Days since last show: $daysSinceLastShow (required: $_minDaysBetweenShows)');
          if (daysSinceLastShow < _minDaysBetweenShows) {
            return false;
          }
        }
      }

      debugPrint('=== RATING SERVICE: All checks passed, can show dialog ===');
      return true;
    } catch (e) {
      debugPrint('Error checking rating dialog: $e');
      return false;
    }
  }

  /// Increment rating dialog shows counter
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

  /// Get current rating dialog shows count
  Future<int> getRatingDialogShowsCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_ratingDialogShowsKey) ?? 0;
    } catch (e) {
      debugPrint('Error getting rating dialog shows count: $e');
      return 0;
    }
  }

  /// Get last rating dialog show date
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

  /// Mark rating as completed (won't show dialog again)
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

  /// Get app install date
  Future<DateTime?> getAppInstallDate() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final dateString = prefs.getString(_appInstallDateKey);

      if (dateString != null) {
        return DateTime.parse(dateString);
      }
      return null;
    } catch (e) {
      debugPrint('Error getting app install date: $e');
      return null;
    }
  }
}
