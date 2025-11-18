import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../models/achievement.dart';
import '../models/progress.dart';

/// Provider for managing achievements
class AchievementProvider with ChangeNotifier {
  final Map<String, Achievement> _achievements = {};
  final List<String> _recentlyUnlocked = [];

  Map<String, Achievement> get achievements => _achievements;
  List<Achievement> get unlockedAchievements =>
      _achievements.values.where((a) => a.isUnlocked).toList();
  List<Achievement> get lockedAchievements =>
      _achievements.values.where((a) => !a.isUnlocked).toList();
  List<String> get recentlyUnlocked => _recentlyUnlocked;

  int get totalXP =>
      unlockedAchievements.fold(0, (sum, a) => sum + a.xpReward);

  /// Initialize achievements
  Future<void> initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final achievementsJson = prefs.getString('achievements_data');

      // Initialize all achievements
      for (final achievement in Achievements.all) {
        _achievements[achievement.id] = achievement;
      }

      // Load unlocked achievements
      if (achievementsJson != null) {
        final data = json.decode(achievementsJson) as Map<String, dynamic>;
        data.forEach((id, achievementData) {
          final achievement = Achievement.fromJson(achievementData);
          _achievements[id] = achievement;
        });
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading achievements: $e');
    }
  }

  /// Check and unlock achievements based on progress
  Future<List<Achievement>> checkAchievements(StudentProgress progress) async {
    final newlyUnlocked = <Achievement>[];

    // Check problems solved achievements
    await _checkAndUnlock(
      'first_steps',
      progress.solvedProblems >= 1,
      progress.solvedProblems,
      newlyUnlocked,
    );
    await _checkAndUnlock(
      'getting_started',
      progress.solvedProblems >= 10,
      progress.solvedProblems,
      newlyUnlocked,
    );
    await _checkAndUnlock(
      'problem_solver',
      progress.solvedProblems >= 50,
      progress.solvedProblems,
      newlyUnlocked,
    );
    await _checkAndUnlock(
      'math_wizard',
      progress.solvedProblems >= 100,
      progress.solvedProblems,
      newlyUnlocked,
    );

    // Check streak achievements
    await _checkAndUnlock(
      'streak_beginner',
      progress.currentStreak >= 3,
      progress.currentStreak,
      newlyUnlocked,
    );
    await _checkAndUnlock(
      'streak_intermediate',
      progress.currentStreak >= 7,
      progress.currentStreak,
      newlyUnlocked,
    );
    await _checkAndUnlock(
      'streak_advanced',
      progress.currentStreak >= 30,
      progress.currentStreak,
      newlyUnlocked,
    );

    // Check accuracy achievement
    if (progress.totalProblems >= 10 && progress.accuracy >= 100) {
      await _checkAndUnlock(
        'perfectionist',
        true,
        progress.totalProblems,
        newlyUnlocked,
      );
    }

    // Check study time achievements
    await _checkAndUnlock(
      'marathon_runner',
      progress.totalMinutesStudied >= 60,
      progress.totalMinutesStudied,
      newlyUnlocked,
    );

    if (newlyUnlocked.isNotEmpty) {
      _recentlyUnlocked.addAll(newlyUnlocked.map((a) => a.id));
      await _saveAchievements();
      notifyListeners();
    }

    return newlyUnlocked;
  }

  /// Check time-based achievements
  Future<List<Achievement>> checkTimeBasedAchievements() async {
    final newlyUnlocked = <Achievement>[];
    final hour = DateTime.now().hour;

    // Night owl (after 10 PM)
    if (hour >= 22) {
      await _checkAndUnlock(
        'night_owl',
        true,
        1,
        newlyUnlocked,
      );
    }

    // Early bird (before 6 AM)
    if (hour < 6) {
      await _checkAndUnlock(
        'early_bird',
        true,
        1,
        newlyUnlocked,
      );
    }

    if (newlyUnlocked.isNotEmpty) {
      _recentlyUnlocked.addAll(newlyUnlocked.map((a) => a.id));
      await _saveAchievements();
      notifyListeners();
    }

    return newlyUnlocked;
  }

  /// Update achievement progress
  Future<void> updateProgress(String achievementId, int currentValue) async {
    final achievement = _achievements[achievementId];
    if (achievement == null || achievement.isUnlocked) return;

    _achievements[achievementId] = achievement.copyWith(
      currentValue: currentValue,
    );

    await _saveAchievements();
    notifyListeners();
  }

  /// Clear recently unlocked notifications
  void clearRecentlyUnlocked() {
    _recentlyUnlocked.clear();
    notifyListeners();
  }

  /// Helper to check and unlock achievement
  Future<void> _checkAndUnlock(
    String id,
    bool condition,
    int currentValue,
    List<Achievement> newlyUnlocked,
  ) async {
    final achievement = _achievements[id];
    if (achievement == null || achievement.isUnlocked) return;

    // Update progress
    _achievements[id] = achievement.copyWith(currentValue: currentValue);

    // Check if should unlock
    if (condition && !achievement.isUnlocked) {
      _achievements[id] = achievement.copyWith(
        currentValue: currentValue,
        unlockedAt: DateTime.now(),
      );
      newlyUnlocked.add(_achievements[id]!);
    }
  }

  /// Save achievements to storage
  Future<void> _saveAchievements() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = <String, dynamic>{};

      _achievements.forEach((id, achievement) {
        data[id] = achievement.toJson();
      });

      await prefs.setString('achievements_data', json.encode(data));
    } catch (e) {
      debugPrint('Error saving achievements: $e');
    }
  }

  /// Reset all achievements (for testing)
  Future<void> resetAchievements() async {
    for (final achievement in Achievements.all) {
      _achievements[achievement.id] = achievement;
    }
    _recentlyUnlocked.clear();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('achievements_data');

    notifyListeners();
  }
}
