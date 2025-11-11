import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/user_state.dart';
import 'providers/auth_provider.dart';
import 'providers/locale_provider.dart';
import 'providers/theme_provider_v2.dart';
import 'providers/ai_bot_provider.dart';
import 'providers/subscription_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:bug_identifier/services/gemini_service.dart';
import 'package:bug_identifier/services/storage_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'utils/supabase_constants.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'navigation/app_router.dart';
import 'config/app_config.dart';
import 'config/prompts_manager.dart';
import 'services/rating_service.dart';
import 'services/usage_tracking_service.dart';
import 'providers/chat_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Инициализация фабрики баз данных для веба
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  }

  // Инициализация конфигурации приложения
  await AppConfig().initialize();

  // Инициализация менеджера промптов
  await PromptsManager.initialize();

  // Инициализация сервиса оценки
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

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserState()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => LocaleProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProviderV2()),
        ChangeNotifierProvider(create: (context) => AiBotProvider()),
        ChangeNotifierProvider(
          create: (context) => SubscriptionProvider()..initialize(),
        ),
        ChangeNotifierProvider(create: (context) => ChatProvider()),
        // Add GeminiService provider here
        Provider<GeminiService>(
          create: (context) => GeminiService(
            useProxy: true,
            supabaseClient: Supabase.instance.client,
          ),
        ),
        Provider<StorageService>(create: (_) => StorageService()),
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
    // Синхронизируем SubscriptionProvider с UserState после инициализации
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userState = context.read<UserState>();
      final subscriptionProvider = context.read<SubscriptionProvider>();
      subscriptionProvider.setUserState(userState);
      // Повторно проверяем статус для синхронизации
      subscriptionProvider.checkStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    final themeProviderV2 = context.watch<ThemeProviderV2>();

    return MaterialApp.router(
      title: 'Bug Identifier',
      debugShowCheckedModeBanner: false,
      theme: themeProviderV2.themeData,
      themeMode: ThemeMode.light, // Всегда используем theme (тема внутри)
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
