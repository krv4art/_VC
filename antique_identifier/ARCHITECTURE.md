# Antique Identifier - Architecture & Integration Guide

## Overview

The Antique Identifier follows a **service-oriented architecture** inspired by ACS (AI Cosmetics Scanner) best practices, adapted for antique valuation and historical analysis.

## 🏗️ Layered Architecture

```
┌─────────────────────────────────────────────┐
│         UI Layer (Screens & Widgets)        │
│     (ScanScreen, ResultsScreen, ChatScreen) │
└────────────────────┬────────────────────────┘
                     │
┌────────────────────▼────────────────────────┐
│       State Management (Provider)            │
│  (ChatProvider, AnalysisProvider, etc.)     │
└────────────────────┬────────────────────────┘
                     │
┌────────────────────▼────────────────────────┐
│         Service Layer (Business Logic)       │
│  • AntiqueIdentificationService             │
│  • ChatService                              │
│  • PromptBuilderService                     │
│  • SupabaseService                          │
└────────────────────┬────────────────────────┘
                     │
┌────────────────────▼────────────────────────┐
│       External APIs & Databases             │
│  • Google Gemini 2.0 Flash (via Supabase)   │
│  • Supabase PostgreSQL                      │
│  • Supabase Storage                         │
└─────────────────────────────────────────────┘
```

## 🔌 Service Integration

### 1. AntiqueIdentificationService

**Purpose**: Analyzes antique photos using Gemini Vision API

**Key Methods**:
```dart
Future<AnalysisResult> analyzeAntiqueImage(
  Uint8List imageBytes,
  {required String languageCode}
)
```

**Flow**:
```
Image → Compress → Base64 → Gemini API → JSON → Parse → AnalysisResult
```

**Example Usage**:
```dart
final service = AntiqueIdentificationService();
final result = await service.analyzeAntiqueImage(
  imageBytes,
  languageCode: 'en',
);

print('Item: ${result.itemName}');
print('Period: ${result.estimatedPeriod}');
print('Value: ${result.priceEstimate?.getFormattedRange()}');
```

**Error Handling**:
- Network errors → TimeoutException
- Invalid JSON → Returns default structure with warnings
- API failures → Exception with status code

### 2. PromptBuilderService

**Purpose**: Creates specialized prompts for antique analysis

**Key Methods**:
```dart
static String buildAntiqueAnalysisPrompt(String languageCode)
```

**Features**:
- 30+ language support
- Enforces JSON output format
- Includes detailed instructions for materials, history, valuation
- Handles non-antique items with humor

**Language Support**:
- Russian (ru)
- Ukrainian (uk)
- Spanish (es)
- English (en)
- German (de)
- French (fr)
- Italian (it)
- +20 more supported

**Prompt Structure**:
```
1. Object Type Determination
   - Is this an antique?
   - Return humorous message if not

2. Full Analysis (if antique)
   - Item identification
   - Materials & construction
   - Historical context
   - Period & origin estimation
   - Authenticity assessment
   - Price estimation
   - Market comparables

3. Language-Specific Output
   - All text in requested language
   - Cultural terminology
   - Region-appropriate pricing
```

### 3. ChatService

**Purpose**: Interactive Q&A about analyzed antiques

**Key Methods**:
```dart
Future<String> sendMessage(
  String message,
  {required String languageCode, String? antiqueContext}
)

void clearHistory()
List<ChatMessage> getHistory()
```

**Features**:
- Maintains chat history automatically
- Uses antique analysis as context
- Multi-language support
- Expert knowledge base

**System Prompt Includes**:
- Expert antique knowledge
- Market trends awareness
- Authenticity assessment
- Care & preservation tips
- Price discussion guidelines

**Example Usage**:
```dart
final chatService = ChatService();

// Ask about an antique
final response = await chatService.sendMessage(
  'What era is this chair from?',
  languageCode: 'en',
  antiqueContext: jsonEncode(analysisResult.toJson()),
);

print(response); // AI response about the chair

// Get conversation history
final messages = chatService.getHistory();
```

### 4. SupabaseService

**Purpose**: Cloud database and storage management

**Key Methods**:
```dart
// Analysis Results
Future<String> saveAnalysisResult(AnalysisResult result)
Future<AnalysisResult?> getAnalysisResult(String resultId)

// Dialogues (Chat Sessions)
Future<int?> createDialogue(String title, ...)
Future<List<Dialogue>> getAllDialogues()
Future<Dialogue?> getDialogue(int dialogueId)

// Chat Messages
Future<void> saveMessage(ChatMessage message)
Future<List<ChatMessage>> getMessages(int dialogueId)

// Image Storage
Future<String> uploadImage(List<int> imageBytes, String fileName)

// Cleanup
Future<void> deleteDialogue(int dialogueId)
```

**Database Schema**:

**antique_analyses**:
```sql
id UUID PRIMARY KEY
item_name TEXT
category TEXT
description TEXT
materials JSONB
historical_context TEXT
estimated_period TEXT
estimated_origin TEXT
price_estimate JSONB
warnings TEXT[]
authenticity_notes TEXT
similar_items TEXT[]
ai_summary TEXT
is_antique BOOLEAN
created_at TIMESTAMP
```

**dialogues**:
```sql
id SERIAL PRIMARY KEY
title TEXT
antique_image_path TEXT
analysis_result_id UUID (FK)
created_at TIMESTAMP
updated_at TIMESTAMP
```

**chat_messages**:
```sql
id SERIAL PRIMARY KEY
dialogue_id INTEGER (FK)
text TEXT
is_user BOOLEAN
timestamp TIMESTAMP
antique_image_path TEXT
```

**Storage Bucket**:
```
antique_photos/
├── antiques/
│   └── {uuid}_{filename}
```

**Example Usage**:
```dart
final supabase = SupabaseService();

// Save analysis
final analysisId = await supabase.saveAnalysisResult(result);

// Create dialogue
final dialogueId = await supabase.createDialogue(
  'Victorian Chair Analysis',
  analysisResultId: analysisId,
);

// Get all past analyses
final dialogues = await supabase.getAllDialogues();

// Upload image
final imageUrl = await supabase.uploadImage(
  imageBytes,
  'my_antique_${DateTime.now().millisecondsSinceEpoch}.jpg',
);
```

## 🔄 Data Flow Examples

### Complete Analysis Flow

```
1. User selects photo
   XFile image
   ↓
2. Image processing
   Compress → imageBytes
   ↓
3. Send to Gemini
   AntiqueIdentificationService.analyzeAntiqueImage(imageBytes, 'en')
   ├─ PromptBuilderService.buildAntiqueAnalysisPrompt('en')
   ├─ Gemini API analyzes with prompt
   └─ Parse response → AnalysisResult
   ↓
4. Save to database
   SupabaseService.saveAnalysisResult(result) → analysisId
   ├─ Store analysis data
   └─ Upload image to storage
   ↓
5. Create dialogue
   SupabaseService.createDialogue(title, analysisId) → dialogueId
   ↓
6. Display results
   Show AnalysisResult to user
   ↓
7. Chat interaction (optional)
   ChatService.sendMessage(question, antiqueContext)
   ├─ Maintain chat history
   └─ Store messages in database
```

### Image Analysis Request Flow

```
┌─ Client (Flutter App)
│
├─ XFile (image)
│   ↓
├─ ImageCompressionService.compress()
│   ↓
├─ Base64 encoding
│   ↓
├─ JSON request body:
│   {
│     "contents": [{
│       "parts": [
│         {"inline_data": {"mime_type": "image/png", "data": "..."}},
│         {"text": "PROMPT"}
│       ]
│     }]
│   }
│   ↓
├─ HTTP POST
│   ↓
└─ Supabase Edge Function (gemini-vision-proxy)
   ├─ Adds authentication
   ├─ Calls Gemini Vision API
   ├─ Returns response to client
   └─ Client parses JSON
       ↓
       AnalysisResult object
```

## 🔐 API Authentication

**No User Authentication Required**:
- Public anonymous access
- Supabase anon key embedded in app
- Database allows public read/write to demo tables
- Storage bucket is public

**Security Considerations for Production**:
```dart
// In production, implement:
// 1. User authentication (email/OAuth)
// 2. Row-level security (RLS) policies
// 3. Rate limiting per user
// 4. Image scanning for malicious content
// 5. API key rotation
// 6. Request signing

// Current development setup:
const String supabaseUrl = 'https://yerbryysrnaraqmbhqdm.supabase.co';
const String supabaseAnonKey = 'eyJ...'; // Public anon key
```

## 📊 Error Handling Strategy

### Service-Level Errors

**AntiqueIdentificationService**:
```dart
try {
  analyzeImage()
} on TimeoutException {
  // Handle slow network
} on FormatException {
  // Handle invalid response JSON
} catch (e) {
  // Handle network/API errors
}
```

**ChatService**:
```dart
try {
  sendMessage()
} on TimeoutException {
  // User feedback: "Request timed out"
} catch (e) {
  // Generic error handling
}
```

**SupabaseService**:
```dart
try {
  saveAnalysisResult()
} catch (e) {
  // Database errors
  debugPrint('Error saving: $e');
  // Fallback: Save to local SQLite
}
```

### UI-Level Error Handling

Should be implemented in Providers/Screens:
```dart
// Show loading spinner
// Handle API errors with user-friendly messages
// Implement retry logic
// Log errors for debugging
// Provide offline fallback
```

## 🧪 Testing Guide

### Unit Tests (Services)

```dart
// Test AntiqueIdentificationService
test('analyzeAntiqueImage returns valid AnalysisResult', () async {
  final service = AntiqueIdentificationService();
  final result = await service.analyzeAntiqueImage(
    testImageBytes,
    languageCode: 'en',
  );

  expect(result.isAntique, true);
  expect(result.itemName, isNotEmpty);
  expect(result.priceEstimate, isNotNull);
});

// Test PromptBuilderService
test('buildAntiqueAnalysisPrompt includes language instruction', () {
  final prompt = PromptBuilderService.buildAntiqueAnalysisPrompt('ru');
  expect(prompt, contains('РУССКОМ'));
  expect(prompt, contains('JSON'));
});

// Test ChatService
test('sendMessage maintains history', () async {
  final service = ChatService();
  await service.sendMessage('test', languageCode: 'en');

  final history = service.getHistory();
  expect(history.length, greaterThan(0));
});
```

### Integration Tests

```dart
// Test full analysis flow
test('Full antique analysis workflow', () async {
  // 1. Analyze image
  // 2. Save to database
  // 3. Create dialogue
  // 4. Send chat message
  // 5. Retrieve results
});
```

## 📦 Dependency Injection

Current setup is simple, but can be enhanced:

```dart
// Current: Direct instantiation
final service = AntiqueIdentificationService();

// Better: Singleton pattern
class Services {
  static final _antique = AntiqueIdentificationService();
  static AntiqueIdentificationService get antique => _antique;
}

// Best: Provider package with dependency injection
final antiqueServiceProvider = Provider<AntiqueIdentificationService>(
  (ref) => AntiqueIdentificationService(),
);
```

## 🚀 Performance Considerations

1. **Image Compression**:
   - Reduce file size by ~70%
   - Faster upload time
   - Lower API costs

2. **Chat History**:
   - Keep in memory for current session
   - Persist to database
   - Implement pagination for long chats

3. **Caching**:
   - Cache analysis results locally
   - Avoid re-uploading same image
   - Implement cache invalidation

4. **Concurrent Requests**:
   - Handle multiple analyses in queue
   - Show progress indicators
   - Cancel long-running requests

## 📚 Implementation Timeline

### Phase 1: Core Services (✅ Complete)
- Data models
- API services
- Supabase integration
- Prompt engineering

### Phase 2: UI Implementation (Pending)
- Home screen
- Scan/upload screen
- Results display screen
- Chat interface
- History/collection view

### Phase 3: Features (Pending)
- Local database (SQLite)
- Offline mode
- Export/share results
- Multi-language UI
- Favorites/collections

### Phase 4: Polish (Pending)
- Animations
- Performance optimization
- Error recovery
- Analytics
- User feedback system

## 🔗 Related Files

- **Models**: `lib/models/analysis_result.dart`
- **Services**: `lib/services/*`
- **Config**: Configuration files for API endpoints
- **Tests**: `test/` directory (to be created)

## 📞 API Endpoints

### Gemini Vision (Image Analysis)
```
POST https://yerbryysrnaraqmbhqdm.supabase.co/functions/v1/gemini-vision-proxy
Content-Type: application/json

Request:
{
  "contents": [{
    "parts": [
      {"inline_data": {"mime_type": "image/png", "data": "base64_image"}},
      {"text": "prompt_text"}
    ]
  }]
}

Response:
{
  "candidates": [{
    "content": {
      "parts": [{
        "text": "json_response"
      }]
    }
  }]
}
```

### Supabase REST API
```
GET    /rest/v1/antique_analyses?id=eq.{id}
POST   /rest/v1/antique_analyses
GET    /rest/v1/dialogues?order=created_at.desc
POST   /rest/v1/dialogues
GET    /rest/v1/chat_messages?dialogue_id=eq.{id}
POST   /rest/v1/chat_messages
```

## 🎯 Next Steps

1. Implement UI screens based on models
2. Add state management with Provider
3. Create navigation structure
4. Add localization (30+ languages)
5. Implement image compression
6. Add error handling in UI
7. Test with real antique photos
8. Optimize performance

---

**Last Updated**: November 2024
**Maintainer**: Architecture team
