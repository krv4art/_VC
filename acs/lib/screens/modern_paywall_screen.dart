import 'package:flutter/material.dart';
import 'package:acs/theme/app_theme.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../theme/theme_extensions_v2.dart';
import '../providers/theme_provider_v2.dart';
import '../services/subscription_service.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../constants/app_dimensions.dart';
import '../widgets/common/app_spacer.dart';

enum Plan { monthly, yearly }

class ModernPaywallScreen extends StatefulWidget {
  const ModernPaywallScreen({super.key});

  @override
  State<ModernPaywallScreen> createState() => _ModernPaywallScreenState();
}

class _ModernPaywallScreenState extends State<ModernPaywallScreen>
    with TickerProviderStateMixin {
  bool _isTrialEnabled = true; // Default to enabled
  late AnimationController _animationController;
  late List<Animation<double>> _cardAnimations;

  // RevenueCat
  final SubscriptionService _subscriptionService = SubscriptionService();
  Offerings? _offerings;
  bool _isLoading = true;
  Package? _selectedPackage;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Create animations for each feature card with staggered delays
    _cardAnimations = List.generate(4, (index) {
      final start = index * 0.2; // 200ms delay for each card
      final end = start + 0.4;
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(start, end, curve: Curves.easeOut),
        ),
      );
    });

    // Start the animation when the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });

    // Load offerings from RevenueCat
    _loadOfferings();
  }

  Future<void> _loadOfferings() async {
    try {
      final offerings = await _subscriptionService.getOfferings();
      setState(() {
        _offerings = offerings;
        _isLoading = false;

        // Автоматически выбираем первый пакет как yearly, второй как monthly
        if (offerings?.current?.availablePackages != null) {
          final packages = offerings!.current!.availablePackages;
          if (packages.isNotEmpty) {
            _selectedPackage = packages.first; // По умолчанию первый пакет
          }
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading products: $e')));
      }
    }
  }

  Future<void> _handleRestorePurchases() async {
    setState(() => _isLoading = true);

    try {
      final success = await _subscriptionService.restorePurchases();

      if (!mounted) return;

      setState(() => _isLoading = false);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Purchases restored successfully!')),
        );
        context.go('/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No purchases to restore')),
        );
      }
    } catch (e) {
      if (!mounted) return;

      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error restoring purchases: $e')));
    }
  }

  Future<void> _handlePurchase() async {
    if (_selectedPackage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a subscription plan')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final success = await _subscriptionService.purchasePackage(
        _selectedPackage!,
      );

      if (!mounted) return;

      setState(() => _isLoading = false);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Subscription successful!')),
        );
        context.go('/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Purchase cancelled or failed')),
        );
      }
    } catch (e) {
      if (!mounted) return;

      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // Watch theme changes to trigger rebuild
    context.watch<ThemeProviderV2>();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              context.colors.background,
              context.colors.background.withValues(alpha: 0.9),
              context.colors.primaryPale.withValues(alpha: 0.3),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: AppDimensions.space16 + AppDimensions.space4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: AppDimensions.space16 + AppDimensions.space4),

                // Top section with close button and headline
                _buildTopSection(l10n),

                SizedBox(height: AppDimensions.space32 - AppDimensions.space4),

                // Feature cards in 2x2 grid
                _buildFeatureCards(l10n),

                const SizedBox(height: 0),

                // Trial toggle
                _buildTrialToggle(l10n),

                const SizedBox(height: 0),

                // Pricing cards
                _buildPricingCards(l10n),

                SizedBox(height: AppDimensions.space32 - AppDimensions.space4),

                // Subscribe button
                _buildSubscribeButton(l10n),

                AppSpacer.v16(),

                // Trial description
                _buildTrialDescription(l10n),

                SizedBox(height: AppDimensions.space16 + AppDimensions.space4),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopSection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // First row: Close button and Restore button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Close button
            IconButton(
              icon: Icon(Icons.close, size: AppDimensions.iconMedium),
              color: context.colors.onBackground, // Adapts to theme
              onPressed: () {
                context.go('/home');
              },
            ),
            // Restore button
            TextButton(
              onPressed: _isLoading ? null : _handleRestorePurchases,
              child: Text(
                l10n.restore,
                style: AppTheme.body.copyWith(
                  color: context.colors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        AppSpacer.v8(),
        // Second row: Value proposition headline - centered
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppDimensions.space16 + AppDimensions.space4),
          child: Text(
            l10n.unlockUnlimitedAccess,
            textAlign: TextAlign.center,
            style: AppTheme.h2.copyWith(
              color: context.colors.primary, // Use ACS natural green
              fontSize: AppDimensions.iconMedium,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureCards(AppLocalizations l10n) {
    final features = [
      {
        'icon': Icons.shield_outlined,
        'color': context.colors.primary,
        'bgColor': context.colors.primary.withValues(alpha: 0.1),
        'text': l10n.unlimitedProductScans,
      },
      {
        'icon': Icons.support_agent,
        'color': context.colors.info,
        'bgColor': context.colors.primary.withValues(alpha: 0.1),
        'text': l10n.personalAIConsultant,
      },
      {
        'icon': Icons.history,
        'color': context.colors.warning,
        'bgColor': context.colors.primary.withValues(alpha: 0.1),
        'text': l10n.fullScanAndSearchHistory,
      },
      {
        'icon': Icons.ad_units_outlined,
        'color': context.colors.error, // Red for "no ads"
        'bgColor': context.colors.primary.withValues(alpha: 0.1),
        'text': l10n.adFreeExperience,
      },
    ];

    return Column(
      children: [
        for (int i = 0; i < features.length; i++)
          AnimatedBuilder(
            animation: _cardAnimations[i],
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, 20 * (1 - _cardAnimations[i].value)),
                child: Opacity(opacity: _cardAnimations[i].value, child: child),
              );
            },
            child: _buildFeatureCard(
              features[i]['icon'] as IconData,
              features[i]['color'] as Color,
              features[i]['bgColor'] as Color,
              features[i]['text'] as String,
            ),
          ),
      ],
    );
  }

  Widget _buildFeatureCard(
    IconData icon,
    Color iconColor,
    Color bgColor,
    String text,
  ) {
    return Container(
      height: AppDimensions.buttonLarge + AppDimensions.space4, // Уменьшить высоту для вертикального списка
      width: double.infinity, // Растянуть на всю ширину
      margin: EdgeInsets.only(bottom: AppDimensions.space8), // Отступ между карточками
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.space16, vertical: AppDimensions.space8),
      decoration: BoxDecoration(
        color: context.colors.surface.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(AppDimensions.radius16),
        boxShadow: [
          BoxShadow(
            color: context.colors.shadowColor.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        // Изменить на Row для горизонтального расположения
        children: [
          Container(
            width: AppDimensions.space32 + AppDimensions.space4, // Уменьшен с 48 до 36
            height: AppDimensions.space32 + AppDimensions.space4, // Уменьшен с 48 до 36
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(AppDimensions.space8 + AppDimensions.space4), // Уменьшен с 12 до 10
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: AppDimensions.iconSmall + AppDimensions.space4,
            ), // Уменьшен с 24 до 18
          ),
          AppSpacer.h16(),
          Expanded(
            child: Text(
              text,
              style: AppTheme.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                color: context.colors.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrialToggle(AppLocalizations l10n) {
    return Row(
      children: [
        Text(
          'Start with 7-day free trial',
          style: AppTheme.body.copyWith(
            color: context.colors.onBackground,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Switch(
          value: _isTrialEnabled,
          onChanged: (bool value) {
            setState(() {
              _isTrialEnabled = value;
            });
          },
          activeColor: context.colors.primary,
          activeTrackColor: context.colors.primary.withValues(alpha: 0.3),
        ),
      ],
    );
  }

  Widget _buildPricingCards(AppLocalizations l10n) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_offerings?.current?.availablePackages == null ||
        _offerings!.current!.availablePackages.isEmpty) {
      return const Center(child: Text('No subscription plans available'));
    }

    final packages = _offerings!.current!.availablePackages;

    return Column(
      children: packages.asMap().entries.map((entry) {
        final index = entry.key;
        final package = entry.value;
        final isSelected = _selectedPackage == package;

        // Определяем тип плана по идентификатору пакета
        String title = package.storeProduct.title;
        String? savings;

        // Если это годовой план, показываем экономию
        if (package.identifier.toLowerCase().contains('annual') ||
            package.identifier.toLowerCase().contains('yearly') ||
            package.identifier.toLowerCase().contains('year')) {
          savings = l10n.savePercentage(
            33,
          ); // Можно вычислить реальную экономию
        }

        return Padding(
          padding: EdgeInsets.only(
            bottom: index < packages.length - 1 ? 16 : 0,
          ),
          child: _buildPlanCard(
            isSelected: isSelected,
            title: title,
            price: package.storeProduct.priceString,
            pricePerMonth: '', // Уже включено в priceString
            savings: savings,
            onTap: () => setState(() => _selectedPackage = package),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPlanCard({
    required bool isSelected,
    required String title,
    required String price,
    required String pricePerMonth,
    String? savings,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(AppDimensions.space16 + AppDimensions.space4),
        decoration: BoxDecoration(
          color: isSelected
              ? context.colors.primary
              : context.colors.cardBackground,
          borderRadius: BorderRadius.circular(
            AppTheme.radiusCard,
          ), // Use ACS radius
          border: Border.all(
            color: isSelected
                ? context.colors.primary
                : context.colors.onSecondary.withValues(
                    alpha: 0.3,
                  ), // Use ACS medium grey
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: context.colors.shadowColor.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ] // Use theme-aware colored shadow
              : [
                  BoxShadow(
                    color: context.colors.shadowColor.withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ], // Use theme-aware soft shadow
        ),
        child: Row(
          children: [
            // Selection indicator
            Container(
              width: AppDimensions.iconMedium,
              height: AppDimensions.iconMedium,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? Colors.transparent
                      : context.colors.onSecondary, // Use ACS medium grey
                  width: 2,
                ),
                color: isSelected ? context.colors.primary : Colors.transparent,
              ),
              child: isSelected
                  ? Icon(Icons.check, color: context.colors.surface, size: AppDimensions.iconSmall)
                  : null,
            ),
            AppSpacer.h16(),
            // Plan details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: isSelected
                          ? context.colors.surface
                          : context.colors.onBackground,
                      fontSize: AppDimensions.iconSmall + AppDimensions.space4,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AppSpacer.v4(),
                  Text(
                    '$price$pricePerMonth',
                    style: TextStyle(
                      color: isSelected
                          ? context.colors.surface.withValues(
                              alpha: 0.9,
                            ) // Slightly transparent white
                          : context.colors.onSurface, // Adapts to theme
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            // Savings badge
            if (savings != null)
              Container(
                padding: EdgeInsets.symmetric(horizontal: AppDimensions.space8, vertical: AppDimensions.space4),
                decoration: BoxDecoration(
                  color: context.colors.surface,
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                ),
                child: Text(
                  savings,
                  style: TextStyle(
                    color: context.colors.primary, // Use ACS natural green
                    fontSize: AppDimensions.radius12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubscribeButton(AppLocalizations l10n) {
    return ElevatedButton(
      onPressed: _isLoading ? null : _handlePurchase,
      style: ElevatedButton.styleFrom(
        backgroundColor: context.colors.primary,
        foregroundColor: context.colors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        ),
        padding: EdgeInsets.symmetric(horizontal: AppDimensions.iconMedium),
        textStyle: AppTheme.buttonText.copyWith(fontSize: AppDimensions.iconSmall + AppDimensions.space4),
        minimumSize: Size(double.infinity, AppDimensions.buttonLarge + AppDimensions.space8),
        shadowColor: context.colors.shadowColor.withValues(alpha: 0.2),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          _isTrialEnabled ? l10n.tryFreeAndSubscribe : l10n.subscribe,
          maxLines: 1,
          overflow: TextOverflow.visible,
        ),
      ),
    );
  }

  Widget _buildTrialDescription(AppLocalizations l10n) {
    return Text(
      'After 7-day free trial, \$79.99/year will be charged. Cancel anytime.',
      textAlign: TextAlign.center,
      style: AppTheme.caption.copyWith(
        color: context.colors.onSurface, // Adapts to theme
        fontSize: AppDimensions.radius12, // Slightly larger for better readability
        height: 1.4,
      ),
    );
  }
}
