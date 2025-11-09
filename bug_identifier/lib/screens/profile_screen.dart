import 'package:bug_identifier/providers/ai_bot_provider.dart';
import 'package:bug_identifier/services/local_data_service.dart';
import 'package:bug_identifier/services/storage_service.dart';
import 'package:bug_identifier/services/subscription_service.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:bug_identifier/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/user_state.dart';
import '../providers/locale_provider.dart';
import '../providers/theme_provider_v2.dart';
import '../widgets/bottom_navigation_wrapper.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/scaffold_with_drawer.dart';
import '../l10n/app_localizations.dart';
import '../theme/theme_extensions_v2.dart';
import '../widgets/animated/animated_card.dart';
import '../widgets/animated/animated_button.dart' as btn;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  final ImagePicker _picker = ImagePicker();
  late AnimationController _animationController;
  late List<Animation<double>> _animations;
  bool _isRestoringPurchases = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    // Create staggered animations for different sections
    _animations = List.generate(6, (index) {
      final startTime = index * 0.08; // 80ms delay between elements
      final endTime = startTime + 0.4; // 400ms duration for each animation

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
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Picks an image, converts it to base64, and saves it to state.
  Future<void> _pickAndSaveImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      try {
        final Uint8List imageBytes = await image.readAsBytes();
        final String base64String = base64Encode(imageBytes);

        if (mounted) {
          // Сохраняем провайдер до асинхронной операции
          final userState = Provider.of<UserState>(context, listen: false);
          await userState.updatePhotoBase64(base64String);
        }
      } catch (e) {
        if (mounted) {
          // Сохраняем контекст и локализацию до асинхронной операции
          final l10n = AppLocalizations.of(context)!;
          final scaffoldMessenger = ScaffoldMessenger.of(context);
          scaffoldMessenger.showSnackBar(
            SnackBar(
              backgroundColor: context.colors.surface,
              content: Text(
                '${l10n.failedToSaveImage} ${e.toString()}',
                style: AppTheme.body.copyWith(color: context.colors.onSurface),
              ),
            ),
          );
        }
      }
    }
  }

  // Shows a dialog to edit the user's name
  Future<void> _showEditNameDialog() async {
    final l10n = AppLocalizations.of(context)!;
    final userState = Provider.of<UserState>(context, listen: false);
    final nameController = TextEditingController(text: userState.name);

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: context.colors.surface,
          title: Text(
            l10n.editName,
            style: TextStyle(color: context.colors.onBackground),
          ),
          content: TextField(
            controller: nameController,
            autofocus: true,
            style: TextStyle(color: context.colors.onBackground),
            decoration: InputDecoration(
              hintText: l10n.enterYourName,
              hintStyle: TextStyle(color: context.colors.onSecondary),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                l10n.cancel,
                style: TextStyle(color: context.colors.onBackground),
              ),
            ),
            TextButton(
              onPressed: () {
                final newName = nameController.text;
                if (newName.isNotEmpty) {
                  userState.updateUserInfo(newName, userState.email);
                  Navigator.of(context).pop();
                }
              },
              style: TextButton.styleFrom(
                foregroundColor: context.colors.primary,
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: AppTheme.fontFamilySerif,
                ),
              ),
              child: Text(l10n.save),
            ),
          ],
        );
      },
    );
  }

  // Shows a dialog to confirm clearing all data
  Future<void> _showClearDataDialog() async {
    final l10n = AppLocalizations.of(context)!;

    // Состояние чекбоксов (по умолчанию все выбраны)
    bool clearScans = true;
    bool clearChats = true;
    bool clearPersonalData = true;

    final result = await showDialog<Map<String, bool>>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: context.colors.surface,
            title: Text(
              l10n.clearAllData,
              style: TextStyle(color: context.colors.onBackground),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.selectDataToClear,
                  style: TextStyle(
                    color: context.colors.onBackground,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                CheckboxListTile(
                  title: Text(
                    l10n.scanResults,
                    style: TextStyle(color: context.colors.onBackground),
                  ),
                  value: clearScans,
                  onChanged: (value) {
                    setState(() {
                      clearScans = value ?? true;
                    });
                  },
                  activeColor: context.colors.primary,
                  checkColor: Colors.white,
                  contentPadding: EdgeInsets.zero,
                ),
                CheckboxListTile(
                  title: Text(
                    l10n.chatHistory,
                    style: TextStyle(color: context.colors.onBackground),
                  ),
                  value: clearChats,
                  onChanged: (value) {
                    setState(() {
                      clearChats = value ?? true;
                    });
                  },
                  activeColor: context.colors.primary,
                  checkColor: Colors.white,
                  contentPadding: EdgeInsets.zero,
                ),
                CheckboxListTile(
                  title: Text(
                    l10n.personalData,
                    style: TextStyle(color: context.colors.onBackground),
                  ),
                  value: clearPersonalData,
                  onChanged: (value) {
                    setState(() {
                      clearPersonalData = value ?? true;
                    });
                  },
                  activeColor: context.colors.primary,
                  checkColor: Colors.white,
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(null),
                child: Text(
                  l10n.cancel,
                  style: TextStyle(color: context.colors.onBackground),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Проверяем, что хотя бы что-то выбрано
                  if (!clearScans && !clearChats && !clearPersonalData) {
                    return;
                  }
                  Navigator.of(dialogContext).pop({
                    'clearScans': clearScans,
                    'clearChats': clearChats,
                    'clearPersonalData': clearPersonalData,
                  });
                },
                child: Text(
                  l10n.clearData,
                  style: TextStyle(color: context.colors.error),
                ),
              ),
            ],
          );
        },
      ),
    );

    if (result != null && mounted) {
      // Сохраняем контекст и локализацию до асинхронной операции
      final l10n = AppLocalizations.of(context)!;
      final scaffoldMessenger = ScaffoldMessenger.of(context);

      // Комплексная очистка выбранных данных
      await _clearAllData(
        clearScans: result['clearScans'] ?? false,
        clearChats: result['clearChats'] ?? false,
        clearPersonalData: result['clearPersonalData'] ?? false,
      );
      if (mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            backgroundColor: context.colors.surface,
            content: Text(
              l10n.allLocalDataHasBeenCleared,
              style: AppTheme.body.copyWith(color: context.colors.onSurface),
            ),
          ),
        );
      }
    }
  }

  // Комплексный метод очистки всех данных
  Future<void> _clearAllData({
    bool clearScans = true,
    bool clearChats = true,
    bool clearPersonalData = true,
  }) async {
    try {
      debugPrint('=== Начало очистки данных ===');

      // 1. Очистка личных данных (с сохранением лимитов использования)
      if (clearPersonalData) {
        debugPrint(
          'Шаг 1: Очистка личных данных с сохранением лимитов использования',
        );
        if (mounted) {
          final userState = Provider.of<UserState>(context, listen: false);
          // clearAllData автоматически сохраняет счётчики использования
          await userState.clearAllData(preservePremium: true);
          debugPrint('Личные данные очищены, лимиты сохранены');
        } else {
          debugPrint('Виджет не mounted, пропускаем очистку личных данных');
        }

        // 2. Сброс языковых настроек (немедленно)
        debugPrint('Шаг 2: Сброс языковых настроек');
        if (mounted) {
          final localeProvider = Provider.of<LocaleProvider>(
            context,
            listen: false,
          );
          localeProvider.clearStateImmediately();
          debugPrint('Языковые настройки сброшены');
        } else {
          debugPrint('Виджет не mounted, пропускаем сброс языковых настроек');
        }

        // 3. Сброс настроек AI-бота
        debugPrint('Шаг 3: Сброс настроек AI-бота');
        if (mounted) {
          await Provider.of<AiBotProvider>(
            context,
            listen: false,
          ).resetToDefault();
          debugPrint('Настройки AI-бота сброшены');
        } else {
          debugPrint('Виджет не mounted, пропускаем сброс настроек AI-бота');
        }
      }

      // 3. Очистка базы данных (выборочно)
      debugPrint('Шаг 4: Очистка базы данных');
      await LocalDataService.instance.clearAllData(
        clearScans: clearScans,
        clearChats: clearChats,
        clearPersonalData: clearPersonalData,
      );
      debugPrint('База данных очищена');

      // 5. Очистка всех изображений, если выбрана очистка сканирований
      if (clearScans) {
        debugPrint('Шаг 5: Очистка всех изображений');
        await StorageService().clearAllImages();
        debugPrint('Изображения очищены');
      }

      // 6. Принудительное обновление состояния после всех операций
      if (clearPersonalData && mounted) {
        final userState = Provider.of<UserState>(context, listen: false);

        // Небольшая задержка перед разрешением автозагрузки, чтобы UI успел обновиться
        await Future.delayed(Duration(milliseconds: 500));

        // Разрешаем автозагрузку данных для будущих операций
        userState.enableAutoLoad();
        debugPrint('Автозагрузка данных разрешена');
      }

      debugPrint('=== Все данные успешно очищены ===');
    } catch (e) {
      debugPrint('Ошибка при очистке данных: $e');
    }
  }

  // Restore purchases
  Future<void> _handleRestorePurchases() async {
    if (_isRestoringPurchases) return; // Предотвращаем множественные нажатия

    setState(() {
      _isRestoringPurchases = true;
    });

    final l10n = AppLocalizations.of(context)!;
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      final subscriptionService = SubscriptionService();
      final success = await subscriptionService.restorePurchases();

      if (!mounted) return;

      if (success) {
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text(l10n.subscriptionRestored)),
        );
      } else {
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text(l10n.noPurchasesToRestore)),
        );
      }
    } catch (e) {
      if (!mounted) return;
      scaffoldMessenger.showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) {
        setState(() {
          _isRestoringPurchases = false;
        });
      }
    }
  }

  String _getNativeLanguageName(Locale locale) {
    final languageCode = locale.languageCode;
    switch (languageCode) {
      case 'en':
        return 'English';
      case 'ru':
        return 'Русский';
      case 'uk':
        return 'Українська';
      case 'de':
        return 'Deutsch';
      case 'fr':
        return 'Français';
      case 'es':
        return 'Español';
      default:
        return languageCode.toUpperCase();
    }
  }

  String? _getLocalizedSkinType(String? skinType, AppLocalizations l10n) {
    if (skinType == null) return null;
    switch (skinType.toLowerCase()) {
      case 'normal':
        return l10n.normal;
      case 'dry':
        return l10n.dry;
      case 'oily':
        return l10n.oily;
      case 'combination':
        return l10n.combination;
      case 'sensitive':
        return l10n.sensitive;
      default:
        return skinType;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final userState = context.watch<UserState>();
    // Watch theme changes to trigger rebuild
    context.watch<ThemeProviderV2>();

    ImageProvider? backgroundImage;
    if (userState.photoBase64 != null) {
      try {
        backgroundImage = MemoryImage(base64Decode(userState.photoBase64!));
      } catch (e) {
        // Handle potential base64 decoding errors
        backgroundImage = null;
      }
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          context.go('/home');
        }
      },
      child: BottomNavigationWrapper(
        currentIndex: 3,
        child: ScaffoldWithDrawer(
          appBar: CustomAppBar(title: l10n.profile),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Column(
                    children: [
                      // Avatar - Animation 0
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
                                    0.4,
                                    curve: Curves.easeOutCubic,
                                  ),
                                ),
                              ),
                          child: GestureDetector(
                            onTap: _pickAndSaveImage,
                            child: AnimatedEntranceCard(
                              duration: const Duration(milliseconds: 600),
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: context.colors.primary,
                                    width: 2,
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: 60,
                                  backgroundColor: context.colors.surface,
                                  backgroundImage: backgroundImage,
                                  child: backgroundImage == null
                                      ? Icon(
                                          Icons.person,
                                          size: 60,
                                          color: context.colors.onSecondary,
                                        )
                                      : null,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // User Info - Animation 1
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
                                    0.08,
                                    0.48,
                                    curve: Curves.easeOutCubic,
                                  ),
                                ),
                              ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                userState.name ?? l10n.userName,
                                style: AppTheme.h2.copyWith(
                                  color: context.colors.onBackground,
                                ),
                              ),
                              btn.AnimatedIconButton(
                                icon: Icons.edit_outlined,
                                iconSize: 20,
                                onPressed: _showEditNameDialog,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),

                      // User Status - Animation 2
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
                                    0.16,
                                    0.56,
                                    curve: Curves.easeOutCubic,
                                  ),
                                ),
                              ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                userState.isPremium
                                    ? l10n.premiumUser
                                    : l10n.freeUser,
                                style: AppTheme.caption.copyWith(
                                  color: context.colors.onSecondary,
                                ),
                              ),
                              if (!userState.isPremium) ...[
                                const SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () => context.push('/modern-paywall'),
                                  child: Text(
                                    l10n.goPremium,
                                    style: AppTheme.caption.copyWith(
                                      color: context.colors.primary,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Skin Profile Section - Animation 3
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
                                    0.24,
                                    0.64,
                                    curve: Curves.easeOutCubic,
                                  ),
                                ),
                              ),
                          child: _buildSection(l10n.skinProfile, [
                            _buildMenuItem(
                              icon: Icons.cake_outlined,
                              title: l10n.age,
                              trailing: Text(
                                userState.ageRange ?? l10n.notSet,
                                style: AppTheme.caption.copyWith(
                                  color: context.colors.onSecondary,
                                ),
                              ),
                              onTap: () => context.push('/age'),
                            ),
                            _buildMenuItem(
                              icon: Icons.face_outlined,
                              title: l10n.skinType,
                              trailing: Text(
                                _getLocalizedSkinType(
                                      userState.skinType,
                                      l10n,
                                    ) ??
                                    l10n.notSet,
                                style: AppTheme.caption.copyWith(
                                  color: context.colors.onSecondary,
                                ),
                              ),
                              onTap: () => context.push('/skintype'),
                            ),
                            _buildMenuItem(
                              icon: Icons.shield_outlined,
                              title: l10n.allergiesSensitivities,
                              onTap: () => context.push('/allergies'),
                            ),
                          ]),
                        ),
                      ),

                      // Settings Section - Animation 4
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
                                    0.32,
                                    0.72,
                                    curve: Curves.easeOutCubic,
                                  ),
                                ),
                              ),
                          child: _buildSection(l10n.settings, [
                            _buildMenuItem(
                              icon: Icons.language,
                              title: l10n.language,
                              trailing: Text(
                                _getNativeLanguageName(
                                  context.watch<LocaleProvider>().locale ??
                                      Localizations.localeOf(context),
                                ),
                                style: AppTheme.caption.copyWith(
                                  color: context.colors.onSecondary,
                                ),
                              ),
                              onTap: () => context.push('/language'),
                            ),
                            _buildMenuItem(
                              icon: Icons.palette_outlined,
                              title: l10n.themes,
                              onTap: () => context.push('/theme-selection'),
                            ),
                            _buildMenuItem(
                              icon: Icons.tune,
                              title: l10n.aiBotSettings,
                              onTap: () => context.push('/ai-bot-settings'),
                            ),
                            // Test screen button
                            _buildMenuItem(
                              icon: Icons.science,
                              title: 'Subscription Test',
                              trailing: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: context.colors.warning.withValues(
                                    alpha: 0.2,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'TEST',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: context.colors.warning,
                                  ),
                                ),
                              ),
                              onTap: () => context.push('/usage-limits-test'),
                            ),
                          ]),
                        ),
                      ),

                      // Legal & Data Management Sections - Animation 5
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
                                    0.4,
                                    0.8,
                                    curve: Curves.easeOutCubic,
                                  ),
                                ),
                              ),
                          child: Column(
                            children: [
                              _buildSection(l10n.legal, [
                                _buildMenuItem(
                                  icon: Icons.lock_outline,
                                  title: l10n.privacyPolicy,
                                  onTap: () {
                                    _launchURL(
                                      'https://docs.google.com/document/d/1u7cY7Y0wYsvNpPTARFiPLIBgnaFtggNLtS4P1zfD544/edit?usp=sharing',
                                    );
                                  },
                                ),
                                _buildMenuItem(
                                  icon: Icons.description_outlined,
                                  title: l10n.termsOfService,
                                  onTap: () {
                                    _launchURL(
                                      'https://docs.google.com/document/d/1ubN7Enoihgx0Q37fmsQ6fg3sT_meMhEUVAHiEeyp540/edit?usp=sharing',
                                    );
                                  },
                                ),
                                _buildMenuItem(
                                  icon: Icons.restore_outlined,
                                  title: l10n.restorePurchases,
                                  trailing: _isRestoringPurchases
                                      ? SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  context.colors.primary,
                                                ),
                                          ),
                                        )
                                      : null,
                                  onTap: _isRestoringPurchases
                                      ? null
                                      : _handleRestorePurchases,
                                ),
                              ]),
                              _buildSection(l10n.dataManagement, [
                                _buildMenuItem(
                                  icon: Icons.delete_forever_outlined,
                                  title: l10n.clearAllData,
                                  onTap: () => _showClearDataDialog(),
                                ),
                              ]),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.space16,
        vertical: AppTheme.space8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTheme.h4.copyWith(color: context.colors.onBackground),
          ),
          const SizedBox(height: AppTheme.space12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return AnimatedCard(
      elevation: 0,
      margin: EdgeInsets.only(bottom: AppTheme.space12),
      backgroundColor: Colors.transparent,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(AppTheme.space16),
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: BorderRadius.circular(AppTheme.radiusStandard),
            border: Border.all(
              color: context.colors.onSecondary.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              Icon(icon, color: context.colors.onBackground, size: 24),
              const SizedBox(width: AppTheme.space16),
              Expanded(
                child: Text(
                  title,
                  style: AppTheme.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.colors.onBackground,
                  ),
                ),
              ),
              trailing ??
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: context.colors.onSecondary,
                  ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
