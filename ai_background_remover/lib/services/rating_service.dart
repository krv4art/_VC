import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class RatingService {
  static const String _ratedKey = 'has_rated';
  static const String _sessionCountKey = 'session_count';
  static const String _processCountKey = 'process_count_for_rating';
  static const String _lastPromptKey = 'last_rating_prompt';

  static const int sessionThreshold = 3;
  static const int processThreshold = 5;
  static const int daysBetweenPrompts = 30;

  Future<bool> shouldShowRatingPrompt() async {
    final prefs = await SharedPreferences.getInstance();
    final hasRated = prefs.getBool(_ratedKey) ?? false;

    if (hasRated) return false;

    final sessionCount = prefs.getInt(_sessionCountKey) ?? 0;
    final processCount = prefs.getInt(_processCountKey) ?? 0;
    final lastPrompt = prefs.getString(_lastPromptKey);

    // Check if enough time has passed since last prompt
    if (lastPrompt != null) {
      final lastDate = DateTime.parse(lastPrompt);
      final daysSince = DateTime.now().difference(lastDate).inDays;
      if (daysSince < daysBetweenPrompts) return false;
    }

    // Check if thresholds are met
    return sessionCount >= sessionThreshold || processCount >= processThreshold;
  }

  Future<void> incrementSessionCount() async {
    final prefs = await SharedPreferences.getInstance();
    final count = prefs.getInt(_sessionCountKey) ?? 0;
    await prefs.setInt(_sessionCountKey, count + 1);
  }

  Future<void> incrementProcessCount() async {
    final prefs = await SharedPreferences.getInstance();
    final count = prefs.getInt(_processCountKey) ?? 0;
    await prefs.setInt(_processCountKey, count + 1);
  }

  Future<void> markAsRated() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_ratedKey, true);
  }

  Future<void> recordPromptShown() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastPromptKey, DateTime.now().toIso8601String());
  }

  Future<void> openAppStore() async {
    // App Store URLs Configuration
    // Replace these with your actual app store URLs after publication:
    //
    // Android (Google Play):
    // 1. Publish app to Google Play Console
    // 2. Get package name from build.gradle (e.g., com.yourcompany.ai_background_remover)
    // 3. URL format: https://play.google.com/store/apps/details?id=YOUR_PACKAGE_NAME
    //
    // iOS (App Store):
    // 1. Publish app to App Store Connect
    // 2. Get app ID from App Store Connect (numeric ID)
    // 3. URL format: https://apps.apple.com/app/idYOUR_APP_ID
    //
    // For development/testing, these URLs point to placeholders
    const String androidPackageId = 'com.aibackgroundremover.app';
    const String iosAppId = '0000000000'; // Replace with real App Store ID

    final String androidUrl = 'https://play.google.com/store/apps/details?id=$androidPackageId';
    final String iosUrl = 'https://apps.apple.com/app/id$iosAppId';

    // Detect platform and use appropriate URL
    final String urlToOpen = Platform.isIOS ? iosUrl : androidUrl;

    final Uri url = Uri.parse(urlToOpen);

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> resetRatingData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_ratedKey);
    await prefs.remove(_sessionCountKey);
    await prefs.remove(_processCountKey);
    await prefs.remove(_lastPromptKey);
  }
}
