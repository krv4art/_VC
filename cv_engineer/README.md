# CV Engineer - Professional Resume Builder

A comprehensive Flutter application for creating professional resumes with AI assistance.

## Features

### Core Functionality
- **Professional Templates**: Multiple beautifully designed resume templates created by recruiters
- **Easy Editing**: Intuitive interface for editing all resume sections
- **AI Assistant**: AI-powered content suggestions and grammar checking
- **PDF Export**: Download and share resumes as PDF files
- **Multi-language Support**: Available in 8 languages (English, Spanish, German, French, Italian, Polish, Portuguese, Turkish)
- **Dark Mode**: Full dark mode support for comfortable editing
- **Interview Preparation**: Built-in interview questions and answer guidelines

### Resume Sections
- Personal Information (with photo support)
- Professional Summary
- Work Experience
- Education
- Skills (with proficiency levels)
- Languages (CEFR levels)
- Custom Sections (flexible for any additional content)

### Customization
- Multiple color themes
- Adjustable font sizes
- Customizable page margins
- Font family selection

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
- **Backend**: Supabase (optional)
- **PDF Generation**: pdf & printing packages
- **Local Storage**: shared_preferences & sqflite

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

### Phase 2: Advanced Features (In Progress)
- [ ] Detailed section editors (Experience, Education, Skills, etc.)
- [ ] PDF export functionality
- [ ] AI Assistant integration
- [ ] Resume templates rendering
- [ ] Photo upload and management
- [ ] Cloud backup with Supabase

### Phase 3: Polish and Optimization
- [ ] Animations and transitions
- [ ] Performance optimization
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
