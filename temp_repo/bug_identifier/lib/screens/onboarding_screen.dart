import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../theme/theme_extensions_v2.dart';
import '../widgets/animated/animated_card.dart';
import '../widgets/animated/animated_button.dart' as btn;
import '../constants/app_dimensions.dart';
import '../widgets/common/app_spacer.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  bool _isTrialEnabled = false;
  String _selectedPlan = 'monthly';
  late AnimationController _animationController;
  late List<Animation<double>> _animations;

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
    _animations = List.generate(4, (index) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      body: SingleChildScrollView(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Column(
              children: [
                // Сетка с карточками (2x2) - Animation 0
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
                    child: GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.all(AppDimensions.space16),
                      children: [
                        // Карточка 1
                        AnimatedCard(
                          elevation: 2,
                          margin: EdgeInsets.all(AppDimensions.space8),
                          child: Padding(
                            padding: EdgeInsets.all(AppDimensions.space16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.timer,
                                  size: AppDimensions.iconLarge,
                                  color: context.colors.primary,
                                ),
                                AppSpacer.v8(),
                                Text(
                                  'Экономия часов на чтении этикеток',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Карточка 2
                        AnimatedCard(
                          elevation: 2,
                          margin: EdgeInsets.all(AppDimensions.space8),
                          child: Padding(
                            padding: EdgeInsets.all(AppDimensions.space16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.person,
                                  size: AppDimensions.iconLarge,
                                  color: context.colors.primary,
                                ),
                                AppSpacer.v8(),
                                Text(
                                  'Персональные рекомендации',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Карточка 3
                        AnimatedCard(
                          elevation: 2,
                          margin: EdgeInsets.all(AppDimensions.space8),
                          child: Padding(
                            padding: EdgeInsets.all(AppDimensions.space16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.science,
                                  size: AppDimensions.iconLarge,
                                  color: context.colors.primary,
                                ),
                                AppSpacer.v8(),
                                Text(
                                  'Анализ любого состава',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Карточка 4
                        AnimatedCard(
                          elevation: 2,
                          margin: EdgeInsets.all(AppDimensions.space8),
                          child: Padding(
                            padding: EdgeInsets.all(AppDimensions.space16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.history,
                                  size: AppDimensions.iconLarge,
                                  color: context.colors.primary,
                                ),
                                AppSpacer.v8(),
                                Text(
                                  'История сканирований',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Блок с переключателем триала - Animation 1
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
                    child: AnimatedCard(
                      elevation: 0,
                      margin: EdgeInsets.all(AppDimensions.space16),
                      child: Padding(
                        padding: EdgeInsets.all(AppDimensions.space16),
                        child: Row(
                          children: [
                            Text('Start with a 3-day free trial'),
                            const Spacer(),
                            Switch(
                              value: _isTrialEnabled,
                              onChanged: (bool value) {
                                setState(() {
                                  _isTrialEnabled = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Плашки с ценами - Animation 2
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
                    child: AnimatedCard(
                      elevation: 0,
                      margin: EdgeInsets.all(AppDimensions.space16),
                      child: Padding(
                        padding: EdgeInsets.all(AppDimensions.space16),
                        child: Column(
                          children: [
                            RadioListTile<String>(
                              title: const Text('Ежемесячно'),
                              value: 'monthly',
                              groupValue: _selectedPlan,
                              onChanged: (String? value) {
                                setState(() {
                                  _selectedPlan = value!;
                                });
                              },
                            ),
                            RadioListTile<String>(
                              title: const Text('Ежегодно'),
                              value: 'yearly',
                              groupValue: _selectedPlan,
                              onChanged: (String? value) {
                                setState(() {
                                  _selectedPlan = value!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Кнопка подписки - Animation 3
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
                    child: Container(
                      margin: EdgeInsets.all(AppDimensions.space16),
                      child: SizedBox(
                        width: double.infinity,
                        height:
                            AppDimensions.buttonLarge + AppDimensions.space4,
                        child: btn.AnimatedButton(
                          buttonType: btn.ButtonType.elevated,
                          animationStyle: btn.AnimationStyle.scale,
                          backgroundColor: context.colors.primary,
                          foregroundColor: Colors.white,
                          borderRadius: BorderRadius.circular(
                            AppTheme.radiusStandard,
                          ),
                          onPressed: () {
                            // Логика будет добавлена позже
                          },
                          child: Text(
                            _isTrialEnabled ? 'Start for free' : 'Subscribe',
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
}
