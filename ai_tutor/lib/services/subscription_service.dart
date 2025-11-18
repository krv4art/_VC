import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

enum SubscriptionTier {
  free,
  premium,
  ultimate,
}

class SubscriptionService {
  static final SubscriptionService _instance = SubscriptionService._internal();
  factory SubscriptionService() => _instance;
  SubscriptionService._internal();

  SubscriptionTier _currentTier = SubscriptionTier.free;
  CustomerInfo? _customerInfo;

  SubscriptionTier get currentTier => _currentTier;
  bool get isPremium => _currentTier == SubscriptionTier.premium || _currentTier == SubscriptionTier.ultimate;
  bool get isUltimate => _currentTier == SubscriptionTier.ultimate;

  /// Initialize RevenueCat
  Future<void> initialize(String userId) async {
    try {
      // TODO: Add your RevenueCat API keys in .env
      // REVENUECAT_IOS_KEY=your_ios_key
      // REVENUECAT_ANDROID_KEY=your_android_key

      PurchasesConfiguration configuration;
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        configuration = PurchasesConfiguration('appl_YOUR_IOS_KEY');
      } else if (defaultTargetPlatform == TargetPlatform.android) {
        configuration = PurchasesConfiguration('goog_YOUR_ANDROID_KEY');
      } else {
        return;
      }

      await Purchases.configure(configuration);
      await Purchases.logIn(userId);

      // Get current entitlements
      _customerInfo = await Purchases.getCustomerInfo();
      _updateSubscriptionTier();

      debugPrint('✅ RevenueCat initialized');
    } catch (e) {
      debugPrint('❌ Error initializing RevenueCat: $e');
    }
  }

  /// Get available offerings
  Future<Offerings?> getOfferings() async {
    try {
      final offerings = await Purchases.getOfferings();
      return offerings;
    } catch (e) {
      debugPrint('Error getting offerings: $e');
      return null;
    }
  }

  /// Purchase product
  Future<bool> purchase(Package package) async {
    try {
      final purchaseResult = await Purchases.purchasePackage(package);
      _customerInfo = purchaseResult;
      _updateSubscriptionTier();
      return true;
    } on PlatformException catch (e) {
      final errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
        debugPrint('User cancelled purchase');
      } else {
        debugPrint('Error purchasing: $e');
      }
      return false;
    }
  }

  /// Restore purchases
  Future<bool> restorePurchases() async {
    try {
      _customerInfo = await Purchases.restorePurchases();
      _updateSubscriptionTier();
      return true;
    } catch (e) {
      debugPrint('Error restoring purchases: $e');
      return false;
    }
  }

  /// Check if user has entitlement
  bool hasEntitlement(String entitlementId) {
    if (_customerInfo == null) return false;
    return _customerInfo!.entitlements.all[entitlementId]?.isActive ?? false;
  }

  /// Update subscription tier based on entitlements
  void _updateSubscriptionTier() {
    if (hasEntitlement('ultimate')) {
      _currentTier = SubscriptionTier.ultimate;
    } else if (hasEntitlement('premium')) {
      _currentTier = SubscriptionTier.premium;
    } else {
      _currentTier = SubscriptionTier.free;
    }

    debugPrint('Current tier: $_currentTier');
  }

  /// Get premium features
  Map<String, bool> getPremiumFeatures() {
    return {
      'unlimited_ai_requests': isPremium,
      'offline_mode': isPremium,
      'advanced_analytics': isPremium,
      'priority_support': isPremium,
      'custom_themes': isUltimate,
      'ai_tutor_sessions': isUltimate,
      'no_ads': isPremium,
    };
  }

  /// Logout (clear user data)
  Future<void> logout() async {
    try {
      await Purchases.logOut();
      _currentTier = SubscriptionTier.free;
      _customerInfo = null;
    } catch (e) {
      debugPrint('Error logging out from RevenueCat: $e');
    }
  }
}
