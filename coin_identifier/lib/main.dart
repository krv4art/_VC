import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:go_router/go_router.dart';

import 'utils/supabase_constants.dart';
import 'config/app_config.dart';
import 'config/prompts_manager.dart';
import 'services/gemini_service.dart';
import 'providers/analysis_provider.dart';
import 'providers/collection_provider.dart';
import 'providers/theme_provider.dart';

import 'screens/home_screen.dart';
import 'screens/scan_screen.dart';
import 'screens/results_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/history_screen.dart';
import 'screens/wishlist_screen.dart';
import 'screens/statistics_screen.dart';
import 'screens/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize database factory for web
  // Disabled - not using sqflite_common_ffi_web
  // if (kIsWeb) {
  //   databaseFactory = databaseFactoryFfiWeb;
  // }

  // Initialize app configuration
  await AppConfig().initialize();

  // Initialize prompts manager
  await PromptsManager.initialize();

  // Initialize Supabase
  await Supabase.initialize(
    url: SupabaseConfig.supabaseUrl.isNotEmpty
        ? SupabaseConfig.supabaseUrl
        : (kDebugMode
            ? SupabaseConfig.devSupabaseUrl
            : SupabaseConfig.prodSupabaseUrl),
    anonKey: SupabaseConfig.supabaseAnonKey.isNotEmpty
        ? SupabaseConfig.supabaseAnonKey
        : (kDebugMode
            ? SupabaseConfig.devSupabaseAnonKey
            : SupabaseConfig.prodSupabaseAnonKey),
  );

  // Initialize theme provider
  final themeProvider = ThemeProvider();
  await themeProvider.init();

  runApp(CoinIdentifierApp(themeProvider: themeProvider));
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();

/// Custom page transition builder for smooth slide animations
Page<dynamic> _buildSlideTransition(
    BuildContext context, GoRouterState state, Widget child) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: animation.drive(
          Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).chain(
            CurveTween(curve: Curves.easeInOutCubic),
          ),
        ),
        child: FadeTransition(
          opacity: animation.drive(
            Tween<double>(begin: 0.8, end: 1.0).chain(
              CurveTween(curve: Curves.easeInOutCubic),
            ),
          ),
          child: child,
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 400),
  );
}

/// Custom page transition builder for fade animations
Page<dynamic> _buildFadeTransition(
    BuildContext context, GoRouterState state, Widget child) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation.drive(
          CurveTween(curve: Curves.easeInOutCubic),
        ),
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 300),
  );
}

final GoRouter _router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      pageBuilder: (context, state) =>
          _buildFadeTransition(context, state, const HomeScreen()),
    ),
    GoRoute(
      path: '/scan',
      name: 'scan',
      pageBuilder: (context, state) =>
          _buildSlideTransition(context, state, const ScanScreen()),
    ),
    GoRoute(
      path: '/results',
      name: 'results',
      pageBuilder: (context, state) {
        final resultId = state.uri.queryParameters['id'];
        return _buildSlideTransition(
            context, state, ResultsScreen(resultId: resultId));
      },
    ),
    GoRoute(
      path: '/chat',
      name: 'chat',
      pageBuilder: (context, state) {
        final dialogueId = state.uri.queryParameters['dialogueId'];
        return _buildSlideTransition(
            context, state, ChatScreen(dialogueId: dialogueId));
      },
    ),
    GoRoute(
      path: '/history',
      name: 'history',
      pageBuilder: (context, state) =>
          _buildSlideTransition(context, state, const HistoryScreen()),
    ),
    GoRoute(
      path: '/wishlist',
      name: 'wishlist',
      pageBuilder: (context, state) =>
          _buildSlideTransition(context, state, const WishlistScreen()),
    ),
    GoRoute(
      path: '/statistics',
      name: 'statistics',
      pageBuilder: (context, state) =>
          _buildSlideTransition(context, state, const StatisticsScreen()),
    ),
    GoRoute(
      path: '/settings',
      name: 'settings',
      pageBuilder: (context, state) =>
          _buildSlideTransition(context, state, const SettingsScreen()),
    ),
  ],
);

class CoinIdentifierApp extends StatelessWidget {
  final ThemeProvider themeProvider;

  const CoinIdentifierApp({Key? key, required this.themeProvider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AnalysisProvider()),
        ChangeNotifierProvider(create: (_) => CollectionProvider()),
        ChangeNotifierProvider.value(value: themeProvider),
        // Add GeminiService provider for AI analysis
        Provider<GeminiService>(
          create: (context) => GeminiService(
            useProxy: true,
            supabaseClient: Supabase.instance.client,
          ),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp.router(
            title: 'Coin Identifier',
            theme: ThemeProvider.lightTheme,
            darkTheme: ThemeProvider.darkTheme,
            themeMode: themeProvider.themeMode,
            routerConfig: _router,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
