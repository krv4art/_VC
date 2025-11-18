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

final GoRouter _router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      pageBuilder: (context, state) => const MaterialPage(
        child: HomeScreen(),
      ),
    ),
    GoRoute(
      path: '/scan',
      name: 'scan',
      pageBuilder: (context, state) => const MaterialPage(
        child: ScanScreen(),
      ),
    ),
    GoRoute(
      path: '/results',
      name: 'results',
      pageBuilder: (context, state) {
        final resultId = state.queryParameters['id'];
        return MaterialPage(
          child: ResultsScreen(resultId: resultId),
        );
      },
    ),
    GoRoute(
      path: '/chat',
      name: 'chat',
      pageBuilder: (context, state) {
        final dialogueId = state.queryParameters['dialogueId'];
        return MaterialPage(
          child: ChatScreen(dialogueId: dialogueId),
        );
      },
    ),
    GoRoute(
      path: '/history',
      name: 'history',
      pageBuilder: (context, state) => const MaterialPage(
        child: HistoryScreen(),
      ),
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
