import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';
import '../theme/theme_extensions_v2.dart';
import '../providers/user_state.dart';
import '../providers/ai_bot_provider.dart';
import '../l10n/app_localizations.dart';
import '../widgets/onboarding/chat_option_button.dart';
import '../widgets/animated/animated_ai_avatar.dart';
import '../constants/app_dimensions.dart';
import '../widgets/common/app_spacer.dart';

class ChatOnboardingScreen extends StatefulWidget {
  const ChatOnboardingScreen({super.key});

  @override
  State<ChatOnboardingScreen> createState() => _ChatOnboardingScreenState();
}

class _ChatOnboardingScreenState extends State<ChatOnboardingScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  int _currentStep = 0;
  String? _selectedSkinType;
  String? _selectedAgeRange;
  final List<String> _selectedAllergies = [];

  // For custom allergies input
  final TextEditingController _customAllergyController = TextEditingController();
  final FocusNode _customAllergyFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  // For name input
  final TextEditingController _nameController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();

  // Для анимации печатания текста
  late AnimationController _typingAnimationController;
  int _displayedCharCount = 0;

  // Для PageView свайп-навигации
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _typingAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 30),
    );

    _pageController = PageController();

    // Load bot settings and start animation after frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<AiBotProvider>().loadSettings();
        _startTypingAnimation();
      }
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

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _typingAnimationController.dispose();
    _pageController.dispose();
    _customAllergyController.dispose();
    _customAllergyFocusNode.dispose();
    _scrollController.dispose();
    _nameController.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  void _startTypingAnimation() {
    final l10n = AppLocalizations.of(context)!;
    final message = _getBotMessage(l10n);
    if (_displayedCharCount < message.length) {
      if (!_typingAnimationController.isAnimating) {
        _typingAnimationController.forward(from: 0).then((_) {
          if (mounted) {
            setState(() {
              _displayedCharCount++;
            });
            _startTypingAnimation();
          }
        });
      }
    }
  }

  final List<Map<String, dynamic>> _skinTypes = [
    {'type': 'Normal', 'icon': Icons.face, 'description': 'Balanced'},
    {'type': 'Dry', 'icon': Icons.water_drop_outlined, 'description': 'Dry'},
    {'type': 'Oily', 'icon': Icons.water_drop, 'description': 'Oily'},
    {'type': 'Combination', 'icon': Icons.gradient, 'description': 'Combo'},
    {
      'type': 'Sensitive',
      'icon': Icons.warning_amber,
      'description': 'Sensitive',
    },
  ];

  final List<Map<String, dynamic>> _ageRanges = [
    {'range': '18-25', 'icon': Icons.face},
    {'range': '26-35', 'icon': Icons.face_retouching_natural},
    {'range': '36-45', 'icon': Icons.self_improvement},
    {'range': '46-55', 'icon': Icons.spa},
    {'range': '56+', 'icon': Icons.favorite},
  ];

  final List<Map<String, dynamic>> _commonAllergies = [
    {'name': 'Fragrance', 'icon': Icons.local_florist},
    {'name': 'Parabens', 'icon': Icons.science},
    {'name': 'Sulfates', 'icon': Icons.bubble_chart},
    {'name': 'Alcohol', 'icon': Icons.liquor},
    {'name': 'Essential Oils', 'icon': Icons.eco},
    {'name': 'Silicones', 'icon': Icons.water_drop},
    {'name': 'Mineral Oil', 'icon': Icons.oil_barrel},
    {'name': 'Formaldehyde', 'icon': Icons.warning},
  ];

  String _getBotMessage(AppLocalizations l10n) {
    switch (_currentStep) {
      case 0:
        return l10n.onboardingGreeting;
      case 1:
        return l10n.selectYourSkinTypeDescription;
      case 2:
        return l10n.selectYourAgeDescription;
      case 3:
        return l10n.selectIngredientsAllergicSensitive;
      case 4:
        return l10n.enterYourName;
      default:
        return '';
    }
  }

  bool _isNextButtonEnabled() {
    switch (_currentStep) {
      case 0:
        return true; // Шаг приветствия - кнопка всегда активна
      case 1:
        return true; // Шаг типа кожи - кнопка всегда активна, можно пропустить
      case 2:
        return true; // Шаг возраста - кнопка всегда активна, можно пропустить
      case 3:
        return true; // Шаг аллергенов - кнопка всегда активна, можно пропустить
      case 4:
        return true; // Шаг имени - кнопка всегда активна, можно пропустить
      default:
        return false;
    }
  }

  Future<void> _handleNextStep() async {
    if (_currentStep < 4) {
      await _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Save all data and navigate to paywall
      final userState = Provider.of<UserState>(context, listen: false);

      if (_selectedSkinType != null) {
        await userState.setSkinType(_selectedSkinType);
      }
      if (_selectedAgeRange != null) {
        await userState.setAgeRange(_selectedAgeRange);
      }
      // Only set allergies if user selected at least one
      // If skipped, allergies card will remain visible on home screen
      if (_selectedAllergies.isNotEmpty) {
        await userState.setAllergies(_selectedAllergies);
      }
      // Save name if entered
      final name = _nameController.text.trim();
      if (name.isNotEmpty) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('name', name);
      }
      await userState.completeOnboarding();

      if (!mounted) return;
      // Navigate to paywall screen
      context.push('/modern-paywall');
    }
  }

  void _handlePageChanged(int page) {
    setState(() {
      _currentStep = page;
      _displayedCharCount = 0; // Reset typing animation
    });

    // Always restart typing animation for new step
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _startTypingAnimation();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: PageView.builder(
          controller: _pageController,
          onPageChanged: _handlePageChanged,
          physics: const BouncingScrollPhysics(),
          itemCount: 5,
          itemBuilder: (context, index) {
            return Column(
              children: [
                // Bot message area - upper part
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Bot message with avatar - like in chat
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // Bot avatar (animated)
                            SizedBox(
                              width: 56,
                              height: 56,
                              child: AnimatedAiAvatar(
                                size: 56,
                                state:
                                    _displayedCharCount <
                                        _getBotMessage(
                                          AppLocalizations.of(context)!,
                                        ).length
                                    ? AvatarAnimationState.thinking
                                    : AvatarAnimationState.idle,
                                colors: context.colors.currentColors,
                              ),
                            ),
                            AppSpacer.h12(),
                            // Message bubble
                            Flexible(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: context.colors.surface,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(
                                      AppDimensions.radius24,
                                    ),
                                    topRight: Radius.circular(
                                      AppDimensions.radius24,
                                    ),
                                    bottomRight: Radius.circular(
                                      AppDimensions.radius24,
                                    ),
                                    bottomLeft: Radius.circular(
                                      AppDimensions.space4,
                                    ),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: context.colors.shadowColor
                                          .withValues(alpha: 0.1),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppDimensions.space16,
                                  vertical: AppDimensions.space12,
                                ),
                                child: Text(
                                  _getBotMessage(
                                    l10n,
                                  ).substring(0, _displayedCharCount),
                                  textAlign: TextAlign.start,
                                  style: AppTheme.bodyLarge.copyWith(
                                    color: context.colors.onSurface,
                                    height: 1.5,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Options area - middle part
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.space24,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            child: _buildOptionsForStep(l10n),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Next button area - lower part
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.space24,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Step indicator
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          5,
                          (index) => Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: AppDimensions.space4,
                            ),
                            width: AppDimensions.space8,
                            height: AppDimensions.space8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: index <= _currentStep
                                  ? context.colors.primary
                                  : context.colors.onBackground.withValues(
                                      alpha: 0.2,
                                    ),
                            ),
                          ),
                        ),
                      ),
                      AppSpacer.v16(),
                      Container(
                        width: double.infinity,
                        height:
                            AppDimensions.buttonLarge + AppDimensions.space8,
                        decoration: BoxDecoration(
                          color: _isNextButtonEnabled()
                              ? context.colors.primary
                              : context.colors.onBackground.withValues(
                                  alpha: 0.2,
                                ),
                          borderRadius: BorderRadius.circular(
                            AppTheme.radiusLarge,
                          ),
                          boxShadow: _isNextButtonEnabled()
                              ? [
                                  BoxShadow(
                                    color: context.colors.shadowColor
                                        .withValues(alpha: 0.2),
                                    blurRadius: AppDimensions.space8,
                                    offset: Offset(0, AppDimensions.space4),
                                  ),
                                ]
                              : null,
                        ),
                        child: ElevatedButton(
                          onPressed: _isNextButtonEnabled()
                              ? _handleNextStep
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            foregroundColor: context.colors.surface,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppTheme.radiusLarge,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: AppDimensions.space24,
                            ),
                            textStyle: AppTheme.buttonText.copyWith(
                              fontSize: 18,
                            ),
                          ),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              _currentStep == 4 ? l10n.finish : l10n.next,
                              maxLines: 1,
                              overflow: TextOverflow.visible,
                            ),
                          ),
                        ),
                      ),
                      AppSpacer.v24(),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildOptionsForStep(AppLocalizations l10n) {
    switch (_currentStep) {
      case 0:
        return _buildWelcomeStep(context);
      case 1:
        return _buildSkinTypeStep(l10n);
      case 2:
        return _buildAgeStep(l10n);
      case 3:
        return _buildAllergiesStep(l10n);
      case 4:
        return _buildNameStep(l10n);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildWelcomeStep(BuildContext context) {
    return const SizedBox.shrink();
  }

  String _getLocalizedSkinTypeName(String skinType, AppLocalizations l10n) {
    switch (skinType) {
      case 'Normal':
        return l10n.normal;
      case 'Dry':
        return l10n.dry;
      case 'Oily':
        return l10n.oily;
      case 'Combination':
        return l10n.combination;
      case 'Sensitive':
        return l10n.sensitive;
      default:
        return skinType;
    }
  }

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
        return allergyName;
    }
  }

  Widget _buildSkinTypeStep(AppLocalizations l10n) {
    return Column(
      children: _skinTypes.map((skinType) {
        final isSelected = _selectedSkinType == skinType['type'];
        return Padding(
          padding: EdgeInsets.only(bottom: AppDimensions.space12),
          child: SizedBox(
            width: double.infinity,
            child: ChatOptionButton(
              icon: skinType['icon'],
              label: _getLocalizedSkinTypeName(skinType['type'], l10n),
              isSelected: isSelected,
              onTap: () {
                setState(() {
                  _selectedSkinType = skinType['type'];
                });
              },
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAgeStep(AppLocalizations l10n) {
    return Column(
      children: _ageRanges.map((ageRange) {
        final isSelected = _selectedAgeRange == ageRange['range'];
        return Padding(
          padding: EdgeInsets.only(bottom: AppDimensions.space12),
          child: SizedBox(
            width: double.infinity,
            child: ChatOptionButton(
              icon: ageRange['icon'],
              label: _getLocalizedAgeRangeName(ageRange['range'], l10n),
              isSelected: isSelected,
              onTap: () {
                setState(() {
                  _selectedAgeRange = ageRange['range'];
                });
              },
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAllergiesStep(AppLocalizations l10n) {
    // Get custom allergies (not in common list)
    final customAllergies = _selectedAllergies
        .where((allergy) =>
            !_commonAllergies.any((common) => common['name'] == allergy))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Common allergies
        ..._commonAllergies.map((allergy) {
          final isSelected = _selectedAllergies.contains(allergy['name']);
          return Padding(
            padding: EdgeInsets.only(bottom: AppDimensions.space12),
            child: SizedBox(
              width: double.infinity,
              child: ChatOptionButton(
                icon: allergy['icon'],
                label: _getLocalizedAllergyName(allergy['name'], l10n),
                isSelected: isSelected,
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedAllergies.remove(allergy['name']);
                    } else {
                      _selectedAllergies.add(allergy['name']);
                    }
                  });
                },
              ),
            ),
          );
        }).toList(),

        // Custom allergy input field
        Padding(
          padding: EdgeInsets.only(
            bottom: AppDimensions.space12,
            top: AppDimensions.space8,
          ),
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
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Cancel button
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
                  // Accept button
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
              if (value.isNotEmpty && !_selectedAllergies.contains(value)) {
                setState(() {
                  _selectedAllergies.add(value);
                  _customAllergyController.clear();
                });
              }
            },
          ),
        ),

        // Custom allergies list
        if (customAllergies.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(bottom: AppDimensions.space12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSpacer.v8(),
                Text(
                  l10n.selectedAllergens,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: context.colors.onBackground,
                  ),
                ),
                AppSpacer.v8(),
                Wrap(
                  spacing: AppDimensions.space8,
                  runSpacing: AppDimensions.space8,
                  children: customAllergies.map((allergen) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppDimensions.space12,
                        vertical: AppDimensions.space8,
                      ),
                      decoration: BoxDecoration(
                        color: context.colors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppDimensions.radius8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            allergen,
                            style: TextStyle(
                              color: context.colors.primary,
                              fontSize: 14,
                            ),
                          ),
                          AppSpacer.h8(),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedAllergies.remove(allergen);
                              });
                            },
                            child: Icon(
                              Icons.close,
                              size: 16,
                              color: context.colors.primary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildNameStep(AppLocalizations l10n) {
    return Column(
      children: [
        AppSpacer.v24(),
        TextField(
          controller: _nameController,
          focusNode: _nameFocusNode,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: context.colors.onBackground,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: l10n.yourName,
            hintStyle: TextStyle(
              color: context.colors.onSecondary,
              fontSize: 18,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radius12),
              borderSide: BorderSide(
                color: context.colors.onSecondary.withValues(alpha: 0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radius12),
              borderSide: BorderSide(
                color: context.colors.primary,
                width: 2,
              ),
            ),
            filled: true,
            fillColor: context.colors.surface,
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppDimensions.space16,
              vertical: AppDimensions.space16,
            ),
          ),
        ),
      ],
    );
  }
}
