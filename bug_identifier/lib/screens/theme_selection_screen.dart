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

import '../constants/app_dimensions.dart';
import '../widgets/common/app_spacer.dart';

class ThemeSelectionScreen extends StatefulWidget {
  const ThemeSelectionScreen({super.key});

  @override
  State<ThemeSelectionScreen> createState() => _ThemeSelectionScreenState();
}

class _ThemeSelectionScreenState extends State<ThemeSelectionScreen>
    with TickerProviderStateMixin {
  AppThemeType? _selectedTheme;
  AppThemeType? _originalTheme;
  bool _isSaved = false;
  AppThemeType? _initialActiveTheme;
  late AnimationController _animationController;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final themeProvider = Provider.of<ThemeProviderV2>(
        context,
        listen: false,
      );
      setState(() {
        _originalTheme = themeProvider.currentTheme;
        _selectedTheme = themeProvider.currentTheme;
        _initialActiveTheme = themeProvider.currentTheme;
      });
    });
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    final lightThemesCount = AppThemeType.values
        .where((theme) => !theme.name.startsWith('dark'))
        .length;

    final totalAnimations = 1 + lightThemesCount + 1;

    _animations = List.generate(totalAnimations, (index) {
      final startTime = index * 0.08;
      final endTime = (startTime + 0.35).clamp(0.0, 1.0);

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
          final provider = Provider.of<ThemeProviderV2>(context, listen: false);
          final shouldRestore = !_isSaved;
          final presetTheme = _originalTheme;

          context.pop();

          if (shouldRestore) {
            Future.delayed(const Duration(milliseconds: 350), () {
              if (presetTheme != null) {
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
                              IconButton(
                                onPressed: () {
                                  if (_selectedTheme != null) {
                                    setState(() {
                                      _selectedTheme = _getLightVariant(
                                        _selectedTheme!,
                                      );
                                    });

                                    if (themeProvider.isDarkTheme) {
                                      themeProvider.setTheme(_selectedTheme!);
                                    } else {
                                      themeProvider.setTheme(
                                        _getDarkVariant(_selectedTheme!),
                                      );
                                    }
                                  } else {
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

                      ...() {
                        int animationIndex = 0;

                        final lightThemes = AppThemeType.values
                            .where(
                              (theme) =>
                                  !theme.name.startsWith('dark') &&
                                  theme != AppThemeType.dark,
                            )
                            .toList();

                        AppThemeType? initialLightTheme;
                        if (_initialActiveTheme != null) {
                          if (_initialActiveTheme!.name.startsWith('dark')) {
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

                        if (initialLightTheme != null) {
                          lightThemes.sort((a, b) {
                            if (a == initialLightTheme) return -1;
                            if (b == initialLightTheme) return 1;
                            return 0;
                          });
                        }

                        return List.generate(lightThemes.length, (index) {
                          final theme = lightThemes[index];

                          final currentAnimationIndex = animationIndex + 1;
                          animationIndex++;

                          bool isSelected = false;
                          if (_selectedTheme != null) {
                            isSelected =
                                _selectedTheme == theme ||
                                _selectedTheme == _getDarkVariant(theme);
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
                                    });
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
                                                        )
                                                      : Colors.white)
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
                                                              )
                                                            : Colors.white)
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
                                                                  )
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
                    ],
                  ),
                ),

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
                              ? const Color(0xFF1A1A1A)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radius16,
                          ),
                          onPressed: () {
                            _isSaved = true;
                            final themeProvider = Provider.of<ThemeProviderV2>(
                              context,
                              listen: false,
                            );

                            if (_selectedTheme != null) {
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
                                  ? const Color(0xFF1A1A1A)
                                  : Colors.white,
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
        return AppThemeType.dark;
    }
  }

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
}
