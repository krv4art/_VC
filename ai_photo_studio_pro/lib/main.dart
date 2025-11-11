import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/user_state.dart';
import 'providers/locale_provider.dart';
import 'providers/theme_provider_v2.dart';
import 'providers/subscription_provider.dart';
import 'providers/photo_generation_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:ai_photo_studio_pro/services/storage_service.dart';
import 'package:ai_photo_studio_pro/services/replicate_service.dart';
import 'package:ai_photo_studio_pro/services/local_photo_database_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'utils/supabase_constants.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'navigation/app_router.dart';
import 'config/app_config.dart';
import 'services/rating_service.dart';
import 'services/usage_tracking_service.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Инициализация фабрики баз данных для веба
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  }

  // Инициализация конфигурации приложения
  await AppConfig().initialize();

  // Инициализация сервиса оценки (важно для рейтинга приложения!)
  await RatingService().initialize();

  // Инициализация сервиса отслеживания использования
  await UsageTrackingService().initialize();

  // Initialize Supabase globally
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

  // Initialize RevenueCat (only on mobile platforms)
  if (!kIsWeb) {
    await Purchases.configure(
      // TODO: Replace with AI Photo Studio Pro RevenueCat API key
      PurchasesConfiguration("your_revenuecat_api_key_here"),
    );
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserState()),
        ChangeNotifierProvider(create: (context) => LocaleProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProviderV2()),
        ChangeNotifierProvider(
          create: (context) => SubscriptionProvider()..initialize(),
        ),
        Provider<StorageService>(create: (_) => StorageService()),
        // Photo generation services
        Provider<ReplicateService>(
          create: (context) => ReplicateService(
            useProxy: true,
            supabaseClient: Supabase.instance.client,
          ),
        ),
        Provider<LocalPhotoDatabase>(
          create: (context) => LocalPhotoDatabase(),
        ),
        ChangeNotifierProxyProvider2<ReplicateService, LocalPhotoDatabase,
            PhotoGenerationProvider>(
          create: (context) => PhotoGenerationProvider(
            replicateService: context.read<ReplicateService>(),
            databaseService: context.read<LocalPhotoDatabase>(),
          ),
          update: (context, replicateService, databaseService, previous) =>
              previous ??
              PhotoGenerationProvider(
                replicateService: replicateService,
                databaseService: databaseService,
              ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Sync SubscriptionProvider with UserState after initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userState = context.read<UserState>();
      final subscriptionProvider = context.read<SubscriptionProvider>();
      subscriptionProvider.setUserState(userState);
      // Recheck status for synchronization
      subscriptionProvider.checkStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    final themeProviderV2 = context.watch<ThemeProviderV2>();

    return MaterialApp.router(
      title: 'AI Photo Studio Pro',
      debugShowCheckedModeBanner: false,
      theme: themeProviderV2.themeData,
      themeMode: ThemeMode.light, // Always light theme (fixed theme, no customization)
      routerConfig: appRouter,
      locale: localeProvider.locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English
        Locale('ru', ''), // Russian
        Locale('uk', ''), // Ukrainian
      ],
    );
  }
}
