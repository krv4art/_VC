import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../services/premium_service.dart';

/// Provider for managing premium subscription state
class PremiumProvider with ChangeNotifier {
  final PremiumService _premiumService = PremiumService();

  bool _isLoading = false;
  List<Package> _availablePackages = [];
  String? _error;

  // Free tier limits
  static const int freeIdentificationsPerDay = 5;
  static const int freeChatMessagesPerDay = 10;

  bool get isPremium => _premiumService.isPremium;
  bool get isLoading => _isLoading;
  List<Package> get availablePackages => _availablePackages;
  String? get error => _error;
  DateTime? get expirationDate => _premiumService.expirationDate;

  PremiumProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _premiumService.initialize();
      await loadPackages();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load available subscription packages
  Future<void> loadPackages() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _availablePackages = await _premiumService.getAvailablePackages();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Purchase a subscription package
  Future<bool> purchasePackage(Package package) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final success = await _premiumService.purchasePackage(package);
      if (success) {
        await _premiumService.checkPremiumStatus();
      }
      return success;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Restore previous purchases
  Future<bool> restorePurchases() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final success = await _premiumService.restorePurchases();
      return success;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Check if user has reached free tier limit for identifications
  Future<bool> canIdentifyFish(int todayCount) async {
    if (isPremium) return true;
    return todayCount < freeIdentificationsPerDay;
  }

  /// Check if user can send chat messages
  Future<bool> canSendChatMessage(int todayCount) async {
    if (isPremium) return true;
    return todayCount < freeChatMessagesPerDay;
  }

  /// Get monthly package
  Package? get monthlyPackage {
    return _availablePackages.firstWhere(
      (p) => p.packageType == PackageType.monthly,
      orElse: () => _availablePackages.isNotEmpty
          ? _availablePackages.first
          : throw Exception('No packages available'),
    );
  }

  /// Get yearly package
  Package? get yearlyPackage {
    return _availablePackages.firstWhere(
      (p) => p.packageType == PackageType.annual,
      orElse: () => _availablePackages.length > 1
          ? _availablePackages[1]
          : throw Exception('No yearly package available'),
    );
  }

  /// Calculate savings percentage for yearly vs monthly
  double get yearlySavingsPercentage {
    try {
      final monthly = monthlyPackage;
      final yearly = yearlyPackage;
      if (monthly == null || yearly == null) return 0;

      final monthlyPrice = monthly.storeProduct.price;
      final yearlyPrice = yearly.storeProduct.price;
      final yearlyEquivalent = monthlyPrice * 12;

      return ((yearlyEquivalent - yearlyPrice) / yearlyEquivalent) * 100;
    } catch (e) {
      return 0;
    }
  }

  /// Refresh premium status
  Future<void> refresh() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _premiumService.checkPremiumStatus();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
