import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import '../config/app_config.dart';

/// Service for managing rating dialog shows
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
  // Minimum hours before first show
  // TODO: Set to 24 for production!
  static const int _minHoursBeforeFirstShow = 0;

  /// Initialize service
  Future<void> initialize() async {
    // Initialize AppConfig if not done yet
    await AppConfig().initialize();

    // Set app install date if not set
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

      // 1. Check if user already completed rating
      final isRatingCompleted = prefs.getBool(_ratingCompletedKey) ?? false;
      debugPrint('=== RATING SERVICE: Rating completed: $isRatingCompleted ===');
      if (isRatingCompleted) {
        debugPrint('=== RATING SERVICE: Rating already completed, not showing dialog ===');
        return false;
      }

      // 2. Check number of shows
      final showsCount = prefs.getInt(_ratingDialogShowsKey) ?? 0;
      final maxShows = AppConfig().maxRatingDialogShows;
      debugPrint('=== RATING SERVICE: Shows count: $showsCount / $maxShows ===');
      if (showsCount >= maxShows) {
        debugPrint('=== RATING SERVICE: Max shows reached ($showsCount/$maxShows), not showing dialog ===');
        return false;
      }

      // 3. Check if minimum time has passed since install
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

      // 4. Check interval since last show (only if shown at least once)
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

  /// Increment rating dialog shows counter
  Future<void> incrementRatingDialogShows() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Increment shows counter
      final currentShows = prefs.getInt(_ratingDialogShowsKey) ?? 0;
      await prefs.setInt(_ratingDialogShowsKey, currentShows + 1);

      // Save current date as last show date
      await prefs.setString(
        _lastRatingDateKey,
        DateTime.now().toIso8601String(),
      );

      debugPrint('Rating dialog shows count: ${currentShows + 1}');
    } catch (e) {
      debugPrint('Error incrementing rating dialog shows: $e');
    }
  }

  /// Get current number of rating dialog shows
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

  /// Mark rating as completed (don't show dialog anymore)
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

  /// Open app store for rating
  /// Note: In a real app, use url_launcher or in_app_review package
  Future<void> openAppStore() async {
    // TODO: Implement with url_launcher or in_app_review package
    debugPrint('Opening app store for rating...');
  }
}
