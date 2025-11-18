# Animations and User Experience Guide

## Overview

The Antique Identifier app features smooth, elegant animations that enhance the user experience throughout the application. This document describes all animation implementations.

## Page Transition Animations

### Navigation System (main.dart)

All screen transitions use custom page animations defined in `main.dart`:

#### 1. **Slide Transition** (Primary Navigation)
- Used for: Scan, Results, Chat, History screens
- **Animation**: Slides from right to left with fade-in
- **Duration**: 400ms
- **Easing**: easeInOutCubic
- **Effect**:
  - Starts at horizontal offset (1, 0) moving to (0, 0)
  - Opacity fades from 0.8 to 1.0
  - Creates smooth, professional navigation flow

```dart
_buildSlideTransition(context, state, const ScanScreen())
// Results in: → (slide) + ↑ (fade) animation
```

#### 2. **Fade Transition** (Home Screen)
- Used for: Home screen entry
- **Animation**: Pure fade-in effect
- **Duration**: 300ms
- **Easing**: easeInOutCubic
- **Effect**: Subtle appearance of home screen

## Widget Animation System

### AnimatedEntrance Widget (lib/widgets/animated_entrance.dart)

Reusable animated entrance widget for any content. Features:

#### **Properties**:
- `delay`: Delay before animation starts (default: 0ms)
- `duration`: Animation duration (default: 600ms)
- `beginOffset`: Starting position offset (default: 20px down)

#### **How It Works**:
1. Fades in from 0 to 1 opacity
2. Slides up from `beginOffset` to zero offset
3. Uses `easeOutCubic` curve for natural feel

#### **Usage Example**:
```dart
AnimatedEntrance(
  delay: const Duration(milliseconds: 200),
  duration: const Duration(milliseconds: 500),
  child: YourWidget(),
)
```

### AnimatedListBuilder Widget

Helper for animating list items with staggered delays:

```dart
AnimatedListBuilder(
  itemCount: 5,
  itemDelay: const Duration(milliseconds: 100),
  itemBuilder: (context, index) => ListItem(index: index),
)
```

Each item appears with 100ms delay between them.

### AnimatedScaleButton Widget

Button that scales down (95%) on press for tactile feedback:
- Provides visual feedback without complexity
- Auto-reverts on release
- Smooth easing curves

## Screen-Specific Animations

### Results Screen (`lib/screens/results_screen.dart`)

Content appears in cascading sequence:

| Section | Delay | Notes |
|---------|-------|-------|
| Header | 0ms | Item name, category, period |
| Warnings | 100ms | Important notes banner |
| Description | 200ms | Item description text |
| Materials | 300ms | Materials list |
| Historical Context | 400ms | History section |
| Price Estimate | 500ms | Valuation info |
| Similar Items | 600ms | Comparison items |
| Chat Button | 700ms | AI expert chat CTA |
| Save Button | 800ms | Collection save CTA |

**Visual Effect**: Elegant cascade where each section smoothly fades and slides up as the user sees it.

### Chat Screen (`lib/screens/chat_screen.dart`)

Message animations:
- **Each message**: Fades and slides up with 50ms stagger between messages
- **Duration**: 400ms per message
- **Effect**: Messages appear naturally as user reads

### History Screen (`lib/screens/history_screen.dart`)

List animations:
- **Each card**: Fades and slides up
- **Delay between cards**: 100ms (staggered)
- **Duration**: 500ms per card
- **Effect**: List builds smoothly as user navigates in

## Performance Considerations

### Animation Best Practices Used

1. **Hardware Acceleration**: All animations use GPU-accelerated properties
   - Opacity: ✓ Hardware accelerated
   - Transform/Offset: ✓ Hardware accelerated
   - No repaints of expensive widgets

2. **Duration Balance**:
   - Fast (300ms): Home screen fade
   - Standard (400-500ms): Most animations
   - Cascading: Minimal delay between items

3. **Resource Usage**:
   - Single AnimationController per widget
   - Disposed properly to prevent memory leaks
   - No animation loops (all have defined endpoints)

4. **Curve Selection**:
   - `Curves.easeInOutCubic`: Smooth, natural feel
   - `Curves.easeOut`: Entrance animations
   - Professional smooth curves, no jarring effects

## Customization

### Change Global Durations

Edit transition builders in `main.dart`:
```dart
transitionDuration: const Duration(milliseconds: 400), // Change here
```

### Adjust Entrance Animations

Modify `AnimatedEntrance` calls in screens:
```dart
AnimatedEntrance(
  delay: const Duration(milliseconds: 300), // Adjust stagger
  duration: const Duration(milliseconds: 600), // Adjust speed
  child: Widget(),
)
```

### Add New Animations

1. Create new animation widget in `lib/widgets/`
2. Import in target screen
3. Wrap desired widgets

Example:
```dart
import '../widgets/my_custom_animation.dart';

MyCustomAnimation(
  child: ImportantWidget(),
)
```

## Testing Animations

### Manual Testing Checklist

- [ ] Navigate between all screens - transitions should be smooth
- [ ] Go to Results screen - sections should cascade in order
- [ ] Send messages in Chat - messages should slide up
- [ ] View History - cards should animate in sequence
- [ ] Check on slower devices - animations should not stutter
- [ ] Test with slow animations enabled (Settings) - should adapt

### Performance Testing

```bash
flutter run --profile  # Run in profile mode to test performance
```

Monitor for:
- Dropped frames in timeline profiler
- Jank in performance overlay (S key)
- Smooth 60 FPS animations

## Accessibility

- Animations respect system settings (MediaQuery.disableAnimations)
- No animation blocks interaction (all non-blocking)
- Animations enhance, not distract from content
- Fast animations for impatient users on slower devices

## Future Enhancement Ideas

1. **Spring Physics**: Replace linear curves with spring animations
2. **Gesture-driven**: Animations responsive to user swipes
3. **Parallax**: Different layers moving at different speeds
4. **Shared Element Transitions**: Hero animations for images
5. **Scroll Animations**: Content animates as user scrolls

## References

- Flutter Animation Documentation: https://flutter.dev/docs/development/ui/animations
- Curve Guide: https://api.flutter.dev/flutter/animation/Curves-class.html
- AnimationController: https://api.flutter.dev/flutter/animation/AnimationController-class.html
