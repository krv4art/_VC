import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/splash_screen.dart';
import '../screens/sign_up_screen.dart';
import '../screens/onboarding_screen.dart';
import '../screens/homepage_screen.dart';
import '../screens/scanning_screen.dart';
import '../screens/analysis_results_screen.dart';
import '../screens/skin_type_screen.dart';
import '../screens/age_selection_screen.dart';
import '../screens/allergies_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/scan_history_screen.dart';
import '../screens/chat_ai_screen.dart';
import '../screens/modern_paywall_screen.dart';
import '../screens/new_paywall_screen.dart';
import '../screens/language_screen.dart';
import '../screens/ai_bot_settings_screen.dart';
import '../screens/usage_limits_test_screen.dart';
import '../models/analysis_result.dart';
import '../screens/dialogue_list_screen.dart';
import '../screens/database_test_screen.dart';
import '../screens/theme_selection_screen.dart';
import '../screens/chat_onboarding_screen.dart';

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
    GoRoute(
      path: '/',
      pageBuilder: (context, state) =>
          _buildPageWithNoTransition(context, state, const SplashScreen()),
    ),
    GoRoute(
      path: '/signup',
      pageBuilder: (context, state) =>
          _buildPageWithNoTransition(context, state, const SignUpScreen()),
    ),
    GoRoute(
      path: '/onboarding',
      pageBuilder: (context, state) =>
          _buildPageWithNoTransition(context, state, const OnboardingScreen()),
    ),
    GoRoute(
      path: '/chat-onboarding',
      pageBuilder: (context, state) => _buildPageWithNoTransition(
        context,
        state,
        const ChatOnboardingScreen(),
      ),
    ),
    GoRoute(
      path: '/home',
      pageBuilder: (context, state) =>
          _buildPageWithNoTransition(context, state, const HomepageScreen()),
    ),
    GoRoute(
      path: '/scanning',
      pageBuilder: (context, state) =>
          _buildPageWithNoTransition(context, state, const ScanningScreen()),
    ),
    GoRoute(
      path: '/analysis',
      pageBuilder: (context, state) {
        if (state.extra is Map<String, dynamic>) {
          final data = state.extra as Map<String, dynamic>;
          final result = data['result'] as AnalysisResult;
          final imagePath = data['imagePath'] as String;
          final source = (data['source'] as String?) ?? 'scanning';

          return _buildPageWithNoTransition(
            context,
            state,
            AnalysisResultsScreen(
              result: result,
              imagePath: imagePath,
              source: source,
            ),
          );
        } else if (state.extra is AnalysisResult) {
          // Fallback for existing navigation
          return _buildPageWithNoTransition(
            context,
            state,
            AnalysisResultsScreen(
              result: state.extra as AnalysisResult,
              imagePath: '',
              source: 'scanning',
            ),
          );
        } else {
          // Handle error case
          return _buildPageWithNoTransition(
            context,
            state,
            const Scaffold(
              body: Center(child: Text('Error: Analysis results not found.')),
            ),
          );
        }
      },
    ),
    GoRoute(
      path: '/skintype',
      pageBuilder: (context, state) =>
          _buildPageWithNoTransition(context, state, const SkinTypeScreen()),
    ),
    GoRoute(
      path: '/age',
      pageBuilder: (context, state) => _buildPageWithNoTransition(
        context,
        state,
        const AgeSelectionScreen(),
      ),
    ),
    GoRoute(
      path: '/allergies',
      pageBuilder: (context, state) =>
          _buildPageWithNoTransition(context, state, const AllergiesScreen()),
    ),
    GoRoute(
      path: '/profile',
      pageBuilder: (context, state) =>
          _buildPageWithNoTransition(context, state, const ProfileScreen()),
    ),
    GoRoute(
      path: '/history',
      pageBuilder: (context, state) =>
          _buildPageWithNoTransition(context, state, const ScanHistoryScreen()),
    ),
    GoRoute(
      path: '/dialogues',
      pageBuilder: (context, state) => _buildPageWithNoTransition(
        context,
        state,
        const DialogueListScreen(),
      ),
    ),
    GoRoute(
      path: '/chat',
      pageBuilder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final scanResultId = extra?['scanResultId'] as int?;
        return _buildPageWithNoTransition(
          context,
          state,
          ChatAIScreen(scanResultId: scanResultId),
        );
      },
    ),
    GoRoute(
      path: '/chat/:dialogueId',
      pageBuilder: (context, state) {
        final dialogueId = int.tryParse(state.pathParameters['dialogueId']!);
        debugPrint(
          '=== ROUTER DEBUG: Navigating to chat with dialogueId: $dialogueId ===',
        );
        return _buildPageWithNoTransition(
          context,
          state,
          ChatAIScreen(dialogueId: dialogueId),
        );
      },
    ),
    GoRoute(
      path: '/modern-paywall',
      pageBuilder: (context, state) =>
          _buildPageWithNoTransition(context, state, const NewPaywallScreen()),
    ),
    GoRoute(
      path: '/old-paywall',
      pageBuilder: (context, state) => _buildPageWithNoTransition(
        context,
        state,
        const ModernPaywallScreen(),
      ),
    ),
    GoRoute(
      path: '/language',
      pageBuilder: (context, state) =>
          _buildPageWithNoTransition(context, state, const LanguageScreen()),
    ),
    // Temporary route for database testing
    GoRoute(
      path: '/db-test',
      pageBuilder: (context, state) => _buildPageWithNoTransition(
        context,
        state,
        const DatabaseTestScreen(),
      ),
    ),
    // Theme selection screen (predefined themes only, no custom editor)
    GoRoute(
      path: '/theme-selection',
      pageBuilder: (context, state) => _buildPageWithNoTransition(
        context,
        state,
        const ThemeSelectionScreen(),
      ),
    ),
    GoRoute(
      path: '/ai-bot-settings',
      pageBuilder: (context, state) => _buildPageWithNoTransition(
        context,
        state,
        const AiBotSettingsScreen(),
      ),
    ),
    GoRoute(
      path: '/usage-limits-test',
      pageBuilder: (context, state) => _buildPageWithNoTransition(
        context,
        state,
        const UsageLimitsTestScreen(),
      ),
    ),
  ],
);
