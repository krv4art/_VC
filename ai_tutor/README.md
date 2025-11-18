# 🎓 AI Tutor - Personalized Learning Platform

## 📖 Overview

AI Tutor is a revolutionary educational app that personalizes learning through **cultural themes** and **interest-based examples**. Instead of generic math problems, students learn through contexts they love - whether it's Minecraft, sports, space, or their favorite hobbies!

## ✨ Key Features

### 🎯 Core Learning Features

#### **Personalized AI Tutoring**
- AI adapts to your interests, cultural background, and learning style
- Socratic method: guides you to discover answers yourself
- Multi-mode support: Explain, Practice, Hint, Check Solution

#### **Practice Mode** 💪
- AI-generated personalized practice problems
- 1-10 difficulty levels
- Up to 3 hints per problem
- Instant feedback and step-by-step solutions
- Problems adapt to your interests (e.g., "Minecraft math")

#### **Progress Tracking** 📊
- Comprehensive analytics per subject
- Track: problems solved, accuracy, study time
- Topic mastery detection
- Session tracking
- XP system

#### **Achievement System** 🏆
- 12 unique achievements to unlock
- Categories: Problems, Streaks, Performance, Dedication
- Real-time notifications
- XP rewards (50-1000 XP)
- Beautiful achievement gallery

#### **Streak Tracking** 🔥
- Daily practice streaks
- Automatic detection
- Streak achievements (3, 7, 30 days)
- Longest streak record

### 🌍 Personalization Features

### 🎯 Interest-Based Learning
- **Personalized Examples**: Learn math through Minecraft, physics through sports, chemistry through cooking
- **10+ Interest Categories**: Gaming, Sports, Space, Animals, Music, Art, Coding, Movies, Books, Food
- **Dynamic Context**: AI adapts all examples to match student interests

### 🌍 Cultural Themes
Choose from 8 unique cultural themes that personalize the entire app experience:
- **Classic** 📘 - Traditional academic style
- **Japanese** 🌸 - Sakura, minimalism, respectful dialogue
- **Eastern** 🕌 - Rich patterns, golden accents, patient teaching
- **Cyberpunk** 🤖 - Neon, tech-focused, casual style
- **Scandinavian** 🌲 - Minimalist, natural, calm approach
- **Vibrant** 🌈 - Colorful, energetic, enthusiastic
- **African** 🦁 - Earth tones, community-focused
- **Latin American** 🎉 - Festive, warm, passionate

Each theme includes:
- Custom color schemes
- Unique dialog styles (casual, formal, respectful, enthusiastic)
- Cultural keywords and context
- Theme-specific animations

### 📚 Multiple Subjects
- **Mathematics** 🔢 - Algebra, geometry, calculus
- **Physics** ⚛️ - Mechanics, energy, forces
- **Chemistry** ⚗️ - Elements, reactions, molecules
- **Programming** 💻 - Coding, algorithms, data structures
- **Biology** 🧬 - Cells, genetics, ecology
- **English** 📝 - Grammar, writing, literature

### 🎨 Adaptive Learning Styles
- **Visual** 📊 - Charts, diagrams, visual representations
- **Practical** 🎯 - Hands-on examples and practice
- **Theoretical** 📖 - Detailed explanations and theory
- **Balanced** ⚖️ - Mix of all approaches
- **Quick** ⚡ - Fast, concise learning

### 💬 AI-Powered Tutoring
- **Socratic Method**: Guides students to discover answers themselves
- **Contextual Learning**: Uses student interests in every explanation
- **Multi-Mode Support**:
  - Explain concepts
  - Generate practice problems
  - Provide hints
  - Check solutions with feedback

## 🏗️ Architecture

### Tech Stack
- **Framework**: Flutter 3.8+
- **State Management**: Provider
- **Navigation**: go_router
- **Backend**: Supabase
- **AI**: OpenAI GPT-4 (via Supabase Edge Functions)
- **Storage**: SharedPreferences, SQLite
- **Charts**: fl_chart (for analytics)
- **Edge Functions**: TypeScript/Deno

### Supabase Edge Functions
Two serverless functions power the AI features:

**`ai-tutor`**: Personalized tutoring conversations
- GPT-4 integration
- Custom system prompts
- Interaction logging

**`generate-practice`**: AI problem generation
- Personalized to interests
- 5 problems per request
- Includes hints and solutions

### Project Structure
```
ai_tutor/
├── lib/
│   ├── models/
│   │   ├── interest.dart              # 10 predefined interests
│   │   ├── cultural_theme.dart        # 8 cultural themes
│   │   ├── user_profile.dart          # User preferences
│   │   ├── subject.dart               # 6 subjects
│   │   ├── chat_message.dart          # Chat messages
│   │   ├── progress.dart              # 📊 Progress tracking
│   │   ├── achievement.dart           # 🏆 12 achievements
│   │   └── practice_problem.dart      # 💪 Practice problems
│   ├── providers/
│   │   ├── user_profile_provider.dart # Profile management
│   │   ├── chat_provider.dart         # Chat state
│   │   ├── theme_provider.dart        # Theme switching
│   │   ├── progress_provider.dart     # 📊 Progress tracking
│   │   └── achievement_provider.dart  # 🏆 Achievement system
│   ├── services/
│   │   ├── ai_tutor_service.dart      # AI chat integration
│   │   └── practice_service.dart      # 💪 Problem generation
│   ├── screens/
│   │   ├── onboarding/                # 5-step onboarding
│   │   ├── home/                      # Main dashboard
│   │   ├── chat/                      # Tutor chat
│   │   ├── subjects/                  # Subject selection
│   │   ├── profile/                   # User profile
│   │   ├── progress/                  # 📊 Analytics dashboard
│   │   └── practice/                  # 💪 Practice mode
│   ├── navigation/
│   │   └── app_router.dart            # GoRouter config
│   └── main.dart
├── supabase/
│   └── functions/
│       ├── ai-tutor/                  # ⚡ Chat AI function
│       └── generate-practice/         # ⚡ Problem generator
└── pubspec.yaml
```

## 🎯 How It Works

### 1. Personalized Onboarding
Students complete a 5-step onboarding:
1. **Welcome** - Introduction to the app
2. **Interests** - Select 1-5 interests (Gaming, Sports, etc.)
3. **Cultural Theme** - Choose visual and dialog style
4. **Learning Style** - Select preferred teaching approach
5. **Level Assessment** - Set grade level per subject

### 2. AI Personalization Context
When a student asks a question, the AI receives:
```
User Profile:
- Interests: Minecraft, Space, Programming
- Cultural Theme: Cyberpunk (casual, tech-focused)
- Learning Style: Practical (examples & practice)
- Keywords: blocks, craft, rocket, planet, code, algorithm

Instructions:
- Use Minecraft and space examples
- Casual, tech-focused language
- Provide hands-on examples
```

### 3. Example Transformation

**Generic Problem:**
> "A train travels at 60 km/h. How far does it go in 2 hours?"

**Personalized (Minecraft + Space interests):**
> "Hey! Your spaceship in Minecraft travels at 60 blocks per second. If you fly for 120 seconds toward a distant planet, how many blocks will you travel? 🚀"

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.8 or higher
- Dart SDK 3.0 or higher
- Supabase account (for backend)
- OpenAI API key (optional, for direct integration)

### Installation

1. **Clone the repository**
```bash
cd ai_tutor
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Setup environment**
Create a `.env` file:
```env
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key
OPENAI_API_KEY=your_openai_key
```

4. **Run the app**
```bash
flutter run
```

## 🔧 Configuration

### Adding New Interests
Edit `lib/models/interest.dart`:
```dart
static const newInterest = Interest(
  id: 'new_interest',
  name: 'New Interest',
  emoji: '🎯',
  description: 'Description',
  keywords: ['keyword1', 'keyword2'],
  examples: ['Example 1', 'Example 2'],
);
```

### Adding New Cultural Themes
Edit `lib/models/cultural_theme.dart`:
```dart
static const newTheme = CulturalTheme(
  id: 'new_theme',
  name: 'New Theme',
  emoji: '✨',
  description: 'Description',
  colors: ThemeColors(...),
  dialogStyle: DialogStyle.casual,
  culturalKeywords: ['keyword1', 'keyword2'],
  animationStyle: AnimationStyle.moderate,
);
```

## 📊 Data Models

### UserProfile
- Selected interests (1-5)
- Cultural theme preference
- Learning style
- Subject levels (grade 1-12)
- Learning goals

### Interest
- 10 predefined interests
- Each with keywords for AI context
- Example sentences for personalization

### CulturalTheme
- 8 unique themes
- Custom color schemes
- Dialog style (casual/formal/respectful/enthusiastic)
- Animation preferences

## 🤝 Contributing

Contributions are welcome! Areas for improvement:
- Additional interests and themes
- More subjects (History, Geography, Languages)
- Voice input/output
- Gamification features
- Progress tracking and analytics
- Parent dashboard
- Offline mode

## 📄 License

This project is part of the VC portfolio.

## 🎉 What Makes This Special

### Traditional Education Apps:
> "Solve: 3x + 5 = 20"

### AI Tutor (Minecraft interest):
> "You're building a Minecraft fortress! You need 3 diamond blocks per tower plus 5 for the gate. You have 20 diamonds total. How many towers can you build? 🏰"

The same problem, but one that actually **engages** the student!

---

**Built with ❤️ for personalized learning**

Transform education from boring to brilliant! 🚀
