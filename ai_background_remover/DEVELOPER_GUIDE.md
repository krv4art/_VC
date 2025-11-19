# Developer Guide - AI Background Remover

## Table of Contents
1. [Getting Started](#getting-started)
2. [Architecture Overview](#architecture-overview)
3. [Services Documentation](#services-documentation)
4. [Adding New Features](#adding-new-features)
5. [Testing Guidelines](#testing-guidelines)
6. [Deployment](#deployment)

## Getting Started

### Prerequisites
- Flutter SDK ^3.8.1
- Dart SDK
- Android Studio / Xcode
- Git

### Environment Setup

1. Clone the repository:
```bash
git clone https://github.com/yourusername/ai_background_remover.git
cd ai_background_remover
```

2. Install dependencies:
```bash
flutter pub get
```

3. Configure environment variables:

Create `.env` file:
```env
# Supabase Configuration
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your_anon_key

# Remove.bg API
REMOVE_BG_API_KEY=your_remove_bg_key

# RevenueCat
REVENUECAT_API_KEY=your_revenuecat_key
```

4. Generate localization:
```bash
flutter gen-l10n
```

5. Run the app:
```bash
flutter run
```

## Architecture Overview

### Clean Architecture Layers

```
┌─────────────────────────────────────┐
│         Presentation Layer          │
│  (Screens, Widgets, Providers)      │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│         Business Logic Layer        │
│           (Services)                │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│            Data Layer               │
│   (Models, Database, Cache)         │
└─────────────────────────────────────┘
```

### State Management

We use **Provider** pattern for state management:

- **ChangeNotifier**: For mutable state
- **Provider**: For dependency injection
- **Consumer**: For rebuilding widgets on state change

Example:
```dart
class ImageProcessingProvider extends ChangeNotifier {
  ProcessingState _state = ProcessingState.idle;

  Future<void> processImage(File image) async {
    _state = ProcessingState.processing;
    notifyListeners();

    // Process image

    _state = ProcessingState.completed;
    notifyListeners();
  }
}
```

## Services Documentation

### 1. AI Background Removal Service

**File**: `lib/services/ai_background_removal_service.dart`

**Purpose**: Manages AI background removal with multiple providers

**Providers**:
- `AIProvider.removeBg`: Remove.bg API (cloud)
- `AIProvider.supabase`: Supabase Edge Functions (cloud)
- `AIProvider.tflite`: TensorFlow Lite (on-device)
- `AIProvider.local`: Fallback algorithm (on-device)

**Usage**:
```dart
final aiService = AIBackgroundRemovalService();

final result = await aiService.removeBackground(
  imageFile: imageFile,
  isPremium: true, // Premium users get priority providers
);
```

**Adding a new AI provider**:

1. Add to `AIProvider` enum:
```dart
enum AIProvider {
  removeBg,
  supabase,
  tflite,
  myNewProvider, // Add here
  local,
}
```

2. Implement provider method:
```dart
Future<Uint8List> _removeBackgroundWithMyProvider(File imageFile) async {
  // Your implementation
}
```

3. Update `removeBackground` switch:
```dart
case AIProvider.myNewProvider:
  return await _removeBackgroundWithMyProvider(imageFile);
```

### 2. Image Editor Service

**File**: `lib/services/image_editor_service.dart`

**Features**:
- Crop, rotate, resize, flip
- 12+ filters
- Color adjustments (brightness, contrast, saturation)
- Edge refinement
- Background blur

**Adding a new filter**:

1. Add to `ImageFilter` enum:
```dart
enum ImageFilter {
  // ...existing filters
  myCustomFilter,
}
```

2. Implement in `applyFilter`:
```dart
case ImageFilter.myCustomFilter:
  filtered = img.adjustColor(
    image,
    // Your adjustments
  );
  break;
```

### 3. Background Service

**File**: `lib/services/background_service.dart`

**Features**:
- Apply preset backgrounds
- Custom gradients (linear, radial, sweep)
- Network/asset image backgrounds
- Blur effect

**Creating custom backgrounds**:

1. Add to `lib/models/background_preset.dart`:
```dart
static const myBackground = BackgroundPreset(
  id: 'my_bg',
  name: 'My Background',
  type: BackgroundType.gradient,
  gradientColors: [Color(0xFF123456), Color(0xFF654321)],
  gradientType: GradientType.linear,
  category: BackgroundCategory.gradient,
  isPremium: false,
);
```

2. Add to `allPresets` list

### 4. Cache Service

**File**: `lib/services/cache_service.dart`

**Features**:
- LRU cache (100MB max)
- 7-day expiry
- MD5 key generation
- Automatic cleanup

**Configuration**:
```dart
static const int _maxCacheSize = 100 * 1024 * 1024; // 100 MB
static const Duration _cacheExpiry = Duration(days: 7);
```

### 5. Analytics Service

**File**: `lib/services/analytics_service.dart`

**Tracking events**:
```dart
final analytics = AnalyticsService();

// Log custom event
await analytics.logEvent(
  name: 'custom_event',
  parameters: {'key': 'value'},
);

// Log image processing
await analytics.logImageProcessing(
  mode: 'Remove Background',
  isPremium: true,
  processingTimeMs: 2500,
);

// Log errors
await analytics.logError(
  exception,
  stackTrace,
  reason: 'Failed to process image',
  fatal: false,
);
```

## Adding New Features

### Adding a New Screen

1. Create screen file in `lib/screens/`:
```dart
// lib/screens/my_new_screen.dart
import 'package:flutter/material.dart';

class MyNewScreen extends StatelessWidget {
  const MyNewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My New Screen')),
      body: const Center(child: Text('Content')),
    );
  }
}
```

2. Add route in `lib/navigation/app_router.dart`:
```dart
GoRoute(
  path: '/my-new-screen',
  name: 'myNewScreen',
  builder: (context, state) => const MyNewScreen(),
),
```

3. Add localization strings in `lib/l10n/app_en.arb` and `app_ru.arb`

### Adding a New Service

1. Create service file in `lib/services/`:
```dart
// lib/services/my_service.dart
class MyService {
  static final MyService _instance = MyService._internal();
  factory MyService() => _instance;
  MyService._internal();

  Future<void> initialize() async {
    // Initialize service
  }

  // Service methods
}
```

2. Add to providers if state management needed:
```dart
// lib/providers/my_provider.dart
import 'package:flutter/foundation.dart';
import '../services/my_service.dart';

class MyProvider extends ChangeNotifier {
  final MyService _service = MyService();

  // State and methods
}
```

3. Register in `main.dart`:
```dart
MultiProvider(
  providers: [
    // ...existing providers
    ChangeNotifierProvider(create: (_) => MyProvider()),
  ],
  // ...
)
```

## Testing Guidelines

### Unit Tests

Location: `test/services/`, `test/models/`

Example:
```dart
// test/services/my_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:ai_background_remover/services/my_service.dart';

void main() {
  group('MyService', () {
    late MyService service;

    setUp(() {
      service = MyService();
    });

    test('should initialize correctly', () async {
      await service.initialize();
      expect(service.isInitialized, isTrue);
    });
  });
}
```

### Widget Tests

Location: `test/widgets/`

Example:
```dart
// test/widgets/my_widget_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('MyWidget displays text', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: MyWidget()),
    );

    expect(find.text('Hello'), findsOneWidget);
  });
}
```

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/services/my_service_test.dart

# Run with coverage
flutter test --coverage
```

## Deployment

### Android Release Build

1. Update version in `pubspec.yaml`:
```yaml
version: 1.0.0+1
```

2. Build APK:
```bash
flutter build apk --release
```

3. Build App Bundle:
```bash
flutter build appbundle --release
```

### iOS Release Build

1. Update version in `pubspec.yaml`

2. Build:
```bash
flutter build ios --release
```

3. Archive in Xcode

### Environment-Specific Builds

For different environments (dev, staging, prod):

```bash
# Development
flutter run --dart-define=ENV=dev

# Staging
flutter run --dart-define=ENV=staging

# Production
flutter run --dart-define=ENV=prod
```

## Best Practices

### Code Style

- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines
- Use `flutter_lints` package
- Run `dart format .` before commits

### Git Workflow

1. Create feature branch: `git checkout -b feature/my-feature`
2. Make changes and commit: `git commit -m "feat: add my feature"`
3. Push branch: `git push origin feature/my-feature`
4. Create Pull Request

### Commit Message Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

Types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`

Example:
```
feat(ai): add new background removal provider

Implemented custom AI provider with better edge detection
and support for complex backgrounds.

Closes #123
```

## Performance Optimization

### Image Processing

- Use `compute()` for heavy operations:
```dart
final result = await compute(processImageIsolate, imageFile);
```

- Implement caching for repeated operations
- Use appropriate image compression

### Memory Management

- Dispose controllers and streams:
```dart
@override
void dispose() {
  _controller.dispose();
  super.dispose();
}
```

- Clear image cache when not needed:
```dart
imageCache.clear();
imageCache.clearLiveImages();
```

## Troubleshooting

### Common Issues

**Issue**: Build fails with "SDK version" error
**Solution**: Update Flutter SDK: `flutter upgrade`

**Issue**: Image processing is slow
**Solution**: Use `compute()` for CPU-intensive tasks

**Issue**: Memory leaks
**Solution**: Check all `dispose()` methods are implemented

## Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Provider Package](https://pub.dev/packages/provider)
- [Image Package](https://pub.dev/packages/image)
- [Firebase for Flutter](https://firebase.flutter.dev)

## Contact

For questions or support:
- Email: dev@aibackgroundremover.com
- GitHub Issues: [Create an issue](https://github.com/yourusername/ai_background_remover/issues)
