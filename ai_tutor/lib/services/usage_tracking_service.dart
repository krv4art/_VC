import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UsageTrackingService {
  static final UsageTrackingService _instance = UsageTrackingService._internal();
  factory UsageTrackingService() => _instance;
  UsageTrackingService._internal();

  // Free tier limits
  static const int freeProblemsPerDay = 10;
  static const int freeAiMessagesPerDay = 5;
  static const int freeBrainTrainingPerDay = 3;
  static const int freeTransformationsPerDay = 5;

  // Keys for SharedPreferences
  static const String _keyProblemsCount = 'daily_problems_count';
  static const String _keyAiMessagesCount = 'daily_ai_messages_count';
  static const String _keyBrainTrainingCount = 'daily_brain_training_count';
  static const String _keyTransformationsCount = 'daily_transformations_count';
  static const String _keyLastResetDate = 'last_reset_date';

  /// Check if it's a new day and reset counters
  Future<void> _checkAndResetDaily() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().substring(0, 10); // YYYY-MM-DD
    final lastResetDate = prefs.getString(_keyLastResetDate);

    if (lastResetDate != today) {
      // New day, reset all counters
      await prefs.setInt(_keyProblemsCount, 0);
      await prefs.setInt(_keyAiMessagesCount, 0);
      await prefs.setInt(_keyBrainTrainingCount, 0);
      await prefs.setInt(_keyTransformationsCount, 0);
      await prefs.setString(_keyLastResetDate, today);
      debugPrint('✅ Daily usage counters reset');
    }
  }

  // ==================== PROBLEMS ====================

  /// Check if user can solve more problems
  Future<bool> canSolveProblems() async {
    await _checkAndResetDaily();
    final count = await getDailyProblemsCount();
    return count < freeProblemsPerDay;
  }

  /// Increment problems solved count
  Future<void> incrementProblemsCount() async {
    final prefs = await SharedPreferences.getInstance();
    final currentCount = await getDailyProblemsCount();
    await prefs.setInt(_keyProblemsCount, currentCount + 1);
  }

  /// Get daily problems solved count
  Future<int> getDailyProblemsCount() async {
    await _checkAndResetDaily();
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyProblemsCount) ?? 0;
  }

  /// Get remaining problems count
  Future<int> getRemainingProblemsCount() async {
    final count = await getDailyProblemsCount();
    return (freeProblemsPerDay - count).clamp(0, freeProblemsPerDay);
  }

  // ==================== AI MESSAGES ====================

  /// Check if user can send more AI messages
  Future<bool> canSendAiMessages() async {
    await _checkAndResetDaily();
    final count = await getDailyAiMessagesCount();
    return count < freeAiMessagesPerDay;
  }

  /// Increment AI messages count
  Future<void> incrementAiMessagesCount() async {
    final prefs = await SharedPreferences.getInstance();
    final currentCount = await getDailyAiMessagesCount();
    await prefs.setInt(_keyAiMessagesCount, currentCount + 1);
  }

  /// Get daily AI messages count
  Future<int> getDailyAiMessagesCount() async {
    await _checkAndResetDaily();
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyAiMessagesCount) ?? 0;
  }

  /// Get remaining AI messages count
  Future<int> getRemainingAiMessagesCount() async {
    final count = await getDailyAiMessagesCount();
    return (freeAiMessagesPerDay - count).clamp(0, freeAiMessagesPerDay);
  }

  // ==================== BRAIN TRAINING ====================

  /// Check if user can play brain training
  Future<bool> canPlayBrainTraining() async {
    await _checkAndResetDaily();
    final count = await getDailyBrainTrainingCount();
    return count < freeBrainTrainingPerDay;
  }

  /// Increment brain training count
  Future<void> incrementBrainTrainingCount() async {
    final prefs = await SharedPreferences.getInstance();
    final currentCount = await getDailyBrainTrainingCount();
    await prefs.setInt(_keyBrainTrainingCount, currentCount + 1);
  }

  /// Get daily brain training count
  Future<int> getDailyBrainTrainingCount() async {
    await _checkAndResetDaily();
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyBrainTrainingCount) ?? 0;
  }

  /// Get remaining brain training count
  Future<int> getRemainingBrainTrainingCount() async {
    final count = await getDailyBrainTrainingCount();
    return (freeBrainTrainingPerDay - count).clamp(0, freeBrainTrainingPerDay);
  }

  // ==================== TRANSFORMATIONS ====================

  /// Check if user can transform more problems
  Future<bool> canTransformProblems() async {
    await _checkAndResetDaily();
    final count = await getDailyTransformationsCount();
    return count < freeTransformationsPerDay;
  }

  /// Increment transformations count
  Future<void> incrementTransformationsCount() async {
    final prefs = await SharedPreferences.getInstance();
    final currentCount = await getDailyTransformationsCount();
    await prefs.setInt(_keyTransformationsCount, currentCount + 1);
  }

  /// Get daily transformations count
  Future<int> getDailyTransformationsCount() async {
    await _checkAndResetDaily();
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyTransformationsCount) ?? 0;
  }

  /// Get remaining transformations count
  Future<int> getRemainingTransformationsCount() async {
    final count = await getDailyTransformationsCount();
    return (freeTransformationsPerDay - count).clamp(0, freeTransformationsPerDay);
  }

  // ==================== UTILITY ====================

  /// Clear all usage data (for testing)
  Future<void> clearAllUsageData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyProblemsCount);
    await prefs.remove(_keyAiMessagesCount);
    await prefs.remove(_keyBrainTrainingCount);
    await prefs.remove(_keyTransformationsCount);
    await prefs.remove(_keyLastResetDate);
    debugPrint('✅ All usage data cleared');
  }

  /// Get usage summary
  Future<Map<String, dynamic>> getUsageSummary() async {
    return {
      'problems': {
        'used': await getDailyProblemsCount(),
        'limit': freeProblemsPerDay,
        'remaining': await getRemainingProblemsCount(),
      },
      'ai_messages': {
        'used': await getDailyAiMessagesCount(),
        'limit': freeAiMessagesPerDay,
        'remaining': await getRemainingAiMessagesCount(),
      },
      'brain_training': {
        'used': await getDailyBrainTrainingCount(),
        'limit': freeBrainTrainingPerDay,
        'remaining': await getRemainingBrainTrainingCount(),
      },
      'transformations': {
        'used': await getDailyTransformationsCount(),
        'limit': freeTransformationsPerDay,
        'remaining': await getRemainingTransformationsCount(),
      },
    };
  }
}
