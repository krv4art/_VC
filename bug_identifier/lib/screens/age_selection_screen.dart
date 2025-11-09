import 'package:flutter/material.dart';
import 'package:bug_identifier/theme/app_theme.dart';
import 'package:bug_identifier/theme/theme_extensions_v2.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/user_state.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/scaffold_with_drawer.dart';
import '../l10n/app_localizations.dart';
import '../widgets/animated/animated_button.dart' as btn;
import '../widgets/selection_card.dart';
import '../constants/app_dimensions.dart';
import '../widgets/common/app_spacer.dart';

class AgeSelectionScreen extends StatefulWidget {
  const AgeSelectionScreen({super.key});

  @override
  State<AgeSelectionScreen> createState() => _AgeSelectionScreenState();
}

class _AgeSelectionScreenState extends State<AgeSelectionScreen>
    with TickerProviderStateMixin {
  String? _selectedAgeRange;
  late AnimationController _animationController;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();

    // Load current age range from state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userState = Provider.of<UserState>(context, listen: false);
      setState(() {
        _selectedAgeRange = userState.ageRange;
      });
    });
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Create staggered animations for age range cards
    _animations = List.generate(_ageRanges.length + 1, (index) {
      final startTime = index * 0.1; // 100ms delay between elements
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

  final List<Map<String, dynamic>> _ageRanges = [
    {'range': '18-25', 'icon': Icons.face},
    {'range': '26-35', 'icon': Icons.face_retouching_natural},
    {'range': '36-45', 'icon': Icons.self_improvement},
    {'range': '46-55', 'icon': Icons.spa},
    {'range': '56+', 'icon': Icons.favorite},
  ];

  String _getLocalizedAgeRangeName(String range, AppLocalizations l10n) {
    switch (range) {
      case '18-25':
        return l10n.ageRange18_25;
      case '26-35':
        return l10n.ageRange26_35;
      case '36-45':
        return l10n.ageRange36_45;
      case '46-55':
        return l10n.ageRange46_55;
      case '56+':
        return l10n.ageRange56Plus;
      default:
        return range;
    }
  }

  String _getLocalizedAgeRangeDescription(String range, AppLocalizations l10n) {
    switch (range) {
      case '18-25':
        return l10n.ageRange18_25Description;
      case '26-35':
        return l10n.ageRange26_35Description;
      case '36-45':
        return l10n.ageRange36_45Description;
      case '46-55':
        return l10n.ageRange46_55Description;
      case '56+':
        return l10n.ageRange56PlusDescription;
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ScaffoldWithDrawer(
      appBar: CustomAppBar(title: l10n.age, showBackButton: true),
      body: Stack(
        children: [
          // Весь скроллируемый контент с анимациями
          SafeArea(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.only(
                    bottom: 100, // Место для плавающей кнопки
                    left: AppDimensions.space16,
                    right: AppDimensions.space16,
                    top: AppDimensions.space16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Анимация 0: Текст описания
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
                          child: Text(
                            l10n.selectYourAgeDescription,
                            style: AppTheme.body.copyWith(
                              color: context.colors.onBackground,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppTheme.space12),

                      // Анимации 1-5: Карточки возрастных диапазонов
                      ...List.generate(_ageRanges.length, (index) {
                        final ageRange = _ageRanges[index];
                        final isSelected =
                            _selectedAgeRange == ageRange['range'];

                        String ageRangeName = _getLocalizedAgeRangeName(
                          ageRange['range'],
                          l10n,
                        );
                        String ageRangeDescription =
                            _getLocalizedAgeRangeDescription(
                              ageRange['range'],
                              l10n,
                            );

                        return FadeTransition(
                          opacity: _animations[index + 1],
                          child: SlideTransition(
                            position:
                                Tween<Offset>(
                                  begin: const Offset(0, 0.3),
                                  end: Offset.zero,
                                ).animate(
                                  CurvedAnimation(
                                    parent: _animationController,
                                    curve: Interval(
                                      (index + 1) * 0.1,
                                      (index + 1) * 0.1 + 0.4,
                                      curve: Curves.easeOutCubic,
                                    ),
                                  ),
                                ),
                            child: SelectionCard(
                              icon: ageRange['icon'],
                              isSelected: isSelected,
                              onTap: () {
                                setState(() {
                                  _selectedAgeRange = ageRange['range'];
                                });
                              },
                              title: ageRangeName,
                              subtitle: ageRangeDescription,
                            ),
                          ),
                        );
                      }),
                      AppSpacer.v16(), // Отступ снизу для визуального комфорта
                    ],
                  ),
                );
              },
            ),
          ),

          // Плавающая кнопка
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimensions.space16),
                    child: FadeTransition(
                      opacity: _animations[_animations.length - 1],
                      child: SlideTransition(
                        position:
                            Tween<Offset>(
                              begin: const Offset(0, 0.3),
                              end: Offset.zero,
                            ).animate(
                              CurvedAnimation(
                                parent: _animationController,
                                curve: Interval(
                                  (_animations.length - 1) * 0.1,
                                  (_animations.length - 1) * 0.1 + 0.4,
                                  curve: Curves.easeOutCubic,
                                ),
                              ),
                            ),
                        child: SizedBox(
                          height: AppDimensions.buttonLarge + 2.0,
                          width: double.infinity,
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
                            onPressed: () async {
                              // Save age range to state
                              final userState = Provider.of<UserState>(
                                context,
                                listen: false,
                              );
                              await userState.setAgeRange(_selectedAgeRange);

                              if (!mounted) return;

                              // Сохраняем контекст перед асинхронной операцией
                              final navigator = Navigator.of(super.context);
                              final router = GoRouter.of(super.context);

                              if (super.context.mounted &&
                                  super.context.canPop()) {
                                navigator.pop();
                              } else {
                                router.go('/home');
                              }
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
