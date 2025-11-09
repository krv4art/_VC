import 'package:flutter/material.dart';
import 'package:acs/theme/app_theme.dart';
import 'package:provider/provider.dart';
import '../providers/user_state.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/scaffold_with_drawer.dart';
import '../l10n/app_localizations.dart';
import '../theme/theme_extensions_v2.dart';
import '../widgets/animated/animated_button.dart' as btn;
import '../widgets/selection_card.dart';
import '../constants/app_dimensions.dart';
import '../widgets/common/app_spacer.dart';

class SkinTypeScreen extends StatefulWidget {
  const SkinTypeScreen({super.key});

  @override
  State<SkinTypeScreen> createState() => _SkinTypeScreenState();
}

class _SkinTypeScreenState extends State<SkinTypeScreen>
    with TickerProviderStateMixin {
  String? _selectedSkinType;
  late AnimationController _animationController;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();

    // Load current skin type from state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userState = Provider.of<UserState>(context, listen: false);
      setState(() {
        _selectedSkinType = userState.skinType;
      });
    });
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Create staggered animations for skin type cards
    _animations = List.generate(_skinTypes.length + 1, (index) {
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

  final List<Map<String, dynamic>> _skinTypes = [
    {
      'type': 'Normal',
      'icon': Icons.face,
      'description': 'Balanced, not too oily or dry',
    },
    {
      'type': 'Dry',
      'icon': Icons.water_drop_outlined,
      'description': 'Tight, flaky, rough texture',
    },
    {
      'type': 'Oily',
      'icon': Icons.water_drop,
      'description': 'Shiny, large pores, prone to acne',
    },
    {
      'type': 'Combination',
      'icon': Icons.gradient,
      'description': 'Oily T-zone, dry cheeks',
    },
    {
      'type': 'Sensitive',
      'icon': Icons.warning_amber,
      'description': 'Easily irritated, prone to redness',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ScaffoldWithDrawer(
      backgroundColor: context.colors.background,
      appBar: CustomAppBar(title: l10n.skinType, showBackButton: true),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
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
                                l10n.selectYourSkinTypeDescription,
                                style: AppTheme.body.copyWith(
                                  color: context.colors.onBackground,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: AppTheme.space12),

                          // Анимации 1-5: Карточки типов кожи
                          ...List.generate(_skinTypes.length, (index) {
                            final skinType = _skinTypes[index];
                            final isSelected =
                                _selectedSkinType == skinType['type'];

                            String skinTypeName = '';
                            String skinTypeDescription = '';
                            switch (skinType['type']) {
                              case 'Normal':
                                skinTypeName = l10n.normal;
                                skinTypeDescription =
                                    l10n.normalSkinDescription;
                                break;
                              case 'Dry':
                                skinTypeName = l10n.dry;
                                skinTypeDescription = l10n.drySkinDescription;
                                break;
                              case 'Oily':
                                skinTypeName = l10n.oily;
                                skinTypeDescription = l10n.oilySkinDescription;
                                break;
                              case 'Combination':
                                skinTypeName = l10n.combination;
                                skinTypeDescription =
                                    l10n.combinationSkinDescription;
                                break;
                              case 'Sensitive':
                                skinTypeName = l10n.sensitive;
                                skinTypeDescription =
                                    l10n.sensitiveSkinDescription;
                                break;
                              default:
                                skinTypeName = skinType['type'];
                                skinTypeDescription = skinType['description'];
                            }

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
                                  icon: skinType['icon'],
                                  isSelected: isSelected,
                                  onTap: () {
                                    setState(() {
                                      _selectedSkinType = skinType['type'];
                                    });
                                  },
                                  title: skinTypeName,
                                  subtitle: skinTypeDescription,
                                ),
                              ),
                            );
                          }),
                          AppSpacer.v16(),
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
                              height: AppDimensions.buttonLarge + 2,
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
                                  // Save skin type to state
                                  final userState = Provider.of<UserState>(
                                    context,
                                    listen: false,
                                  );
                                  await userState.updateSkinType(
                                    _selectedSkinType,
                                  );

                                  if (!mounted) return;

                                  // Сохраняем контекст перед асинхронной операцией
                                  final navigator = Navigator.of(super.context);
                                  navigator.pop();
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
          );
        },
      ),
    );
  }
}
