import 'package:flutter/material.dart';
import 'package:ai_photo_studio_pro/theme/app_theme.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
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

  // Animations for main buttons
  late Animation<double> _mainButtonScaleAnimation;
  late Animation<Offset> _mainButtonSlideAnimation;

  // Animations for quick actions section
  late Animation<double> _quickActionsTitleAnimation;
  late Animation<double> _quickActionsCard1Animation;
  late Animation<double> _quickActionsCard2Animation;

  // Animations for settings section
  late Animation<double> _settingsTitleAnimation;
  late Animation<double> _settingsItemAnimation;

  bool _isInitialized = false;
  bool _animationsStarted = false;

  final ImagePicker _imagePicker = ImagePicker();

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
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _isInitialized) {
      _restartAnimations();
    }
  }

  void _initializeAnimations() {
    _mainButtonController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _quickActionsController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _settingsController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

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

    _quickActionsTitleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _quickActionsController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeOutCubic),
      ),
    );

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

    _settingsTitleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _settingsController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeOutCubic),
      ),
    );

    _settingsItemAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _settingsController,
        curve: const Interval(0.1, 0.4, curve: Curves.easeOutCubic),
      ),
    );
  }

  void _startAnimations() {
    if (_animationsStarted) return;
    _animationsStarted = true;

    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) _mainButtonController.forward();
    });

    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _quickActionsController.forward();
    });

    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) _settingsController.forward();
    });
  }

  void _restartAnimations() {
    if (!_isInitialized) return;

    _mainButtonController.reset();
    _quickActionsController.reset();
    _settingsController.reset();
    _animationsStarted = false;

    _startAnimations();
  }

  void _resetAndRestartAnimations() {
    if (!mounted || !_isInitialized) return;

    _animationsStarted = false;
    _mainButtonController.reset();
    _quickActionsController.reset();
    _settingsController.reset();

    Future.delayed(const Duration(milliseconds: 50), () {
      if (mounted) {
        _startAnimations();
      }
    });
  }

  Future<void> _handleTakePhoto() async {
    context.push('/camera');
  }

  Future<void> _handleChoosePhoto() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (image != null && mounted) {
      // TODO: Navigate to style selection with the selected image
      // For now, just navigate to styles catalog
      context.push('/styles');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final userState = context.watch<UserState>();
    context.watch<ThemeProviderV2>();

    return BottomNavigationWrapper(
      onReturnToHome: _resetAndRestartAnimations,
      currentIndex: 0,
      child: ScaffoldWithDrawer(
        appBar: CustomAppBar(
          title: l10n.appName,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(AppDimensions.space16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppTheme.space8),

                  // Welcome message
                  Text(
                    l10n.welcomeMessage,
                    style: AppTheme.h2.copyWith(
                      color: context.colors.onBackground,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AppSpacer.v24(),

                  // Main action buttons with animation
                  AnimatedBuilder(
                    animation: _mainButtonController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _mainButtonScaleAnimation.value,
                        child: SlideTransition(
                          position: _mainButtonSlideAnimation,
                          child: Column(
                            children: [
                              // Take Photo button
                              Container(
                                width: double.infinity,
                                height: AppDimensions.buttonLarge +
                                    AppDimensions.space64,
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
                                  onPressed: _handleTakePhoto,
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
                                            ? const Color(0xFF1A1A1A)
                                            : Colors.white,
                                      ),
                                      AppSpacer.v16(),
                                      Text(
                                        l10n.takePhoto,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: AppDimensions.space16 +
                                              AppDimensions.space4,
                                          fontWeight: FontWeight.bold,
                                          color: context.colors.isDark
                                              ? const Color(0xFF1A1A1A)
                                              : Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              AppSpacer.v16(),
                              // Choose from Gallery button
                              Container(
                                width: double.infinity,
                                height: AppDimensions.buttonLarge +
                                    AppDimensions.space16,
                                decoration: BoxDecoration(
                                  color: context.colors.cardBackground,
                                  borderRadius: BorderRadius.circular(
                                    AppDimensions.radius24,
                                  ),
                                  border: Border.all(
                                    color: context.colors.primary,
                                    width: 2,
                                  ),
                                ),
                                child: ElevatedButton(
                                  onPressed: _handleChoosePhoto,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        AppDimensions.radius24,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.photo_library_outlined,
                                        size: AppDimensions.iconLarge,
                                        color: context.colors.primary,
                                      ),
                                      AppSpacer.h12(),
                                      Text(
                                        l10n.chooseFromGallery,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: AppDimensions.space16,
                                          fontWeight: FontWeight.bold,
                                          color: context.colors.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  AppSpacer.v32(),

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
                                position: Tween<Offset>(
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
                                  l10n.myPhotos,
                                  Icons.photo_album_outlined,
                                  () => context.push('/gallery'),
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
                                position: Tween<Offset>(
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
                                  l10n.stylesCatalog,
                                  Icons.style_outlined,
                                  () => context.push('/styles'),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  AppSpacer.v16(),

                  // New AI Features Row
                  Row(
                    children: [
                      Expanded(
                        child: AnimatedBuilder(
                          animation: _quickActionsCard1Animation,
                          builder: (context, child) {
                            return FadeTransition(
                              opacity: _quickActionsCard1Animation,
                              child: _buildQuickAction(
                                context,
                                'AI Editor',
                                Icons.auto_fix_high,
                                () => context.push('/advanced-editor'),
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
                              child: _buildQuickAction(
                                context,
                                'Batch Gen',
                                Icons.burst_mode,
                                () => context.push('/batch-generation'),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  AppSpacer.v32(),

                  // Settings section - only show subscription if not premium
                  if (!userState.isPremium) ...[
                    AnimatedBuilder(
                      animation: _settingsTitleAnimation,
                      builder: (context, child) {
                        return FadeTransition(
                          opacity: _settingsTitleAnimation,
                          child: Text(
                            l10n.unlockPremium,
                            style: AppTheme.h3.copyWith(
                              color: context.colors.onBackground,
                            ),
                          ),
                        );
                      },
                    ),
                    AppSpacer.v16(),

                    AnimatedBuilder(
                      animation: _settingsItemAnimation,
                      builder: (context, child) {
                        return FadeTransition(
                          opacity: _settingsItemAnimation,
                          child: SlideTransition(
                            position: Tween<Offset>(
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
                              Icons.workspace_premium_outlined,
                              () => context.push('/paywall'),
                            ),
                          ),
                        );
                      },
                    ),
                    AppSpacer.v32(),
                  ],

                  // Poll Widget
                  const PollWidget(),
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: AppDimensions.iconLarge,
            color: context.colors.onBackground,
          ),
          AppSpacer.v8(),
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
  );
}

Widget _buildSettingItem(
  BuildContext context,
  String title,
  IconData icon,
  VoidCallback onTap,
) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.all(AppDimensions.space16),
      decoration: BoxDecoration(
        gradient: context.colors.primaryGradient,
        borderRadius: BorderRadius.circular(AppDimensions.radius16),
        boxShadow: [
          AppTheme.getColoredShadow(context.colors.shadowColor),
        ],
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: AppDimensions.iconMedium,
          ),
          AppSpacer.h16(),
          Expanded(
            child: Text(
              title,
              style: AppTheme.bodyLarge.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: AppDimensions.iconSmall,
            color: Colors.white,
          ),
        ],
      ),
    ),
  );
}
