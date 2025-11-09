# AI Cosmetic Scanner

![Flutter](https://img.shields.io/badge/Flutter-3.32.6-blue)
![Dart](https://img.shields.io/badge/Dart-3.8.1-blue)
![License](https://img.shields.io/badge/license-MIT-green)

**AI-powered cosmetic ingredient analyzer with personalized skin care recommendations.**

## 🌟 Features

### Core Functionality
- 📸 **Smart Scanning** - Camera & gallery support for cosmetic labels
- 🤖 **AI Analysis** - Powered by Google Gemini 2.0 Flash
- 🎭 **Object Detection** - Detects non-cosmetic objects with humorous messages
- ⚠️ **Safety Scoring** - 0-10 scale ingredient safety analysis
- 🔍 **Ingredient Breakdown** - High/Medium/Low risk categorization
- 👤 **Personalized Warnings** - Based on skin type and allergies
- 💊 **Alternative Recommendations** - Suggests safer products
- 💬 **AI Chat Assistant** - Multi-turn conversations with context

### User Experience
- 🌐 **Multi-language** - English, Russian, Ukrainian, Spanish
- 🎨 **Natural Beauty Design** - Saddle Brown, Natural Green, Beige
- 📱 **Responsive UI** - Works on mobile, tablet, and web
- 📊 **Scan History** - SQLite local storage
- 👥 **User Profiles** - Skin type and allergy management

## 🎨 Design System

**Natural Beauty Theme** - Inspired by nature and organic cosmetics

### Colors
- **Primary**: Saddle Brown (`#8B4513`) - Warm, earthy, trustworthy
- **Accent**: Natural Green (`#4CAF50`) - Fresh, safe, natural
- **Background**: Soft Beige (`#F5F1E8`) - Gentle, clean, minimalist

### Typography
- **Headers**: Lora (Serif) - Elegant, professional
- **Body**: Open Sans (Sans-serif) - Clean, readable

### Components
- Gradient selections
- Floating snackbars
- Rounded corners (8-20px)
- Soft shadows

[Full Design System Documentation](docs/DESIGN_SYSTEM.md)

## 🚀 Quick Start

### Prerequisites
- Flutter SDK 3.32.6+
- Dart 3.8.1+
- Android Studio / VS Code
- Supabase account
- Google Gemini API key

### Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/acs.git
cd acs

# Install dependencies
flutter pub get

# Generate localization files
flutter gen-l10n

# Run the app
flutter run -d chrome  # For web
flutter run           # For mobile
```

### Environment Setup

Create `.env` file in the root directory:

```env
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key
GEMINI_API_KEY=your_gemini_api_key
```

## 📱 Platform Support

| Platform | Status | Notes |
|----------|--------|-------|
| Android  | ✅ Full | Min SDK 21 |
| iOS      | ✅ Full | iOS 12+ |
| Web      | ✅ Full | Chrome, Firefox, Safari |
| Windows  | 🚧 Beta | Limited camera support |
| macOS    | 🚧 Beta | Limited camera support |
| Linux    | 🚧 Beta | Limited camera support |

## 🏗️ Architecture

```
lib/
├── l10n/                 # Localization files
├── models/              # Data models
│   ├── analysis_result.dart
│   ├── scan_result.dart
│   └── chat_message.dart
├── providers/           # State management
│   ├── user_state.dart
│   └── locale_provider.dart
├── screens/            # UI screens
│   ├── homepage_screen.dart
│   ├── scanning_screen.dart
│   ├── analysis_screen.dart
│   ├── chat_ai_screen.dart
│   └── ...
├── services/           # Business logic
│   ├── gemini_service.dart
│   ├── local_data_service.dart
│   └── chat_context_service.dart
├── theme/              # Design system
│   └── app_theme.dart
├── widgets/            # Reusable widgets
│   └── bottom_navigation_wrapper.dart
└── main.dart           # App entry point
```

[Detailed Architecture Documentation](docs/ARCHITECTURE.md)

## 🔌 API Integrations

### Google Gemini AI
- **Model**: gemini-2.0-flash
- **Vision API**: Image analysis
- **Text API**: Chat conversations
- **Proxy**: Supabase Edge Functions

### Supabase
- **Database**: Scan history (future feature)
- **Edge Functions**:
  - `gemini-vision-proxy` - Image analysis
  - `gemini-proxy` - Chat API

[API Integration Guide](docs/API_INTEGRATION.md)

## 📚 Documentation

**📖 [Полная документация в папке docs/](docs/README.md)**

Вся документация систематизирована и организована по категориям:

### Структура документации

```
docs/
├── 🏗️ Архитектурные документы (корень docs/)
├── 📖 guides/ - Руководства и гайды
├── 🚀 deployment/ - CI/CD и публикация
├── ⚙️ setup/ - Настройка и конфигурация
├── 🎨 assets/ - Ресурсы и иконки
├── ✨ features/ - Документация фич
├── 📋 planning/ - Планы и анализы
├── 📝 changelogs/ - История изменений
└── 📦 archive/ - Завершенные проекты
```

### Основные разделы

#### 🏗️ Архитектура и система дизайна
- [Architecture](docs/ARCHITECTURE.md) - Техническая архитектура
- [Design System](docs/DESIGN_SYSTEM.md) - Полная дизайн-система
- [Quick Reference](docs/DESIGN_SYSTEM_QUICK_REFERENCE.md) - Быстрый справочник
- [API Integration](docs/API_INTEGRATION.md) - Интеграция с API

#### 📖 Руководства (guides/)
- [Localization Guide](docs/guides/LOCALIZATION_GUIDE.md) - Мультиязычность
- [Add New Language](docs/guides/ADD_NEW_LANGUAGE_GUIDE.md) - Добавление языка
- [Multi-Theme Guide](docs/guides/MULTI_THEME_GUIDE.md) - Система тем
- [Add New Theme](docs/guides/ADD_NEW_THEME_ULTIMATE_GUIDE.md) - Добавление темы
- [Common Issues](docs/guides/COMMON_ISSUES.md) - Частые проблемы и решения
- [Store Listings Guide](docs/guides/STORE_LISTINGS_GUIDE.md) - Управление материалами сторов

#### 🚀 Deployment и CI/CD
- [Codemagic Setup](docs/deployment/CODEMAGIC_SETUP.md) - Настройка CI/CD
- [Signing Setup](docs/deployment/SIGNING_SETUP.md) - Подпись приложения
- [Restoration Guide](docs/deployment/RESTORATION_GUIDE.md) - Восстановление проекта

#### ⚙️ Настройка и конфигурация
- [Subscription Setup](docs/setup/SUBSCRIPTION_SETUP.md) - Настройка подписок RevenueCat
- [Telegram Setup](docs/setup/TELEGRAM_SETUP.md) - Настройка Telegram

#### 🎨 Ресурсы и ассеты
- [Icon Replacement Guide](docs/assets/ICON_REPLACEMENT_GUIDE.md) - Замена иконки
- [Quick Icon Change](docs/assets/QUICK_ICON_CHANGE.md) - Быстрая замена (одна команда)

#### 📱 Store Listings
- [Store Listings Materials](store_listings/README.md) - Материалы для App Store и Google Play

## 🧪 Testing

```bash
# Run unit tests
flutter test

# Run integration tests
flutter test integration_test

# Analyze code
flutter analyze

# Format code
flutter format lib/
```

## 📦 Build

### Change App Icon
Before building, you can replace the app icon:
```bash
# Quick one-liner (delete old icons first!)
cp /path/to/icon.png assets/icon/logo.png && \
cd android/app/src/main/res && \
find . -name "launcher_icon.png" -type f -delete && \
find . -name "ic_launcher.png" -type f -delete && \
cd ../../../.. && \
dart run flutter_launcher_icons && \
flutter clean
```

**Important:** Always delete old icons before generating new ones!

See [Quick Icon Change](docs/assets/QUICK_ICON_CHANGE.md) or [Full Guide](docs/assets/ICON_REPLACEMENT_GUIDE.md)

### Android APK
```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

### Android App Bundle
```bash
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/app-release.aab
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
# Output: build/web/
```

## 🎯 Roadmap

### Version 1.1 (In Progress)
- [x] Design system implementation
- [x] Smart object detection with humor
- [x] Multi-language support
- [ ] Scan history with SQLite
- [ ] Product search by barcode

### Version 1.2 (Planned)
- [ ] Offline mode
- [ ] Ingredient database
- [ ] Custom allergy alerts
- [ ] Social sharing
- [ ] Product favorites

### Version 2.0 (Future)
- [ ] User authentication
- [ ] Cloud sync
- [ ] Community reviews
- [ ] Premium features
- [ ] Notifications

## 🤝 Contributing

Contributions are welcome! Please read our contributing guidelines before submitting PRs.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Authors

- **Your Name** - Initial work

## 🙏 Acknowledgments

- Google Gemini AI for powerful AI capabilities
- Supabase for backend infrastructure
- Flutter community for amazing packages
- Open source contributors

## 📞 Support

- 📧 Email: support@acs-app.com
- 🐛 Issues: [GitHub Issues](https://github.com/yourusername/acs/issues)
- 💬 Discussions: [GitHub Discussions](https://github.com/yourusername/acs/discussions)

---

Made with ❤️ and Flutter
