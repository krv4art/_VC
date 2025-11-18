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
    // TODO: Replace with actual app store URLs
    const String androidUrl = 'https://play.google.com/store/apps/details?id=com.example.ai_background_remover';
    const String iosUrl = 'https://apps.apple.com/app/id123456789';

    // For now, just open a placeholder
    final Uri url = Uri.parse(androidUrl);

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
