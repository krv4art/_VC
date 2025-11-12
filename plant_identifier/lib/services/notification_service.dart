import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import '../config/app_config.dart';

/// Service for scheduling care reminders and notifications
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  /// Initialize notification service
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      // Android initialization settings
      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

      // iOS initialization settings
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      // Combined initialization settings
      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      // Initialize
      await _notifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      _initialized = true;
      debugPrint('NotificationService initialized successfully');
    } catch (e) {
      debugPrint('Error initializing NotificationService: $e');
    }
  }

  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    debugPrint('Notification tapped: ${response.payload}');
    // Here you can add navigation logic based on payload
  }

  /// Schedule a watering reminder
  Future<void> scheduleWateringReminder({
    required String plantName,
    required Duration frequency,
    String? plantId,
  }) async {
    if (!AppConfig().enableNotifications) {
      debugPrint('Notifications disabled in config');
      return;
    }

    if (!_initialized) await initialize();

    try {
      final id = plantId?.hashCode ?? plantName.hashCode;
      final scheduledDate = DateTime.now().add(frequency);

      await _notifications.zonedSchedule(
        id,
        'Watering Reminder',
        'Time to water your $plantName! 💧',
        tz.TZDateTime.from(scheduledDate, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'watering_reminders',
            'Watering Reminders',
            channelDescription: 'Reminders to water your plants',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: 'watering_$plantId',
      );

      debugPrint(
          'Scheduled watering reminder for $plantName (ID: $id) at $scheduledDate');
    } catch (e) {
      debugPrint('Error scheduling watering reminder: $e');
    }
  }

  /// Schedule a fertilizing reminder
  Future<void> scheduleFertilizingReminder({
    required String plantName,
    required Duration frequency,
    String? plantId,
  }) async {
    if (!AppConfig().enableNotifications) {
      debugPrint('Notifications disabled in config');
      return;
    }

    if (!_initialized) await initialize();

    try {
      final id = (plantId?.hashCode ?? plantName.hashCode) + 1000;
      final scheduledDate = DateTime.now().add(frequency);

      await _notifications.zonedSchedule(
        id,
        'Fertilizing Reminder',
        'Time to fertilize your $plantName! 🌱',
        tz.TZDateTime.from(scheduledDate, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'fertilizing_reminders',
            'Fertilizing Reminders',
            channelDescription: 'Reminders to fertilize your plants',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: 'fertilizing_$plantId',
      );

      debugPrint(
          'Scheduled fertilizing reminder for $plantName (ID: $id) at $scheduledDate');
    } catch (e) {
      debugPrint('Error scheduling fertilizing reminder: $e');
    }
  }

  /// Schedule a general care reminder
  Future<void> scheduleCareReminder({
    required String plantName,
    required String reminderType,
    required DateTime scheduledTime,
    String? plantId,
  }) async {
    if (!AppConfig().enableNotifications) {
      debugPrint('Notifications disabled in config');
      return;
    }

    if (!_initialized) await initialize();

    try {
      final id = (plantId?.hashCode ?? plantName.hashCode) + 2000;

      await _notifications.zonedSchedule(
        id,
        'Plant Care Reminder',
        '$reminderType for $plantName 🌿',
        tz.TZDateTime.from(scheduledTime, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'care_reminders',
            'Plant Care Reminders',
            channelDescription: 'General plant care reminders',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: 'care_${plantId}_$reminderType',
      );

      debugPrint(
          'Scheduled $reminderType reminder for $plantName (ID: $id) at $scheduledTime');
    } catch (e) {
      debugPrint('Error scheduling care reminder: $e');
    }
  }

  /// Show immediate notification
  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    if (!AppConfig().enableNotifications) return;
    if (!_initialized) await initialize();

    try {
      await _notifications.show(
        DateTime.now().millisecondsSinceEpoch.remainder(100000),
        title,
        body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'general_notifications',
            'General Notifications',
            channelDescription: 'General app notifications',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: payload,
      );

      debugPrint('Showed notification: $title');
    } catch (e) {
      debugPrint('Error showing notification: $e');
    }
  }

  /// Cancel all reminders for a specific plant
  Future<void> cancelPlantReminders(String plantId) async {
    try {
      final baseId = plantId.hashCode;
      await _notifications.cancel(baseId); // Watering
      await _notifications.cancel(baseId + 1000); // Fertilizing
      await _notifications.cancel(baseId + 2000); // General care

      debugPrint('Cancelled all reminders for plant: $plantId');
    } catch (e) {
      debugPrint('Error cancelling plant reminders: $e');
    }
  }

  /// Cancel all reminders
  Future<void> cancelAllReminders() async {
    try {
      await _notifications.cancelAll();
      debugPrint('Cancelled all reminders');
    } catch (e) {
      debugPrint('Error cancelling all reminders: $e');
    }
  }

  /// Check if notifications are enabled
  Future<bool> areNotificationsEnabled() async {
    if (!_initialized) await initialize();

    try {
      if (defaultTargetPlatform == TargetPlatform.android) {
        final result = await _notifications
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.areNotificationsEnabled();
        return result ?? false;
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        final result = await _notifications
            .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin>()
            ?.requestPermissions(
              alert: true,
              badge: true,
              sound: true,
            );
        return result ?? false;
      }
      return false;
    } catch (e) {
      debugPrint('Error checking notification permissions: $e');
      return false;
    }
  }

  /// Request notification permissions
  Future<bool> requestPermissions() async {
    if (!_initialized) await initialize();

    try {
      if (defaultTargetPlatform == TargetPlatform.android) {
        final result = await _notifications
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.requestNotificationsPermission();
        debugPrint('Android notification permission: $result');
        return result ?? false;
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        final result = await _notifications
            .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin>()
            ?.requestPermissions(
              alert: true,
              badge: true,
              sound: true,
            );
        debugPrint('iOS notification permission: $result');
        return result ?? false;
      }
      return false;
    } catch (e) {
      debugPrint('Error requesting notification permissions: $e');
      return false;
    }
  }

  /// Get pending notifications
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    if (!_initialized) await initialize();

    try {
      return await _notifications.pendingNotificationRequests();
    } catch (e) {
      debugPrint('Error getting pending notifications: $e');
      return [];
    }
  }
}
