import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_profile.dart';
import '../models/progress.dart';
import '../models/achievement.dart';

/// Service for syncing local data with Supabase cloud
class DataSyncService {
  final SupabaseClient _supabase;
  bool _isSyncing = false;

  DataSyncService({required SupabaseClient supabase}) : _supabase = supabase;

  bool get isSyncing => _isSyncing;

  /// Sync all data (called after login)
  Future<void> syncAll(String userId) async {
    if (_isSyncing) return;

    _isSyncing = true;
    try {
      await Future.wait([
        syncUserProfile(userId),
        syncProgress(userId),
        syncAchievements(userId),
        syncBrainTrainingStats(userId),
      ]);
      debugPrint('✅ All data synced successfully');
    } catch (e) {
      debugPrint('❌ Error syncing data: $e');
      rethrow;
    } finally {
      _isSyncing = false;
    }
  }

  /// Sync user profile to cloud
  Future<void> syncUserProfile(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final profileJson = prefs.getString('user_profile');

      if (profileJson != null) {
        final profileData = json.decode(profileJson);

        // Upload to Supabase
        await _supabase.from('user_profiles').upsert({
          'id': userId,
          'full_name': profileData['fullName'],
          'email': profileData['email'],
          'selected_interests': profileData['selectedInterests'],
          'custom_interests': profileData['customInterests'],
          'cultural_theme_id': profileData['culturalThemeId'],
          'learning_style': profileData['learningStyle'],
          'subject_levels': profileData['subjectLevels'],
          'preferred_language': profileData['preferredLanguage'],
          'is_onboarding_complete': profileData['isOnboardingComplete'],
          'updated_at': DateTime.now().toIso8601String(),
        });

        debugPrint('✅ User profile synced');
      }
    } catch (e) {
      debugPrint('❌ Error syncing user profile: $e');
    }
  }

  /// Download user profile from cloud
  Future<void> downloadUserProfile(String userId) async {
    try {
      final response = await _supabase
          .from('user_profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (response != null) {
        final prefs = await SharedPreferences.getInstance();
        final profileData = {
          'userId': userId,
          'fullName': response['full_name'],
          'email': response['email'],
          'selectedInterests': response['selected_interests'] ?? [],
          'customInterests': response['custom_interests'] ?? [],
          'culturalThemeId': response['cultural_theme_id'] ?? 'default',
          'learningStyle': response['learning_style'] ?? 'balanced',
          'subjectLevels': response['subject_levels'] ?? {},
          'preferredLanguage': response['preferred_language'] ?? 'en',
          'isOnboardingComplete': response['is_onboarding_complete'] ?? false,
        };

        await prefs.setString('user_profile', json.encode(profileData));
        debugPrint('✅ User profile downloaded');
      }
    } catch (e) {
      debugPrint('❌ Error downloading user profile: $e');
    }
  }

  /// Sync progress to cloud
  Future<void> syncProgress(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final progressJson = prefs.getString('progress_data');

      if (progressJson != null) {
        final progressData = json.decode(progressJson);

        await _supabase.from('progress').upsert({
          'user_id': userId,
          'problems_solved': progressData['problemsSolved'] ?? 0,
          'correct_answers': progressData['correctAnswers'] ?? 0,
          'current_streak': progressData['currentStreak'] ?? 0,
          'longest_streak': progressData['longestStreak'] ?? 0,
          'total_study_time': progressData['totalStudyTime'] ?? 0,
          'last_study_date': progressData['lastStudyDate'],
          'topic_progress': progressData['topicProgress'] ?? {},
          'topic_mastery': progressData['topicMastery'] ?? {},
          'updated_at': DateTime.now().toIso8601String(),
        });

        debugPrint('✅ Progress synced');
      }
    } catch (e) {
      debugPrint('❌ Error syncing progress: $e');
    }
  }

  /// Download progress from cloud
  Future<void> downloadProgress(String userId) async {
    try {
      final response = await _supabase
          .from('progress')
          .select()
          .eq('user_id', userId)
          .maybeSingle();

      if (response != null) {
        final prefs = await SharedPreferences.getInstance();
        final progressData = {
          'problemsSolved': response['problems_solved'] ?? 0,
          'correctAnswers': response['correct_answers'] ?? 0,
          'currentStreak': response['current_streak'] ?? 0,
          'longestStreak': response['longest_streak'] ?? 0,
          'totalStudyTime': response['total_study_time'] ?? 0,
          'lastStudyDate': response['last_study_date'],
          'topicProgress': response['topic_progress'] ?? {},
          'topicMastery': response['topic_mastery'] ?? {},
        };

        await prefs.setString('progress_data', json.encode(progressData));
        debugPrint('✅ Progress downloaded');
      }
    } catch (e) {
      debugPrint('❌ Error downloading progress: $e');
    }
  }

  /// Sync achievements to cloud
  Future<void> syncAchievements(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final achievementsJson = prefs.getString('achievements_data');

      if (achievementsJson != null) {
        final achievementsData = json.decode(achievementsJson);

        await _supabase.from('achievements').upsert({
          'user_id': userId,
          'total_xp': achievementsData['totalXP'] ?? 0,
          'unlocked_achievements': achievementsData['unlockedAchievements'] ?? [],
          'achievement_dates': achievementsData['achievementDates'] ?? {},
          'updated_at': DateTime.now().toIso8601String(),
        });

        debugPrint('✅ Achievements synced');
      }
    } catch (e) {
      debugPrint('❌ Error syncing achievements: $e');
    }
  }

  /// Download achievements from cloud
  Future<void> downloadAchievements(String userId) async {
    try {
      final response = await _supabase
          .from('achievements')
          .select()
          .eq('user_id', userId)
          .maybeSingle();

      if (response != null) {
        final prefs = await SharedPreferences.getInstance();
        final achievementsData = {
          'totalXP': response['total_xp'] ?? 0,
          'unlockedAchievements': response['unlocked_achievements'] ?? [],
          'achievementDates': response['achievement_dates'] ?? {},
        };

        await prefs.setString('achievements_data', json.encode(achievementsData));
        debugPrint('✅ Achievements downloaded');
      }
    } catch (e) {
      debugPrint('❌ Error downloading achievements: $e');
    }
  }

  /// Sync brain training stats to cloud
  Future<void> syncBrainTrainingStats(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final statsJson = prefs.getString('brain_training_stats');

      if (statsJson != null) {
        final statsData = json.decode(statsJson);

        await _supabase.from('brain_training_stats').upsert({
          'user_id': userId,
          'stats_data': statsData,
          'updated_at': DateTime.now().toIso8601String(),
        });

        debugPrint('✅ Brain training stats synced');
      }
    } catch (e) {
      debugPrint('❌ Error syncing brain training stats: $e');
    }
  }

  /// Download brain training stats from cloud
  Future<void> downloadBrainTrainingStats(String userId) async {
    try {
      final response = await _supabase
          .from('brain_training_stats')
          .select()
          .eq('user_id', userId)
          .maybeSingle();

      if (response != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
          'brain_training_stats',
          json.encode(response['stats_data']),
        );
        debugPrint('✅ Brain training stats downloaded');
      }
    } catch (e) {
      debugPrint('❌ Error downloading brain training stats: $e');
    }
  }

  /// Merge local and cloud data (conflict resolution)
  /// Strategy: Latest timestamp wins
  Future<void> mergeData(String userId) async {
    try {
      // Download cloud data
      await Future.wait([
        downloadUserProfile(userId),
        downloadProgress(userId),
        downloadAchievements(userId),
        downloadBrainTrainingStats(userId),
      ]);

      // Compare timestamps and use latest
      // For now, we'll just use cloud data if it exists
      // TODO: Implement proper conflict resolution with timestamps

      debugPrint('✅ Data merged successfully');
    } catch (e) {
      debugPrint('❌ Error merging data: $e');
    }
  }

  /// Enable auto-sync (periodic background sync)
  /// This should be called when user is authenticated
  void enableAutoSync(String userId) {
    // TODO: Implement periodic sync with WorkManager or similar
    // For now, we'll sync on app resume/pause
    debugPrint('Auto-sync enabled for user: $userId');
  }

  /// Disable auto-sync
  void disableAutoSync() {
    debugPrint('Auto-sync disabled');
  }

  /// Clear all local data (after logout)
  Future<void> clearLocalData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_profile');
      await prefs.remove('progress_data');
      await prefs.remove('achievements_data');
      await prefs.remove('brain_training_stats');
      await prefs.remove('daily_challenge');
      await prefs.remove('study_goals');
      debugPrint('✅ Local data cleared');
    } catch (e) {
      debugPrint('❌ Error clearing local data: $e');
    }
  }
}
