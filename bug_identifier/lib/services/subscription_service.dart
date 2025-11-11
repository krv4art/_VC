import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Сервис для работы с подписками через RevenueCat
class SubscriptionService {
  static final SubscriptionService _instance = SubscriptionService._internal();
  factory SubscriptionService() => _instance;
  SubscriptionService._internal();

  // Статус подписки
  bool _isPremium = false;
  bool get isPremium => _isPremium;

  // Entitlement identifier (должен совпадать с RevenueCat Dashboard)
  static const String premiumEntitlement = 'premium';

  /// Инициализация сервиса
  Future<void> initialize() async {
    // На Web платформе RevenueCat не поддерживается
    if (kIsWeb) {
      debugPrint('RevenueCat not supported on Web platform');
      return;
    }

    try {
      // Включаем debug режим для тестирования
      if (kDebugMode) {
        await Purchases.setLogLevel(LogLevel.debug);
      }

      // Загружаем текущий статус подписки
      await checkSubscriptionStatus();
    } catch (e) {
      debugPrint('Error initializing SubscriptionService: $e');
    }
  }

  /// Проверка статуса подписки
  Future<bool> checkSubscriptionStatus() async {
    // На Web платформе RevenueCat не поддерживается
    if (kIsWeb) {
      _isPremium = false;
      return false;
    }

    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      _isPremium =
          customerInfo.entitlements.all[premiumEntitlement]?.isActive ?? false;
      debugPrint('Subscription status: isPremium = $_isPremium');
      return _isPremium;
    } catch (e) {
      debugPrint('Error checking subscription status: $e');
      return false;
    }
  }

  /// Получить доступные предложения (offerings)
  Future<Offerings?> getOfferings() async {
    // На Web платформе RevenueCat не поддерживается
    if (kIsWeb) {
      debugPrint('RevenueCat not supported on Web platform');
      return null;
    }

    try {
      Offerings offerings = await Purchases.getOfferings();

      if (offerings.current != null &&
          offerings.current!.availablePackages.isNotEmpty) {
        debugPrint(
            'Available packages: ${offerings.current!.availablePackages.length}');
        return offerings;
      } else {
        debugPrint('No offerings available');
        return null;
      }
    } catch (e) {
      debugPrint('Error getting offerings: $e');
      return null;
    }
  }

  /// Совершить покупку
  Future<bool> purchasePackage(Package package) async {
    // На Web платформе RevenueCat не поддерживается
    if (kIsWeb) {
      debugPrint('Purchases not supported on Web platform');
      return false;
    }

    try {
      CustomerInfo customerInfo = await Purchases.purchasePackage(package);
      _isPremium =
          customerInfo.entitlements.all[premiumEntitlement]?.isActive ?? false;

      if (_isPremium) {
        debugPrint('Purchase successful! Premium status: $_isPremium');
        return true;
      } else {
        debugPrint('Purchase completed but premium not active');
        return false;
      }
    } on PlatformException catch (e) {
      var errorCode = PurchasesErrorHelper.getErrorCode(e);

      if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
        debugPrint('User cancelled purchase');
      } else if (errorCode == PurchasesErrorCode.productAlreadyPurchasedError) {
        debugPrint('Product already purchased');
        await restorePurchases(); // Автоматически восстанавливаем
        return _isPremium;
      } else {
        debugPrint('Purchase error: ${e.message}');
      }
      return false;
    } catch (e) {
      debugPrint('Unexpected purchase error: $e');
      return false;
    }
  }

  /// Восстановить покупки
  Future<bool> restorePurchases() async {
    // На Web платформе RevenueCat не поддерживается
    if (kIsWeb) {
      debugPrint('Restore purchases not supported on Web platform');
      return false;
    }

    try {
      CustomerInfo customerInfo = await Purchases.restorePurchases();
      _isPremium =
          customerInfo.entitlements.all[premiumEntitlement]?.isActive ?? false;

      debugPrint('Restore purchases: isPremium = $_isPremium');
      return _isPremium;
    } catch (e) {
      debugPrint('Error restoring purchases: $e');
      return false;
    }
  }

  /// Установить user ID (опционально, для аналитики)
  Future<void> setUserId(String userId) async {
    // На Web платформе RevenueCat не поддерживается
    if (kIsWeb) {
      debugPrint('User ID not supported on Web platform');
      return;
    }

    try {
      await Purchases.logIn(userId);
      await checkSubscriptionStatus();
    } catch (e) {
      debugPrint('Error setting user ID: $e');
    }
  }

  /// Выйти (опционально, при logout пользователя)
  Future<void> logout() async {
    // На Web платформе RevenueCat не поддерживается
    if (kIsWeb) {
      _isPremium = false;
      return;
    }

    try {
      await Purchases.logOut();
      _isPremium = false;
    } catch (e) {
      debugPrint('Error logging out: $e');
    }
  }
}
