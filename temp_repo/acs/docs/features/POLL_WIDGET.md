# Poll Widget Documentation

## Overview

This document describes the Poll Widget implementation for the ACS application. The widget allows users to vote for features they want to see in the app.

## Features

### Core Features
- ✅ Vote for up to 3 options
- ✅ Device-based uniqueness using device ID
- ✅ Add custom options
- ✅ Multiple filters (All, Top Voted, Newest, Trending, My Option)
- ✅ Pagination support
- ✅ Vote count display
- ✅ Visual feedback for voted options
- ✅ Thank you message after voting
- ✅ Localization (Russian and English)

### Storage
- **Phase 1**: SharedPreferences (Current Implementation)
- **Phase 2**: Supabase (Future Implementation)

## File Structure

```
lib/
├── models/
│   ├── poll_option.dart          # Model for poll options
│   └── poll_vote.dart             # Model for user votes
├── services/
│   └── poll_service.dart          # Service for poll operations
├── widgets/
│   └── poll_widget.dart           # Poll widget UI
└── screens/
    └── homepage_screen.dart       # Homepage with poll widget

lib/l10n/
├── app_en.arb                     # English localization
└── app_ru.arb                     # Russian localization
```

## Installation

1. The `device_info_plus` package has been added to `pubspec.yaml`
2. Run the following commands:

```bash
flutter pub get
flutter gen-l10n
```

## Usage

The poll widget is automatically displayed on the homepage under the Settings section.

### For Users

1. **Viewing Options**: All poll options are displayed with their vote counts
2. **Voting**:
   - Click on any option to vote for it
   - You can vote for up to 3 options
   - Voted options are highlighted with a checkmark
   - Your remaining votes are displayed at the top
3. **Adding Custom Options**:
   - Click "Add your option" button
   - Enter your suggestion (max 100 characters)
   - Click "Add" to submit
4. **Filtering Options**:
   - **All**: Show all options
   - **Top Voted**: Sort by vote count (highest first)
   - **Newest**: Sort by creation date (newest first)
   - **Trending**: Show options gaining popularity (created within 7 days with votes)
   - **My Option**: Show only options you created
5. **Pagination**: Use arrow buttons to navigate through pages (5 items per page)

### For Developers

#### PollService API

```dart
final pollService = PollService();

// Get device ID
String deviceId = await pollService.getDeviceId();

// Get all options
List<PollOption> options = await pollService.getOptions();

// Get user's vote
PollVote? vote = await pollService.getUserVote();

// Vote for an option
bool success = await pollService.vote(optionId);

// Unvote an option
bool success = await pollService.unvote(optionId);

// Add custom option
bool success = await pollService.addCustomOption("My suggestion");

// Get remaining votes
int remaining = await pollService.getRemainingVotes();

// Check if user has voted
bool hasVoted = await pollService.hasVoted();

// Reset poll (for testing)
await pollService.resetPoll();
```

## Default Poll Options

The poll comes with 5 default options:
1. AI анализ ингредиентов в реальном времени / AI ingredient analysis in real-time
2. Персональные рекомендации косметики / Personal cosmetics recommendations
3. История изменения состава / Composition change history
4. Сравнение продуктов / Product comparison
5. База знаний об ингредиентах / Ingredient knowledge base

## Design System Compliance

The poll widget follows the ACS Design System:
- Uses `AppDimensions` for spacing and sizing
- Uses `AppTheme` for typography
- Uses `context.colors` for theming
- Uses `AppSpacer` for consistent spacing
- Follows the 8-point grid system

## Localization Keys

New localization keys added:
- `pollTitle`: Poll question
- `pollDescription`: Voting instructions
- `votesRemaining`: Remaining votes display
- `votes`: Vote count label
- `addYourOption`: Add option button
- `enterYourOption`: Input placeholder
- `add`: Add button
- `filterAll`: All filter
- `filterTopVoted`: Top voted filter
- `filterNewest`: Newest filter
- `filterTrending`: Trending filter
- `filterMyOption`: My option filter
- `thankYouForVoting`: Thank you message
- `votingComplete`: Vote confirmation
- `cancel`: Cancel button

## Future Enhancements (Phase 2)

When implementing Supabase integration:

1. Create Supabase tables:
```sql
-- poll_options table
CREATE TABLE poll_options (
  id TEXT PRIMARY KEY,
  text TEXT NOT NULL,
  vote_count INTEGER DEFAULT 0,
  created_at TIMESTAMP DEFAULT NOW(),
  is_user_created BOOLEAN DEFAULT false
);

-- poll_votes table
CREATE TABLE poll_votes (
  device_id TEXT PRIMARY KEY,
  voted_option_ids TEXT[] NOT NULL,
  last_vote_time TIMESTAMP DEFAULT NOW()
);
```

2. Update `PollService` to use Supabase:
   - Replace SharedPreferences calls with Supabase queries
   - Add real-time vote count updates
   - Add vote synchronization
   - Add admin dashboard for managing options

## Testing

To test the poll widget:

1. Run the app
2. Navigate to the homepage
3. Scroll down to see the poll widget
4. Try voting for options
5. Try adding a custom option
6. Try different filters
7. Test pagination
8. Restart app to verify vote persistence

## Troubleshooting

### Common Issues

1. **Device ID not generated**:
   - Make sure `device_info_plus` is installed
   - Check platform-specific permissions

2. **Votes not persisting**:
   - Verify SharedPreferences is working
   - Check for errors in console

3. **Localization not working**:
   - Run `flutter gen-l10n`
   - Restart the app

4. **Widget not displaying**:
   - Check that `PollWidget` is imported in `homepage_screen.dart`
   - Verify no build errors

## Technical Notes

- **Device ID Generation**: Uses `device_info_plus` to generate a unique ID based on device information
- **Storage Format**: JSON serialization for SharedPreferences
- **Vote Limits**: Hardcoded to 3 votes per device
- **Pagination**: 5 items per page
- **Max Option Length**: 100 characters

## Credits

Implemented by: Claude AI Assistant
Date: 2025-01-06
Version: 1.0.0
