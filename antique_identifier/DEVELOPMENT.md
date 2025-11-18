# Development Guide - Antique Identifier

## Getting Started

### Prerequisites
- Flutter SDK 3.8.1 or higher
- Dart SDK 3.8.1 or higher
- iOS development tools (for iOS builds)
- Android SDK (for Android builds)

### Setup

```bash
# Clone repository
git clone <repo_url>
cd antique_identifier

# Install dependencies
flutter pub get

# Generate localization files (when added)
flutter gen-l10n

# Run app
flutter run
```

## Project Structure

```
lib/
├── main.dart                           # App entry point
├── models/                             # Data models
│   ├── analysis_result.dart            # ✅ Complete
│   ├── dialogue.dart                   # ✅ Complete
│   └── chat_message.dart               # ✅ Complete
├── services/                           # API & business logic
│   ├── antique_identification_service.dart  # ✅ Gemini API
│   ├── prompt_builder_service.dart          # ✅ Prompt engineering
│   ├── chat_service.dart                    # ✅ Chat AI
│   └── supabase_service.dart                # ✅ Backend
├── screens/                            # 📝 To implement
│   ├── home_screen.dart
│   ├── scan_screen.dart
│   ├── results_screen.dart
│   ├── chat_screen.dart
│   └── history_screen.dart
├── widgets/                            # 📝 To implement
│   ├── price_estimate_widget.dart
│   ├── materials_list_widget.dart
│   ├── warnings_banner_widget.dart
│   └── chat_bubble_widget.dart
├── providers/                          # 📝 To implement
│   ├── analysis_provider.dart
│   ├── chat_provider.dart
│   └── history_provider.dart
├── config/                             # Configuration
│   ├── app_config.dart
│   ├── constants.dart
│   └── theme.dart
└── l10n/                              # 📝 Localization (30+ languages)
```

## Code Style & Conventions

### Naming Conventions

```dart
// Classes: PascalCase
class AnalysisResult { }

// Methods/Variables: camelCase
void analyzeImage() { }
String itemName;

// Constants: camelCase (use const/final)
const String apiUrl = 'https://...';
final Map<String, String> translations = {};

// Private: prefix with underscore
String _privateVariable;
void _privateMethod() { }

// Enum values: lowercase
enum Confidence { low, medium, high }

// File names: snake_case
analysis_result.dart
antique_identification_service.dart
```

### Documentation

```dart
/// Brief description of the class.
///
/// More detailed explanation if needed.
/// Can include examples:
/// ```dart
/// final result = await service.analyzeImage(bytes);
/// ```
class MyClass {
  /// Description of the method.
  ///
  /// [parameter] - description of parameter
  /// Returns: description of return value
  /// Throws: [Exception] if something goes wrong
  Future<AnalysisResult> analyzeImage(Uint8List bytes) async { }
}
```

### Error Handling

```dart
// ✅ Good: Specific error handling
try {
  final result = await service.analyzeImage(imageBytes);
  // Process result
} on TimeoutException catch (e) {
  debugPrint('Request timed out: $e');
  showErrorDialog(context, 'Request took too long');
} on FormatException catch (e) {
  debugPrint('Invalid response format: $e');
  showErrorDialog(context, 'Invalid response from server');
} catch (e) {
  debugPrint('Unexpected error: $e');
  showErrorDialog(context, 'An unexpected error occurred');
}

// ❌ Bad: Generic catch-all
try {
  await service.analyzeImage(imageBytes);
} catch (e) {
  print('Error: $e'); // No specific handling
}
```

### Async/Await Usage

```dart
// ✅ Good: Clear async operations
Future<AnalysisResult> analyzeImage(Uint8List bytes) async {
  try {
    // Step 1: Validate input
    if (bytes.isEmpty) throw ArgumentError('Image is empty');

    // Step 2: Send to API
    final response = await _sendToGemini(bytes);

    // Step 3: Parse response
    final result = AnalysisResult.fromJson(response);

    // Step 4: Save to database
    await _supabaseService.saveAnalysisResult(result);

    return result;
  } catch (e) {
    debugPrint('Error: $e');
    rethrow;
  }
}

// ❌ Bad: Nested callbacks
void analyzeImageBad(Uint8List bytes) {
  _sendToGemini(bytes).then((response) {
    var result = AnalysisResult.fromJson(response);
    _supabaseService.saveAnalysisResult(result).then((_) {
      // Hard to read and maintain
    });
  });
}
```

### Constants & Configuration

```dart
// config/constants.dart
class ApiConstants {
  static const String geminiUrl = 'https://...';
  static const Duration requestTimeout = Duration(seconds: 60);
  static const int maxRetries = 3;
}

class UiConstants {
  static const double defaultPadding = 16.0;
  static const double borderRadius = 8.0;
}

// Usage
await http.post(
  Uri.parse(ApiConstants.geminiUrl),
).timeout(ApiConstants.requestTimeout);
```

## Best Practices

### 1. Service Layer

```dart
// ✅ Good: Service has single responsibility
class AntiqueIdentificationService {
  Future<AnalysisResult> analyzeImage(
    Uint8List imageBytes,
    {required String languageCode}
  ) async {
    // Single, focused responsibility
  }
}

// ❌ Bad: Service doing too much
class AntiqueService {
  Future<AnalysisResult> analyzeImage(...) { }
  Future<void> saveToDatabase(...) { }
  Future<void> uploadImage(...) { }
  Future<String> sendChatMessage(...) { }
  // Too many responsibilities!
}
```

### 2. Model Classes

```dart
// ✅ Good: Immutable models with factory constructors
class AnalysisResult {
  final bool isAntique;
  final String itemName;
  final String description;
  final List<MaterialInfo> materials;

  const AnalysisResult({
    required this.isAntique,
    required this.itemName,
    required this.description,
    required this.materials,
  });

  factory AnalysisResult.fromJson(Map<String, dynamic> json) {
    // Parsing logic
  }

  Map<String, dynamic> toJson() {
    // Serialization logic
  }
}

// ❌ Bad: Mutable models
class AnalysisResultBad {
  bool? isAntique;
  String? itemName;

  // Methods that modify state
  void setAntique(bool value) {
    isAntique = value; // Unpredictable behavior
  }
}
```

### 3. Null Safety

```dart
// ✅ Good: Explicit null handling
String? estimatedPeriod; // Can be null
String itemName;         // Cannot be null

// Check before use
if (estimatedPeriod != null) {
  print('Period: $estimatedPeriod');
}

// Or use null coalescing
String period = estimatedPeriod ?? 'Unknown';

// ❌ Bad: Unsafe null access
String? period = null;
print(period.length); // Runtime error!
```

### 4. Resource Management

```dart
// ✅ Good: Proper resource cleanup
class ChatService {
  @override
  void dispose() {
    _history.clear();
    // Clean up any other resources
  }
}

// ❌ Bad: Leaking resources
class ChatServiceBad {
  // No cleanup, memory leak over time
}
```

### 5. Logging & Debugging

```dart
// ✅ Good: Structured logging
debugPrint('=== Analyzing antique image ===');
debugPrint('Language: $languageCode');
debugPrint('Image size: ${imageBytes.length} bytes');

final result = await service.analyzeImage(imageBytes);

debugPrint('✓ Analysis complete');
debugPrint('Item: ${result.itemName}');
debugPrint('Value: ${result.priceEstimate?.getFormattedRange()}');

// ❌ Bad: No logging
final result = await service.analyzeImage(imageBytes);
// How do we know what happened?
```

## Widget Development Guidelines

### Creating UI Screens

```dart
// ✅ Good: Structured screen with state management
class ResultsScreen extends StatefulWidget {
  final AnalysisResult result;

  const ResultsScreen({Key? key, required this.result}) : super(key: key);

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Analysis Results')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Title & Category
            _buildHeader(),
            const SizedBox(height: 24),

            // Materials
            _buildMaterials(),
            const SizedBox(height: 24),

            // Valuation
            _buildPriceEstimate(),
            const SizedBox(height: 24),

            // Warnings
            _buildWarnings(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.result.itemName,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        if (widget.result.category != null)
          Text(widget.result.category!),
        if (widget.result.estimatedPeriod != null)
          Text('Period: ${widget.result.estimatedPeriod}'),
      ],
    );
  }

  Widget _buildMaterials() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Materials',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        ...widget.result.materials.map((material) =>
          Card(
            child: ListTile(
              title: Text(material.name),
              subtitle: Text(material.description),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceEstimate() {
    final estimate = widget.result.priceEstimate;
    if (estimate == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Estimated Value',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Card(
          color: Colors.amber.shade50,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  estimate.getFormattedRange(),
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text('Confidence: ${estimate.confidence}'),
                Text('Based on: ${estimate.basedOn}'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWarnings() {
    if (widget.result.warnings.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Important Notes',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.orange.shade100,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.orange),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.result.warnings
                .map((warning) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.warning, size: 16),
                      const SizedBox(width: 8),
                      Expanded(child: Text(warning)),
                    ],
                  ),
                ))
                .toList(),
          ),
        ),
      ],
    );
  }
}
```

### Creating Reusable Widgets

```dart
// ✅ Good: Reusable, focused widget
class PriceEstimateWidget extends StatelessWidget {
  final PriceEstimate estimate;

  const PriceEstimateWidget({Key? key, required this.estimate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.amber.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Estimated Value',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Text(
              estimate.getFormattedRange(),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            _buildConfidenceBadge(),
            const SizedBox(height: 8),
            Text('Based on: ${estimate.basedOn}'),
          ],
        ),
      ),
    );
  }

  Widget _buildConfidenceBadge() {
    final color = estimate.confidence == 'high'
        ? Colors.green
        : estimate.confidence == 'medium'
            ? Colors.orange
            : Colors.red;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        'Confidence: ${estimate.confidence}',
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}

// Usage
PriceEstimateWidget(estimate: analysisResult.priceEstimate!)
```

## Testing

### Writing Tests

```dart
// test/services/antique_identification_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:antique_identifier/services/antique_identification_service.dart';
import 'package:antique_identifier/models/analysis_result.dart';

void main() {
  group('AntiqueIdentificationService', () {
    late AntiqueIdentificationService service;

    setUp(() {
      service = AntiqueIdentificationService();
    });

    test('analyzeAntiqueImage returns valid AnalysisResult', () async {
      // Arrange
      final testImageBytes = _createTestImage();

      // Act
      final result = await service.analyzeAntiqueImage(
        testImageBytes,
        languageCode: 'en',
      );

      // Assert
      expect(result.isAntique, true);
      expect(result.itemName, isNotEmpty);
      expect(result.materials, isNotEmpty);
      expect(result.priceEstimate, isNotNull);
      expect(result.warnings, isNotEmpty);
    });

    test('analyzeAntiqueImage handles network errors', () async {
      // Test error handling
    });

    test('analyzeAntiqueImage handles invalid JSON', () async {
      // Test error handling
    });
  });

  // Helper function
  List<int> _createTestImage() {
    // Create a test image
    return [];
  }
}
```

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/services/antique_identification_service_test.dart

# Run tests with coverage
flutter test --coverage

# View coverage report
lcov --list coverage/lcov.info
```

## Performance Tips

### Image Handling
```dart
// Compress images before sending
final compressedBytes = await ImageCompression.compressImage(imageBytes);
final base64 = base64Encode(compressedBytes);

// Typical compression: 70% reduction
```

### API Calls
```dart
// Add timeout to prevent hanging
await http.post(
  Uri.parse(url),
).timeout(const Duration(seconds: 60));

// Implement exponential backoff for retries
Future<T> retryWithBackoff<T>(
  Future<T> Function() operation,
) async {
  int retries = 0;
  while (retries < 3) {
    try {
      return await operation();
    } catch (e) {
      retries++;
      if (retries >= 3) rethrow;
      await Future.delayed(Duration(seconds: 1 << retries));
    }
  }
}
```

### State Management
```dart
// Use Provider for efficient state management
// Only rebuild widgets that depend on changed state
final analysisProvider = StateNotifierProvider<
  AnalysisNotifier,
  AsyncValue<AnalysisResult>
>((ref) => AnalysisNotifier());

// Efficient rebuilds
Consumer(
  builder: (context, ref, child) {
    final analysis = ref.watch(analysisProvider);
    return analysis.when(
      loading: () => const LoadingSpinner(),
      error: (error, stack) => ErrorWidget(error: error),
      data: (result) => ResultsView(result: result),
    );
  },
)
```

## Common Issues & Solutions

### Issue: Long Analysis Times
**Solution**:
- Show progress indicator
- Implement timeout handling
- Show "slow internet" message after 7 seconds

### Issue: JSON Parsing Errors
**Solution**:
- Use try-catch with specific error handling
- Log full response for debugging
- Return default structure with warnings

### Issue: Memory Leaks with Images
**Solution**:
- Compress before storing
- Clear image cache periodically
- Dispose resources in cleanup methods

### Issue: Chat History Gets Lost
**Solution**:
- Persist to Supabase database
- Implement local SQLite cache
- Auto-save messages periodically

## Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Documentation](https://dart.dev/guides)
- [Google Gemini API](https://ai.google.dev/docs)
- [Supabase Flutter SDK](https://supabase.com/docs/reference/flutter)
- [Provider Package](https://pub.dev/packages/provider)

---

**Last Updated**: November 2024
**Version**: 1.0
