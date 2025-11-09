# ACS Design System Migration Plan

Step-by-step guide to migrate the entire app to the new Natural Beauty design system.

## 📋 Overview

This plan outlines the systematic migration from the current design to the new Natural Beauty theme based on Homepage Template 6.

---

## Phase 1: Foundation Setup ✅

### 1.1 Add Font Assets
- [ ] Download Lora font (Google Fonts)
- [ ] Download Open Sans font (Google Fonts)
- [ ] Add fonts to `assets/fonts/` directory
- [ ] Update `pubspec.yaml` with font declarations

```yaml
fonts:
  - family: Lora
    fonts:
      - asset: assets/fonts/Lora-Regular.ttf
      - asset: assets/fonts/Lora-Bold.ttf
        weight: 700
  - family: Open Sans
    fonts:
      - asset: assets/fonts/OpenSans-Regular.ttf
      - asset: assets/fonts/OpenSans-Medium.ttf
        weight: 500
      - asset: assets/fonts/OpenSans-SemiBold.ttf
        weight: 600
      - asset: assets/fonts/OpenSans-Bold.ttf
        weight: 700
```

### 1.2 Apply Global Theme
- [ ] Import `AppTheme` in `main.dart`
- [ ] Apply theme to `MaterialApp`

---

## Phase 2: Core Components (Priority 1)

### 2.1 AppBars (All Screens)
**Impact:** High visibility, affects all screens

**Files to update:**
- `lib/screens/home_screen.dart`
- `lib/screens/scanning_screen.dart`
- `lib/screens/analysis_results_screen.dart`
- `lib/screens/profile_screen.dart`
- `lib/screens/scan_history_screen.dart`
- `lib/screens/dialogue_list_screen.dart`
- `lib/screens/chat_ai_screen.dart`

**Changes:**
```dart
AppBar(
  backgroundColor: AppTheme.saddleBrown,  // Changed
  title: Text(
    'Title',
    style: TextStyle(
      color: Colors.white,
      fontFamily: AppTheme.fontFamilySerif,  // Added
      fontWeight: FontWeight.bold,
    ),
  ),
  iconTheme: IconThemeData(color: Colors.white),
)
```

**Estimate:** 2 hours

---

### 2.2 Background Colors
**Impact:** High visibility

**Changes:**
- Replace all `Scaffold` `backgroundColor` with `AppTheme.beige`
- Update any hardcoded backgrounds

**Estimate:** 1 hour

---

### 2.3 Primary Buttons & CTAs
**Impact:** High - affects user actions

**Files to update:**
- `lib/screens/home_screen.dart` - Main scan button
- `lib/screens/analysis_results_screen.dart` - "Discuss with AI" button
- `lib/screens/profile_screen.dart` - Save buttons
- `lib/screens/chat_ai_screen.dart` - Send button

**Before:**
```dart
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: Color(0xFF47EB99),
  ),
)
```

**After:**
```dart
Container(
  decoration: BoxDecoration(
    gradient: AppTheme.primaryGradient,
    borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
    boxShadow: [AppTheme.coloredShadow],
  ),
  child: ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
    ),
    ...
  ),
)
```

**Estimate:** 3 hours

---

## Phase 3: Cards & Lists (Priority 2)

### 3.1 Scan History Cards ✅
**Status:** Already updated with new design

**Verification needed:**
- [ ] Colors match theme
- [ ] Border radius is 18px
- [ ] Shadows are applied
- [ ] Typography uses theme fonts

---

### 3.2 Dialogue List Cards ✅
**Status:** Already updated with new design

**Verification needed:**
- [ ] Colors match theme
- [ ] Border radius is 18px
- [ ] Icons use theme colors

---

### 3.3 Analysis Results Screen
**Impact:** High - key information display

**File:** `lib/screens/analysis_results_screen.dart`

**Changes:**
1. Update score card gradient to use semantic colors
2. Apply theme typography
3. Update ingredient list styling
4. Add proper spacing using `AppTheme.space*`

**Estimate:** 4 hours

---

### 3.4 Profile Screen
**Impact:** Medium

**File:** `lib/screens/profile_screen.dart`

**Changes:**
1. Update form inputs to match theme
2. Apply theme colors to selections
3. Update section headers with Lora font
4. Add bordered cards for settings sections

**Estimate:** 3 hours

---

## Phase 4: Typography (Priority 3)

### 4.1 Headlines & Titles
**Impact:** High - brand identity

**Replace all occurrences:**

```dart
// Before
Text(
  'Title',
  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
)

// After
Text('Title', style: AppTheme.h2)
```

**Screens to update:**
- Home screen
- Analysis results
- Profile
- All major sections

**Estimate:** 3 hours

---

### 4.2 Body Text
**Impact:** Medium

**Replace with theme styles:**
- Primary text → `AppTheme.bodyLarge`
- Secondary text → `AppTheme.body`
- Captions → `AppTheme.caption`

**Estimate:** 2 hours

---

## Phase 5: Input Forms (Priority 4)

### 5.1 Profile Input Fields
**File:** `lib/screens/profile_screen.dart`

**Apply theme input decoration:**
```dart
TextField(
  decoration: InputDecoration(
    filled: true,
    fillColor: Colors.white.withValues(alpha: 0.9),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppTheme.radiusStandard),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppTheme.radiusStandard),
      borderSide: BorderSide(color: AppTheme.naturalGreen, width: 2),
    ),
  ),
)
```

**Estimate:** 2 hours

---

## Phase 6: Badges & Indicators (Priority 5)

### 6.1 Safety Score Indicators
**Files:**
- `lib/screens/analysis_results_screen.dart`
- `lib/screens/scan_history_screen.dart`

**Update risk badges:**
- High risk → Red with `Color(0xFFFFEBEE)` background
- Moderate → Orange with light orange background
- Safe → Green with `Color(0xFFE8F5E9)` background

**Estimate:** 2 hours

---

### 6.2 Score Display
**Add shield icon and semantic colors:**

```dart
Row(
  children: [
    Icon(
      Icons.shield_outlined,
      size: 14,
      color: scoreColor,
    ),
    SizedBox(width: AppTheme.space4),
    Text(
      '${score}/10',
      style: AppTheme.caption.copyWith(
        color: scoreColor,
        fontWeight: FontWeight.w600,
      ),
    ),
  ],
)
```

**Estimate:** 1 hour

---

## Phase 7: Special Components (Priority 6)

### 7.1 Home Screen Hero Section
**File:** `lib/screens/home_screen.dart`

**Create natural beauty hero:**
```dart
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
      'Embrace Your Natural Glow',
      style: AppTheme.h1,
    ),
    SizedBox(height: AppTheme.space12),
    Text(
      'Pure ingredients for a healthier you.',
      style: AppTheme.bodyLarge,
    ),
  ],
)
```

**Estimate:** 2 hours

---

### 7.2 Philosophy/Feature Cards
**Add to home screen:**

```dart
_buildPhilosophyCard(
  'Pure & Potent',
  'Harnessing the power of nature for your skin.',
  Icons.spa_outlined,
  AppTheme.naturalGreen,
)
```

**Estimate:** 2 hours

---

### 7.3 Chat UI
**File:** `lib/screens/chat_ai_screen.dart`

**Updates:**
- Message bubbles with natural colors
- Input field with theme styling
- Send button with gradient
- AI avatar with natural green

**Estimate:** 3 hours

---

## Phase 8: Navigation & Icons (Priority 7)

### 8.1 Bottom Navigation
**File:** `lib/widgets/bottom_navigation_wrapper.dart`

**Apply theme:**
```dart
BottomNavigationBar(
  backgroundColor: AppTheme.surfaceWhite,
  selectedItemColor: AppTheme.naturalGreen,
  unselectedItemColor: AppTheme.mediumBrown,
  ...
)
```

**Estimate:** 1 hour

---

### 8.2 Icon Updates
**Replace all icon colors:**
- Primary actions → `AppTheme.naturalGreen`
- Secondary actions → `AppTheme.mediumBrown`
- On primary surfaces → `Colors.white`

**Estimate:** 1 hour

---

## Phase 9: Final Polish (Priority 8)

### 9.1 Spacing Consistency
- [ ] Replace all hardcoded spacing with `AppTheme.space*`
- [ ] Verify padding is consistent (18px for cards)
- [ ] Check margins between sections

**Estimate:** 2 hours

---

### 9.2 Border Radius Consistency
- [ ] All cards: 18px
- [ ] Buttons: 16px
- [ ] Inputs: 16px
- [ ] Images: 8-12px

**Estimate:** 1 hour

---

### 9.3 Shadow Consistency
- [ ] Apply appropriate shadows to all cards
- [ ] Use colored shadows for CTAs
- [ ] Remove harsh shadows

**Estimate:** 1 hour

---

## 📊 Time Estimates Summary

| Phase | Estimated Time |
|-------|----------------|
| Phase 1: Foundation | 1 hour |
| Phase 2: Core Components | 6 hours |
| Phase 3: Cards & Lists | 7 hours |
| Phase 4: Typography | 5 hours |
| Phase 5: Input Forms | 2 hours |
| Phase 6: Badges & Indicators | 3 hours |
| Phase 7: Special Components | 7 hours |
| Phase 8: Navigation & Icons | 2 hours |
| Phase 9: Final Polish | 4 hours |
| Phase 10: Testing & QA | 7 hours |
| **Total** | **44 hours** |

---

## 🎯 Recommended Approach

### Option A: All at Once (Weekend Sprint)
- Allocate 2-3 days
- Complete phases sequentially
- Test thoroughly at the end
- **Pros:** Fast, consistent
- **Cons:** High risk if issues found

### Option B: Incremental (Recommended)
- Week 1: Phases 1-2 (Foundation & Core)
- Week 2: Phases 3-4 (Cards & Typography)
- Week 3: Phases 5-7 (Forms, Badges, Components)
- Week 4: Phases 8-10 (Navigation, Polish, Testing)
- **Pros:** Lower risk, easier to test
- **Cons:** Takes longer

### Option C: Priority-Based
1. Start with high-impact screens (Home, Analysis)
2. Move to medium-impact (Profile, History)
3. Finish with low-impact (Settings, About)
- **Pros:** Quick visual improvement
- **Cons:** Inconsistent during migration

---

## ✅ Success Criteria

Migration is complete when:
- [ ] All hardcoded colors replaced with theme constants
- [ ] All text uses theme typography
- [ ] All spacing uses theme scale
- [ ] All cards have 18px border radius
- [ ] All buttons use theme styles
- [ ] Contrast ratios meet WCAG AA
- [ ] Touch targets are minimum 48x48
- [ ] No console warnings about deprecated methods
- [ ] App builds without errors
- [ ] All screens visually match design system
- [ ] QA testing passes

---

## 📝 Notes

- Keep original code commented out during migration for easy rollback
- Test each screen after updates
- Create a branch for migration work
- Document any deviations from design system
- Update design system docs if patterns emerge that aren't documented

---

**Created:** 2025-01-08
**Last Updated:** 2025-01-08
