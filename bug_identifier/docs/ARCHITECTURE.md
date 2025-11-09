# Architecture Documentation

## Overview

AI Cosmetic Scanner follows a **layered architecture** with clear separation of concerns, making the codebase maintainable, testable, and scalable.

## Architecture Layers

```
┌─────────────────────────────────────┐
│         Presentation Layer          │
│    (Screens, Widgets, Theme)        │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│       State Management Layer        │
│      (Providers, State Models)      │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│        Business Logic Layer         │
│           (Services)                │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│          Data Layer                 │
│   (Models, Local DB, External API)  │
└─────────────────────────────────────┘
```

## Directory Structure

```
lib/
├── l10n/                      # Internationalization
│   ├── app_en.arb            # English translations
│   ├── app_ru.arb            # Russian translations
│   ├── app_uk.arb            # Ukrainian translations
│   ├── app_es.arb            # Spanish translations
│   └── app_localizations.dart # Generated
│
├── models/                    # Data Models
│   ├── analysis_result.dart  # AI analysis response
│   ├── scan_result.dart      # Scan history item
│   ├── chat_message.dart     # Chat message
│   └── user_preferences.dart # User settings
│
├── exceptions/                # Custom Exceptions
│   └── api_exceptions.dart   # API error exceptions
│
├── providers/                 # State Management
│   ├── user_state.dart       # User profile state
│   └── locale_provider.dart  # Language state
│
├── screens/                   # UI Screens
│   ├── homepage_screen.dart  # Home/Dashboard
│   ├── scanning_screen.dart  # Camera/Gallery scan
│   ├── analysis_screen.dart  # Results display
│   ├── chat_ai_screen.dart   # AI chat interface
│   ├── dialogues_screen.dart # Chat history
│   ├── history_screen.dart   # Scan history
│   ├── profile_screen.dart   # User profile
│   ├── skin_type_screen.dart # Skin type selection
│   ├── allergies_screen.dart # Allergy management
│   ├── language_screen.dart  # Language settings
│   └── subscription_screen.dart # Premium features
│
├── services/                  # Business Logic
│   ├── camera/               # Camera-related services
│   │   └── camera_manager.dart # Camera lifecycle management
│   ├── scanning/             # Scanning-related services
│   │   ├── scanning_animation_controller.dart # 9 animations
│   │   ├── image_analysis_service.dart # Image processing
│   │   └── prompt_builder_service.dart # AI prompt generation
│   ├── gemini_service.dart   # Gemini AI integration
│   ├── local_data_service.dart # SQLite operations
│   ├── chat_context_service.dart # Chat context builder
│   ├── rating_service.dart   # Rating dialog logic
│   ├── usage_tracking_service.dart # Usage limits tracking
│   └── subscription_service.dart # RevenueCat integration
│
├── theme/                     # Design System
│   └── app_theme.dart        # Colors, typography, etc.
│
├── constants/                 # App Constants
│   └── app_dimensions.dart   # 8px design system values
│
├── widgets/                   # Reusable Components
│   ├── camera/               # Camera widgets
│   │   ├── camera_scan_overlay.dart # Scanning UI overlay
│   │   ├── focus_indicator.dart # Tap-to-focus indicator
│   │   ├── camera_permission_denied.dart # Permission error
│   │   └── scanning_frame_painter.dart # Custom frame painter
│   ├── scanning/             # Scanning widgets
│   │   ├── processing_overlay.dart # Loading dialog
│   │   └── joke_bubble_widget.dart # Non-cosmetic humor
│   ├── bottom_navigation_wrapper.dart
│   └── rating_request_dialog.dart
│
├── utils/                     # Utilities
│   └── integration_test.dart # Test helpers
│
└── main.dart                  # Application Entry Point
```

## Core Components

### 1. Presentation Layer

#### Screens
Each screen is a `StatefulWidget` or `StatelessWidget` responsible for:
- UI rendering
- User interaction handling
- Navigation
- State observation

**Example: ScanningScreen**
```dart
class ScanningScreen extends StatefulWidget {
  // Manages camera, image capture, and AI analysis
  // Routes to AnalysisScreen on success
}
```

#### Widgets
Reusable UI components following the design system.

**Example: BottomNavigationWrapper**
```dart
class BottomNavigationWrapper extends StatelessWidget {
  // Wraps screens with consistent bottom navigation
  // Handles route changes via GoRouter
}
```

### 2. State Management Layer

Uses **Provider** pattern for reactive state management.

#### UserState
Manages user profile data:
```dart
class UserState extends ChangeNotifier {
  String? _name;
  String? _skinType;
  List<String> _allergies;
  bool _isPregnant;
  bool _isBreastfeeding;

  // Methods: updateName, updateSkinType, addAllergy, etc.
  // Persists to SharedPreferences
}
```

#### LocaleProvider
Manages app language:
```dart
class LocaleProvider extends ChangeNotifier {
  Locale? _locale;

  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
    // Persists to SharedPreferences
  }
}
```

### 3. Business Logic Layer

#### GeminiService
Handles all Gemini AI interactions:
```dart
class GeminiService {
  // Vision API: analyzeImage()
  // - Determines if object is cosmetic
  // - Extracts ingredients
  // - Analyzes safety
  // - Returns AnalysisResult

  // Chat API: sendMessageWithHistory()
  // - Maintains conversation context
  // - Multi-language support
  // - Returns AI response
}
```

#### LocalDataService
SQLite database operations:
```dart
class LocalDataService {
  // CRUD operations for scan history
  // - insertScanResult()
  // - getAllScanResults()
  // - deleteScanResult()
}
```

#### ChatContextService
Builds context for AI chat:
```dart
class ChatContextService {
  static String generateScanContext(AnalysisResult result) {
    // Converts analysis to chat context
  }

  static String generateUserProfileContext(UserState userState) {
    // Builds user profile summary
  }
}
```

#### RatingService
Manages app rating dialog logic and timing:
```dart
class RatingService {
  // Check if rating dialog should be shown
  Future<bool> shouldShowRatingDialog();

  // Increment show counter
  Future<void> incrementRatingDialogShows();

  // Mark rating as completed (no more shows)
  Future<void> markRatingCompleted();

  // Reset for testing
  Future<void> resetRatingDialogShows();
}
```

Smart timing logic:
- Shows after 2nd user message in chat
- Minimum 24 hours after app install
- 3 days interval between repeated shows
- Maximum 3 shows total
- Never shows again after rating/feedback

See [RATING_SYSTEM_GUIDE.md](RATING_SYSTEM_GUIDE.md) for details.

#### UsageTrackingService
Tracks usage limits for free users:
```dart
class UsageTrackingService {
  // Check if user can scan
  Future<bool> canUserScan();

  // Check if user can send message
  Future<bool> canUserSendMessage();

  // Increment counters
  Future<void> incrementScansCount();
  Future<void> incrementMessagesCount();
}
```

#### Error Handling

The application implements a comprehensive error handling system with custom exceptions:

**Custom Exceptions** (`lib/exceptions/api_exceptions.dart`)
```dart
class ApiException implements Exception {
  final String message;
  final String? technicalDetails;
}

// Specific exception types:
- ServiceOverloadedException  // API overload
- RateLimitException          // Rate limiting
- TimeoutException            // Request timeout
- NetworkException            // Network issues
- AuthenticationException     // Auth failures
- InvalidResponseException    // Invalid data
- ServerException             // Generic errors
```

**Error Parsing in GeminiService**
```dart
ApiException _parseApiError(String errorMessage, int statusCode) {
  // Analyzes error messages and returns appropriate exception
  // Hides technical details like "Gemini" from users
}
```

**Localized Error Messages**
All errors are translated into 7 languages with user-friendly messages that:
- Hide technical implementation details
- Provide actionable guidance
- Maintain consistent tone across languages

See [ERROR_HANDLING_GUIDE.md](ERROR_HANDLING_GUIDE.md) for complete documentation.

### 4. Data Layer

#### Models

**IngredientInfo**
```dart
class IngredientInfo {
  final String name;              // Translated name
  final String hint;              // Safety explanation
  final String? originalName;     // Original name from label

  factory IngredientInfo.fromJson(Map<String, dynamic> json);
  factory IngredientInfo.fromDynamic(dynamic data); // Handles legacy data
}
```

**AnalysisResult**
```dart
class AnalysisResult {
  final bool isCosmeticLabel;
  final String? humorousMessage;
  final List<String> ingredients;
  final double overallSafetyScore;
  final List<IngredientInfo> highRiskIngredients;    // Changed from List<String>
  final List<IngredientInfo> moderateRiskIngredients; // Changed from List<String>
  final List<IngredientInfo> lowRiskIngredients;     // Changed from List<String>
  final List<String> personalizedWarnings;
  final String benefitsAnalysis;
  final List<RecommendedAlternative> recommendedAlternatives;

  factory AnalysisResult.fromJson(Map<String, dynamic> json);
}
```

**Key Features**:
- `IngredientInfo.originalName` stores EXACT text from product label (Korean, Japanese, Chinese, Cyrillic, Latin)
- `IngredientInfo.name` stores translated ingredient name in user's language
- `IngredientInfo.hint` provides localized safety explanation
- Display logic shows translations for non-Latin scripts (CJK, Hangul, Cyrillic)

**ScanResult** (for history)
```dart
class ScanResult {
  final int? id;
  final String imagePath;
  final DateTime timestamp;
  final String productName;
  final List<String> ingredients;
  final double safetyScore;
  // ... other fields
}
```

## Navigation Architecture

Uses **GoRouter** for declarative routing:

```dart
final GoRouter _router = GoRouter(
  routes: [
    GoRoute(path: '/home', builder: (context, state) => HomepageScreen()),
    GoRoute(path: '/scanning', builder: (context, state) => ScanningScreen()),
    GoRoute(path: '/analysis', builder: (context, state) => AnalysisScreen()),
    // ... other routes
  ],
);
```

### Navigation Flow

```
Homepage
  ├─→ Scan Button → ScanningScreen
  │                    ├─→ AI Analysis
  │                    └─→ AnalysisScreen
  ├─→ History → HistoryScreen → AnalysisScreen
  ├─→ Chat → DialoguesScreen → ChatAIScreen
  └─→ Profile → ProfileScreen
                  ├─→ SkinTypeScreen
                  ├─→ AllergiesScreen
                  ├─→ LanguageScreen
                  └─→ SubscriptionScreen
```

## Data Flow

### Scanning Flow
```
1. User taps camera button
   ↓
2. ScanningScreen captures image
   ↓
3. Image → Base64 encoding
   ↓
4. GeminiService.analyzeImage()
   ↓
5. Supabase Edge Function → Gemini Vision API
   ↓
6. AI Response → AnalysisResult model
   ↓
7. Check if cosmetic label
   ├─→ YES: Navigate to AnalysisScreen
   └─→ NO: Show humorous snackbar
   ↓
8. LocalDataService saves to SQLite (future)
```

### Chat Flow
```
1. User sends message
   ↓
2. ChatAIScreen captures input
   ↓
3. GeminiService.sendMessageWithHistory()
   ↓
4. Supabase Edge Function → Gemini API
   ↓
5. AI Response with history context
   ↓
6. Update chat messages list
   ↓
7. LocalDataService saves dialogue (future)
```

## State Management Patterns

### Provider Pattern
```dart
// In main.dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => UserState()),
    ChangeNotifierProvider(create: (_) => LocaleProvider()),
    Provider(create: (_) => GeminiService(useProxy: true)),
  ],
  child: MyApp(),
)

// In screens
final userState = context.watch<UserState>(); // Reactive
final gemini = context.read<GeminiService>(); // One-time access
```

### When to use `watch` vs `read`
- **`watch`**: When widget needs to rebuild on state changes
- **`read`**: When calling methods (actions), no rebuild needed

## Design Patterns Used

### 1. Repository Pattern
`LocalDataService` abstracts database operations.

### 2. Service Locator
Provider acts as a service locator for dependency injection.

### 3. Factory Pattern
Models use factory constructors:
```dart
factory AnalysisResult.fromJson(Map<String, dynamic> json) {
  // Parse and construct
}
```

### 4. Observer Pattern
Provider's `ChangeNotifier` implements observer pattern.

### 5. Singleton Pattern
Services are created once via Provider.

## Error Handling

### API Errors
```dart
try {
  final result = await geminiService.analyzeImage(image, prompt);
} catch (e) {
  _showError('Analysis failed: ${e.toString()}');
}
```

### Navigation Errors
```dart
if (context.canPop()) {
  context.pop();
} else {
  context.go('/fallback');
}
```

### Type Safety
```dart
List<T> safeCast<T>(List<dynamic>? list) {
  return list?.whereType<T>().toList() ?? [];
}
```

## Performance Optimizations

### 1. Lazy Loading
```dart
ListView.builder( // Only builds visible items
  itemCount: items.length,
  itemBuilder: (context, index) => ItemWidget(items[index]),
)
```

### 2. Const Widgets
```dart
const Icon(Icons.home) // Reuses instance
```

### 3. Image Caching
```dart
CachedNetworkImage(imageUrl: url)
```

### 4. Tree Shaking
Fonts are tree-shaken at build time (99% reduction).

## Testing Strategy

### Unit Tests
- Models: JSON parsing
- Services: Business logic
- Utilities: Helper functions

### Widget Tests
- Screens: UI rendering
- Widgets: Component behavior

### Integration Tests
- End-to-end flows
- API interactions

## Security Considerations

### 1. API Keys
- Stored in `.env` (not committed)
- Accessed via Supabase Edge Functions (proxy)

### 2. User Data
- Stored locally (SharedPreferences, SQLite)
- No cloud sync (v1.0)

### 3. Input Validation
```dart
if (allergies.isEmpty) return;
final sanitized = allergies.where((a) => a.isNotEmpty).toList();
```

## Scalability

### Future Enhancements

#### 1. Backend Integration
- User authentication
- Cloud sync
- Social features

#### 2. Offline Support
- Cached ingredient database
- Offline analysis (TensorFlow Lite)

#### 3. Modularization
```
packages/
  ├── core/           # Shared utilities
  ├── features/       # Feature modules
  │   ├── scanning/
  │   ├── chat/
  │   └── profile/
  └── design_system/  # Theme package
```

## Dependencies Management

### Core Dependencies
- `flutter`: ^3.32.6
- `provider`: ^6.1.2
- `go_router`: ^14.8.1
- `supabase_flutter`: ^2.10.2

### Development Dependencies
- `flutter_lints`: ^5.0.0
- `flutter_test`: SDK

### External Services
- Google Gemini AI
- Supabase (Edge Functions, future DB)

## Build & Deployment

### Build Variants
```bash
flutter build apk --release              # Android
flutter build appbundle --release         # Play Store
flutter build ios --release              # iOS
flutter build web --release              # Web
```

### Environment Configuration
```dart
// lib/config/env.dart
class Env {
  static const bool useProxy = true;
  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const String geminiKey = String.fromEnvironment('GEMINI_KEY');
}
```

## Monitoring & Analytics

### Future Integration
- Firebase Analytics
- Crashlytics
- Performance monitoring

## Code Quality & Refactoring

### Scanning Screen Refactoring (January 2025)

The scanning screen was successfully refactored from a monolithic 1,593-line file into a modular architecture:

**Metrics**:
- **77% reduction** in file size (1,593 → 363 lines)
- **60% reduction** in cyclomatic complexity (8-12 → 1-5)
- **100% elimination** of code duplication (~400 lines removed)
- **15 files created** for better separation of concerns

**Key Achievements**:
1. **Extracted Services**:
   - `CameraManager` - Camera lifecycle and permissions
   - `ScanningAnimationController` - 9 different animations
   - `ImageAnalysisService` - Centralized image processing
   - `PromptBuilderService` - AI prompt generation

2. **Extracted Widgets**:
   - `CameraScanOverlay` - Scanning UI with animations
   - `ProcessingOverlay` - Loading dialog
   - `FocusIndicator` - Tap-to-focus indicator
   - `JokeBubbleWidget` - Non-cosmetic humor
   - `CameraPermissionDenied` - Error states

3. **Configuration Management**:
   - AI prompts moved to `assets/config/prompts.json`
   - Centralized dimensions in `constants/app_dimensions.dart`
   - 8px design system implementation

4. **Critical Bug Fixes**:
   - Fixed processing dialog visibility during navigation
   - Added UI synchronization with `Future.delayed(Duration.zero)`
   - Implemented ingredient translation support (original_name field)
   - Added smart display logic for non-Latin scripts (CJK, Hangul, Cyrillic)

See [SCANNING_SCREEN_REFACTORING.md](SCANNING_SCREEN_REFACTORING.md) for detailed documentation.

---

**Last Updated**: January 2025
**Version**: 1.1.0
**Architecture Review**: January 2025
