# Antique Identifier

AI-powered antique item identifier with expert descriptions, historical context, and valuation.

## 📋 Overview

The Antique Identifier is a Flutter application that uses advanced AI (Google Gemini) to analyze photographs of antique items and provide:

1. **Identification**: Accurate identification of the antique item, its category, and basic description
2. **Historical Context**: Detailed historical and cultural information about the item's era, origin, and significance
3. **Material Analysis**: Identification of materials used and their characteristics
4. **Expert Valuation**: Approximate market price estimation with confidence levels
5. **Authenticity Assessment**: Analysis of authenticity indicators and construction methods
6. **Interactive Chat**: Ask follow-up questions about specific items in an intelligent Q&A interface
7. **Collection Management**: Save and organize analyzed antiques for future reference

## 🏗️ Project Structure

```
antique_identifier/
├── lib/
│   ├── models/                      # Data models
│   │   ├── analysis_result.dart      # Antique analysis results structure
│   │   ├── dialogue.dart             # Chat dialogue model
│   │   └── chat_message.dart         # Chat message model
│   ├── services/                    # Business logic & API integration
│   │   ├── antique_identification_service.dart    # Gemini API integration for antique analysis
│   │   ├── prompt_builder_service.dart            # Prompt engineering for antique analysis
│   │   ├── chat_service.dart                      # Chat with AI about antiques
│   │   └── supabase_service.dart                  # Database & cloud storage
│   ├── screens/                     # UI Screens (to be implemented)
│   ├── widgets/                     # Reusable UI components (to be implemented)
│   ├── providers/                   # State management (to be implemented)
│   └── main.dart                    # Application entry point
├── assets/
│   ├── config/                      # Configuration files
│   ├── images/                      # App images and icons
│   └── fonts/                       # Custom fonts
├── pubspec.yaml                     # Project dependencies
└── README.md                        # This file
```

## 🔧 Architecture

### 1. **Data Models** (`lib/models/`)
- **AnalysisResult**: Complete antique analysis including materials, history, pricing, and authenticity notes
- **PriceEstimate**: Market valuation with confidence levels and comparable sales data
- **MaterialInfo**: Information about materials used in the item
- **Dialogue**: Chat session containing analysis results and messages
- **ChatMessage**: Individual chat messages (user or AI)

### 2. **Services** (`lib/services/`)

#### AntiqueIdentificationService
- Analyzes uploaded photos using Google Gemini 2.0 Flash
- Returns structured AnalysisResult with all relevant information
- Handles image compression and Base64 encoding
- Manages API communication through Supabase proxy

#### PromptBuilderService
- Constructs detailed prompts for antique analysis
- Supports 30+ languages with culturally-appropriate terminology
- Enforces JSON output format from AI responses
- Provides language-specific instructions and examples

#### ChatService
- Manages interactive Q&A about analyzed antiques
- Maintains chat history context
- Handles message serialization and API requests
- Supports follow-up questions with item-specific context

#### SupabaseService
- Cloud database for storing analysis results and chat history
- File storage for antique photos
- User dialogues and conversation management
- Handles authentication and data persistence

### 3. **AI Integration**

#### Gemini Vision API (via Supabase Edge Function)
```
User Photo → Base64 Encoding → Gemini Vision → JSON Response → Parsing
```

**Endpoint**: `https://yerbryysrnaraqmbhqdm.supabase.co/functions/v1/gemini-vision-proxy`

#### Features:
- Multi-modal analysis (image + text prompts)
- Supports Russian, Ukrainian, Spanish, English, German, French, Italian, and more
- Returns structured JSON with all analysis components
- Automatic non-antique detection with humorous responses

### 4. **Database Structure** (Supabase)

#### Tables:
- `antique_analyses`: Stores analysis results
- `dialogues`: Chat sessions linked to analyses
- `chat_messages`: Individual messages within dialogues

#### Storage:
- `antique_photos` bucket: Stores uploaded images

## 🚀 Key Features

### ✅ Implemented

1. **Core Data Models**
   - AnalysisResult with all required fields
   - PriceEstimate with confidence levels
   - MaterialInfo for material analysis
   - Dialogue and ChatMessage models
   - Full JSON serialization/deserialization

2. **AI Services**
   - AntiqueIdentificationService for image analysis
   - PromptBuilderService with multilingual support
   - ChatService for interactive Q&A
   - Direct Gemini API integration via Supabase proxy

3. **Backend Integration**
   - SupabaseService for database operations
   - Cloud storage for photos
   - Authentication-free design (public bucket)
   - Automatic result persistence

4. **Project Foundation**
   - Proper Flutter project structure
   - All core dependencies in pubspec.yaml
   - Comprehensive error handling
   - Debug logging throughout

### 📋 To Be Implemented

1. **UI Screens**
   - HomeScreen: Main interface with scan button
   - ScanScreen: Camera/gallery photo selection
   - ResultsScreen: Display antique analysis with formatted results
   - ChatScreen: Interactive Q&A interface
   - HistoryScreen: View past analyses
   - DetailsScreen: Full antique details

2. **State Management**
   - Provider-based state management
   - Chat history provider
   - Analysis result caching
   - Loading and error states

3. **UI Components**
   - PriceEstimateWidget: Display valuation with formatting
   - WarningsBanner: Show accuracy warnings prominently
   - MaterialsList: Display materials in card format
   - ChatBubble: Message rendering
   - LoadingAnimation: Progress indicators

4. **Localization**
   - Multi-language support (30+ languages)
   - Translated UI strings
   - Language-specific formatting (prices, dates)

5. **Additional Features**
   - Image compression before upload
   - Offline mode with SQLite
   - User preferences (language, currency)
   - Collection management
   - Export/share functionality
   - Photo guidelines/tutorial

## 📦 Dependencies

### Key Libraries:
- **flutter**: Core framework
- **provider**: State management
- **go_router**: Navigation (ready for use)
- **camera/image_picker**: Photo capture
- **flutter_image_compress**: Image optimization
- **http**: API requests
- **supabase_flutter**: Backend services
- **sqflite**: Local database (optional)

## 🔐 API Configuration

### Supabase Setup:
```dart
URL: https://yerbryysrnaraqmbhqdm.supabase.co
ANON KEY: (included in supabase_service.dart)
```

### Required Database Tables:
```sql
CREATE TABLE antique_analyses (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  item_name TEXT NOT NULL,
  category TEXT,
  description TEXT,
  materials JSONB,
  historical_context TEXT,
  estimated_period TEXT,
  estimated_origin TEXT,
  price_estimate JSONB,
  warnings TEXT[],
  authenticity_notes TEXT,
  similar_items TEXT[],
  ai_summary TEXT,
  is_antique BOOLEAN,
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE dialogues (
  id SERIAL PRIMARY KEY,
  title TEXT NOT NULL,
  antique_image_path TEXT,
  analysis_result_id UUID REFERENCES antique_analyses(id),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP
);

CREATE TABLE chat_messages (
  id SERIAL PRIMARY KEY,
  dialogue_id INTEGER REFERENCES dialogues(id) ON DELETE CASCADE,
  text TEXT NOT NULL,
  is_user BOOLEAN DEFAULT FALSE,
  timestamp TIMESTAMP DEFAULT NOW(),
  antique_image_path TEXT
);
```

### Required Storage Bucket:
```
Bucket: antique_photos
Access: Public (for image serving)
Path: antiques/{filename}
```

## 🎯 How It Works

### 1. User Takes/Selects Photo
```
Camera/Gallery → ImageFile (XFile)
```

### 2. Image Analysis
```
XFile → Compress → Base64 Encode → Send to Gemini (via Supabase)
↓
Gemini analyzes with specialized antique prompt
↓
Returns JSON with analysis results
↓
Parse and create AnalysisResult object
↓
Save to Supabase database
```

### 3. Chat About Results
```
User Question + Previous Analysis Context → Send to Gemini
↓
Gemini responds as antique expert
↓
Add to chat history
↓
Display to user
↓
Save to database
```

## 🌐 Multilingual Support

The prompt system automatically adapts to user's language (detected or selected):
- Russian (ru)
- Ukrainian (uk)
- Spanish (es)
- English (en)
- German (de)
- French (fr)
- Italian (it)
- And 20+ more supported

All responses are provided in the selected language.

## ⚠️ Accuracy & Disclaimers

The app includes automatic warning messages:
1. "This valuation is estimated based on visual inspection and may not reflect actual market value"
2. "Professional appraisal recommended before selling at auction"
3. "Condition and any restoration work significantly affect value"
4. "Market values vary by region and current demand"

These are displayed prominently to users as part of the analysis results.

## 🔄 Development Workflow

1. **Create Screens** based on the models and services
2. **Add State Management** using Provider
3. **Implement Navigation** with GoRouter
4. **Build UI Components** following Material Design 3
5. **Add Localization** for all text strings
6. **Test with Real Images** of antiques
7. **Optimize Performance** and user experience

## 📞 API Status

- ✅ Gemini Vision API: Functional
- ✅ Supabase Backend: Configured
- ✅ Database Structure: Ready
- ✅ Chat Endpoint: Available

## 📝 Notes

- All API calls use Supabase Edge Functions as proxy for security
- Database is configured with public access for demo purposes
- Image compression reduces file size by ~70% before sending to API
- Chat history is maintained in memory and persisted to database
- Analysis results include specific comparable sales data and market context

## 🎨 UI/UX Considerations

- Display warnings prominently with warning color
- Show confidence levels on price estimates
- Use card layout for materials and similar items
- Implement smooth loading animations
- Show image preview in results
- Allow sharing and exporting analysis results
- Provide photo quality guidelines for better analysis

---

**Last Updated**: November 2024
**Version**: 1.0.0
**Status**: Core architecture ready, screens pending
