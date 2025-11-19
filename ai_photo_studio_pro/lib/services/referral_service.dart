import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:math';

/// Service for managing referral program
class ReferralService {
  final Database _database;

  ReferralService(this._database);

  /// Initialize referral tables
  static Future<void> createTables(Database db) async {
    // User referral info table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS referral_info (
        id INTEGER PRIMARY KEY CHECK (id = 1),
        referral_code TEXT NOT NULL UNIQUE,
        referred_by_code TEXT,
        total_referrals INTEGER NOT NULL DEFAULT 0,
        total_rewards_earned INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL
      )
    ''');

    // Referral history table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS referrals (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        referred_user_code TEXT NOT NULL,
        status TEXT NOT NULL,
        reward_type TEXT,
        reward_value INTEGER,
        referred_at TEXT NOT NULL,
        completed_at TEXT
      )
    ''');

    // Rewards table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS referral_rewards (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        referral_id INTEGER NOT NULL,
        reward_type TEXT NOT NULL,
        reward_value INTEGER NOT NULL,
        claimed INTEGER NOT NULL DEFAULT 0,
        claimed_at TEXT,
        expires_at TEXT,
        FOREIGN KEY (referral_id) REFERENCES referrals(id)
      )
    ''');
  }

  /// Initialize user referral code
  Future<String> initializeReferralCode({String? userId}) async {
    try {
      // Check if already exists
      final existing = await _database.query('referral_info', where: 'id = 1');

      if (existing.isNotEmpty) {
        return existing.first['referral_code'] as String;
      }

      // Generate new referral code
      final code = _generateReferralCode(userId);

      await _database.insert('referral_info', {
        'id': 1,
        'referral_code': code,
        'total_referrals': 0,
        'total_rewards_earned': 0,
        'created_at': DateTime.now().toIso8601String(),
      });

      debugPrint('Referral code created: $code');
      return code;
    } catch (e) {
      debugPrint('Error initializing referral code: $e');
      return _generateReferralCode(userId);
    }
  }

  /// Generate unique referral code
  String _generateReferralCode(String? userId) {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789'; // No confusing chars
    final random = Random();
    final prefix = userId?.substring(0, min(3, userId.length)).toUpperCase() ?? 'APP';

    String code = prefix;
    for (int i = 0; i < 5; i++) {
      code += chars[random.nextInt(chars.length)];
    }

    return code;
  }

  /// Get user's referral code
  Future<String?> getReferralCode() async {
    try {
      final result = await _database.query('referral_info', where: 'id = 1');
      return result.isNotEmpty ? result.first['referral_code'] as String : null;
    } catch (e) {
      debugPrint('Error getting referral code: $e');
      return null;
    }
  }

  /// Get referral info
  Future<Map<String, dynamic>?> getReferralInfo() async {
    try {
      final result = await _database.query('referral_info', where: 'id = 1');
      return result.isNotEmpty ? result.first : null;
    } catch (e) {
      debugPrint('Error getting referral info: $e');
      return null;
    }
  }

  /// Set referred by code (when user signs up with a referral link)
  Future<bool> setReferredBy(String referralCode) async {
    try {
      await _database.update(
        'referral_info',
        {'referred_by_code': referralCode},
        where: 'id = 1',
      );

      debugPrint('User was referred by: $referralCode');
      return true;
    } catch (e) {
      debugPrint('Error setting referred by: $e');
      return false;
    }
  }

  /// Track new referral
  Future<int?> trackReferral(String referredUserCode) async {
    try {
      final referralId = await _database.insert('referrals', {
        'referred_user_code': referredUserCode,
        'status': 'pending',
        'referred_at': DateTime.now().toIso8601String(),
      });

      await _database.rawUpdate('''
        UPDATE referral_info
        SET total_referrals = total_referrals + 1
        WHERE id = 1
      ''');

      debugPrint('New referral tracked: $referredUserCode');
      return referralId;
    } catch (e) {
      debugPrint('Error tracking referral: $e');
      return null;
    }
  }

  /// Complete referral (when referred user completes required action)
  Future<bool> completeReferral({
    required int referralId,
    ReferralRewardType rewardType = ReferralRewardType.freeScans,
    int rewardValue = 5,
  }) async {
    try {
      // Update referral status
      await _database.update(
        'referrals',
        {
          'status': 'completed',
          'reward_type': rewardType.name,
          'reward_value': rewardValue,
          'completed_at': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [referralId],
      );

      // Create reward
      final expiresAt = DateTime.now().add(const Duration(days: 30));
      await _database.insert('referral_rewards', {
        'referral_id': referralId,
        'reward_type': rewardType.name,
        'reward_value': rewardValue,
        'claimed': 0,
        'expires_at': expiresAt.toIso8601String(),
      });

      // Update total rewards
      await _database.rawUpdate('''
        UPDATE referral_info
        SET total_rewards_earned = total_rewards_earned + ?
        WHERE id = 1
      ''', [rewardValue]);

      debugPrint('Referral completed with reward: $rewardType = $rewardValue');
      return true;
    } catch (e) {
      debugPrint('Error completing referral: $e');
      return false;
    }
  }

  /// Get all referrals
  Future<List<Map<String, dynamic>>> getAllReferrals() async {
    try {
      return await _database.query(
        'referrals',
        orderBy: 'referred_at DESC',
      );
    } catch (e) {
      debugPrint('Error getting referrals: $e');
      return [];
    }
  }

  /// Get completed referrals count
  Future<int> getCompletedReferralsCount() async {
    try {
      final result = await _database.rawQuery('''
        SELECT COUNT(*) as count
        FROM referrals
        WHERE status = 'completed'
      ''');
      return result.first['count'] as int;
    } catch (e) {
      debugPrint('Error getting completed referrals count: $e');
      return 0;
    }
  }

  /// Get pending rewards
  Future<List<Map<String, dynamic>>> getPendingRewards() async {
    try {
      final now = DateTime.now().toIso8601String();
      return await _database.query(
        'referral_rewards',
        where: 'claimed = 0 AND expires_at > ?',
        whereArgs: [now],
        orderBy: 'expires_at ASC',
      );
    } catch (e) {
      debugPrint('Error getting pending rewards: $e');
      return [];
    }
  }

  /// Claim reward
  Future<bool> claimReward(int rewardId) async {
    try {
      await _database.update(
        'referral_rewards',
        {
          'claimed': 1,
          'claimed_at': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [rewardId],
      );

      debugPrint('Reward claimed: $rewardId');
      return true;
    } catch (e) {
      debugPrint('Error claiming reward: $e');
      return false;
    }
  }

  /// Get total unclaimed reward value by type
  Future<Map<String, int>> getUnclaimedRewardsByType() async {
    try {
      final now = DateTime.now().toIso8601String();
      final rewards = await _database.query(
        'referral_rewards',
        where: 'claimed = 0 AND expires_at > ?',
        whereArgs: [now],
      );

      final Map<String, int> totals = {};
      for (final reward in rewards) {
        final type = reward['reward_type'] as String;
        final value = reward['reward_value'] as int;
        totals[type] = (totals[type] ?? 0) + value;
      }

      return totals;
    } catch (e) {
      debugPrint('Error getting unclaimed rewards by type: $e');
      return {};
    }
  }

  /// Generate referral link
  String generateReferralLink(String referralCode) {
    return 'https://aiphotostudio.pro/invite/$referralCode';
  }

  /// Get referral share text
  String getReferralShareText(String referralCode) {
    final link = generateReferralLink(referralCode);
    return '''
🎨 Join me on AI Photo Studio Pro!

Create stunning AI headshots with professional quality.

Use my code: $referralCode
Or click: $link

We'll both get free scans! 🎁

#AIPhoto #AIHeadshot #PhotoStudio
''';
  }

  /// Get referral statistics
  Future<Map<String, dynamic>> getReferralStatistics() async {
    try {
      final info = await getReferralInfo();
      final completedCount = await getCompletedReferralsCount();
      final pendingRewards = await getPendingRewards();
      final unclaimedByType = await getUnclaimedRewardsByType();

      return {
        'referral_code': info?['referral_code'],
        'total_referrals': info?['total_referrals'] ?? 0,
        'completed_referrals': completedCount,
        'total_rewards_earned': info?['total_rewards_earned'] ?? 0,
        'pending_rewards_count': pendingRewards.length,
        'unclaimed_by_type': unclaimedByType,
      };
    } catch (e) {
      debugPrint('Error getting referral statistics: $e');
      return {};
    }
  }

  /// Clean up expired rewards
  Future<int> cleanupExpiredRewards() async {
    try {
      final now = DateTime.now().toIso8601String();
      final count = await _database.delete(
        'referral_rewards',
        where: 'claimed = 0 AND expires_at <= ?',
        whereArgs: [now],
      );

      debugPrint('Cleaned up $count expired rewards');
      return count;
    } catch (e) {
      debugPrint('Error cleaning up expired rewards: $e');
      return 0;
    }
  }
}

/// Types of referral rewards
enum ReferralRewardType {
  freeScans,
  premiumDays,
  bonusCredits,
  discountPercent,
}
