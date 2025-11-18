# AI Background Remover

A powerful Flutter application for removing backgrounds and objects from photos using AI technology.

## Features

- **AI-Powered Background Removal**: Instantly remove backgrounds from your photos with advanced AI algorithms
- **Smart Object Eraser**: Intelligently remove unwanted objects from images
- **Custom Backgrounds**: Add solid colors or custom images as new backgrounds
- **Auto Enhancement**: Automatically improve image quality
- **Multiple Export Formats**: Save images as PNG (with transparency) or JPG
- **Processing History**: Keep track of all your processed images
- **Premium Features**: Unlock unlimited processing and advanced features

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

4. Run the app:
```bash
flutter run
```

## Project Structure

```
lib/
├── config/              # App configuration
├── constants/           # App constants
├── models/              # Data models
├── navigation/          # Navigation and routing
├── providers/           # State management (Provider)
├── screens/             # App screens
├── services/            # Business logic and services
├── theme/               # App theming
├── widgets/             # Reusable widgets
└── main.dart           # App entry point
```

## Architecture

This app uses the **Provider** pattern for state management and follows clean architecture principles:

- **Screens**: UI layer that displays data and handles user interactions
- **Providers**: State management layer that manages app state
- **Services**: Business logic layer that handles data processing
- **Models**: Data models that represent app entities

## Key Technologies

- **Flutter**: Cross-platform mobile framework
- **Provider**: State management
- **Go Router**: Navigation and routing
- **Image Processing**: Custom image manipulation algorithms
- **Supabase**: Backend and database
- **RevenueCat**: In-app purchases and subscriptions
- **Camera**: Camera access for photo capture
- **Image Picker**: Gallery access for photo selection

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

## Roadmap

- [ ] Advanced AI models for better background removal
- [ ] Batch processing support
- [ ] Cloud storage integration
- [ ] Social media sharing presets
- [ ] Video background removal
- [ ] AI-powered object detection
- [ ] Custom filters and effects
- [ ] Desktop support (Windows, macOS, Linux)

## Acknowledgments

- Flutter team for the amazing framework
- Image processing community for algorithms and techniques
- UI/UX inspiration from modern design systems

---

Made with ❤️ using Flutter
