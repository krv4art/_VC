import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

/// Сервис для управления аналитикой приложения
class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  FirebaseAnalytics? _analytics;
  bool _isInitialized = false;

  factory AnalyticsService() {
    return _instance;
  }

  AnalyticsService._internal() {
    if (!kIsWeb) {
      _analytics = FirebaseAnalytics.instance;
      _isInitialized = true;
    }
  }

  /// Проверяет, инициализирована ли аналитика
  bool get isInitialized => _isInitialized;

  /// Логирование просмотра экрана
  Future<void> logScreenView({
    required String screenName,
    Map<String, Object>? parameters,
  }) async {
    if (!_isInitialized) return;
    try {
      await _analytics?.logScreenView(
        screenName: screenName,
        parameters: parameters,
      );
    } catch (e) {
      debugPrint('Analytics error: $e');
    }
  }

  /// Логирование события сканирования
  Future<void> logScan({
    required String productName,
    required String productBrand,
    Map<String, Object>? customParameters,
  }) async {
    if (!_isInitialized) return;
    try {
      await _analytics?.logEvent(
        name: 'product_scan',
        parameters: {
          'product_name': productName,
          'product_brand': productBrand,
          ...?customParameters,
        },
      );
    } catch (e) {
      debugPrint('Analytics error: $e');
    }
  }

  /// Логирование события открытия галереи
  Future<void> logGalleryOpen() async {
    if (!_isInitialized) return;
    try {
      await _analytics?.logEvent(
        name: 'gallery_open',
      );
    } catch (e) {
      debugPrint('Analytics error: $e');
    }
  }

  /// Логирование события открытия камеры
  Future<void> logCameraOpen() async {
    if (!_isInitialized) return;
    try {
      await _analytics?.logEvent(
        name: 'camera_open',
      );
    } catch (e) {
      debugPrint('Analytics error: $e');
    }
  }

  /// Логирование события приобретения подписки
  Future<void> logSubscriptionPurchase({
    required String subscriptionType,
    required double price,
    required String currency,
    Map<String, Object>? customParameters,
  }) async {
    if (!_isInitialized) return;
    try {
      await _analytics?.logEvent(
        name: 'subscription_purchase',
        parameters: {
          'subscription_type': subscriptionType,
          'price': price,
          'currency': currency,
          ...?customParameters,
        },
      );
    } catch (e) {
      debugPrint('Analytics error: $e');
    }
  }

  /// Логирование события запроса функции
  Future<void> logFeatureUsed({
    required String featureName,
    Map<String, Object>? customParameters,
  }) async {
    if (!_isInitialized) return;
    try {
      await _analytics?.logEvent(
        name: 'feature_used',
        parameters: {
          'feature_name': featureName,
          ...?customParameters,
        },
      );
    } catch (e) {
      debugPrint('Analytics error: $e');
    }
  }

  /// Логирование события ошибки
  Future<void> logError({
    required String errorCode,
    required String errorMessage,
    Map<String, Object>? customParameters,
  }) async {
    if (!_isInitialized) return;
    try {
      await _analytics?.logEvent(
        name: 'app_error',
        parameters: {
          'error_code': errorCode,
          'error_message': errorMessage,
          ...?customParameters,
        },
      );
    } catch (e) {
      debugPrint('Analytics error: $e');
    }
  }

  /// Логирование события просмотра товара
  Future<void> logViewItem({
    required String itemId,
    required String itemName,
    String? itemCategory,
    Map<String, Object>? customParameters,
  }) async {
    if (!_isInitialized) return;
    try {
      await _analytics?.logEvent(
        name: 'view_item',
        parameters: {
          'item_id': itemId,
          'item_name': itemName,
          if (itemCategory != null) 'item_category': itemCategory,
          ...?customParameters,
        },
      );
    } catch (e) {
      debugPrint('Analytics error: $e');
    }
  }

  /// Логирование пользовательского события
  Future<void> logCustomEvent({
    required String eventName,
    Map<String, Object>? parameters,
  }) async {
    if (!_isInitialized) return;
    try {
      await _analytics?.logEvent(
        name: eventName,
        parameters: parameters,
      );
    } catch (e) {
      debugPrint('Analytics error: $e');
    }
  }

  /// Установка ID пользователя
  Future<void> setUserId(String userId) async {
    if (!_isInitialized) return;
    try {
      await _analytics?.setUserId(id: userId);
    } catch (e) {
      debugPrint('Analytics error: $e');
    }
  }

  /// Установка пользовательского свойства
  Future<void> setUserProperty({
    required String name,
    required String value,
  }) async {
    if (!_isInitialized) return;
    try {
      await _analytics?.setUserProperty(name: name, value: value);
    } catch (e) {
      debugPrint('Analytics error: $e');
    }
  }

  /// Очистка ID пользователя
  Future<void> clearUserId() async {
    if (!_isInitialized) return;
    try {
      await _analytics?.setUserId(id: null);
    } catch (e) {
      debugPrint('Analytics error: $e');
    }
  }
}
