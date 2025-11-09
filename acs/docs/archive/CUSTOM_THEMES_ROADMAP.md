# Custom Themes Implementation Roadmap

**Date:** 27 October 2025
**Status:** Planning
**Total Estimated Time:** 15-20 hours

---

## 🎯 Overall Goal

Allow users to create custom themes with:
1. Manual color editing
2. AI generation from user prompts (e.g., "candy colors", "ocean vibes")
3. Preset theme as starting point

---

## 📦 Iteration Breakdown

### ✅ Iteration 0: Color Refactoring (COMPLETED)
**Status:** ✅ DONE
**Time:** ~5 hours
**Branch:** refactor/semantic-colors

**What was done:**
- Renamed all colors to semantic names (primary, secondary, neutral)
- Updated all 12 theme classes
- Replaced usage in 33 files
- Build successful

---

### 🔄 Iteration 1: Custom Color Model & Storage
**Status:** 📋 PLANNED
**Estimated Time:** 2-3 hours
**Branch:** feature/custom-theme-model

**Goals:**
- Create `CustomThemeData` model with JSON serialization
- Create `CustomColors` class that extends AppColors
- Create `ThemeStorageService` for saving/loading
- Store up to 10 custom themes in SharedPreferences

**Deliverables:**
1. `lib/models/custom_theme_data.dart`
2. `lib/theme/custom_colors.dart`
3. `lib/services/theme_storage_service.dart`
4. Unit tests for serialization

**Testing Checklist:**
- [ ] CustomThemeData serializes to JSON correctly
- [ ] CustomThemeData deserializes from JSON correctly
- [ ] Can save custom theme to SharedPreferences
- [ ] Can load custom themes from SharedPreferences
- [ ] Can delete custom theme
- [ ] Handles max limit (10 themes)

**Acceptance Criteria:**
- All tests pass
- Can create CustomColors instance programmatically
- Can save and load without errors

---

### 🔄 Iteration 2: Theme Provider Integration
**Status:** 📋 PLANNED
**Estimated Time:** 2 hours
**Branch:** feature/custom-theme-provider

**Goals:**
- Extend `ThemeProviderV2` to support custom themes
- Add enum value `AppThemeType.custom`
- Implement CRUD operations for custom themes
- Load custom themes on app start

**Deliverables:**
1. Updated `lib/providers/theme_provider_v2.dart`
2. Methods: `addCustomTheme()`, `deleteCustomTheme()`, `updateCustomTheme()`
3. Integration tests

**Testing Checklist:**
- [ ] Can add custom theme to provider
- [ ] Can switch to custom theme
- [ ] Theme persists after app restart
- [ ] Can delete custom theme
- [ ] Can update custom theme
- [ ] App doesn't crash with custom theme

**Acceptance Criteria:**
- Custom theme displays correctly in app
- All preset themes still work
- Theme switching works smoothly

---

### 🔄 Iteration 3: Color Picker Components
**Status:** 📋 PLANNED
**Estimated Time:** 3-4 hours
**Branch:** feature/color-picker-ui

**Goals:**
- Add `flutter_colorpicker` package
- Create `ColorPickerTile` widget
- Create `CustomColorPickerDialog` with hex input
- Create color preview widget

**Deliverables:**
1. Updated `pubspec.yaml`
2. `lib/widgets/theme_editor/color_picker_tile.dart`
3. `lib/widgets/theme_editor/custom_color_picker_dialog.dart`
4. `lib/widgets/theme_editor/color_preview.dart`

**Testing Checklist:**
- [ ] Color picker opens correctly
- [ ] Can select color visually
- [ ] Can enter hex color manually
- [ ] Invalid hex shows error
- [ ] Selected color updates preview
- [ ] Dialog cancels properly
- [ ] Dialog saves color on confirm

**Acceptance Criteria:**
- Color picker is user-friendly
- Hex input validates correctly
- Works on all screen sizes

---

### 🔄 Iteration 4: Basic Theme Editor Screen
**Status:** 📋 PLANNED
**Estimated Time:** 4-5 hours
**Branch:** feature/theme-editor-basic

**Goals:**
- Create basic theme editor screen
- Allow editing all color properties
- Group colors by category (primary, secondary, etc.)
- Live preview of theme
- Save custom theme

**Deliverables:**
1. `lib/screens/custom_theme_editor_screen.dart`
2. `lib/widgets/theme_editor/color_group_section.dart`
3. `lib/widgets/theme_editor/theme_preview_card.dart`
4. Navigation integration

**Testing Checklist:**
- [ ] Screen opens without errors
- [ ] All color fields are editable
- [ ] Preview updates in real-time
- [ ] Can save theme with custom name
- [ ] Theme name validation works
- [ ] Can cancel editing (returns to original)
- [ ] Works in light and dark mode

**Acceptance Criteria:**
- Can create a fully custom theme manually
- Preview accurately shows how theme looks
- Saved theme appears in theme list

---

### 🔄 Iteration 5: AI Theme Generator Service
**Status:** 📋 PLANNED
**Estimated Time:** 3-4 hours
**Branch:** feature/ai-theme-generator

**Goals:**
- Create `ThemeGeneratorService`
- Design AI prompt for theme generation
- Integrate with existing GeminiService
- Parse JSON response from AI
- Validate generated colors (contrast check)

**Deliverables:**
1. `lib/services/theme_generator_service.dart`
2. `lib/utils/color_validator.dart` (WCAG contrast checker)
3. Error handling for AI failures

**Testing Checklist:**
- [ ] AI generates valid JSON response
- [ ] JSON parses correctly to CustomColors
- [ ] Handles AI errors gracefully
- [ ] Network timeout handled
- [ ] Invalid colors rejected
- [ ] Contrast validation works
- [ ] Different prompts produce different themes

**Test Prompts:**
- "candy colors, sweet and playful"
- "ocean vibes, calm blue tones"
- "конфетные цвета"
- "темная космическая тема"

**Acceptance Criteria:**
- Successfully generates theme from text prompt
- Generated themes are harmonious
- Error messages are user-friendly

---

### 🔄 Iteration 6: AI Generator UI Integration
**Status:** 📋 PLANNED
**Estimated Time:** 2-3 hours
**Branch:** feature/ai-generator-ui

**Goals:**
- Add AI generator dialog to theme editor
- Text input for user prompt
- "Generate" button with loading state
- Show generated theme in editor
- Allow editing AI-generated theme

**Deliverables:**
1. `lib/widgets/theme_editor/ai_theme_generator_dialog.dart`
2. Integration with theme editor screen
3. Loading animations

**Testing Checklist:**
- [ ] Dialog opens correctly
- [ ] Prompt input works
- [ ] Generate button shows loading state
- [ ] Success shows generated theme
- [ ] Can edit generated theme before saving
- [ ] Can regenerate with different prompt
- [ ] Cancel works at any step

**Acceptance Criteria:**
- Smooth UX flow
- Clear feedback during generation
- Generated theme is editable

---

### 🔄 Iteration 7: Theme Selection Screen Update
**Status:** 📋 PLANNED
**Estimated Time:** 2-3 hours
**Branch:** feature/custom-themes-list

**Goals:**
- Add "Custom Themes" section to theme selection screen
- Show all user's custom themes
- "+ Create Custom Theme" button
- Edit/delete actions for custom themes
- Preset themes remain unchanged

**Deliverables:**
1. Updated `lib/screens/theme_selection_screen.dart`
2. Custom theme card widget
3. Swipe-to-delete gesture
4. Navigation to editor

**Testing Checklist:**
- [ ] Custom themes section appears
- [ ] All custom themes are listed
- [ ] Can tap to apply custom theme
- [ ] Can swipe to delete (with confirmation)
- [ ] Can long-press to edit
- [ ] Create button works
- [ ] Empty state shows helpful message
- [ ] Animations are smooth

**Acceptance Criteria:**
- Clear separation between preset and custom
- Easy to manage custom themes
- No impact on preset themes

---

### 🔄 Iteration 8: Polish & Edge Cases
**Status:** 📋 PLANNED
**Estimated Time:** 2-3 hours
**Branch:** feature/custom-themes-polish

**Goals:**
- Add localization for all new strings
- Handle edge cases (max themes, invalid data)
- Add undo/redo for editor (optional)
- Improve error messages
- Add onboarding/help tooltips

**Deliverables:**
1. Updated `.arb` localization files
2. Error handling improvements
3. User guidance tooltips
4. Edge case handling

**Testing Checklist:**
- [ ] All strings localized (en, ru, uk, etc.)
- [ ] Max themes limit enforced
- [ ] Corrupted data doesn't crash app
- [ ] Empty theme name prevented
- [ ] Duplicate names handled
- [ ] Network errors shown clearly
- [ ] Works offline (no AI generation)

**Acceptance Criteria:**
- No crashes in edge cases
- Clear user guidance
- Works in all supported languages

---

### 🔄 Iteration 9: (Optional) Supabase Sync
**Status:** 📋 OPTIONAL
**Estimated Time:** 3-4 hours
**Branch:** feature/custom-themes-sync

**Goals:**
- Create Supabase table for custom themes
- Sync custom themes across devices
- Cloud backup of themes
- Share themes with other users (optional)

**Deliverables:**
1. `lib/services/theme_sync_service.dart`
2. Supabase table schema
3. Sync on login/logout

**Testing Checklist:**
- [ ] Themes sync on login
- [ ] Local changes sync to cloud
- [ ] Cloud changes sync to device
- [ ] Handles conflicts correctly
- [ ] Works offline (queues changes)
- [ ] Doesn't duplicate themes

**Acceptance Criteria:**
- Seamless sync experience
- No data loss
- Works offline

---

## 📊 Progress Tracking

| Iteration | Status | Progress | Branch | PR |
|-----------|--------|----------|--------|-----|
| 0. Color Refactoring | ✅ DONE | 100% | `refactor/semantic-colors` | - |
| 1. Model & Storage | 📋 PLANNED | 0% | - | - |
| 2. Provider Integration | 📋 PLANNED | 0% | - | - |
| 3. Color Picker | 📋 PLANNED | 0% | - | - |
| 4. Editor Screen | 📋 PLANNED | 0% | - | - |
| 5. AI Generator Service | 📋 PLANNED | 0% | - | - |
| 6. AI Generator UI | 📋 PLANNED | 0% | - | - |
| 7. Selection Screen | 📋 PLANNED | 0% | - | - |
| 8. Polish | 📋 PLANNED | 0% | - | - |
| 9. Supabase Sync (Optional) | 📋 OPTIONAL | 0% | - | - |

**Total Progress:** 11% (1/9 iterations)

---

## 🎯 Milestones

### Milestone 1: MVP (Iterations 1-4)
**Goal:** Users can manually create custom themes
**Deadline:** TBD
**Deliverables:**
- Custom theme model
- Storage system
- Basic editor with color picker
- Can save and apply custom themes

### Milestone 2: AI Integration (Iterations 5-6)
**Goal:** Users can generate themes with AI
**Deadline:** TBD
**Deliverables:**
- AI theme generator
- User prompt input
- Generated themes are editable

### Milestone 3: Production Ready (Iterations 7-8)
**Goal:** Feature-complete and polished
**Deadline:** TBD
**Deliverables:**
- Updated theme selection screen
- Full localization
- Edge cases handled
- Ready for release

### Milestone 4: Cloud Sync (Iteration 9) - OPTIONAL
**Goal:** Themes sync across devices
**Deadline:** TBD
**Deliverables:**
- Supabase integration
- Multi-device support

---

## 🚀 Getting Started

**Next up:** Iteration 1 - Custom Color Model & Storage

Ready to start? Let's begin with creating the data models!

---

## 📝 Notes

- Each iteration should be testable independently
- Can skip iteration 9 (Supabase sync) if not needed
- Iterations 1-4 form the MVP
- Iterations 5-6 add AI magic
- Iterations 7-8 make it production-ready

