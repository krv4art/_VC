# Animated AI Avatar Implementation Guide

## Overview

The animated AI avatar is a custom-designed molecular structure widget that serves as the visual representation of the AI assistant in the ACS (AI Cosmetics Scanner) application. The avatar features a dynamic hexagonal molecular structure with a pulsating center node, all rendered using Flutter's CustomPainter API.

## Design Concept

The avatar was designed to:
- **Represent Science**: Molecular hexagonal structure associates with chemistry and cosmetic ingredients
- **Be Inclusive**: Abstract design avoids race, gender, age biases
- **Show Intelligence**: Animation states convey AI activity (idle, thinking, speaking)
- **Adapt to Themes**: Colors dynamically change based on the active theme
- **Be Transparent**: No background circle, seamlessly blends with any UI

## Technical Implementation

### File Structure

```
lib/
├── widgets/
│   └── animated/
│       └── animated_ai_avatar.dart    # Main avatar widget and painter
├── screens/
│   ├── chat_ai_screen.dart           # Chat integration
│   └── chat_onboarding_screen.dart   # Onboarding integration
└── models/
    └── ai_bot_settings.dart          # Settings model with isAnimatedAvatar flag
```

### Core Components

#### 1. AnimatedAiAvatar Widget

**Location**: `lib/widgets/animated/animated_ai_avatar.dart`

**Constructor Parameters**:
```dart
AnimatedAiAvatar({
  double size = 40.0,              // Widget size in pixels
  AvatarAnimationState state,      // Animation state (idle, thinking, speaking)
  AppColors? colors,                // Theme colors (optional, auto-detected from context)
})
```

**Animation States**:
- **Idle**: Gentle pulsation (2 second cycle) - bot waiting
- **Thinking**: Fast rotation with shimmer (1 second cycle) - bot processing
- **Speaking**: Wave animation (1.5 second cycle) - bot responding

#### 2. Molecular Structure Design

**Proportions** (using Golden Ratio φ = 0.618):
```dart
nodeRadius = baseRadius * 0.618      // Distance of hexagon nodes from center
nodeSize = baseRadius * 0.087        // Size of outer nodes
centerSize = baseRadius * 0.28       // Base size of center node
strokeWidth = 1.82                   // Connection line thickness
```

**Pulsation Factors** (for Idle state):
```dart
centerSize *= (1.0 + 0.364 * sin(animationValue * 2π))  // Center node pulsation
glowIntensity = 0.8 + 0.2 * sin(animationValue * 2π)    // Glow intensity
```

**Maximum Pulsation Size**:
- At maximum: `centerSize = 0.28 * 1.364 ≈ 0.382 * baseRadius`
- This equals `0.618 * nodeRadius` (golden ratio relationship)

### Color Scheme

The avatar uses three colors from the active theme:

```dart
primary       // Hot Pink (#FF69B4 in Vibrant theme) - main color
primaryDark   // Purple (#8E24AA in Vibrant theme) - center node
secondary     // Orchid (#DA70D6 in Vibrant theme) - outer accents
```

**Color Application**:
- **Connection Lines**: `primary.withValues(alpha: 0.4)`
- **Outer Nodes**: Gradient from `primary` to `secondary`
- **Center Node**: Gradient from `primaryDark` → `primary` → `secondary`
- **Glow Effects**: Blur with reduced alpha for soft appearance

### Drawing Order

```dart
paint(Canvas canvas, Size size) {
  1. _drawBackgroundGradient()    // Empty (transparent background)
  2. _drawMolecularStructure()    // Hexagon nodes + connection lines
  3. _drawCenterNode()            // Pulsating center
}
```

## Integration Guide

### Step 1: Enable Animated Avatar in Settings

The avatar is set as default in `AiBotSettings`:

```dart
// lib/models/ai_bot_settings.dart
const AiBotSettings({
  this.isAnimatedAvatar = true,  // Default to animated avatar
  // ...
});
```

### Step 2: Use in UI

The avatar is integrated in three places:

#### A. Chat Screen (ChatAIScreen)

**Location**: `lib/screens/chat_ai_screen.dart:1587`

```dart
Widget _buildBotAvatar(AiBotProvider botProvider, BuildContext context, {
  required double radius,
  AvatarAnimationState? animationState,
}) {
  if (botProvider.isAnimatedAvatar) {
    return SizedBox(
      width: radius * 2,
      height: radius * 2,
      child: AnimatedAiAvatar(
        size: radius * 2,
        state: animationState ?? AvatarAnimationState.idle,
        colors: context.colors.currentColors,
      ),
    );
  }
  // ... static avatar fallback
}
```

**Usage**:
- **AppBar**: radius 20, state: idle
- **Typing Indicator**: radius 24, state: thinking
- **Message Bubbles**: radius 24, state: idle

#### B. Onboarding Screen (ChatOnboardingScreen)

**Location**: `lib/screens/chat_onboarding_screen.dart:469`

```dart
AnimatedAiAvatar(
  size: 56,  // radius 28
  state: _displayedCharCount < botMessage.length
      ? AvatarAnimationState.speaking
      : AvatarAnimationState.idle,
  colors: context.colors.currentColors,
)
```

**Behavior**: Switches to `speaking` state during typing animation, then `idle` when complete.

#### C. Avatar Picker (BotAvatarPicker)

**Location**: `lib/widgets/bot_avatar_picker.dart:69`

```dart
AnimatedAiAvatar(
  size: 64,
  state: AvatarAnimationState.idle,
  colors: context.colors.currentColors,
)
```

**Special ID**: `kAnimatedAvatarId = 'ANIMATED_AVATAR'`

### Step 3: Toggle Between Static and Animated

Users can switch avatars in settings:

```dart
// Select animated avatar
await context.read<AiBotProvider>().toggleAnimatedAvatar(true);

// Select static avatar
await context.read<AiBotProvider>().toggleAnimatedAvatar(false);
await context.read<AiBotProvider>().updateAvatar(avatarPath);
```

## Theme Integration

The avatar automatically adapts to theme changes:

```dart
// Colors are passed from context
colors: context.colors.currentColors

// Painter uses fallback if colors not provided
final primary = colors?.primary ?? const Color(0xFFFF69B4);
```

**Theme Examples**:
- **Vibrant**: Pink/Purple gradient
- **Ocean**: Cyan/Blue gradient
- **Forest**: Green/Lime gradient
- **Sunset**: Orange/Gold gradient
- **Natural**: Green/Beige gradient

## Performance Optimization

### Animation Controller

- Uses `SingleTickerProviderStateMixin` for efficient animation
- `repeat()` mode for continuous animation
- Different durations per state (idle: 2s, thinking: 1s, speaking: 1.5s)

### Custom Painter Optimization

```dart
@override
bool shouldRepaint(_MolecularAvatarPainter oldDelegate) {
  return oldDelegate.animationValue != animationValue ||
         oldDelegate.state != state ||
         oldDelegate.colors != colors;
}
```

Only repaints when animation value, state, or colors change.

### No External Dependencies

- No Lottie or Rive files
- Pure Dart/Flutter Canvas API
- Minimal app size impact (~300 lines of code)

## Design Rationale

### Why Molecular Structure?

1. **Scientific Association**: Molecules → Chemistry → Cosmetic Ingredients
2. **Uniqueness**: Competitors don't use this approach
3. **Scalability**: Works at any size (16px - 80px radius)
4. **Animation Potential**: Easy to animate rotation, pulsation, waves

### Why Golden Ratio (0.618)?

The golden ratio (φ ≈ 0.618) provides:
- Visually balanced proportions
- Harmonious relationship between elements
- Aesthetically pleasing to human perception
- Used throughout nature and design

### Why Transparent Background?

1. **Flexibility**: Blends with any background color
2. **Minimalism**: Reduces visual clutter
3. **Elegance**: Pure geometric form
4. **Performance**: Less rendering overhead

## Troubleshooting

### Avatar appears too small/large

Adjust the `radius` parameter in `_buildBotAvatar()`:

```dart
// Current values (as of implementation)
AppBar:           radius: 20
Chat messages:    radius: 24
Typing indicator: radius: 24
Onboarding:       radius: 28
Avatar picker:    size: 64
```

### Colors don't match theme

Ensure `colors` parameter is passed:

```dart
AnimatedAiAvatar(
  colors: context.colors.currentColors,  // Don't forget this!
  // ...
)
```

### Animation too fast/slow

Adjust duration in `_getDurationForState()`:

```dart
Duration _getDurationForState(AvatarAnimationState state) {
  switch (state) {
    case AvatarAnimationState.idle:
      return const Duration(milliseconds: 2000);  // Adjust here
    // ...
  }
}
```

### Pulsation too strong/weak

Adjust pulsation factor in `_drawCenterNode()`:

```dart
if (state == AvatarAnimationState.idle) {
  centerSize *= (1.0 + 0.364 * sin(...));  // Adjust 0.364
}
```

## Future Enhancements

### Possible Improvements

1. **Particle Effects**: Add floating particles around nodes
2. **Custom Colors**: Allow user-defined color schemes
3. **More States**: Add error, success, loading states
4. **3D Rotation**: Add depth perception with shadows
5. **Interaction**: Respond to tap/long-press gestures
6. **Sound**: Subtle audio feedback for state changes

### Performance Considerations

- Monitor FPS when multiple avatars visible simultaneously
- Consider reducing animation complexity on low-end devices
- Add option to disable animations in settings

## Credits

**Design Philosophy**: Based on beauty-tech AI best practices and scientific aesthetics
**Implementation**: Flutter CustomPainter with golden ratio proportions
**Default Theme**: Vibrant theme with hot pink accent (#FF69B4)

---

**Last Updated**: 2025-10-31
**Version**: 1.0.0
**Status**: ✅ Production Ready
