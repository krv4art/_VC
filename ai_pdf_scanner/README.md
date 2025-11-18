# AI PDF Scanner

A powerful Flutter application for scanning, converting, editing, and managing PDF documents with AI-powered features.

## Features

### 📸 Phone Scanner
- Camera-based document scanning
- Multi-page PDF creation
- Auto edge detection and cropping
- **AI-powered document type detection**
- **Smart quality enhancement**
- **OCR (Text Recognition)**

### 🔄 PDF Converter
- JPG to PDF conversion
- MS Office to PDF (Word, Excel, PowerPoint)
- PDF to MS Office conversion
- Image extraction from PDFs
- **AI-based layout preservation**

### ✏️ PDF Editor
- PDF annotation (highlight, notes, comments)
- Drawing tools
- Image insertion
- Form filling and digital signatures
- PDF reader/viewer
- **AI-powered smart annotations**
- **Handwriting recognition**
- **Content summarization**
- **Real-time translation**

### ⚙️ PDF Optimization & Organization
- PDF compression
- PDF merging and splitting
- Page rotation and resizing
- Password protection
- Page numbering
- Watermarking
- **AI-based smart compression**
- **Auto organization and tagging**
- **Duplicate detection**
- **Privacy scanning**

## Architecture

This application is built using:
- **Flutter** - Cross-platform UI framework
- **Provider** - State management
- **GoRouter** - Navigation
- **SQLite** - Local database
- **Supabase** - Backend services and AI API proxy
- **Gemini AI** - AI-powered features

The architecture follows patterns from the ACS (Antique Collection Scanner) project:
- Clean separation of concerns
- Singleton services pattern
- Provider-based state management
- Abstract color system for easy theming
- Responsive design constants

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── config/                   # Configuration files
├── constants/                # App constants
├── theme/                    # Design system
├── l10n/                     # Localization
├── models/                   # Data models
├── services/                 # Business logic
│   ├── ai/                   # AI services
│   ├── pdf/                  # PDF processing
│   ├── scanning/             # Document scanning
│   └── storage/              # Database & files
├── providers/                # State management
├── navigation/               # Routing
├── screens/                  # UI screens
└── widgets/                  # Reusable widgets
```

## Getting Started

### Prerequisites
- Flutter SDK (3.8.1 or higher)
- Dart SDK
- Android Studio / Xcode (for mobile development)

### Installation

1. Clone the repository
2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## Development Phases

### Phase 1: Foundation ✅
- Project structure
- Design system
- Database schema
- Navigation
- Basic screens

### Phase 2: Scanner (In Progress)
- Camera integration
- Image processing
- Edge detection
- Multi-page scanning
- AI document detection

### Phase 3-11: See AI_PDF_SCANNER_DEVELOPMENT_PLAN.md

## Contributing

This is a private project. For internal development guidelines, see the development plan.

## License

Proprietary - All rights reserved

## Contact

For questions or support, please contact the development team.
