import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:go_router/go_router.dart';

import 'utils/supabase_constants.dart';
import 'config/app_config.dart';
import 'services/gemini_service.dart';
import 'services/background_processing_service.dart';
import 'services/chat_service.dart';
import 'providers/background_provider.dart';
import 'providers/chat_provider.dart';

import 'screens/home_screen.dart';
import 'screens/select_image_screen.dart';
import 'screens/processing_screen.dart';
import 'screens/result_screen.dart';
import 'screens/history_screen.dart';
import 'screens/chat_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize database factory for web
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  }

  // Initialize app configuration
  await AppConfig().initialize();

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

  runApp(const BackgroundChangerApp());
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
      path: '/select-image',
      name: 'select-image',
      pageBuilder: (context, state) =>
          _buildSlideTransition(context, state, const SelectImageScreen()),
    ),
    GoRoute(
      path: '/processing',
      name: 'processing',
      pageBuilder: (context, state) =>
          _buildSlideTransition(context, state, const ProcessingScreen()),
    ),
    GoRoute(
      path: '/result',
      name: 'result',
      pageBuilder: (context, state) {
        final resultId = state.uri.queryParameters['id'];
        return _buildSlideTransition(
            context, state, ResultScreen(resultId: resultId));
      },
    ),
    GoRoute(
      path: '/history',
      name: 'history',
      pageBuilder: (context, state) =>
          _buildSlideTransition(context, state, const HistoryScreen()),
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
  ],
);

class BackgroundChangerApp extends StatelessWidget {
  const BackgroundChangerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Services
        Provider<GeminiService>(
          create: (context) => GeminiService(
            useProxy: true,
            supabaseClient: Supabase.instance.client,
          ),
        ),
        Provider<BackgroundProcessingService>(
          create: (context) => BackgroundProcessingService(
            Supabase.instance.client,
          ),
        ),
        ProxyProvider<GeminiService, ChatService>(
          update: (context, geminiService, _) => ChatService(geminiService),
        ),
        // Providers
        ProxyProvider2<BackgroundProcessingService, GeminiService,
            BackgroundProvider>(
          update: (context, processingService, geminiService, _) =>
              BackgroundProvider(processingService, geminiService),
        ),
        ProxyProvider<ChatService, ChatProvider>(
          update: (context, chatService, _) => ChatProvider(chatService),
        ),
      ],
      child: MaterialApp.router(
        title: 'AI Background Changer',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF6B4EFF), // Purple accent
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          fontFamily: 'Inter',
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF6B4EFF),
            foregroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
          ),
          cardTheme: CardTheme(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6B4EFF),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Color(0xFF6B4EFF),
            foregroundColor: Colors.white,
          ),
        ),
        routerConfig: _router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
