# MAS - Math AI Solver

**Math AI Solver** - AI-powered math problem solver with step-by-step solutions, powered by Gemini Vision API.

## 🎯 Features

### MVP Features (Phase 1)

#### 1. **Solve Mode** (Розв'язати) 💡
- Scan any math problem with your camera
- AI provides step-by-step solution with LaTeX formulas
- Detailed explanation for each step
- Save solutions to history

#### 2. **Check Mode** (Перевірити) 🔍
- Scan your handwritten solution
- AI validates each step
- Highlights errors with hints
- Shows accuracy percentage
- Rescan after corrections

#### 3. **Training Mode** (Тренуйся) 💪
- Scan example problem
- AI generates 5-10 similar problems
- Practice with multiple choice or written answers
- Get instant feedback
- Track your progress

#### 4. **Math Chat** 💬
- Chat with AI math tutor
- Attach photos to messages
- Get explanations and help
- LaTeX formula rendering

#### 5. **Unit Converter** 📏
- Length, mass, volume, area, time
- Temperature, speed conversions
- Interactive calculator

### Premium Features

#### 6. **Expert Mode** 🎓
- Deep mathematical theory
- Real-life examples
- Links to textbooks and videos
- Historical context

#### 7. **AI Tutor Mode** (Socratic Method) 🧠
- AI teaches through questions
- Student discovers solution themselves
- Adaptive difficulty

## 🏗️ Tech Stack

- **Framework**: Flutter 3.8.1+
- **State Management**: Provider
- **Navigation**: go_router
- **Database**: SQLite + Supabase
- **AI**: Gemini Vision API (Supabase Edge Functions)
- **Subscriptions**: RevenueCat
- **LaTeX Rendering**: flutter_math_fork
- **Charts**: fl_chart

## 📁 Project Structure

```
lib/
├── models/              # Data models
│   ├── math_expression.dart
│   ├── math_solution.dart
│   ├── solution_step.dart
│   ├── validation_result.dart
│   └── training_session.dart
├── services/            # Business logic
│   ├── math_ai_service.dart
│   ├── camera/
│   └── database/
├── screens/             # UI screens
│   ├── solve/
│   ├── check/
│   ├── training/
│   ├── chat/
│   └── converter/
├── widgets/             # Reusable components
├── providers/           # State management
├── theme/               # App theming
└── l10n/                # Localization
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.8.1 or higher
- Dart SDK
- Supabase account
- RevenueCat account (for subscriptions)

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd MAS
```

2. Install dependencies:
```bash
flutter pub get
```

3. Set up environment variables:
Create `.env` file in the root:
```
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_key
REVENUECAT_API_KEY=your_revenuecat_key
```

4. Run the app:
```bash
flutter run
```

## 📱 Supported Platforms

- ✅ iOS
- ✅ Android
- ⏳ Web (coming soon)

## 🎨 Themes

- **Classic Math** - Light purple-blue gradient
- **Dark Scholar** - Dark purple theme
- **Nature Study** - Green calm theme
- **Custom** - User-defined theme

## 📊 Features Roadmap

### Phase 1 (Weeks 1-6) - MVP
- [x] Project setup
- [x] Data models
- [x] AI service
- [ ] Solve mode
- [ ] Check mode
- [ ] Training mode
- [ ] Math chat

### Phase 2 (Weeks 7-10) - Premium Features
- [ ] Unit converter
- [ ] Expert mode
- [ ] AI Tutor mode
- [ ] Subscription system

### Phase 3 (Weeks 11-13) - Polish
- [ ] Animations and transitions
- [ ] Performance optimization
- [ ] Testing
- [ ] App store deployment

## 🌍 Localization

Supported languages:
- 🇺🇦 Ukrainian
- 🇷🇺 Russian
- 🇬🇧 English
- (More coming soon)

## 📄 License

Proprietary - All rights reserved

## 👥 Team

- Developer: [Your Name]
- Based on ACS architecture

## 🔗 Links

- [Documentation](docs/)
- [Issue Tracker](issues/)

---

**Built with ❤️ using Flutter and AI**
