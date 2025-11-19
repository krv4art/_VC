import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/user_state.dart';
import 'providers/locale_provider.dart';
import 'providers/theme_provider_v2.dart';
import 'providers/subscription_provider.dart';
import 'providers/photo_generation_provider.dart';
import 'providers/enhanced_photo_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:ai_photo_studio_pro/services/storage_service.dart';
import 'package:ai_photo_studio_pro/services/replicate_service.dart';
import 'package:ai_photo_studio_pro/services/local_photo_database_service.dart';
import 'package:ai_photo_studio_pro/services/ai_retouch_service.dart';
import 'package:ai_photo_studio_pro/services/background_removal_service.dart';
import 'package:ai_photo_studio_pro/services/batch_generation_service.dart';
import 'package:ai_photo_studio_pro/services/image_upscaling_service.dart';
import 'package:ai_photo_studio_pro/services/ai_image_expansion_service.dart';
import 'package:ai_photo_studio_pro/services/ai_outfit_change_service.dart';
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

        // Enhanced AI services
        Provider<AIRetouchService>(
          create: (context) => AIRetouchService(
            supabaseClient: Supabase.instance.client,
          ),
        ),
        Provider<BackgroundRemovalService>(
          create: (context) => BackgroundRemovalService(
            supabaseClient: Supabase.instance.client,
          ),
        ),
        Provider<ImageUpscalingService>(
          create: (context) => ImageUpscalingService(
            supabaseClient: Supabase.instance.client,
          ),
        ),
        Provider<AIImageExpansionService>(
          create: (context) => AIImageExpansionService(
            supabaseClient: Supabase.instance.client,
          ),
        ),
        Provider<AIOutfitChangeService>(
          create: (context) => AIOutfitChangeService(
            supabaseClient: Supabase.instance.client,
          ),
        ),

        // Batch generation service
        ProxyProvider6<ReplicateService, LocalPhotoDatabase, AIRetouchService,
            BackgroundRemovalService, ImageUpscalingService, AIImageExpansionService,
            BatchGenerationService>(
          update: (context, replicateService, databaseService, retouchService,
              backgroundService, upscalingService, expansionService, previous) =>
            BatchGenerationService(
              replicateService: replicateService,
              databaseService: databaseService,
              retouchService: retouchService,
              backgroundService: backgroundService,
              upscalingService: upscalingService,
              expansionService: expansionService,
              supabaseClient: Supabase.instance.client,
            ),
        ),

        // Photo generation provider
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

        // Enhanced photo provider
        ChangeNotifierProxyProvider6<AIRetouchService, BackgroundRemovalService,
            BatchGenerationService, ImageUpscalingService, AIImageExpansionService,
            AIOutfitChangeService, EnhancedPhotoProvider>(
          create: (context) => EnhancedPhotoProvider(
            retouchService: context.read<AIRetouchService>(),
            backgroundService: context.read<BackgroundRemovalService>(),
            batchService: context.read<BatchGenerationService>(),
            upscalingService: context.read<ImageUpscalingService>(),
            expansionService: context.read<AIImageExpansionService>(),
            outfitService: context.read<AIOutfitChangeService>(),
          ),
          update: (context, retouchService, backgroundService, batchService,
              upscalingService, expansionService, outfitService, previous) =>
            previous ??
            EnhancedPhotoProvider(
              retouchService: retouchService,
              backgroundService: backgroundService,
              batchService: batchService,
              upscalingService: upscalingService,
              expansionService: expansionService,
              outfitService: outfitService,
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
