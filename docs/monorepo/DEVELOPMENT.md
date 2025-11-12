# Development Guidelines

## Getting Started

### Prerequisites

1. **Flutter SDK** (3.x or higher)
   ```bash
   flutter --version
   ```

2. **Dart SDK** (3.x or higher)
   ```bash
   dart --version
   ```

3. **IDE Setup**
   - VS Code with Flutter extension
   - Android Studio with Flutter plugin
   - IntelliJ IDEA with Flutter plugin

4. **Platform-Specific Requirements**
   - **Android:** Android Studio, Android SDK, JDK 11+
   - **iOS:** Xcode 14+, CocoaPods
   - **Web:** Chrome browser
   - **Desktop:** Platform-specific build tools

### Initial Setup

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd <repository-directory>
   ```

2. **Choose an app to work on**
   ```bash
   cd acs  # or bug_identifier, plant_identifier, MAS, unseen
   ```

3. **Install dependencies**
   ```bash
   flutter pub get
   ```

4. **Check for issues**
   ```bash
   flutter doctor
   ```

5. **Run the app**
   ```bash
   flutter run
   ```

## Project Structure

### Each App Directory Structure
```
app_name/
├── lib/                    # Dart source code
├── android/               # Android platform code
├── ios/                   # iOS platform code
├── web/                   # Web platform code
├── macos/                 # macOS platform code
├── linux/                 # Linux platform code
├── windows/               # Windows platform code
├── test/                  # Test files
├── pubspec.yaml           # Dependencies
├── README.md              # App documentation
└── docs/                  # Additional docs
```

### lib/ Directory Structure
```
lib/
├── main.dart              # Entry point
├── models/                # Data models
├── services/              # Business logic
├── providers/             # State management
├── screens/               # UI screens
├── widgets/               # Reusable widgets
├── theme/                 # Theming
├── navigation/            # Routing
├── config/                # Configuration
└── l10n/                  # Localization
```

## Coding Standards

### Dart Style Guide

Follow the [official Dart style guide](https://dart.dev/guides/language/effective-dart/style):

1. **Naming Conventions**
   - Classes: `UpperCamelCase`
   - Functions/Variables: `lowerCamelCase`
   - Constants: `lowerCamelCase`
   - Enums: `UpperCamelCase`, values in `lowerCamelCase`

2. **File Naming**
   - Snake case: `file_name.dart`
   - One class per file
   - File name matches class name

3. **Formatting**
   ```bash
   # Format all Dart files
   dart format .
   
   # Format specific file
   dart format lib/main.dart
   ```

### Code Organization

#### Models
```dart
// models/scan_result.dart
class ScanResult {
  final String id;
  final String imagePath;
  final double score;
  final DateTime createdAt;
  
  ScanResult({
    required this.id,
    required this.imagePath,
    required this.score,
    required this.createdAt,
  });
  
  factory ScanResult.fromJson(Map<String, dynamic> json) => ScanResult(
    id: json['id'] as String,
    imagePath: json['imagePath'] as String,
    score: (json['score'] as num).toDouble(),
    createdAt: DateTime.parse(json['createdAt'] as String),
  );
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'imagePath': imagePath,
    'score': score,
    'createdAt': createdAt.toIso8601String(),
  };
}
```

#### Services
```dart
// services/database_service.dart
class DatabaseService {
  Database? _database;
  
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }
  
  Future<List<ScanResult>> getScans() async {
    final db = await database;
    final results = await db.query('scans');
    return results.map((json) => ScanResult.fromJson(json)).toList();
  }
  
  Future<void> saveScan(ScanResult scan) async {
    final db = await database;
    await db.insert('scans', scan.toJson());
  }
}
```

#### Providers
```dart
// providers/scan_history_provider.dart
class ScanHistoryProvider extends ChangeNotifier {
  final DatabaseService _databaseService;
  List<ScanResult> _scans = [];
  bool _isLoading = false;
  
  List<ScanResult> get scans => List.unmodifiable(_scans);
  bool get isLoading => _isLoading;
  
  ScanHistoryProvider(this._databaseService);
  
  Future<void> loadScans() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _scans = await _databaseService.getScans();
    } catch (e) {
      // Handle error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> addScan(ScanResult scan) async {
    await _databaseService.saveScan(scan);
    _scans.insert(0, scan);
    notifyListeners();
  }
}
```

#### Widgets
```dart
// widgets/scan_card.dart
class ScanCard extends StatelessWidget {
  final ScanResult scan;
  final VoidCallback? onTap;
  
  const ScanCard({
    Key? key,
    required this.scan,
    this.onTap,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text('Score: ${scan.score}'),
        subtitle: Text(scan.createdAt.toString()),
        onTap: onTap,
      ),
    );
  }
}
```

### State Management

#### Provider Setup in main.dart
```dart
void main() {
  runApp(
    MultiProvider(
      providers: [
        // Services (no need for ChangeNotifier)
        Provider<DatabaseService>(
          create: (_) => DatabaseService(),
        ),
        
        // Providers (with ChangeNotifier)
        ChangeNotifierProvider<ThemeProvider>(
          create: (context) => ThemeProvider(
            context.read<ThemeStorageService>(),
          ),
        ),
        ChangeNotifierProvider<ScanHistoryProvider>(
          create: (context) => ScanHistoryProvider(
            context.read<DatabaseService>(),
          ),
        ),
      ],
      child: MyApp(),
    ),
  );
}
```

#### Using Providers in Widgets
```dart
// Read once (doesn't rebuild on changes)
final service = context.read<DatabaseService>();

// Watch (rebuilds on changes)
final scans = context.watch<ScanHistoryProvider>().scans;

// Select specific value (rebuilds only when that value changes)
final isLoading = context.select<ScanHistoryProvider, bool>(
  (provider) => provider.isLoading,
);
```

### Error Handling

```dart
// Use try-catch for async operations
Future<void> loadData() async {
  try {
    final data = await apiService.fetchData();
    // Process data
  } on NetworkException catch (e) {
    // Handle network error
    showError('Network error: ${e.message}');
  } on DatabaseException catch (e) {
    // Handle database error
    showError('Database error: ${e.message}');
  } catch (e) {
    // Handle unexpected errors
    showError('Unexpected error: $e');
  }
}

// Create custom exceptions
class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
}
```

### Null Safety

```dart
// Use nullable types when appropriate
String? nullableString;

// Use non-nullable with late when initialization is deferred
late final String lateString;

// Use null-aware operators
final length = nullableString?.length ?? 0;

// Use null assertion only when you're certain
final definitelyNotNull = nullableString!;
```

## Testing

### Unit Tests
```dart
// test/services/database_service_test.dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DatabaseService', () {
    late DatabaseService service;
    
    setUp(() {
      service = DatabaseService();
    });
    
    test('should save and retrieve scan', () async {
      final scan = ScanResult(
        id: '1',
        imagePath: '/path/to/image',
        score: 8.5,
        createdAt: DateTime.now(),
      );
      
      await service.saveScan(scan);
      final scans = await service.getScans();
      
      expect(scans, contains(scan));
    });
  });
}
```

### Widget Tests
```dart
// test/widgets/scan_card_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('ScanCard displays score', (tester) async {
    final scan = ScanResult(
      id: '1',
      imagePath: '/path',
      score: 8.5,
      createdAt: DateTime.now(),
    );
    
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ScanCard(scan: scan),
        ),
      ),
    );
    
    expect(find.text('Score: 8.5'), findsOneWidget);
  });
}
```

### Running Tests
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/services/database_service_test.dart

# Run with coverage
flutter test --coverage

# View coverage report (requires lcov)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## Localization

### Adding a New Language

1. **Create ARB file**
   ```bash
   cp lib/l10n/app_en.arb lib/l10n/app_fr.arb
   ```

2. **Translate strings**
   ```json
   {
     "appTitle": "Mon Application",
     "@appTitle": {
       "description": "Le titre de l'application"
     }
   }
   ```

3. **Generate localizations**
   ```bash
   flutter gen-l10n
   ```

4. **Update supported locales in main.dart**
   ```dart
   MaterialApp(
     localizationsDelegates: AppLocalizations.localizationsDelegates,
     supportedLocales: AppLocalizations.supportedLocales,
     // ...
   )
   ```

### Using Localizations
```dart
// In widgets
Text(AppLocalizations.of(context)!.appTitle)

// With extension
extension BuildContextL10n on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}

Text(context.l10n.appTitle)
```

## Theming

### Creating a New Theme
```dart
// theme/app_colors.dart
class CustomTheme {
  static const primary = Color(0xFF6200EE);
  static const secondary = Color(0xFF03DAC6);
  static const background = Color(0xFFF5F5F5);
  static const surface = Color(0xFFFFFFFF);
  static const error = Color(0xFFB00020);
}

// theme/app_theme.dart
class AppTheme {
  static ThemeData customTheme() {
    return ThemeData(
      colorScheme: ColorScheme.light(
        primary: CustomTheme.primary,
        secondary: CustomTheme.secondary,
        background: CustomTheme.background,
        surface: CustomTheme.surface,
        error: CustomTheme.error,
      ),
      // ... other theme properties
    );
  }
}
```

## Git Workflow

### Branch Naming
- Feature: `feature/description`
- Bug fix: `fix/description`
- Hotfix: `hotfix/description`
- Documentation: `docs/description`

### Commit Messages
Follow [Conventional Commits](https://www.conventionalcommits.org/):
```
feat: add new feature
fix: resolve bug
docs: update documentation
style: format code
refactor: restructure code
test: add tests
chore: update dependencies
```

### Pull Request Process
1. Create feature branch from `main`
2. Make changes and commit
3. Push branch to remote
4. Create pull request
5. Address review comments
6. Merge when approved

## Build & Release

### Android Release Build
```bash
# Build APK
flutter build apk --release

# Build App Bundle (for Play Store)
flutter build appbundle --release
```

### iOS Release Build
```bash
# Build IPA
flutter build ipa --release
```

### Web Release Build
```bash
# Build for web
flutter build web --release

# Build with specific base href
flutter build web --release --base-href /app/
```

### Version Bumping
Update in `pubspec.yaml`:
```yaml
version: 1.2.3+4  # version+build_number
```

## Performance Tips

1. **Use const constructors**
   ```dart
   const Text('Hello')  // Better than Text('Hello')
   ```

2. **Avoid rebuilding entire trees**
   ```dart
   // Use context.select to watch specific values
   final isLoading = context.select<Provider, bool>(
     (p) => p.isLoading,
   );
   ```

3. **Use ListView.builder for long lists**
   ```dart
   ListView.builder(
     itemCount: items.length,
     itemBuilder: (context, index) => ItemWidget(items[index]),
   )
   ```

4. **Cache expensive computations**
   ```dart
   late final expensiveValue = _computeExpensiveValue();
   ```

## Debugging

### Enable Flutter DevTools
```bash
flutter pub global activate devtools
flutter pub global run devtools
```

### Common Debug Commands
```bash
# Hot reload
r

# Hot restart
R

# Print widget tree
debugDumpApp()

# Print render tree
debugDumpRenderTree()

# Print layer tree
debugDumpLayerTree()
```

### Performance Profiling
```bash
# Profile build
flutter run --profile

# Measure performance
flutter run --profile --trace-startup
```

## Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Flutter Cookbook](https://docs.flutter.dev/cookbook)
- [Effective Dart](https://dart.dev/guides/language/effective-dart)
- [Flutter Best Practices](https://docs.flutter.dev/perf/best-practices)

---

**Last Updated:** 2025-01-11  
**Maintained By:** Development Team
