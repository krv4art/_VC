# Custom Interests Feature 🎯

## Overview

The Custom Interests feature allows students to create their own personalized interests beyond the 10 predefined categories. This revolutionary capability enables **truly individualized learning** where every student can specify their unique passions, hobbies, and areas of interest.

## Why Custom Interests Matter

### The Science Behind It

Research in educational psychology shows that:
- **Contextual Learning**: Students retain 3-4x more information when concepts are taught within familiar contexts
- **Neural Connections**: Personalized examples create stronger neural pathways in the brain
- **Emotional Engagement**: Learning through personal interests increases motivation and reduces cognitive load
- **Transfer of Knowledge**: Skills learned in familiar contexts transfer more easily to new situations

### Real-World Impact

Instead of generic math problems like:
> "If you have 12 apples and give away 5..."

Students who love LEGO will see:
> "You have 240 LEGO bricks and use 1/3 to build a castle. How many bricks do you have left?"

Students passionate about dinosaurs will encounter:
> "A T-Rex weighs 7 tons and a Triceratops weighs 12 tons. What's the total weight?"

## User Experience

### Creating a Custom Interest

1. **Access the Dialog**
   - During onboarding: Click "Add Your Own Interest" button
   - In settings: Navigate to profile → Edit Interests

2. **Choose an Emoji** (48 options)
   - 🦖 Dinosaurs
   - 🚗 Cars
   - 💃 Dancing
   - 🧱 LEGO
   - 📸 Photography
   - And 43 more!

3. **Enter Interest Name**
   - Examples: "LEGO", "Dinosaurs", "K-Pop", "Skateboarding"
   - Capitalization is automatic
   - Clear, simple input

4. **Specify Keywords** (Critical for AI!)
   - Comma or space-separated
   - Example for LEGO: `blocks, build, bricks, pieces, construct, minifigs`
   - Example for Dinosaurs: `T-Rex, fossil, prehistoric, Jurassic, extinct`
   - Example for Dancing: `rhythm, choreography, moves, performance, stage`

5. **Submit**
   - Interest is automatically selected
   - Appears in the interests grid
   - Saved to user profile immediately

### Managing Custom Interests

**Selecting/Deselecting**
- Tap any custom interest card to toggle selection
- Works exactly like predefined interests
- Green checkmark shows selection

**Deleting**
- Red X button in top-left corner of custom interest cards
- Confirmation not required (can be re-added easily)
- Removes from profile instantly

**Limits**
- No limit on number of custom interests
- Can have mix of predefined and custom (1-5 total selected)
- Each custom interest is unique with timestamp-based ID

## Technical Implementation

### Data Model

```dart
class Interest {
  final String id;                    // Unique identifier
  final String name;                  // Display name
  final String emoji;                 // Visual representation
  final String description;           // Auto-generated for custom
  final List<String> keywords;        // AI personalization keys
  final List<String> examples;        // Empty for custom
  final bool isCustom;                // Flag for custom interests
}
```

### Custom Interest Factory

```dart
factory Interest.custom({
  required String name,
  required String emoji,
  required List<String> keywords,
}) {
  final id = 'custom_${name.toLowerCase().replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}';
  return Interest(
    id: id,
    name: name,
    emoji: emoji,
    description: 'Custom interest: $name',
    keywords: keywords,
    examples: [],
    isCustom: true,
  );
}
```

**ID Generation Strategy**
- Prefix: `custom_`
- Sanitized name: lowercase, spaces replaced with underscores
- Timestamp: milliseconds since epoch (ensures uniqueness)
- Example: `custom_lego_1701234567890`

### Storage Architecture

**UserProfile Structure**
```dart
class UserProfile {
  final List<String> selectedInterests;      // IDs of predefined interests
  final List<Interest> customInterests;      // Full custom Interest objects

  // Combined getter
  List<Interest> get interests {
    final predefined = selectedInterests.map((id) => Interests.getById(id));
    return [...predefined, ...customInterests];
  }
}
```

**Persistence**
- Stored in SharedPreferences as JSON
- Custom interests serialized with full data
- Predefined interests stored as IDs only (for efficiency)

**JSON Structure**
```json
{
  "selected_interests": ["gaming", "sports"],
  "custom_interests": [
    {
      "id": "custom_lego_1701234567890",
      "name": "LEGO",
      "emoji": "🧱",
      "description": "Custom interest: LEGO",
      "keywords": ["blocks", "build", "bricks", "pieces"],
      "examples": [],
      "isCustom": true
    }
  ]
}
```

### AI Integration

**System Prompt Enhancement**

The AI receives custom interest keywords in the personalization context:

```dart
String getPersonalizationContext() {
  final allInterests = profile.interests; // Includes custom!
  final keywords = allInterests
      .expand((i) => i.keywords)
      .take(15)
      .join(', ');

  return '''
User Profile:
- Interests: ${allInterests.map((i) => i.name).join(', ')}
- Keywords: $keywords

Instructions:
- Use these keywords naturally in all examples
- Create problems related to user's interests
- Make learning personally relevant
''';
}
```

**Example Transformations**

With custom interest "LEGO 🧱" (keywords: blocks, build, bricks, pieces):

| Generic Problem | LEGO-Personalized Problem |
|----------------|---------------------------|
| "Calculate 1/3 of 240" | "You have 240 LEGO bricks and use 1/3 to build a castle. How many remain?" |
| "Find the perimeter of a rectangle" | "Your LEGO baseplate is 16 studs by 24 studs. What's the perimeter?" |
| "Solve for x: 5x + 10 = 60" | "You need x LEGO pieces per minifig. 5 minifigs need 60 pieces total, and you have 10 extra. Find x." |

## UI/UX Design

### Dialog Layout

```
┌─────────────────────────────────────┐
│  Add Your Own Interest              │
├─────────────────────────────────────┤
│                                     │
│  Choose an emoji                    │
│  ┌─────────────────────────────┐   │
│  │ ⭐ 🎯 🚀 💎 🎨 🎵 🏆 🌟   │   │
│  │ 🎭 🎪 🎸 🎹 🎬 📸 🏀 ⚽   │   │
│  │ ... (48 emojis total)         │   │
│  └─────────────────────────────┘   │
│                                     │
│  Interest name                      │
│  ┌─────────────────────────────┐   │
│  │ e.g., LEGO, Dinosaurs       │   │
│  └─────────────────────────────┘   │
│                                     │
│  Keywords (for AI)                  │
│  Separate with commas or spaces     │
│  ┌─────────────────────────────┐   │
│  │ e.g., blocks, build, bricks │   │
│  │                             │   │
│  └─────────────────────────────┘   │
│                                     │
│  💡 AI will use these keywords to   │
│     create personalized examples!   │
│                                     │
├─────────────────────────────────────┤
│           [Cancel]  [Add Interest]  │
└─────────────────────────────────────┘
```

### Interest Card States

**Predefined Interest**
```
┌──────────────┐
│      ✓       │  ← Checkmark (if selected)
│              │
│      🎮      │
│    Gaming    │
│              │
└──────────────┘
```

**Custom Interest**
```
┌──────────────┐
│ ✗        ✓   │  ← Delete (left), Checkmark (right)
│              │
│      🦖      │
│  Dinosaurs   │
│              │
└──────────────┘
```

## Best Practices

### For Users

**Creating Effective Keywords**
1. **Be Specific**: Use concrete terms from the interest domain
   - Good: "fossils, T-Rex, Jurassic, paleontology"
   - Bad: "cool, awesome, fun"

2. **Include Variety**: Mix nouns, verbs, and domain-specific terms
   - Good: "dance, choreography, rhythm, performance, stage, moves"
   - Bad: "dance, dancing, dancer" (too repetitive)

3. **Think Like the AI**: What words would make sense in a math problem?
   - Good: "camera, lens, shutter, exposure, photo" (for Photography)
   - These can appear in: "A camera shutter opens for 1/500th of a second..."

4. **Use 5-10 Keywords**: Enough variety without overwhelming
   - Too few: Limited personalization
   - Too many: Diluted focus

### For Developers

**Validation Rules**
```dart
// Name validation
- Minimum: 2 characters
- Maximum: 30 characters
- Allowed: Letters, numbers, spaces, hyphens
- Auto-capitalized

// Keywords validation
- Minimum: 1 keyword
- Maximum: 20 keywords
- Each keyword: 2-20 characters
- Parsed via RegExp(r'[,\s]+')
```

**Error Handling**
```dart
void _submit() {
  // Name validation
  if (name.isEmpty) {
    showSnackBar('Please enter a name for your interest');
    return;
  }

  // Keywords validation
  if (keywords.isEmpty) {
    showSnackBar('Please enter at least one keyword');
    return;
  }

  // Success
  Navigator.pop(context, customInterest);
}
```

## Examples by Interest Type

### Physical Hobbies

**Skateboarding 🛹**
- Keywords: `board, trick, ollie, kickflip, ramp, skate`
- Example: "You land an ollie that's 0.75 meters high. Express as a fraction."

**Dancing 💃**
- Keywords: `rhythm, beat, choreography, performance, step, move`
- Example: "A dance routine has 8 counts per measure. If you perform 12 measures, how many counts total?"

### Creative Pursuits

**Photography 📸**
- Keywords: `camera, lens, exposure, shutter, aperture, photo`
- Example: "A camera lens has f/2.8 aperture. The next stop is f/4. What's the ratio?"

**Drawing/Art 🎨**
- Keywords: `sketch, canvas, color, pencil, palette, brush`
- Example: "Your canvas is 50cm × 70cm. What's the area in square meters?"

### Collections/Hobbies

**LEGO 🧱**
- Keywords: `brick, build, piece, plate, minifig, construct`
- Example: "A LEGO set has 1,234 pieces. You've built 2/3. How many pieces left?"

**Trading Cards 🃏**
- Keywords: `card, deck, trade, collection, pack, rare`
- Example: "You have 240 cards. 15% are rare. How many rare cards?"

### Technology

**Robotics 🤖**
- Keywords: `robot, sensor, motor, code, circuit, program`
- Example: "A robot's sensor reads every 0.001 seconds. How many readings per second?"

**3D Printing 🖨️**
- Keywords: `print, layer, filament, model, nozzle, extrude`
- Example: "A 3D print uses 0.2mm layers. The model is 12mm tall. How many layers?"

### Nature/Science

**Astronomy 🔭**
- Keywords: `star, planet, galaxy, telescope, orbit, nebula`
- Example: "A planet orbits its star every 365.25 days. How many orbits in 10 years?"

**Marine Biology 🐠**
- Keywords: `ocean, fish, coral, reef, species, marine`
- Example: "A coral reef has 150 fish species. 40% are endangered. How many?"

## Future Enhancements

### Planned Features

1. **Interest Templates**
   - Quick-add popular interests with pre-filled keywords
   - Community-suggested keywords for common interests

2. **Keyword Suggestions**
   - AI-powered keyword recommendations based on interest name
   - "LEGO" → Auto-suggest: blocks, bricks, build, minifigs

3. **Interest Sharing**
   - Export/import custom interests
   - Share with friends or teachers
   - QR code generation

4. **Visual Customization**
   - Upload custom emoji/icon
   - Choose color scheme for interest
   - Add description/notes

5. **Analytics**
   - Track which interests generate the most engagement
   - See example problems created for each interest
   - Suggest new interests based on usage patterns

6. **Multi-language Support**
   - Keywords in user's native language
   - Automatic translation for AI context
   - Cultural adaptation

### Technical Roadmap

**Phase 1** (Current) ✅
- Basic custom interest creation
- Keyword-based personalization
- Local storage

**Phase 2** (Next)
- Cloud sync (Supabase)
- Interest templates library
- Keyword suggestions API

**Phase 3** (Future)
- Community features
- Visual customization
- Advanced analytics

## FAQ

**Q: How many custom interests can I create?**
A: Unlimited! However, you can only select 1-5 total interests (predefined + custom combined).

**Q: Can I edit a custom interest after creating it?**
A: Currently no - delete and recreate it. Edit functionality coming in future update.

**Q: What happens if I don't add keywords?**
A: The dialog won't let you submit without at least one keyword - they're essential for AI personalization!

**Q: Can teachers create interests for their students?**
A: This feature is coming in the Parent/Teacher Dashboard (planned for Phase 4 of MVP).

**Q: Are custom interests synced across devices?**
A: Not yet - currently stored locally. Cloud sync is planned for the next major update.

**Q: Can I use emojis in keywords?**
A: Better to use text keywords only - AI works better with words than symbols.

**Q: What if my interest is very niche?**
A: Perfect! That's exactly what custom interests are for. The more specific, the more personalized your learning.

**Q: Can I have multiple interests in the same category?**
A: Yes! You could have "Soccer ⚽" and "Basketball 🏀" as separate custom interests.

## Performance Considerations

### Storage Impact
- Each custom interest: ~200-500 bytes
- 10 custom interests: ~5 KB
- Negligible impact on SharedPreferences

### AI Context Length
- Keywords are limited to top 15 for performance
- Longer keyword lists don't improve personalization
- Quality > Quantity

### Network Usage
- Custom interests stored locally (no API calls)
- Future cloud sync will be optional
- Minimal data transfer

## Accessibility

### Screen Reader Support
- All form fields properly labeled
- Emoji selector announces emoji names
- Error messages are semantic

### Keyboard Navigation
- Tab through all fields
- Enter to submit
- Escape to cancel

### Visual Accessibility
- High contrast in dialog
- Large tap targets (48x48 minimum)
- Clear focus indicators

## Conclusion

Custom Interests represent a **paradigm shift** in educational technology. By allowing students to define their own learning contexts, we're creating the first truly **student-centric** AI tutor that adapts not just to learning pace, but to individual passions and interests.

This feature transforms the AI tutor from a generic teaching tool into a **personalized learning companion** that speaks the student's language - whether that's LEGO, dinosaurs, K-Pop, or rocket science.

---

**Documentation Version**: 1.0
**Feature Version**: 1.0
**Last Updated**: 2025-11-18
**Author**: AI Tutor Development Team
