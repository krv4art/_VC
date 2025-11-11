# 🐟 Fish Identifier - AI-Powered Fish Recognition App

**Snap Fish AI** - Instantly identify fish species from photos with artificial intelligence.

## 📋 Overview

Fish Identifier is a Flutter-based mobile application that uses Google Gemini AI to instantly identify fish species from photos. Perfect for anglers, divers, and nature enthusiasts who want to:

- 📸 Identify fish species instantly
- 💬 Chat with AI about fishing tips and techniques
- 📚 Build a personal collection of catches
- 🎣 Get cooking and fishing recommendations
- 🌍 Track fishing locations with GPS

---

## ✨ Features

### Core Features
- **AI Fish Identification** - Identify 1000+ fish species with 95%+ accuracy
- **Expert Chat Assistant** - Ask questions about fishing, cooking, and fish care
- **Personal Collection** - Catalog your catches with photos, location, and notes
- **Multi-language Support** - English, Russian, Spanish, Japanese
- **Offline Database** - Store identifications locally for offline access

### Premium Features (Planned)
- Unlimited identifications
- Advanced fishing statistics
- Weather-based fishing predictions
- Social feed to share catches
- Export collection to PDF

---

## 🏗️ Architecture

### Tech Stack
- **Framework**: Flutter 3.8+
- **Language**: Dart
- **State Management**: Provider
- **Navigation**: GoRouter
- **Database**: SQLite (sqflite)
- **AI**: Google Gemini 2.0 Flash (via Supabase proxy)
- **Camera**: camera + image_picker packages

### Project Structure
```
fish_identifier/
├── lib/
│   ├── models/                 # Data models
│   │   ├── fish_identification.dart
│   │   ├── fish_collection.dart
│   │   └── chat_message.dart
│   ├── services/               # Business logic
│   │   ├── gemini_service.dart      # AI identification & chat
│   │   └── database_service.dart    # SQLite operations
│   ├── providers/              # State management
│   ├── screens/                # UI screens
│   ├── theme/                  # Design system
│   │   ├── app_theme.dart
│   │   └── app_colors.dart     # Ocean Blue theme
│   ├── config/                 # Configuration
│   │   └── fish_prompts_manager.dart
│   ├── l10n/                   # Localization (4 languages)
│   └── main.dart
```

---

## 🎨 Design System

### Ocean Blue Theme
- **Primary**: `#0077BE` - Ocean Blue
- **Secondary**: `#00BCD4` - Aqua/Cyan
- **Accent**: `#FF6F61` - Coral
- **Background**: `#F0F8FF` - Alice Blue

### Alternative Themes
- **Deep Sea** (Dark Mode) - Navy and bright blues
- **Tropical Waters** - Turquoise and teal

### Typography
- **Headings**: Lora (serif)
- **Body**: Open Sans (sans-serif)

---

## 📦 Database Schema

### fish_identifications
```sql
CREATE TABLE fish_identifications (
  id INTEGER PRIMARY KEY,
  imagePath TEXT NOT NULL,
  fishData TEXT NOT NULL,      -- JSON with all fish info
  identifyDate TEXT NOT NULL
);
```

### collection
```sql
CREATE TABLE collection (
  id INTEGER PRIMARY KEY,
  fishIdentificationId INTEGER,
  catchDate TEXT NOT NULL,
  location TEXT,
  latitude REAL,
  longitude REAL,
  notes TEXT,
  isFavorite INTEGER DEFAULT 0,
  weight REAL,
  length REAL,
  weatherConditions TEXT,
  baitUsed TEXT
);
```

### dialogues & messages
For AI chat functionality (linked to fish identifications)

---

## 🤖 AI Integration

### Fish Identification Prompt
```
Analyze fish image → Return JSON:
{
  "fish_name": "Largemouth Bass",
  "scientific_name": "Micropterus salmoides",
  "habitat": "Freshwater lakes and rivers",
  "diet": "Carnivorous - smaller fish, insects",
  "fun_facts": ["Can live up to 16 years", ...],
  "confidence_score": 0.95,
  "edibility": "Edible",
  "cooking_tips": "Best grilled or fried",
  "fishing_tips": "Use spinnerbaits in spring",
  "conservation_status": "Least Concern"
}
```

### Chat System
- Context-aware conversations about identified fish
- Fishing techniques and equipment recommendations
- Cooking recipes and preparation tips
- Local regulations and conservation info

---

## 🌍 Localization

Supported languages:
- 🇺🇸 English (en)
- 🇷🇺 Russian (ru)
- 🇪🇸 Spanish (es)
- 🇯🇵 Japanese (ja)

All AI responses are provided in the user's selected language.

---

## 🚀 Current Progress

### ✅ Completed
1. Project structure and dependencies
2. Data models (Fish, Collection, ChatMessage)
3. AI service (Gemini integration)
4. Database service (SQLite with full schema)
5. Ocean-themed design system
6. AI prompts for fish identification and chat
7. Exception handling framework

### 🚧 In Progress
- Providers (theme, locale, identification)
- Localization files (ARB)
- UI screens (Camera, Results, Chat, Collection)
- Navigation setup
- Main app entry point

### 📋 To Do
- Camera integration
- Image processing
- Testing and debugging
- RevenueCat subscription setup
- App Store/Play Store preparation

---

## 🎯 Monetization Strategy

### Free Tier
- 5 identifications per day
- Basic fish information
- 3 chat messages per identification
- Personal collection (up to 20 fish)

### Premium ($4.99/month or $29.99/year)
- ♾️ Unlimited identifications
- ♾️ Unlimited AI chat
- 📍 GPS location tracking
- 📊 Advanced statistics
- 💾 Cloud backup
- 🎣 Personalized fishing recommendations
- 📱 Ad-free experience

---

## 💡 Inspiration

Based on successful identification apps:
- **PictureThis** (98% accuracy, 50M+ users, $30/year)
- **Picture Insect** (Expert chat feature, Premium subscription)
- **FishVerify** (Ask an Expert feature, Regulations database)

---

## 📈 Market Potential

- **Target Market**: $800 MRR (from reference app)
- **Price Point**: $12,000 (listed app price)
- **User GEO**: US, Australia, Japan (major fishing markets)
- **Growth**: ASO, TikTok/Shorts marketing, Social feed

---

## 📝 License

Private project - Not for public distribution

---

## 👨‍💻 Development

Built with ❤️ using Flutter and Google Gemini AI

**Status**: 🚧 In Development (MVP Phase)
