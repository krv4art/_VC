# AI Apps Monorepo

[![Flutter](https://img.shields.io/badge/Flutter-3.x-blue)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.x-blue)](https://dart.dev/)
[![License](https://img.shields.io/badge/license-MIT-green)](LICENSE)

> A Flutter monorepo housing multiple AI-driven mobile and web applications sharing the ACS (AI Cosmetic Scanner) architecture.

## 📱 Applications

### [ACS - AI Cosmetic Scanner](./acs)
AI-powered cosmetic ingredient analyzer with personalized skin care recommendations.
- 📸 Smart label scanning with camera/gallery
- 🤖 AI analysis powered by Google Gemini 2.0 Flash
- ⚠️ Safety scoring (0-10 scale) and ingredient breakdown
- 👤 Personalized warnings based on skin type
- 💬 AI chat assistant with context

**Status:** ✅ Production | **Languages:** 31+ | **Platform:** Mobile, Web

---

### [Bug Identifier](./bug_identifier)
AI-powered insect recognition app built on the ACS architecture.
- 🐛 Insect identification with taxonomy details
- 🌿 Nature-inspired theming
- 📚 Entomology data models
- 🔍 AI-driven recognition with Gemini

**Status:** ✅ Production | **Platform:** Mobile, Web

---

### [Plant Identifier](./plant_identifier)
Plant and mushroom identification with AI-driven care guidance.
- 🌱 Plant and mushroom recognition
- 📖 Care guides and recommendations
- 🏡 Personalization (location, garden type, experience)
- 🎨 Multiple botanical themes
- 📜 History storage

**Status:** ✅ Production | **Platform:** Mobile, Web

---

### [MAS - Math AI Solver](./MAS)
Photo-based equation solver with step-by-step solutions.
- 🧮 Solve math problems from photos
- ✅ Solution validation and checking
- 💪 Training problem generation
- 💬 Math-focused AI chat
- 📏 Unit converter

**Status:** ✅ Production | **Platform:** Mobile, Web

---

### [Unseen](./unseen)
Privacy-first notification listener for capturing messages without read receipts.
- 🔒 Privacy-first message capture
- 📱 Popular messenger support
- 💾 Local persistence
- ⭐ Premium tier support
- 🌐 Broad localization

**Status:** ✅ Production | **Platform:** Mobile

---

### [AI Background Changer](./ai_background_changer)
AI-powered background removal and replacement tool with smart scene generation.
- 🎨 Smart background removal using AI
- 🌄 Creative background styles and custom prompts
- 🤖 AI assistant for creative suggestions
- 📸 Camera and gallery support
- 💾 History and favorites
- 🔄 Share processed images

**Status:** 🚧 Development | **Platform:** Mobile, Web

---

## 🏗️ Architecture

All applications share a common architecture pattern:

```
lib/
├── models/          # Data models
├── services/        # Business logic & API integration
├── providers/       # State management (Provider pattern)
├── screens/         # UI screens
├── widgets/         # Reusable UI components
├── theme/          # Theming & styling
├── navigation/     # Routing (go_router)
├── config/         # App configuration
├── l10n/           # Localization files
└── main.dart       # App entry point
```

### Shared Technologies

- **Framework:** Flutter 3.x
- **Language:** Dart 3.x
- **State Management:** Provider
- **Navigation:** go_router
- **Storage:** sqflite / sqflite_ffi_web
- **AI Backend:** Google Gemini via Supabase Edge Functions
- **Subscriptions:** RevenueCat (where applicable)
- **Localization:** Flutter intl (30+ languages)

## 🚀 Quick Start

### Prerequisites

- Flutter SDK 3.x or higher
- Dart SDK 3.x or higher
- Android Studio / Xcode (for mobile)
- Chrome (for web)

### Setup

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd <repository-name>
   ```

2. **Choose an app to run**
   ```bash
   cd acs  # or bug_identifier, plant_identifier, MAS, unseen
   ```

3. **Install dependencies**
   ```bash
   flutter pub get
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Environment Configuration

Each app may require environment configuration. Check the app's README for details:
- Supabase credentials (for AI features)
- RevenueCat API keys (for subscriptions)
- Platform-specific setup (Android/iOS)

## 📚 Documentation

### Monorepo Documentation
- [Architecture Overview](./docs/monorepo/ARCHITECTURE.md)
- [Development Guidelines](./docs/monorepo/DEVELOPMENT.md)
- [Shared Components](./docs/monorepo/SHARED_COMPONENTS.md)

### Tools & Utilities
- [Google Play Upload Tool](./docs/tools/google-play-uploader/README.md)
- [Localization Analysis](./docs/tools/localization/README.md)

### App-Specific Documentation
Each application has its own detailed documentation in its respective directory:
- [ACS Documentation](./acs/docs/)
- [Bug Identifier Documentation](./bug_identifier/docs/)
- [MAS Documentation](./MAS/)
- [Plant Identifier Documentation](./plant_identifier/)
- [Unseen Documentation](./unseen/)

## 🎨 Design Philosophy

All apps follow a cohesive design approach:
- **Natural & Organic** - Inspired by nature
- **Clean & Minimal** - Focus on functionality
- **Accessible** - WCAG compliant
- **Adaptive** - Works across all screen sizes
- **Themeable** - Multiple color schemes

## 🌍 Localization

Apps support 30+ languages including:
- **Western:** English, Spanish, German, French, Italian, Portuguese
- **Eastern European:** Russian, Ukrainian, Polish, Czech
- **Scandinavian:** Swedish, Norwegian, Danish, Finnish
- **Middle East:** Arabic, Turkish, Greek
- **Asian:** Japanese, Korean, Chinese (Simplified & Traditional), Hindi, Thai, Vietnamese, Indonesian

## 🧪 Testing

```bash
# Run tests for specific app
cd <app-directory>
flutter test

# Run tests with coverage
flutter test --coverage
```

## 📦 Building

### Android
```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS
```bash
flutter build ipa --release
```

### Web
```bash
flutter build web --release
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

See [CONTRIBUTING.md](./docs/monorepo/CONTRIBUTING.md) for detailed guidelines.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Support

For app-specific issues, please check the individual app's README and documentation.

For general monorepo issues, please open an issue in this repository.

---

**Made with ❤️ using Flutter**
