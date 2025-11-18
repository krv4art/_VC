import 'package:flutter/material.dart';
import '../constants/app_dimensions.dart';
import '../widgets/common/app_spacer.dart';
import '../widgets/animated/animated_card.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
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

    // Staggered animations for different sections
    _animations = List.generate(4, (index) {
      final startTime = index * 0.1;
      final endTime = startTime + 0.4;

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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Column(
                children: [
                  AppSpacer.v24(),
                  // App Logo
                  FadeTransition(
                    opacity: _animations[0],
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, -0.3),
                        end: Offset.zero,
                      ).animate(_animationController),
                      child: Column(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: const Color(0xFF6B4EFF).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: const Icon(
                              Icons.auto_fix_high,
                              size: 60,
                              color: Color(0xFF6B4EFF),
                            ),
                          ),
                          AppSpacer.v16(),
                          const Text(
                            'AI Background Changer',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          AppSpacer.v8(),
                          const Text(
                            'Transform your photos with AI',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                  AppSpacer.v32(),
                  // Features Grid (2x2)
                  FadeTransition(
                    opacity: _animations[1],
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.3),
                        end: Offset.zero,
                      ).animate(_animationController),
                      child: GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(AppDimensions.space16),
                        children: [
                          _buildFeatureCard(
                            Icons.auto_awesome,
                            'Smart Background Removal',
                          ),
                          _buildFeatureCard(
                            Icons.palette,
                            'Creative Styles',
                          ),
                          _buildFeatureCard(
                            Icons.chat,
                            'AI Assistant',
                          ),
                          _buildFeatureCard(
                            Icons.history,
                            'History & Favorites',
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Get Started Button
                  FadeTransition(
                    opacity: _animations[3],
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.3),
                        end: Offset.zero,
                      ).animate(_animationController),
                      child: Container(
                        margin: const EdgeInsets.all(AppDimensions.space16),
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => context.go('/'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6B4EFF),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text(
                            'Get Started',
                            style: TextStyle(fontSize: 18),
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
      ),
    );
  }

  Widget _buildFeatureCard(IconData icon, String title) {
    return AnimatedCard(
      elevation: 2,
      margin: const EdgeInsets.all(AppDimensions.space8),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.space16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: const Color(0xFF6B4EFF),
            ),
            AppSpacer.v8(),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
