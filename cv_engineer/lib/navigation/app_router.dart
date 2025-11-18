import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/splash_screen.dart';
import '../screens/home_screen.dart';
import '../screens/onboarding_screen.dart';
import '../screens/resume_editor_screen.dart';
import '../screens/resume_list_screen.dart';
import '../screens/template_selection_screen.dart';
import '../screens/preview_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/interview_questions_screen.dart';

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
      path: '/onboarding',
      pageBuilder: (context, state) =>
          _buildPageWithNoTransition(context, state, const OnboardingScreen()),
    ),
    GoRoute(
      path: '/home',
      pageBuilder: (context, state) =>
          _buildPageWithNoTransition(context, state, const HomeScreen()),
    ),
    GoRoute(
      path: '/resumes',
      pageBuilder: (context, state) =>
          _buildPageWithNoTransition(context, state, const ResumeListScreen()),
    ),
    GoRoute(
      path: '/templates',
      pageBuilder: (context, state) =>
          _buildPageWithNoTransition(context, state, const TemplateSelectionScreen()),
    ),
    GoRoute(
      path: '/editor',
      pageBuilder: (context, state) =>
          _buildPageWithNoTransition(context, state, const ResumeEditorScreen()),
    ),
    GoRoute(
      path: '/preview',
      pageBuilder: (context, state) =>
          _buildPageWithNoTransition(context, state, const PreviewScreen()),
    ),
    GoRoute(
      path: '/settings',
      pageBuilder: (context, state) =>
          _buildPageWithNoTransition(context, state, const SettingsScreen()),
    ),
    GoRoute(
      path: '/interview-questions',
      pageBuilder: (context, state) =>
          _buildPageWithNoTransition(context, state, const InterviewQuestionsScreen()),
    ),
  ],
);
