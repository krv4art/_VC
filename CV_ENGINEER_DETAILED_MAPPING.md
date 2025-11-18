# CV ENGINEER - DETAILED CODEBASE MAPPING

## Core Project Files

### Main Entry Point
- `/home/user/_VC/cv_engineer/lib/main.dart` - App initialization, providers setup, routing configuration

### Data Models (7 files)
- `/home/user/_VC/cv_engineer/lib/models/resume.dart` - Main Resume model with all sections
- `/home/user/_VC/cv_engineer/lib/models/personal_info.dart` - User contact/personal details
- `/home/user/_VC/cv_engineer/lib/models/experience.dart` - Work experience model **[BUG: uses isCurrentJob]**
- `/home/user/_VC/cv_engineer/lib/models/education.dart` - Education model (uses isCurrent)
- `/home/user/_VC/cv_engineer/lib/models/skill.dart` - Skills with proficiency levels (4 tiers)
- `/home/user/_VC/cv_engineer/lib/models/language.dart` - Languages with CEFR proficiency (A1-C2)
- `/home/user/_VC/cv_engineer/lib/models/custom_section.dart` - Flexible custom sections (Certifications, Projects, etc.)

### State Management (3 files)
- `/home/user/_VC/cv_engineer/lib/providers/resume_provider.dart` - Main resume CRUD operations
- `/home/user/_VC/cv_engineer/lib/providers/theme_provider.dart` - Dark mode & theme switching
- `/home/user/_VC/cv_engineer/lib/providers/locale_provider.dart` - Language/localization switching

### Services (6 files)
- `/home/user/_VC/cv_engineer/lib/services/storage_service.dart` - Local data persistence (SharedPreferences)
- `/home/user/_VC/cv_engineer/lib/services/pdf_service.dart` - PDF generation & export
- `/home/user/_VC/cv_engineer/lib/services/ai_assistant_service.dart` - AI text improvement (Supabase + fallback)
- `/home/user/_VC/cv_engineer/lib/services/image_service.dart` - Photo upload & compression
- `/home/user/_VC/cv_engineer/lib/services/rating_service.dart` - App rating dialog management
- `/home/user/_VC/cv_engineer/lib/services/onboarding_service.dart` - First-time user onboarding flow

### Screens (13 files, ~3850 LOC total)
- `/home/user/_VC/cv_engineer/lib/screens/splash_screen.dart` - App startup screen
- `/home/user/_VC/cv_engineer/lib/screens/onboarding_screen.dart` - 4-page animated introduction
- `/home/user/_VC/cv_engineer/lib/screens/home_screen.dart` - Main dashboard with quick actions
- `/home/user/_VC/cv_engineer/lib/screens/template_selection_screen.dart` - Choose resume template
- `/home/user/_VC/cv_engineer/lib/screens/resume_editor_screen.dart` - Main editor with section tabs
- `/home/user/_VC/cv_engineer/lib/screens/preview_screen.dart` - Resume preview with template switching
- `/home/user/_VC/cv_engineer/lib/screens/experience_editor_screen.dart` - Work experience CRUD **[TODO: reordering]**
- `/home/user/_VC/cv_engineer/lib/screens/education_editor_screen.dart` - Education CRUD
- `/home/user/_VC/cv_engineer/lib/screens/skills_editor_screen.dart` - Skills with categories & proficiency
- `/home/user/_VC/cv_engineer/lib/screens/languages_editor_screen.dart` - Language proficiency editor
- `/home/user/_VC/cv_engineer/lib/screens/custom_sections_editor_screen.dart` - Flexible section editor **[TODO: reordering]**
- `/home/user/_VC/cv_engineer/lib/screens/interview_questions_screen.dart` - Interview prep (13 Q&A)
- `/home/user/_VC/cv_engineer/lib/screens/settings_screen.dart` - App settings (theme, language)

### Templates (7 files, ~1778 LOC total)
- `/home/user/_VC/cv_engineer/lib/widgets/templates/template_factory.dart` - Template factory pattern
- `/home/user/_VC/cv_engineer/lib/widgets/templates/professional_template.dart` (422 LOC) - Blue corporate style
- `/home/user/_VC/cv_engineer/lib/widgets/templates/creative_template.dart` (568 LOC) - Purple modern gradient
- `/home/user/_VC/cv_engineer/lib/widgets/templates/modern_template.dart` (659 LOC) - Teal two-column layout
- `/home/user/_VC/cv_engineer/lib/widgets/templates/resume_template.dart` - Abstract base template

### Other Widgets
- `/home/user/_VC/cv_engineer/lib/widgets/animated_card.dart` - Animated UI components
- `/home/user/_VC/cv_engineer/lib/widgets/rating_request_dialog.dart` - Rating dialog **[TODO: backend URLs]**

### Theme & Styling
- `/home/user/_VC/cv_engineer/lib/theme/app_theme.dart` - Design system (spacing, shadows, text styles)
- `/home/user/_VC/cv_engineer/lib/theme/app_colors.dart` - Color palette definitions
- `/home/user/_VC/cv_engineer/lib/constants/app_dimensions.dart` - Dimension constants

### Navigation & Utilities
- `/home/user/_VC/cv_engineer/lib/navigation/app_router.dart` - go_router configuration (8 routes)
- `/home/user/_VC/cv_engineer/lib/animations/page_transitions.dart` - Page transition animations
- `/home/user/_VC/cv_engineer/lib/utils/demo_data.dart` - Demo resume data (3 examples) **[BUG: isCurrent vs isCurrentJob]**
- `/home/user/_VC/cv_engineer/lib/utils/supabase_constants.dart` - Supabase config (unused)
- `/home/user/_VC/cv_engineer/lib/l10n/app_localizations.dart` - Localization strings (8 languages)

### Configuration
- `/home/user/_VC/cv_engineer/pubspec.yaml` - Dependencies & Flutter config
- `/home/user/_VC/cv_engineer/.env.example` - Environment template
- `/home/user/_VC/cv_engineer/analysis_options.yaml` - Lint rules

### Documentation
- `/home/user/_VC/cv_engineer/README.md` - Project overview
- `/home/user/_VC/cv_engineer/docs/FEATURES.md` - Feature documentation (363 lines)
- `/home/user/_VC/cv_engineer/assets/fonts/README.md` - Font info
- `/home/user/_VC/cv_engineer/assets/images/README.md` - Image assets

---

## KEY CODE PATTERNS & ISSUES

### 1. Data Consistency Bug - CRITICAL
**Issue**: Field name mismatch in Experience model
```dart
// File: /lib/models/experience.dart
final bool isCurrentJob;  // ← Uses "isCurrentJob"

// File: /lib/utils/demo_data.dart
Experience(
  jobTitle: 'Senior Software Engineer',
  company: 'TechCorp Solutions',
  isCurrent: true,  // ← Uses "isCurrent" (WRONG!)
  ...
)
```
**Impact**: Demo resume loading will fail with field mapping error

### 2. Unused Supabase Integration
**File**: `/lib/main.dart` (lines 28-34)
```dart
// Supabase is initialized but:
// - No cloud storage implemented
// - No authentication
// - No real-time sync
// - AI assistant has fallback mode
```

### 3. Photo Upload Implemented, But Not Displayed
**Exists**:
- `/lib/models/personal_info.dart` - has photoPath field
- `/lib/services/image_service.dart` - Photo compression & storage
- `/lib/screens/resume_editor_screen.dart` - Photo picker UI

**Missing**:
- No photo display in any template (Professional, Creative, Modern)
- No photo rendering in PDF export

### 4. Incomplete Features (TODO Comments)
**Location**: `/lib/screens/experience_editor_screen.dart` & `/lib/screens/custom_sections_editor_screen.dart`
```dart
// TODO: Implement reordering
// For both experience and custom sections
// Items can be added/deleted but not reordered
```

### 5. Multiple Resume Management Gap
**Backend Support**: ✓ Complete
- Supports multiple resumes in storage
- Resume list accessible via ResumeProvider
- CRUD operations work

**Frontend Support**: ✗ Missing
- UI only shows "Current Resume"
- No resume list/gallery view
- No quick resume switcher
- Must load demo to see multiple resumes

---

## TEMPLATE SYSTEM DETAILS

### Template Architecture
All templates use base class and factory pattern:
- Base: `ResumeTemplate` interface
- Factory: `TemplateFactory.createTemplate(templateId, resume)`
- ID-based instantiation: 'professional', 'creative', 'modern'

### Template Features Matrix
| Feature | Professional | Creative | Modern |
|---------|-------------|----------|--------|
| **Color Scheme** | Blue (#1976D2) | Purple (#9C27B0) | Teal (#009688) |
| **Layout** | Single column | Single column | Two-column |
| **Header Style** | Simple text | Gradient + icons | Minimalist |
| **Experience Display** | Bullets | Cards | Timeline |
| **Skills Layout** | Categories | Stars | List |
| **PDF Export** | ✓ | ✓ | ✓ |
| **Photo Display** | ✗ | ✗ | ✗ |
| **Customizable** | Limited | Limited | Limited |

### What Templates Support
✓ All resume sections (Personal, Experience, Education, Skills, Languages, Custom)
✓ Font size adjustment (8-16pt)
✓ Margin customization (10-40pt)
✓ Font family: Roboto (default) + Merriweather
✓ Real-time preview switching
✓ PDF generation

### What Templates DON'T Support
✗ Profile photo display
✗ Color customization
✗ Layout modification
✗ Custom font families beyond 2
✗ Section reordering in template

---

## SERVICE LAYER CAPABILITIES

### StorageService (`/lib/services/storage_service.dart`)
```
✓ saveResume(Resume) - Create/update
✓ loadResumes() - List all
✓ loadResume(id) - Get single
✓ deleteResume(id) - Delete
✓ clearAll() - Wipe data
```
Backend: SharedPreferences (local only, no cloud)

### PDFService (`/lib/services/pdf_service.dart`)
```
✓ generatePdf(Resume) → pw.Document
✓ savePdf(Resume, filename?) → String (file path)
✓ sharePdf(Resume) - System share dialog
✓ printPdf(Resume) - System print dialog
```
Features:
- Section headers with underlines
- Grouped skills by category
- Language proficiency badges
- Custom section support
- Font/margin respecting

### AIAssistantService (`/lib/services/ai_assistant_service.dart`)
```
✓ improveText(text, context?) → String
✓ generateSummary(experiences, skills, targetRole?) → String
✓ suggestSkills(jobTitle) → List<String>
✓ fixGrammar(text) → String
✓ makeProfessional(text) → String
```
Backend: Supabase Edge Functions (with smart fallback)
Fallback Level: Basic text improvements without AI

### ImageService (`/lib/services/image_service.dart`)
```
Implied capabilities:
✓ Image compression
✓ Photo selection (Camera/Gallery)
✓ File storage with path
```

### RatingService (`/lib/services/rating_service.dart`)
```
✓ shouldShowRatingDialog() → bool
✓ incrementRatingDialogShows()
✓ Smart timing logic
✗ No backend tracking
✗ URLs are placeholders
```

---

## LOCALIZATION SUPPORT

### Supported Languages (8)
1. English (en)
2. Spanish (es_ES)
3. German (de)
4. French (fr)
5. Italian (it)
6. Polish (pl)
7. Portuguese (pt_PT)
8. Turkish (tr)

### Localization Setup
- Generator: Flutter intl
- Files: `/lib/l10n/app_localizations.dart`
- Implementation: LocaleProvider for dynamic switching
- Coverage: All UI strings (resume content not affected)

---

## DEPENDENCIES & VERSIONS

### Critical Dependencies
- flutter_localizations (SDK)
- provider: ^6.1.2 (State management)
- go_router: ^14.6.2 (Navigation)
- pdf: ^3.11.1 & printing: ^5.13.4 (PDF)
- image_picker: ^1.1.2 & flutter_image_compress: ^2.3.0 (Images)
- supabase_flutter: ^2.8.0 (Backend, mostly unused)
- shared_preferences: ^2.3.3 (Storage)

### Missing Critical Libraries
- ✗ Spell checker (would require external service)
- ✗ Grammar checker in editor
- ✗ PDF parser/import
- ✗ LinkedIn API client
- ✗ Document export libraries (DOCX, ODT)

---

## FEATURE COMPLETENESS ANALYSIS

### MVP Features (100% Complete)
- [x] Create resume
- [x] Edit all sections
- [x] Save/load resumes
- [x] 3 templates
- [x] PDF export
- [x] Dark mode
- [x] Multi-language
- [x] Interview prep

### Phase 2 Features (~60% Complete)
- [x] AI text improvements (basic)
- [x] Photo upload (partial - not displayed)
- [x] Custom sections
- [x] Skill categories
- [x] Language proficiency (CEFR)
- [x] Demo data
- [ ] Reordering items (TODO)
- [ ] Cloud sync (setup only)

### Advanced Features (0% Complete)
- [ ] Cover letters
- [ ] ATS optimization
- [ ] Import/export (DOCX, etc.)
- [ ] LinkedIn import
- [ ] Collaboration
- [ ] Analytics
- [ ] Job posting matching

---

## PERFORMANCE CHARACTERISTICS

### Strengths
- Lightweight Flutter app (minimal dependencies)
- Efficient local storage (SharedPreferences)
- Template rendering is fast (no complex computations)

### Weaknesses
- No pagination for large resume lists
- No image lazy loading
- No caching of AI suggestions
- PDF generation blocks UI during large exports
- No background processing

---

## Testing Status

### Current State
- No unit tests
- No widget tests
- No integration tests
- No test coverage configuration
- Manual testing only

### Test Files Present
- test/ directory exists but empty
- test_driver/ directory exists but empty
- Various test_*.dart files in root (legacy, not in proper test/ structure)

---

## SECURITY & DATA PRIVACY

### Concerns
- All data stored locally in SharedPreferences (not encrypted)
- Photo paths stored in plain text
- No password protection for resumes
- No access control between resumes
- No audit logging

### What's Secure
- No remote server access (local-only by default)
- No user tracking (unless Supabase enabled)
- Open source code (no hidden functionality)

---

## DEPLOYMENT STATUS

### Ready for Production
- ✓ Clean code structure
- ✓ Error handling present
- ✓ Localization complete
- ✓ UI/UX polished

### Not Ready for Production
- ✗ No automated tests
- ✗ No analytics setup
- ✗ No crash reporting
- ✗ No performance monitoring
- ✗ Cloud features unused
- ✗ Feedback system incomplete

---

## FILE REFERENCE GUIDE

To find specific features:

| Feature | Primary File | Related Files |
|---------|-------------|---------------|
| Resume editing | resume_editor_screen.dart | resume_provider.dart, all models |
| PDF export | pdf_service.dart | preview_screen.dart, all templates |
| AI suggestions | ai_assistant_service.dart | experience_editor_screen.dart |
| Photo upload | image_service.dart | personal_info.dart, resume_editor_screen.dart |
| Localization | locale_provider.dart | app_localizations.dart |
| Themes | theme_provider.dart | app_theme.dart, app_colors.dart |
| Navigation | app_router.dart | main.dart, all screens |
| Interview prep | interview_questions_screen.dart | home_screen.dart |
| Demo data | demo_data.dart | home_screen.dart, resume_provider.dart |
| Storage | storage_service.dart | resume_provider.dart |

