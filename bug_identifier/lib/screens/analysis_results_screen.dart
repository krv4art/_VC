import 'package:flutter/material.dart';
import 'package:bug_identifier/theme/app_theme.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/analysis_result.dart';
import '../l10n/app_localizations.dart';
import '../providers/user_state.dart';
import '../providers/subscription_provider.dart';
import '../services/chat_context_service.dart';
import '../services/usage_tracking_service.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/scaffold_with_drawer.dart';
import '../widgets/bottom_navigation_wrapper.dart';
import '../theme/theme_extensions_v2.dart';
import '../widgets/animated/animated_card.dart';
import '../constants/app_dimensions.dart';
import '../widgets/common/app_spacer.dart';

class AnalysisResultsScreen extends StatefulWidget {
  final AnalysisResult result;
  final String imagePath;
  final String source; // 'scanning' or 'history'
  const AnalysisResultsScreen({
    super.key,
    required this.result,
    required this.imagePath,
    this.source = 'scanning',
  });

  @override
  State<AnalysisResultsScreen> createState() => _AnalysisResultsScreenState();
}

class _AnalysisResultsScreenState extends State<AnalysisResultsScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _fabAnimationController;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    // Main staggered animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // FAB animation controller
    _fabAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    // Create staggered animations for different sections
    // Increased from 5 to 10 to support new UI components
    _animations = List.generate(10, (index) {
      final startTime = index * 0.06; // 60ms delay between elements
      final endTime = startTime + 0.5; // 500ms duration for each animation

      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            startTime,
            endTime.clamp(0.0, 1.0),
            curve: Curves.easeOutCubic,
          ),
        ),
      );
    });

    // Start animations after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
      // Start FAB animation after main animations
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          _fabAnimationController.forward();
        }
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _fabAnimationController.dispose();
    super.dispose();
  }

  void _handleBackNavigation(BuildContext context) {
    if (widget.source == 'history') {
      // Вернуться в историю сканирований
      context.go('/history');
    } else {
      // По умолчанию вернуться в экран сканирования
      context.go('/scanning');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _handleBackNavigation(context);
        }
      },
      child: BottomNavigationWrapper(
        currentIndex:
            -1, // Не выделяем ни одну кнопку, так как это экран результатов
        child: ScaffoldWithDrawer(
          backgroundColor: context.colors.background,
          appBar: CustomAppBar(
            title: l10n.analysisResults,
            showBackButton: true,
            onBackPressed: () => _handleBackNavigation(context),
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.all(AppDimensions.space16),
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Score Card - Animation 0
                        FadeTransition(
                          opacity: _animations[0],
                          child: SlideTransition(
                            position:
                                Tween<Offset>(
                                  begin: const Offset(0, 0.3),
                                  end: Offset.zero,
                                ).animate(
                                  CurvedAnimation(
                                    parent: _animationController,
                                    curve: const Interval(
                                      0.0,
                                      0.6,
                                      curve: Curves.easeOutCubic,
                                    ),
                                  ),
                                ),
                            child: _buildScoreCard(l10n),
                          ),
                        ),
                        AppSpacer.v16(),

                        // Product Context - Animation 1 (NEW)
                        FadeTransition(
                          opacity: _animations[1],
                          child: SlideTransition(
                            position:
                                Tween<Offset>(
                                  begin: const Offset(0, 0.3),
                                  end: Offset.zero,
                                ).animate(
                                  CurvedAnimation(
                                    parent: _animationController,
                                    curve: const Interval(
                                      0.06,
                                      0.56,
                                      curve: Curves.easeOutCubic,
                                    ),
                                  ),
                                ),
                            child: _buildProductContext(l10n),
                          ),
                        ),
                        AppSpacer.v16(),

                        // AI Verdict - Animation 2 (NEW)
                        FadeTransition(
                          opacity: _animations[2],
                          child: SlideTransition(
                            position:
                                Tween<Offset>(
                                  begin: const Offset(0, 0.3),
                                  end: Offset.zero,
                                ).animate(
                                  CurvedAnimation(
                                    parent: _animationController,
                                    curve: const Interval(
                                      0.12,
                                      0.62,
                                      curve: Curves.easeOutCubic,
                                    ),
                                  ),
                                ),
                            child: _buildAIVerdict(l10n),
                          ),
                        ),
                        AppSpacer.v16(),

                        // Quick Summary - Animation 3 (NEW)
                        FadeTransition(
                          opacity: _animations[3],
                          child: SlideTransition(
                            position:
                                Tween<Offset>(
                                  begin: const Offset(0, 0.3),
                                  end: Offset.zero,
                                ).animate(
                                  CurvedAnimation(
                                    parent: _animationController,
                                    curve: const Interval(
                                      0.18,
                                      0.68,
                                      curve: Curves.easeOutCubic,
                                    ),
                                  ),
                                ),
                            child: _buildQuickSummary(l10n),
                          ),
                        ),
                        AppSpacer.v16(),

                        // Action Buttons - Animation 4 (NEW)
                        FadeTransition(
                          opacity: _animations[4],
                          child: SlideTransition(
                            position:
                                Tween<Offset>(
                                  begin: const Offset(0, 0.3),
                                  end: Offset.zero,
                                ).animate(
                                  CurvedAnimation(
                                    parent: _animationController,
                                    curve: const Interval(
                                      0.24,
                                      0.74,
                                      curve: Curves.easeOutCubic,
                                    ),
                                  ),
                                ),
                            child: _buildActionButtons(l10n),
                          ),
                        ),
                        AppSpacer.v32(),

                        // Personalized Warnings - Animation 5
                        if (widget.result.personalizedWarnings.isNotEmpty)
                          FadeTransition(
                            opacity: _animations[5],
                            child: SlideTransition(
                              position:
                                  Tween<Offset>(
                                    begin: const Offset(0, 0.3),
                                    end: Offset.zero,
                                  ).animate(
                                    CurvedAnimation(
                                      parent: _animationController,
                                      curve: const Interval(
                                        0.30,
                                        0.80,
                                        curve: Curves.easeOutCubic,
                                      ),
                                    ),
                                  ),
                              child: _buildSection(
                                title: l10n.personalizedWarnings,
                                children: widget.result.personalizedWarnings
                                    .map(
                                      (warning) =>
                                          _buildWarningItem(warning, context),
                                    )
                                    .toList(),
                                context: context,
                              ),
                            ),
                          ),

                        // Premium Insights - Animation 6 (NEW)
                        FadeTransition(
                          opacity: _animations[6],
                          child: SlideTransition(
                            position:
                                Tween<Offset>(
                                  begin: const Offset(0, 0.3),
                                  end: Offset.zero,
                                ).animate(
                                  CurvedAnimation(
                                    parent: _animationController,
                                    curve: const Interval(
                                      0.36,
                                      0.86,
                                      curve: Curves.easeOutCubic,
                                    ),
                                  ),
                                ),
                            child: _buildPremiumInsights(l10n),
                          ),
                        ),
                        AppSpacer.v32(),

                        // Ingredients Analysis - Animation 7
                        FadeTransition(
                          opacity: _animations[7],
                          child: SlideTransition(
                            position:
                                Tween<Offset>(
                                  begin: const Offset(0, 0.3),
                                  end: Offset.zero,
                                ).animate(
                                  CurvedAnimation(
                                    parent: _animationController,
                                    curve: const Interval(
                                      0.42,
                                      0.92,
                                      curve: Curves.easeOutCubic,
                                    ),
                                  ),
                                ),
                            child: _buildSection(
                              title: l10n.ingredientsAnalysis(
                                widget.result.ingredients.length,
                              ),
                              children: [
                                _buildIngredientList(
                                  l10n.highRisk,
                                  widget.result.highRiskIngredients,
                                  Colors.red,
                                  context,
                                ),
                                _buildIngredientList(
                                  l10n.moderateRisk,
                                  widget.result.moderateRiskIngredients,
                                  Colors.orange,
                                  context,
                                ),
                                _buildIngredientList(
                                  l10n.lowRisk,
                                  widget.result.lowRiskIngredients,
                                  Colors.green,
                                  context,
                                ),
                              ],
                              context: context,
                            ),
                          ),
                        ),

                        // Benefits Analysis - Animation 8
                        FadeTransition(
                          opacity: _animations[8],
                          child: SlideTransition(
                            position:
                                Tween<Offset>(
                                  begin: const Offset(0, 0.3),
                                  end: Offset.zero,
                                ).animate(
                                  CurvedAnimation(
                                    parent: _animationController,
                                    curve: const Interval(
                                      0.48,
                                      0.98,
                                      curve: Curves.easeOutCubic,
                                    ),
                                  ),
                                ),
                            child: _buildSection(
                              title: l10n.benefitsAnalysis,
                              children: [
                                Text(
                                  widget.result.benefitsAnalysis,
                                  style: AppTheme.body.copyWith(
                                    color: context.colors.onBackground,
                                  ),
                                ),
                              ],
                              context: context,
                            ),
                          ),
                        ),

                        // Recommended Alternatives - Animation 9
                        if (widget.result.recommendedAlternatives.isNotEmpty)
                          FadeTransition(
                            opacity: _animations[9],
                            child: SlideTransition(
                              position:
                                  Tween<Offset>(
                                    begin: const Offset(0, 0.3),
                                    end: Offset.zero,
                                  ).animate(
                                    CurvedAnimation(
                                      parent: _animationController,
                                      curve: const Interval(
                                        0.54,
                                        1.0,
                                        curve: Curves.easeOutCubic,
                                      ),
                                    ),
                                  ),
                              child: _buildSection(
                                title: l10n.recommendedAlternatives,
                                children: widget.result.recommendedAlternatives
                                    .map(
                                      (alt) => _buildAlternativeItem(
                                        context,
                                        alt,
                                        l10n,
                                      ),
                                    )
                                    .toList(),
                                context: context,
                              ),
                            ),
                          ),

                        // Extra bottom padding to prevent FAB overlap
                        // FAB height (~80px) + safe area
                        SizedBox(
                          height: AppDimensions.space64 + AppDimensions.space24,
                        ),
                      ],
                    );
                  },
                ),
              ),

              // Floating AI Chat Button at bottom
              Positioned(
                bottom: AppDimensions.space16,
                left: AppDimensions.space16,
                right: AppDimensions.space16,
                child: Consumer<SubscriptionProvider>(
                  builder: (context, subscriptionProvider, child) {
                    return FutureBuilder<bool>(
                      future: UsageTrackingService().canUserSendMessage(),
                      builder: (context, snapshot) {
                        final canSendMessage =
                            subscriptionProvider.isPremium ||
                            (snapshot.data ?? true);

                        return FadeTransition(
                          opacity: _fabAnimationController,
                          child: SlideTransition(
                            position:
                                Tween<Offset>(
                                  begin: const Offset(0, 1.0),
                                  end: Offset.zero,
                                ).animate(
                                  CurvedAnimation(
                                    parent: _fabAnimationController,
                                    curve: Curves.easeOutCubic,
                                  ),
                                ),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: canSendMessage
                                    ? context.colors.primaryGradient
                                    : LinearGradient(
                                        colors: [
                                          Colors.grey.shade400,
                                          Colors.grey.shade500,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.radius24,
                                ),
                                boxShadow: [
                                  AppTheme.getColoredShadow(
                                    context.colors.shadowColor,
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: canSendMessage
                                    ? () => _discussWithAI(context)
                                    : () {
                                        // Показываем диалог для апгрейда
                                        showDialog(
                                          context: context,
                                          builder:
                                              (
                                                BuildContext dialogContext,
                                              ) => AlertDialog(
                                                title: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.lock,
                                                      color: context
                                                          .colors
                                                          .warning,
                                                    ),
                                                    AppSpacer.h12(),
                                                    Text(
                                                      l10n.dailyMessageLimitReached,
                                                    ),
                                                  ],
                                                ),
                                                content: Text(
                                                  l10n.dailyMessageLimitReachedMessage,
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.of(
                                                          dialogContext,
                                                        ).pop(),
                                                    child: Text(l10n.cancel),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.of(
                                                        dialogContext,
                                                      ).pop();
                                                      context.push(
                                                        '/modern-paywall',
                                                      );
                                                    },
                                                    style:
                                                        ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              context
                                                                  .colors
                                                                  .primary,
                                                        ),
                                                    child: Text(
                                                      l10n.upgradeToPremium,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                        );
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  padding: EdgeInsets.symmetric(
                                    vertical: AppDimensions.space16,
                                    horizontal: AppDimensions.space24,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      AppTheme.radiusLarge,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      canSendMessage ? Icons.chat : Icons.lock,
                                      color: Colors.white,
                                    ),
                                    AppSpacer.h8(),
                                    Text(
                                      canSendMessage
                                          ? l10n.discussWithAI
                                          : l10n.upgradeToChat,
                                      style: AppTheme.button.copyWith(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _discussWithAI(BuildContext context) async {
    debugPrint('=== ANALYSIS DEBUG: _discussWithAI called ===');

    // Сохраняем всё необходимое из контекста ДО асинхронных операций
    final subscriptionProvider = context.read<SubscriptionProvider>();
    final userState = Provider.of<UserState>(context, listen: false);
    final navigator = Navigator.of(context);
    final colors = context.colors;
    final usageService = UsageTrackingService();

    if (!subscriptionProvider.isPremium) {
      final canSend = await usageService.canUserSendMessage();

      if (!canSend) {
        if (!mounted) return;

        // Показываем диалог с предложением оформить подписку
        bool shouldUpgrade = false;
        if (mounted) {
          shouldUpgrade =
              await showDialog<bool>(
                // ignore: use_build_context_synchronously
                context: context,
                builder: (BuildContext ctx) {
                  final dialogL10n = AppLocalizations.of(ctx)!;
                  return AlertDialog(
                    title: Row(
                      children: [
                        Icon(Icons.lock, color: colors.warning),
                        AppSpacer.h12(),
                        Text(dialogL10n.dailyMessageLimitReached),
                      ],
                    ),
                    content: Text(dialogL10n.dailyMessageLimitReachedMessage),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(false),
                        child: Text(dialogL10n.cancel),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.of(ctx).pop(true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.primary,
                        ),
                        child: Text(dialogL10n.upgradeToPremium),
                      ),
                    ],
                  );
                },
              ) ??
              false;
        }

        if (shouldUpgrade && mounted) {
          navigator.pushNamed('/modern-paywall');
        }

        return; // Блокируем переход в чат
      }

      // Увеличиваем счетчик сообщений
      await usageService.incrementMessagesCount();
    }

    // Создаем полный контекст (профиль пользователя + результаты сканирования)
    final fullContext = ChatContextService.generateFullContext(
      userState,
      widget.result,
    );

    // Переходим в AI чат с полным контекстом и путем к изображению
    if (mounted) {
      debugPrint('=== ANALYSIS DEBUG: Navigating to chat ===');
      // Сохраняем контекст перед асинхронной операцией
      final router = GoRouter.of(super.context);
      router.push(
        '/chat',
        extra: {'scanContext': fullContext, 'scanImagePath': widget.imagePath},
      );
      debugPrint('=== ANALYSIS DEBUG: Navigation initiated ===');
    }
  }

  Widget _buildScoreCard(AppLocalizations l10n) {
    final scoreColor = widget.result.overallSafetyScore >= 7
        ? context.colors.primary
        : widget.result.overallSafetyScore >= 4
        ? AppTheme.orange
        : AppTheme.red;

    return AnimatedEntranceCard(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(AppDimensions.space16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [scoreColor.withValues(alpha: 0.8), scoreColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppDimensions.radius24),
        ),
        child: Column(
          children: [
            Text(
              l10n.overallSafetyScore,
              style: AppTheme.bodyLarge.copyWith(color: Colors.white),
            ),
            AppSpacer.h12(),
            Text(
              widget.result.overallSafetyScore.toStringAsFixed(1),
              style: AppTheme.h1.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
    required BuildContext context,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppDimensions.space32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTheme.h3.copyWith(color: context.colors.onBackground),
          ),
          AppSpacer.v16(),
          ...children,
        ],
      ),
    );
  }

  Widget _buildWarningItem(String warning, BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppDimensions.space12),
      padding: EdgeInsets.all(AppDimensions.space12),
      decoration: BoxDecoration(
        color: AppTheme.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radius12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: AppTheme.red,
            size: AppDimensions.iconMedium,
          ),
          AppSpacer.h12(),
          Expanded(
            child: Text(
              warning,
              style: AppTheme.body.copyWith(color: context.colors.onBackground),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientList(
    String title,
    List<IngredientInfo> ingredients,
    Color color,
    BuildContext context,
  ) {
    // Фильтруем пустые/испорченные ингредиенты
    final validIngredients = ingredients
        .where((ingredientInfo) => ingredientInfo.name.isNotEmpty)
        .toList();

    if (validIngredients.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(bottom: AppDimensions.space12),
      child: ExpansionTile(
        shape: const Border(), // Убираем стандартные dividers
        collapsedShape:
            const Border(), // Убираем dividers в свернутом состоянии
        leading: Icon(
          Icons.circle,
          color: color,
          size: AppDimensions.iconSmall,
        ),
        title: Text(
          '$title (${validIngredients.length})',
          style: AppTheme.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
            color: context.colors.onBackground,
          ),
        ),
        children: validIngredients
            .map(
              (ingredientInfo) => _buildIngredientItem(ingredientInfo, context),
            )
            .toList(),
      ),
    );
  }

  Widget _buildIngredientItem(
    IngredientInfo ingredientInfo,
    BuildContext context,
  ) {
    final l10n = AppLocalizations.of(context)!;

    return Consumer<SubscriptionProvider>(
      builder: (context, subscriptionProvider, _) {
        final isPremium = subscriptionProvider.isPremium;

        return ListTile(
          title: Row(
            children: [
              Expanded(
                child: Text(
                  _formatIngredientName(ingredientInfo),
                  style: AppTheme.body.copyWith(
                    color: context.colors.onBackground,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  isPremium ? Icons.info_outline : Icons.lock_outline,
                  size: AppDimensions.iconMedium,
                  color: isPremium
                      ? context.colors.primary
                      : context.colors.onSecondary.withValues(alpha: 0.5),
                ),
                onPressed: isPremium
                    ? () => _showIngredientHint(context, ingredientInfo)
                    : () => _showUpgradeDialogForIngredients(context),
                tooltip: isPremium ? ingredientInfo.name : l10n.premiumFeature,
              ),
            ],
          ),
        );
      },
    );
  }

  void _showIngredientHint(
    BuildContext context,
    IngredientInfo ingredientInfo,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        backgroundColor: context.colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radius24),
        ),
        title: Row(
          children: [
            Icon(
              Icons.lightbulb_outline,
              color: context.colors.primary,
              size: AppDimensions.iconMedium,
            ),
            AppSpacer.h8(),
            Expanded(
              child: Text(
                ingredientInfo.name,
                style: AppTheme.h3.copyWith(color: context.colors.onBackground),
              ),
            ),
          ],
        ),
        content: Text(
          ingredientInfo.hint,
          style: AppTheme.body.copyWith(color: context.colors.onSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              AppLocalizations.of(context)!.close,
              style: TextStyle(
                color: context.colors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showUpgradeDialogForIngredients(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        backgroundColor: context.colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radius24),
        ),
        title: Row(
          children: [
            Icon(
              Icons.lock,
              color: context.colors.warning,
              size: AppDimensions.iconMedium,
            ),
            AppSpacer.h12(),
            Expanded(
              child: Text(
                l10n.premiumFeature,
                style: AppTheme.h3.copyWith(color: context.colors.onBackground),
              ),
            ),
          ],
        ),
        content: Text(
          l10n.allIngredientsInfoDesc,
          style: AppTheme.body.copyWith(color: context.colors.onSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              l10n.cancel,
              style: TextStyle(color: context.colors.onSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.push('/modern-paywall');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colors.primary,
              foregroundColor: Colors.white,
            ),
            child: Text(l10n.upgradeToPremium),
          ),
        ],
      ),
    );
  }

  Widget _buildAlternativeItem(
    BuildContext context,
    RecommendedAlternative alt,
    AppLocalizations l10n,
  ) {
    return AnimatedCard(
      elevation: 0,
      margin: EdgeInsets.only(bottom: AppDimensions.space12),
      onTap: () {
        // Можно добавить действие при нажатии на альтернативу
      },
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              alt.name,
              style: AppTheme.bodyLarge.copyWith(
                fontWeight: FontWeight.bold,
                color: context.colors.onBackground,
              ),
            ),
            AppSpacer.v4(),
            Text(
              alt.description,
              style: AppTheme.body.copyWith(color: context.colors.onSecondary),
            ),
            AppSpacer.v8(),
            Text(
              '${l10n.reason} ${alt.reason}',
              style: AppTheme.caption.copyWith(
                color: context.colors.onSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Formats ingredient name with original name if available
  /// Shows original name when it exists and is different from translated name
  String _formatIngredientName(IngredientInfo ingredientInfo) {
    // If no original name, just show the translated name
    if (ingredientInfo.originalName == null ||
        ingredientInfo.originalName!.isEmpty) {
      return ingredientInfo.name;
    }

    // If original name is the same as translated name, just show one
    if (ingredientInfo.originalName == ingredientInfo.name) {
      return ingredientInfo.name;
    }

    // If names are different, always show both: "Translation (Original)"
    // This ensures consistent display regardless of script/alphabet
    return '${ingredientInfo.name} (${ingredientInfo.originalName})';
  }

  // ====== NEW UI COMPONENTS ======

  /// Product Context Widget - Shows product type and brand if available
  Widget _buildProductContext(AppLocalizations l10n) {
    // Only show if we have product type or brand name
    if (widget.result.productType == null && widget.result.brandName == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.all(AppDimensions.space16),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radius16),
        boxShadow: [AppTheme.shadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: context.colors.primary,
                size: AppDimensions.iconMedium,
              ),
              AppSpacer.h8(),
              Text(
                l10n.productInfo,
                style: AppTheme.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.colors.onBackground,
                ),
              ),
            ],
          ),
          if (widget.result.productType != null ||
              widget.result.brandName != null)
            AppSpacer.v12(),
          if (widget.result.productType != null)
            Row(
              children: [
                Icon(
                  Icons.category_outlined,
                  size: AppDimensions.iconSmall,
                  color: context.colors.onSecondary,
                ),
                AppSpacer.h8(),
                Text(
                  '${l10n.productType}: ',
                  style: AppTheme.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.colors.onSecondary,
                  ),
                ),
                Expanded(
                  child: Text(
                    widget.result.productType!,
                    style: AppTheme.body.copyWith(
                      color: context.colors.onBackground,
                    ),
                  ),
                ),
              ],
            ),
          if (widget.result.productType != null &&
              widget.result.brandName != null)
            AppSpacer.v8(),
          if (widget.result.brandName != null)
            Row(
              children: [
                Icon(
                  Icons.business_outlined,
                  size: AppDimensions.iconSmall,
                  color: context.colors.onSecondary,
                ),
                AppSpacer.h8(),
                Text(
                  '${l10n.brand}: ',
                  style: AppTheme.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.colors.onSecondary,
                  ),
                ),
                Expanded(
                  child: Text(
                    widget.result.brandName!,
                    style: AppTheme.body.copyWith(
                      color: context.colors.onBackground,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  /// AI Verdict Widget - Shows friendly AI summary
  Widget _buildAIVerdict(AppLocalizations l10n) {
    if (widget.result.aiSummary == null || widget.result.aiSummary!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.all(AppDimensions.space16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            context.colors.primary.withValues(alpha: 0.1),
            context.colors.primary.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radius16),
        border: Border.all(
          color: context.colors.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(AppDimensions.space8),
                decoration: BoxDecoration(
                  color: context.colors.primary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppDimensions.radius12),
                ),
                child: Icon(
                  Icons.smart_toy,
                  color: context.colors.primary,
                  size: AppDimensions.iconMedium,
                ),
              ),
              AppSpacer.h12(),
              Text(
                l10n.ourVerdict,
                style: AppTheme.h3.copyWith(color: context.colors.onBackground),
              ),
            ],
          ),
          AppSpacer.v12(),
          Text(
            widget.result.aiSummary!,
            style: AppTheme.body.copyWith(
              color: context.colors.onBackground,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  /// Quick Summary Widget - Shows key metrics at a glance
  Widget _buildQuickSummary(AppLocalizations l10n) {
    final totalIngredients = widget.result.ingredients.length;
    final highRisk = widget.result.highRiskIngredients.length;
    final moderateRisk = widget.result.moderateRiskIngredients.length;
    final lowRisk = widget.result.lowRiskIngredients.length;
    final warnings = widget.result.personalizedWarnings.length;

    return Container(
      padding: EdgeInsets.all(AppDimensions.space16),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radius16),
        boxShadow: [AppTheme.shadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.quickSummary,
            style: AppTheme.h3.copyWith(color: context.colors.onBackground),
          ),
          AppSpacer.v12(),
          _buildSummaryRow(
            Icons.check_circle_outline,
            '$totalIngredients ${l10n.ingredientsChecked}',
            context.colors.primary,
          ),
          AppSpacer.v8(),
          if (highRisk > 0)
            _buildSummaryRow(
              Icons.warning_amber_rounded,
              '$highRisk ${l10n.highRisk}',
              AppTheme.red,
            ),
          if (highRisk > 0) AppSpacer.v8(),
          if (moderateRisk > 0)
            _buildSummaryRow(
              Icons.info_outline,
              '$moderateRisk ${l10n.moderateRisk}',
              AppTheme.orange,
            ),
          if (moderateRisk > 0) AppSpacer.v8(),
          if (lowRisk > 0)
            _buildSummaryRow(
              Icons.check_circle,
              '$lowRisk ${l10n.lowRisk}',
              Colors.green,
            ),
          if (lowRisk > 0) AppSpacer.v8(),
          if (warnings > 0)
            _buildSummaryRow(
              Icons.notification_important,
              '$warnings ${l10n.personalWarnings}',
              context.colors.warning,
            ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, size: AppDimensions.iconSmall, color: color),
        AppSpacer.h8(),
        Text(
          text,
          style: AppTheme.body.copyWith(color: context.colors.onBackground),
        ),
      ],
    );
  }

  /// Action Buttons Panel - Quick actions for the analysis
  Widget _buildActionButtons(AppLocalizations l10n) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildActionButton(
            icon: Icons.favorite_border,
            label: l10n.saveToFavorites,
            onTap: () {
              // TODO: Implement save to favorites
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${l10n.saveToFavorites} - Coming soon'),
                ),
              );
            },
          ),
          AppSpacer.h8(),
          _buildActionButton(
            icon: Icons.share,
            label: l10n.shareResults,
            onTap: () {
              // TODO: Implement share
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${l10n.shareResults} - Coming soon')),
              );
            },
          ),
          AppSpacer.h8(),
          _buildActionButton(
            icon: Icons.compare_arrows,
            label: l10n.compareProducts,
            onTap: () {
              // TODO: Implement compare
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${l10n.compareProducts} - Coming soon'),
                ),
              );
            },
          ),
          AppSpacer.h8(),
          Consumer<SubscriptionProvider>(
            builder: (context, subscriptionProvider, _) {
              final isPremium = subscriptionProvider.isPremium;
              return _buildActionButton(
                icon: isPremium ? Icons.picture_as_pdf : Icons.lock,
                label: l10n.exportPDF,
                onTap: isPremium
                    ? () {
                        // TODO: Implement PDF export
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${l10n.exportPDF} - Coming soon'),
                          ),
                        );
                      }
                    : () => context.push('/modern-paywall'),
                isPremium: !isPremium,
              );
            },
          ),
          AppSpacer.h8(),
          _buildActionButton(
            icon: Icons.camera_alt,
            label: l10n.scanSimilar,
            onTap: () {
              context.go('/scanning');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isPremium = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radius12),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.space12,
          vertical: AppDimensions.space12,
        ),
        decoration: BoxDecoration(
          color: isPremium
              ? context.colors.warning.withValues(alpha: 0.1)
              : context.colors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radius12),
          border: isPremium
              ? Border.all(color: context.colors.warning.withValues(alpha: 0.3))
              : null,
          boxShadow: [AppTheme.shadow],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: AppDimensions.iconMedium,
              color: isPremium
                  ? context.colors.warning
                  : context.colors.primary,
            ),
            AppSpacer.v4(),
            Text(
              label,
              style: AppTheme.caption.copyWith(
                color: context.colors.onSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Premium Insights Widget - Shows premium data (research, ranking, trends)
  Widget _buildPremiumInsights(AppLocalizations l10n) {
    return Consumer<SubscriptionProvider>(
      builder: (context, subscriptionProvider, _) {
        final isPremium = subscriptionProvider.isPremium;

        // If not premium, show upgrade prompt
        if (!isPremium) {
          return Container(
            padding: EdgeInsets.all(AppDimensions.space16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  context.colors.warning.withValues(alpha: 0.2),
                  context.colors.warning.withValues(alpha: 0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppDimensions.radius16),
              border: Border.all(
                color: context.colors.warning.withValues(alpha: 0.5),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.workspace_premium,
                      color: context.colors.warning,
                      size: AppDimensions.iconLarge,
                    ),
                    AppSpacer.h12(),
                    Expanded(
                      child: Text(
                        l10n.premiumInsights,
                        style: AppTheme.h3.copyWith(
                          color: context.colors.onBackground,
                        ),
                      ),
                    ),
                  ],
                ),
                AppSpacer.v12(),
                Text(
                  'Unlock detailed scientific research, category rankings, and safety trends',
                  style: AppTheme.body.copyWith(
                    color: context.colors.onSecondary,
                  ),
                ),
                AppSpacer.v16(),
                ElevatedButton(
                  onPressed: () => context.push('/modern-paywall'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.colors.warning,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.space24,
                      vertical: AppDimensions.space12,
                    ),
                  ),
                  child: Text(l10n.upgradeToPremium),
                ),
              ],
            ),
          );
        }

        // If premium but no data, don't show anything
        if (widget.result.premiumInsights == null) {
          return const SizedBox.shrink();
        }

        final insights = widget.result.premiumInsights!;

        return Container(
          padding: EdgeInsets.all(AppDimensions.space16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                context.colors.primary.withValues(alpha: 0.2),
                context.colors.primary.withValues(alpha: 0.1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(AppDimensions.radius16),
            border: Border.all(
              color: context.colors.primary.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.workspace_premium,
                    color: context.colors.primary,
                    size: AppDimensions.iconLarge,
                  ),
                  AppSpacer.h12(),
                  Text(
                    l10n.premiumInsights,
                    style: AppTheme.h3.copyWith(
                      color: context.colors.onBackground,
                    ),
                  ),
                ],
              ),
              AppSpacer.v16(),
              if (insights.researchArticlesCount != null)
                _buildInsightRow(
                  Icons.science_outlined,
                  l10n.researchArticles,
                  '${insights.researchArticlesCount} articles',
                ),
              if (insights.researchArticlesCount != null) AppSpacer.v12(),
              if (insights.categoryRank != null)
                _buildInsightRow(
                  Icons.emoji_events_outlined,
                  l10n.categoryRanking,
                  insights.categoryRank!,
                ),
              if (insights.categoryRank != null) AppSpacer.v12(),
              if (insights.safetyTrend != null)
                _buildInsightRow(
                  Icons.trending_up,
                  l10n.safetyTrend,
                  insights.safetyTrend!,
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInsightRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          size: AppDimensions.iconMedium,
          color: context.colors.primary,
        ),
        AppSpacer.h12(),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTheme.caption.copyWith(
                  color: context.colors.onSecondary,
                ),
              ),
              AppSpacer.v4(),
              Text(
                value,
                style: AppTheme.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.colors.onBackground,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
