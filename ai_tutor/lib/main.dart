import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'navigation/app_router.dart';
import 'providers/user_profile_provider.dart';
import 'providers/chat_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/progress_provider.dart';
import 'providers/achievement_provider.dart';
import 'providers/challenge_provider.dart';
import 'providers/brain_training_provider.dart';
import 'services/ai_tutor_service.dart';
import 'services/practice_service.dart';
import 'services/notification_service.dart';
import 'config/app_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize app configuration
  await AppConfig().initialize();

  // Initialize notification service
  await NotificationService().initialize();

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

  runApp(const AITutorApp());
}

class AITutorApp extends StatelessWidget {
  const AITutorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // User Profile Provider
        ChangeNotifierProvider<UserProfileProvider>(
          create: (_) {
            final provider = UserProfileProvider();
            provider.initialize();
            return provider;
          },
        ),

        // Theme Provider
        ChangeNotifierProvider<ThemeProvider>(
          create: (_) => ThemeProvider(),
        ),

        // Chat Provider
        ChangeNotifierProvider<ChatProvider>(
          create: (_) => ChatProvider(),
        ),

        // Progress Provider
        ChangeNotifierProvider<ProgressProvider>(
          create: (context) {
            final provider = ProgressProvider();
            final userId = context.read<UserProfileProvider>().profile.userId;
            if (userId != null) {
              provider.initialize(userId);
            }
            return provider;
          },
        ),

        // Achievement Provider
        ChangeNotifierProvider<AchievementProvider>(
          create: (_) {
            final provider = AchievementProvider();
            provider.initialize();
            return provider;
          },
        ),

        // Challenge Provider
        ChangeNotifierProvider<ChallengeProvider>(
          create: (_) {
            final provider = ChallengeProvider();
            provider.initialize();
            return provider;
          },
        ),

        // Brain Training Provider
        ChangeNotifierProvider<BrainTrainingProvider>(
          create: (_) => BrainTrainingProvider(),
        ),

        // AI Tutor Service
        Provider<AITutorService>(
          create: (_) => AITutorService(
            supabase: Supabase.instance.client,
          ),
        ),

        // Practice Service
        Provider<PracticeService>(
          create: (_) => PracticeService(
            supabase: Supabase.instance.client,
          ),
        ),

        // Notification Service
        Provider<NotificationService>(
          create: (_) => NotificationService(),
        ),
      ],
      child: Consumer2<ThemeProvider, UserProfileProvider>(
        builder: (context, themeProvider, profileProvider, child) {
          // Update theme when user profile changes
          if (profileProvider.profile.isOnboardingComplete) {
            final culturalTheme = profileProvider.culturalTheme;
            if (themeProvider.currentTheme.id != culturalTheme.id) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                themeProvider.setTheme(culturalTheme);
              });
            }
          }

          // Get locale from user profile
          Locale locale = const Locale('en');
          if (profileProvider.profile.preferredLanguage == 'ru') {
            locale = const Locale('ru');
          }

          return MaterialApp.router(
            title: 'AI Tutor',
            debugShowCheckedModeBanner: false,

            // Localization
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'), // English
              Locale('ru'), // Russian
            ],
            locale: locale,

            // Theme
            theme: themeProvider.themeData,

            // Router
            routerConfig: appRouter,
          );
        },
      ),
    );
  }
}
