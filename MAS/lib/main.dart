import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'navigation/app_router.dart';
import 'theme/app_theme.dart';
import 'services/math_ai_service.dart';
import 'config/app_config.dart';
import 'services/rating_service.dart';
import 'services/usage_tracking_service.dart';
import 'providers/locale_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize app configuration
  await AppConfig().initialize();

  // Initialize rating service
  await RatingService().initialize();

  // Initialize usage tracking service
  await UsageTrackingService().initialize();

  // Load environment variables
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint('⚠️ Warning: .env file not found. Using default values.');
  }

  // Initialize Supabase
  try {
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL'] ?? '',
      anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
    );
    debugPrint('✅ Supabase initialized');
  } catch (e) {
    debugPrint('❌ Supabase initialization failed: $e');
  }

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MASApp());
}

class MASApp extends StatelessWidget {
  const MASApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Locale Provider (for runtime language switching)
        ChangeNotifierProvider<LocaleProvider>(
          create: (_) => LocaleProvider(),
        ),

        // AI Service
        Provider<MathAIService>(
          create: (_) => MathAIService(
            supabaseClient: Supabase.instance.client,
          ),
        ),
        // Add more providers here as needed
      ],
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, child) {
          return MaterialApp.router(
            title: 'MAS - Math AI Solver',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.system,
            locale: localeProvider.locale,
            supportedLocales: const [
              Locale('en'), Locale('ru'), Locale('uk'), Locale('es'),
              Locale('de'), Locale('fr'), Locale('it'), Locale('ar'),
              Locale('ko'), Locale('cs'), Locale('da'), Locale('el'),
              Locale('fi'), Locale('hi'), Locale('hu'), Locale('id'),
              Locale('ja'), Locale('nl'), Locale('no'), Locale('pl'),
              Locale('pt'), Locale('ro'), Locale('sv'), Locale('th'),
              Locale('tr'), Locale('vi'), Locale('zh'),
            ],
            routerConfig: appRouter,
          );
        },
      ),
    );
  }
}
