# AI Photo Studio Pro - Features Reference Guide

Quick reference for all implemented AI features and their usage.

## Table of Contents
1. [AI Portrait Retouch](#ai-portrait-retouch)
2. [Background Editing](#background-editing)
3. [Outfit Customization](#outfit-customization)
4. [Aspect Ratio Expansion](#aspect-ratio-expansion)
5. [4K Upscaling](#4k-upscaling)
6. [Batch Generation](#batch-generation)
7. [Integration Points](#integration-points)
8. [Code Examples](#code-examples)

---

## AI Portrait Retouch

### Overview
Professional AI-powered portrait retouching with customizable settings.

### Features
- 3 Quick Presets (Natural, Professional, Glamour)
- 9 Customizable Settings:
  - Remove blemishes
  - Smooth skin
  - Enhance lighting
  - Color correction
  - Remove shine
  - Enhance eyes
  - Whiten teeth
  - Smoothness level (0-100%)
  - Lighting intensity (0-100%)

### Service File
`lib/services/ai_retouch_service.dart`

### Model File
`lib/models/retouch_settings.dart`

### Usage Example
```dart
// Quick preset
final result = await retouchService.professionalRetouch(imagePath);

// Custom settings
final settings = RetouchSettings(
  removeBlemishes: true,
  smoothSkin: true,
  smoothnessLevel: 0.7,
  enhanceLighting: true,
  lightingIntensity: 0.6,
);
final result = await retouchService.applyRetouch(
  imagePath: imagePath,
  settings: settings,
);
```

### Supabase Edge Function
`supabase/functions/ai-photo-enhance`

### API Endpoint
`POST /functions/v1/ai-photo-enhance`
```json
{
  "action": "retouch",
  "image": "base64_image_data",
  "settings": {
    "preset": "professional"
    // or custom settings
  }
}
```

---

## Background Editing

### Overview
Remove or replace backgrounds with AI-powered precision.

### Features
- **Background Removal**: Transparent PNG output
- **8 Professional Preset Backgrounds**:
  - Modern Office
  - White Studio
  - Outdoor Scene
  - Urban Setting
  - Library
  - Conference Room
  - Modern Interior
  - Classic Interior
- **Custom Background**: Upload your own
- **Solid Color**: Any color background
- **Blur Effect**: Adjustable blur (0-100%)

### Service File
`lib/services/background_removal_service.dart`

### Model File
`lib/models/background_settings.dart`

### Usage Example
```dart
// Remove background
final transparent = await backgroundService.removeBackground(imagePath);

// Replace with preset
final settings = BackgroundSettings(
  type: BackgroundType.replace,
  style: BackgroundStyle.office,
);
final result = await backgroundService.replaceBackground(
  imagePath: imagePath,
  settings: settings,
);

// Custom background
final settings = BackgroundSettings(
  type: BackgroundType.replace,
  customBackgroundUrl: 'https://example.com/bg.jpg',
);
```

### Supabase Edge Function
`supabase/functions/background-removal`

### API Endpoint
`POST /functions/v1/background-removal`
```json
{
  "action": "remove",  // or "replace"
  "image": "base64_image_data",
  "settings": {
    "style": "office"  // or custom settings
  }
}
```

---

## Outfit Customization

### Overview
Change clothing with AI-powered virtual try-on.

### Features
- **10 Profession-Specific Outfits**:
  - Business Suit (Male)
  - Business Suit (Female)
  - Medical Scrubs
  - Lab Coat
  - Casual Shirt
  - Polo Shirt
  - Sweater
  - Blazer
  - Formal Dress
  - Turtleneck
- **Custom Prompts**: Describe any outfit

### Service File
`lib/services/ai_outfit_change_service.dart`

### Usage Example
```dart
// Preset outfit
final result = await outfitService.changeOutfit(
  imagePath: imagePath,
  outfitType: OutfitType.businessSuitMale,
);

// Custom outfit
final result = await outfitService.changeOutfit(
  imagePath: imagePath,
  outfitType: OutfitType.custom,
  customPrompt: 'wearing a red evening gown',
);

// Get available options
final options = AIOutfitChangeService.getAvailableOutfits();
```

### Supabase Edge Function
`supabase/functions/outfit-change`

### API Endpoint
`POST /functions/v1/outfit-change`
```json
{
  "image": "base64_image_data",
  "outfit_type": "business_suit_male",
  "custom_prompt": "optional custom description"
}
```

---

## Aspect Ratio Expansion

### Overview
AI-powered outpainting to change aspect ratios for different platforms.

### Features
- **5 Target Aspect Ratios**:
  - Square (1:1) - Instagram Posts - 1080x1080
  - Portrait (4:5) - Instagram Feed - 1080x1350
  - Stories (9:16) - Reels/TikTok - 1080x1920
  - Landscape (16:9) - YouTube - 1920x1080
  - LinkedIn Banner - 1584x396
- **3 Expansion Directions**:
  - All sides
  - Horizontal only
  - Vertical only

### Service File
`lib/services/ai_image_expansion_service.dart`

### Usage Example
```dart
// Expand to Instagram Stories format
final result = await expansionService.expandImage(
  imagePath: imagePath,
  targetRatio: AspectRatio.ratio9x16,
  direction: ExpansionDirection.vertical,
);

// Get available ratios
final ratios = AIImageExpansionService.getAvailableRatios();
```

### Supabase Edge Function
`supabase/functions/image-expansion`

### API Endpoint
`POST /functions/v1/image-expansion`
```json
{
  "image": "base64_image_data",
  "target_ratio": "9:16",
  "direction": "vertical"
}
```

---

## 4K Upscaling

### Overview
AI-powered image upscaling to 4K quality using Real-ESRGAN.

### Features
- **2x or 4x Scale Factor**
- **3 Quality Modes**:
  - Standard (fast, good quality)
  - High (balanced)
  - Ultra (best quality, slower)
- **Automatic 4K Upscaling**

### Service File
`lib/services/image_upscaling_service.dart`

### Usage Example
```dart
// Quick 4K upscale
final result = await upscalingService.upscaleTo4K(imagePath);

// Custom upscaling
final result = await upscalingService.upscaleImage(
  imagePath: imagePath,
  scaleFactor: 4,
  quality: UpscaleQuality.ultra,
);
```

### Supabase Edge Function
`supabase/functions/image-upscaling`

### API Endpoint
`POST /functions/v1/image-upscaling`
```json
{
  "image": "base64_image_data",
  "scale_factor": 4,
  "quality": "ultra"
}
```

---

## Batch Generation

### Overview
Enterprise-ready bulk photo processing for teams and businesses.

### Features
- **Multi-Photo Upload**: Up to 100 photos
- **Configurable Variations**: 1-20 variations per photo
- **Optional Enhancements**:
  - AI Retouch (with preset selection)
  - Background Changes
- **High Resolution Output**
- **Real-time Progress Tracking**
- **Job Persistence**: Resume after app restart

### Service File
`lib/services/batch_generation_service.dart`

### Model File
`lib/models/batch_generation_request.dart`

### Screen File
`lib/screens/batch_generation_screen.dart`

### Usage Example
```dart
// Create batch job
final request = BatchGenerationRequest(
  imagePaths: ['/path/1.jpg', '/path/2.jpg'],
  styleId: 'professional_headshot',
  numberOfVariations: 5,
  highResolution: true,
  retouchSettings: RetouchSettings.professional(),
  backgroundSettings: BackgroundSettings(
    type: BackgroundType.replace,
    style: BackgroundStyle.office,
  ),
);

// Start processing
final job = await batchService.startBatchGeneration(request);

// Monitor progress
print('Progress: ${job.completedPhotos}/${job.totalPhotos}');
print('Percentage: ${(job.progress * 100).toInt()}%');
```

### Database Tables
- `batch_generation_jobs` - Job tracking
- `batch_generation_items` - Individual photo items

---

## Integration Points

### Navigation

**Homepage Quick Actions** (`lib/screens/homepage_screen.dart`):
```dart
// AI Editor button (line 449)
context.push('/advanced-editor', extra: imagePath);

// Batch Gen button (line 462)
context.push('/batch-generation');
```

**Router Configuration** (`lib/navigation/app_router.dart`):
```dart
// Advanced Photo Editor route
GoRoute(
  path: '/advanced-editor',
  pageBuilder: (context, state) {
    final imagePath = state.extra as String?;
    return AdvancedPhotoEditorScreen(imagePath: imagePath);
  },
),

// Batch Generation route
GoRoute(
  path: '/batch-generation',
  pageBuilder: (context, state) {
    return BatchGenerationScreen();
  },
),
```

### Provider Setup

**Main App** (`lib/main.dart`):
```dart
// All 6 AI services as Providers
Provider<AIRetouchService>(
  create: (context) => AIRetouchService(
    supabaseClient: Supabase.instance.client,
  ),
),
Provider<BackgroundRemovalService>(...),
Provider<ImageUpscalingService>(...),
Provider<AIImageExpansionService>(...),
Provider<AIOutfitChangeService>(...),

// Batch service with complex dependencies
ProxyProvider6<
  ReplicateService,
  LocalPhotoDatabase,
  AIRetouchService,
  BackgroundRemovalService,
  ImageUpscalingService,
  AIImageExpansionService,
  BatchGenerationService
>(
  update: (context, replicate, db, retouch, bg, upscale, expand, prev) =>
    BatchGenerationService(...),
),

// Enhanced photo provider
ChangeNotifierProxyProvider6<
  AIRetouchService,
  BackgroundRemovalService,
  BatchGenerationService,
  ImageUpscalingService,
  AIImageExpansionService,
  AIOutfitChangeService,
  EnhancedPhotoProvider
>(
  create: (context) => EnhancedPhotoProvider(...),
),
```

### State Management

**Enhanced Photo Provider** (`lib/providers/enhanced_photo_provider.dart`):
```dart
class EnhancedPhotoProvider with ChangeNotifier {
  bool _isProcessing = false;
  double _progress = 0.0;
  String? _currentOperation;
  BatchGenerationJob? _currentBatchJob;

  // Getters
  bool get isProcessing => _isProcessing;
  double get progress => _progress;
  String? get currentOperation => _currentOperation;
  BatchGenerationJob? get currentBatchJob => _currentBatchJob;

  // Methods for each AI operation
  Future<String> applyRetouch(...) async { ... }
  Future<String> removeBackground(...) async { ... }
  Future<String> changeOutfit(...) async { ... }
  Future<String> expandImage(...) async { ... }
  Future<String> upscaleImage(...) async { ... }
  Future<BatchGenerationJob> startBatchGeneration(...) async { ... }
}
```

---

## Code Examples

### Complete Workflow Example

```dart
// 1. Get providers
final enhancedPhotoProvider = context.read<EnhancedPhotoProvider>();
final subscriptionProvider = context.read<SubscriptionProvider>();

// 2. Check subscription (premium features)
if (!subscriptionProvider.isPro) {
  // Show paywall
  context.push('/subscription');
  return;
}

// 3. Apply retouch
final retouchedPath = await enhancedPhotoProvider.applyRetouch(
  imagePath: originalImagePath,
  settings: RetouchSettings.professional(),
);

// 4. Change background
final finalPath = await enhancedPhotoProvider.replaceBackground(
  imagePath: retouchedPath,
  settings: BackgroundSettings(
    type: BackgroundType.replace,
    style: BackgroundStyle.office,
  ),
);

// 5. Upscale to 4K
final hdPath = await enhancedPhotoProvider.upscaleImage(
  imagePath: finalPath,
  scaleFactor: 4,
  quality: UpscaleQuality.ultra,
);

// 6. Save and display
// Result is ready in hdPath
```

### UI Integration Example

```dart
// In your screen widget
Consumer<EnhancedPhotoProvider>(
  builder: (context, provider, child) {
    if (provider.isProcessing) {
      return Column(
        children: [
          CircularProgressIndicator(value: provider.progress),
          SizedBox(height: 16),
          Text(provider.currentOperation ?? 'Processing...'),
          Text('${(provider.progress * 100).toInt()}%'),
        ],
      );
    }
    return YourNormalUI();
  },
)
```

### Error Handling Example

```dart
try {
  final result = await enhancedPhotoProvider.applyRetouch(
    imagePath: imagePath,
    settings: settings,
  );
  // Success!
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Retouch applied successfully!')),
  );
} catch (e) {
  // Handle error
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Error: ${e.toString()}')),
  );
}
```

---

## Localization

All features have full localization support in:
- 🇺🇸 English
- 🇷🇺 Russian
- 🇺🇦 Ukrainian

**Total localization keys**: 150+ new keys

**Files**:
- `lib/l10n/app_en.arb`
- `lib/l10n/app_ru.arb`
- `lib/l10n/app_uk.arb`

**Usage**:
```dart
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// In your widget
final l10n = AppLocalizations.of(context)!;

// Use localized strings
Text(l10n.aiEditor);
Text(l10n.batchGen);
Text(l10n.retouchTitle);
Text(l10n.processingRetouch);
```

---

## Premium Feature Gates

All new AI features are gated behind Pro subscription:

```dart
// Check subscription status
if (!subscriptionProvider.isPro) {
  // Show premium feature dialog
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.premiumOnly),
      content: Text(l10n.premiumFeatureRetouch), // or other feature
      actions: [
        TextButton(
          onPressed: () => context.push('/subscription'),
          child: Text(l10n.upgradeNow),
        ),
      ],
    ),
  );
  return;
}
```

---

## Database Schema

All operations are tracked in Supabase for analytics and history:

**Tables**:
- `enhanced_photos` - All AI-enhanced photos
- `retouch_history` - Retouch operations
- `background_changes` - Background operations
- `outfit_changes` - Outfit operations
- `image_expansions` - Expansion operations
- `image_upscaling` - Upscaling operations
- `batch_generation_jobs` - Batch jobs
- `batch_generation_items` - Batch items

**Migration**: `supabase/migrations/20250119_create_enhanced_features_schema.sql`

---

## Performance Considerations

1. **Image Compression**: All images are compressed before upload
2. **Caching**: Results are cached for 7 days
3. **Background Processing**: Long operations run in background
4. **Progress Tracking**: Real-time progress updates
5. **Error Recovery**: Jobs can be resumed after failure

---

## Testing Checklist

- [ ] Retouch with each preset
- [ ] Retouch with custom settings
- [ ] Remove background
- [ ] Replace background with each preset
- [ ] Replace with custom background
- [ ] Change outfit with each preset
- [ ] Expand to each aspect ratio
- [ ] Upscale with each quality mode
- [ ] Batch generation (small batch 2-3 photos)
- [ ] Batch generation with enhancements
- [ ] Progress tracking during operations
- [ ] Error handling for failed operations
- [ ] Subscription gates
- [ ] Localization in all 3 languages

---

## Cost Per Operation

Based on Replicate pricing:

| Operation | Cost per Use | Free Tier | Pro Tier Limit |
|-----------|-------------|-----------|----------------|
| Headshot Generation | $0.003 | 3/day | 100/month |
| AI Retouch | $0.003 | Included | Unlimited |
| Background Removal | $0.01 | Included | Unlimited |
| Outfit Change | $0.005 | Premium | Unlimited |
| 4K Upscaling | $0.02 | Premium | Unlimited |
| Aspect Expansion | $0.005 | Premium | Unlimited |
| Batch Generation | Varies | Premium | Unlimited |

**Average cost per enhanced photo**: $0.02 - $0.05

---

## Support & Documentation

- **Main README**: [README.md](./README.md)
- **Market Research**: [MARKET_RESEARCH.md](./MARKET_RESEARCH.md)
- **API Setup**: [API_SETUP_GUIDE.md](./API_SETUP_GUIDE.md)
- **Supabase Functions**: [SUPABASE_FUNCTIONS.md](./SUPABASE_FUNCTIONS.md)
- **Deployment Guide**: [DEPLOYMENT.md](./DEPLOYMENT.md)
