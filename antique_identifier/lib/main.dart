import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'services/supabase_service.dart';
import 'screens/home_screen.dart';
import 'screens/scan_screen.dart';
import 'screens/results_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/history_screen.dart';
import 'providers/analysis_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseService().initialize();
  runApp(const AntiqueIdentifierApp());
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

/// Custom page transition builder for smooth slide animations
Page<dynamic> _buildSlideTransition(BuildContext context, GoRouterState state, Widget child) {
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
Page<dynamic> _buildFadeTransition(BuildContext context, GoRouterState state, Widget child) {
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
      pageBuilder: (context, state) => _buildFadeTransition(context, state, const HomeScreen()),
    ),
    GoRoute(
      path: '/scan',
      name: 'scan',
      pageBuilder: (context, state) => _buildSlideTransition(context, state, const ScanScreen()),
    ),
    GoRoute(
      path: '/results',
      name: 'results',
      pageBuilder: (context, state) {
        final resultId = state.queryParameters['id'];
        return _buildSlideTransition(context, state, ResultsScreen(resultId: resultId));
      },
    ),
    GoRoute(
      path: '/chat',
      name: 'chat',
      pageBuilder: (context, state) {
        final dialogueId = state.queryParameters['dialogueId'];
        return _buildSlideTransition(context, state, ChatScreen(dialogueId: dialogueId));
      },
    ),
    GoRoute(
      path: '/history',
      name: 'history',
      pageBuilder: (context, state) => _buildSlideTransition(context, state, const HistoryScreen()),
    ),
  ],
);

class AntiqueIdentifierApp extends StatelessWidget {
  const AntiqueIdentifierApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AnalysisProvider()),
      ],
      child: MaterialApp.router(
        title: 'Antique Identifier',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
          useMaterial3: true,
          fontFamily: 'Lora',
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.amber.shade700,
            foregroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
          ),
        ),
        routerConfig: _router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
