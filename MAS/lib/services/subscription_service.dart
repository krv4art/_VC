import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Service for managing subscriptions via RevenueCat
///
/// Handles Premium subscriptions for Math AI Solver:
/// - Unlimited problem solutions
/// - Unlimited chat messages
/// - Unlimited solution checks
/// - No ads
///
/// Web platform note: RevenueCat is not supported on Web
class SubscriptionService {
  static final SubscriptionService _instance = SubscriptionService._internal();
  factory SubscriptionService() => _instance;
  SubscriptionService._internal();

  // Subscription status
  bool _isPremium = false;
  bool get isPremium => _isPremium;

  // Entitlement identifier (must match RevenueCat Dashboard)
  static const String premiumEntitlement = 'premium';

  /// Initialize service
  Future<void> initialize() async {
    // RevenueCat not supported on Web platform
    if (kIsWeb) {
      debugPrint('⚠️ RevenueCat not supported on Web platform');
      return;
    }

    try {
      // Enable debug mode for testing
      if (kDebugMode) {
        await Purchases.setLogLevel(LogLevel.debug);
      }

      // Load current subscription status
      await checkSubscriptionStatus();
      debugPrint('✅ SubscriptionService initialized');
    } catch (e) {
      debugPrint('❌ Error initializing SubscriptionService: $e');
    }
  }

  /// Check subscription status
  Future<bool> checkSubscriptionStatus() async {
    // RevenueCat not supported on Web platform
    if (kIsWeb) {
      _isPremium = false;
      return false;
    }

    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      _isPremium = customerInfo.entitlements.all[premiumEntitlement]?.isActive ?? false;
      debugPrint('📊 Subscription status: isPremium = $_isPremium');
      return _isPremium;
    } catch (e) {
      debugPrint('❌ Error checking subscription status: $e');
      return false;
    }
  }

  /// Get available offerings
  Future<Offerings?> getOfferings() async {
    // RevenueCat not supported on Web platform
    if (kIsWeb) {
      debugPrint('⚠️ RevenueCat not supported on Web platform');
      return null;
    }

    try {
      Offerings offerings = await Purchases.getOfferings();

      if (offerings.current != null && offerings.current!.availablePackages.isNotEmpty) {
        debugPrint('📦 Available packages: ${offerings.current!.availablePackages.length}');
        return offerings;
      } else {
        debugPrint('⚠️ No offerings available');
        return null;
      }
    } catch (e) {
      debugPrint('❌ Error getting offerings: $e');
      return null;
    }
  }

  /// Purchase a package
  Future<bool> purchasePackage(Package package) async {
    // RevenueCat not supported on Web platform
    if (kIsWeb) {
      debugPrint('❌ Purchases not supported on Web platform');
      return false;
    }

    try {
      CustomerInfo customerInfo = await Purchases.purchasePackage(package);
      _isPremium = customerInfo.entitlements.all[premiumEntitlement]?.isActive ?? false;

      if (_isPremium) {
        debugPrint('✅ Purchase successful! Premium status: $_isPremium');
        return true;
      } else {
        debugPrint('⚠️ Purchase completed but premium not active');
        return false;
      }
    } on PlatformException catch (e) {
      var errorCode = PurchasesErrorHelper.getErrorCode(e);

      if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
        debugPrint('ℹ️ User cancelled purchase');
      } else if (errorCode == PurchasesErrorCode.productAlreadyPurchasedError) {
        debugPrint('ℹ️ Product already purchased, restoring...');
        await restorePurchases(); // Auto-restore
        return _isPremium;
      } else {
        debugPrint('❌ Purchase error: ${e.message}');
      }
      return false;
    } catch (e) {
      debugPrint('❌ Unexpected purchase error: $e');
      return false;
    }
  }

  /// Restore purchases
  Future<bool> restorePurchases() async {
    // RevenueCat not supported on Web platform
    if (kIsWeb) {
      debugPrint('❌ Restore purchases not supported on Web platform');
      return false;
    }

    try {
      CustomerInfo customerInfo = await Purchases.restorePurchases();
      _isPremium = customerInfo.entitlements.all[premiumEntitlement]?.isActive ?? false;

      debugPrint('✅ Restore purchases: isPremium = $_isPremium');
      return _isPremium;
    } catch (e) {
      debugPrint('❌ Error restoring purchases: $e');
      return false;
    }
  }

  /// Set user ID (optional, for analytics)
  Future<void> setUserId(String userId) async {
    // RevenueCat not supported on Web platform
    if (kIsWeb) {
      debugPrint('⚠️ User ID not supported on Web platform');
      return;
    }

    try {
      await Purchases.logIn(userId);
      await checkSubscriptionStatus();
      debugPrint('✅ User ID set: $userId');
    } catch (e) {
      debugPrint('❌ Error setting user ID: $e');
    }
  }

  /// Logout (optional, on user logout)
  Future<void> logout() async {
    // RevenueCat not supported on Web platform
    if (kIsWeb) {
      _isPremium = false;
      return;
    }

    try {
      await Purchases.logOut();
      _isPremium = false;
      debugPrint('✅ Logged out from RevenueCat');
    } catch (e) {
      debugPrint('❌ Error logging out: $e');
    }
  }
}
