import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

/// Service for managing premium subscriptions via RevenueCat
class PremiumService {
  static final PremiumService _instance = PremiumService._internal();
  factory PremiumService() => _instance;
  PremiumService._internal();

  static const String _revenueCatApiKey = 'YOUR_REVENUECAT_API_KEY';
  static const String monthlyProductId = 'fish_id_premium_monthly';
  static const String yearlyProductId = 'fish_id_premium_yearly';

  bool _isInitialized = false;
  bool _isPremium = false;
  DateTime? _expirationDate;

  bool get isPremium => _isPremium;
  bool get isInitialized => _isInitialized;
  DateTime? get expirationDate => _expirationDate;

  /// Initialize RevenueCat SDK
  Future<void> initialize({String? userId}) async {
    if (_isInitialized) return;

    try {
      await Purchases.setLogLevel(LogLevel.info);

      // Configure SDK
      final configuration = PurchasesConfiguration(_revenueCatApiKey);
      if (userId != null) {
        configuration.appUserID = userId;
      }

      await Purchases.configure(configuration);

      // Check initial premium status
      await checkPremiumStatus();

      _isInitialized = true;
    } catch (e) {
      print('Failed to initialize RevenueCat: $e');
      _isInitialized = false;
    }
  }

  /// Check current premium status
  Future<void> checkPremiumStatus() async {
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      _updatePremiumStatus(customerInfo);
    } catch (e) {
      print('Failed to check premium status: $e');
      _isPremium = false;
    }
  }

  /// Get available packages for purchase
  Future<List<Package>> getAvailablePackages() async {
    try {
      final offerings = await Purchases.getOfferings();
      if (offerings.current != null) {
        return offerings.current!.availablePackages;
      }
      return [];
    } catch (e) {
      print('Failed to get packages: $e');
      return [];
    }
  }

  /// Purchase a package
  Future<bool> purchasePackage(Package package) async {
    try {
      final customerInfo = await Purchases.purchasePackage(package);
      _updatePremiumStatus(customerInfo);
      return _isPremium;
    } catch (e) {
      if (e is PlatformException) {
        final errorCode = PurchasesErrorHelper.getErrorCode(e);
        if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
          print('User cancelled purchase');
        } else {
          print('Purchase error: ${e.message}');
        }
      }
      return false;
    }
  }

  /// Restore previous purchases
  Future<bool> restorePurchases() async {
    try {
      final customerInfo = await Purchases.restorePurchases();
      _updatePremiumStatus(customerInfo);
      return _isPremium;
    } catch (e) {
      print('Failed to restore purchases: $e');
      return false;
    }
  }

  /// Update premium status from customer info
  void _updatePremiumStatus(CustomerInfo customerInfo) {
    final entitlements = customerInfo.entitlements.active;
    _isPremium = entitlements.isNotEmpty;

    if (_isPremium && entitlements.values.isNotEmpty) {
      final premiumEntitlement = entitlements.values.first;
      _expirationDate = premiumEntitlement.expirationDate != null
          ? DateTime.parse(premiumEntitlement.expirationDate!)
          : null;
    } else {
      _expirationDate = null;
    }
  }

  /// Get user ID for analytics
  Future<String?> getUserId() async {
    try {
      return await Purchases.appUserID;
    } catch (e) {
      print('Failed to get user ID: $e');
      return null;
    }
  }

  /// Log out current user
  Future<void> logout() async {
    try {
      await Purchases.logOut();
      _isPremium = false;
      _expirationDate = null;
    } catch (e) {
      print('Failed to log out: $e');
    }
  }
}
