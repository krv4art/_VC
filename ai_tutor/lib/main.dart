import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'navigation/app_router.dart';
import 'providers/user_profile_provider.dart';
import 'providers/chat_provider.dart';
import 'providers/theme_provider.dart';
import 'services/ai_tutor_service.dart';
import 'config/app_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize app configuration
  await AppConfig().initialize();

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

        // AI Tutor Service
        Provider<AITutorService>(
          create: (_) => AITutorService(
            supabase: Supabase.instance.client,
          ),
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

          return MaterialApp.router(
            title: 'AI Tutor',
            debugShowCheckedModeBanner: false,
            theme: themeProvider.themeData,
            routerConfig: appRouter,
          );
        },
      ),
    );
  }
}
