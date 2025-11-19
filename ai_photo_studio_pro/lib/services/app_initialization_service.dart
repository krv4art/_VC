import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../services/gamification_service.dart';
import '../services/favorites_service.dart';
import '../services/referral_service.dart';
import '../services/analytics_service.dart';
import '../services/feedback_service.dart';
import '../services/push_notification_service.dart';
import '../services/offline_cache_service.dart';
import '../services/cloud_backup_service.dart';

/// Service to initialize all app services on startup
class AppInitializationService {
  static Future<void> initializeAllServices(Database database) async {
    debugPrint('🚀 Initializing all app services...');

    try {
      // Initialize database tables
      await _initializeDatabaseTables(database);

      // Initialize push notifications
      await _initializePushNotifications();

      // Initialize offline cache
      await _initializeOfflineCache();

      // Initialize cloud backup buckets
      await _initializeCloudBackup();

      debugPrint('✅ All services initialized successfully');
    } catch (e) {
      debugPrint('❌ Error initializing services: $e');
    }
  }

  static Future<void> _initializeDatabaseTables(Database db) async {
    debugPrint('📊 Initializing database tables...');

    // Create tables for all new services
    await GamificationService.createTables(db);
    await FavoritesService.createTable(db);
    await ReferralService.createTables(db);
    await AnalyticsService.createTables(db);
    await FeedbackService.createTables(db);

    debugPrint('✅ Database tables initialized');
  }

  static Future<void> _initializePushNotifications() async {
    debugPrint('🔔 Initializing push notifications...');

    try {
      final pushService = PushNotificationService();
      await pushService.initialize();

      // Subscribe to default topics
      await pushService.subscribeToTopic('all_users');

      debugPrint('✅ Push notifications initialized');
    } catch (e) {
      debugPrint('⚠️ Push notifications not initialized: $e');
      // Non-critical, continue anyway
    }
  }

  static Future<void> _initializeOfflineCache() async {
    debugPrint('💾 Initializing offline cache...');

    try {
      final cacheService = OfflineCacheService();
      await cacheService.initialize();

      debugPrint('✅ Offline cache initialized');
    } catch (e) {
      debugPrint('⚠️ Offline cache not initialized: $e');
    }
  }

  static Future<void> _initializeCloudBackup() async {
    debugPrint('☁️ Initializing cloud backup...');

    try {
      final cloudBackup = CloudBackupService();
      await cloudBackup.initializeBuckets();

      debugPrint('✅ Cloud backup initialized');
    } catch (e) {
      debugPrint('⚠️ Cloud backup not initialized: $e');
      // Non-critical if Supabase not configured
    }
  }

  /// Track app open in analytics
  static Future<void> trackAppOpen(Database database) async {
    try {
      final analyticsService = AnalyticsService(database);
      await analyticsService.trackAppOpen();

      final gamificationService = GamificationService(database);
      await gamificationService.updateDailyStreak();
    } catch (e) {
      debugPrint('Error tracking app open: $e');
    }
  }

  /// End current session in analytics
  static Future<void> endCurrentSession(Database database, int sessionId) async {
    try {
      final analyticsService = AnalyticsService(database);
      await analyticsService.endSession(sessionId);
    } catch (e) {
      debugPrint('Error ending session: $e');
    }
  }

  /// Clean up old data on app start
  static Future<void> cleanupOldData(Database database) async {
    debugPrint('🧹 Cleaning up old data...');

    try {
      // Clean old activity logs
      final analyticsService = AnalyticsService(database);
      await analyticsService.cleanOldActivityLogs(daysToKeep: 90);

      // Clean old cache files
      final cacheService = OfflineCacheService();
      await cacheService.cleanOldCache(daysToKeep: 30);

      // Clean expired referral rewards
      final referralService = ReferralService(database);
      await referralService.cleanupExpiredRewards();

      debugPrint('✅ Old data cleaned up');
    } catch (e) {
      debugPrint('⚠️ Error cleaning up old data: $e');
    }
  }

  /// Initialize tutorial for first-time users
  static Future<bool> shouldShowTutorial() async {
    try {
      // Check if this is first launch
      // Implementation depends on tutorial service
      return false; // Placeholder
    } catch (e) {
      debugPrint('Error checking tutorial status: $e');
      return false;
    }
  }
}
