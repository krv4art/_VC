# App Icon Guide

## Required File
`logo.png` - Main app icon for all platforms

## Specifications
- **Format**: PNG with transparency (or JPG for simpler design)
- **Size**: **1024x1024px** (high resolution source)
- **Design**: Should represent plant/botanical theme
- **Colors**: Green-focused palette matching app theme

## Icon Suggestions

### Design Ideas:
1. **Leaf icon** - Simple, recognizable leaf silhouette
2. **Plant in pot** - Potted plant illustration
3. **Magnifying glass + leaf** - Identification concept
4. **Camera + plant** - Photo identification theme
5. **Botanical symbol** - Scientific/botanical icon

### Design Tools:
- **Figma/Sketch** - Professional design
- **Canva** - Easy online templates
- **AI Generation** - DALL-E, Midjourney:
  - Prompt: "App icon, simple leaf symbol, green gradient, minimalist, botanical, 1024x1024px"

### Color Palette (from app theme):
- Primary Green: `#4CAF50`
- Dark Green: `#388E3C`
- Light Green: `#81C784`
- Background: White or transparent

## Generation Steps

### Option 1: Using flutter_launcher_icons (Recommended)
1. Place `logo.png` (1024x1024) in `assets/icon/`
2. Run: `flutter pub run flutter_launcher_icons`
3. Icons will be generated for all platforms automatically

### Option 2: Manual Platform Icons
- **Android**: `android/app/src/main/res/mipmap-*/ic_launcher.png`
- **iOS**: `ios/Runner/Assets.xcassets/AppIcon.appiconset/`
- **Web**: `web/icons/Icon-*.png`

## After Adding Icon
Run this command to generate platform-specific icons:
```bash
flutter pub run flutter_launcher_icons
```

## Temporary Placeholder
Until you add a real icon, the app will use default Flutter icon.

## Resources
- [Flutter Icon Generator](https://icon.kitchen/)
- [App Icon Template](https://appicon.co/)
- [Icon Design Guidelines](https://developer.android.com/google-play/resources/icon-design-specifications)
