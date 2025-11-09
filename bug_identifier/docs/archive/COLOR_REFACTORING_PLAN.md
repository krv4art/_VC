# Color Naming Refactoring Plan

## Current State Analysis

### Current Names → Actual Usage

| Current Name | Usage Pattern | New Semantic Name |
|--------------|---------------|-------------------|
| `saddleBrown` | Rarely used directly | `accentDark` |
| `naturalGreen` | Primary buttons, borders, active states | `primary` (keep) |
| `lightGreen` | Gradient color 1 | `primaryLight` |
| `paleGreen` | Gradient color 2 | `primaryPale` |
| `deepBrown` | Text on primary in dark theme | `onPrimaryDark` |
| `mediumBrown` | Secondary elements | `secondaryDark` |
| `mediumGrey` | Disabled/muted elements | `neutral` |

## Proposed New Color Scheme

```dart
abstract class AppColors {
  // === PRIMARY COLORS (Main accent - buttons, active states) ===
  Color get primary;           // Main brand color
  Color get primaryLight;      // Lighter shade for gradients
  Color get primaryPale;       // Palest shade for gradients
  Color get primaryDark;       // Darker shade (optional)

  // === SECONDARY COLORS (Supporting accent) ===
  Color get secondary;         // Secondary brand color
  Color get secondaryLight;    // Lighter secondary
  Color get secondaryDark;     // Darker secondary

  // === NEUTRAL COLORS (Gray scale) ===
  Color get neutral;           // Mid-gray for borders, disabled
  Color get neutralLight;      // Light gray
  Color get neutralDark;       // Dark gray

  // === BACKGROUND COLORS (Already good) ===
  Color get background;        // Main background
  Color get surface;           // Card/surface background
  Color get cardBackground;    // Specific for cards

  // === TEXT COLORS (On various backgrounds) ===
  Color get onBackground;      // Text on background
  Color get onSurface;         // Text on surface
  Color get onPrimary;         // Text on primary color
  Color get onSecondary;       // Text on secondary elements

  // === SEMANTIC COLORS (Already good) ===
  Color get success;           // Green for success
  Color get warning;           // Orange/yellow for warnings
  Color get error;             // Red for errors
  Color get info;              // Blue for info

  // === SPECIAL ===
  Color get shadowColor;       // For colored shadows
  Color get appBarColor;       // AppBar background
  Color get navBarColor;       // Navigation bar background

  // === GRADIENT ===
  LinearGradient get primaryGradient;  // Keep as is

  // === BRIGHTNESS ===
  Brightness get brightness;   // Keep as is
}
```

## Migration Strategy

### Phase 1: Add New Properties with Mapping
```dart
// In each color class (LightColors, DarkColors, etc.)

// NEW semantic names
@override
Color get primaryLight => const Color(0xFF81C784);

@override
Color get primaryPale => const Color(0xFFC8E6C9);

@override
Color get primaryDark => const Color(0xFF8D6E63);

@override
Color get secondary => const Color(0xFF795548);

@override
Color get secondaryLight => const Color(0xFFA1887F);

@override
Color get secondaryDark => const Color(0xFF5D4037);

@override
Color get neutral => const Color(0xFFBDBDBD);

@override
Color get neutralLight => const Color(0xFFE0E0E0);

@override
Color get neutralDark => const Color(0xFF757575);

// OLD names as DEPRECATED (remove later)
@Deprecated('Use primary instead')
Color get naturalGreen => primary;

@Deprecated('Use primaryLight instead')
Color get lightGreen => primaryLight;

@Deprecated('Use primaryPale instead')
Color get paleGreen => primaryPale;

@Deprecated('Use primaryDark instead')
Color get saddleBrown => primaryDark;

@Deprecated('Use secondaryDark instead')
Color get deepBrown => secondaryDark;

@Deprecated('Use secondary instead')
Color get mediumBrown => secondary;

@Deprecated('Use neutral instead')
Color get mediumGrey => neutral;
```

### Phase 2: Update ThemeExtension
```dart
// lib/theme/theme_extensions_v2.dart

class ThemeColors {
  // Add new getters
  Color get primary => currentColors.primary;
  Color get primaryLight => currentColors.primaryLight;
  Color get primaryPale => currentColors.primaryPale;
  Color get primaryDark => currentColors.primaryDark;
  Color get secondary => currentColors.secondary;
  Color get secondaryLight => currentColors.secondaryLight;
  Color get secondaryDark => currentColors.secondaryDark;
  Color get neutral => currentColors.neutral;
  Color get neutralLight => currentColors.neutralLight;
  Color get neutralDark => currentColors.neutralDark;

  // Keep old ones temporarily
  @Deprecated('Use primary instead')
  Color get naturalGreen => currentColors.naturalGreen;

  @Deprecated('Use primaryLight instead')
  Color get lightGreen => currentColors.lightGreen;

  // ... etc
}
```

### Phase 3: Find and Replace in Codebase

**Search patterns:**
- `context.colors.naturalGreen` → `context.colors.primary`
- `context.colors.lightGreen` → `context.colors.primaryLight`
- `context.colors.paleGreen` → `context.colors.primaryPale`
- `context.colors.saddleBrown` → `context.colors.primaryDark`
- `context.colors.deepBrown` → `context.colors.secondaryDark`
- `context.colors.mediumBrown` → `context.colors.secondary`
- `context.colors.mediumGrey` → `context.colors.neutral`

**Files to update (33 files):**
```
✅ lib/screens/scanning_screen.dart
✅ lib/screens/photo_confirmation_screen.dart
✅ lib/widgets/modern_drawer.dart
✅ lib/widgets/rating_request_dialog.dart
✅ lib/screens/chat_ai_screen.dart
✅ lib/screens/new_paywall_screen.dart
✅ lib/screens/theme_selection_screen.dart
✅ lib/screens/homepage_screen.dart
✅ lib/screens/profile_screen.dart
✅ lib/widgets/selection_card.dart
✅ lib/screens/allergies_screen.dart
✅ lib/screens/skin_type_screen.dart
✅ lib/screens/age_selection_screen.dart
✅ lib/screens/dialogue_list_screen.dart
✅ lib/screens/scan_history_screen.dart
✅ lib/widgets/scan_analysis_card.dart
✅ lib/screens/analysis_results_screen.dart
✅ lib/widgets/bot_joke_popup.dart
✅ lib/widgets/bottom_navigation_wrapper.dart
✅ lib/screens/usage_limits_test_screen.dart
✅ lib/widgets/usage_indicator_widget.dart
✅ lib/widgets/upgrade_banner_widget.dart
✅ lib/screens/modern_paywall_screen.dart
✅ lib/screens/ai_bot_settings_screen.dart
✅ lib/screens/language_screen.dart
✅ lib/widgets/custom_app_bar.dart
✅ lib/widgets/bot_avatar_picker.dart
✅ lib/screens/onboarding_screen.dart
✅ lib/widgets/animated/animated_button.dart
✅ lib/screens/rating_test_screen.dart
✅ lib/screens/theme_test_screen.dart
✅ lib/theme/app_theme.dart
✅ lib/theme/theme_extensions_v2.dart
```

### Phase 4: Remove Deprecated Names

After testing, remove all `@Deprecated` properties from `AppColors`.

## Testing Checklist

- [ ] All screens render correctly
- [ ] Theme switching works (light/dark)
- [ ] All preset themes work (Ocean, Forest, Sunset, etc.)
- [ ] Gradients render correctly
- [ ] Selected states have proper colors
- [ ] Button colors are correct
- [ ] Text contrast is maintained
- [ ] No compilation errors
- [ ] No runtime errors

## Benefits

1. **Clear semantic meaning**: Developer knows what color is for
2. **AI-friendly**: No color names that confuse AI generation
3. **Scalable**: Easy to add more accent levels
4. **Maintainable**: Clear hierarchy and purpose
5. **Flexible**: Can map any colors to roles

## Timeline

- **Phase 1**: 1 hour (add new properties)
- **Phase 2**: 30 min (update extensions)
- **Phase 3**: 2-3 hours (find/replace in 33 files)
- **Phase 4**: 30 min (remove deprecated)
- **Testing**: 1-2 hours

**Total: ~5-7 hours**
