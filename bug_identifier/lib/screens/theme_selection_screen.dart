import 'package:flutter/material.dart';
import 'package:bug_identifier/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/theme_provider_v2.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/scaffold_with_drawer.dart';
import '../theme/theme_extensions_v2.dart';
import '../l10n/app_localizations.dart';
import '../widgets/animated/animated_card.dart';
import '../widgets/animated/animated_button.dart' as btn;
import '../models/custom_theme_data.dart';
import '../constants/app_dimensions.dart';
import '../widgets/common/app_spacer.dart';
import '../services/telegram_service.dart';

class ThemeSelectionScreen extends StatefulWidget {
  const ThemeSelectionScreen({super.key});

  @override
  State<ThemeSelectionScreen> createState() => _ThemeSelectionScreenState();
}

class _ThemeSelectionScreenState extends State<ThemeSelectionScreen>
    with TickerProviderStateMixin {
  AppThemeType? _selectedTheme;
  String? _selectedCustomThemeId;
  AppThemeType? _originalTheme;
  CustomThemeData? _originalCustomTheme;
  bool _isSaved = false;
  // Активная тема на момент входа на экран (не меняется при выборе)
  AppThemeType? _initialActiveTheme;
  String? _initialActiveCustomThemeId;
  late AnimationController _animationController;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();

    // Save the original theme when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final themeProvider = Provider.of<ThemeProviderV2>(
        context,
        listen: false,
      );
      setState(() {
        _originalTheme = themeProvider.currentTheme;
        _originalCustomTheme = themeProvider.currentCustomTheme;

        if (themeProvider.isCustomThemeActive) {
          _selectedCustomThemeId = themeProvider.currentCustomTheme?.id;
          _selectedTheme = null;
          // Сохраняем активную кастомную тему при входе
          _initialActiveCustomThemeId = themeProvider.currentCustomTheme?.id;
          _initialActiveTheme = null;
        } else {
          _selectedTheme = themeProvider.currentTheme;
          _selectedCustomThemeId = null;
          // Сохраняем активную пресетную тему при входе
          _initialActiveTheme = themeProvider.currentTheme;
          _initialActiveCustomThemeId = null;
        }
      });
    });
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500), // Увеличили длительность
    );

    // Подсчитываем количество светлых тем (без темных вариантов)
    final lightThemesCount = AppThemeType.values
        .where((theme) => !theme.name.startsWith('dark'))
        .length;

    // Create staggered animations for theme cards
    // 1 для заголовка + lightThemesCount для карточек тем +
    // 1 для заголовка кастомных тем + 10 (максимум кастомных тем) +
    // 1 для кнопки создания + 1 для кнопки сохранения
    // Создаем с запасом, чтобы при добавлении новых тем не было ошибки
    final totalAnimations =
        1 +
        lightThemesCount +
        1 + // заголовок кастомных тем
        10 + // максимальное количество кастомных тем
        1 + // кнопка создания
        1; // кнопка сохранения

    _animations = List.generate(totalAnimations, (index) {
      final startTime = index * 0.08; // 80ms delay between elements
      final endTime = (startTime + 0.35).clamp(
        0.0,
        1.0,
      ); // 420ms duration for each animation

      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            startTime.clamp(0.0, 1.0),
            endTime,
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

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProviderV2>();
    final l10n = AppLocalizations.of(context)!;

    return ScaffoldWithDrawer(
      backgroundColor: context.colors.background,
      appBar: CustomAppBar(
        title: l10n.themes,
        showBackButton: true,
        onBackPressed: () {
          // Сохраняем ссылку на провайдер ДО навигации
          final provider = Provider.of<ThemeProviderV2>(context, listen: false);
          final shouldRestore = !_isSaved;
          final customTheme = _originalCustomTheme;
          final presetTheme = _originalTheme;

          // Сначала делаем переход назад
          context.pop();

          // Ждём завершения анимации перехода перед восстановлением темы
          if (shouldRestore) {
            Future.delayed(const Duration(milliseconds: 350), () {
              if (customTheme != null) {
                provider.setCustomTheme(customTheme);
              } else if (presetTheme != null) {
                provider.setTheme(presetTheme);
              }
            });
          }
        },
      ),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Stack(
              children: [
                // Весь скроллируемый контент с анимациями
                SingleChildScrollView(
                  padding: EdgeInsets.only(
                    bottom: AppDimensions.space64 + AppDimensions.space16,
                    left: AppDimensions.space16,
                    right: AppDimensions.space16,
                    top: AppDimensions.space16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Анимация 0: Заголовок с переключателем темного режима
                      FadeTransition(
                        opacity: _animations[0],
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.3),
                            end: Offset.zero,
                          ).animate(_animations[0]),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(
                                  l10n.selectPreferredTheme,
                                  style: AppTheme.body.copyWith(
                                    color: context.colors.onBackground,
                                  ),
                                ),
                              ),
                              // Переключатель темного режима
                              IconButton(
                                onPressed: () {
                                  // Если выбрана пресетная тема (не кастомная)
                                  if (_selectedCustomThemeId == null &&
                                      _selectedTheme != null) {
                                    // Всегда храним светлую версию темы в _selectedTheme
                                    setState(() {
                                      _selectedTheme = _getLightVariant(
                                        _selectedTheme!,
                                      );
                                    });

                                    // Применяем тему с учетом нового режима
                                    if (themeProvider.isDarkTheme) {
                                      // Переключаемся на светлую версию выбранной темы
                                      themeProvider.setTheme(_selectedTheme!);
                                    } else {
                                      // Переключаемся на темную версию выбранной темы
                                      themeProvider.setTheme(
                                        _getDarkVariant(_selectedTheme!),
                                      );
                                    }
                                  } else {
                                    // Если кастомная тема или ничего не выбрано - используем стандартный toggleTheme
                                    themeProvider.toggleTheme();
                                  }
                                },
                                icon: Icon(
                                  themeProvider.isDarkTheme
                                      ? Icons.light_mode
                                      : Icons.dark_mode,
                                  color: context.colors.onBackground,
                                  size: AppDimensions.iconMedium,
                                ),
                                tooltip: themeProvider.isDarkTheme
                                    ? l10n.naturalTheme
                                    : l10n.darkTheme,
                              ),
                            ],
                          ),
                        ),
                      ),
                      AppSpacer.v12(),

                      // Анимации 1-5: Карточки тем
                      // Показываем только светлые темы (без темных вариантов)
                      ...() {
                        int animationIndex = 0;

                        // Получаем список светлых тем
                        final lightThemes = AppThemeType.values
                            .where(
                              (theme) =>
                                  !theme.name.startsWith('dark') &&
                                  theme != AppThemeType.dark,
                            )
                            .toList();

                        // Определяем светлую версию начальной активной темы
                        AppThemeType? initialLightTheme;
                        if (_initialActiveTheme != null &&
                            _initialActiveCustomThemeId == null) {
                          // Если начальная тема была пресетной, находим её светлую версию
                          if (_initialActiveTheme!.name.startsWith('dark')) {
                            // Находим соответствующую светлую тему
                            for (final theme in lightThemes) {
                              if (_getDarkVariant(theme) ==
                                  _initialActiveTheme) {
                                initialLightTheme = theme;
                                break;
                              }
                            }
                          } else {
                            initialLightTheme = _initialActiveTheme;
                          }
                        }

                        // Сортируем темы так, чтобы начальная активная тема была первой
                        if (initialLightTheme != null) {
                          lightThemes.sort((a, b) {
                            if (a == initialLightTheme) return -1;
                            if (b == initialLightTheme) return 1;
                            return 0;
                          });
                        }

                        return List.generate(lightThemes.length, (index) {
                          final theme = lightThemes[index];

                          // Используем отдельный счетчик для анимаций
                          final currentAnimationIndex = animationIndex + 1;
                          animationIndex++;

                          // Правильно определяем, выбрана ли тема с учетом темного режима
                          bool isSelected = false;
                          if (_selectedCustomThemeId == null &&
                              _selectedTheme != null) {
                            // Карточка показывает светлую тему, но _selectedTheme может быть темной
                            // Сравниваем либо напрямую, либо с темной версией карточки
                            isSelected =
                                _selectedTheme == theme ||
                                _selectedTheme == _getDarkVariant(theme);
                          } else if (_selectedCustomThemeId != null) {
                            // Если выбрана кастомная тема, пресетные темы не выделены
                            isSelected = false;
                          }

                          final themeIcon = themeProvider.getThemeIcon(theme);

                          return FadeTransition(
                            opacity: _animations[currentAnimationIndex],
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0, 0.3),
                                end: Offset.zero,
                              ).animate(_animations[currentAnimationIndex]),
                              child: AnimatedCard(
                                elevation: isSelected ? 4 : 2,
                                margin: EdgeInsets.only(
                                  bottom: AppDimensions.space12,
                                ),
                                borderRadius: BorderRadius.circular(
                                  AppTheme.radiusCard,
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedTheme = theme;
                                      _selectedCustomThemeId = null;
                                    });
                                    // Apply theme temporarily for preview
                                    // Если текущая тема темная, применяем темную версию выбранной темы
                                    if (themeProvider.isDarkTheme) {
                                      final darkVariant = _getDarkVariant(
                                        theme,
                                      );
                                      themeProvider.setTheme(darkVariant);
                                    } else {
                                      themeProvider.setTheme(theme);
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(
                                      AppDimensions.space16 +
                                          AppDimensions.space4,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: isSelected
                                          ? context.colors.primaryGradient
                                          : null,
                                      color: isSelected
                                          ? null
                                          : context.colors.surface,
                                      borderRadius: BorderRadius.circular(
                                        AppTheme.radiusCard,
                                      ),
                                      border: Border.all(
                                        color: isSelected
                                            ? context.colors.primary
                                            : context.colors.onBackground
                                                  .withValues(alpha: 0.2),
                                        width: isSelected ? 2 : 1,
                                      ),
                                      boxShadow: isSelected
                                          ? [
                                              AppTheme.getColoredShadow(
                                                context.colors.shadowColor,
                                              ),
                                            ]
                                          : null,
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: AppDimensions.avatarMedium,
                                          height: AppDimensions.avatarMedium,
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? Colors.white.withValues(
                                                    alpha: 0.2,
                                                  )
                                                : context.colors.primary
                                                      .withValues(alpha: 0.15),
                                            borderRadius: BorderRadius.circular(
                                              AppTheme.radiusMedium,
                                            ),
                                          ),
                                          child: Icon(
                                            themeIcon,
                                            color: isSelected
                                                ? (context.colors.isDark
                                                      ? const Color(
                                                          0xFF1A1A1A,
                                                        ) // Very dark gray for dark theme
                                                      : Colors
                                                            .white) // White for light theme
                                                : context.colors.onBackground,
                                            size: AppDimensions.iconLarge,
                                          ),
                                        ),
                                        AppSpacer.h16(),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                _getThemeDisplayName(
                                                  themeProvider.isDarkTheme
                                                      ? _getDarkVariant(theme)
                                                      : theme,
                                                  l10n,
                                                ),
                                                style: AppTheme.h4.copyWith(
                                                  color: isSelected
                                                      ? (context.colors.isDark
                                                            ? const Color(
                                                                0xFF1A1A1A,
                                                              ) // Very dark gray for dark theme
                                                            : Colors
                                                                  .white) // White for light theme
                                                      : context
                                                            .colors
                                                            .onBackground,
                                                ),
                                              ),
                                              AppSpacer.v4(),
                                              Text(
                                                _getThemeDescription(
                                                  themeProvider.isDarkTheme
                                                      ? _getDarkVariant(theme)
                                                      : theme,
                                                  l10n,
                                                ),
                                                style: AppTheme.bodySmall.copyWith(
                                                  color: isSelected
                                                      ? (context.colors.isDark
                                                            ? const Color(
                                                                    0xFF1A1A1A,
                                                                  ) // Very dark gray for dark theme
                                                                  .withValues(
                                                                    alpha: 0.9,
                                                                  )
                                                            : Colors.white
                                                                  .withValues(
                                                                    alpha: 0.9,
                                                                  ))
                                                      : context
                                                            .colors
                                                            .onBackground
                                                            .withValues(
                                                              alpha: 0.8,
                                                            ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        });
                      }(),
                      AppSpacer.v16(),

                      // Custom Themes Section
                      if (themeProvider.customThemes.isNotEmpty) ...[
                        // Заголовок появляется после всех основных карточек
                        // Индекс = 1 (заголовок) + lightThemesCount (основные карточки)
                        () {
                          final lightThemesCount = AppThemeType.values
                              .where((theme) => !theme.name.startsWith('dark'))
                              .length;
                          final customThemesTitleIndex = 1 + lightThemesCount;

                          return FadeTransition(
                            opacity: _animations[customThemesTitleIndex],
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0, 0.3),
                                end: Offset.zero,
                              ).animate(_animations[customThemesTitleIndex]),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppSpacer.v8(),
                                  Text(
                                    l10n.customThemes,
                                    style: AppTheme.h4.copyWith(
                                      color: context.colors.onBackground,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  AppSpacer.v12(),
                                ],
                              ),
                            ),
                          );
                        }(),
                        // Custom theme cards
                        ..._buildCustomThemeCards(themeProvider, l10n),
                        AppSpacer.v8(),
                      ],

                      // Create Custom Theme Button
                      // Появляется после заголовка кастомных тем и всех кастомных карточек
                      () {
                        final lightThemesCount = AppThemeType.values
                            .where((theme) => !theme.name.startsWith('dark'))
                            .length;
                        final customThemesCount =
                            themeProvider.customThemes.length;
                        final createButtonIndex =
                            1 +
                            lightThemesCount +
                            (customThemesCount > 0 ? 1 : 0) +
                            customThemesCount;

                        return FadeTransition(
                          opacity: _animations[createButtonIndex],
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, 0.3),
                              end: Offset.zero,
                            ).animate(_animations[createButtonIndex]),
                            child: AnimatedCard(
                              elevation: 2,
                              margin: EdgeInsets.only(
                                bottom: AppDimensions.space4,
                              ),
                              borderRadius: BorderRadius.circular(
                                AppTheme.radiusCard,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  // Отправляем уведомление в Telegram о нажатии на кнопку (не блокируем UI)
                                  TelegramService().sendCustomThemeRequest();

                                  // Показываем сообщение о том, что функция в разработке
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            l10n.customThemeInDevelopment,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            l10n.customThemeComingSoon,
                                            style: TextStyle(
                                              color: Colors.white.withValues(
                                                alpha: 0.9,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      backgroundColor: context.colors.primary,
                                      duration: Duration(seconds: 3),
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          AppDimensions.radius8,
                                        ),
                                      ),
                                    ),
                                  );
                                  return;

                                  /*
                                  final canAdd = await themeProvider
                                      .canAddMoreThemes();
                                  if (!canAdd) {
                                    if (!context.mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Maximum 10 custom themes allowed',
                                        ),
                                        backgroundColor: context.colors.error,
                                      ),
                                    );
                                    return;
                                  }

                                  if (!context.mounted) return;

                                  // Восстанавливаем оригинальную тему перед переходом к редактору
                                  final provider = Provider.of<ThemeProviderV2>(
                                    context,
                                    listen: false,
                                  );
                                  if (_originalCustomTheme != null) {
                                    await provider.setCustomTheme(
                                      _originalCustomTheme!,
                                    );
                                  } else if (_originalTheme != null) {
                                    await provider.setTheme(_originalTheme!);
                                  }

                                  if (!context.mounted) return;
                                  context.push('/theme-editor/new');
                                  */
                                },
                                child: Container(
                                  padding: EdgeInsets.all(
                                    AppDimensions.space16 +
                                        AppDimensions.space4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: context.colors.surface,
                                    borderRadius: BorderRadius.circular(
                                      AppTheme.radiusCard,
                                    ),
                                    border: Border.all(
                                      color: context.colors.primary.withValues(
                                        alpha: 0.5,
                                      ),
                                      width: 2,
                                      style: BorderStyle.solid,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: AppDimensions.avatarMedium,
                                        height: AppDimensions.avatarMedium,
                                        decoration: BoxDecoration(
                                          color: context.colors.primary
                                              .withValues(alpha: 0.15),
                                          borderRadius: BorderRadius.circular(
                                            AppDimensions.radius12,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.add,
                                          color: context.colors.primary,
                                          size: AppDimensions.iconLarge,
                                        ),
                                      ),
                                      AppSpacer.h16(),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              l10n.createCustomTheme,
                                              style: AppTheme.h4.copyWith(
                                                color:
                                                    context.colors.onBackground,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            AppSpacer.v4(),
                                            Text(
                                              l10n.designYourOwnTheme,
                                              style: AppTheme.bodySmall
                                                  .copyWith(
                                                    color: context
                                                        .colors
                                                        .onSecondary,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }(),
                      AppSpacer.v16(),
                    ],
                  ),
                ),

                // Анимация 5: Плавающая кнопка
                Positioned(
                  bottom: AppDimensions.space16,
                  left: AppDimensions.space16,
                  right: AppDimensions.space16,
                  child: FadeTransition(
                    opacity: _animations[_animations.length - 1],
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.3),
                        end: Offset.zero,
                      ).animate(_animations[_animations.length - 1]),
                      child: SizedBox(
                        height: AppDimensions.avatarMedium,
                        child: btn.AnimatedButton(
                          buttonType: btn.ButtonType.elevated,
                          animationStyle: btn.AnimationStyle.scale,
                          backgroundColor: context.colors.primary,
                          foregroundColor: context.colors.isDark
                              ? const Color(
                                  0xFF1A1A1A,
                                ) // Very dark gray for dark theme
                              : Colors.white, // White for light theme
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radius16,
                          ),
                          onPressed: () {
                            _isSaved = true;
                            final themeProvider = Provider.of<ThemeProviderV2>(
                              context,
                              listen: false,
                            );

                            // Сохраняем выбранную тему
                            if (_selectedCustomThemeId != null) {
                              // Если выбрана кастомная тема - она уже применена через setCustomTheme
                              // Просто отмечаем как сохраненную
                            } else if (_selectedTheme != null) {
                              // Если выбрана пресетная тема - применяем её с учетом темного режима
                              if (themeProvider.isDarkTheme) {
                                final darkVariant = _getDarkVariant(
                                  _selectedTheme!,
                                );
                                themeProvider.setTheme(darkVariant);
                              } else {
                                themeProvider.setTheme(_selectedTheme!);
                              }
                            }

                            if (!context.mounted) return;

                            // Navigate back
                            Future.delayed(
                              const Duration(milliseconds: 150),
                              () {
                                if (context.mounted) {
                                  context.pop();
                                }
                              },
                            );
                          },
                          child: Text(
                            l10n.save,
                            style: AppTheme.buttonText.copyWith(
                              color: context.colors.isDark
                                  ? const Color(
                                      0xFF1A1A1A,
                                    ) // Very dark gray for dark theme
                                  : Colors.white, // White for light theme
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// Получить темную версию светлой темы
  AppThemeType _getDarkVariant(AppThemeType lightTheme) {
    switch (lightTheme) {
      case AppThemeType.natural:
        return AppThemeType.dark;
      case AppThemeType.ocean:
        return AppThemeType.darkOcean;
      case AppThemeType.forest:
        return AppThemeType.darkForest;
      case AppThemeType.sunset:
        return AppThemeType.darkSunset;
      case AppThemeType.vibrant:
        return AppThemeType.darkVibrant;
      default:
        return AppThemeType.dark; // По умолчанию
    }
  }

  /// Получить светлую версию темной темы
  AppThemeType _getLightVariant(AppThemeType theme) {
    switch (theme) {
      case AppThemeType.dark:
        return AppThemeType.natural;
      case AppThemeType.darkOcean:
        return AppThemeType.ocean;
      case AppThemeType.darkForest:
        return AppThemeType.forest;
      case AppThemeType.darkSunset:
        return AppThemeType.sunset;
      case AppThemeType.darkVibrant:
        return AppThemeType.vibrant;
      // Если уже светлая, возвращаем как есть
      default:
        return theme;
    }
  }

  String _getThemeDisplayName(AppThemeType theme, AppLocalizations l10n) {
    switch (theme) {
      case AppThemeType.natural:
        return l10n.naturalTheme;
      case AppThemeType.dark:
        return l10n.darkNatural;
      case AppThemeType.ocean:
        return l10n.oceanTheme;
      case AppThemeType.darkOcean:
        return l10n.darkOcean;
      case AppThemeType.forest:
        return l10n.forestTheme;
      case AppThemeType.darkForest:
        return l10n.darkForest;
      case AppThemeType.sunset:
        return l10n.sunsetTheme;
      case AppThemeType.darkSunset:
        return l10n.darkSunset;
      case AppThemeType.vibrant:
        return l10n.vibrantTheme;
      case AppThemeType.darkVibrant:
        return l10n.darkVibrant;
    }
  }

  String _getThemeDescription(AppThemeType theme, AppLocalizations l10n) {
    switch (theme) {
      case AppThemeType.natural:
        return l10n.naturalThemeDescription;
      case AppThemeType.dark:
        return l10n.darkThemeDescription;
      case AppThemeType.ocean:
        return l10n.oceanThemeDescription;
      case AppThemeType.darkOcean:
        return l10n.darkOceanThemeDescription;
      case AppThemeType.forest:
        return l10n.forestThemeDescription;
      case AppThemeType.darkForest:
        return l10n.darkForestThemeDescription;
      case AppThemeType.sunset:
        return l10n.sunsetThemeDescription;
      case AppThemeType.darkSunset:
        return l10n.darkSunsetThemeDescription;
      case AppThemeType.vibrant:
        return l10n.vibrantThemeDescription;
      case AppThemeType.darkVibrant:
        return l10n.darkVibrantThemeDescription;
    }
  }

  // Метод для построения карточек кастомных тем с сортировкой
  List<Widget> _buildCustomThemeCards(
    ThemeProviderV2 themeProvider,
    AppLocalizations l10n,
  ) {
    // Получаем список кастомных тем и сортируем так, чтобы начальная активная была первой
    final customThemesList = List<CustomThemeData>.from(
      themeProvider.customThemes,
    );

    // Если начальная активная тема была кастомной, перемещаем её в начало списка
    if (_initialActiveCustomThemeId != null) {
      customThemesList.sort((a, b) {
        if (a.id == _initialActiveCustomThemeId) return -1;
        if (b.id == _initialActiveCustomThemeId) return 1;
        return 0;
      });
    }

    // Вычисляем начальный индекс анимации для кастомных карточек
    final lightThemesCount = AppThemeType.values
        .where((theme) => !theme.name.startsWith('dark'))
        .length;
    // Начальный индекс = 1 (заголовок) + lightThemesCount (основные карточки) + 1 (заголовок кастомных тем)
    final startAnimationIndex = 1 + lightThemesCount + 1;

    return customThemesList.asMap().entries.map((entry) {
      final index = entry.key;
      final customTheme = entry.value;
      final isSelected = _selectedCustomThemeId == customTheme.id;
      final animationIndex = startAnimationIndex + index;

      return FadeTransition(
        opacity: _animations[animationIndex],
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.3),
            end: Offset.zero,
          ).animate(_animations[animationIndex]),
          child: AnimatedCard(
            elevation: isSelected ? 4 : 2,
            margin: EdgeInsets.only(bottom: AppDimensions.space12),
            borderRadius: BorderRadius.circular(AppTheme.radiusCard),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTheme = null;
                  _selectedCustomThemeId = customTheme.id;
                });
                // Apply custom theme temporarily for preview
                themeProvider.setCustomTheme(customTheme);
              },
              child: Container(
                padding: EdgeInsets.all(
                  AppDimensions.space16 + AppDimensions.space4,
                ),
                decoration: BoxDecoration(
                  gradient: isSelected ? context.colors.primaryGradient : null,
                  color: isSelected ? null : context.colors.surface,
                  borderRadius: BorderRadius.circular(AppTheme.radiusCard),
                  border: Border.all(
                    color: isSelected
                        ? context.colors.primary
                        : context.colors.onBackground.withValues(alpha: 0.2),
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: isSelected
                      ? [AppTheme.getColoredShadow(context.colors.shadowColor)]
                      : null,
                ),
                child: Row(
                  children: [
                    Container(
                      width: AppDimensions.avatarMedium,
                      height: AppDimensions.avatarMedium,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            customTheme.colors.primary,
                            customTheme.colors.secondary,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(
                          AppTheme.radiusMedium,
                        ),
                      ),
                      child: Icon(
                        Icons.palette,
                        color: Colors.white,
                        size: AppDimensions.iconLarge,
                      ),
                    ),
                    AppSpacer.h16(),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            customTheme.name,
                            style: AppTheme.h4.copyWith(
                              color: isSelected
                                  ? (context.colors.isDark
                                        ? const Color(
                                            0xFF1A1A1A,
                                          ) // Very dark gray for dark theme
                                        : Colors.white) // White for light theme
                                  : context.colors.onBackground,
                            ),
                          ),
                          AppSpacer.v4(),
                          Text(
                            l10n.customTheme,
                            style: AppTheme.bodySmall.copyWith(
                              color: isSelected
                                  ? (context.colors.isDark
                                        ? const Color(
                                                0xFF1A1A1A,
                                              ) // Very dark gray for dark theme
                                              .withValues(alpha: 0.9)
                                        : Colors.white.withValues(alpha: 0.9))
                                  : context.colors.onSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Edit button
                    IconButton(
                      onPressed: () {
                        context.push('/theme-editor/${customTheme.id}');
                      },
                      icon: Icon(
                        Icons.edit,
                        color: isSelected
                            ? (context.colors.isDark
                                  ? const Color(
                                      0xFF1A1A1A,
                                    ) // Very dark gray for dark theme
                                  : Colors.white) // White for light theme
                            : context.colors.onBackground,
                        size: AppDimensions.iconSmall + 4.0,
                      ),
                      tooltip: l10n.edit,
                    ),
                    // Delete button
                    IconButton(
                      onPressed: () async {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(l10n.deleteTheme),
                            content: Text(
                              l10n.deleteThemeConfirmation(customTheme.name),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: Text(l10n.cancel),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: Text(l10n.delete),
                              ),
                            ],
                          ),
                        );

                        if (confirmed == true) {
                          await themeProvider.deleteCustomTheme(customTheme.id);
                        }
                      },
                      icon: Icon(
                        Icons.delete,
                        color: isSelected
                            ? (context.colors.isDark
                                  ? const Color(
                                      0xFF1A1A1A,
                                    ) // Very dark gray for dark theme
                                  : Colors.white) // White for light theme
                            : context.colors.error,
                        size: AppDimensions.iconSmall + 4.0,
                      ),
                      tooltip: 'Delete',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }).toList();
  }
}
