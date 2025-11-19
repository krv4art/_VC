# AI Background Remover

A powerful, production-ready Flutter application for removing backgrounds and objects from photos using advanced AI technology.

## ✨ Features

### 🎨 Core Features
- **AI-Powered Background Removal**: Multiple AI providers (Remove.bg API, Supabase Edge Functions, TensorFlow Lite, Local algorithms)
- **Smart Object Eraser**: Intelligently remove unwanted objects from images
- **Advanced Image Editing**: Crop, rotate, resize, flip, and refine images
- **Rich Filters Library**: 12+ professional filters (Grayscale, Sepia, Vintage, Vivid, Cool, Warm, etc.)
- **Edge Refinement**: Manual tools for perfect edge cleanup
- **Auto Enhancement**: Automatic image quality improvement with adjustable parameters

### 🌈 Background Features
- **200+ Background Presets**: Categorized library of solid colors, gradients, and patterns
- **Custom Backgrounds**: Upload your own images or create custom gradients
- **Background Blur**: Bokeh-style background blur effect
- **Gradient Editor**: Create custom linear, radial, and sweep gradients
- **Professional Templates**: Business cards, social media, e-commerce presets

### 📦 Advanced Features
- **Batch Processing**: Process multiple images simultaneously with progress tracking
- **Before/After Comparison**: Interactive slider to compare original and processed images
- **Image Caching**: Smart LRU cache system (100MB) for faster reprocessing
- **Cloud Storage**: Supabase integration for premium users
- **Processing History**: Search, filter, and group processed images by date
- **Multi-language Support**: Full localization (English, Russian)

### 💎 Premium Features
- Unlimited image processing (vs 5/day free tier)
- High-quality exports (no compression)
- Priority processing queue
- Cloud storage & sync (50GB)
- Batch processing (up to 50 images)
- Ad-free experience
- Premium backgrounds and filters
- Advanced editing tools

## Screenshots

| Onboarding | Home | Editor | Result |
|------------|------|--------|--------|
| ![Onboarding](assets/screenshots/onboarding.png) | ![Home](assets/screenshots/home.png) | ![Editor](assets/screenshots/editor.png) | ![Result](assets/screenshots/result.png) |

## Getting Started

### Prerequisites

- Flutter SDK (^3.8.1)
- Dart SDK
- Android Studio / Xcode (for mobile development)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/ai_background_remover.git
cd ai_background_remover
```

2. Install dependencies:
```bash
flutter pub get
```

3. Create a `.env` file in the root directory and add your API keys:
```env
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key
REVENUECAT_API_KEY=your_revenuecat_api_key
REMOVE_BG_API_KEY=your_remove_bg_api_key
```

4. Generate localization files:
```bash
flutter gen-l10n
```

5. Run the app:
```bash
flutter run
```

## 📁 Project Structure

```
lib/
├── constants/           # App constants and configuration
├── l10n/                # Localization files (ARB)
│   ├── app_en.arb       # English translations
│   └── app_ru.arb       # Russian translations
├── models/              # Data models
│   ├── processing_options.dart
│   ├── processed_image.dart
│   └── background_preset.dart
├── navigation/          # Navigation and routing (GoRouter)
├── providers/           # State management (Provider pattern)
│   ├── image_processing_provider.dart
│   ├── premium_provider.dart
│   └── theme_provider.dart
├── screens/             # App screens (9 screens)
│   ├── splash_screen.dart
│   ├── onboarding_screen.dart
│   ├── home_screen.dart
│   ├── editor_screen.dart
│   ├── result_screen.dart
│   ├── history_screen.dart
│   ├── settings_screen.dart
│   ├── premium_screen.dart
│   ├── privacy_policy_screen.dart
│   └── terms_of_service_screen.dart
├── services/            # Business logic and services
│   ├── ai_background_removal_service.dart  # Multi-provider AI service
│   ├── image_processing_service.dart       # Core image processing
│   ├── image_editor_service.dart           # Crop, rotate, resize, filters
│   ├── background_service.dart             # Background application
│   ├── batch_processing_service.dart       # Batch processing
│   ├── cache_service.dart                  # Smart caching system
│   ├── database_service.dart               # SQLite database
│   ├── analytics_service.dart              # Firebase Analytics
│   ├── ad_service.dart                     # Google AdMob
│   └── rating_service.dart                 # App rating
├── theme/               # App theming (Material 3)
├── widgets/             # Reusable widgets
│   ├── feature_card.dart
│   ├── rating_dialog.dart
│   └── before_after_slider.dart
└── main.dart            # App entry point
```

## Architecture

This app uses the **Provider** pattern for state management and follows clean architecture principles:

- **Screens**: UI layer that displays data and handles user interactions
- **Providers**: State management layer that manages app state
- **Services**: Business logic layer that handles data processing
- **Models**: Data models that represent app entities

## 🛠️ Key Technologies

### Core Framework
- **Flutter** (^3.8.1): Cross-platform mobile framework
- **Dart**: Programming language
- **Material Design 3**: Modern UI components

### State Management & Navigation
- **Provider** (^6.1.2): State management
- **GoRouter** (^14.6.2): Declarative routing

### Image Processing
- **image** (^4.1.7): Core image manipulation
- **flutter_image_compress** (^2.3.0): Image compression
- **TensorFlow Lite** (^0.11.0): On-device ML inference
- **image_gallery_saver** (^2.0.3): Save to gallery
- **camera** (^0.11.0+2): Camera access
- **image_picker** (^1.1.2): Gallery picker

### Backend & AI
- **Supabase** (^2.8.0): Backend, database, edge functions
- **Remove.bg API**: Cloud-based background removal
- **HTTP** (^1.2.2): API requests with retry logic

### Analytics & Monetization
- **Firebase Core** (^3.8.1): Firebase initialization
- **Firebase Analytics** (^11.3.5): Usage analytics
- **Firebase Crashlytics** (^4.2.0): Crash reporting
- **Google Mobile Ads** (^5.2.0): AdMob integration
- **RevenueCat** (^8.2.3): Subscription management

### UI Components
- **google_fonts** (^6.2.1): Custom fonts
- **flutter_svg** (^2.0.10+1): SVG rendering
- **lottie** (^3.1.2): Animations
- **flutter_animate** (^4.5.0): Micro-interactions

### Storage & Caching
- **sqflite** (^2.3.3): SQLite database
- **shared_preferences** (^2.3.3): Key-value storage
- **path_provider** (^2.1.3): File system paths

### Utilities
- **flutter_dotenv** (^5.2.1): Environment variables
- **url_launcher** (^6.3.1): URL handling
- **share_plus** (^10.1.2): Share functionality
- **permission_handler** (^11.3.1): Runtime permissions
- **crypto** (^3.0.3): MD5 hashing for cache keys

## Features in Detail

### Processing Modes

1. **Remove Background**: Completely remove the background from images
2. **Remove Object**: Selectively remove unwanted objects
3. **Auto Enhance**: Automatically improve image quality
4. **Smart Erase**: Intelligently erase selected areas

### Background Options

- Transparent (PNG)
- Solid colors (White, Black, Custom)
- Gradient backgrounds
- Custom image backgrounds

### Export Options

- PNG with transparency
- JPG with white background
- JPG with custom background
- Adjustable quality settings

## Premium Features

- Unlimited image processing
- High-quality exports
- Priority processing
- Cloud storage
- Batch processing
- Ad-free experience

## Development

### Running Tests

```bash
flutter test
```

### Building for Release

Android:
```bash
flutter build apk --release
```

iOS:
```bash
flutter build ios --release
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

For support, email support@example.com or open an issue in the repository.

## 📚 API Documentation

### AI Background Removal Service

```dart
final aiService = AIBackgroundRemovalService();

// Remove background with auto provider selection
final result = await aiService.removeBackground(
  imageFile: imageFile,
  isPremium: true,
);

// Use specific provider
final result = await aiService.removeBackground(
  imageFile: imageFile,
  preferredProvider: AIProvider.removeBg,
  isPremium: true,
);
```

### Image Editor Service

```dart
final editorService = ImageEditorService();

// Crop image
final cropped = await editorService.cropImage(
  imageFile,
  Rect.fromLTWH(0, 0, 500, 500),
);

// Apply filter
final filtered = await editorService.applyFilter(
  imageFile,
  ImageFilter.vintage,
  intensity: 0.8,
);

// Rotate image
final rotated = await editorService.rotateImage(imageFile, 90);
```

### Background Service

```dart
final bgService = BackgroundService();

// Apply preset background
final result = await bgService.applyBackground(
  foregroundFile,
  BackgroundPresets.sunsetGradient,
);

// Create custom gradient
final gradient = await bgService.createCustomGradient(
  width: 1080,
  height: 1920,
  colors: [Colors.blue, Colors.purple],
  type: GradientType.linear,
);
```

### Batch Processing

```dart
final batchService = BatchProcessingService();

// Process multiple images in parallel
final results = await batchService.processBatchParallel(
  images,
  options,
  maxConcurrent: 3,
  onProgress: (current, total) {
    print('Processing $current of $total');
  },
);
```

### Cache Service

```dart
final cacheService = CacheService();
await cacheService.initialize();

// Cache processed image
await cacheService.cacheImage(
  originalPath: originalFile.path,
  processedFile: processedFile,
  options: {'mode': 'remove_bg'},
);

// Retrieve cached image
final cached = await cacheService.getCachedImage(
  originalPath: originalFile.path,
  options: {'mode': 'remove_bg'},
);

// Get cache statistics
final stats = await cacheService.getCacheStats();
print('Cache size: ${stats['totalSizeMB']} MB');
```

## 🗺️ Roadmap

### ✅ Completed
- [x] AI-powered background removal (multiple providers)
- [x] Advanced image editing tools
- [x] Batch processing support
- [x] Rich background library
- [x] Before/after comparison slider
- [x] Multi-language support
- [x] Image caching system
- [x] Firebase Analytics & Crashlytics
- [x] AdMob integration
- [x] Privacy Policy & Terms of Service

### 🚧 In Progress
- [ ] RevenueCat subscription setup
- [ ] Cloud storage integration
- [ ] History search and filtering
- [ ] Offline mode support

### 📋 Planned
- [ ] Video background removal
- [ ] AI-powered object detection & selection
- [ ] Social media sharing presets
- [ ] Desktop support (Windows, macOS, Linux)
- [ ] Web version
- [ ] Background templates marketplace
- [ ] Collaborative editing
- [ ] API for third-party integration

## Acknowledgments

- Flutter team for the amazing framework
- Image processing community for algorithms and techniques
- UI/UX inspiration from modern design systems

---

Made with ❤️ using Flutter
