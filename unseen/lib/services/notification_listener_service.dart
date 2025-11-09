import 'dart:async';
import 'package:flutter/services.dart';
import '../models/notification_data.dart';

/// Flutter service for interacting with Android NotificationListenerService
class NotificationListenerService {
  static const MethodChannel _methodChannel =
      MethodChannel('unseen/notifications/methods');
  static const EventChannel _eventChannel =
      EventChannel('unseen/notifications/events');

  /// Stream of incoming notifications
  Stream<NotificationData>? _notificationStream;

  /// Initialize the notification listener
  Future<bool> initialize() async {
    try {
      final result = await _methodChannel.invokeMethod<bool>('initialize');
      return result ?? false;
    } on PlatformException catch (e) {
      print('Failed to initialize notification listener: ${e.message}');
      return false;
    }
  }

  /// Check if notification access permission is granted
  Future<bool> isPermissionGranted() async {
    try {
      final result =
          await _methodChannel.invokeMethod<bool>('isPermissionGranted');
      return result ?? false;
    } on PlatformException catch (e) {
      print('Failed to check permission: ${e.message}');
      return false;
    }
  }

  /// Open notification access settings
  Future<void> openPermissionSettings() async {
    try {
      await _methodChannel.invokeMethod('openPermissionSettings');
    } on PlatformException catch (e) {
      print('Failed to open settings: ${e.message}');
    }
  }

  /// Start listening to notifications
  Future<bool> startListening() async {
    try {
      final result = await _methodChannel.invokeMethod<bool>('startListening');
      return result ?? false;
    } on PlatformException catch (e) {
      print('Failed to start listening: ${e.message}');
      return false;
    }
  }

  /// Stop listening to notifications
  Future<void> stopListening() async {
    try {
      await _methodChannel.invokeMethod('stopListening');
    } on PlatformException catch (e) {
      print('Failed to stop listening: ${e.message}');
    }
  }

  /// Get stream of notification events
  Stream<NotificationData> getNotificationStream() {
    _notificationStream ??= _eventChannel
        .receiveBroadcastStream()
        .map((event) => NotificationData.fromPlatform(event as Map<String, dynamic>));

    return _notificationStream!;
  }

  /// Check if a specific messenger is supported
  Future<bool> isMessengerSupported(String packageName) async {
    try {
      final result = await _methodChannel.invokeMethod<bool>(
        'isMessengerSupported',
        {'packageName': packageName},
      );
      return result ?? false;
    } on PlatformException catch (e) {
      print('Failed to check messenger support: ${e.message}');
      return false;
    }
  }

  /// Get list of installed supported messengers
  Future<List<String>> getInstalledMessengers() async {
    try {
      final result = await _methodChannel.invokeMethod<List<dynamic>>(
        'getInstalledMessengers',
      );
      return result?.cast<String>() ?? [];
    } on PlatformException catch (e) {
      print('Failed to get installed messengers: ${e.message}');
      return [];
    }
  }

  /// Dispose resources
  void dispose() {
    stopListening();
  }
}
