import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/camera_screen.dart';
import '../screens/fish_result_screen.dart';
import '../screens/history_screen.dart';
import '../screens/collection_screen.dart';
import '../screens/chat_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/main_screen.dart';
import '../screens/premium_screen.dart';
import '../screens/fishing_map_screen.dart';
import '../screens/forecast_screen.dart';
import '../screens/regulations_screen.dart';
import '../screens/statistics_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const MainScreen(),
      ),
      GoRoute(
        path: '/camera',
        builder: (context, state) => const CameraScreen(),
      ),
      GoRoute(
        path: '/result/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return FishResultScreen(fishId: id);
        },
      ),
      GoRoute(
        path: '/history',
        builder: (context, state) => const HistoryScreen(),
      ),
      GoRoute(
        path: '/collection',
        builder: (context, state) => const CollectionScreen(),
      ),
      GoRoute(
        path: '/chat',
        builder: (context, state) {
          final fishId = state.uri.queryParameters['fishId'];
          return ChatScreen(fishId: fishId != null ? int.parse(fishId) : null);
        },
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/premium',
        builder: (context, state) => const PremiumScreen(),
      ),
      GoRoute(
        path: '/fishing-map',
        builder: (context, state) => const FishingMapScreen(),
      ),
      // NEW ROUTES FOR ENHANCED FEATURES
      GoRoute(
        path: '/forecast',
        builder: (context, state) => const ForecastScreen(),
      ),
      GoRoute(
        path: '/regulations',
        builder: (context, state) => const RegulationsScreen(),
      ),
      GoRoute(
        path: '/statistics',
        builder: (context, state) => const StatisticsScreen(),
      ),
    ],
  );
}
