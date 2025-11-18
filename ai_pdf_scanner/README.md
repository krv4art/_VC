# 🤖 AI PDF Scanner

> **Powerful AI-driven PDF document scanner and management app built with Flutter**

[![Flutter](https://img.shields.io/badge/Flutter-3.8.1+-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?logo=dart)](https://dart.dev)
[![Supabase](https://img.shields.io/badge/Supabase-Ready-3ECF8E?logo=supabase)](https://supabase.com)
[![License](https://img.shields.io/badge/License-Proprietary-red)](#)

Comprehensive PDF scanner with AI-powered features including OCR, document classification, smart organization, and advanced PDF manipulation tools.

---

## ✨ Features

### 📸 **Phone Scanner**
- 📷 Camera-based document scanning with live preview
- 📄 Multi-page PDF creation in single session
- ✂️ Auto edge detection and perspective correction
- 🎨 Smart image enhancement (brightness, contrast, sharpness)
- 🤖 **AI-powered document type detection**
- 📝 **OCR with 95%+ accuracy**

### 🔄 **PDF Converter**
- 🖼️ JPG/PNG to PDF conversion
- 📊 MS Office to PDF (Word, Excel, PowerPoint) - *planned*
- 📄 PDF to images extraction
- 🎯 **AI-based layout preservation**

### ✏️ **PDF Editor**
- 🖍️ Annotations (highlight, notes, comments, drawings)
- ✍️ Digital signatures
- 📝 Form filling
- 🖼️ Image and text insertion
- 🔢 Page numbers and watermarks
- 🤖 **AI-powered smart annotations** - *planned*
- 🌐 **Real-time translation**

### ⚙️ **PDF Tools**
- 🗜️ Smart compression (4 quality levels)
- 🔗 Merge multiple PDFs
- ✂️ Split by pages or ranges
- 🔄 Rotate and reorder pages
- 🔒 Password protection - *planned*
- 🤖 **AI-based optimization**

### 📚 **Organization**
- 🗂️ Tab-based library (All/Scanned/Converted/Favorites)
- 🔍 Search and filter
- 📊 Sort by date, name, size
- ⭐ Favorites and tags
- 🤖 **AI auto-categorization** - *planned*

---

## 🏗️ Architecture

Built with **clean architecture** principles following the ACS (Antique Collection Scanner) project patterns:

```
┌─────────────┐
│   Screens   │  ← UI Layer (Flutter Widgets)
└─────┬───────┘
      │
┌─────▼───────┐
│  Providers  │  ← State Management (Provider Pattern)
└─────┬───────┘
      │
┌─────▼───────┐
│  Services   │  ← Business Logic (Singletons)
└─────┬───────┘
      │
┌─────▼───────┐
│   Models    │  ← Data Layer
└─────────────┘
```

### Technology Stack

| Component | Technology |
|-----------|-----------|
| **Framework** | Flutter 3.8.1+ |
| **Language** | Dart 3.0+ |
| **State Management** | Provider |
| **Navigation** | GoRouter |
| **Local Database** | SQLite (sqflite) |
| **Backend** | Supabase |
| **AI** | Google Gemini 1.5 Flash |
| **PDF Processing** | Syncfusion PDF |
| **Camera** | camera plugin |
| **Image Processing** | image, flutter_image_compress |

---

## 📦 Project Structure

```
ai_pdf_scanner/
├── lib/
│   ├── config/                    # Configuration
│   │   ├── api_config.dart       # API endpoints
│   │   └── app_config.dart       # App settings
│   │
│   ├── constants/                 # Design constants
│   │   └── app_dimensions.dart   # Spacing & sizing
│   │
│   ├── theme/                     # Design system
│   │   ├── app_colors.dart       # Color palettes (4 themes)
│   │   └── app_theme.dart        # Theme configuration
│   │
│   ├── models/                    # Data models
│   │   ├── pdf_document.dart
│   │   └── annotation.dart
│   │
│   ├── services/                  # Business logic
│   │   ├── ai/                    # AI services
│   │   │   ├── gemini_service.dart
│   │   │   └── ocr_service.dart
│   │   ├── pdf/                   # PDF tools
│   │   │   ├── pdf_generator_service.dart
│   │   │   ├── pdf_editor_service.dart
│   │   │   ├── pdf_merger_service.dart
│   │   │   ├── pdf_splitter_service.dart
│   │   │   └── pdf_compressor_service.dart
│   │   ├── scanning/              # Camera & scanning
│   │   │   ├── camera_service.dart
│   │   │   ├── image_processor_service.dart
│   │   │   ├── edge_detection_service.dart
│   │   │   └── scan_orchestrator_service.dart
│   │   └── storage/               # Data persistence
│   │       ├── database_service.dart
│   │       └── file_storage_service.dart
│   │
│   ├── providers/                 # State management
│   │   ├── app_state_provider.dart
│   │   ├── document_provider.dart
│   │   └── scan_provider.dart
│   │
│   ├── screens/                   # UI screens
│   │   ├── home/
│   │   ├── library/
│   │   ├── scanner/
│   │   └── settings/
│   │
│   └── main.dart                  # App entry point
│
├── supabase/
│   ├── functions/
│   │   └── ai-process/            # Edge Function for AI
│   │       └── index.ts
│   └── DEPLOYMENT.md              # Deployment guide
│
├── assets/                        # Static assets
├── test/                          # Unit tests
└── pubspec.yaml                   # Dependencies
```

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK **3.8.1+**
- Dart SDK **3.0+**
- Android Studio / Xcode
- Supabase account (for AI features)
- Google Gemini API key

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd ai_pdf_scanner
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Supabase** (see [DEPLOYMENT.md](supabase/DEPLOYMENT.md))
   ```bash
   # Update lib/config/api_config.dart with your Supabase URL and keys
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### First Run Setup

1. Grant camera permissions when prompted
2. Grant storage permissions for file access
3. (Optional) Configure AI features in Settings

---

## 🔧 Configuration

### API Configuration

Edit `lib/config/api_config.dart`:

```dart
class ApiConfig {
  static const String supabaseUrl = 'YOUR_SUPABASE_URL';
  static const String supabaseAnonKey = 'YOUR_ANON_KEY';
  static const String aiEndpoint = '$supabaseUrl/functions/v1/ai-process';
}
```

### App Configuration

Edit `lib/config/app_config.dart` for:
- PDF quality settings
- Scanner settings
- AI thresholds
- Storage paths

---

## 🎨 Themes

4 beautiful themes included:

| Theme | Description | Primary Color |
|-------|-------------|---------------|
| **Professional** ⭐ | Modern blue (default) | #2196F3 |
| **Dark** | Dark mode variant | #64B5F6 |
| **Minimalist** | Clean gray | #424242 |
| **Green Business** | Eco-friendly | #43A047 |

---

## 📖 Documentation

- 📘 [Development Plan](../AI_PDF_SCANNER_DEVELOPMENT_PLAN.md)
- 🚀 [Deployment Guide](supabase/DEPLOYMENT.md)
- 📊 [Project Status](PROJECT_STATUS.md)
- 💻 [API Documentation](#) - Coming soon

---

## 🧪 Testing

```bash
# Run unit tests
flutter test

# Run integration tests
flutter test integration_test

# Run with coverage
flutter test --coverage
```

---

## 📱 Build & Deploy

### Android

```bash
flutter build apk --release
# or
flutter build appbundle --release
```

### iOS

```bash
flutter build ios --release
```

---

## 🤝 Contributing

This is a private project. For development guidelines:

1. Follow Flutter/Dart best practices
2. Use meaningful commit messages
3. Add tests for new features
4. Update documentation

---

## 📊 Project Stats

- **Total Files**: 50+
- **Lines of Code**: 10,000+
- **Services**: 15
- **Screens**: 6
- **Languages**: English, Russian (extensible)

---

## 🔐 Security

- ✅ API keys secured via Supabase Edge Functions
- ✅ Local data encryption ready
- ✅ Privacy-first design
- ✅ No user tracking
- ⚠️ No authentication (as per requirements)

---

## 📄 License

**Proprietary** - All rights reserved

---

## 🙏 Acknowledgments

- Architecture inspired by ACS project
- UI/UX following Material Design 3
- AI powered by Google Gemini
- Backend by Supabase

---

## 📞 Support & Contact

For questions or issues:
- Check [Documentation](supabase/DEPLOYMENT.md)
- Review [Project Status](PROJECT_STATUS.md)
- Contact: [Your contact info]

---

**Made with ❤️ using Flutter**
