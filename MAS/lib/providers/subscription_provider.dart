import 'package:flutter/foundation.dart';
import '../services/subscription_service.dart';
import 'user_state.dart';

/// Provider for managing subscription status in Math AI Solver
///
/// Manages Premium subscription state and syncs with UserState.
///
/// Premium benefits:
/// - Unlimited math problem solutions
/// - Unlimited chat messages
/// - Unlimited solution checks
/// - No ads
/// - Full history access
class SubscriptionProvider extends ChangeNotifier {
  final SubscriptionService _subscriptionService = SubscriptionService();
  UserState? _userState;

  bool _isPremium = false;
  bool get isPremium => _isPremium;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Set UserState for synchronization
  void setUserState(UserState userState) {
    _userState = userState;
    debugPrint('✅ UserState linked to SubscriptionProvider');
  }

  /// Initialize on app startup
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    debugPrint('🔄 Initializing SubscriptionProvider...');

    await _subscriptionService.initialize();
    _isPremium = await _subscriptionService.checkSubscriptionStatus();

    // Sync with UserState
    if (_userState != null) {
      await _userState!.updatePremiumStatus(_isPremium);
    }

    _isLoading = false;
    debugPrint('✅ SubscriptionProvider initialized: isPremium = $_isPremium');
    notifyListeners();
  }

  /// Check subscription status
  Future<void> checkStatus() async {
    debugPrint('🔄 Checking subscription status...');
    _isPremium = await _subscriptionService.checkSubscriptionStatus();

    // Sync with UserState
    if (_userState != null) {
      await _userState!.updatePremiumStatus(_isPremium);
    }

    debugPrint('✅ Subscription status checked: isPremium = $_isPremium');
    notifyListeners();
  }

  /// Set user (optional)
  Future<void> setUser(String userId) async {
    await _subscriptionService.setUserId(userId);
    await checkStatus();
  }

  /// Logout
  Future<void> logout() async {
    await _subscriptionService.logout();
    _isPremium = false;
    debugPrint('✅ Logged out from SubscriptionProvider');
    notifyListeners();
  }
}
