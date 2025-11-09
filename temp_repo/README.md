# Vibe Projects

Multi-project Flutter repository containing AI-powered mobile applications.

## 📱 Projects

### 1. ACS (AI Cosmetic Scanner)
**Location:** `acs/`

AI-powered cosmetic ingredient analyzer with personalized skin care recommendations.

- **Tech Stack:** Flutter 3.32.6, Dart 3.8.1, Google Gemini 2.0 Flash
- **Features:** Smart scanning, AI analysis, safety scoring, personalized warnings
- **Languages:** English, Russian, Ukrainian, Spanish, German, French, Italian
- **Status:** Active development

[View ACS Documentation →](acs/README.md)

---

### 2. Bug Identifier
**Location:** `bug_identifier/`

AI-powered insect identification and analysis application.

- **Tech Stack:** Flutter 3.32.6, Dart 3.8.1, AI Integration
- **Features:** Bug identification, detailed analysis, personalized insights
- **Languages:** English, Russian, Ukrainian
- **Status:** Initial setup complete, ready for development

[View Bug Identifier Documentation →](bug_identifier/README.md)

---

### 3. Plant Identifier
**Location:** `plant_identifier/`

AI-powered plant identification and care guide application.

- **Tech Stack:** Flutter 3.32.6, Dart 3.8.1, AI Integration
- **Features:** Plant identification, care recommendations, detailed plant information
- **Languages:** English, Russian, Ukrainian
- **Status:** Complete and ready for deployment

[View Plant Identifier Documentation →](plant_identifier/README.md)

---

### 4. MAS (Math AI Solver)
**Location:** `MAS/`

AI-powered math problem solver with step-by-step solutions.

- **Tech Stack:** Flutter 3.8.1+, Dart, Gemini Vision API
- **Features:** Step-by-step solutions, homework checker, training mode, math chat, unit converter
- **Languages:** Ukrainian, Russian, English
- **Status:** MVP development in progress

[View MAS Documentation →](MAS/README.md)

---

## 🏗️ Repository Structure

```
Vibe/
├── acs/                    # AI Cosmetic Scanner project
│   ├── lib/                # Source code
│   ├── android/            # Android platform
│   ├── ios/                # iOS platform
│   ├── assets/             # Images, fonts, etc.
│   └── pubspec.yaml        # Dependencies
│
├── bug_identifier/         # Bug Identifier project
│   ├── lib/                # Source code
│   ├── android/            # Android platform
│   ├── ios/                # iOS platform
│   ├── assets/             # Images, fonts, etc.
│   └── pubspec.yaml        # Dependencies
│
├── plant_identifier/       # Plant Identifier project
│   ├── lib/                # Source code
│   ├── assets/             # Images, fonts, etc.
│   └── pubspec.yaml        # Dependencies
│
├── MAS/                    # Math AI Solver project
│   ├── lib/                # Source code
│   └── pubspec.yaml        # Dependencies
│
├── .git/                   # Git repository
└── README.md               # This file
```

## 🚀 Getting Started

Each project is fully independent with its own dependencies and configuration.

### Running ACS:
```bash
cd acs
flutter pub get
flutter run
```

### Running Bug Identifier:
```bash
cd bug_identifier
flutter pub get
flutter run
```

### Running Plant Identifier:
```bash
cd plant_identifier
flutter pub get
flutter run
```

### Running MAS:
```bash
cd MAS
flutter pub get
flutter run
```

## 📝 Development Philosophy

Each project in this repository:
- ✅ Is completely independent (no shared dependencies)
- ✅ Can be developed and deployed separately
- ✅ Evolves and improves upon previous projects
- ✅ Uses refactored and optimized code from earlier projects

## 📄 License

Each project has its own license. See individual project directories for details.
