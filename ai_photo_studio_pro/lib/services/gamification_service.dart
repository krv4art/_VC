import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

/// Service for gamification features (achievements, levels, rewards)
class GamificationService {
  final Database _database;

  GamificationService(this._database);

  /// Initialize gamification tables
  static Future<void> createTables(Database db) async {
    // User progress table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS user_progress (
        id INTEGER PRIMARY KEY CHECK (id = 1),
        level INTEGER NOT NULL DEFAULT 1,
        total_xp INTEGER NOT NULL DEFAULT 0,
        photos_generated INTEGER NOT NULL DEFAULT 0,
        days_streak INTEGER NOT NULL DEFAULT 0,
        last_activity_date TEXT,
        total_shares INTEGER NOT NULL DEFAULT 0,
        total_favorites INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL
      )
    ''');

    // Achievements table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS achievements (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        icon TEXT NOT NULL,
        xp_reward INTEGER NOT NULL,
        unlocked INTEGER NOT NULL DEFAULT 0,
        unlocked_at TEXT,
        progress INTEGER NOT NULL DEFAULT 0,
        target INTEGER NOT NULL,
        category TEXT NOT NULL
      )
    ''');

    // Daily bonuses table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS daily_bonuses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        claimed_at TEXT NOT NULL,
        day_number INTEGER NOT NULL,
        reward_type TEXT NOT NULL,
        reward_value INTEGER NOT NULL
      )
    ''');

    // Initialize default user progress
    await db.insert(
      'user_progress',
      {
        'id': 1,
        'level': 1,
        'total_xp': 0,
        'photos_generated': 0,
        'days_streak': 0,
        'total_shares': 0,
        'total_favorites': 0,
        'created_at': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );

    // Initialize achievements
    await _initializeAchievements(db);
  }

  /// Initialize default achievements
  static Future<void> _initializeAchievements(Database db) async {
    final achievements = [
      {
        'id': 'first_photo',
        'name': 'First Steps',
        'description': 'Generate your first AI photo',
        'icon': '🎨',
        'xp_reward': 100,
        'target': 1,
        'category': 'generation',
      },
      {
        'id': 'photo_master_10',
        'name': 'Photo Master',
        'description': 'Generate 10 AI photos',
        'icon': '📸',
        'xp_reward': 500,
        'target': 10,
        'category': 'generation',
      },
      {
        'id': 'photo_expert_50',
        'name': 'Photo Expert',
        'description': 'Generate 50 AI photos',
        'icon': '🏆',
        'xp_reward': 2000,
        'target': 50,
        'category': 'generation',
      },
      {
        'id': 'photo_legend_100',
        'name': 'Photo Legend',
        'description': 'Generate 100 AI photos',
        'icon': '⭐',
        'xp_reward': 5000,
        'target': 100,
        'category': 'generation',
      },
      {
        'id': 'style_explorer',
        'name': 'Style Explorer',
        'description': 'Try 5 different photo styles',
        'icon': '🎭',
        'xp_reward': 300,
        'target': 5,
        'category': 'variety',
      },
      {
        'id': 'social_butterfly',
        'name': 'Social Butterfly',
        'description': 'Share 10 photos',
        'icon': '🦋',
        'xp_reward': 400,
        'target': 10,
        'category': 'social',
      },
      {
        'id': 'streak_7',
        'name': 'Week Warrior',
        'description': 'Use app 7 days in a row',
        'icon': '🔥',
        'xp_reward': 700,
        'target': 7,
        'category': 'engagement',
      },
      {
        'id': 'streak_30',
        'name': 'Monthly Master',
        'description': 'Use app 30 days in a row',
        'icon': '💎',
        'xp_reward': 3000,
        'target': 30,
        'category': 'engagement',
      },
      {
        'id': 'favorite_collector',
        'name': 'Favorite Collector',
        'description': 'Add 25 photos to favorites',
        'icon': '💝',
        'xp_reward': 600,
        'target': 25,
        'category': 'collection',
      },
    ];

    for (final achievement in achievements) {
      await db.insert(
        'achievements',
        achievement,
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
  }

  /// Get user progress
  Future<Map<String, dynamic>?> getUserProgress() async {
    try {
      final result = await _database.query('user_progress', where: 'id = 1');
      return result.isNotEmpty ? result.first : null;
    } catch (e) {
      debugPrint('Error getting user progress: $e');
      return null;
    }
  }

  /// Update daily streak
  Future<void> updateDailyStreak() async {
    try {
      final progress = await getUserProgress();
      if (progress == null) return;

      final lastActivityDate = progress['last_activity_date'] as String?;
      final now = DateTime.now();

      int newStreak = 1;

      if (lastActivityDate != null) {
        final lastDate = DateTime.parse(lastActivityDate);
        final difference = now.difference(lastDate).inDays;

        if (difference == 1) {
          // Consecutive day
          newStreak = (progress['days_streak'] as int) + 1;
        } else if (difference == 0) {
          // Same day, keep current streak
          newStreak = progress['days_streak'] as int;
        }
        // else: streak broken, reset to 1
      }

      await _database.update(
        'user_progress',
        {
          'days_streak': newStreak,
          'last_activity_date': now.toIso8601String(),
        },
        where: 'id = 1',
      );

      // Check streak achievements
      await _checkStreakAchievements(newStreak);
    } catch (e) {
      debugPrint('Error updating daily streak: $e');
    }
  }

  /// Add XP to user
  Future<void> addXP(int xp, {String? reason}) async {
    try {
      final progress = await getUserProgress();
      if (progress == null) return;

      final currentXP = progress['total_xp'] as int;
      final currentLevel = progress['level'] as int;
      final newXP = currentXP + xp;

      // Calculate new level (simple formula: level = sqrt(xp / 100))
      final newLevel = (newXP / 1000).floor() + 1;

      await _database.update(
        'user_progress',
        {
          'total_xp': newXP,
          'level': newLevel,
        },
        where: 'id = 1',
      );

      debugPrint('Added $xp XP${reason != null ? ' for $reason' : ''}. New total: $newXP');

      // Level up notification if level increased
      if (newLevel > currentLevel) {
        debugPrint('🎉 Level up! Now level $newLevel');
      }
    } catch (e) {
      debugPrint('Error adding XP: $e');
    }
  }

  /// Track photo generation
  Future<void> trackPhotoGeneration() async {
    try {
      await _database.rawUpdate('''
        UPDATE user_progress
        SET photos_generated = photos_generated + 1
        WHERE id = 1
      ''');

      await addXP(50, reason: 'photo generation');
      await updateDailyStreak();

      // Check generation achievements
      final progress = await getUserProgress();
      if (progress != null) {
        final photosGenerated = progress['photos_generated'] as int;
        await _checkGenerationAchievements(photosGenerated);
      }
    } catch (e) {
      debugPrint('Error tracking photo generation: $e');
    }
  }

  /// Track photo share
  Future<void> trackPhotoShare() async {
    try {
      await _database.rawUpdate('''
        UPDATE user_progress
        SET total_shares = total_shares + 1
        WHERE id = 1
      ''');

      await addXP(25, reason: 'sharing photo');

      final progress = await getUserProgress();
      if (progress != null) {
        final totalShares = progress['total_shares'] as int;
        await _checkSocialAchievements(totalShares);
      }
    } catch (e) {
      debugPrint('Error tracking photo share: $e');
    }
  }

  /// Track favorite added
  Future<void> trackFavoriteAdded() async {
    try {
      await _database.rawUpdate('''
        UPDATE user_progress
        SET total_favorites = total_favorites + 1
        WHERE id = 1
      ''');

      await addXP(10, reason: 'adding to favorites');

      final progress = await getUserProgress();
      if (progress != null) {
        final totalFavorites = progress['total_favorites'] as int;
        await _checkCollectionAchievements(totalFavorites);
      }
    } catch (e) {
      debugPrint('Error tracking favorite: $e');
    }
  }

  /// Check and unlock generation achievements
  Future<void> _checkGenerationAchievements(int photosGenerated) async {
    final achievementIds = ['first_photo', 'photo_master_10', 'photo_expert_50', 'photo_legend_100'];

    for (final id in achievementIds) {
      await _updateAchievementProgress(id, photosGenerated);
    }
  }

  /// Check and unlock streak achievements
  Future<void> _checkStreakAchievements(int streak) async {
    final achievementIds = ['streak_7', 'streak_30'];

    for (final id in achievementIds) {
      await _updateAchievementProgress(id, streak);
    }
  }

  /// Check and unlock social achievements
  Future<void> _checkSocialAchievements(int shares) async {
    await _updateAchievementProgress('social_butterfly', shares);
  }

  /// Check and unlock collection achievements
  Future<void> _checkCollectionAchievements(int favorites) async {
    await _updateAchievementProgress('favorite_collector', favorites);
  }

  /// Update achievement progress and unlock if target reached
  Future<void> _updateAchievementProgress(String achievementId, int progress) async {
    try {
      final achievement = await _database.query(
        'achievements',
        where: 'id = ?',
        whereArgs: [achievementId],
      );

      if (achievement.isEmpty) return;

      final target = achievement.first['target'] as int;
      final unlocked = achievement.first['unlocked'] as int;

      if (unlocked == 0 && progress >= target) {
        // Unlock achievement
        await _database.update(
          'achievements',
          {
            'unlocked': 1,
            'unlocked_at': DateTime.now().toIso8601String(),
            'progress': progress,
          },
          where: 'id = ?',
          whereArgs: [achievementId],
        );

        final xpReward = achievement.first['xp_reward'] as int;
        await addXP(xpReward, reason: 'achievement unlocked');

        debugPrint('🏆 Achievement unlocked: ${achievement.first['name']}');
      } else if (unlocked == 0) {
        // Update progress
        await _database.update(
          'achievements',
          {'progress': progress},
          where: 'id = ?',
          whereArgs: [achievementId],
        );
      }
    } catch (e) {
      debugPrint('Error updating achievement progress: $e');
    }
  }

  /// Get all achievements
  Future<List<Map<String, dynamic>>> getAllAchievements() async {
    try {
      return await _database.query('achievements', orderBy: 'unlocked DESC, category');
    } catch (e) {
      debugPrint('Error getting achievements: $e');
      return [];
    }
  }

  /// Get unlocked achievements
  Future<List<Map<String, dynamic>>> getUnlockedAchievements() async {
    try {
      return await _database.query(
        'achievements',
        where: 'unlocked = 1',
        orderBy: 'unlocked_at DESC',
      );
    } catch (e) {
      debugPrint('Error getting unlocked achievements: $e');
      return [];
    }
  }

  /// Check if can claim daily bonus
  Future<bool> canClaimDailyBonus() async {
    try {
      final today = DateTime.now();
      final todayStart = DateTime(today.year, today.month, today.day);

      final result = await _database.query(
        'daily_bonuses',
        where: 'claimed_at >= ?',
        whereArgs: [todayStart.toIso8601String()],
        limit: 1,
      );

      return result.isEmpty;
    } catch (e) {
      debugPrint('Error checking daily bonus: $e');
      return false;
    }
  }

  /// Claim daily bonus
  Future<Map<String, dynamic>?> claimDailyBonus() async {
    try {
      final canClaim = await canClaimDailyBonus();
      if (!canClaim) return null;

      // Get consecutive days
      final allBonuses = await _database.query(
        'daily_bonuses',
        orderBy: 'claimed_at DESC',
        limit: 1,
      );

      int dayNumber = 1;
      if (allBonuses.isNotEmpty) {
        final lastBonus = allBonuses.first;
        final lastClaimDate = DateTime.parse(lastBonus['claimed_at'] as String);
        final today = DateTime.now();

        if (today.difference(lastClaimDate).inDays == 1) {
          dayNumber = (lastBonus['day_number'] as int) + 1;
        }
      }

      // Cycle every 7 days
      if (dayNumber > 7) dayNumber = 1;

      // Rewards increase each day
      final xpReward = 50 * dayNumber;

      await _database.insert('daily_bonuses', {
        'claimed_at': DateTime.now().toIso8601String(),
        'day_number': dayNumber,
        'reward_type': 'xp',
        'reward_value': xpReward,
      });

      await addXP(xpReward, reason: 'daily bonus');

      return {
        'day_number': dayNumber,
        'reward_type': 'xp',
        'reward_value': xpReward,
      };
    } catch (e) {
      debugPrint('Error claiming daily bonus: $e');
      return null;
    }
  }

  /// Get XP required for next level
  int getXPForNextLevel(int currentLevel) {
    return currentLevel * 1000;
  }

  /// Get current level progress percentage
  double getLevelProgress(int currentXP, int currentLevel) {
    final xpForCurrentLevel = (currentLevel - 1) * 1000;
    final xpForNextLevel = currentLevel * 1000;
    final xpIntoLevel = currentXP - xpForCurrentLevel;
    final xpNeeded = xpForNextLevel - xpForCurrentLevel;

    return xpIntoLevel / xpNeeded;
  }
}
