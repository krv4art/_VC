import 'package:flutter/material.dart';
import 'package:acs/theme/app_theme.dart';
import 'package:acs/theme/theme_extensions_v2.dart';
import 'package:provider/provider.dart';
import '../providers/user_state.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/scaffold_with_drawer.dart';
import '../l10n/app_localizations.dart';
import '../widgets/animated/animated_card.dart';
import '../widgets/animated/animated_button.dart' as btn;
import '../constants/app_dimensions.dart';
import '../widgets/common/app_spacer.dart';

class AllergiesScreen extends StatefulWidget {
  const AllergiesScreen({super.key});

  @override
  State<AllergiesScreen> createState() => _AllergiesScreenState();
}

class _AllergiesScreenState extends State<AllergiesScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  List<String> _selectedAllergies = [];
  late AnimationController _animationController;
  late List<Animation<double>> _animations;
  final ScrollController _scrollController = ScrollController();
  final FocusNode _customAllergyFocusNode = FocusNode();
  final TextEditingController _customAllergyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeAnimations();

    // Load current allergies from state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userState = Provider.of<UserState>(context, listen: false);
      setState(() {
        _selectedAllergies = List.from(userState.allergies);
      });
    });
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    // Scroll down when keyboard appears, if the input field is focused
    if (_customAllergyFocusNode.hasFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Create staggered animations for sections
    _animations = List.generate(5, (index) {
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
    WidgetsBinding.instance.removeObserver(this);
    _animationController.dispose();
    _scrollController.dispose();
    _customAllergyFocusNode.dispose();
    _customAllergyController.dispose();
    super.dispose();
  }

  final List<Map<String, dynamic>> _commonAllergies = [
    {
      'name': 'Fragrance',
      'icon': Icons.local_florist,
      'description': 'Fragrances & perfumes',
    },
    {
      'name': 'Parabens',
      'icon': Icons.science,
      'description': 'Paraben preservatives',
    },
    {
      'name': 'Sulfates',
      'icon': Icons.bubble_chart,
      'description': 'Sulfate cleansers',
    },
    {
      'name': 'Alcohol',
      'icon': Icons.liquor,
      'description': 'Alcoholic ingredients',
    },
    {
      'name': 'Essential Oils',
      'icon': Icons.eco,
      'description': 'Essential oils',
    },
    {
      'name': 'Silicones',
      'icon': Icons.water_drop,
      'description': 'Silicone compounds',
    },
    {
      'name': 'Mineral Oil',
      'icon': Icons.oil_barrel,
      'description': 'Mineral oil',
    },
    {
      'name': 'Formaldehyde',
      'icon': Icons.warning,
      'description': 'Formaldehyde',
    },
  ];

  String _getLocalizedAllergyName(String allergyName, AppLocalizations l10n) {
    switch (allergyName) {
      case 'Fragrance':
        return l10n.fragrance;
      case 'Parabens':
        return l10n.parabens;
      case 'Sulfates':
        return l10n.sulfates;
      case 'Alcohol':
        return l10n.alcohol;
      case 'Essential Oils':
        return l10n.essentialOils;
      case 'Silicones':
        return l10n.silicones;
      case 'Mineral Oil':
        return l10n.mineralOil;
      case 'Formaldehyde':
        return l10n.formaldehyde;
      default:
        return allergyName; // For custom allergies that don't have localization
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ScaffoldWithDrawer(
      backgroundColor: context.colors.background,
      appBar: CustomAppBar(
        title: l10n.allergiesSensitivities,
        showBackButton: true,
      ),
      body: Stack(
        children: [
          // Весь скроллируемый контент с анимациями
          SafeArea(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return SingleChildScrollView(
                  controller: _scrollController,
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
                            l10n.selectIngredientsAllergicSensitive,
                            style: AppTheme.body.copyWith(
                              color: context.colors.onBackground,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppTheme.space12),

                      // Анимация 1: Общие аллергены
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
                                    0.1,
                                    0.5,
                                    curve: Curves.easeOutCubic,
                                  ),
                                ),
                              ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.commonAllergens,
                                style: AppTheme.h4.copyWith(
                                  color: context.colors.onBackground,
                                ),
                              ),
                              AppSpacer.v16(),
                              // Разбиваем аллергены по парам для отображения в 2 колонках
                              ...List.generate(
                                (_commonAllergies.length / 2).ceil(),
                                (rowIndex) {
                                  final startIndex = rowIndex * 2;
                                  final endIndex = (startIndex + 2).clamp(
                                    0,
                                    _commonAllergies.length,
                                  );
                                  final rowAllergies = _commonAllergies.sublist(
                                    startIndex,
                                    endIndex,
                                  );

                                  return Padding(
                                    padding: EdgeInsets.only(
                                      //  bottom: AppDimensions.space4,
                                    ),
                                    child: Row(
                                      children: [
                                        ...rowAllergies.asMap().entries.map((
                                          entry,
                                        ) {
                                          final allergy = entry.value;
                                          final isLast =
                                              entry.key ==
                                              rowAllergies.length - 1;
                                          final isSelected = _selectedAllergies
                                              .contains(allergy['name']);

                                          String allergyName = '';
                                          switch (allergy['name']) {
                                            case 'Fragrance':
                                              allergyName = l10n.fragrance;
                                              break;
                                            case 'Parabens':
                                              allergyName = l10n.parabens;
                                              break;
                                            case 'Sulfates':
                                              allergyName = l10n.sulfates;
                                              break;
                                            case 'Alcohol':
                                              allergyName = l10n.alcohol;
                                              break;
                                            case 'Essential Oils':
                                              allergyName = l10n.essentialOils;
                                              break;
                                            case 'Silicones':
                                              allergyName = l10n.silicones;
                                              break;
                                            case 'Mineral Oil':
                                              allergyName = l10n.mineralOil;
                                              break;
                                            case 'Formaldehyde':
                                              allergyName = l10n.formaldehyde;
                                              break;
                                            default:
                                              allergyName = allergy['name'];
                                          }

                                          return Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                right: isLast
                                                    ? 0
                                                    : AppDimensions.space4,
                                              ),
                                              child: _buildCompactAllergyCard(
                                                context,
                                                allergy['icon'],
                                                isSelected,
                                                () {
                                                  setState(() {
                                                    if (isSelected) {
                                                      _selectedAllergies.remove(
                                                        allergy['name'],
                                                      );
                                                    } else {
                                                      _selectedAllergies.add(
                                                        allergy['name'],
                                                      );
                                                    }
                                                  });
                                                },
                                                allergyName,
                                              ),
                                            ),
                                          );
                                        }),
                                        // Если в ряду нечетное количество, добавляем пустой Expanded
                                        if (rowAllergies.length == 1)
                                          Expanded(child: SizedBox.shrink()),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),

                      AppSpacer.v24(),

                      // Анимация 2: Добавление кастомной аллергии
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
                                    0.2,
                                    0.6,
                                    curve: Curves.easeOutCubic,
                                  ),
                                ),
                              ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.addCustomAllergen,
                                style: AppTheme.h4.copyWith(
                                  color: context.colors.onBackground,
                                ),
                              ),
                              AppSpacer.v8(),
                              AnimatedCard(
                                elevation: 0,
                                child: TextField(
                                  controller: _customAllergyController,
                                  focusNode: _customAllergyFocusNode,
                                  style: TextStyle(
                                    color: context.colors.onBackground,
                                    fontSize: 14,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: l10n.typeIngredientName,
                                    hintStyle: TextStyle(
                                      color: context.colors.onSecondary,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.add_circle_outline,
                                      color: context.colors.onBackground,
                                      size: 20,
                                    ),
                                    // Cancel button (suffix icon left)
                                    suffixIcon: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _customAllergyController.clear();
                                              _customAllergyFocusNode.unfocus();
                                            });
                                          },
                                          icon: Icon(
                                            Icons.close,
                                            size: 20,
                                            color: context.colors.onSecondary,
                                          ),
                                        ),
                                        // Accept button (suffix icon right)
                                        IconButton(
                                          onPressed: () {
                                            final value = _customAllergyController.text.trim();
                                            if (value.isNotEmpty &&
                                                !_selectedAllergies.contains(value)) {
                                              setState(() {
                                                _selectedAllergies.add(value);
                                                _customAllergyController.clear();
                                                _customAllergyFocusNode.unfocus();
                                              });
                                            }
                                          },
                                          icon: Icon(
                                            Icons.check,
                                            size: 20,
                                            color: context.colors.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                        AppDimensions.radius12,
                                      ),
                                    ),
                                    filled: true,
                                    fillColor: context.colors.surface,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: AppDimensions.space12,
                                      vertical: AppDimensions.space12,
                                    ),
                                  ),
                                  onSubmitted: (value) {
                                    if (value.isNotEmpty &&
                                        !_selectedAllergies.contains(value)) {
                                      setState(() {
                                        _selectedAllergies.add(value);
                                        _customAllergyController.clear();
                                      });
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      AppSpacer.v24(),

                      // Анимация 3: Выбранные аллергены
                      if (_selectedAllergies.isNotEmpty)
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
                                      0.3,
                                      0.7,
                                      curve: Curves.easeOutCubic,
                                    ),
                                  ),
                                ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.selectedAllergens,
                                  style: AppTheme.h4.copyWith(
                                    color: context.colors.onBackground,
                                  ),
                                ),
                                AppSpacer.v12(),
                                Wrap(
                                  spacing: AppDimensions.space4,
                                  runSpacing: AppDimensions.space4,
                                  children: _selectedAllergies.map((allergy) {
                                    return Container(
                                      margin: EdgeInsets.only(
                                        right: AppDimensions.space8,
                                        bottom: AppDimensions.space8,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient:
                                            context.colors.primaryGradient,
                                        borderRadius: BorderRadius.circular(
                                          AppDimensions.radius16,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: context.colors.shadowColor
                                                .withValues(alpha: 0.4),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                        border: Border.all(
                                          color: context.colors.primary,
                                          width: 2,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: AppDimensions.space8,
                                          vertical: AppDimensions.space4,
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                _getLocalizedAllergyName(
                                                  allergy,
                                                  l10n,
                                                ),
                                                style: AppTheme.bodySmall.copyWith(
                                                  color: context.colors.isDark
                                                      ? const Color(
                                                          0xFF1A1A1A,
                                                        ) // Very dark gray for dark theme
                                                      : Colors
                                                            .white, // White for light theme
                                                  fontSize: 11,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            AppSpacer.h4(),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _selectedAllergies.remove(
                                                    allergy,
                                                  );
                                                });
                                              },
                                              child: Icon(
                                                Icons.close,
                                                size:
                                                    AppDimensions.iconSmall +
                                                    2.0,
                                                color: context.colors.isDark
                                                    ? const Color(
                                                        0xFF1A1A1A,
                                                      ) // Very dark gray for dark theme
                                                    : Colors
                                                          .white, // White for light theme
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                        ),
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
                              // Save allergies to state
                              final userState = Provider.of<UserState>(
                                context,
                                listen: false,
                              );
                              await userState.setAllergies(_selectedAllergies);

                              if (!mounted) return;

                              // Сохраняем контекст перед асинхронной операцией
                              final navigator = Navigator.of(super.context);
                              navigator.pop();
                            },
                            child: Text(
                              l10n.saveSelected(_selectedAllergies.length),
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

  Widget _buildCompactAllergyCard(
    BuildContext context,
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
    String title,
  ) {
    return AnimatedCard(
      elevation: 0,
      borderRadius: BorderRadius.circular(AppDimensions.radius16),
      backgroundColor: Colors.transparent,
      margin: EdgeInsets.only(bottom: AppDimensions.space12),
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          height: 62,
          child: Container(
            decoration: BoxDecoration(
              gradient: isSelected ? context.colors.primaryGradient : null,
              color: isSelected ? null : context.colors.surface,
              borderRadius: BorderRadius.circular(AppDimensions.radius16),
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
            padding: EdgeInsets.all(AppDimensions.space12),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isSelected
                      ? Colors.white
                      : context.colors.onBackground,
                  size: AppDimensions.iconMedium,
                ),
                AppSpacer.h8(),
                Expanded(
                  child: Text(
                    title,
                    style: AppTheme.bodySmall.copyWith(
                      color: isSelected
                          ? Colors.white
                          : context.colors.onBackground,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
