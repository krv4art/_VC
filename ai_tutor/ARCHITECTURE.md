# 🏗️ AI Tutor - Technical Architecture

**Complete technical documentation of the AI Tutor platform**

---

## Table of Contents

- [System Overview](#system-overview)
- [Technology Stack](#technology-stack)
- [Data Architecture](#data-architecture)
- [State Management](#state-management)
- [AI Integration](#ai-integration)
- [Personalization Engine](#personalization-engine)
- [Storage Strategy](#storage-strategy)
- [Performance Optimization](#performance-optimization)

---

## System Overview

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                      Flutter App (Client)                    │
│  ┌────────────┐  ┌────────────┐  ┌─────────────────────┐   │
│  │  Screens   │──│  Providers │──│  Services           │   │
│  │  (UI/UX)   │  │  (State)   │  │  (Business Logic)   │   │
│  └────────────┘  └────────────┘  └─────────────────────┘   │
│         │               │                    │               │
│         └───────────────┴────────────────────┘               │
│                         │                                    │
└─────────────────────────┼────────────────────────────────────┘
                          │
          ┌───────────────┴───────────────┐
          │                               │
    ┌─────▼──────┐               ┌───────▼──────┐
    │ Local      │               │  Supabase     │
    │ Storage    │               │  (Backend)    │
    │            │               │               │
    │ • SharedPref│               │ • Edge       │
    │ • SQLite   │               │   Functions  │
    └────────────┘               │ • Database   │
                                 │ • Auth       │
                                 └──────┬───────┘
                                        │
                                  ┌─────▼──────┐
                                  │  OpenAI    │
                                  │  GPT-4     │
                                  └────────────┘
```

---

## Technology Stack

### Frontend Layer

**Framework**: Flutter 3.8+
- **Why**: Cross-platform (iOS, Android, Web) with single codebase
- **Benefits**: Hot reload, rich UI widgets, native performance
- **Dart Version**: 3.0+

**State Management**: Provider Pattern
```dart
MultiProvider(
  providers: [
    ChangeNotifierProvider<UserProfileProvider>,
    ChangeNotifierProvider<ChatProvider>,
    ChangeNotifierProvider<ThemeProvider>,
    ChangeNotifierProvider<ProgressProvider>,
    ChangeNotifierProvider<AchievementProvider>,
    ChangeNotifierProvider<ChallengeProvider>,
    Provider<NotificationService>,
  ],
  child: App(),
)
```

**Navigation**: go_router 12.0+
- Declarative routing
- Deep linking support
- Type-safe navigation
- 13 routes configured

**UI Libraries**:
- `flutter_material3`: Modern Material Design
- `fl_chart`: Analytics visualizations
- `share_plus`: Social sharing
- `image_picker`: Profile photos (future)
- `camera`: Document scanning (future)

### Backend Layer

**BaaS**: Supabase
- PostgreSQL database
- Row Level Security (RLS)
- Real-time subscriptions
- RESTful API
- Authentication (planned)

**Edge Functions**: Deno/TypeScript
- Serverless compute
- GPT-4 integration
- Request/response streaming
- Environment secrets management

**AI**: OpenAI GPT-4 Turbo
- Model: `gpt-4-turbo-preview`
- Temperature: 0.7 (balanced creativity)
- Max tokens: 1000 (sufficient for tutoring)
- Context window: 128K tokens

### Storage Layer

**Local Storage**:
```dart
// User preferences (small data)
SharedPreferences: {
  'user_profile': JSON string
  'theme_mode': String
  'last_sync': Timestamp
}

// Structured data (future)
SQLite (sqflite): {
  sessions: []
  progress: []
  achievements: []
}
```

**Cloud Storage** (Planned):
- Supabase Storage for media files
- Database for user data sync
- Realtime for collaborative features

---

## Data Architecture

### Core Models

#### 1. Interest Model
```dart
class Interest {
  String id                    // Unique identifier
  String name                  // Display name
  String emoji                 // Visual icon
  String description           // Explanation
  List<String> keywords        // AI personalization keys (critical!)
  List<String> examples        // Sample sentences
  bool isCustom               // Predefined vs custom flag

  // Factory for custom interests
  factory Interest.custom({
    required String name,
    required String emoji,
    required List<String> keywords,
  }) {
    // ID: custom_name_timestamp for uniqueness
    final id = 'custom_${name.toLowerCase().replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}';
    return Interest(...);
  }
}

// Predefined interests: 10 (Gaming, Sports, Space, Animals, Music, Art, Coding, Movies, Books, Food)
// Custom interests: Unlimited
```

#### 2. UserProfile Model
```dart
class UserProfile {
  String? userId                        // Future: Supabase auth ID
  List<String> selectedInterests        // IDs of predefined interests
  List<Interest> customInterests        // Full custom Interest objects
  String culturalThemeId                // Selected theme ID
  LearningStyle learningStyle           // Enum
  Map<String, int> subjectLevels        // {subjectId: gradeLevel}
  List<String> goals                    // Learning objectives
  String preferredLanguage              // Default: 'en'
  DateTime createdAt
  DateTime? lastActiveAt

  // Computed property
  List<Interest> get interests {
    // Combines predefined + custom interests
    return [...predefinedInterests, ...customInterests];
  }
}

// Serialization: JSON to/from SharedPreferences
// Storage key: 'user_profile'
// Size: ~2-10 KB typical
```

#### 3. StudentProgress Model
```dart
class StudentProgress {
  String userId
  String subjectId
  int totalProblems                 // All attempted
  int solvedProblems               // Correctly solved
  int correctAnswers               // Correct on first try
  int currentStreak                // Days
  int longestStreak                // Record
  Map<String, int> topicProgress   // {topic: problemsSolved}
  List<String> masteredTopics      // Topics with high mastery
  int totalMinutesStudied
  int totalXP

  // Computed metrics
  double get accuracy => (correctAnswers / totalProblems) * 100;
  double get completionRate => (solvedProblems / totalProblems) * 100;
}
```

#### 4. Achievement Model
```dart
class Achievement {
  String id
  String name
  String emoji
  String description
  AchievementType type           // Enum: problemsSolved, streaks, performance, dedication
  int targetValue               // Goal to unlock
  int currentValue              // Current progress
  int xpReward                  // XP earned on unlock
  DateTime? unlockedAt

  bool get isUnlocked => unlockedAt != null;
  double get progress => (currentValue / targetValue).clamp(0.0, 1.0);
}

// 12 achievements total
// Categories: 4 (Problems: 3, Streaks: 3, Performance: 3, Dedication: 3)
// Total XP available: 5400
```

#### 5. DailyChallenge & StudyGoal Models
```dart
class DailyChallenge {
  String subjectId
  String topic
  String title                  // Auto-generated
  int targetProblems            // Random 3-10
  int currentProgress
  int difficulty                // Random 1-10
  int xpReward                  // Bonus XP
  DateTime date                 // Today's date
  bool isCompleted
}

class StudyGoal {
  String id                     // UUID
  String title
  GoalType type                 // Enum: problemsSolved, accuracy, streak, studyTime, topicMastery
  int targetValue
  int currentValue
  DateTime createdAt
  DateTime deadline
  bool isCompleted

  double get progress => (currentValue / targetValue).clamp(0.0, 1.0);
  int get daysRemaining => deadline.difference(DateTime.now()).inDays;
}
```

---

## State Management

### Provider Architecture

**Why Provider?**
- Simple, scalable
- Built by Flutter team
- Excellent performance
- Easy testing
- No boilerplate

**6 Providers**:

#### 1. UserProfileProvider
```dart
class UserProfileProvider with ChangeNotifier {
  UserProfile _profile = UserProfile();
  bool _isLoading = false;

  // Getters
  UserProfile get profile => _profile;
  List<Interest> get allInterests => _profile.interests;
  List<Interest> get customInterests => _profile.customInterests;

  // Methods
  Future<void> updateInterests(List<String> ids);
  Future<void> addCustomInterest(Interest interest);
  Future<void> removeCustomInterest(String id);
  Future<void> updateCulturalTheme(String themeId);
  Future<void> updateLearningStyle(LearningStyle style);

  String getPersonalizationContext() {
    // Builds AI system prompt with interests, keywords, theme
  }
}
```

#### 2. ProgressProvider
```dart
class ProgressProvider with ChangeNotifier {
  Map<String, StudentProgress> _progressBySubject = {};
  Session? _currentSession;

  Future<void> startSession(String userId, String subjectId);
  Future<void> endSession();
  Future<void> recordProblemAttempt({
    required bool isCorrect,
    required String topic,
    bool usedHint = false,
  });

  Map<String, dynamic> getOverallStats();
}
```

#### 3. AchievementProvider
```dart
class AchievementProvider with ChangeNotifier {
  List<Achievement> _achievements = Achievements.all;

  Future<List<Achievement>> checkAchievements(StudentProgress progress);
  Future<void> unlockAchievement(String achievementId);

  List<Achievement> get unlockedAchievements;
  List<Achievement> get lockedAchievements;
  int get totalXP;
}
```

#### 4. ChallengeProvider
```dart
class ChallengeProvider with ChangeNotifier {
  DailyChallenge? _todayChallenge;
  List<StudyGoal> _activeGoals = [];
  List<StudyGoal> _completedGoals = [];

  Future<void> generateDailyChallenge();
  Future<void> addGoal(StudyGoal goal);
  Future<void> checkGoalsProgress({...});

  DailyChallenge? get todayChallenge;
  bool get isChallengeCompleted;
}
```

#### 5. ChatProvider
```dart
class ChatProvider with ChangeNotifier {
  List<ChatMessage> _messages = [];
  bool _isLoading = false;

  void addUserMessage(String content);
  void addAssistantMessage(String content);
  void clear();

  List<Map<String, String>> getChatHistory({int maxMessages = 10});
}
```

#### 6. ThemeProvider
```dart
class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  void setThemeMode(ThemeMode mode);

  ThemeMode get themeMode;
  bool get isDarkMode;
}
```

**Provider Lifecycle**:
```
App Start
   │
   ├─► MultiProvider initialization
   │   └─► Each provider initialized
   │
   ├─► UserProfileProvider.initialize()
   │   └─► Load from SharedPreferences
   │
   ├─► ProgressProvider.initialize()
   │   └─► Load progress data
   │
   └─► ChallengeProvider.initialize()
       └─► Check if new day → generate challenge
```

---

## AI Integration

### Architecture

```
User Input
   │
   ├─► UserProfileProvider.getPersonalizationContext()
   │   └─► Returns: interests, keywords, theme, style
   │
   ├─► AITutorService.sendMessage()
   │   ├─► Build system prompt
   │   ├─► Format chat history
   │   └─► Call Supabase Edge Function
   │           │
   │           ├─► ai-tutor function (Deno)
   │           │   ├─► Validate request
   │           │   ├─► Build GPT-4 messages array
   │           │   └─► Call OpenAI API
   │           │           │
   │           │           ├─► GPT-4 processing
   │           │           │   └─► Uses keywords for personalization
   │           │           │
   │           │           └─► Response
   │           │
   │           └─► Return to app
   │
   └─► ChatProvider.addAssistantMessage()
       └─► UI updates via notifyListeners()
```

### System Prompt Engineering

**Structure**:
```
[Role Definition]
You are an AI tutor for a [grade level] student.

[Personalization Context]
Student Profile:
- Interests: [comma-separated list]
- Keywords for examples: [blocks, build, craft, ...]
- Cultural Theme: [theme name] ([dialog style])
- Learning Style: [style name]

[Teaching Instructions]
- Use Socratic method
- Incorporate keywords naturally
- Match dialog style ([casual/formal/respectful/enthusiastic])
- Provide [visual/practical/theoretical/balanced/quick] explanations

[Example Transformation]
Generic: "Calculate area of rectangle"
Personalized: "Your LEGO baseplate is 16x24 studs. What's the area?"

[Conversation History]
[Last N messages]

[Current Question]
User: [message]
```

**Dynamic Generation**:
```dart
String _buildSystemPrompt({
  required UserProfile userProfile,
  required Subject subject,
  required TutorMode mode,
}) {
  final interests = userProfile.interests.map((i) => i.name).join(', ');
  final keywords = userProfile.interests
      .expand((i) => i.keywords)
      .take(15)  // Limit for token efficiency
      .join(', ');

  final theme = userProfile.culturalTheme;
  final dialogStyle = theme.dialogStyle.name;
  final learningStyle = userProfile.learningStyle.displayName;

  return '''
You are a $dialogStyle AI tutor teaching ${subject.name}.

Student Interests: $interests
Use these keywords in examples: $keywords
Dialog Style: $dialogStyle
Learning Style: $learningStyle

Adapt all explanations to student's interests!
''';
}
```

### Token Management

**Limits**:
- System prompt: ~300-500 tokens
- Chat history: Last 10 messages (~500-1000 tokens)
- User message: ~50-200 tokens
- Response max: 1000 tokens

**Total**: ~1850-2700 tokens per request (well under GPT-4's 128K limit)

**Cost Optimization**:
- Use `gpt-4-turbo-preview` (cheaper than `gpt-4`)
- Limit chat history to 10 messages
- Cache system prompts when possible
- Batch requests for practice problems (5 at once)

---

## Personalization Engine

### Keyword Matching System

**How AI uses keywords**:

1. **Problem Generation**:
```
Generic template: "Calculate distance traveled at speed S for time T"

With keywords [blocks, craft, build] (LEGO interest):
→ "You're building in Minecraft! You travel at 5 blocks per second. How far in 30 seconds?"
```

2. **Concept Explanations**:
```
Generic: "Fractions represent parts of a whole"

With keywords [T-Rex, fossil, Jurassic] (Dinosaurs interest):
→ "Imagine a T-Rex skeleton with 200 bones. If we've found 3/4 of them, that's like dividing the whole skeleton into 4 equal parts and having 3 parts..."
```

3. **Hints**:
```
Generic: "Think about the relationship between numerator and denominator"

With keywords [camera, lens, shutter] (Photography interest):
→ "Think of it like your camera's aperture - f/2.8 means the denominator is 2.8. Smaller number = larger opening!"
```

### Cultural Theme Application

**Dialog Style Transformation**:

| Style | Generic | Themed |
|-------|---------|--------|
| **Casual** (Cyberpunk) | "Let's solve this problem" | "Yo! Let's crack this code 🤖" |
| **Formal** (Classic) | "We will now solve" | "We shall now proceed to solve this problem" |
| **Respectful** (Japanese) | "Please solve" | "I would be honored to guide you through this concept" |
| **Enthusiastic** (Vibrant) | "Let's learn" | "OMG let's make this AWESOME! 🌟" |

**Color Scheme Application**:
```dart
// Example: Japanese theme
ThemeColors(
  primary: Color(0xFFFFB7C5),     // Sakura pink
  secondary: Color(0xFF4A4E69),   // Indigo
  background: Color(0xFFFFF8F0),  // Warm white
  surface: Color(0xFFFFFFFF),     // Pure white
  error: Color(0xFFD32F2F),       // Red
)

// Applied throughout app:
- AppBar background
- Button colors
- Progress bars
- Achievement badges
- Card highlights
```

---

## Storage Strategy

### Data Persistence

**SharedPreferences** (Key-Value):
```dart
Keys:
  'user_profile'          // JSON string (~2-10 KB)
  'custom_interests'      // JSON array (~1-5 KB)
  'progress_math'         // JSON (~1 KB per subject)
  'progress_physics'
  'progress_chemistry'
  'progress_programming'
  'progress_biology'
  'progress_english'
  'achievements'          // JSON array (~2 KB)
  'daily_challenge'       // JSON (~0.5 KB)
  'study_goals'           // JSON array (~1-3 KB)
  'theme_mode'            // String ('light'/'dark'/'system')
  'last_streak_check'     // ISO timestamp

Total typical size: ~15-30 KB (very small!)
```

**SQLite** (Future - for complex queries):
```sql
-- Sessions table
CREATE TABLE sessions (
  id TEXT PRIMARY KEY,
  user_id TEXT,
  subject_id TEXT,
  start_time INTEGER,
  end_time INTEGER,
  problems_attempted INTEGER,
  problems_correct INTEGER,
  xp_earned INTEGER
);

-- Progress snapshots (for trends)
CREATE TABLE progress_snapshots (
  id TEXT PRIMARY KEY,
  user_id TEXT,
  subject_id TEXT,
  snapshot_date INTEGER,
  total_problems INTEGER,
  accuracy REAL,
  current_streak INTEGER
);

CREATE INDEX idx_sessions_user ON sessions(user_id);
CREATE INDEX idx_snapshots_date ON progress_snapshots(snapshot_date);
```

### Data Sync Strategy (Planned)

**Offline-First Architecture**:
```
1. All data stored locally first
2. Background sync to Supabase when online
3. Conflict resolution: last-write-wins
4. Delta sync for efficiency
```

**Sync Triggers**:
- App start (if online)
- Every 5 minutes (background)
- On profile changes (immediate)
- On achievement unlock (immediate)
- Manual refresh button

---

## Performance Optimization

### Rendering Optimization

**Const Constructors**:
```dart
// All widgets use const where possible
const Text('Hello')
const SizedBox(height: 16)
const Icon(Icons.check)

// Reduces widget rebuilds
```

**ListView.builder** for long lists:
```dart
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    // Only builds visible items + small buffer
    return ItemWidget(item: items[index]);
  },
)
```

**RepaintBoundary** for expensive widgets:
```dart
RepaintBoundary(
  child: Chart(...),  // Complex fl_chart widget
)
```

### Memory Management

**Image Caching**:
```dart
// Use cached_network_image for profile photos
CachedNetworkImage(
  imageUrl: url,
  memCacheWidth: 200,  // Resize in memory
  maxHeightDiskCache: 400,
)
```

**Lazy Loading**:
```dart
// Don't load all achievements at once
List<Achievement> get visibleAchievements {
  return _achievements.take(6).toList();  // Load more on scroll
}
```

### Network Optimization

**Batch Requests**:
```dart
// Generate 5 problems in one request instead of 5 separate calls
final problems = await practiceService.generateProblems(
  subjectId: 'math',
  count: 5,  // Batch!
);
```

**Request Debouncing**:
```dart
// Don't send every keystroke to AI
Timer? _debounce;

void onSearchChanged(String query) {
  _debounce?.cancel();
  _debounce = Timer(Duration(milliseconds: 500), () {
    performSearch(query);
  });
}
```

**Caching**:
```dart
// Cache AI responses for common questions
final cache = <String, String>{};

Future<String> sendMessage(String message) async {
  if (cache.containsKey(message)) {
    return cache[message]!;
  }

  final response = await aiService.sendMessage(message);
  cache[message] = response;
  return response;
}
```

---

## Security Considerations

### API Key Protection

**Environment Variables**:
```dart
// NEVER commit .env file
// Use .env.example as template

const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
const supabaseKey = String.fromEnvironment('SUPABASE_ANON_KEY');

// Keys never in source code
```

**Edge Function Secrets**:
```bash
# Stored securely in Supabase
supabase secrets set OPENAI_API_KEY=sk-xxx

# Not accessible from client
```

### Data Privacy

**Local Storage Only** (Current):
- All user data stays on device
- No server-side storage yet
- No tracking or analytics
- GDPR-compliant by design

**Future (with Supabase Auth)**:
- Row Level Security (RLS) policies
- End-to-end encryption for sensitive data
- User data deletion on request
- COPPA compliance for students under 13

### Input Validation

**Client-Side**:
```dart
// Validate before sending to AI
if (message.length > 1000) {
  throw Exception('Message too long');
}

if (message.trim().isEmpty) {
  throw Exception('Empty message');
}
```

**Server-Side** (Edge Functions):
```typescript
// Validate all inputs
if (!request.message || typeof request.message !== 'string') {
  return new Response('Invalid message', { status: 400 });
}

// Sanitize before sending to OpenAI
const sanitized = sanitizeInput(request.message);
```

---

## Deployment Architecture

### Current (MVP)

```
Developer Machine
   │
   ├─► flutter build apk (Android)
   ├─► flutter build ios (iOS)
   └─► flutter build web (Web)

   Manual deployment to stores/hosting
```

### Planned (Production)

```
GitHub Repository
   │
   ├─► Push to main branch
   │
   ├─► GitHub Actions CI/CD
   │   ├─► Run tests
   │   ├─► Build for iOS
   │   ├─► Build for Android
   │   ├─► Build for Web
   │   └─► Deploy Edge Functions
   │
   ├─► Fastlane (Mobile)
   │   ├─► Upload to App Store
   │   └─► Upload to Play Store
   │
   └─► Vercel/Netlify (Web)
       └─► Deploy to CDN
```

---

## Conclusion

This architecture provides:
- ✅ **Scalability**: Can handle millions of users
- ✅ **Performance**: Optimized for mobile devices
- ✅ **Maintainability**: Clean separation of concerns
- ✅ **Extensibility**: Easy to add new features
- ✅ **Security**: API keys protected, data privacy
- ✅ **Cost-Effective**: Serverless, efficient token usage

**Next Steps**:
1. Add Supabase authentication
2. Implement cloud sync
3. Set up CI/CD pipeline
4. Add comprehensive testing
5. Performance monitoring

---

**Document Version**: 1.0
**Last Updated**: 2025-11-18
**Author**: AI Tutor Development Team
