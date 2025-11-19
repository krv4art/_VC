#!/usr/bin/env python3
"""
Integration Guide for AI Photo Studio Pro - All New Features
"""

# 🚀 Руководство по интеграции новых функций

## Содержание

1. [Быстрый старт](#быстрый-старт)
2. [Обновление main.dart](#обновление-maindart)
3. [Обновление роутинга](#обновление-роутинга)
4. [Обновление database service](#обновление-database-service)
5. [Добавление провайдеров](#добавление-провайдеров)
6. [Firebase настройка](#firebase-настройка)
7. [Тестирование](#тестирование)

---

## Быстрый старт

### 1. Установите зависимости

```bash
cd ai_photo_studio_pro
flutter pub get
```

### 2. Добавьте API ключи

Отредактируйте `assets/config/.env`:

```bash
# Existing keys
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key
GEMINI_API_KEY=your_gemini_key

# New keys (опционально)
REMOVE_BG_API_KEY=your_remove_bg_key  # Для удаления фона
REPLICATE_API_KEY=your_replicate_key   # Для AI enhancement
```

### 3. Настройте Firebase

Следуйте инструкциям в [FIREBASE_SETUP.md](FIREBASE_SETUP.md)

---

## Обновление main.dart

Замените содержимое `lib/main.dart` следующим кодом:

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_core/firebase_core.dart';

// Providers
import 'providers/theme_mode_provider.dart';
import 'providers/theme_provider_v2.dart';
import 'providers/locale_provider.dart';
import 'providers/user_state.dart';
import 'providers/subscription_provider.dart';

// Services
import 'services/app_initialization_service.dart';
import 'services/local_photo_database_service.dart';
import 'services/tutorial_service.dart';

// Screens
import 'screens/tutorial_screen.dart';
import 'navigation/app_router.dart';
import 'theme/dark_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: 'assets/config/.env');

  // Initialize Firebase
  try {
    await Firebase.initializeApp();
    debugPrint('✅ Firebase initialized');
  } catch (e) {
    debugPrint('⚠️ Firebase initialization failed: $e');
  }

  // Initialize Supabase
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  // Initialize database
  final database = await LocalPhotoDatabaseService.instance.database;

  // Initialize all new services
  await AppInitializationService.initializeAllServices(database);

  // Track app open
  final sessionId = await AppInitializationService.trackAppOpen(database);

  // Check if should show tutorial
  final tutorialService = TutorialService();
  final showTutorial = !(await tutorialService.isTutorialCompleted());

  runApp(MyApp(
    database: database,
    sessionId: sessionId ?? 0,
    showTutorial: showTutorial,
  ));
}

class MyApp extends StatelessWidget {
  final Database database;
  final int sessionId;
  final bool showTutorial;

  const MyApp({
    Key? key,
    required this.database,
    required this.sessionId,
    required this.showTutorial,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Existing providers
        ChangeNotifierProvider(create: (_) => UserState()),
        ChangeNotifierProvider(create: (_) => SubscriptionProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProviderV2()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),

        // New providers
        ChangeNotifierProvider(
          create: (_) => ThemeModeProvider()..initialize(),
        ),

        // Database provider
        Provider<Database>.value(value: database),
      ],
      child: Consumer2<ThemeModeProvider, LocaleProvider>(
        builder: (context, themeProvider, localeProvider, _) {
          return MaterialApp(
            title: 'AI Photo Studio Pro',
            debugShowCheckedModeBanner: false,

            // Theme configuration
            theme: ThemeData.light(), // Your existing light theme
            darkTheme: DarkTheme.theme,
            themeMode: themeProvider.themeMode,

            // Localization
            locale: localeProvider.locale,
            supportedLocales: const [
              Locale('en', ''),
              Locale('ru', ''),
              Locale('uk', ''),
            ],

            // Routing
            onGenerateRoute: AppRouter.onGenerateRoute,
            initialRoute: showTutorial ? '/tutorial' : '/splash',
          );
        },
      ),
    );
  }

  // Clean up on app termination
  @override
  void dispose() {
    AppInitializationService.endCurrentSession(database, sessionId);
    super.dispose();
  }
}
```

---

## Обновление роутинга

Добавьте новые маршруты в `lib/navigation/app_router.dart`:

```dart
import 'package:flutter/material.dart';

// Import new screens
import '../screens/tutorial_screen.dart';
import '../screens/enhanced_photo_viewer_screen.dart';
import '../screens/analytics_dashboard_screen.dart';
import '../screens/referral_screen.dart';
import '../screens/achievements_screen.dart';
import '../screens/feedback_form_screen.dart';
import '../screens/photo_editor_screen.dart';
import '../screens/enhanced_settings_screen.dart';

class AppRouter {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      // Existing routes...
      // Add these new routes:

      case '/tutorial':
        return MaterialPageRoute(
          builder: (_) => const TutorialScreen(),
        );

      case '/analytics':
        return MaterialPageRoute(
          builder: (_) => const AnalyticsDashboardScreen(),
        );

      case '/referrals':
        return MaterialPageRoute(
          builder: (_) => const ReferralScreen(),
        );

      case '/achievements':
        return MaterialPageRoute(
          builder: (_) => const AchievementsScreen(),
        );

      case '/feedback':
        final isBugReport = settings.arguments as bool? ?? false;
        return MaterialPageRoute(
          builder: (_) => FeedbackFormScreen(isBugReport: isBugReport),
        );

      case '/photo-editor':
        final photo = settings.arguments as GeneratedPhoto;
        return MaterialPageRoute(
          builder: (_) => PhotoEditorScreen(photo: photo),
        );

      case '/photo-viewer':
        final photo = settings.arguments as GeneratedPhoto;
        return MaterialPageRoute(
          builder: (_) => EnhancedPhotoViewerScreen(photo: photo),
        );

      case '/settings':
        return MaterialPageRoute(
          builder: (_) => const EnhancedSettingsScreen(),
        );

      default:
        return null;
    }
  }
}
```

---

## Обновление database service

Обновите `lib/services/local_photo_database_service.dart` для инициализации новых таблиц:

```dart
import 'package:sqflite/sqflite.dart';
import '../services/gamification_service.dart';
import '../services/favorites_service.dart';
import '../services/referral_service.dart';
import '../services/analytics_service.dart';
import '../services/feedback_service.dart';

class LocalPhotoDatabaseService {
  // ... existing code ...

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'ai_photo_studio.db');

    return await openDatabase(
      path,
      version: 2, // Increment version
      onCreate: _createDb,
      onUpgrade: _upgradeDb,
    );
  }

  Future<void> _createDb(Database db, int version) async {
    // Existing table creation...
    // ... your existing code ...

    // Create new tables
    await GamificationService.createTables(db);
    await FavoritesService.createTable(db);
    await ReferralService.createTables(db);
    await AnalyticsService.createTables(db);
    await FeedbackService.createTables(db);
  }

  Future<void> _upgradeDb(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Add new tables for version 2
      await GamificationService.createTables(db);
      await FavoritesService.createTable(db);
      await ReferralService.createTables(db);
      await AnalyticsService.createTables(db);
      await FeedbackService.createTables(db);
    }
  }
}
```

---

## Добавление провайдеров

Провайдер темы уже добавлен в main.dart. Если нужно добавить больше:

```dart
MultiProvider(
  providers: [
    // ... existing providers ...

    ChangeNotifierProvider(
      create: (_) => ThemeModeProvider()..initialize(),
    ),

    // Add more if needed
    Provider<GamificationService>(
      create: (_) => GamificationService(database),
    ),
    Provider<FavoritesService>(
      create: (_) => FavoritesService(database),
    ),
  ],
  child: // ...
)
```

---

## Firebase настройка

1. Следуйте [FIREBASE_SETUP.md](FIREBASE_SETUP.md)
2. Добавьте файлы конфигурации:
   - `android/app/google-services.json`
   - `ios/Runner/GoogleService-Info.plist`

3. Добавьте в `.gitignore`:
```
google-services.json
GoogleService-Info.plist
firebase_app_id_file.json
```

---

## Использование новых функций

### 1. Social Sharing

```dart
import '../services/social_sharing_service.dart';

final sharingService = SocialSharingService();

// Share photo
await sharingService.sharePhoto(
  photoPath: '/path/to/photo.jpg',
  text: 'My AI photo!',
);

// Share to specific platform
await sharingService.shareToInstagram('/path/to/photo.jpg');
```

### 2. Save to Gallery

```dart
import '../services/gallery_saver_service.dart';

final gallerySaver = GallerySaverService();

await gallerySaver.saveToGallery(
  filePath: '/path/to/photo.jpg',
);
```

### 3. Photo Editing

```dart
import '../services/photo_editing_service.dart';

final editingService = PhotoEditingService();

// Crop
final cropped = await editingService.cropImage(
  imagePath: path,
  x: 0, y: 0, width: 500, height: 500,
);

// Adjust brightness
final adjusted = await editingService.adjustBrightness(
  imagePath: path,
  brightness: 50,
);
```

### 4. Gamification

```dart
import '../services/gamification_service.dart';

final gamificationService = GamificationService(database);

// Track photo generation
await gamificationService.trackPhotoGeneration();

// Add XP
await gamificationService.addXP(100, reason: 'completed task');

// Check achievements
final achievements = await gamificationService.getAllAchievements();
```

### 5. Analytics

```dart
import '../services/analytics_service.dart';

final analyticsService = AnalyticsService(database);

// Track events
await analyticsService.trackPhotoGeneration('style_id', 'Professional');
await analyticsService.trackPhotoShared('instagram');

// Get statistics
final stats = await analyticsService.getUserStatistics();
```

---

## Тестирование

### 1. Базовый тест

```bash
flutter run
```

### 2. Тест уведомлений

Откройте Firebase Console → Cloud Messaging → Send test message

### 3. Тест темной темы

Переключите в Settings → Appearance → Dark

### 4. Тест аналитики

Используйте приложение и проверьте Analytics Dashboard

### 5. Тест реферальной программы

Откройте Referrals screen и поделитесь кодом

---

## Troubleshooting

### Проблема: "Firebase not initialized"

**Решение:**
```dart
await Firebase.initializeApp();
```
должно быть вызвано перед runApp()

### Проблема: "Database table not found"

**Решение:**
Увеличьте версию БД и добавьте миграцию в onUpgrade

### Проблема: "Push notifications not working"

**Решение:**
- Проверьте Firebase конфигурацию
- На iOS используйте физическое устройство
- Проверьте permissions в AndroidManifest/Info.plist

---

## Дополнительные ресурсы

- [НОВЫЕ_ФУНКЦИИ.md](НОВЫЕ_ФУНКЦИИ.md) - Полный список функций
- [FIREBASE_SETUP.md](FIREBASE_SETUP.md) - Настройка Firebase
- [Flutter Documentation](https://docs.flutter.dev/)
- [Supabase Documentation](https://supabase.com/docs)

---

## Поддержка

Если возникли проблемы:
1. Проверьте логи: `flutter run --verbose`
2. Очистите проект: `flutter clean && flutter pub get`
3. Проверьте версии зависимостей: `flutter pub outdated`

---

**Успешной интеграции! 🚀**
