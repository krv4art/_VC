import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/subscription_provider.dart';
import '../l10n/app_localizations.dart';

/// Helper класс для проверки премиум статуса и отображения paywall
class SubscriptionHelper {
  /// Проверить премиум статус и показать paywall, если не премиум
  /// Возвращает true, если пользователь премиум, false если нет
  static bool checkPremiumOrShowPaywall(BuildContext context) {
    final subscriptionProvider = context.read<SubscriptionProvider>();

    if (!subscriptionProvider.isPremium) {
      // Показываем paywall
      context.push('/modern-paywall');
      return false;
    }

    return true;
  }

  /// Проверить премиум статус (без перехода на paywall)
  static bool isPremium(BuildContext context) {
    return context.read<SubscriptionProvider>().isPremium;
  }

  /// Виджет для защиты премиум контента
  static Widget premiumGate({
    required BuildContext context,
    required Widget premiumChild,
    Widget? freeChild,
  }) {
    return Consumer<SubscriptionProvider>(
      builder: (context, subscriptionProvider, _) {
        if (subscriptionProvider.isPremium) {
          return premiumChild;
        } else {
          return freeChild ??
              Builder(
                builder: (context) {
                  final l10n = AppLocalizations.of(context)!;
                  return Center(
                    child: ElevatedButton(
                      onPressed: () => context.push('/modern-paywall'),
                      child: Text(l10n.upgradeToPremium),
                    ),
                  );
                },
              );
        }
      },
    );
  }
}

/// Пример использования в коде:
///
/// 1. Проверка перед действием:
/// ```dart
/// void onPremiumFeatureTap() {
///   if (!SubscriptionHelper.checkPremiumOrShowPaywall(context)) {
///     return; // Paywall будет показан автоматически
///   }
///
///   // Выполняем премиум действие
///   doSomethingPremium();
/// }
/// ```
///
/// 2. Показать/скрыть кнопку:
/// ```dart
/// Consumer<SubscriptionProvider>(
///   builder: (context, subscriptionProvider, child) {
///     return ElevatedButton(
///       onPressed: subscriptionProvider.isPremium ? _doPremiumAction : null,
///       child: Text(subscriptionProvider.isPremium ? 'Premium Feature' : 'Upgrade'),
///     );
///   },
/// )
/// ```
///
/// 3. Условный рендеринг:
/// ```dart
/// SubscriptionHelper.premiumGate(
///   context: context,
///   premiumChild: PremiumFeatureWidget(),
///   freeChild: Text('Upgrade to access this feature'),
/// )
/// ```
