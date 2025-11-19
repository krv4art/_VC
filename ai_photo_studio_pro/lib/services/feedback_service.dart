import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:io';

/// Service for user feedback and bug reporting
class FeedbackService {
  final Database _database;
  final SupabaseClient _supabase = Supabase.instance.client;

  FeedbackService(this._database);

  /// Initialize feedback tables
  static Future<void> createTables(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS feedback_submissions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT NOT NULL,
        category TEXT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        rating INTEGER,
        device_info TEXT,
        app_version TEXT,
        submitted_at TEXT NOT NULL,
        synced INTEGER NOT NULL DEFAULT 0,
        synced_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS bug_reports (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        steps_to_reproduce TEXT,
        expected_behavior TEXT,
        actual_behavior TEXT,
        severity TEXT,
        screenshot_path TEXT,
        device_info TEXT,
        app_version TEXT,
        reported_at TEXT NOT NULL,
        synced INTEGER NOT NULL DEFAULT 0,
        synced_at TEXT
      )
    ''');
  }

  /// Submit general feedback
  Future<int?> submitFeedback({
    required FeedbackType type,
    String? category,
    required String title,
    required String description,
    int? rating,
  }) async {
    try {
      final deviceInfo = await _getDeviceInfo();
      final appVersion = await _getAppVersion();

      final feedbackId = await _database.insert('feedback_submissions', {
        'type': type.name,
        'category': category,
        'title': title,
        'description': description,
        'rating': rating,
        'device_info': deviceInfo,
        'app_version': appVersion,
        'submitted_at': DateTime.now().toIso8601String(),
        'synced': 0,
      });

      debugPrint('Feedback submitted: $feedbackId');

      // Sync to backend asynchronously
      _syncFeedbackToBackend(feedbackId);

      return feedbackId;
    } catch (e) {
      debugPrint('Error submitting feedback: $e');
      return null;
    }
  }

  /// Submit bug report
  Future<int?> submitBugReport({
    required String title,
    required String description,
    String? stepsToReproduce,
    String? expectedBehavior,
    String? actualBehavior,
    BugSeverity severity = BugSeverity.medium,
    String? screenshotPath,
  }) async {
    try {
      final deviceInfo = await _getDeviceInfo();
      final appVersion = await _getAppVersion();

      final bugId = await _database.insert('bug_reports', {
        'title': title,
        'description': description,
        'steps_to_reproduce': stepsToReproduce,
        'expected_behavior': expectedBehavior,
        'actual_behavior': actualBehavior,
        'severity': severity.name,
        'screenshot_path': screenshotPath,
        'device_info': deviceInfo,
        'app_version': appVersion,
        'reported_at': DateTime.now().toIso8601String(),
        'synced': 0,
      });

      debugPrint('Bug report submitted: $bugId');

      // Sync to backend asynchronously
      _syncBugReportToBackend(bugId);

      return bugId;
    } catch (e) {
      debugPrint('Error submitting bug report: $e');
      return null;
    }
  }

  /// Get device information
  Future<String> _getDeviceInfo() async {
    try {
      final deviceInfo = DeviceInfoPlugin();

      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        return '''
Platform: Android
Model: ${androidInfo.model}
Manufacturer: ${androidInfo.manufacturer}
Android Version: ${androidInfo.version.release}
SDK: ${androidInfo.version.sdkInt}
Brand: ${androidInfo.brand}
''';
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        return '''
Platform: iOS
Model: ${iosInfo.model}
Name: ${iosInfo.name}
System Version: ${iosInfo.systemVersion}
Identifer: ${iosInfo.identifierForVendor}
''';
      }

      return 'Unknown platform';
    } catch (e) {
      debugPrint('Error getting device info: $e');
      return 'Error retrieving device info';
    }
  }

  /// Get app version
  Future<String> _getAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      return '${packageInfo.version} (${packageInfo.buildNumber})';
    } catch (e) {
      debugPrint('Error getting app version: $e');
      return 'Unknown';
    }
  }

  /// Sync feedback to backend
  Future<void> _syncFeedbackToBackend(int feedbackId) async {
    try {
      final feedback = await _database.query(
        'feedback_submissions',
        where: 'id = ?',
        whereArgs: [feedbackId],
      );

      if (feedback.isEmpty) return;

      final data = feedback.first;

      // Send to Supabase
      await _supabase.from('feedback').insert({
        'type': data['type'],
        'category': data['category'],
        'title': data['title'],
        'description': data['description'],
        'rating': data['rating'],
        'device_info': data['device_info'],
        'app_version': data['app_version'],
        'submitted_at': data['submitted_at'],
      });

      // Mark as synced
      await _database.update(
        'feedback_submissions',
        {
          'synced': 1,
          'synced_at': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [feedbackId],
      );

      debugPrint('Feedback synced to backend: $feedbackId');
    } catch (e) {
      debugPrint('Error syncing feedback to backend: $e');
    }
  }

  /// Sync bug report to backend
  Future<void> _syncBugReportToBackend(int bugId) async {
    try {
      final bug = await _database.query(
        'bug_reports',
        where: 'id = ?',
        whereArgs: [bugId],
      );

      if (bug.isEmpty) return;

      final data = bug.first;

      // Send to Supabase
      await _supabase.from('bug_reports').insert({
        'title': data['title'],
        'description': data['description'],
        'steps_to_reproduce': data['steps_to_reproduce'],
        'expected_behavior': data['expected_behavior'],
        'actual_behavior': data['actual_behavior'],
        'severity': data['severity'],
        'device_info': data['device_info'],
        'app_version': data['app_version'],
        'reported_at': data['reported_at'],
      });

      // Upload screenshot if exists
      if (data['screenshot_path'] != null) {
        await _uploadScreenshot(bugId, data['screenshot_path'] as String);
      }

      // Mark as synced
      await _database.update(
        'bug_reports',
        {
          'synced': 1,
          'synced_at': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [bugId],
      );

      debugPrint('Bug report synced to backend: $bugId');
    } catch (e) {
      debugPrint('Error syncing bug report to backend: $e');
    }
  }

  /// Upload screenshot for bug report
  Future<void> _uploadScreenshot(int bugId, String screenshotPath) async {
    try {
      final file = File(screenshotPath);
      if (!await file.exists()) return;

      final fileName = 'bug_$bugId.png';
      await _supabase.storage.from('bug-screenshots').upload(fileName, file);

      debugPrint('Screenshot uploaded for bug: $bugId');
    } catch (e) {
      debugPrint('Error uploading screenshot: $e');
    }
  }

  /// Get all feedback submissions
  Future<List<Map<String, dynamic>>> getAllFeedback() async {
    try {
      return await _database.query(
        'feedback_submissions',
        orderBy: 'submitted_at DESC',
      );
    } catch (e) {
      debugPrint('Error getting feedback: $e');
      return [];
    }
  }

  /// Get all bug reports
  Future<List<Map<String, dynamic>>> getAllBugReports() async {
    try {
      return await _database.query(
        'bug_reports',
        orderBy: 'reported_at DESC',
      );
    } catch (e) {
      debugPrint('Error getting bug reports: $e');
      return [];
    }
  }

  /// Get unsynced feedback count
  Future<int> getUnsyncedFeedbackCount() async {
    try {
      final result = await _database.rawQuery('''
        SELECT COUNT(*) as count
        FROM feedback_submissions
        WHERE synced = 0
      ''');
      return result.first['count'] as int;
    } catch (e) {
      debugPrint('Error getting unsynced feedback count: $e');
      return 0;
    }
  }

  /// Get unsynced bug reports count
  Future<int> getUnsyncedBugReportsCount() async {
    try {
      final result = await _database.rawQuery('''
        SELECT COUNT(*) as count
        FROM bug_reports
        WHERE synced = 0
      ''');
      return result.first['count'] as int;
    } catch (e) {
      debugPrint('Error getting unsynced bug reports count: $e');
      return 0;
    }
  }

  /// Sync all unsynced feedback and bug reports
  Future<void> syncAll() async {
    try {
      // Sync feedback
      final unsyncedFeedback = await _database.query(
        'feedback_submissions',
        where: 'synced = 0',
      );

      for (final feedback in unsyncedFeedback) {
        await _syncFeedbackToBackend(feedback['id'] as int);
      }

      // Sync bug reports
      final unsyncedBugs = await _database.query(
        'bug_reports',
        where: 'synced = 0',
      );

      for (final bug in unsyncedBugs) {
        await _syncBugReportToBackend(bug['id'] as int);
      }

      debugPrint('All feedback and bug reports synced');
    } catch (e) {
      debugPrint('Error syncing all: $e');
    }
  }

  /// Get feedback statistics
  Future<Map<String, dynamic>> getFeedbackStatistics() async {
    try {
      final totalFeedback = await _database.rawQuery(
        'SELECT COUNT(*) as count FROM feedback_submissions',
      );

      final totalBugs = await _database.rawQuery(
        'SELECT COUNT(*) as count FROM bug_reports',
      );

      final avgRating = await _database.rawQuery('''
        SELECT AVG(rating) as avg_rating
        FROM feedback_submissions
        WHERE rating IS NOT NULL
      ''');

      return {
        'total_feedback': totalFeedback.first['count'],
        'total_bug_reports': totalBugs.first['count'],
        'average_rating': avgRating.first['avg_rating'] ?? 0,
        'unsynced_feedback': await getUnsyncedFeedbackCount(),
        'unsynced_bugs': await getUnsyncedBugReportsCount(),
      };
    } catch (e) {
      debugPrint('Error getting feedback statistics: $e');
      return {};
    }
  }
}

/// Feedback types
enum FeedbackType {
  general,
  feature_request,
  improvement,
  complaint,
  praise,
}

/// Bug severity levels
enum BugSeverity {
  low,
  medium,
  high,
  critical,
}
