import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/user_preferences_provider.dart';
import '../theme/app_theme.dart';

/// Splash screen with logo and loading indicator
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    // Wait for 2 seconds - best practice for splash screen
    await Future.delayed(const Duration(milliseconds: 2000));

    if (!mounted) return;

    // Check if onboarding is completed
    final preferencesProvider = context.read<UserPreferencesProvider>();
    await preferencesProvider.loadPreferences();

    final onboardingCompleted = preferencesProvider.preferences.onboardingCompleted ?? false;

    if (mounted) {
      // If onboarding not completed - show it
      if (!onboardingCompleted) {
        context.go('/onboarding');
      } else {
        // Otherwise - go to home screen
        context.go('/');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final colors = themeProvider.colors;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colors.primary,
              colors.primaryLight,
              colors.secondary,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App logo with shadow
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppTheme.space24 + AppTheme.space4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppTheme.space24 + AppTheme.space4),
                  child: Container(
                    width: 144,
                    height: 144,
                    color: Colors.white,
                    child: Icon(
                      Icons.eco,
                      size: 80,
                      color: colors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.space24),

              // App name
              Text(
                'Plant Identifier',
                style: AppTheme.h1.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppTheme.space8),

              Text(
                'Discover the Nature',
                style: AppTheme.body.copyWith(
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              const SizedBox(height: AppTheme.space48),

              // Loading indicator
              SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.white.withOpacity(0.8),
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
