import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/home_screen.dart';
import '../screens/solve/math_scanning_screen.dart';
import '../screens/solve/solution_results_screen.dart';
import '../screens/check/check_mode_screen.dart';
import '../screens/check/validation_results_screen.dart';
import '../screens/training/training_mode_screen.dart';
import '../screens/training/practice_results_screen.dart';
import '../screens/converter/unit_converter_screen.dart';
import '../screens/chat/math_chat_screen.dart';
import '../screens/history/solution_history_screen.dart';
import '../screens/settings/settings_screen.dart';

// No transition page builder
Page<void> _buildPageWithNoTransition(
  BuildContext context,
  GoRouterState state,
  Widget child,
) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: Duration.zero,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        child,
  );
}

// Router configuration
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    // Home screen
    GoRoute(
      path: '/',
      pageBuilder: (context, state) =>
          _buildPageWithNoTransition(context, state, const HomeScreen()),
    ),

    // Solve Mode routes
    GoRoute(
      path: '/solve',
      pageBuilder: (context, state) =>
          _buildPageWithNoTransition(context, state, const MathScanningScreen()),
    ),
    GoRoute(
      path: '/solve/results',
      pageBuilder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return _buildPageWithNoTransition(
          context,
          state,
          SolutionResultsScreen(
            solution: extra?['solution'],
            imagePath: extra?['imagePath'] as String? ?? '',
          ),
        );
      },
    ),

    // Check Mode routes
    GoRoute(
      path: '/check',
      pageBuilder: (context, state) =>
          _buildPageWithNoTransition(context, state, const CheckModeScreen()),
    ),
    GoRoute(
      path: '/check/results',
      pageBuilder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return _buildPageWithNoTransition(
          context,
          state,
          ValidationResultsScreen(
            validation: extra?['validation'],
            imagePath: extra?['imagePath'] as String? ?? '',
          ),
        );
      },
    ),

    // Training Mode routes
    GoRoute(
      path: '/training',
      pageBuilder: (context, state) =>
          _buildPageWithNoTransition(context, state, const TrainingModeScreen()),
    ),
    GoRoute(
      path: '/training/results',
      pageBuilder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return _buildPageWithNoTransition(
          context,
          state,
          PracticeResultsScreen(
            session: extra?['session'],
          ),
        );
      },
    ),

    // Unit Converter
    GoRoute(
      path: '/converter',
      pageBuilder: (context, state) =>
          _buildPageWithNoTransition(context, state, const UnitConverterScreen()),
    ),

    // Math Chat
    GoRoute(
      path: '/chat',
      pageBuilder: (context, state) =>
          _buildPageWithNoTransition(context, state, const MathChatScreen()),
    ),

    // History
    GoRoute(
      path: '/history',
      pageBuilder: (context, state) =>
          _buildPageWithNoTransition(context, state, const SolutionHistoryScreen()),
    ),

    // Settings
    GoRoute(
      path: '/settings',
      pageBuilder: (context, state) =>
          _buildPageWithNoTransition(context, state, const SettingsScreen()),
    ),
  ],
);
