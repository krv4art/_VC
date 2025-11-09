import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for managing app ratings and review requests
class RatingService {
  static const String _ratingShownKey = 'rating_dialog_shown';
  static const String _scanCountKey = 'scan_count';
  static const String _lastRatingRequestKey = 'last_rating_request';

  /// Check if we should show rating dialog
  Future<bool> shouldShowRatingDialog() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Check if already shown
      final alreadyShown = prefs.getBool(_ratingShownKey) ?? false;
      if (alreadyShown) return false;

      // Check scan count (show after 5 scans)
      final scanCount = prefs.getInt(_scanCountKey) ?? 0;
      if (scanCount < 5) return false;

      // Check if we asked recently (don't ask more than once per week)
      final lastRequest = prefs.getString(_lastRatingRequestKey);
      if (lastRequest != null) {
        final lastDate = DateTime.parse(lastRequest);
        final daysSince = DateTime.now().difference(lastDate).inDays;
        if (daysSince < 7) return false;
      }

      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error checking rating dialog: $e');
      }
      return false;
    }
  }

  /// Increment scan count
  Future<void> incrementScanCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentCount = prefs.getInt(_scanCountKey) ?? 0;
      await prefs.setInt(_scanCountKey, currentCount + 1);
    } catch (e) {
      if (kDebugMode) {
        print('Error incrementing scan count: $e');
      }
    }
  }

  /// Mark rating dialog as shown
  Future<void> markRatingShown() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_ratingShownKey, true);
      await prefs.setString(_lastRatingRequestKey, DateTime.now().toIso8601String());
    } catch (e) {
      if (kDebugMode) {
        print('Error marking rating shown: $e');
      }
    }
  }

  /// Mark user declined rating (will ask again later)
  Future<void> markRatingDeclined() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_lastRatingRequestKey, DateTime.now().toIso8601String());
    } catch (e) {
      if (kDebugMode) {
        print('Error marking rating declined: $e');
      }
    }
  }

  /// Open app store for rating
  Future<void> openAppStore() async {
    // TODO: Implement with url_launcher or in_app_review package
    if (kDebugMode) {
      print('Would open app store here');
    }
    await markRatingShown();
  }

  /// Reset rating state (for testing)
  Future<void> resetRatingState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_ratingShownKey);
      await prefs.remove(_scanCountKey);
      await prefs.remove(_lastRatingRequestKey);
    } catch (e) {
      if (kDebugMode) {
        print('Error resetting rating state: $e');
      }
    }
  }
}
