# Chat-style Onboarding Implementation

## Overview
Реализован новый экран онбординга в стиле чата, который персонализирует опыт пользователя через интерактивный диалог.

## Features

### 4-Step Onboarding Flow
1. **Welcome Step** - Бот представляется и пользователь нажимает "Let's Go"
2. **Skin Type Selection** - Выбор типа кожи (Normal, Dry, Oily, Combination, Sensitive)
3. **Age Selection** - Выбор возрастной группы (18-25, 26-35, 36-45, 46-55, 56+)
4. **Allergies Selection** - Выбор аллергий и чувствительностей (Fragrance, Parabens, Sulfates, и т.д.)

### UI Layout
```
┌─────────────────────────────────────┐
│                                     │
│    Bot Message Area (50% height)    │
│  - Bot avatar                       │
│  - Dynamic message based on step    │
│                                     │
├─────────────────────────────────────┤
│                                     │
│   Options Area (30% height)         │
│  - Wrap layout с mini buttons       │
│  - Icons + labels                   │
│                                     │
├─────────────────────────────────────┤
│  Step Indicator (4 dots)            │
│  Next/Finish Button                 │
│  (16px padding)                     │
└─────────────────────────────────────┘
```

### Mini Button Component
- Location: `lib/widgets/onboarding/chat_option_button.dart`
- Features:
  - Animated container with gradient on selection
  - Icon with label below
  - Smooth 200ms transition
  - Supports single and multi-select

## Implementation Details

### Files Created/Modified

1. **New Files:**
   - `lib/screens/chat_onboarding_screen.dart` - Main onboarding screen
   - `lib/widgets/onboarding/chat_option_button.dart` - Mini button component
   - `CHAT_ONBOARDING_IMPLEMENTATION.md` - This file

2. **Modified Files:**
   - `lib/navigation/app_router.dart` - Added `/chat-onboarding` route
   - `lib/l10n/app_*.arb` - Added localization strings for all languages

### Localization Keys Added
- `onboardingGreeting` - Bot greeting message
- `letsGo` - Button text for welcome step
- `next` - Next button text
- `finish` - Finish button text

Translations available in:
- English (en)
- Russian (ru)
- Ukrainian (uk)
- Spanish (es)
- German (de)
- French (fr)
- Italian (it)

## Data Flow

1. User answers 4 questions through interactive UI
2. Selections are stored in local state variables
3. On completion, data is saved to `UserState` using:
   - `userState.setSkinType()`
   - `userState.setAgeRange()`
   - `userState.setAllergies()`
4. Navigation to modern paywall screen

## Navigation

```dart
// To navigate to chat onboarding
context.push('/chat-onboarding');

// After completion, automatically navigates to
context.push('/modern-paywall');
```

## Customization

### To modify skin types:
Edit the `_skinTypes` list in `ChatOnboardingScreen`:
```dart
final List<Map<String, dynamic>> _skinTypes = [
  {'type': 'Normal', 'icon': Icons.face, 'description': 'Balanced'},
  // Add more types...
];
```

### To modify age ranges:
Edit the `_ageRanges` list similarly.

### To modify allergies:
Edit the `_commonAllergies` list.

## Theme Integration
- Uses `context.colors` extension for theme colors
- Supports both light and dark modes
- Gradient applied on selection for visual feedback
- Consistent with existing app design system

## Testing
To test the onboarding screen:
```dart
// Push to onboarding screen
context.push('/chat-onboarding');
```

The screen will:
1. Display bot greeting
2. Allow user to select through 4 steps
3. Save data to SharedPreferences via UserState
4. Navigate to paywall on completion
