import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

/// Service for analytics and crash reporting
class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;

  /// Initialize analytics and crashlytics
  Future<void> initialize() async {
    // Set analytics collection enabled
    await _analytics.setAnalyticsCollectionEnabled(!kDebugMode);

    // Configure crashlytics
    FlutterError.onError = _crashlytics.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stack) {
      _crashlytics.recordError(error, stack, fatal: true);
      return true;
    };
  }

  /// Log custom event
  Future<void> logEvent({
    required String name,
    Map<String, dynamic>? parameters,
  }) async {
    try {
      await _analytics.logEvent(
        name: name,
        parameters: parameters,
      );
    } catch (e) {
      debugPrint('Failed to log analytics event: $e');
    }
  }

  /// Log screen view
  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    try {
      await _analytics.logScreenView(
        screenName: screenName,
        screenClass: screenClass,
      );
    } catch (e) {
      debugPrint('Failed to log screen view: $e');
    }
  }

  /// Log image processing event
  Future<void> logImageProcessing({
    required String mode,
    required bool isPremium,
    required int processingTimeMs,
  }) async {
    await logEvent(
      name: 'image_processed',
      parameters: {
        'processing_mode': mode,
        'is_premium': isPremium,
        'processing_time_ms': processingTimeMs,
      },
    );
  }

  /// Log background applied
  Future<void> logBackgroundApplied({
    required String backgroundType,
    required String backgroundId,
  }) async {
    await logEvent(
      name: 'background_applied',
      parameters: {
        'background_type': backgroundType,
        'background_id': backgroundId,
      },
    );
  }

  /// Log filter applied
  Future<void> logFilterApplied({
    required String filterName,
  }) async {
    await logEvent(
      name: 'filter_applied',
      parameters: {
        'filter_name': filterName,
      },
    );
  }

  /// Log subscription event
  Future<void> logSubscription({
    required String plan,
    required double price,
    required String currency,
  }) async {
    await _analytics.logPurchase(
      currency: currency,
      value: price,
      parameters: {
        'subscription_plan': plan,
      },
    );
  }

  /// Log share event
  Future<void> logShare({
    required String contentType,
    required String method,
  }) async {
    await _analytics.logShare(
      contentType: contentType,
      method: method,
      itemId: 'processed_image',
    );
  }

  /// Set user properties
  Future<void> setUserProperties({
    required bool isPremium,
    String? language,
  }) async {
    try {
      await _analytics.setUserProperty(
        name: 'is_premium',
        value: isPremium.toString(),
      );

      if (language != null) {
        await _analytics.setUserProperty(
          name: 'preferred_language',
          value: language,
        );
      }
    } catch (e) {
      debugPrint('Failed to set user properties: $e');
    }
  }

  /// Log error to Crashlytics
  Future<void> logError(
    dynamic exception,
    StackTrace? stackTrace, {
    String? reason,
    bool fatal = false,
  }) async {
    try {
      await _crashlytics.recordError(
        exception,
        stackTrace,
        reason: reason,
        fatal: fatal,
      );
    } catch (e) {
      debugPrint('Failed to log error to Crashlytics: $e');
    }
  }

  /// Set custom key for crashlytics
  Future<void> setCustomKey(String key, dynamic value) async {
    try {
      await _crashlytics.setCustomKey(key, value);
    } catch (e) {
      debugPrint('Failed to set custom key: $e');
    }
  }

  /// Log breadcrumb for debugging
  Future<void> logBreadcrumb(String message) async {
    try {
      await _crashlytics.log(message);
    } catch (e) {
      debugPrint('Failed to log breadcrumb: $e');
    }
  }
}
