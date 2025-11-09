import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Providers
import 'providers/messages_provider.dart';
import 'providers/locale_provider.dart';
import 'providers/theme_provider_v2.dart';
import 'providers/subscription_provider.dart';
import 'providers/user_state.dart';

// Services
import 'services/rating_service.dart';
import 'services/usage_tracking_service.dart';

// Screens
import 'screens/home_screen.dart';
import 'screens/onboarding_screen.dart';

// Localization
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize database factory for web
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  }

  // Initialize rating service
  await RatingService().initialize();

  // Initialize usage tracking service
  await UsageTrackingService().initialize();

  // Initialize RevenueCat (only on mobile platforms)
  if (!kIsWeb) {
    await Purchases.configure(
      PurchasesConfiguration("goog_UKfcCZSMJPjqYxRVOMbiPXbkRoS"),
    );
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MessagesProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProviderV2()),
        ChangeNotifierProvider(create: (_) => UserState()),
        ChangeNotifierProvider(
          create: (_) => SubscriptionProvider()..initialize(),
        ),
      ],
      child: const UnseenApp(),
    ),
  );
}

class UnseenApp extends StatefulWidget {
  const UnseenApp({super.key});

  @override
  State<UnseenApp> createState() => _UnseenAppState();
}

class _UnseenAppState extends State<UnseenApp> {
  bool _onboardingCompleted = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();

    // Initialize messages provider after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final messagesProvider = context.read<MessagesProvider>();
      messagesProvider.initialize();

      // Sync subscription provider with user state
      final userState = context.read<UserState>();
      final subscriptionProvider = context.read<SubscriptionProvider>();
      subscriptionProvider.setUserState(userState);
      subscriptionProvider.checkStatus();
    });
  }

  Future<void> _checkOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _onboardingCompleted = prefs.getBool('onboarding_completed') ?? false;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    final themeProviderV2 = context.watch<ThemeProviderV2>();

    if (_isLoading) {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return MaterialApp(
      title: 'Unseen - Private Messaging',
      debugShowCheckedModeBanner: false,
      theme: themeProviderV2.themeData,
      themeMode: ThemeMode.light,
      home: _onboardingCompleted ? HomeScreen() : const OnboardingScreen(),
      locale: localeProvider.locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', ''), // Arabic
        Locale('cs', ''), // Czech
        Locale('da', ''), // Danish
        Locale('de', ''), // German
        Locale('el', ''), // Greek
        Locale('en', ''), // English
        Locale('es', ''), // Spanish
        Locale('fi', ''), // Finnish
        Locale('fr', ''), // French
        Locale('hi', ''), // Hindi
        Locale('hu', ''), // Hungarian
        Locale('id', ''), // Indonesian
        Locale('it', ''), // Italian
        Locale('ja', ''), // Japanese
        Locale('ko', ''), // Korean
        Locale('nl', ''), // Dutch
        Locale('no', ''), // Norwegian
        Locale('pl', ''), // Polish
        Locale('pt', ''), // Portuguese
        Locale('ro', ''), // Romanian
        Locale('ru', ''), // Russian
        Locale('sv', ''), // Swedish
        Locale('th', ''), // Thai
        Locale('tr', ''), // Turkish
        Locale('uk', ''), // Ukrainian
        Locale('vi', ''), // Vietnamese
        Locale('zh', ''), // Chinese
      ],
      routes: {
        '/': (context) => HomeScreen(),
      },
    );
  }
}
