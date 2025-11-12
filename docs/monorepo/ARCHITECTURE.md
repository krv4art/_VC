# Monorepo Architecture

## Overview

This monorepo houses multiple Flutter applications that share a common architecture pattern derived from the AI Cosmetic Scanner (ACS) application. Each app is a standalone Flutter project but follows consistent patterns for code organization, state management, and feature implementation.

## Applications

### 1. ACS (AI Cosmetic Scanner)
**Purpose:** AI-powered cosmetic ingredient analyzer  
**Status:** Production  
**Key Features:** Label scanning, ingredient analysis, safety scoring, AI chat

### 2. Bug Identifier
**Purpose:** AI-powered insect recognition  
**Status:** Production  
**Key Features:** Insect ID, taxonomy details, nature themes, entomology data

### 3. Plant Identifier
**Purpose:** Plant and mushroom identification with care guidance  
**Status:** Production  
**Key Features:** Plant recognition, care guides, personalization, botanical themes

### 4. MAS (Math AI Solver)
**Purpose:** Photo-based equation solver  
**Status:** Production  
**Key Features:** Math problem solving, solution checking, training problems, unit converter

### 5. Unseen
**Purpose:** Privacy-first notification listener  
**Status:** Production  
**Key Features:** Message capture without read receipts, local storage, premium tiers

## Shared Architecture Pattern

All applications follow this directory structure:

```
app_name/
├── lib/
│   ├── main.dart              # App entry point with MultiProvider setup
│   ├── models/                # Data models and DTOs
│   ├── services/              # Business logic and API integration
│   │   ├── database_service.dart
│   │   ├── api_service.dart
│   │   ├── storage_service.dart
│   │   └── ...
│   ├── providers/             # State management (Provider pattern)
│   │   ├── theme_provider.dart
│   │   ├── app_state_provider.dart
│   │   └── ...
│   ├── screens/               # UI screens/pages
│   │   ├── home/
│   │   ├── scan/
│   │   ├── history/
│   │   └── settings/
│   ├── widgets/               # Reusable UI components
│   │   ├── common/
│   │   ├── animated/
│   │   └── ...
│   ├── theme/                 # Theme and styling
│   │   ├── app_theme.dart
│   │   ├── app_colors.dart
│   │   ├── custom_colors.dart
│   │   └── theme_extensions_v2.dart
│   ├── navigation/            # Routing configuration
│   │   └── app_router.dart
│   ├── config/                # App configuration
│   │   ├── constants.dart
│   │   └── environment.dart
│   └── l10n/                  # Localization files
│       ├── app_en.arb
│       ├── app_ru.arb
│       └── ...
├── android/                   # Android platform code
├── ios/                       # iOS platform code
├── web/                       # Web platform code
├── macos/                     # macOS platform code
├── linux/                     # Linux platform code
├── windows/                   # Windows platform code
├── pubspec.yaml              # Dependencies
├── README.md                 # App-specific documentation
└── docs/                     # Additional documentation
```

## Technology Stack

### Core Framework
- **Flutter SDK:** 3.x
- **Dart SDK:** 3.x
- **Target Platforms:** Android, iOS, Web, Desktop (macOS, Linux, Windows)

### State Management
- **Provider** - Chosen for simplicity and Flutter team recommendation
- **MultiProvider** - Used in main.dart to provide multiple state objects
- **ChangeNotifier** - Base class for all providers

### Navigation
- **go_router** - Declarative routing with deep linking support
- **Route Guards** - Authentication and permission checks
- **Nested Navigation** - Bottom navigation with nested routes

### Local Storage
- **sqflite** - SQLite database for mobile
- **sqflite_common_ffi** - SQLite for desktop platforms
- **sqflite_common_ffi_web** - SQLite for web (IndexedDB backed)
- **shared_preferences** - Simple key-value storage

### Backend & AI
- **Supabase** - Backend as a service
  - Authentication (where needed)
  - Edge Functions for AI processing
  - Real-time subscriptions (where needed)
- **Google Gemini API** - AI model for analysis
  - Gemini 2.0 Flash via Supabase Edge Functions
  - Vision capabilities for image analysis
  - Multi-turn conversations

### Subscriptions & Monetization
- **RevenueCat** - Cross-platform subscription management
- **In-app Purchases** - iOS/Android native integration
- **Subscription Tiers** - Free, Premium, Expert (varies by app)

### Localization
- **flutter_localizations** - Flutter's built-in i18n
- **intl** - Internationalization utilities
- **ARB files** - Translation source files
- **30+ languages** - Broad international support

## Design Patterns

### Service Layer Pattern
Services handle business logic and external API communication:
```dart
class DatabaseService {
  Future<List<Item>> getItems() async { ... }
  Future<void> saveItem(Item item) async { ... }
}
```

### Repository Pattern
Optional layer for data abstraction (used in some apps):
```dart
class ItemRepository {
  final DatabaseService _db;
  final ApiService _api;
  
  Future<List<Item>> fetchItems() async { ... }
}
```

### Provider Pattern
State management with ChangeNotifier:
```dart
class AppStateProvider extends ChangeNotifier {
  bool _isLoading = false;
  
  bool get isLoading => _isLoading;
  
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
```

### Dependency Injection
Services injected via Provider:
```dart
MultiProvider(
  providers: [
    Provider<DatabaseService>(create: (_) => DatabaseService()),
    ChangeNotifierProvider<AppStateProvider>(
      create: (context) => AppStateProvider(
        context.read<DatabaseService>(),
      ),
    ),
  ],
  child: MyApp(),
)
```

## Code Organization Principles

### 1. Separation of Concerns
- **Models** - Data structures only
- **Services** - Business logic, no UI
- **Providers** - State management, minimal logic
- **Widgets** - UI only, delegates to providers
- **Screens** - Compose widgets, minimal logic

### 2. Single Responsibility
Each file/class has one clear purpose

### 3. DRY (Don't Repeat Yourself)
Shared widgets in `widgets/` directory, reusable across screens

### 4. Testability
- Services are mockable
- Providers are testable independently
- Widgets use dependency injection

### 5. Scalability
- Modular structure allows easy feature addition
- Services can be swapped (e.g., different database)
- Themes are customizable

## Theme System

### Structure
```dart
theme/
├── app_theme.dart              # Main theme configuration
├── app_colors.dart             # Color palette definitions
├── custom_colors.dart          # Custom color scheme
└── theme_extensions_v2.dart    # BuildContext extensions
```

### Usage
```dart
// Access theme colors
context.colors.primary
context.colors.background
context.colors.surface

// Access text styles
Theme.of(context).textTheme.headlineMedium
```

### Theme Presets
Most apps include multiple theme presets:
- Natural/Light
- Dark
- Ocean
- Forest
- Sunset
- Vibrant
- Custom (user-defined)

## Localization

### ARB Files
Source of truth for translations:
```json
{
  "appTitle": "My App",
  "@appTitle": {
    "description": "The title of the application"
  }
}
```

### Code Generation
Flutter generates type-safe accessors:
```dart
AppLocalizations.of(context)!.appTitle
```

### Supported Languages
- Western European: en, es, de, fr, it, pt
- Eastern European: ru, uk, pl, cs, ro, hu
- Scandinavian: sv, no, da, fi
- Middle Eastern: ar, tr, el
- Asian: ja, ko, zh-CN, zh-TW, hi, th, vi, id

## Database Schema

### Common Tables (varies by app)
```sql
-- Scan/Analysis history
CREATE TABLE scans (
  id INTEGER PRIMARY KEY,
  image_path TEXT,
  result TEXT,
  score REAL,
  created_at INTEGER
);

-- User profiles
CREATE TABLE profiles (
  id INTEGER PRIMARY KEY,
  name TEXT,
  preferences TEXT,
  created_at INTEGER
);

-- Settings
CREATE TABLE settings (
  key TEXT PRIMARY KEY,
  value TEXT
);
```

## API Integration

### Supabase Edge Functions
```typescript
// Example: Gemini analysis function
serve(async (req) => {
  const { image, prompt } = await req.json();
  
  const response = await gemini.generateContent({
    contents: [{
      role: 'user',
      parts: [
        { text: prompt },
        { inlineData: { mimeType: 'image/jpeg', data: image } }
      ]
    }]
  });
  
  return new Response(JSON.stringify(response), {
    headers: { 'Content-Type': 'application/json' }
  });
});
```

### Flutter Client
```dart
class ApiService {
  final SupabaseClient _client;
  
  Future<AnalysisResult> analyze(File image) async {
    final bytes = await image.readAsBytes();
    final base64 = base64Encode(bytes);
    
    final response = await _client.functions.invoke(
      'analyze',
      body: {'image': base64, 'prompt': _getPrompt()},
    );
    
    return AnalysisResult.fromJson(response.data);
  }
}
```

## Platform-Specific Code

### Android
- Manifest configuration for permissions
- Native splash screen
- Multi-window support
- Edge-to-edge display

### iOS
- Info.plist configuration
- Camera/photo library permissions
- App Transport Security
- Launch screen

### Web
- HTML entry point
- Service worker for PWA
- IndexedDB for storage
- Responsive design

### Desktop (macOS/Linux/Windows)
- Window management
- File system access
- Native menus
- Platform-specific UI adaptations

## Security Considerations

### API Keys
- Stored in environment variables
- Not committed to version control
- Supabase Row Level Security (RLS) for data access

### User Data
- Local storage only (most apps)
- No server-side user tracking
- Privacy-first approach (especially Unseen app)

### Permissions
- Request only necessary permissions
- Runtime permission handling
- Graceful degradation when denied

## Performance Optimization

### Image Handling
- Compress before upload
- Cache loaded images
- Lazy loading for lists

### Database
- Indexed queries
- Batch operations
- Connection pooling

### UI
- Const constructors where possible
- ListView.builder for long lists
- Efficient state updates (specific notifyListeners)

## Testing Strategy

### Unit Tests
- Service layer logic
- Model serialization
- Utility functions

### Widget Tests
- Individual widget behavior
- User interactions
- UI state changes

### Integration Tests
- End-to-end workflows
- Database operations
- API interactions

## Continuous Integration

Each app can be built independently:
```bash
cd app_name
flutter test
flutter build apk --release
flutter build ios --release
flutter build web --release
```

## Future Improvements

### Potential Enhancements
1. **Shared Package** - Extract common code into shared package
2. **Automated Testing** - CI/CD pipeline for all apps
3. **Code Generation** - Generate boilerplate code
4. **Documentation** - Auto-generate API documentation
5. **Monitoring** - Centralized error tracking and analytics

### Considerations
- Balance between sharing code and app independence
- Maintain flexibility for app-specific customizations
- Keep dependencies up to date across all apps

---

**Last Updated:** 2025-01-11  
**Maintained By:** Development Team
