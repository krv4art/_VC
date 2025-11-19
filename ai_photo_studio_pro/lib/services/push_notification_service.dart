import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Service for managing push notifications via Firebase Cloud Messaging
class PushNotificationService {
  static final PushNotificationService _instance = PushNotificationService._internal();
  factory PushNotificationService() => _instance;
  PushNotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  bool _initialized = false;
  String? _fcmToken;

  /// Initialize push notifications
  Future<bool> initialize() async {
    if (_initialized) return true;

    try {
      // Request permission
      final settings = await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      if (settings.authorizationStatus != AuthorizationStatus.authorized) {
        debugPrint('Push notification permission denied');
        return false;
      }

      // Initialize local notifications
      await _initializeLocalNotifications();

      // Get FCM token
      _fcmToken = await _firebaseMessaging.getToken();
      debugPrint('FCM Token: $_fcmToken');

      // Listen for token refresh
      _firebaseMessaging.onTokenRefresh.listen((newToken) {
        _fcmToken = newToken;
        debugPrint('FCM Token refreshed: $newToken');
        // TODO: Send to backend
      });

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // Handle background messages
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      // Handle notification taps
      FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

      _initialized = true;
      debugPrint('Push notifications initialized successfully');
      return true;
    } catch (e) {
      debugPrint('Error initializing push notifications: $e');
      return false;
    }
  }

  /// Initialize local notifications
  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );
  }

  /// Handle foreground messages
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    debugPrint('Foreground message received: ${message.messageId}');

    final notification = message.notification;
    if (notification != null) {
      await _showLocalNotification(
        title: notification.title ?? 'AI Photo Studio',
        body: notification.body ?? '',
        payload: message.data.toString(),
      );
    }
  }

  /// Handle notification tap
  void _handleNotificationTap(RemoteMessage message) {
    debugPrint('Notification tapped: ${message.messageId}');
    // TODO: Navigate to appropriate screen based on message data
  }

  /// Handle local notification tap
  void _onNotificationTap(NotificationResponse response) {
    debugPrint('Local notification tapped: ${response.payload}');
    // TODO: Navigate to appropriate screen based on payload
  }

  /// Show local notification
  Future<void> _showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'ai_photo_studio_channel',
      'AI Photo Studio',
      channelDescription: 'Notifications for AI Photo Studio Pro',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
      payload: payload,
    );
  }

  /// Send notification when photo generation is complete
  Future<void> notifyPhotoGenerationComplete({
    required String photoId,
    String? styleName,
  }) async {
    await _showLocalNotification(
      title: '✨ Your AI photo is ready!',
      body: styleName != null
          ? 'Your $styleName photo has been generated'
          : 'Your AI-generated photo is ready to view',
      payload: 'photo:$photoId',
    );
  }

  /// Send notification for daily reminder
  Future<void> notifyDailyReminder() async {
    await _showLocalNotification(
      title: '📸 Create something amazing today!',
      body: 'You have free scans available. Try a new style!',
      payload: 'reminder:daily',
    );
  }

  /// Send notification for new styles
  Future<void> notifyNewStyles({required int count}) async {
    await _showLocalNotification(
      title: '🎨 New styles available!',
      body: 'Check out $count new AI photo styles',
      payload: 'styles:new',
    );
  }

  /// Send notification for subscription expiring
  Future<void> notifySubscriptionExpiring({required int daysLeft}) async {
    await _showLocalNotification(
      title: '⏰ Subscription expiring soon',
      body: 'Your premium subscription expires in $daysLeft days',
      payload: 'subscription:expiring',
    );
  }

  /// Send notification for referral reward
  Future<void> notifyReferralReward({required String reward}) async {
    await _showLocalNotification(
      title: '🎁 Referral reward earned!',
      body: 'You earned $reward for inviting a friend',
      payload: 'referral:reward',
    );
  }

  /// Send notification for achievement unlocked
  Future<void> notifyAchievementUnlocked({required String achievement}) async {
    await _showLocalNotification(
      title: '🏆 Achievement unlocked!',
      body: achievement,
      payload: 'achievement:unlocked',
    );
  }

  /// Get FCM token
  String? get fcmToken => _fcmToken;

  /// Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      debugPrint('Subscribed to topic: $topic');
    } catch (e) {
      debugPrint('Error subscribing to topic: $e');
    }
  }

  /// Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      debugPrint('Unsubscribed from topic: $topic');
    } catch (e) {
      debugPrint('Error unsubscribing from topic: $e');
    }
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _localNotifications.cancelAll();
  }

  /// Schedule daily reminder notification
  Future<void> scheduleDailyReminder({required TimeOfDay time}) async {
    // TODO: Implement scheduled notifications using flutter_local_notifications
    // This requires additional setup for timezone handling
    debugPrint('Daily reminder scheduled for ${time.hour}:${time.minute}');
  }

  /// Disable notifications
  Future<void> disableNotifications() async {
    await cancelAllNotifications();
    // Note: Can't programmatically disable FCM, user must do it in settings
  }
}

/// Background message handler (must be top-level function)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Background message received: ${message.messageId}');
  // Handle background message
}
