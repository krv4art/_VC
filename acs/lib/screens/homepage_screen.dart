import 'package:flutter/material.dart';
import 'package:acs/theme/app_theme.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../widgets/bottom_navigation_wrapper.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/scaffold_with_drawer.dart';
import '../l10n/app_localizations.dart';
import '../providers/user_state.dart';
import '../providers/theme_provider_v2.dart';
import '../theme/theme_extensions_v2.dart';
import '../constants/app_dimensions.dart';
import '../widgets/common/app_spacer.dart';
import '../widgets/poll_widget.dart';
import '../widgets/usage_indicator_widget.dart';

class HomepageScreen extends StatefulWidget {
  const HomepageScreen({super.key});

  @override
  State<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  // Animation controllers
  late AnimationController _mainButtonController;
  late AnimationController _quickActionsController;
  late AnimationController _settingsController;
  late AnimationController _pollController;

  // Animations for main scan button
  late Animation<double> _mainButtonScaleAnimation;
  late Animation<Offset> _mainButtonSlideAnimation;

  // Animations for quick actions section
  late Animation<double> _quickActionsTitleAnimation;
  late Animation<double> _quickActionsCard1Animation;
  late Animation<double> _quickActionsCard2Animation;

  // Animations for settings section
  late Animation<double> _settingsTitleAnimation;
  late List<Animation<double>> _settingsItemAnimations;

  // Animations for poll widget
  late Animation<double> _pollAnimation;

  bool _isInitialized = false;
  bool _animationsStarted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeAnimations();
    _isInitialized = true;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Запускаем анимации при первом изменении зависимостей
    if (_isInitialized && !_animationsStarted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _startAnimations();
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _mainButtonController.dispose();
    _quickActionsController.dispose();
    _settingsController.dispose();
    _pollController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _isInitialized) {
      // Не перезапускаем анимации при возврате, только при первом открытии экрана
      // Это предотвращает артефакты когда боттомшит открыт поверх главной страницы
      // _restartAnimations(); // Закомментировано чтобы избежать артефактов
    }
  }

  void _initializeAnimations() {
    // Main button animation controller (duration: 800ms)
    _mainButtonController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Quick actions animation controller (duration: 1000ms)
    _quickActionsController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Settings animation controller (duration: 1200ms)
    _settingsController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Poll animation controller (duration: 800ms)
    _pollController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Main button animations
    _mainButtonScaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainButtonController,
        curve: Curves.easeOutCubic,
      ),
    );

    _mainButtonSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _mainButtonController,
            curve: Curves.easeOutCubic,
          ),
        );

    // Quick actions title animation
    _quickActionsTitleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _quickActionsController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeOutCubic),
      ),
    );

    // Quick actions cards animations with staggered delays
    _quickActionsCard1Animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _quickActionsController,
        curve: const Interval(0.1, 0.6, curve: Curves.easeOutCubic),
      ),
    );

    _quickActionsCard2Animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _quickActionsController,
        curve: const Interval(0.16, 0.66, curve: Curves.easeOutCubic),
      ),
    );

    // Settings title animation
    _settingsTitleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _settingsController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeOutCubic),
      ),
    );

    // Initialize settings items animations
    _settingsItemAnimations = List.generate(4, (index) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _settingsController,
          curve: Interval(
            0.1 + (index * 0.06), // 60ms stagger between items
            0.4 + (index * 0.06),
            curve: Curves.easeOutCubic,
          ),
        ),
      );
    });

    // Poll widget animation
    _pollAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _pollController,
        curve: Curves.easeOutCubic,
      ),
    );
  }

  void _startAnimations() {
    if (_animationsStarted) return;
    _animationsStarted = true;

    // Start animations with delays between sections
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) _mainButtonController.forward();
    });

    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _quickActionsController.forward();
    });

    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) _settingsController.forward();
    });

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) _pollController.forward();
    });
  }

  void _restartAnimations() {
    if (!_isInitialized) return;

    // Сбрасываем анимации в начальное состояние
    _mainButtonController.reset();
    _quickActionsController.reset();
    _settingsController.reset();
    _pollController.reset();
    _animationsStarted = false;

    // Запускаем анимации заново
    _startAnimations();
  }

  // Метод для перезапуска анимаций при возврате на экран
  void _resetAndRestartAnimations() {
    if (!mounted || !_isInitialized) return;

    // Сбрасываем флаг
    _animationsStarted = false;

    // Сбрасываем контроллеры
    _mainButtonController.reset();
    _quickActionsController.reset();
    _settingsController.reset();
    _pollController.reset();

    // Запускаем заново с небольшой задержкой
    Future.delayed(const Duration(milliseconds: 50), () {
      if (mounted) {
        _startAnimations();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final userState = context.watch<UserState>();
    // Watch theme changes to trigger rebuild
    context.watch<ThemeProviderV2>();

    return BottomNavigationWrapper(
      onReturnToHome: _resetAndRestartAnimations,
      currentIndex: 0,
      child: ScaffoldWithDrawer(
        appBar: CustomAppBar(
          title: l10n.appName, // Using app name as title
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(AppDimensions.space16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //  const SizedBox(height: AppTheme.space20), // Use theme spacing
                  // Welcome text (removed 'Skin Analysis' as it's in AppBar)
                  const SizedBox(
                    height: AppTheme.space8,
                  ), // Removed if not needed after text removal
                  //   const SizedBox(height: 30),

                  // Main scan button with animation
                  AnimatedBuilder(
                    animation: _mainButtonController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _mainButtonScaleAnimation.value,
                        child: SlideTransition(
                          position: _mainButtonSlideAnimation,
                          child: Container(
                            width: double.infinity,
                            height:
                                AppDimensions.space64 +
                                AppDimensions.space64 +
                                AppDimensions.space64 +
                                AppDimensions.space8,
                            decoration: BoxDecoration(
                              gradient: context.colors.primaryGradient,
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
                              onPressed: () => context.push('/scanning'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppDimensions.radius24,
                                  ),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.camera_alt,
                                    size: AppDimensions.iconXLarge,
                                    color: context.colors.isDark
                                        ? const Color(
                                            0xFF1A1A1A,
                                          ) // Very dark gray for dark theme
                                        : Colors.white,
                                  ),
                                  AppSpacer.v16(),
                                  Text(
                                    l10n.startScanning,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize:
                                          AppDimensions.space16 +
                                          AppDimensions.space4,
                                      fontWeight: FontWeight.bold,
                                      color: context.colors.isDark
                                          ? const Color(
                                              0xFF1A1A1A,
                                            ) // Very dark gray for dark theme
                                          : Colors.white,
                                    ),
                                  ),
                                  AppSpacer.v8(),
                                  Text(
                                    l10n.checkYourCosmetics,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: AppDimensions.iconSmall,
                                      fontWeight: FontWeight.normal,
                                      height: 1.2, // межстрочный интервал
                                      color: context.colors.isDark
                                          ? const Color(
                                              0xFF1A1A1A,
                                            ) // Very dark gray for dark theme
                                          : Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  AppSpacer.v24(),

                  // Usage indicator (compact mode for free users)
                  const UsageIndicatorWidget(compact: true),
                  AppSpacer.v24(),

                  // Quick actions with animations
                  AnimatedBuilder(
                    animation: _quickActionsTitleAnimation,
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _quickActionsTitleAnimation,
                        child: Text(
                          l10n.quickActions,
                          style: AppTheme.h3.copyWith(
                            color: context.colors.onBackground,
                          ),
                        ),
                      );
                    },
                  ),
                  AppSpacer.v16(),

                  Row(
                    children: [
                      Expanded(
                        child: AnimatedBuilder(
                          animation: _quickActionsCard1Animation,
                          builder: (context, child) {
                            return FadeTransition(
                              opacity: _quickActionsCard1Animation,
                              child: SlideTransition(
                                position:
                                    Tween<Offset>(
                                      begin: const Offset(0.2, 0),
                                      end: Offset.zero,
                                    ).animate(
                                      CurvedAnimation(
                                        parent: _quickActionsController,
                                        curve: const Interval(
                                          0.1,
                                          0.6,
                                          curve: Curves.easeOutCubic,
                                        ),
                                      ),
                                    ),
                                child: _buildQuickAction(
                                  context,
                                  l10n.scanHistory,
                                  Icons.history,
                                  () => context.push('/history'),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      AppSpacer.h16(),
                      Expanded(
                        child: AnimatedBuilder(
                          animation: _quickActionsCard2Animation,
                          builder: (context, child) {
                            return FadeTransition(
                              opacity: _quickActionsCard2Animation,
                              child: SlideTransition(
                                position:
                                    Tween<Offset>(
                                      begin: const Offset(0.2, 0),
                                      end: Offset.zero,
                                    ).animate(
                                      CurvedAnimation(
                                        parent: _quickActionsController,
                                        curve: const Interval(
                                          0.16,
                                          0.66,
                                          curve: Curves.easeOutCubic,
                                        ),
                                      ),
                                    ),
                                child: _buildQuickAction(
                                  context,
                                  l10n.aiChats,
                                  Icons.chat_bubble_outline,
                                  () => context.push('/dialogues'),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  AppSpacer.v32(),

                  // Settings section with animations - показываем только если есть незаполненные настройки
                  if ((!userState.ageConfigured) ||
                      (!userState.skinTypeConfigured) ||
                      (!userState.allergiesConfigured)) ...[
                    AnimatedBuilder(
                      animation: _settingsTitleAnimation,
                      builder: (context, child) {
                        return FadeTransition(
                          opacity: _settingsTitleAnimation,
                          child: Text(
                            l10n.settings,
                            style: AppTheme.h3.copyWith(
                              color: context.colors.onBackground,
                            ),
                          ),
                        );
                      },
                    ),
                    AppSpacer.v16(),

                    // Показываем настройки только если они не установлены
                    // Animated settings items with stagger
                    AnimatedBuilder(
                      animation: _settingsController,
                      builder: (context, child) {
                        final settingsItems = <Widget>[];
                        int itemIndex = 0;

                        if (!userState.ageConfigured) {
                          settingsItems.add(
                            FadeTransition(
                              opacity: _settingsItemAnimations[itemIndex],
                              child: SlideTransition(
                                position:
                                    Tween<Offset>(
                                      begin: const Offset(-0.2, 0),
                                      end: Offset.zero,
                                    ).animate(
                                      CurvedAnimation(
                                        parent: _settingsController,
                                        curve: Interval(
                                          0.1 + (itemIndex * 0.06),
                                          0.4 + (itemIndex * 0.06),
                                          curve: Curves.easeOutCubic,
                                        ),
                                      ),
                                    ),
                                child: _buildSettingItem(
                                  context,
                                  l10n.age,
                                  Icons.cake_outlined,
                                  () => context.push('/age'),
                                ),
                              ),
                            ),
                          );
                          itemIndex++;
                        }

                        if (!userState.skinTypeConfigured) {
                          settingsItems.add(
                            FadeTransition(
                              opacity: _settingsItemAnimations[itemIndex],
                              child: SlideTransition(
                                position:
                                    Tween<Offset>(
                                      begin: const Offset(-0.2, 0),
                                      end: Offset.zero,
                                    ).animate(
                                      CurvedAnimation(
                                        parent: _settingsController,
                                        curve: Interval(
                                          0.1 + (itemIndex * 0.06),
                                          0.4 + (itemIndex * 0.06),
                                          curve: Curves.easeOutCubic,
                                        ),
                                      ),
                                    ),
                                child: _buildSettingItem(
                                  context,
                                  l10n.skinType,
                                  Icons.face,
                                  () => context.push('/skintype'),
                                ),
                              ),
                            ),
                          );
                          itemIndex++;
                        }

                        if (!userState.allergiesConfigured) {
                          settingsItems.add(
                            FadeTransition(
                              opacity: _settingsItemAnimations[itemIndex],
                              child: SlideTransition(
                                position:
                                    Tween<Offset>(
                                      begin: const Offset(-0.2, 0),
                                      end: Offset.zero,
                                    ).animate(
                                      CurvedAnimation(
                                        parent: _settingsController,
                                        curve: Interval(
                                          0.1 + (itemIndex * 0.06),
                                          0.4 + (itemIndex * 0.06),
                                          curve: Curves.easeOutCubic,
                                        ),
                                      ),
                                    ),
                                child: _buildSettingItem(
                                  context,
                                  l10n.allergiesSensitivities,
                                  Icons.warning_amber_outlined,
                                  () => context.push('/allergies'),
                                ),
                              ),
                            ),
                          );
                          itemIndex++;
                        }

                        return Column(children: settingsItems);
                      },
                    ),
                    AppSpacer.v32(),
                  ],

                  // Subscription card - показываем отдельно, без заголовка, только если не оформлена
                  if (!userState.isPremium) ...[
                    AnimatedBuilder(
                      animation: _settingsController,
                      builder: (context, child) {
                        return FadeTransition(
                          opacity: _settingsController,
                          child: SlideTransition(
                            position:
                                Tween<Offset>(
                                  begin: const Offset(-0.2, 0),
                                  end: Offset.zero,
                                ).animate(
                                  CurvedAnimation(
                                    parent: _settingsController,
                                    curve: const Interval(
                                      0.1,
                                      0.4,
                                      curve: Curves.easeOutCubic,
                                    ),
                                  ),
                                ),
                            child: _buildSettingItem(
                              context,
                              l10n.subscription,
                              Icons.card_membership_outlined,
                              () => context.push('/modern-paywall'),
                              withBottomMargin: false,
                            ),
                          ),
                        );
                      },
                    ),
                  ],

                  // Отступ перед Poll Widget
                  AppSpacer.v32(),

                  // Poll Widget - добавлен под секцией настроек с анимацией
                  AnimatedBuilder(
                    animation: _pollAnimation,
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _pollAnimation,
                        child: SlideTransition(
                          position:
                              Tween<Offset>(
                                begin: const Offset(-0.2, 0),
                                end: Offset.zero,
                              ).animate(
                                CurvedAnimation(
                                  parent: _pollController,
                                  curve: Curves.easeOutCubic,
                                ),
                              ),
                          child: const PollWidget(),
                        ),
                      );
                    },
                  ),
                  AppSpacer.v32(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildQuickAction(
  BuildContext context,
  String label,
  IconData icon,
  VoidCallback onTap,
) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: AppDimensions.buttonLarge + AppDimensions.space48,
      decoration: BoxDecoration(
        color: context.colors.cardBackground,
        borderRadius: BorderRadius.circular(AppDimensions.radius12),
        border: Border.all(
          color: context.colors.onSecondary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              icon,
              size: AppDimensions.iconLarge,
              color: context.colors.onBackground,
            ),
            Text(
              label,
              textAlign: TextAlign.center,
              style: AppTheme.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                color: context.colors.onBackground,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildSettingItem(
  BuildContext context,
  String title,
  IconData icon,
  VoidCallback onTap, {
  bool withBottomMargin = true,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      margin: withBottomMargin ? EdgeInsets.only(bottom: AppDimensions.space12) : EdgeInsets.zero,
      padding: EdgeInsets.all(AppDimensions.space16),
      decoration: BoxDecoration(
        color: context.colors.cardBackground,
        borderRadius: BorderRadius.circular(AppDimensions.radius16),
        border: Border.all(
          color: context.colors.onSecondary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: context.colors.onBackground,
            size: AppDimensions.iconMedium,
          ),
          AppSpacer.h16(),
          Expanded(
            child: Text(
              title,
              style: AppTheme.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
                color: context.colors.onBackground,
              ),
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: AppDimensions.iconSmall,
            color: context.colors.onSecondary,
          ),
        ],
      ),
    ),
  );
}
