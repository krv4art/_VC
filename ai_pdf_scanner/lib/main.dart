import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'config/api_config.dart';
import 'navigation/app_router.dart';
import 'providers/app_state_provider.dart';
import 'providers/document_provider.dart';
import 'providers/scan_provider.dart';
import 'theme/app_theme.dart';

/// Main entry point for AI PDF Scanner application
Future<void> main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // Initialize Supabase
  await Supabase.initialize(
    url: ApiConfig.supabaseUrl,
    anonKey: ApiConfig.supabaseAnonKey,
  );

  // Run the app
  runApp(const MyApp());
}

/// Root application widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // App state provider (theme, settings)
        ChangeNotifierProvider(create: (_) => AppStateProvider()..loadSettings()),

        // Document provider (PDF management)
        ChangeNotifierProvider(create: (_) => DocumentProvider()..loadDocuments()),

        // Scan provider (scanning state)
        ChangeNotifierProvider(create: (_) => ScanProvider()),

        // TODO: Add more providers as needed
        // - EditorProvider (editing state)
        // - AIProvider (AI analysis state)
      ],
      child: Consumer<AppStateProvider>(
        builder: (context, appState, _) {
          return MaterialApp.router(
            title: 'AI PDF Scanner',
            debugShowCheckedModeBanner: false,

            // Theme configuration
            theme: AppTheme.getThemeData(appState.colors, false),
            darkTheme: AppTheme.getThemeData(appState.colors, true),
            themeMode: appState.isDarkMode ? ThemeMode.dark : ThemeMode.light,

            // Navigation
            routerConfig: AppRouter.router,

            // Localization (will be set up later)
            // localizationsDelegates: AppLocalizations.localizationsDelegates,
            // supportedLocales: AppLocalizations.supportedLocales,
          );
        },
      ),
    );
  }
}
