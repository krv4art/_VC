import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ai_photo_studio_pro/screens/splash_screen.dart';
import 'package:ai_photo_studio_pro/screens/onboarding_screen.dart';
import 'package:ai_photo_studio_pro/screens/homepage_screen.dart';
import 'package:ai_photo_studio_pro/screens/camera_screen.dart';
import 'package:ai_photo_studio_pro/screens/gallery_screen.dart';
import 'package:ai_photo_studio_pro/screens/styles_catalog_screen.dart';
import 'package:ai_photo_studio_pro/screens/profile_screen.dart';
import 'package:ai_photo_studio_pro/screens/new_paywall_screen.dart';
import 'package:ai_photo_studio_pro/screens/language_screen.dart';
import 'package:ai_photo_studio_pro/screens/theme_selection_screen.dart';
import 'package:ai_photo_studio_pro/screens/advanced_photo_editor_screen.dart';
import 'package:ai_photo_studio_pro/screens/batch_generation_screen.dart';
import 'package:ai_photo_studio_pro/models/style_model.dart';

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
          _buildPageWithNoTransition(context, state, const HomepageScreen()),
    ),
    GoRoute(
      path: '/camera',
      pageBuilder: (context, state) =>
          _buildPageWithNoTransition(context, state, const CameraScreen()),
    ),
    GoRoute(
      path: '/gallery',
      pageBuilder: (context, state) =>
          _buildPageWithNoTransition(context, state, const GalleryScreen()),
    ),
    GoRoute(
      path: '/styles',
      pageBuilder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final callback = extra?['onStyleSelected'] as Function(StyleModel)?;
        final imagePath = extra?['imagePath'] as String?;
        return _buildPageWithNoTransition(
          context,
          state,
          StylesCatalogScreen(
            onStyleSelected: callback,
            preselectedImagePath: imagePath,
          ),
        );
      },
    ),
    GoRoute(
      path: '/profile',
      pageBuilder: (context, state) =>
          _buildPageWithNoTransition(context, state, const ProfileScreen()),
    ),
    GoRoute(
      path: '/paywall',
      pageBuilder: (context, state) =>
          _buildPageWithNoTransition(context, state, const NewPaywallScreen()),
    ),
    GoRoute(
      path: '/language',
      pageBuilder: (context, state) =>
          _buildPageWithNoTransition(context, state, const LanguageScreen()),
    ),
    GoRoute(
      path: '/theme-selection',
      pageBuilder: (context, state) => _buildPageWithNoTransition(
        context,
        state,
        const ThemeSelectionScreen(),
      ),
    ),
    GoRoute(
      path: '/advanced-editor',
      pageBuilder: (context, state) {
        final imagePath = state.extra as String?;
        if (imagePath == null) {
          // Navigate to gallery to select a photo first
          return _buildPageWithNoTransition(context, state, const GalleryScreen());
        }
        return _buildPageWithNoTransition(
          context,
          state,
          AdvancedPhotoEditorScreen(imagePath: imagePath),
        );
      },
    ),
    GoRoute(
      path: '/batch-generation',
      pageBuilder: (context, state) =>
          _buildPageWithNoTransition(context, state, const BatchGenerationScreen()),
    ),
  ],
);
