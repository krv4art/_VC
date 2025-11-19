import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

/// Service for tracking and analyzing user activity
class AnalyticsService {
  final Database _database;

  AnalyticsService(this._database);

  /// Initialize analytics tables
  static Future<void> createTables(Database db) async {
    // User statistics table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS user_statistics (
        id INTEGER PRIMARY KEY CHECK (id = 1),
        total_photos_generated INTEGER NOT NULL DEFAULT 0,
        total_photos_saved INTEGER NOT NULL DEFAULT 0,
        total_photos_shared INTEGER NOT NULL DEFAULT 0,
        total_photos_deleted INTEGER NOT NULL DEFAULT 0,
        total_app_opens INTEGER NOT NULL DEFAULT 0,
        total_time_spent_seconds INTEGER NOT NULL DEFAULT 0,
        favorite_style_id TEXT,
        last_app_open TEXT,
        first_app_open TEXT,
        created_at TEXT NOT NULL
      )
    ''');

    // Activity log table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS activity_log (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        event_type TEXT NOT NULL,
        event_data TEXT,
        screen_name TEXT,
        timestamp TEXT NOT NULL
      )
    ''');

    // Style usage table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS style_usage (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        style_id TEXT NOT NULL,
        style_name TEXT,
        times_used INTEGER NOT NULL DEFAULT 1,
        last_used TEXT NOT NULL
      )
    ''');

    // Session tracking table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS app_sessions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        session_start TEXT NOT NULL,
        session_end TEXT,
        duration_seconds INTEGER,
        photos_generated INTEGER NOT NULL DEFAULT 0,
        screens_visited TEXT
      )
    ''');

    // Initialize user statistics
    await db.insert(
      'user_statistics',
      {
        'id': 1,
        'total_photos_generated': 0,
        'total_photos_saved': 0,
        'total_photos_shared': 0,
        'total_photos_deleted': 0,
        'total_app_opens': 0,
        'total_time_spent_seconds': 0,
        'first_app_open': DateTime.now().toIso8601String(),
        'created_at': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  /// Track app open
  Future<int?> trackAppOpen() async {
    try {
      final now = DateTime.now().toIso8601String();

      // Update statistics
      await _database.rawUpdate('''
        UPDATE user_statistics
        SET total_app_opens = total_app_opens + 1,
            last_app_open = ?
        WHERE id = 1
      ''', [now]);

      // Create new session
      final sessionId = await _database.insert('app_sessions', {
        'session_start': now,
        'photos_generated': 0,
      });

      // Log event
      await _logEvent('app_open', null, null);

      return sessionId;
    } catch (e) {
      debugPrint('Error tracking app open: $e');
      return null;
    }
  }

  /// End current session
  Future<void> endSession(int sessionId, {List<String>? screensVisited}) async {
    try {
      final session = await _database.query(
        'app_sessions',
        where: 'id = ?',
        whereArgs: [sessionId],
      );

      if (session.isEmpty) return;

      final startTime = DateTime.parse(session.first['session_start'] as String);
      final endTime = DateTime.now();
      final duration = endTime.difference(startTime).inSeconds;

      await _database.update(
        'app_sessions',
        {
          'session_end': endTime.toIso8601String(),
          'duration_seconds': duration,
          'screens_visited': screensVisited?.join(','),
        },
        where: 'id = ?',
        whereArgs: [sessionId],
      );

      // Update total time spent
      await _database.rawUpdate('''
        UPDATE user_statistics
        SET total_time_spent_seconds = total_time_spent_seconds + ?
        WHERE id = 1
      ''', [duration]);
    } catch (e) {
      debugPrint('Error ending session: $e');
    }
  }

  /// Track photo generation
  Future<void> trackPhotoGeneration(String styleId, String? styleName) async {
    try {
      // Update statistics
      await _database.rawUpdate('''
        UPDATE user_statistics
        SET total_photos_generated = total_photos_generated + 1
        WHERE id = 1
      ''');

      // Update style usage
      await _updateStyleUsage(styleId, styleName);

      // Log event
      await _logEvent('photo_generated', 'style_id:$styleId', null);

      // Update current session
      await _database.rawUpdate('''
        UPDATE app_sessions
        SET photos_generated = photos_generated + 1
        WHERE session_end IS NULL
      ''');
    } catch (e) {
      debugPrint('Error tracking photo generation: $e');
    }
  }

  /// Track photo saved
  Future<void> trackPhotoSaved() async {
    try {
      await _database.rawUpdate('''
        UPDATE user_statistics
        SET total_photos_saved = total_photos_saved + 1
        WHERE id = 1
      ''');

      await _logEvent('photo_saved', null, null);
    } catch (e) {
      debugPrint('Error tracking photo saved: $e');
    }
  }

  /// Track photo shared
  Future<void> trackPhotoShared(String platform) async {
    try {
      await _database.rawUpdate('''
        UPDATE user_statistics
        SET total_photos_shared = total_photos_shared + 1
        WHERE id = 1
      ''');

      await _logEvent('photo_shared', 'platform:$platform', null);
    } catch (e) {
      debugPrint('Error tracking photo shared: $e');
    }
  }

  /// Track photo deleted
  Future<void> trackPhotoDeleted() async {
    try {
      await _database.rawUpdate('''
        UPDATE user_statistics
        SET total_photos_deleted = total_photos_deleted + 1
        WHERE id = 1
      ''');

      await _logEvent('photo_deleted', null, null);
    } catch (e) {
      debugPrint('Error tracking photo deleted: $e');
    }
  }

  /// Track screen view
  Future<void> trackScreenView(String screenName) async {
    try {
      await _logEvent('screen_view', null, screenName);
    } catch (e) {
      debugPrint('Error tracking screen view: $e');
    }
  }

  /// Update style usage
  Future<void> _updateStyleUsage(String styleId, String? styleName) async {
    try {
      final existing = await _database.query(
        'style_usage',
        where: 'style_id = ?',
        whereArgs: [styleId],
      );

      if (existing.isEmpty) {
        await _database.insert('style_usage', {
          'style_id': styleId,
          'style_name': styleName,
          'times_used': 1,
          'last_used': DateTime.now().toIso8601String(),
        });
      } else {
        await _database.rawUpdate('''
          UPDATE style_usage
          SET times_used = times_used + 1,
              last_used = ?
          WHERE style_id = ?
        ''', [DateTime.now().toIso8601String(), styleId]);
      }

      // Update favorite style (most used)
      await _updateFavoriteStyle();
    } catch (e) {
      debugPrint('Error updating style usage: $e');
    }
  }

  /// Update favorite style based on usage
  Future<void> _updateFavoriteStyle() async {
    try {
      final result = await _database.query(
        'style_usage',
        orderBy: 'times_used DESC',
        limit: 1,
      );

      if (result.isNotEmpty) {
        final favoriteStyleId = result.first['style_id'] as String;
        await _database.update(
          'user_statistics',
          {'favorite_style_id': favoriteStyleId},
          where: 'id = 1',
        );
      }
    } catch (e) {
      debugPrint('Error updating favorite style: $e');
    }
  }

  /// Log event
  Future<void> _logEvent(String eventType, String? eventData, String? screenName) async {
    try {
      await _database.insert('activity_log', {
        'event_type': eventType,
        'event_data': eventData,
        'screen_name': screenName,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      debugPrint('Error logging event: $e');
    }
  }

  /// Get user statistics
  Future<Map<String, dynamic>?> getUserStatistics() async {
    try {
      final result = await _database.query('user_statistics', where: 'id = 1');
      return result.isNotEmpty ? result.first : null;
    } catch (e) {
      debugPrint('Error getting user statistics: $e');
      return null;
    }
  }

  /// Get style usage statistics
  Future<List<Map<String, dynamic>>> getStyleUsageStats() async {
    try {
      return await _database.query(
        'style_usage',
        orderBy: 'times_used DESC',
      );
    } catch (e) {
      debugPrint('Error getting style usage stats: $e');
      return [];
    }
  }

  /// Get activity timeline
  Future<List<Map<String, dynamic>>> getActivityTimeline({int limit = 50}) async {
    try {
      return await _database.query(
        'activity_log',
        orderBy: 'timestamp DESC',
        limit: limit,
      );
    } catch (e) {
      debugPrint('Error getting activity timeline: $e');
      return [];
    }
  }

  /// Get recent sessions
  Future<List<Map<String, dynamic>>> getRecentSessions({int limit = 10}) async {
    try {
      return await _database.query(
        'app_sessions',
        where: 'session_end IS NOT NULL',
        orderBy: 'session_start DESC',
        limit: limit,
      );
    } catch (e) {
      debugPrint('Error getting recent sessions: $e');
      return [];
    }
  }

  /// Get average session duration
  Future<int> getAverageSessionDuration() async {
    try {
      final result = await _database.rawQuery('''
        SELECT AVG(duration_seconds) as avg_duration
        FROM app_sessions
        WHERE duration_seconds IS NOT NULL
      ''');

      return (result.first['avg_duration'] as num?)?.toInt() ?? 0;
    } catch (e) {
      debugPrint('Error getting average session duration: $e');
      return 0;
    }
  }

  /// Get photos generated per day average
  Future<double> getPhotosPerDayAverage() async {
    try {
      final stats = await getUserStatistics();
      if (stats == null) return 0;

      final firstOpen = DateTime.parse(stats['first_app_open'] as String);
      final daysSinceFirstOpen = DateTime.now().difference(firstOpen).inDays + 1;
      final totalPhotos = stats['total_photos_generated'] as int;

      return totalPhotos / daysSinceFirstOpen;
    } catch (e) {
      debugPrint('Error calculating photos per day: $e');
      return 0;
    }
  }

  /// Get engagement score (0-100)
  Future<int> getEngagementScore() async {
    try {
      final stats = await getUserStatistics();
      if (stats == null) return 0;

      final totalOpens = stats['total_app_opens'] as int;
      final totalPhotos = stats['total_photos_generated'] as int;
      final totalShares = stats['total_photos_shared'] as int;
      final avgSession = await getAverageSessionDuration();

      // Simple scoring algorithm
      int score = 0;
      score += (totalPhotos * 2).clamp(0, 30); // Max 30 points for photos
      score += (totalShares * 3).clamp(0, 20); // Max 20 points for shares
      score += (totalOpens).clamp(0, 25); // Max 25 points for opens
      score += ((avgSession / 60) * 5).toInt().clamp(0, 25); // Max 25 points for session time

      return score.clamp(0, 100);
    } catch (e) {
      debugPrint('Error calculating engagement score: $e');
      return 0;
    }
  }

  /// Format time duration for display
  String formatDuration(int seconds) {
    if (seconds < 60) return '${seconds}s';
    if (seconds < 3600) return '${(seconds / 60).floor()}m';
    return '${(seconds / 3600).toStringAsFixed(1)}h';
  }

  /// Clean old activity logs (keep last 90 days)
  Future<int> cleanOldActivityLogs({int daysToKeep = 90}) async {
    try {
      final cutoffDate = DateTime.now().subtract(Duration(days: daysToKeep));
      final count = await _database.delete(
        'activity_log',
        where: 'timestamp < ?',
        whereArgs: [cutoffDate.toIso8601String()],
      );

      debugPrint('Cleaned $count old activity logs');
      return count;
    } catch (e) {
      debugPrint('Error cleaning old logs: $e');
      return 0;
    }
  }
}
