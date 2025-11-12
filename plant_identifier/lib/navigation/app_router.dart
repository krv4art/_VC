import 'package:go_router/go_router.dart';
import '../screens/splash_screen.dart';
import '../screens/onboarding_screen.dart';
import '../screens/home_screen.dart';
import '../screens/scan_screen.dart';
import '../screens/history_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/language_screen.dart';
import '../screens/theme_selection_screen.dart';
import '../screens/plant_result_screen.dart';
import '../screens/chat_ai_screen.dart';
import '../models/plant_result.dart';

/// App routing configuration
final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      name: 'onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/scan',
      name: 'scan',
      builder: (context, state) => const ScanScreen(),
    ),
    GoRoute(
      path: '/history',
      name: 'history',
      builder: (context, state) => const HistoryScreen(),
    ),
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/profile',
      name: 'profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/language',
      name: 'language',
      builder: (context, state) => const LanguageScreen(),
    ),
    GoRoute(
      path: '/theme-selection',
      name: 'theme-selection',
      builder: (context, state) => const ThemeSelectionScreen(),
    ),
    GoRoute(
      path: '/plant-result',
      name: 'plant-result',
      builder: (context, state) {
        final plantResult = state.extra as PlantResult?;
        if (plantResult == null) {
          // If no plant result provided, redirect to home
          return const HomeScreen();
        }
        return PlantResultScreen(result: plantResult);
      },
    ),
    GoRoute(
      path: '/chat',
      name: 'chat',
      builder: (context, state) {
        final extras = state.extra as Map<String, dynamic>?;
        return ChatAIScreen(
          dialogueId: extras?['dialogueId'] as int?,
          plantContext: extras?['plantContext'] as String?,
          plantImagePath: extras?['plantImagePath'] as String?,
          plantResultId: (extras?['plantResultId'] as int?)?.toString(),
        );
      },
    ),
  ],
);
