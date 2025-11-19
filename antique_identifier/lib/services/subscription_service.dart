import 'dart:async';
import 'dart:developer' as developer;
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Типы подписок
enum SubscriptionTier {
  free,
  premium,
  professional,
}

/// Сервис управления подписками
class SubscriptionService {
  final InAppPurchase _iap = InAppPurchase.instance;

  // Product IDs
  static const String premiumMonthly = 'premium_monthly';
  static const String premiumYearly = 'premium_yearly';
  static const String professionalMonthly = 'professional_monthly';
  static const String professionalYearly = 'professional_yearly';

  // Лимиты для бесплатного тарифа
  static const int freeAnalysesPerMonth = 3;

  StreamSubscription<List<PurchaseDetails>>? _subscription;

  SubscriptionTier _currentTier = SubscriptionTier.free;
  List<ProductDetails> _products = [];
  bool _isAvailable = false;

  SubscriptionTier get currentTier => _currentTier;
  List<ProductDetails> get products => _products;
  bool get isAvailable => _isAvailable;

  /// Инициализация сервиса подписок
  Future<bool> initialize() async {
    try {
      developer.log('Initializing subscription service', name: 'SubscriptionService');

      _isAvailable = await _iap.isAvailable();

      if (!_isAvailable) {
        developer.log('IAP not available', name: 'SubscriptionService');
        return false;
      }

      // Загружаем сохраненный тариф
      await _loadSavedTier();

      // Загружаем продукты
      await _loadProducts();

      // Слушаем изменения покупок
      _subscription = _iap.purchaseStream.listen(
        _onPurchaseUpdate,
        onDone: () => _subscription?.cancel(),
        onError: (error) {
          developer.log('Purchase stream error: $error', name: 'SubscriptionService');
        },
      );

      // Восстанавливаем покупки
      await restorePurchases();

      developer.log('Subscription service initialized', name: 'SubscriptionService');
      return true;
    } catch (e) {
      developer.log('Initialization error: $e', name: 'SubscriptionService');
      return false;
    }
  }

  /// Загружает доступные продукты
  Future<void> _loadProducts() async {
    try {
      const Set<String> productIds = {
        premiumMonthly,
        premiumYearly,
        professionalMonthly,
        professionalYearly,
      };

      final ProductDetailsResponse response =
          await _iap.queryProductDetails(productIds);

      if (response.notFoundIDs.isNotEmpty) {
        developer.log(
          'Products not found: ${response.notFoundIDs}',
          name: 'SubscriptionService',
        );
      }

      _products = response.productDetails;
      developer.log('Loaded ${_products.length} products', name: 'SubscriptionService');
    } catch (e) {
      developer.log('Error loading products: $e', name: 'SubscriptionService');
    }
  }

  /// Обрабатывает обновления покупок
  void _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.purchased ||
          purchaseDetails.status == PurchaseStatus.restored) {
        // Обрабатываем успешную покупку
        await _handleSuccessfulPurchase(purchaseDetails);
      } else if (purchaseDetails.status == PurchaseStatus.error) {
        developer.log(
          'Purchase error: ${purchaseDetails.error}',
          name: 'SubscriptionService',
        );
      }

      if (purchaseDetails.pendingCompletePurchase) {
        await _iap.completePurchase(purchaseDetails);
      }
    }
  }

  /// Обрабатывает успешную покупку
  Future<void> _handleSuccessfulPurchase(PurchaseDetails purchase) async {
    try {
      // Определяем тариф по product ID
      final tier = _getTierFromProductId(purchase.productID);

      if (tier != null) {
        _currentTier = tier;
        await _saveTier(tier);
        developer.log('Subscription activated: $tier', name: 'SubscriptionService');
      }
    } catch (e) {
      developer.log('Error handling purchase: $e', name: 'SubscriptionService');
    }
  }

  /// Определяет тариф по product ID
  SubscriptionTier? _getTierFromProductId(String productId) {
    if (productId == premiumMonthly || productId == premiumYearly) {
      return SubscriptionTier.premium;
    } else if (productId == professionalMonthly || productId == professionalYearly) {
      return SubscriptionTier.professional;
    }
    return null;
  }

  /// Покупка подписки
  Future<bool> subscribe(String productId) async {
    try {
      final product = _products.firstWhere((p) => p.id == productId);

      final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);

      final success = await _iap.buyNonConsumable(purchaseParam: purchaseParam);

      return success;
    } catch (e) {
      developer.log('Subscribe error: $e', name: 'SubscriptionService');
      return false;
    }
  }

  /// Восстановление покупок
  Future<void> restorePurchases() async {
    try {
      developer.log('Restoring purchases', name: 'SubscriptionService');
      await _iap.restorePurchases();
    } catch (e) {
      developer.log('Restore error: $e', name: 'SubscriptionService');
    }
  }

  /// Проверяет доступность функции
  bool hasFeature(String feature) {
    switch (feature) {
      case 'unlimited_analyses':
        return _currentTier != SubscriptionTier.free;
      case 'pdf_export':
        return _currentTier != SubscriptionTier.free;
      case 'visual_matches':
        return _currentTier != SubscriptionTier.free;
      case 'cloud_sync':
        return _currentTier != SubscriptionTier.free;
      case 'expert_appraisal':
        return _currentTier == SubscriptionTier.professional;
      case 'marketplace_integration':
        return _currentTier == SubscriptionTier.professional;
      case 'priority_support':
        return _currentTier == SubscriptionTier.professional;
      default:
        return false;
    }
  }

  /// Получить количество оставшихся бесплатных анализов
  Future<int> getRemainingFreeAnalyses() async {
    if (_currentTier != SubscriptionTier.free) {
      return -1; // Безлимит
    }

    final prefs = await SharedPreferences.getInstance();
    final usedCount = prefs.getInt('free_analyses_used') ?? 0;
    final lastResetMonth = prefs.getInt('last_reset_month') ?? 0;

    final currentMonth = DateTime.now().month;

    // Сбрасываем счетчик каждый месяц
    if (lastResetMonth != currentMonth) {
      await prefs.setInt('free_analyses_used', 0);
      await prefs.setInt('last_reset_month', currentMonth);
      return freeAnalysesPerMonth;
    }

    return (freeAnalysesPerMonth - usedCount).clamp(0, freeAnalysesPerMonth);
  }

  /// Использовать бесплатный анализ
  Future<bool> useFreeAnalysis() async {
    if (_currentTier != SubscriptionTier.free) {
      return true; // Безлимит для платных тарифов
    }

    final remaining = await getRemainingFreeAnalyses();

    if (remaining <= 0) {
      return false;
    }

    final prefs = await SharedPreferences.getInstance();
    final usedCount = prefs.getInt('free_analyses_used') ?? 0;
    await prefs.setInt('free_analyses_used', usedCount + 1);

    return true;
  }

  /// Сохраняет текущий тариф
  Future<void> _saveTier(SubscriptionTier tier) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('subscription_tier', tier.toString());
  }

  /// Загружает сохраненный тариф
  Future<void> _loadSavedTier() async {
    final prefs = await SharedPreferences.getInstance();
    final tierString = prefs.getString('subscription_tier');

    if (tierString != null) {
      _currentTier = SubscriptionTier.values.firstWhere(
        (t) => t.toString() == tierString,
        orElse: () => SubscriptionTier.free,
      );
    }
  }

  /// Получает цену продукта
  String? getPrice(String productId) {
    try {
      final product = _products.firstWhere((p) => p.id == productId);
      return product.price;
    } catch (e) {
      return null;
    }
  }

  /// Очистка ресурсов
  void dispose() {
    _subscription?.cancel();
  }
}
