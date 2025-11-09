# Plant Identifier

AI-powered plant and mushroom identification app built with Flutter.

## Features

### Core Features
- 🌿 **Plant Identification**: Identify plants, flowers, trees, and mushrooms using AI
- 📸 **Camera Integration**: Take photos or select from gallery
- 📚 **Identification History**: View and manage past identifications
- 🎨 **Multiple Themes**: Choose from various plant-themed color schemes
- 🌍 **Multilingual Support**: English, Russian, and Ukrainian languages
- 💾 **Offline History**: Local database for storing identification results

### Plant Information
- Common and scientific names
- Detailed descriptions
- Care instructions (watering, sunlight, soil, etc.)
- Toxicity warnings
- Edibility information
- Uses and benefits
- Common pests and diseases

### Personalization
- Gardening experience level
- Location and climate settings
- Garden type preferences
- Interest-based recommendations
- Custom notifications for plant care

## Architecture

Based on the proven ACS (AI Cosmetic Scanner) architecture with adaptations for botanical identification:

### Design System
- **Theme System**: Multiple botanical color palettes
  - Green Nature (default)
  - Forest
  - Botanical Garden
  - Mushroom
  - Dark Green
- **Typography**: Lora (serif) + Open Sans (sans-serif)
- **8px Grid System**: Consistent spacing and layout

### State Management
- **Provider**: For app-wide state management
- **Providers**:
  - `ThemeProvider`: Theme and appearance management
  - `LocaleProvider`: Language management
  - `UserPreferencesProvider`: User settings and personalization
  - `PlantHistoryProvider`: Identification history

### Data Layer
- **Local Database**: SQLite for storing identification history
- **Models**:
  - `PlantResult`: Identification results with care info
  - `UserPreferences`: User settings and preferences
  - `PlantCareInfo`: Detailed plant care information

### Services
- **PlantIdentificationService**: AI-powered identification via Gemini
- **DatabaseService**: Local data persistence
- **Supabase**: Backend integration for AI proxy

## Project Structure

```
plant_identifier/
├── lib/
│   ├── models/          # Data models
│   ├── providers/       # State management
│   ├── services/        # Business logic
│   ├── screens/         # UI screens
│   ├── widgets/         # Reusable widgets
│   ├── theme/           # Design system
│   ├── navigation/      # Routing
│   ├── config/          # Configuration
│   ├── utils/           # Utilities
│   └── main.dart        # App entry point
├── assets/              # Images, fonts, icons
└── pubspec.yaml         # Dependencies
```

## Technologies

- **Framework**: Flutter 3.8+
- **Language**: Dart
- **State Management**: Provider
- **Navigation**: go_router
- **Database**: sqflite
- **Backend**: Supabase
- **AI**: Google Gemini Vision API
- **Storage**: shared_preferences

## Getting Started

### Prerequisites
- Flutter SDK 3.8.1 or higher
- Dart 3.0+
- Android Studio / VS Code
- Supabase account (for AI identification)

### Installation

1. Clone the repository
2. Navigate to the plant_identifier directory:
   ```bash
   cd plant_identifier
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Run the app:
   ```bash
   flutter run
   ```

### Configuration

Create a `.env` file in the root directory with your Supabase credentials:

```env
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key
```

## Features in Development

- [ ] Camera capture and image processing
- [ ] Advanced plant care scheduling
- [ ] Plant care reminders and notifications
- [ ] Social features (share identifications)
- [ ] Plant collection management
- [ ] Offline AI model support
- [ ] Plant disease detection
- [ ] AR plant visualization

## Acknowledgments

- Based on ACS (AI Cosmetic Scanner) architecture
- Powered by Google Gemini AI
- UI inspired by natural and botanical design principles

## License

This project is part of the ACS_Vibe repository.
