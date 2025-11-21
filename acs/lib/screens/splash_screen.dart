import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider_v2.dart';
import '../providers/subscription_provider.dart';
import '../providers/user_state.dart';
import '../constants/app_dimensions.dart';
import '../widgets/common/app_spacer.dart';
import '../widgets/animated/animated_ai_avatar.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  Future<void> _navigateToHome() async {
    // Задержка 2 секунды - лучшая практика для splash screen
    await Future.delayed(const Duration(milliseconds: 2000));

    if (!mounted) return;

    // Проверяем статус онбординга
    final userState = context.read<UserState>();
    final onboardingCompleted = userState.onboardingCompleted;

    // Если онбординг не завершён - показываем его
    if (!onboardingCompleted) {
      if (mounted) {
        context.go('/chat-onboarding');
      }
      return;
    }

    // Проверяем статус подписки
    final subscriptionProvider = context.read<SubscriptionProvider>();
    final isPremium = subscriptionProvider.isPremium;

    if (mounted) {
      // Если нет подписки - показываем paywall
      if (!isPremium) {
        context.go('/modern-paywall');
      } else {
        // Если есть подписка - переходим на главный экран
        context.go('/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProviderV2>();
    final colors = themeProvider.currentColors;

    return Scaffold(
      backgroundColor: colors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Анимированный аватар бота
            AnimatedAiAvatar(
              size: AppDimensions.space64 + AppDimensions.space64 + AppDimensions.space64,
              state: AvatarAnimationState.thinking,
              colors: colors,
            ),
            AppSpacer.v24(),
            // Индикатор загрузки (убран, так как аватар уже анимирован)
          ],
        ),
      ),
    );
  }
}
