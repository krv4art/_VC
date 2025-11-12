import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';

// Providers
import 'providers/theme_provider.dart';
import 'providers/locale_provider.dart';
import 'providers/user_preferences_provider.dart';
import 'providers/plant_history_provider.dart';
import 'providers/chat_provider.dart';

// Services
import 'services/plant_identification_service.dart';

// Config
import 'config/app_config.dart';
import 'utils/supabase_constants.dart';

// Navigation
import 'navigation/app_router.dart';

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
    url: SupabaseConfig.getSupabaseUrl(),
    anonKey: SupabaseConfig.getSupabaseAnonKey(),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => UserPreferencesProvider()),
        ChangeNotifierProvider(create: (_) => PlantHistoryProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        Provider<PlantIdentificationService>(
          create: (_) => PlantIdentificationService(
            supabaseClient: Supabase.instance.client,
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final localeProvider = context.watch<LocaleProvider>();

    return MaterialApp.router(
      title: 'Plant Identifier',
      debugShowCheckedModeBanner: false,
      theme: themeProvider.themeData,
      routerConfig: appRouter,
      locale: localeProvider.locale,
      supportedLocales: localeProvider.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
