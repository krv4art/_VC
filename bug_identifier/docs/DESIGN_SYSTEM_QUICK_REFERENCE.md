# ACS Design System Quick Reference

This document provides a quick overview of the key design tokens and component usages within the ACS application, based on the Natural Beauty theme.

---

## 🎨 Color Palette

| Color Name | Hex Code | Usage |
|---|---|---|
| **Saddle Brown** | `#8B4513` | Primary brand color, AppBars, Primary buttons |
| **Natural Green** | `#4CAF50` | Accent color, Success states, Safe ingredients |
| **Light Green** | `#8BC34A` | Gradient starts, Active states |
| **Pale Green** | `#C3E0A1` | Gradient ends, Subtle backgrounds |
| **Beige** | `#F5F5DC` | Main background color |
| **Deep Brown** | `#6D4C41` | Primary text, Headlines |
| **Medium Brown** | `#8D6E63` | Secondary text, Descriptions |
| **Success / Safe** | `#4CAF50` | Semantic color |
| **Warning / Moderate Risk** | `#FF9800` | Semantic color |
| **Error / High Risk** | `#F44336` | Semantic color |
| **Info** | `#8BC34A` | Semantic color |
| **Neutral** | `#6D4C41` | Semantic color |
| **Light Grey** | `#E0E0E0` | Borders, disabled states |
| **Medium Grey** | `#BDBDBD` | Placeholder text, secondary icons |
| **Dark Grey** | `#757575` | Icons, subtle elements |
| **Surface White** | `#FFFFFF` | Card backgrounds, elevated surfaces |

---

## 🔤 Typography

### Font Families
- **Serif**: `Lora` (for headlines and branding)
- **Sans-serif**: `Open Sans` (for body text and UI)

### Text Styles (from `AppTheme`)
- `AppTheme.h1`: Page titles (Lora, 30px, Bold, Natural Green)
- `AppTheme.h2`: Section headers (Lora, 26px, Bold, Natural Green)
- `AppTheme.h3`: Card titles (Lora, 20px, Bold, Deep Brown)
- `AppTheme.h4`: Subsection headers (Open Sans, 18px, Bold, Deep Brown)
- `AppTheme.bodyLarge`: Primary body text (Open Sans, 16px, Regular, Deep Brown)
- `AppTheme.body`: Secondary body text (Open Sans, 15px, Regular, Medium Brown)
- `AppTheme.bodySmall`: Captions, labels (Open Sans, 13px, Regular, Medium Brown)
- `AppTheme.caption`: Metadata, timestamps (Open Sans, 12px, Medium, Medium Brown)
- `AppTheme.button`: Button labels (Open Sans, 16px, Bold)
- `AppTheme.buttonText`: Button labels (Open Sans, 16px, Bold, White)

---

## 📐 Spacing & Layout

### Spacing Scale (from `AppTheme`)
- `AppTheme.space4`: 4.0
- `AppTheme.space8`: 8.0
- `AppTheme.space12`: 12.0
- `AppTheme.space16`: 16.0
- `AppTheme.space18`: 18.0
- `AppTheme.space20`: 20.0
- `AppTheme.space24`: 24.0
- `AppTheme.space32`: 32.0
- `AppTheme.space40`: 40.0
- `AppTheme.space48`: 48.0

### Border Radius (from `AppTheme`)
- `AppTheme.radiusSmall`: 8.0 (images, thumbnails)
- `AppTheme.radiusMedium`: 12.0
- `AppTheme.radiusStandard`: 16.0 (cards, inputs, buttons)
- `AppTheme.radiusCard`: 18.0
- `AppTheme.radiusLarge`: 20.0 (hero cards, major CTAs)

---

## 🎭 Effects & Elevation

### Shadows (from `AppTheme`)
- `AppTheme.softShadow`: Soft shadow for cards
- `AppTheme.mediumShadow`: Medium shadow for elevated cards
- `AppTheme.coloredShadow`: Colored shadow for CTA buttons

---

## 🎯 Component Examples

### Primary Button (CTA)
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
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusStandard),
      ),
      textStyle: AppTheme.button,
    ),
    child: Text('Button Text', style: AppTheme.buttonText),
  ),
)
```

### AppBar
```dart
AppBar(
  backgroundColor: AppTheme.saddleBrown,
  foregroundColor: Colors.white,
  elevation: 0,
  centerTitle: true,
  title: Text(
    'Title',
    style: AppTheme.h3.copyWith(color: Colors.white),
  ),
  iconTheme: IconThemeData(color: Colors.white),
)
```

### Input Field
```dart
TextField(
  decoration: InputDecoration(
    filled: true,
    fillColor: AppTheme.surfaceWhite.withOpacity(0.9),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppTheme.radiusStandard),
      borderSide: BorderSide(color: AppTheme.mediumBrown, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppTheme.radiusStandard),
      borderSide: BorderSide(color: AppTheme.naturalGreen, width: 2),
    ),
    hintStyle: AppTheme.body.copyWith(color: AppTheme.mediumBrown.withOpacity(0.6)),
  ),
)
```

---

**Last Updated:** 2025-01-08
