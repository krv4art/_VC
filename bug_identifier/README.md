# Bug Identifier 🐛

![Flutter](https://img.shields.io/badge/Flutter-3.32.6-blue)
![Dart](https://img.shields.io/badge/Dart-3.8.1-blue)
![Status](https://img.shields.io/badge/status-refactoring%20complete-green)

**AI-powered insect identification and analysis application.**

## 🐛 Overview

Bug Identifier is an intelligent mobile application that helps users identify insects using AI-powered image recognition. Built on the proven architecture of ACS (AI Cosmetic Scanner), this app provides detailed information about insects, their characteristics, and personalized insights.

**Key Difference from ACS**: While ACS analyzes cosmetic ingredients for safety, Bug Identifier identifies insects and provides taxonomic, ecological, and behavioral information.

---

## 🎉 Refactoring Status: Complete!

✅ **All core refactoring completed:**
- Package renamed: `acs` → `bug_identifier`
- Android package updated: `com.vibe.bug_identifier`
- Localization simplified: 3 languages (en, ru, uk)
- Theme adapted: Nature-inspired colors (Olive Green, Dark Brown)
- Custom theme editor removed
- **New data models created for insect identification**
- **AI prompts adapted for entomology**

---

## 🌟 Features

### Current Features (from ACS base)
- 📸 **Smart Scanning** - Camera & gallery support
- 🤖 **AI Analysis** - Powered by Google Gemini 2.0 Flash
- 💾 **Local Database** - SQLite for offline access
- 🌐 **Multi-language** - English, Russian, Ukrainian
- 🎨 **Nature Theme** - Eco-friendly color palette
- 📱 **Responsive UI** - Mobile, tablet, web support
- 👥 **User Profiles** - Settings and preferences

### Planned Features (Insect-Specific)
- 🔍 **Species Identification** - Identify insects to species level
- 📊 **Taxonomic Classification** - Full taxonomy (Kingdom → Species)
- ⚠️ **Danger Assessment** - Safety ratings (0-10 scale)
- 🌿 **Ecological Information** - Role in ecosystem
- 🔄 **Similar Species** - Comparison with look-alikes
- 📍 **Location-Based** - Region-specific warnings
- 🎓 **Educational Content** - Learn about insects

---

## 🏗️ Architecture

### Data Models

The project uses two separate model systems:

#### 🐛 **Insect Models** (NEW - `lib/models/bug_analysis.dart`)

**Primary Model: `BugAnalysis`**
```dart
BugAnalysis(
  isInsect: true,
  characteristics: ["Orange wings", "Six legs", "Antennae"],
  dangerLevel: 2.0,  // 0-10 scale
  dangerousTraits: [...],
  notableTraits: [...],
  commonTraits: [...],
  ecologicalRole: "Beneficial predator...",
  similarSpecies: [...],
  scientificName: "Coccinella septempunctata",
  commonName: "Seven-spotted Ladybug",
  habitat: "Gardens, meadows",
  taxonomyInfo: TaxonomyInfo(...),
  species: InsectSpecies(...),
)
```

**Supporting Models:**
- `CharacteristicInfo` - Insect traits (anatomy, behavior, etc.)
- `InsectSpecies` - Complete species information
- `TaxonomyInfo` - Taxonomic classification
- `SimilarSpecies` - Look-alike species comparison

#### 💄 **Legacy Cosmetics Models** (`lib/models/analysis_result.dart`)

Kept for backward compatibility. Will be gradually replaced.

---

## 🤖 AI Prompts

### Insect Identification Prompt

Location: `lib/config/prompts/insect_identification_prompt.dart`

**Features:**
- Identifies insects to species level
- Provides complete taxonomy (Class → Species)
- Analyzes danger level (0-10 scale)
- Describes ecological role and behavior
- Lists similar species with differences
- Generates educational summaries
- Multilingual support (en, ru, uk)

**Danger Level Scale:**
- 0-2: Completely harmless (butterflies, ladybugs)
- 3-4: Minor nuisance (houseflies, most ants)
- 5-6: Can cause discomfort (biting flies, stinging ants)
- 7-8: Potentially harmful (wasps, hornets)
- 9-10: Dangerous/venomous (black widow, bullet ant)

---

## 🎨 Design System

### Color Palette (Nature Theme)

Inspired by nature: leaves, bark, earth

```dart
Primary Colors:
- primary: #689F38        // Olive Green (листва)
- primaryLight: #8BC34A   // Light Green
- primaryPale: #DCEDC8    // Pale Green
- primaryDark: #5D4037    // Dark Brown (кора дерева)

Backgrounds:
- background: #F1F8E9     // Light Green Tint
- surface: #FFFFFF        // White

Semantic Colors:
- success: #66BB6A        // Green
- warning: #FF8A65        // Warm Orange
- error: #E53935          // Red
- info: #42A5F5           // Blue
```

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.32.6 or higher
- Dart SDK 3.8.1 or higher
- Android Studio / VS Code with Flutter extensions

### Installation

```bash
# Navigate to the project
cd bug_identifier

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Configuration

Create a `.env` file in the project root:
```env
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_key
GEMINI_API_KEY=your_gemini_api_key
```

---

## 📁 Project Structure

```
bug_identifier/
├── lib/
│   ├── main.dart                    # Entry point
│   │
│   ├── models/                      # Data Models
│   │   ├── bug_analysis.dart        # 🆕 Insect models (BugAnalysis, InsectSpecies, etc.)
│   │   └── analysis_result.dart     # 📦 Legacy cosmetics models
│   │
│   ├── config/
│   │   └── prompts/
│   │       ├── insect_identification_prompt.dart  # 🆕 AI prompt for insects
│   │       └── default_analysis_prompt.dart       # 📦 Legacy cosmetics prompt
│   │
│   ├── services/                    # Business Logic
│   │   ├── gemini_service.dart      # AI integration
│   │   ├── database_service.dart    # SQLite database
│   │   └── scanning/
│   │       └── image_analysis_service.dart  # Image analysis
│   │
│   ├── providers/                   # State Management
│   │   ├── user_state.dart
│   │   ├── theme_provider_v2.dart
│   │   └── ...
│   │
│   ├── screens/                     # UI Screens
│   │   ├── scanning_screen.dart
│   │   ├── analysis_results_screen.dart
│   │   └── ...
│   │
│   ├── theme/                       # Theming
│   │   ├── app_colors.dart          # 🆕 Updated nature colors
│   │   └── app_theme.dart
│   │
│   ├── l10n/                        # Localizations
│   │   ├── app_en.arb               # English
│   │   ├── app_ru.arb               # Russian
│   │   └── app_uk.arb               # Ukrainian
│   │
│   └── navigation/
│       └── app_router.dart          # Go Router configuration
│
├── android/                         # Android platform
│   └── app/
│       ├── build.gradle.kts         # 🆕 com.vibe.bug_identifier
│       └── src/main/kotlin/com/vibe/bug_identifier/
│           └── MainActivity.kt
│
├── ios/                             # iOS platform
├── assets/                          # Images, fonts, etc.
├── pubspec.yaml                     # 🆕 bug_identifier v0.1.0
└── README.md                        # This file
```

---

## 🔄 Migration from Cosmetics to Insects

### Model Field Mapping

| Cosmetics (Old) | Insects (New) | Description |
|----------------|---------------|-------------|
| `isCosmeticLabel` | `isInsect` | Object type check |
| `ingredients` | `characteristics` | Main features list |
| `overallSafetyScore` | `dangerLevel` | 0-10 rating |
| `highRiskIngredients` | `dangerousTraits` | Dangerous features |
| `moderateRiskIngredients` | `notableTraits` | Notable features |
| `lowRiskIngredients` | `commonTraits` | Common features |
| `benefitsAnalysis` | `ecologicalRole` | Purpose/role |
| `recommendedAlternatives` | `similarSpecies` | Comparisons |
| `productType` | `habitat` | Environment |
| `brandName` | `scientificName` | Latin name |
| `premiumInsights` | `taxonomyInfo` | Classification |

### Usage Example

```dart
// Old cosmetics code
import '../models/analysis_result.dart';
final result = AnalysisResult.fromJson(json);
print(result.overallSafetyScore);

// New insect code
import '../models/bug_analysis.dart';
final analysis = BugAnalysis.fromJson(json);
print(analysis.dangerLevel);
print(analysis.scientificName);
print(analysis.taxonomyInfo?.order); // e.g., "Coleoptera"
```

---

## 🎯 Refactoring Checklist

### ✅ Completed
- [x] Package rename (`acs` → `bug_identifier`)
- [x] Android package update (`com.vibe.bug_identifier`)
- [x] Localization simplification (3 languages)
- [x] Theme adaptation (nature colors)
- [x] Custom theme editor removal
- [x] BugAnalysis models created
- [x] InsectSpecies model created
- [x] TaxonomyInfo model created
- [x] Insect identification AI prompt
- [x] Documentation updated

### 🔄 In Progress / TODO
- [ ] Update `image_analysis_service.dart` to use `BugAnalysis`
- [ ] Update UI screens to display insect data
- [ ] Update localization strings (cosmetics → insects)
- [ ] Create insect-specific widgets
- [ ] Update database schema for insects
- [ ] Create app icon with insect theme
- [ ] Test with real insect photos
- [ ] Update onboarding for insect context

---

## 📚 Development Guide

### Using the New Models

1. **Import the model:**
```dart
import '../models/bug_analysis.dart';
```

2. **Parse AI response:**
```dart
final analysis = BugAnalysis.fromJson(jsonResponse);
```

3. **Access insect data:**
```dart
// Basic info
print(analysis.commonName);           // "Seven-spotted Ladybug"
print(analysis.scientificName);       // "Coccinella septempunctata"
print(analysis.dangerLevel);          // 2.0

// Taxonomy
print(analysis.taxonomyInfo?.order);  // "Coleoptera"
print(analysis.taxonomyInfo?.family); // "Coccinellidae"

// Characteristics
for (var trait in analysis.notableTraits) {
  print('${trait.name}: ${trait.description}');
}

// Ecology
print(analysis.ecologicalRole);       // "Beneficial predator..."
print(analysis.habitat);               // "Gardens, meadows"

// Similar species
for (var similar in analysis.similarSpecies) {
  print('${similar.name} (${similar.scientificName})');
  print('Difference: ${similar.differences}');
}
```

### Using the Insect Prompt

```dart
import '../config/prompts/insect_identification_prompt.dart';

final prompt = InsectIdentificationPrompt.withVariables(
  languageCode: 'en',
  userProfile: '''
    Location: Europe
    Interests: Gardening, beneficial insects
  ''',
);

// Send to AI with insect photo
final response = await geminiService.analyzeImage(
  imagePath: photoPath,
  prompt: prompt,
);

final analysis = BugAnalysis.fromJson(response);
```

---

## 🐞 Example: Identifying a Ladybug

**Input**: Photo of a seven-spotted ladybug

**AI Response** (BugAnalysis):
```json
{
  "is_insect": true,
  "common_name": "Seven-spotted Ladybug",
  "scientific_name": "Coccinella septempunctata",
  "danger_level": 2.0,
  "habitat": "Gardens, agricultural fields, meadows",
  "ai_summary": "This is a beautiful ladybug, a beneficial insect...",
  "notable_traits": [
    {
      "name": "Seven black spots",
      "description": "Distinctive pattern on red wing covers",
      "category": "anatomy"
    },
    {
      "name": "Aphid predator",
      "description": "Consumes up to 5,000 aphids in lifetime",
      "category": "behavior"
    }
  ],
  "ecological_role": "Beneficial predatory insect providing natural pest control...",
  "taxonomy_info": {
    "order": "Coleoptera",
    "family": "Coccinellidae",
    "genus": "Coccinella",
    "species": "septempunctata"
  },
  "similar_species": [
    {
      "name": "Asian Lady Beetle",
      "scientific_name": "Harmonia axyridis",
      "differences": "Variable spot patterns, white M marking"
    }
  ]
}
```

---

## 🔬 Tech Stack

- **Framework:** Flutter 3.32.6
- **Language:** Dart 3.8.1
- **State Management:** Provider
- **Navigation:** Go Router
- **Database:** SQLite
- **Backend:** Supabase
- **AI:** Google Gemini 2.0 Flash
- **Payments:** RevenueCat (optional)

---

## 📖 Resources

### Documentation
- [ACS Original Project](../acs/README.md) - Base architecture
- [Flutter Documentation](https://docs.flutter.dev/)
- [Go Router](https://pub.dev/packages/go_router)
- [Provider](https://pub.dev/packages/provider)

### Entomology Resources
- [BugGuide.net](https://bugguide.net/) - North American insects
- [iNaturalist](https://www.inaturalist.org/) - Worldwide species
- [Wikipedia: Insect](https://en.wikipedia.org/wiki/Insect) - General info

---

## 📄 License

To be determined

---

## 🤝 Contributing

This is a private project. Development guidelines will be added later.

---

## 📝 Changelog

### v0.1.0 (Current) - Refactoring Complete
- ✅ Project structure created
- ✅ Base code copied from ACS
- ✅ Package renamed to `bug_identifier`
- ✅ Android package updated
- ✅ Localization simplified (en, ru, uk)
- ✅ Theme adapted for nature/insects
- ✅ Custom theme editor removed
- ✅ BugAnalysis models created
- ✅ Insect identification AI prompt created
- ✅ Documentation updated

### Next Release (v0.2.0) - Planned
- [ ] UI screens updated for insects
- [ ] Database schema updated
- [ ] Localization strings updated
- [ ] App icon designed
- [ ] Testing with real photos

---

**Note:** Built on the solid foundation of [ACS (AI Cosmetic Scanner)](../acs/README.md). Architecture, design patterns, and core functionality have been adapted and improved for insect identification.

🐛 **Happy Bug Hunting!** 🔍
