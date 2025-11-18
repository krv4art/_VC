import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../services/subscription_service.dart';

class SubscriptionProvider with ChangeNotifier {
  final SubscriptionService _subscriptionService = SubscriptionService();

  SubscriptionTier _currentTier = SubscriptionTier.free;
  bool _isLoading = false;
  String? _errorMessage;

  SubscriptionTier get currentTier => _currentTier;
  bool get isPremium => _subscriptionService.isPremium;
  bool get isUltimate => _subscriptionService.isUltimate;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Initialize subscription service
  Future<void> initialize(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _subscriptionService.initialize(userId);
      _currentTier = _subscriptionService.currentTier;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('Error initializing subscription: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Get available offerings
  Future<Offerings?> getOfferings() async {
    _isLoading = true;
    notifyListeners();

    try {
      final offerings = await _subscriptionService.getOfferings();
      _errorMessage = null;
      return offerings;
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('Error getting offerings: $e');
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Purchase package
  Future<bool> purchase(Package package) async {
    _isLoading = true;
    notifyListeners();

    try {
      final success = await _subscriptionService.purchase(package);
      _currentTier = _subscriptionService.currentTier;
      _errorMessage = null;
      return success;
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('Error purchasing: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Restore purchases
  Future<bool> restorePurchases() async {
    _isLoading = true;
    notifyListeners();

    try {
      final success = await _subscriptionService.restorePurchases();
      _currentTier = _subscriptionService.currentTier;
      _errorMessage = null;
      return success;
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('Error restoring purchases: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Check subscription status
  Future<void> checkSubscriptionStatus() async {
    try {
      await _subscriptionService.initialize(''); // Will use current user
      _currentTier = _subscriptionService.currentTier;
      notifyListeners();
    } catch (e) {
      debugPrint('Error checking subscription status: $e');
    }
  }
}
