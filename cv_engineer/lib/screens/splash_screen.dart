import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      context.go('/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: theme.colorScheme.brightness == Brightness.light
              ? LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.primary.withValues(alpha: 0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: theme.colorScheme.brightness == Brightness.dark
              ? theme.scaffoldBackgroundColor
              : null,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.description,
                size: 100,
                color: theme.colorScheme.brightness == Brightness.light
                    ? Colors.white
                    : theme.colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                'CV Engineer',
                style: theme.textTheme.displayMedium?.copyWith(
                  color: theme.colorScheme.brightness == Brightness.light
                      ? Colors.white
                      : theme.colorScheme.onBackground,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Professional Resume Builder',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.brightness == Brightness.light
                      ? Colors.white.withValues(alpha: 0.9)
                      : theme.colorScheme.onBackground.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 48),
              CircularProgressIndicator(
                color: theme.colorScheme.brightness == Brightness.light
                    ? Colors.white
                    : theme.colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
