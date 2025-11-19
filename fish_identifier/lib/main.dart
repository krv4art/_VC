import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'providers/theme_provider_v2.dart';
import 'providers/locale_provider.dart';
import 'providers/identification_provider.dart';
import 'providers/collection_provider.dart';
import 'providers/premium_provider.dart';
import 'providers/fishing_spots_provider.dart';
import 'providers/forecast_provider.dart';
import 'providers/regulations_provider.dart';
import 'providers/statistics_provider.dart';
import 'navigation/app_router.dart';
import 'flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize Supabase with environment variables
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(const FishIdentifierApp());
}

class FishIdentifierApp extends StatelessWidget {
  const FishIdentifierApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProviderV2()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => IdentificationProvider()),
        ChangeNotifierProvider(create: (_) => CollectionProvider()),
        ChangeNotifierProvider(create: (_) => PremiumProvider()),
        ChangeNotifierProvider(create: (_) => FishingSpotsProvider()),
        // NEW PROVIDERS FOR ENHANCED FEATURES
        ChangeNotifierProvider(create: (_) => ForecastProvider()),
        ChangeNotifierProvider(create: (_) => RegulationsProvider()),
        ChangeNotifierProvider(create: (_) => StatisticsProvider()),
      ],
      child: Consumer2<ThemeProviderV2, LocaleProvider>(
        builder: (context, themeProvider, localeProvider, child) {
          return MaterialApp.router(
            title: 'Fish Identifier',
            debugShowCheckedModeBanner: false,

            // Theme
            theme: themeProvider.themeData,

            // Localization
            locale: localeProvider.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: LocaleProvider.supportedLocales,

            // Routing
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
