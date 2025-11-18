import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Notification/Reminder service
/// Note: For full functionality, add flutter_local_notifications package
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  bool _initialized = false;
  bool _remindersEnabled = true;
  NotificationTime _reminderTime = const NotificationTime(hour: 19, minute: 0); // 7 PM

  bool get remindersEnabled => _remindersEnabled;
  NotificationTime get reminderTime => _reminderTime;

  /// Initialize notification service
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      _remindersEnabled = prefs.getBool('reminders_enabled') ?? true;

      final hour = prefs.getInt('reminder_hour') ?? 19;
      final minute = prefs.getInt('reminder_minute') ?? 0;
      _reminderTime = NotificationTime(hour: hour, minute: minute);

      _initialized = true;
      debugPrint('✅ NotificationService initialized');
    } catch (e) {
      debugPrint('❌ NotificationService initialization failed: $e');
    }
  }

  /// Enable/disable reminders
  Future<void> setRemindersEnabled(bool enabled) async {
    _remindersEnabled = enabled;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('reminders_enabled', enabled);

    if (enabled) {
      await _scheduleReminders();
    } else {
      await _cancelReminders();
    }
  }

  /// Set reminder time
  Future<void> setReminderTime(NotificationTime time) async {
    _reminderTime = time;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('reminder_hour', time.hour);
    await prefs.setInt('reminder_minute', time.minute);

    if (_remindersEnabled) {
      await _scheduleReminders();
    }
  }

  /// Schedule reminders
  Future<void> _scheduleReminders() async {
    // TODO: Implement with flutter_local_notifications
    debugPrint('📅 Scheduling reminders for ${_reminderTime.hour}:${_reminderTime.minute}');

    // Example implementation:
    // await flutterLocalNotificationsPlugin.zonedSchedule(
    //   0,
    //   'Time to practice! 🎓',
    //   'Keep your streak going!',
    //   _nextInstanceOfTime(_reminderTime),
    //   notificationDetails,
    //   androidAllowWhileIdle: true,
    //   uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    //   matchDateTimeComponents: DateTimeComponents.time,
    // );
  }

  /// Cancel all reminders
  Future<void> _cancelReminders() async {
    // TODO: Implement with flutter_local_notifications
    debugPrint('🔕 Cancelling all reminders');

    // Example:
    // await flutterLocalNotificationsPlugin.cancelAll();
  }

  /// Show streak reminder
  Future<void> showStreakReminder(int currentStreak) async {
    if (!_remindersEnabled) return;

    debugPrint('🔥 Showing streak reminder: $currentStreak days');

    // TODO: Show notification
    // await flutterLocalNotificationsPlugin.show(
    //   1,
    //   'Keep your streak! 🔥',
    //   'You\'re on a $currentStreak day streak! Don\'t break it!',
    //   notificationDetails,
    // );
  }

  /// Show daily challenge reminder
  Future<void> showDailyChallengeReminder() async {
    if (!_remindersEnabled) return;

    debugPrint('🎯 Showing daily challenge reminder');

    // TODO: Show notification
  }

  /// Show achievement unlocked notification
  Future<void> showAchievementUnlocked(String achievementName, String emoji) async {
    debugPrint('🏆 Achievement unlocked: $emoji $achievementName');

    // TODO: Show notification
    // await flutterLocalNotificationsPlugin.show(
    //   2,
    //   'Achievement Unlocked! 🏆',
    //   '$emoji $achievementName',
    //   notificationDetails,
    // );
  }

  /// Show weekly report notification
  Future<void> showWeeklyReportReady() async {
    if (!_remindersEnabled) return;

    debugPrint('📊 Weekly report ready');

    // TODO: Show notification
  }
}

class NotificationTime {
  final int hour;
  final int minute;

  const NotificationTime({required this.hour, required this.minute});

  @override
  String toString() => '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
}
