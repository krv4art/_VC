import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider_v2.dart';
import '../providers/subscription_provider.dart';
import '../providers/user_state.dart';
import '../constants/app_dimensions.dart';
import '../widgets/common/app_spacer.dart';

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
      body: Container(
        decoration: BoxDecoration(
          gradient: colors.primaryGradient,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Логотип приложения с тенью
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppDimensions.space24 + AppDimensions.space4 + AppDimensions.space4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppDimensions.space24 + AppDimensions.space4 + AppDimensions.space4),
                  child: Image.asset(
                    'assets/icon/logo.png',
                    width: AppDimensions.space64 + AppDimensions.space64 + AppDimensions.space16 + AppDimensions.space4 + AppDimensions.space4,
                    height: AppDimensions.space64 + AppDimensions.space64 + AppDimensions.space16 + AppDimensions.space4 + AppDimensions.space4,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              AppSpacer.v24(),
              // Индикатор загрузки
              SizedBox(
                width: AppDimensions.space40,
                height: AppDimensions.space40,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
