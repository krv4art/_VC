import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../screens/onboarding/welcome_screen.dart';
import '../screens/onboarding/interests_selection_screen.dart';
import '../screens/onboarding/cultural_theme_screen.dart';
import '../screens/onboarding/learning_style_screen.dart';
import '../screens/onboarding/level_assessment_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/chat/tutor_chat_screen.dart';
import '../screens/subjects/subject_selection_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/progress/progress_screen.dart';
import '../screens/practice/practice_screen.dart';
import '../screens/challenges/challenges_screen.dart';
import '../screens/reports/weekly_report_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/brain_training/brain_training_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/social/leaderboard_screen.dart';
import '../screens/social/friends_screen.dart';
import '../screens/analytics/analytics_screen.dart';
import '../screens/premium/premium_screen.dart';
import '../screens/account/account_management_screen.dart';
import '../screens/legal/privacy_policy_screen.dart';
import '../screens/legal/terms_of_service_screen.dart';
import '../config/app_config.dart';
import '../providers/auth_provider.dart';

/// App router configuration
GoRouter createAppRouter() {
  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final isOnboardingComplete = AppConfig().isOnboardingComplete;

      // Auth routes
      final authRoutes = ['/login', '/register', '/forgot-password'];
      final isAuthRoute = authRoutes.contains(state.matchedLocation);

      // If not onboarded, redirect to onboarding (except auth routes)
      if (!isOnboardingComplete &&
          !state.matchedLocation.startsWith('/onboarding') &&
          !isAuthRoute) {
        return '/onboarding/welcome';
      }

      // If onboarded and going to onboarding, redirect to home
      if (isOnboardingComplete && state.matchedLocation.startsWith('/onboarding')) {
        return '/home';
      }

      return null;
    },
    routes: [
      // Root redirects to appropriate screen
      GoRoute(
        path: '/',
        redirect: (context, state) {
          final isOnboardingComplete = AppConfig().isOnboardingComplete;
          return isOnboardingComplete ? '/home' : '/onboarding/welcome';
        },
      ),

    // Onboarding flow
    GoRoute(
      path: '/onboarding/welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/onboarding/interests',
      builder: (context, state) => const InterestsSelectionScreen(),
    ),
    GoRoute(
      path: '/onboarding/theme',
      builder: (context, state) => const CulturalThemeScreen(),
    ),
    GoRoute(
      path: '/onboarding/style',
      builder: (context, state) => const LearningStyleScreen(),
    ),
    GoRoute(
      path: '/onboarding/level',
      builder: (context, state) => const LevelAssessmentScreen(),
    ),

    // Main app
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/subjects',
      builder: (context, state) => const SubjectSelectionScreen(),
    ),
    GoRoute(
      path: '/chat/:subjectId',
      builder: (context, state) {
        final subjectId = state.pathParameters['subjectId']!;
        return TutorChatScreen(subjectId: subjectId);
      },
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/progress',
      builder: (context, state) => const ProgressScreen(),
    ),
    GoRoute(
      path: '/practice/:subjectId',
      builder: (context, state) {
        final subjectId = state.pathParameters['subjectId']!;
        return PracticeScreen(subjectId: subjectId);
      },
    ),
    GoRoute(
      path: '/challenges',
      builder: (context, state) => const ChallengesScreen(),
    ),
    GoRoute(
      path: '/weekly-report',
      builder: (context, state) => const WeeklyReportScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/brain-training',
      builder: (context, state) => const BrainTrainingScreen(),
    ),

      // Auth
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),

      // Social
      GoRoute(
        path: '/leaderboard',
        builder: (context, state) => const LeaderboardScreen(),
      ),
      GoRoute(
        path: '/friends',
        builder: (context, state) => const FriendsScreen(),
      ),

      // Analytics
      GoRoute(
        path: '/analytics',
        builder: (context, state) => const AnalyticsScreen(),
      ),

      // Premium
      GoRoute(
        path: '/premium',
        builder: (context, state) => const PremiumScreen(),
      ),

      // Account Management
      GoRoute(
        path: '/account',
        builder: (context, state) => const AccountManagementScreen(),
      ),

      // Legal
      GoRoute(
        path: '/privacy-policy',
        builder: (context, state) => const PrivacyPolicyScreen(),
      ),
      GoRoute(
        path: '/terms-of-service',
        builder: (context, state) => const TermsOfServiceScreen(),
      ),
    ],
  );
}
