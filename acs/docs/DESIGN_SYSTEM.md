# ACS Design System

## Overview

This document describes the design system implemented for the ACS (All-in-one Cosmetic Scanner) application. The design system is based on the 8-point grid system, which ensures consistent spacing, sizing, and alignment throughout the application.

## 8-Point Grid System

The 8-point grid system is the foundation of our design system. All spacing, sizing, and dimensions are multiples of 8px (0.5rem). This creates visual harmony and ensures that the UI is properly aligned on all screen sizes.

### Base Unit

- **Base Unit**: 8px (0.5rem)
- **Usage**: All spacing, sizing, and dimensions should be multiples of 8px

### Spacing Scale

| Scale | Value | Usage |
|--------|--------|--------|
| 4px | 8px | Small gaps, tight spacing |
| 8px | 16px | Standard spacing, padding |
| 12px | 24px | Medium spacing, section padding |
| 16px | 32px | Large spacing, container padding |
| 24px | 48px | Extra large spacing, hero sections |

## Implementation

### Constants

All spacing and sizing constants are defined in `lib/constants/app_dimensions.dart`:

```dart
class AppDimensions {
  // Base spacing
  static const double space4 = 4.0;
  static const double space8 = 8.0;
  static const double space12 = 12.0;
  static const double space16 = 16.0;
  static const double space24 = 24.0;
  static const double space32 = 32.0;
  static const double space40 = 40.0;
  static const double space48 = 48.0;
  static const double space64 = 64.0;
  
  // Border radius
  static const double radius4 = 4.0;
  static const double radius8 = 8.0;
  static const double radius12 = 12.0;
  static const double radius16 = 16.0;
  static const double radius24 = 24.0;
  
  // Avatar sizes
  static const double avatarSmall = 20.0;
  static const double avatarMedium = 32.0;
  static const double avatarLarge = 56.0;
  
  // Button sizes
  static const double buttonSmall = 32.0;
  static const double buttonMedium = 40.0;
  static const double buttonLarge = 48.0;
}
```

### Spacers

For consistent spacing, use the `AppSpacer` widget from `lib/widgets/common/app_spacer.dart`:

```dart
class AppSpacer {
  const AppSpacer._();
  
  // Vertical spacing
  static Widget v4() => const SizedBox(height: AppDimensions.space4);
  static Widget v8() => const SizedBox(height: AppDimensions.space8);
  static Widget v12() => const SizedBox(height: AppDimensions.space12);
  static Widget v16() => const SizedBox(height: AppDimensions.space16);
  static Widget v24() => const SizedBox(height: AppDimensions.space24);
  static Widget v32() => const SizedBox(height: AppDimensions.space32);
  static Widget v48() => const SizedBox(height: AppDimensions.space48);
  static Widget v64() => const SizedBox(height: AppDimensions.space64);
  
  // Horizontal spacing
  static Widget h4() => const SizedBox(width: AppDimensions.space4);
  static Widget h8() => const SizedBox(width: AppDimensions.space8);
  static Widget h12() => const SizedBox(width: AppDimensions.space12);
  static Widget h16() => const SizedBox(width: AppDimensions.space16);
  static Widget h24() => const SizedBox(width: AppDimensions.space24);
  static Widget h32() => const SizedBox(width: AppDimensions.space32);
  static Widget h48() => const SizedBox(width: AppDimensions.space48);
}
```

## Usage Guidelines

### Spacing

Instead of using hardcoded values, use the constants from `AppDimensions`:

```dart
// ❌ Don't do this
padding: const EdgeInsets.all(16.0),

// ✅ Do this
padding: EdgeInsets.all(AppDimensions.space16),
```

### Border Radius

Use the predefined border radius constants:

```dart
// ❌ Don't do this
BorderRadius.circular(12.0),

// ✅ Do this
BorderRadius.circular(AppDimensions.radius12),
```

### SizedBox

Use the `AppSpacer` widget for consistent spacing:

```dart
// ❌ Don't do this
const SizedBox(height: 16.0),

// ✅ Do this
AppSpacer.v16(),
```

## Refactoring Progress

The following components have been refactored to use the 8-point grid system:

### Completed

1. **Constants** (`lib/constants/app_dimensions.dart`)
   - Created comprehensive spacing and sizing constants
   - All values follow the 8-point grid system

2. **Spacers** (`lib/widgets/common/app_spacer.dart`)
   - Created reusable spacer widgets
   - Provides consistent vertical and horizontal spacing

3. **High Priority Screens**
   - `chat_ai_screen.dart`
   - `chat_onboarding_screen.dart`
   - `ai_bot_settings_screen.dart`
   - All hardcoded values replaced with constants

4. **Reusable Widgets**
   - `bot_avatar_picker.dart`
   - `bot_joke_popup.dart`
   - All hardcoded values replaced with constants

5. **Theme Data** (`lib/theme/app_theme.dart`)
   - Updated to use constants from `AppDimensions`
   - All spacing and sizing now follows the 8-point grid system

### In Progress

1. **Animated Widgets**
   - `animated_ai_avatar.dart`
   - Partially refactored (some constants applied)
   - Syntax errors encountered during refactoring

## Benefits

1. **Consistency**: All UI elements follow the same spacing rules
2. **Maintainability**: Changes to spacing can be made in one place
3. **Scalability**: Easy to adjust the entire design system by modifying constants
4. **Developer Experience**: Clear guidelines for spacing and sizing

## Next Steps

1. Complete refactoring of remaining animated widgets
2. Apply the design system to all remaining screens and components
3. Create additional utility widgets as needed
4. Establish design review process to ensure compliance

## Files Structure

```
lib/
├── constants/
│   └── app_dimensions.dart
├── widgets/
│   └── common/
│       └── app_spacer.dart
├── theme/
│   └── app_theme.dart
└── screens/
    ├── chat_ai_screen.dart
    ├── chat_onboarding_screen.dart
    ├── ai_bot_settings_screen.dart
    └── ...
