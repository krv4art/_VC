# API Integration Guide

## Overview

ACS integrates with two main external services:
1. **Google Gemini AI** - AI-powered analysis and chat
2. **Supabase** - Edge Functions for API proxy

## Google Gemini AI

### Setup

1. **Get API Key**
   - Visit [Google AI Studio](https://makersuite.google.com/app/apikey)
   - Create a new API key
   - Copy and save securely

2. **Add to Environment**
   ```env
   GEMINI_API_KEY=AIzaSyBhFq-8l7Xu__B9YORp7FGANhYPmjSqqDQ
   ```

### Available Models (January 2025)

| Model | Best For | Speed | Cost |
|-------|----------|-------|------|
| `gemini-2.0-flash` | General use | ⚡⚡⚡ | $ |
| `gemini-2.5-flash` | Better quality | ⚡⚡ | $$ |
| `gemini-2.5-pro` | Complex tasks | ⚡ | $$$ |

**Current Configuration**: `gemini-2.0-flash`

### API Endpoints

#### 1. Text Generation (Chat)
```
POST https://generativelanguage.googleapis.com/v1beta/models/{model}:generateContent?key={API_KEY}
```

**Request Body**:
```json
{
  "contents": [
    {
      "role": "user",
      "parts": [{"text": "Hello!"}]
    },
    {
      "role": "model",
      "parts": [{"text": "Hi there!"}]
    },
    {
      "role": "user",
      "parts": [{"text": "How are you?"}]
    }
  ]
}
```

**Response**:
```json
{
  "candidates": [
    {
      "content": {
        "parts": [
          {"text": "I'm doing well, thank you!"}
        ],
        "role": "model"
      }
    }
  ]
}
```

#### 2. Vision API (Image Analysis)
```
POST https://generativelanguage.googleapis.com/v1beta/models/{model}:generateContent?key={API_KEY}
```

**Request Body**:
```json
{
  "contents": [
    {
      "parts": [
        {
          "inline_data": {
            "mime_type": "image/png",
            "data": "base64_encoded_image_data_here"
          }
        },
        {
          "text": "Analyze this cosmetic label and extract ingredients..."
        }
      ]
    }
  ]
}
```

**Response**:
```json
{
  "candidates": [
    {
      "content": {
        "parts": [
          {
            "text": "{\n  \"is_cosmetic_label\": true,\n  \"ingredients\": [...],\n  ...
}"
          }
        ]
      }
    }
  ]
}
```

### Implementation in Flutter

#### GeminiService Class

```dart
class GeminiService {
  final bool useProxy;
  final SupabaseClient? _supabaseClient;

  static const String _apiKey = 'YOUR_API_KEY';
  static const String _model = 'gemini-2.0-flash';
  static const String _baseUrl = 'https://generativelanguage.googleapis.com/v1beta';

  // Chat API
  Future<String> sendMessageWithHistory(String message, {String languageCode = 'en'}) {
    if (useProxy) {
      return _sendMessageWithProxy(message, languageCode: languageCode);
    } else {
      return _sendMessageDirectly(message, languageCode: languageCode);
    }
  }

  // Vision API
  Future<AnalysisResult> analyzeImage(
    String base64Image,
    String prompt,
    {String languageCode = 'en'}
  ) async {
    final functionUrl = 'https://yerbryysrnaraqmbhqdm.supabase.co/functions/v1/gemini-vision-proxy';

    final response = await http.post(
      Uri.parse(functionUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contents': [
          {
            'parts': [
              {
                'inline_data': {
                  'mime_type': 'image/png',
                  'data': base64Image,
                }
              },
              {'text': prompt}
            ]
          }
        ]
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final contentText = data['candidates'][0]['content']['parts'][0]['text'];
      final jsonString = contentText.replaceAll('```json', '').replaceAll('```', '').trim();
      final analysisJson = jsonDecode(jsonString);
      return AnalysisResult.fromJson(analysisJson);
    } else {
      throw Exception('Analysis failed: ${response.body}');
    }
  }
}
```

### Prompt Engineering

#### Vision Analysis Prompt

```dart
String _buildAnalysisPrompt(String userProfilePrompt) {
  return '''
    You are an expert cosmetic ingredient analyst.

    STEP 1: DETERMINE OBJECT TYPE
    First, carefully examine the image and determine if this is a cosmetic product label/packaging.

    Cosmetic products include: creams, lotions, shampoos, soaps, makeup, perfumes, deodorants, sunscreens, skincare products, hair care products, etc.

    If this is NOT a cosmetic product label:
    - Set "is_cosmetic_label" to false
    - Create a humorous, creative message (20-40 words) about how this object could be used for skincare/beauty in a funny way
    - Use emojis to make it fun! 😄
    - Leave all other fields empty/default

    If this IS a cosmetic product label:
    - Set "is_cosmetic_label" to true
    - Proceed with full analysis below

    STEP 2: FULL COSMETIC ANALYSIS (only if it's a cosmetic label):
    1. Extract ALL ingredient names from sections labeled 'Ingredients:', 'INCI:', or ingredient lists.
    2. Analyze each ingredient's safety level considering the user's profile.
    3. Provide personalized warnings based on user's allergies and conditions.
    4. Calculate overall safety score (0-10 scale).
    5. Suggest benefits and alternative products.

    REQUIRED OUTPUT FORMAT (valid JSON only):
    {
      "is_cosmetic_label": true/false,
      "humorous_message": "😂 Your pizza box could make a great exfoliating face mask! 🍕✨",
      "ingredients": ["AQUA", "GLYCERIN", "CETYL ALCOHOL"],
      "overall_safety_score": 8.5,
      "high_risk_ingredients": ["FRAGRANCE", "ALCOHOL"],
      "moderate_risk_ingredients": ["PHENOXYETHANOL"],
      "low_risk_ingredients": ["AQUA", "GLYCERIN", "CETYL ALCOHOL"],
      "personalized_warnings": [
        "Contains fragrance which may cause irritation for sensitive skin"
      ],
      "benefits_analysis": "This product is formulated to hydrate and soothe the skin.",
      "recommended_alternatives": [
        {
          "name": "Gentle Cleanser",
          "description": "Fragrance-free cleanser",
          "reason": "Better for sensitive skin"
        }
      ]
    }

    SAFETY CRITERIA:
    - HIGH RISK: Allergens from user allergy list, pregnancy/breastfeeding restrictions
    - MODERATE RISK: Potentially irritating ingredients based on skin type

    $userProfilePrompt
  ''';
}
```

### Rate Limits

| Tier | Requests/Minute | Tokens/Minute |
|------|-----------------|---------------|
| Free | 15 | 1,000,000 |
| Pay-as-you-go | 1,000 | 4,000,000 |

**Current Usage**: Free tier (via Supabase proxy)

### Error Handling

```dart
try {
  final result = await geminiService.analyzeImage(image, prompt);
} catch (e) {
  if (e.toString().contains('404')) {
    // Model not found
    print('Update model name to current version');
  } else if (e.toString().contains('429')) {
    // Rate limit
    print('Too many requests, wait and retry');
  } else if (e.toString().contains('503')) {
    // Service unavailable
    print('Gemini API temporarily unavailable');
  } else {
    print('Unknown error: $e');
  }
}
```

---

## Supabase Integration

### Setup

1. **Create Supabase Project**
   - Visit [supabase.com](https://supabase.com)
   - Create new project
   - Copy URL and anon key

2. **Add to Environment**
   ```env
   SUPABASE_URL=https://yerbryysrnaraqmbhqdm.supabase.co
   SUPABASE_ANON_KEY=your_anon_key_here
   ```

3. **Initialize in Flutter**
   ```dart
   await Supabase.initialize(
     url: dotenv.env['SUPABASE_URL']!,
     anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
   );
   ```

### Edge Functions

#### 1. Gemini Proxy

**Purpose**: Hides API key from client, adds CORS headers

**File**: `supabase/functions/gemini-proxy/index.ts`

```typescript
import { serve } from "https://deno.land/std@0.168.0/http/server.ts"

const geminiApiKey = Deno.env.get('GEMINI_API_KEY')!;
const model = "gemini-2.0-flash";

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders });
  }

  try {
    const { prompt, history } = await req.json();

    const url = `https://generativelanguage.googleapis.com/v1beta/models/${model}:generateContent?key=${geminiApiKey}`;

    const response = await fetch(url, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        contents: history || [
          { role: 'user', parts: [{ text: prompt }] }
        ]
      }),
    });

    const data = await response.json();
    const text = data.candidates[0].content.parts[0].text;

    return new Response(
      JSON.stringify({ text }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    );
  } catch (error) {
    return new Response(
      JSON.stringify({ error: error.message }),
      { status: 500, headers: corsHeaders }
    );
  }
});
```

**Deploy**:
```bash
npx supabase functions deploy gemini-proxy
```

#### 2. Gemini Vision Proxy

**File**: `supabase/functions/gemini-vision-proxy/index.ts`

```typescript
serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders });
  }

  try {
    const { contents } = await req.json();

    const url = `https://generativelanguage.googleapis.com/v1beta/models/${model}:generateContent?key=${geminiApiKey}`;

    const response = await fetch(url, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ contents }),
    });

    const data = await response.json();

    return new Response(
      JSON.stringify(data),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    );
  } catch (error) {
    return new Response(
      JSON.stringify({ error: error.message }),
      { status: 500, headers: corsHeaders }
    );
  }
});
```

**Deploy**:
```bash
npx supabase functions deploy gemini-vision-proxy
```

### Environment Variables

Set in Supabase Dashboard → Project Settings → Edge Functions:

```
GEMINI_API_KEY=your_gemini_api_key_here
```

### CORS Configuration

```typescript
const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
};
```

---

## Future Integrations

### Planned

#### 1. Supabase Database
- User authentication
- Cloud sync for scan history
- Social features

#### 2. Payment Gateway
- Stripe for subscriptions
- In-app purchases (iOS/Android)

#### 3. Analytics
- Firebase Analytics
- Mixpanel

#### 4. Crash Reporting
- Sentry
- Firebase Crashlytics

---

## Testing APIs

### Postman Collection

Import this collection to test APIs:

```json
{
  "info": {
    "name": "ACS API Tests",
    "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
  },
  "item": [
    {
      "name": "Gemini Text",
      "request": {
        "method": "POST",
        "url": "https://yerbryysrnaraqmbhqdm.supabase.co/functions/v1/gemini-proxy",
        "body": {
          "mode": "raw",
          "raw": "{\"prompt\": \"Hello, how are you?\"}"
        }
      }
    },
    {
      "name": "Gemini Vision",
      "request": {
        "method": "POST",
        "url": "https://yerbryysrnaraqmbhqdm.supabase.co/functions/v1/gemini-vision-proxy",
        "body": {
          "mode": "raw",
          "raw": "{\"contents\": [{\"parts\": [{\"inline_data\": {\"mime_type\": \"image/png\", \"data\": \"base64...\"}}, {\"text\": \"What's in this image?\"}]}]}"
        }
      }
    }
  ]
}
```

### cURL Examples

**Chat API**:
```bash
curl -X POST https://yerbryysrnaraqmbhqdm.supabase.co/functions/v1/gemini-proxy \
  -H "Content-Type: application/json" \
  -d '{"prompt": "Hello!"}'
```

**Vision API**:
```bash
curl -X POST https://yerbryysrnaraqmbhqdm.supabase.co/functions/v1/gemini-vision-proxy \
  -H "Content-Type: application/json" \
  -d '{
    "contents": [{
      "parts": [
        {
          "inline_data": {
            "mime_type": "image/png",
            "data": "iVBORw0KGgoAAAANS..."
          }
        },
        {"text": "Analyze this image"}
      ]
    }]
  }'
```

---

## Monitoring & Debugging

### Check Supabase Logs
```bash
npx supabase functions logs gemini-proxy
npx supabase functions logs gemini-vision-proxy
```

### Enable Verbose Logging

```dart
class GeminiService {
  static const bool _debug = true;

  Future<String> _sendMessage(String message) async {
    if (_debug) print('→ Sending: $message');

    final response = await http.post(...);

    if (_debug) {
      print('← Status: ${response.statusCode}');
      print('← Body: ${response.body}');
    }

    return response.body;
  }
}
```

---

**Last Updated**: January 2025
**API Version**: Gemini v1beta
**Supabase Version**: Latest
