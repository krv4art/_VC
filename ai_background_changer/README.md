# AI Background Changer

AI-powered background removal and replacement tool with smart scene generation.

## Features

- **Smart Background Removal**: AI-powered precise background detection and removal
- **Creative Backgrounds**: Choose from preset styles or create custom backgrounds
- **AI Assistant**: Get creative suggestions and ideas for your photos
- **History**: Keep track of all your processed images
- **Share**: Easily share your creations

## Architecture

This app follows the same architecture pattern as other apps in the monorepo:

```
lib/
├── models/          # Data models (BackgroundResult, BackgroundStyle, etc.)
├── services/        # Business logic & API integration
│   ├── gemini_service.dart
│   ├── background_processing_service.dart
│   ├── image_compression_service.dart
│   ├── local_data_service.dart
│   └── chat_service.dart
├── providers/       # State management (Provider pattern)
│   ├── background_provider.dart
│   └── chat_provider.dart
├── screens/         # UI screens
│   ├── home_screen.dart
│   ├── select_image_screen.dart
│   ├── processing_screen.dart
│   ├── result_screen.dart
│   ├── history_screen.dart
│   └── chat_screen.dart
├── widgets/         # Reusable UI components
├── utils/           # Utility functions
├── config/          # App configuration
├── l10n/            # Localization files
└── main.dart        # App entry point
```

## Technologies

- **Framework**: Flutter 3.x
- **Language**: Dart 3.x
- **State Management**: Provider
- **Navigation**: go_router
- **Storage**: sqflite / sqflite_ffi_web
- **AI Backend**: Google Gemini via Supabase Edge Functions
- **Image Processing**: flutter_image_compress
- **Localization**: Flutter intl

## Getting Started

### Prerequisites

- Flutter SDK 3.x or higher
- Dart SDK 3.x or higher
- Android Studio / Xcode (for mobile)
- Chrome (for web)

### Setup

1. **Install dependencies**
   ```bash
   flutter pub get
   ```

2. **Configure Supabase**
   - Update `lib/utils/supabase_constants.dart` with your Supabase credentials
   - Set up Edge Functions for background processing (see Edge Functions section)

3. **Configure environment**
   - Update `assets/config/.env` with your settings

4. **Run the app**
   ```bash
   flutter run
   ```

## Edge Functions

This app requires the following Supabase Edge Functions:

### 1. Background Removal Function
```typescript
// functions/background-removal/index.ts
// Remove background from image using AI
```

### 2. Background Generation Function
```typescript
// functions/background-generation/index.ts
// Generate new background and composite with foreground
```

### 3. Chat Completion Function (Gemini Proxy)
```typescript
// functions/gemini-proxy/index.ts
// Proxy for Gemini AI chat
```

## Background Styles

The app includes predefined background styles in several categories:

- **Nature**: Forest, Beach, Mountain
- **Urban**: City Skyline, Street
- **Studio**: White Studio, Gradient
- **Abstract**: Bokeh Lights, Color Splash
- **Professional**: Modern Office (Premium)
- **Vintage**: Classic Style (Premium)

Users can also create custom backgrounds by describing them in natural language.

## Features Breakdown

### 1. Background Processing
- Upload or capture image
- AI removes background automatically
- Choose preset style or describe custom background
- AI generates new background
- Composite final image

### 2. History Management
- All processed images saved locally
- View history in grid layout
- Mark favorites
- Quick access to previous results

### 3. AI Chat Assistant
- Ask for background suggestions
- Get creative ideas
- Learn about photo composition
- Persistent chat history

## Localization

Currently supports:
- English (en)
- Russian (ru)

To add more languages:
1. Create `lib/l10n/app_[locale].arb`
2. Add translations
3. Run `flutter gen-l10n`

## Building

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

## Database Schema

### Results Table
```sql
CREATE TABLE results(
  id TEXT PRIMARY KEY,
  original_image_path TEXT NOT NULL,
  processed_image_path TEXT,
  removed_bg_image_path TEXT,
  timestamp TEXT NOT NULL,
  style_id TEXT,
  style_name TEXT,
  style_description TEXT,
  user_prompt TEXT,
  is_favorite INTEGER DEFAULT 0,
  status TEXT DEFAULT 'pending',
  error_message TEXT,
  metadata TEXT
)
```

### Dialogues Table
```sql
CREATE TABLE dialogues(
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  message_count INTEGER DEFAULT 0,
  last_message TEXT,
  result_id TEXT
)
```

### Messages Table
```sql
CREATE TABLE messages(
  id TEXT PRIMARY KEY,
  dialogue_id TEXT NOT NULL,
  role TEXT NOT NULL,
  content TEXT NOT NULL,
  timestamp TEXT NOT NULL,
  image_path TEXT,
  metadata TEXT,
  FOREIGN KEY (dialogue_id) REFERENCES dialogues (id) ON DELETE CASCADE
)
```

## Configuration

### Free Tier Limits
Configure in `assets/config/.env`:
- `FREE_PROCESSINGS_PER_WEEK`: Number of free background changes per week
- `FREE_MESSAGES_PER_DAY`: Number of free AI chat messages per day
- `FREE_VISIBLE_RESULTS`: Number of results visible in history

## Future Enhancements

- [ ] Multiple background options per image
- [ ] Real-time preview
- [ ] Batch processing
- [ ] Cloud sync
- [ ] Social sharing integration
- [ ] Premium backgrounds library
- [ ] Advanced editing tools
- [ ] Video background replacement

## License

This project is part of the AI Apps monorepo and follows the same MIT License.

## Support

For issues specific to this app, please check the main monorepo documentation.

---

**Made with Flutter**
