# Shared Components & Patterns

This document describes common components, patterns, and code that are shared across multiple applications in the monorepo.

## Overview

While each application is standalone, they share common architectural patterns and similar implementations of core features. This document helps identify reusable code and patterns.

## Common Architecture Patterns

### 1. Service Layer

All apps use a service layer for business logic:

```dart
// services/database_service.dart
class DatabaseService {
  Database? _database;
  
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }
  
  Future<Database> _initDatabase() async {
    final path = await getDatabasePath();
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
  }
  
  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE items (
        id TEXT PRIMARY KEY,
        data TEXT NOT NULL,
        created_at INTEGER NOT NULL
      )
    ''');
  }
}
```

**Used in:** All apps  
**Location:** `lib/services/database_service.dart`

### 2. Provider Pattern

State management using Provider:

```dart
// providers/app_state_provider.dart
class AppStateProvider extends ChangeNotifier {
  final DatabaseService _database;
  bool _isLoading = false;
  String? _error;
  
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  AppStateProvider(this._database);
  
  Future<void> performAction() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      // Perform action
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
```

**Used in:** All apps  
**Location:** `lib/providers/`

### 3. Theme System

Comprehensive theming with custom colors:

```dart
// theme/app_colors.dart
class AppColors {
  static const naturalTheme = CustomColors(
    primary: Color(0xFF8B4513),
    secondary: Color(0xFF4CAF50),
    background: Color(0xFFF5F1E8),
    surface: Color(0xFFFFFFFF),
    // ... more colors
  );
}

// theme/theme_extensions_v2.dart
extension ThemeExtensions on BuildContext {
  CustomColors get colors {
    final provider = Provider.of<ThemeProviderV2>(this, listen: false);
    return provider.currentColors;
  }
}

// Usage
Container(color: context.colors.primary)
```

**Used in:** acs, bug_identifier, MAS  
**Location:** `lib/theme/`

### 4. Localization Pattern

ARB-based localization:

```json
// lib/l10n/app_en.arb
{
  "appTitle": "App Name",
  "@appTitle": {
    "description": "The title of the application"
  },
  "greeting": "Hello {name}",
  "@greeting": {
    "description": "Greeting message",
    "placeholders": {
      "name": {
        "type": "String"
      }
    }
  }
}
```

```dart
// Usage
Text(AppLocalizations.of(context)!.appTitle)
Text(AppLocalizations.of(context)!.greeting('John'))
```

**Used in:** All apps  
**Location:** `lib/l10n/`

## Shared Widgets

### 1. Animated Card

Reusable animated card with scale and elevation effects:

```dart
// widgets/animated/animated_card.dart
class AnimatedCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double elevation;
  final double scaleFactor;
  
  const AnimatedCard({
    Key? key,
    required this.child,
    this.onTap,
    this.elevation = 4.0,
    this.scaleFactor = 0.95,
  }) : super(key: key);
  
  @override
  State<AnimatedCard> createState() => _AnimatedCardState();
}
```

**Used in:** acs, bug_identifier, MAS  
**Features:** 
- Scale animation on press
- Elevation animation
- Entrance animation support
- Customizable timing

### 2. Loading Overlay

Full-screen loading indicator:

```dart
// widgets/common/loading_overlay.dart
class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final String? message;
  
  const LoadingOverlay({
    Key? key,
    required this.isLoading,
    required this.child,
    this.message,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Colors.black54,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  if (message != null) ...[
                    SizedBox(height: 16),
                    Text(message!, style: TextStyle(color: Colors.white)),
                  ],
                ],
              ),
            ),
          ),
      ],
    );
  }
}
```

**Used in:** All apps  
**Location:** `lib/widgets/common/loading_overlay.dart`

### 3. Error Widget

Consistent error display:

```dart
// widgets/common/error_widget.dart
class ErrorDisplay extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  
  const ErrorDisplay({
    Key? key,
    required this.message,
    this.onRetry,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red),
          SizedBox(height: 16),
          Text(message, textAlign: TextAlign.center),
          if (onRetry != null) ...[
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              child: Text('Retry'),
            ),
          ],
        ],
      ),
    );
  }
}
```

**Used in:** All apps  
**Location:** `lib/widgets/common/error_widget.dart`

### 4. Empty State Widget

Display when no data is available:

```dart
// widgets/common/empty_state.dart
class EmptyState extends StatelessWidget {
  final String message;
  final IconData icon;
  final VoidCallback? onAction;
  final String? actionLabel;
  
  const EmptyState({
    Key? key,
    required this.message,
    this.icon = Icons.inbox_outlined,
    this.onAction,
    this.actionLabel,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(message, style: Theme.of(context).textTheme.titleMedium),
          if (onAction != null && actionLabel != null) ...[
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: onAction,
              child: Text(actionLabel!),
            ),
          ],
        ],
      ),
    );
  }
}
```

**Used in:** All apps  
**Location:** `lib/widgets/common/empty_state.dart`

## Common Services

### 1. Image Picker Service

Wrapper around image_picker with error handling:

```dart
// services/image_picker_service.dart
class ImagePickerService {
  final ImagePicker _picker = ImagePicker();
  
  Future<File?> pickFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      return image != null ? File(image.path) : null;
    } catch (e) {
      throw ImagePickerException('Failed to pick from camera: $e');
    }
  }
  
  Future<File?> pickFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      return image != null ? File(image.path) : null;
    } catch (e) {
      throw ImagePickerException('Failed to pick from gallery: $e');
    }
  }
}
```

**Used in:** acs, bug_identifier, plant_identifier, MAS  
**Location:** `lib/services/image_picker_service.dart`

### 2. Storage Service

Local file storage wrapper:

```dart
// services/storage_service.dart
class StorageService {
  Future<String> saveImage(File image) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final path = '${directory.path}/$fileName';
    
    await image.copy(path);
    return path;
  }
  
  Future<void> deleteImage(String path) async {
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }
  
  Future<File> getImage(String path) async {
    return File(path);
  }
}
```

**Used in:** acs, bug_identifier, plant_identifier, MAS  
**Location:** `lib/services/storage_service.dart`

### 3. API Service Base

Base class for API services:

```dart
// services/api_service_base.dart
abstract class ApiServiceBase {
  final SupabaseClient client;
  
  ApiServiceBase(this.client);
  
  Future<T> callFunction<T>({
    required String functionName,
    required Map<String, dynamic> body,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final response = await client.functions.invoke(
        functionName,
        body: body,
      );
      
      if (response.status != 200) {
        throw ApiException('Function call failed: ${response.status}');
      }
      
      return fromJson(response.data);
    } catch (e) {
      throw ApiException('API call failed: $e');
    }
  }
}
```

**Used in:** acs, bug_identifier, plant_identifier, MAS  
**Location:** `lib/services/api_service_base.dart`

## Common Models

### 1. Result Model

Generic result type for operations that can fail:

```dart
// models/result.dart
sealed class Result<T> {
  const Result();
}

class Success<T> extends Result<T> {
  final T value;
  const Success(this.value);
}

class Failure<T> extends Result<T> {
  final String message;
  final Exception? exception;
  const Failure(this.message, [this.exception]);
}

// Usage
Future<Result<ScanData>> scan() async {
  try {
    final data = await performScan();
    return Success(data);
  } catch (e) {
    return Failure('Scan failed', e as Exception);
  }
}
```

**Used in:** acs, bug_identifier, plant_identifier, MAS  
**Location:** `lib/models/result.dart`

## Common Utilities

### 1. Date Formatter

Consistent date formatting:

```dart
// utils/date_formatter.dart
class DateFormatter {
  static String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }
  
  static String formatDateTime(DateTime date) {
    return DateFormat('MMM dd, yyyy HH:mm').format(date);
  }
  
  static String formatRelative(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 7) {
      return formatDate(date);
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
}
```

**Used in:** All apps  
**Location:** `lib/utils/date_formatter.dart`

### 2. Validator

Common validation functions:

```dart
// utils/validators.dart
class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Invalid email format';
    }
    return null;
  }
  
  static String? validateNotEmpty(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }
  
  static String? validateLength(String? value, int min, int max) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    if (value.length < min) {
      return 'Must be at least $min characters';
    }
    if (value.length > max) {
      return 'Must be at most $max characters';
    }
    return null;
  }
}
```

**Used in:** All apps  
**Location:** `lib/utils/validators.dart`

## Navigation Patterns

### 1. Go Router Setup

All apps use go_router with similar structure:

```dart
// navigation/app_router.dart
final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      path: '/scan',
      builder: (context, state) => ScanScreen(),
    ),
    GoRoute(
      path: '/history',
      builder: (context, state) => HistoryScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => SettingsScreen(),
    ),
  ],
);
```

**Used in:** All apps  
**Location:** `lib/navigation/app_router.dart`

## Extraction Opportunities

### Potential Shared Package

These components could be extracted into a shared package:

1. **Core Widgets**
   - AnimatedCard
   - LoadingOverlay
   - ErrorDisplay
   - EmptyState

2. **Common Services**
   - ImagePickerService
   - StorageService
   - ApiServiceBase

3. **Utilities**
   - DateFormatter
   - Validators
   - Result type

4. **Theme System**
   - ThemeProvider
   - CustomColors
   - ThemeExtensions

### Benefits of Extraction
- **Consistency** - Same behavior across all apps
- **Maintenance** - Fix bugs in one place
- **Testing** - Test once, use everywhere
- **Reusability** - Easy to add to new apps

### Considerations
- **Coupling** - Shared package creates dependencies
- **Versioning** - Need to manage package versions
- **Flexibility** - May need app-specific customizations
- **Overhead** - Additional setup complexity

## Conclusion

While currently each app maintains its own copy of these patterns and components, understanding the commonalities helps:

1. **Consistency** - Maintain similar implementations
2. **Knowledge Transfer** - Developers can work across apps easily
3. **Best Practices** - Learn from all apps
4. **Future Planning** - Identify extraction opportunities

---

**Last Updated:** 2025-01-11  
**Maintained By:** Development Team
