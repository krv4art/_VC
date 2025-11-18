# CV Engineer - Professional Resume Builder

A comprehensive Flutter application for creating professional resumes with AI assistance.

## Features

### Core Functionality
- **Professional Templates**: Multiple beautifully designed resume templates created by recruiters
- **Easy Editing**: Intuitive interface with dedicated editors for each section
- **AI Assistant**: AI-powered content suggestions and grammar checking
- **PDF Export**: Download, share, and print resumes as PDF files
- **Multi-language Support**: Available in 8 languages (English, Spanish, German, French, Italian, Polish, Portuguese, Turkish)
- **Dark Mode**: Full dark mode support with 3 color themes
- **Interview Preparation**: Built-in interview questions and answer guidelines

### Advanced Editors
- **Experience Editor**: Full-featured form with responsibilities, date ranges, and current job tracking
- **Education Editor**: Comprehensive editor with achievements, GPA, and current studies tracking
- **Skills Editor**: Categorized skills with proficiency levels (Beginner to Expert)
- **Languages Editor**: CEFR standard proficiency levels (A1 to C2)
- **Photo Upload**: Support for profile photos with compression and cropping

### Resume Sections
- Personal Information (with photo support)
- Professional Summary (with AI assistance)
- Work Experience (with bullet points and duration calculation)
- Education (with achievements and honors)
- Skills (categorized with proficiency indicators)
- Languages (CEFR proficiency standards)
- Custom Sections (flexible for any additional content)

### Customization
- 3 professional color themes (Professional, Creative, Modern)
- Each theme supports light and dark modes
- Adjustable font sizes (8-16pt)
- Customizable page margins (10-40pt)
- Real-time preview updates

## Architecture

The app follows a clean architecture pattern inspired by the ACS project:

```
lib/
├── animations/          # Animation utilities
├── config/             # App configuration
├── constants/          # App-wide constants
├── l10n/               # Localization files
├── models/             # Data models
├── navigation/         # Routing configuration
├── providers/          # State management (Provider)
├── screens/            # UI screens
├── services/           # Business logic services
├── theme/              # Theme configuration
├── utils/              # Utility functions
└── widgets/            # Reusable widgets
```

## Technology Stack

- **Framework**: Flutter 3.8+
- **State Management**: Provider
- **Navigation**: go_router
- **Backend**: Supabase (optional for AI features)
- **PDF Generation**: pdf & printing packages
- **Local Storage**: shared_preferences & sqflite
- **Image Processing**: image_picker & flutter_image_compress
- **Permissions**: permission_handler

## Getting Started

### Prerequisites
- Flutter SDK 3.8.1 or higher
- Dart 3.0+

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd cv_engineer
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

### Configuration

#### Supabase (Optional)
If you want to use Supabase for cloud storage:

1. Create a Supabase project
2. Copy your project URL and anon key
3. Update `lib/utils/supabase_constants.dart` with your credentials

## Roadmap

### Phase 1: Core Features ✅
- [x] Project structure and architecture
- [x] Data models
- [x] Theme system with dark mode
- [x] Multi-language support
- [x] Main screens (Home, Editor, Preview, Settings)
- [x] Interview questions feature

### Phase 2: Advanced Features ✅
- [x] Detailed section editors (Experience, Education, Skills, Languages)
- [x] PDF export functionality with printing and sharing
- [x] AI Assistant service integration
- [x] Photo upload and management service
- [x] Professional PDF generation with formatting
- [x] Comprehensive form validation
- [x] Date pickers and autocomplete inputs
- [x] Skill categorization and proficiency levels
- [x] CEFR language proficiency standards

### Phase 3: Polish and Optimization (In Progress)
- [ ] Animations and transitions
- [ ] Performance optimization
- [ ] Cloud backup with Supabase
- [ ] Advanced resume templates
- [ ] Comprehensive testing
- [ ] App store deployment

## Contributing

Contributions are welcome! Please read our contributing guidelines before submitting pull requests.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Architecture inspired by the ACS project
- Design system following Material Design 3 guidelines
- Interview questions curated from industry best practices

## Support

For support, please open an issue in the GitHub repository.
