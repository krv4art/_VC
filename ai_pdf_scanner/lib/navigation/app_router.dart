import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'route_names.dart';
import '../screens/home/home_screen.dart';
import '../screens/library/library_screen.dart';
import '../screens/scanner/scanner_screen.dart';
import '../screens/settings/settings_screen.dart';

/// Application router configuration using GoRouter
/// All navigation is handled through this router
class AppRouter {
  // Private constructor to prevent instantiation
  AppRouter._();

  /// GoRouter configuration
  static final GoRouter router = GoRouter(
    initialLocation: RouteNames.home,
    routes: [
      // Home Screen
      GoRoute(
        path: RouteNames.home,
        name: 'home',
        pageBuilder: (context, state) => _noTransitionPage(
          context,
          state,
          const HomeScreen(),
        ),
      ),

      // Library Screen
      GoRoute(
        path: RouteNames.library,
        name: 'library',
        pageBuilder: (context, state) => _noTransitionPage(
          context,
          state,
          const LibraryScreen(),
        ),
      ),

      // Scanner Screen
      GoRoute(
        path: RouteNames.scanner,
        name: 'scanner',
        pageBuilder: (context, state) => _noTransitionPage(
          context,
          state,
          const ScannerScreen(),
        ),
      ),

      // Settings Screen
      GoRoute(
        path: RouteNames.settings,
        name: 'settings',
        pageBuilder: (context, state) => _noTransitionPage(
          context,
          state,
          const SettingsScreen(),
        ),
      ),

      // PDF Viewer Screen
      GoRoute(
        path: RouteNames.pdfViewer,
        name: 'pdf-viewer',
        pageBuilder: (context, state) {
          final documentId = state.uri.queryParameters['id'];
          return _noTransitionPage(
            context,
            state,
            Scaffold(
              appBar: AppBar(title: const Text('PDF Viewer')),
              body: Center(
                child: Text('PDF Viewer - Document ID: $documentId'),
              ),
            ),
          );
        },
      ),

      // PDF Editor Screen
      GoRoute(
        path: RouteNames.pdfEditor,
        name: 'pdf-editor',
        pageBuilder: (context, state) {
          final documentId = state.uri.queryParameters['id'];
          return _noTransitionPage(
            context,
            state,
            Scaffold(
              appBar: AppBar(title: const Text('PDF Editor')),
              body: Center(
                child: Text('PDF Editor - Document ID: $documentId'),
              ),
            ),
          );
        },
      ),

      // Converter Screen
      GoRoute(
        path: RouteNames.converter,
        name: 'converter',
        pageBuilder: (context, state) => _noTransitionPage(
          context,
          state,
          Scaffold(
            appBar: AppBar(title: const Text('Converter')),
            body: const Center(child: Text('Converter Screen')),
          ),
        ),
      ),

      // Tools Screen
      GoRoute(
        path: RouteNames.tools,
        name: 'tools',
        pageBuilder: (context, state) => _noTransitionPage(
          context,
          state,
          Scaffold(
            appBar: AppBar(title: const Text('Tools')),
            body: const Center(child: Text('Tools Screen')),
          ),
        ),
      ),
    ],

    // Error handling
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48),
            const SizedBox(height: 16),
            Text('Page not found: ${state.uri.path}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(RouteNames.home),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );

  /// Creates a page with no transition animation (instant navigation)
  /// This provides a snappier feel for the app, similar to ACS approach
  static CustomTransitionPage _noTransitionPage(
    BuildContext context,
    GoRouterState state,
    Widget child,
  ) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // No animation - instant transition
        return child;
      },
    );
  }
}
