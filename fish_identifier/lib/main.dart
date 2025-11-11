import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'providers/theme_provider.dart';
import 'providers/locale_provider.dart';
import 'providers/identification_provider.dart';
import 'providers/collection_provider.dart';
import 'providers/premium_provider.dart';
import 'providers/fishing_spots_provider.dart';
import 'navigation/app_router.dart';
import 'flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://yerbryysrnaraqmbhqdm.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InllcmJyeXlzcm5hcmFxbWJoZWRtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzU5MjQ5NjIsImV4cCI6MjA1MTUwMDk2Mn0.dummy',
  );

  runApp(const FishIdentifierApp());
}

class FishIdentifierApp extends StatelessWidget {
  const FishIdentifierApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => IdentificationProvider()),
        ChangeNotifierProvider(create: (_) => CollectionProvider()),
        ChangeNotifierProvider(create: (_) => PremiumProvider()),
        ChangeNotifierProvider(create: (_) => FishingSpotsProvider()),
      ],
      child: Consumer2<ThemeProvider, LocaleProvider>(
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
