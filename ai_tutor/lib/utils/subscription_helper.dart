import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/subscription_provider.dart';

class SubscriptionHelper {
  /// Check if user is premium, show paywall if not
  /// Returns true if user is premium, false otherwise
  static bool checkPremiumOrShowPaywall(BuildContext context) {
    final subscriptionProvider = context.read<SubscriptionProvider>();

    if (!subscriptionProvider.isPremium) {
      context.push('/premium');
      return false;
    }
    return true;
  }

  /// Premium gate widget - shows different content for premium/free users
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
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.lock,
                      size: 64,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Premium Feature',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Upgrade to Premium to access this feature',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => context.push('/premium'),
                      icon: const Icon(Icons.star),
                      label: const Text('Upgrade Now'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              );
        }
      },
    );
  }

  /// Show premium badge on features
  static Widget premiumBadge({
    bool mini = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: mini ? 6 : 8,
        vertical: mini ? 2 : 4,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.amber, Colors.orange],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star,
            size: mini ? 12 : 16,
            color: Colors.white,
          ),
          SizedBox(width: mini ? 2 : 4),
          Text(
            'PREMIUM',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: mini ? 8 : 10,
            ),
          ),
        ],
      ),
    );
  }

  /// Check if feature is available for free user
  static Future<bool> checkFeatureAccess({
    required BuildContext context,
    required String featureName,
    bool showPaywallIfLocked = true,
  }) async {
    final subscriptionProvider = context.read<SubscriptionProvider>();

    if (subscriptionProvider.isPremium) {
      return true;
    }

    // Show paywall
    if (showPaywallIfLocked) {
      final result = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.lock, color: Colors.amber),
              const SizedBox(width: 8),
              const Text('Premium Feature'),
            ],
          ),
          content: Text(
            '$featureName is only available for Premium users.\n\nUpgrade now to unlock unlimited access!',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context, true);
                context.push('/premium');
              },
              icon: const Icon(Icons.star),
              label: const Text('Upgrade'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
      return result ?? false;
    }

    return false;
  }

  /// Get subscription tier display name
  static String getTierDisplayName(SubscriptionTier tier) {
    switch (tier) {
      case SubscriptionTier.free:
        return 'Free';
      case SubscriptionTier.premium:
        return 'Premium';
      case SubscriptionTier.ultimate:
        return 'Ultimate';
    }
  }

  /// Get tier color
  static Color getTierColor(SubscriptionTier tier) {
    switch (tier) {
      case SubscriptionTier.free:
        return Colors.grey;
      case SubscriptionTier.premium:
        return Colors.amber;
      case SubscriptionTier.ultimate:
        return Colors.purple;
    }
  }

  /// Get tier icon
  static IconData getTierIcon(SubscriptionTier tier) {
    switch (tier) {
      case SubscriptionTier.free:
        return Icons.person;
      case SubscriptionTier.premium:
        return Icons.star;
      case SubscriptionTier.ultimate:
        return Icons.diamond;
    }
  }
}
