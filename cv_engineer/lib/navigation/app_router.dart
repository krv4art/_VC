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
import '../screens/cover_letter_list_screen.dart';
import '../screens/cover_letter_editor_screen.dart';
import '../screens/cover_letter_preview_screen.dart';

// New advanced feature screens
import '../screens/ats_analyzer_screen.dart';
import '../screens/social_links_editor_screen.dart';
import '../screens/cover_letter_screen.dart' as cl_generator;
import '../screens/job_tracker_screen.dart';
import '../screens/resume_analytics_screen.dart';
import '../screens/resume_versions_screen.dart';

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

    // Cover Letter Routes (from HEAD)
    GoRoute(
      path: '/cover-letters',
      pageBuilder: (context, state) =>
          _buildPageWithNoTransition(context, state, const CoverLetterListScreen()),
    ),
    GoRoute(
      path: '/cover-letter-editor',
      pageBuilder: (context, state) =>
          _buildPageWithNoTransition(context, state, const CoverLetterEditorScreen()),
    ),
    GoRoute(
      path: '/cover-letter-preview',
      pageBuilder: (context, state) =>
          _buildPageWithNoTransition(context, state, const CoverLetterPreviewScreen()),
    ),

    // Advanced Features Routes (from branch)
    GoRoute(
      path: '/ats-checker',
      pageBuilder: (context, state) =>
          _buildPageWithNoTransition(context, state, const ATSAnalyzerScreen()),
    ),
    GoRoute(
      path: '/social-links',
      pageBuilder: (context, state) =>
          _buildPageWithNoTransition(context, state, const SocialLinksEditorScreen()),
    ),
    GoRoute(
      path: '/cover-letter',
      pageBuilder: (context, state) =>
          _buildPageWithNoTransition(context, state, const cl_generator.CoverLetterGeneratorScreen()),
    ),
    GoRoute(
      path: '/job-tracker',
      pageBuilder: (context, state) =>
          _buildPageWithNoTransition(context, state, const JobTrackerScreen()),
    ),
    GoRoute(
      path: '/analytics',
      pageBuilder: (context, state) =>
          _buildPageWithNoTransition(context, state, const ResumeAnalyticsScreen()),
    ),
    GoRoute(
      path: '/versions',
      pageBuilder: (context, state) =>
          _buildPageWithNoTransition(context, state, const ResumeVersionsScreen()),
    ),
  ],
);
