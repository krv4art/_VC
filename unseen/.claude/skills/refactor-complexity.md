---
name: refactor-complexity
description: Analyze Flutter/Dart files for cyclomatic complexity and propose modularization strategy to improve code maintainability and testability.
tools: [Read, Edit, Write, Glob, Grep, Bash, Task]
---

# Refactor Cyclomatic Complexity Skill

## Purpose
Analyze Flutter/Dart files for high cyclomatic complexity and propose modularization to improve code quality, maintainability, and testability.

## When to Use This Skill
- When a file exceeds 500-1000 lines
- When methods have cyclomatic complexity > 10
- When code duplication is detected
- When adding new features becomes difficult
- When unit testing is challenging
- When user asks to "refactor", "reduce complexity", or "modularize"

## Analysis Process

### Step 1: Initial Assessment
Read the target file and analyze:
1. **File Size**: Count total lines of code
2. **Method Complexity**: Identify methods with high cyclomatic complexity (count if/else, switch, for, while, &&, ||)
3. **Code Duplication**: Find repeated code blocks (>10 lines)
4. **Coupling**: Identify tight dependencies between components
5. **Single Responsibility**: Check if class/file has multiple responsibilities

### Step 2: Calculate Metrics
```
Cyclomatic Complexity Formula:
CC = Number of decision points + 1

Decision points:
- if/else (each branch = +1)
- switch cases (each case = +1)
- for/while loops (+1)
- && and || operators (+1 each)
- try/catch (+1)
- ternary operators (+1)
```

**Complexity Levels**:
- 1-5: Low (simple, easy to test)
- 6-10: Moderate (acceptable)
- 11-20: High (needs refactoring)
- 21+: Very High (critical, refactor immediately)

### Step 3: Propose Refactoring Strategy

#### A. Service Extraction
Extract business logic into dedicated service classes:
```dart
// Before: All in screen
class MyScreen extends StatefulWidget {
  void _processData() {
    // 50 lines of business logic
  }
}

// After: Extracted to service
class DataProcessingService {
  Future<Result> processData() {
    // Business logic here
  }
}
```

**Extract to**:
- `lib/services/[feature]/` for business logic
- Use clear naming: `CameraManager`, `ImageAnalysisService`, `PromptBuilderService`

#### B. Widget Extraction
Extract reusable UI components:
```dart
// Before: Inline widget with 100+ lines
Widget build(BuildContext context) {
  return Column(
    children: [
      // 100 lines of UI code
    ],
  );
}

// After: Extracted widget
class CustomOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // UI code here
  }
}
```

**Extract to**:
- `lib/widgets/[feature]/` for feature-specific widgets
- `lib/widgets/common/` for reusable widgets
- Use descriptive names: `CameraScanOverlay`, `ProcessingDialog`, `FocusIndicator`

#### C. Animation Controller Extraction
Extract complex animation logic:
```dart
// Before: Multiple animations in screen
class _MyScreenState extends State<MyScreen> with TickerProviderStateMixin {
  late AnimationController _controller1;
  late AnimationController _controller2;
  late Animation<double> _anim1;
  late Animation<double> _anim2;
  // ... 10 more animations
}

// After: Dedicated animation controller
class MyAnimationController {
  late AnimationController controller;
  late Animation<double> fadeAnimation;
  late Animation<double> scaleAnimation;

  void initializeAnimations(TickerProvider vsync) {
    // Setup animations
  }
}
```

**Extract to**:
- `lib/services/[feature]/[feature]_animation_controller.dart`

#### D. Constants Extraction
Centralize magic numbers and strings:
```dart
// Before: Magic numbers everywhere
Container(height: 16, padding: EdgeInsets.all(8))

// After: Centralized constants
class AppDimensions {
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 16.0;
}
Container(
  height: AppDimensions.spacingMedium,
  padding: EdgeInsets.all(AppDimensions.spacingSmall),
)
```

**Extract to**:
- `lib/constants/app_dimensions.dart` for sizes/spacing
- `lib/constants/app_strings.dart` for strings
- `lib/constants/app_durations.dart` for animation durations

#### E. Configuration Extraction
Move configuration to JSON/YAML files:
```dart
// Before: Hardcoded in code
String prompt = "You are an expert... very long prompt...";

// After: External configuration
// assets/config/prompts.json
{
  "analysis_prompt": "You are an expert...",
  "language_instructions": {
    "en": "Respond in English"
  }
}
```

**Extract to**:
- `assets/config/` for configuration files
- Load at runtime using `PromptsManager` or similar

### Step 4: Create Refactoring Plan

Organize extraction into phases:

**Phase 1: Critical Services**
- Extract core business logic
- Extract data processing
- Create service interfaces

**Phase 2: UI Components**
- Extract large widgets (>100 lines)
- Extract reusable components
- Create widget library

**Phase 3: Supporting Files**
- Extract constants
- Extract configuration
- Create utilities

**Phase 4: Polish**
- Add documentation
- Add unit tests
- Update architecture docs

### Step 5: Implementation Guidelines

#### File Organization
```
lib/
├── screens/
│   └── feature_screen.dart (200-500 lines max)
├── services/
│   └── feature/
│       ├── feature_service.dart
│       ├── feature_animation_controller.dart
│       └── feature_helper.dart
├── widgets/
│   └── feature/
│       ├── feature_overlay.dart
│       ├── feature_dialog.dart
│       └── feature_indicator.dart
├── constants/
│   ├── app_dimensions.dart
│   └── feature_constants.dart
└── config/
    └── feature_config.dart
```

#### Naming Conventions
- **Services**: `[Feature]Service`, `[Feature]Manager`, `[Feature]Controller`
- **Widgets**: `[Feature][Component]`, descriptive names
- **Files**: snake_case matching class name
- **Directories**: Plural for collections, singular for specific feature

#### Code Quality Rules
1. **Single Responsibility**: Each class/file does ONE thing
2. **DRY (Don't Repeat Yourself)**: Extract duplicated code
3. **KISS (Keep It Simple)**: Avoid over-engineering
4. **Dependency Injection**: Pass dependencies, don't create them
5. **Const Constructors**: Use `const` wherever possible
6. **Named Parameters**: Use named parameters for clarity

### Step 6: Testing Strategy

After refactoring, ensure:
```dart
// Service tests
test('ImageAnalysisService processes image correctly', () async {
  final service = ImageAnalysisService();
  final result = await service.processImage(mockImage, context: mockContext);
  expect(result.analysisResult, isNotNull);
});

// Widget tests
testWidgets('CameraScanOverlay displays correctly', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: CameraScanOverlay(
        isProcessing: false,
        onCameraTap: () {},
        onGalleryTap: () {},
      ),
    ),
  );
  expect(find.byType(CameraScanOverlay), findsOneWidget);
});
```

## Expected Outcomes

### Metrics Improvement
| Metric | Before | Target | Method |
|--------|--------|--------|--------|
| File Size | 1000-2000 lines | 300-500 lines | Extract services, widgets |
| Cyclomatic Complexity | 10-20 | 1-5 | Simplify methods, extract logic |
| Code Duplication | High | None | DRY principle |
| Test Coverage | Low | 70%+ | Unit tests for services |

### Quality Improvements
- ✅ Easier to understand (smaller files)
- ✅ Easier to test (isolated components)
- ✅ Easier to maintain (clear boundaries)
- ✅ Easier to extend (modular structure)
- ✅ Better performance (const constructors, lazy loading)

## Common Patterns from Experience

### Pattern 1: Screen with Camera + Analysis
**Problem**: 1500+ line screen with camera, animations, image processing

**Solution**:
```
Screen (300 lines) - State management, composition
├── CameraManager (100 lines) - Camera lifecycle
├── AnimationController (150 lines) - 9 animations
├── ImageAnalysisService (200 lines) - Processing logic
├── CameraScanOverlay (300 lines) - UI overlay
├── ProcessingOverlay (50 lines) - Loading dialog
└── Constants (50 lines) - Dimensions, durations
```

### Pattern 2: Duplicated Processing Methods
**Problem**: Two methods with 95% identical code (~400 lines total)

**Solution**:
- Extract common logic to service
- Use parameters for variations
- Single source of truth

### Pattern 3: Inline Animations
**Problem**: 10+ animations declared inline in screen

**Solution**:
- Create `[Feature]AnimationController` class
- Initialize all animations in one place
- Expose only necessary animations
- Dispose in single method

### Pattern 4: Hardcoded Prompts/Config
**Problem**: Large strings hardcoded in business logic

**Solution**:
- Move to `assets/config/prompts.json`
- Create `PromptsManager` to load
- Support variable substitution
- Enable hot updates without recompiling

## Bug Prevention During Refactoring

### Critical Checks
1. **UI Synchronization**: Use `await Future.delayed(Duration.zero)` after Navigator operations
2. **State Lifecycle**: Check `mounted` before calling `setState`
3. **Processing Dialogs**: Keep visible during navigation transitions
4. **Animation Disposal**: Always dispose controllers in `dispose()`
5. **Context Usage**: Don't use `context` across async gaps without checks

### Common Pitfalls
```dart
// ❌ BAD: Setting state before navigation
_isProcessing = false;
context.push('/next');

// ✅ GOOD: Keep state until after navigation
context.push('/next');
// Let next screen handle cleanup

// ❌ BAD: Using context after async
await someAsyncOperation();
context.push('/next'); // Context might be disposed

// ✅ GOOD: Check mounted
await someAsyncOperation();
if (mounted) {
  context.push('/next');
}
```

## Documentation Updates

After refactoring, update:
1. **ARCHITECTURE.md** - New structure, services, widgets
2. **[FEATURE]_REFACTORING.md** - Detailed refactoring guide
3. **CHANGELOG_REFACTORING.md** - Metrics, changes, fixes
4. **README.md** - Updated quick references

## Example: Real Refactoring (scanning_screen.dart)

### Before
- 📄 1,593 lines in single file
- 📊 Cyclomatic complexity: 8-12
- 🔁 ~400 lines of duplicated code
- ❌ Hard to test
- ❌ Hard to maintain

### After
- 📄 363 lines in main file (77% reduction)
- 📊 Cyclomatic complexity: 1-5 (60% reduction)
- 🔁 0 lines duplicated (100% elimination)
- ✅ 15 modular files
- ✅ Easy to test
- ✅ Easy to maintain

### Extracted Files (15)
**Services (4)**:
- `camera_manager.dart` (100 lines)
- `scanning_animation_controller.dart` (163 lines)
- `image_analysis_service.dart` (200 lines)
- `prompt_builder_service.dart` (100 lines)

**Widgets (6)**:
- `camera_scan_overlay.dart` (321 lines)
- `focus_indicator.dart` (50 lines)
- `camera_permission_denied.dart` (80 lines)
- `scanning_frame_painter.dart` (100 lines)
- `processing_overlay.dart` (60 lines)
- `joke_bubble_widget.dart` (70 lines)

**Constants (1)**:
- `app_dimensions.dart` (50 lines)

**Configuration (1)**:
- `prompts.json` (AI prompts)

**Documentation (3)**:
- `SCANNING_SCREEN_REFACTORING.md`
- `CHANGELOG_REFACTORING.md`
- Updated `ARCHITECTURE.md`

### Critical Bugs Fixed
1. ✅ Processing dialog not visible (state management)
2. ✅ UI synchronization issue (`Future.delayed(Duration.zero)`)
3. ✅ Missing ingredient translations (AI prompt)
4. ✅ Translation display logic (non-Latin detection)

## Skill Output Format

When executing this skill, provide:

1. **Initial Analysis**
   - Current file size and metrics
   - Identified complexity hotspots
   - Code duplication report

2. **Refactoring Plan**
   - Phase breakdown
   - Files to extract
   - Estimated line counts

3. **Implementation Steps**
   - Detailed extraction instructions
   - Code examples
   - Testing guidelines

4. **Expected Results**
   - Metrics comparison table
   - Quality improvements
   - Maintenance benefits

5. **Documentation Updates**
   - Files to create/update
   - Architecture changes
   - Changelog entries

## Tips for Success

1. **Start Small**: Extract one service/widget at a time
2. **Test Continuously**: Run tests after each extraction
3. **Keep it Running**: Ensure app works after each step
4. **Document as You Go**: Update docs immediately
5. **Review Metrics**: Verify complexity reduction
6. **Get Feedback**: Review with team before major changes

## References

- [Flutter Best Practices](https://flutter.dev/docs/development/best-practices)
- [Clean Code by Robert Martin](https://www.amazon.com/Clean-Code-Handbook-Software-Craftsmanship/dp/0132350882)
- [Refactoring by Martin Fowler](https://refactoring.com/)
- Project: `docs/SCANNING_SCREEN_REFACTORING.md` (real example)

---

**Skill Version**: 1.0
**Created**: January 2025
**Based on**: Real refactoring of scanning_screen.dart (1,593 → 363 lines)
