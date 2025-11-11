import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import '../theme/app_theme.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../theme/theme_extensions_v2.dart';
import '../providers/theme_provider_v2.dart';
import '../providers/subscription_provider.dart';
import '../services/subscription_service.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../constants/app_dimensions.dart';
import '../widgets/common/app_spacer.dart';

class NewPaywallScreen extends StatefulWidget {
  const NewPaywallScreen({super.key});

  @override
  State<NewPaywallScreen> createState() => _NewPaywallScreenState();
}

class _NewPaywallScreenState extends State<NewPaywallScreen>
    with TickerProviderStateMixin {
  // Animation
  late AnimationController _controller;
  late List<Animation<double>> _featureAnimations;

  // RevenueCat
  final SubscriptionService _subscriptionService = SubscriptionService();
  bool _isLoading = true;
  Package? _selectedPackage;

  @override
  void initState() {
    super.initState();
    _loadOfferings();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Create 10 staggered animations (0-9)
    // Each animation starts slightly after the previous one
    _featureAnimations = List.generate(10, (index) {
      final startTime = (index * 0.08).clamp(0.0, 0.7); // Max start at 0.7
      final endTime = (startTime + 0.3).clamp(0.0, 1.0); // Duration of 0.3s

      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(startTime, endTime, curve: Curves.easeOutCubic),
        ),
      );
    });
  }

  void _startAnimations() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.stop();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadOfferings() async {
    try {
      final offerings = await _subscriptionService.getOfferings();
      setState(() {
        _isLoading = false;

        if (offerings?.current?.availablePackages != null) {
          final packages = offerings!.current!.availablePackages;

          // Ищем недельную подписку
          _selectedPackage = packages.firstWhereOrNull(
            (package) =>
                package.identifier.toLowerCase().contains('weekly') ||
                package.identifier.toLowerCase().contains('week') ||
                package.storeProduct.identifier.toLowerCase().contains(
                  'weekly',
                ) ||
                package.storeProduct.identifier.toLowerCase().contains('week'),
          );
          _selectedPackage ??= packages.firstOrNull;
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

  Future<void> _handlePurchase() async {
    if (_selectedPackage == null) {
      // Сохраняем контекст до асинхронной операции
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      scaffoldMessenger.showSnackBar(
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
        // Обновляем статус подписки в провайдере
        final subscriptionProvider = context.read<SubscriptionProvider>();
        await subscriptionProvider.checkStatus();

        if (!mounted) return;

        // Сохраняем контекст до асинхронной операции
        final scaffoldMessenger = ScaffoldMessenger.of(context);
        final router = GoRouter.of(context);

        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Subscription successful!')),
        );
        router.go('/home');
      } else {
        // Сохраняем контекст до асинхронной операции
        final scaffoldMessenger = ScaffoldMessenger.of(context);
        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Purchase cancelled or failed')),
        );
      }
    } catch (e) {
      if (!mounted) return;

      setState(() => _isLoading = false);
      // Сохраняем контекст до асинхронной операции
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      scaffoldMessenger.showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _handleRestore() async {
    setState(() => _isLoading = true);

    try {
      final success = await _subscriptionService.restorePurchases();

      if (!mounted) return;

      setState(() => _isLoading = false);

      if (success) {
        // Обновляем статус подписки в провайдере
        final subscriptionProvider = context.read<SubscriptionProvider>();
        await subscriptionProvider.checkStatus();

        if (!mounted) return;

        // Сохраняем контекст и локализацию до асинхронной операции
        final l10n = AppLocalizations.of(context)!;
        final scaffoldMessenger = ScaffoldMessenger.of(context);
        final router = GoRouter.of(context);

        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text(l10n.subscriptionRestored)),
        );
        router.go('/home');
      } else {
        // Сохраняем контекст и локализацию до асинхронной операции
        final l10n = AppLocalizations.of(context)!;
        final scaffoldMessenger = ScaffoldMessenger.of(context);
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text(l10n.noPurchasesToRestore)),
        );
      }
    } catch (e) {
      if (!mounted) return;

      setState(() => _isLoading = false);
      // Сохраняем контекст до асинхронной операции
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      scaffoldMessenger.showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    context.watch<ThemeProviderV2>();

    return Scaffold(
      body: Stack(
        children: [
          // Main scrollable content (entire screen)
          SingleChildScrollView(
            child: Column(
              children: [
                // Top section with image and close button
                _buildTopImageSection(l10n),

                // Feature comparison list
                _buildFeaturesList(l10n),

                SizedBox(
                  height:
                      AppDimensions.space64 +
                      AppDimensions.space32 +
                      AppDimensions.space4,
                ), // Space for bottom button
              ],
            ),
          ),

          // Bottom button with transparent background overlay
          _buildBottomButton(l10n),
        ],
      ),
    );
  }

  Widget _buildTopImageSection(AppLocalizations l10n) {
    return Stack(
      children: [
        // Background image
        Container(
          height: 300,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/paywall/paywall_image.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),

        // Close button overlay
        SafeArea(
          child: Padding(
            padding: EdgeInsets.all(AppDimensions.space8),
            child: Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.white.withValues(alpha: 0.9),
                  size: AppDimensions.iconMedium,
                ),
                onPressed: () {
                  context.go('/home');
                },
              ),
            ),
          ),
        ),

        // Title and description overlay at the bottom of image
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  context.colors.background.withValues(alpha: 0.4),
                  context.colors.background.withValues(alpha: 0.8),
                  context.colors.background,
                ],
                stops: const [0.0, 0.3, 0.7, 1.0],
              ),
            ),
            padding: EdgeInsets.fromLTRB(
              AppDimensions.space16 + AppDimensions.space4,
              AppDimensions.space40,
              AppDimensions.space16 + AppDimensions.space4,
              AppDimensions.radius12,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  l10n.paywallTitle,
                  textAlign: TextAlign.center,
                  style: AppTheme.h3.copyWith(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),
                AppSpacer.v8(),
                Text(
                  _selectedPackage != null
                      ? l10n.paywallDescription(
                          _selectedPackage!.storeProduct.priceString,
                        )
                      : l10n.paywallDescription('...'),
                  textAlign: TextAlign.center,
                  style: AppTheme.bodySmall.copyWith(
                    color: context.colors.onSurface.withValues(alpha: 0.85),
                    fontSize: 11,
                    height: 1.4,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturesList(AppLocalizations l10n) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppDimensions.iconMedium,
        right: AppDimensions.iconMedium,
        top: 0,
        bottom: 0,
      ),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Restore button at the top - Animation 0
              FadeTransition(
                opacity: _featureAnimations[0],
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.2),
                    end: Offset.zero,
                  ).animate(_featureAnimations[0]),
                  child: Center(
                    child: TextButton(
                      onPressed: _isLoading ? null : _handleRestore,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppDimensions.space8,
                          vertical: AppDimensions.space4,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        l10n.restorePurchases,
                        style: AppTheme.bodySmall.copyWith(
                          color: context.colors.onSurface.withValues(
                            alpha: 0.6,
                          ),
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                          decorationColor: context.colors.onSurface.withValues(
                            alpha: 0.6,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              AppSpacer.v16(),

              // Section header - Animation 1
              FadeTransition(
                opacity: _featureAnimations[1],
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.2),
                    end: Offset.zero,
                  ).animate(_featureAnimations[1]),
                  child: Center(
                    child: Text(
                      l10n.whatsIncluded,
                      style: AppTheme.h3.copyWith(
                        color: context.colors.onBackground,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              AppSpacer.v8(),

              // Tabs - Animation 2
              FadeTransition(
                opacity: _featureAnimations[2],
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.2),
                    end: Offset.zero,
                  ).animate(_featureAnimations[2]),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        l10n.basicPlan,
                        style: AppTheme.body.copyWith(
                          color: context.colors.onSurface.withValues(
                            alpha: 0.3,
                          ),
                          fontSize: 14,
                        ),
                      ),
                      AppSpacer.h24(),
                      Text(
                        l10n.premiumPlan,
                        style: AppTheme.body.copyWith(
                          color: context.colors.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              AppSpacer.v16(),

              // Features list - Animations 3-9
              _buildAnimatedFeatureItem(
                l10n.revolutionaryAI,
                l10n.revolutionaryAIDesc,
                baseIncluded: true,
                premiumIncluded: true,
                animation: _featureAnimations[3],
              ),
              _buildAnimatedFeatureItem(
                l10n.unlimitedScans,
                l10n.unlimitedScansDesc,
                baseIncluded: false,
                premiumIncluded: true,
                animation: _featureAnimations[4],
              ),
              _buildAnimatedFeatureItem(
                l10n.unlimitedChats,
                l10n.unlimitedChatsDesc,
                baseIncluded: false,
                premiumIncluded: true,
                animation: _featureAnimations[5],
              ),
              _buildAnimatedFeatureItem(
                l10n.fullHistory,
                l10n.fullHistoryDesc,
                baseIncluded: false,
                premiumIncluded: true,
                animation: _featureAnimations[6],
              ),
              _buildAnimatedFeatureItem(
                l10n.allIngredientsInfo,
                l10n.allIngredientsInfoDesc,
                baseIncluded: false,
                premiumIncluded: true,
                animation: _featureAnimations[7],
              ),
              _buildAnimatedFeatureItem(
                l10n.noAds,
                l10n.noAdsDesc,
                baseIncluded: false,
                premiumIncluded: true,
                animation: _featureAnimations[8],
              ),
              _buildAnimatedFeatureItem(
                l10n.multiLanguage,
                l10n.multiLanguageDesc,
                baseIncluded: false,
                premiumIncluded: true,
                animation: _featureAnimations[9],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAnimatedFeatureItem(
    String title,
    String subtitle, {
    required bool baseIncluded,
    required bool premiumIncluded,
    bool isNew = false,
    required Animation<double> animation,
  }) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.2),
          end: Offset.zero,
        ).animate(animation),
        child: _buildFeatureItem(
          title,
          subtitle,
          baseIncluded: baseIncluded,
          premiumIncluded: premiumIncluded,
          isNew: isNew,
        ),
      ),
    );
  }

  Widget _buildFeatureItem(
    String title,
    String subtitle, {
    required bool baseIncluded,
    required bool premiumIncluded,
    bool isNew = false,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: AppDimensions.radius12),
      padding: EdgeInsets.all(AppDimensions.space16),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radius12),
        border: Border.all(
          color: context.colors.onSecondary.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: AppTheme.body.copyWith(
                          color: context.colors.onBackground,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (isNew)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppDimensions.space8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: context.colors.warning,
                          borderRadius: BorderRadius.circular(
                            AppDimensions.space4,
                          ),
                        ),
                        child: Text(
                          'Новое!',
                          style: AppTheme.caption.copyWith(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                AppSpacer.v4(),
                Text(
                  subtitle,
                  style: AppTheme.bodySmall.copyWith(
                    color: context.colors.onSurface.withValues(alpha: 0.7),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          AppSpacer.h16(),

          // Status icons
          Row(
            children: [
              // Base version icon
              Container(
                width: AppDimensions.iconMedium,
                height: AppDimensions.iconMedium,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: baseIncluded
                      ? context.colors.onSurface.withValues(alpha: 0.1)
                      : Colors.transparent,
                  border: Border.all(
                    color: baseIncluded
                        ? context.colors.onSurface.withValues(alpha: 0.3)
                        : context.colors.onSurface.withValues(alpha: 0.3),
                  ),
                ),
                child: baseIncluded
                    ? Icon(
                        Icons.check,
                        size: AppDimensions.iconSmall,
                        color: context.colors.onSurface.withValues(alpha: 0.3),
                      )
                    : Icon(
                        Icons.lock_outline,
                        size: 14,
                        color: context.colors.onSurface.withValues(alpha: 0.3),
                      ),
              ),
              AppSpacer.h12(),

              // Premium version icon
              Container(
                width: AppDimensions.iconMedium,
                height: AppDimensions.iconMedium,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: premiumIncluded
                      ? context.colors.primary.withValues(alpha: 0.2)
                      : Colors.transparent,
                  border: Border.all(
                    color: premiumIncluded
                        ? context.colors.primary
                        : context.colors.onSurface.withValues(alpha: 0.3),
                  ),
                ),
                child: premiumIncluded
                    ? Icon(
                        Icons.check,
                        size: AppDimensions.iconSmall,
                        color: context.colors.primary,
                      )
                    : Icon(
                        Icons.lock_outline,
                        size: 14,
                        color: context.colors.onSurface.withValues(alpha: 0.3),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton(AppLocalizations l10n) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              context.colors.background.withValues(alpha: 0.0),
              context.colors.background.withValues(alpha: 0.4),
              context.colors.background.withValues(alpha: 0.6),
            ],
          ),
        ),
        padding: EdgeInsets.all(AppDimensions.iconMedium),
        child: SafeArea(
          top: false,
          child: SizedBox(
            width: double.infinity,
            height: AppDimensions.buttonLarge + AppDimensions.space8,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handlePurchase,
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.primary,
                foregroundColor: context.colors.onPrimary,
                elevation: 4,
                shadowColor: context.colors.shadowColor.withValues(alpha: 0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.iconMedium,
                ),
              ),
              child: _isLoading
                  ? SizedBox(
                      width: AppDimensions.iconMedium,
                      height: AppDimensions.iconMedium,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          context.colors.surface,
                        ),
                      ),
                    )
                  : Text(
                      l10n.tryFree,
                      style: AppTheme.buttonText.copyWith(
                        fontSize: AppDimensions.iconSmall,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
