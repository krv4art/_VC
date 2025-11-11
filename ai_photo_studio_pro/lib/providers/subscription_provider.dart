import 'package:flutter/foundation.dart';
import '../services/subscription_service.dart';
import 'user_state.dart';

/// Provider для управления статусом подписки в приложении
class SubscriptionProvider extends ChangeNotifier {
  final SubscriptionService _subscriptionService = SubscriptionService();
  UserState? _userState;

  bool _isPremium = false;
  bool get isPremium => _isPremium;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Установить UserState для синхронизации
  void setUserState(UserState userState) {
    _userState = userState;
  }

  /// Инициализация при запуске приложения
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    await _subscriptionService.initialize();
    _isPremium = await _subscriptionService.checkSubscriptionStatus();

    // Синхронизируем с UserState
    if (_userState != null) {
      await _userState!.updatePremiumStatus(_isPremium);
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Проверить статус подписки
  Future<void> checkStatus() async {
    _isPremium = await _subscriptionService.checkSubscriptionStatus();

    // Синхронизируем с UserState
    if (_userState != null) {
      await _userState!.updatePremiumStatus(_isPremium);
    }

    notifyListeners();
  }

  /// Установить пользователя (опционально)
  Future<void> setUser(String userId) async {
    await _subscriptionService.setUserId(userId);
    await checkStatus();
  }

  /// Выйти
  Future<void> logout() async {
    await _subscriptionService.logout();
    _isPremium = false;
    notifyListeners();
  }
}
