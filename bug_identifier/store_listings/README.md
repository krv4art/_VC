# AI Cosmetic Scanner - Store Listing Materials

This directory contains all materials needed for publishing AI Cosmetic Scanner to Google Play Store and Apple App Store.

## 📁 Directory Structure

```
store_listings/
├── shared/               # Unified content for all stores
│   ├── en/              # English
│   │   ├── name.txt                              # App name (both stores)
│   │   ├── description.txt                       # Full description (both stores)
│   │   ├── keywords.txt                          # Keywords (App Store)
│   │   ├── subtitle_app_store.txt                # Subtitle (App Store only)
│   │   ├── short_description_google_play.txt     # Short description (Google Play only)
│   │   └── promo_text_google_play.txt            # Promo text (Google Play only)
│   ├── ru/              # Russian
│   ├── uk/              # Ukrainian
│   ├── es/              # Spanish
│   ├── de/              # German
│   ├── fr/              # French
│   ├── it/              # Italian
│   ├── ko/              # Korean
│   └── ar/              # Arabic
├── google_play/          # Legacy Google Play Store materials (deprecated)
├── app_store/           # Legacy Apple App Store materials (deprecated)
├── screenshots/         # Screenshots for both stores
│   ├── phone/          # Phone screenshots
│   ├── tablet/         # Tablet screenshots
│   └── descriptions/   # Screenshot guidelines and captions
├── metadata.json        # Comprehensive metadata for all stores
├── reorganize.py        # Script used for reorganization
└── README.md           # This file
```

## 🌍 Supported Languages

Currently prepared:
- ✅ English (en)
- ✅ Russian (ru)
- ✅ Ukrainian (uk)
- ✅ Spanish (es)
- ✅ German (de)
- ✅ French (fr)
- ✅ Italian (it)
- ✅ Korean (ko)
- ✅ Arabic (ar)

## 📝 File Naming Convention

### Common Files (used by both stores)
- `name.txt` - App name (max 30 chars for App Store, 50 chars for Google Play)
- `description.txt` - Full description (max 4000 chars)
- `keywords.txt` - Keywords for App Store (max 100 chars, comma-separated)

### Store-Specific Files
- `subtitle_app_store.txt` - App Store subtitle (max 30 chars)
- `short_description_google_play.txt` - Google Play short description (max 80 chars)
- `promo_text_google_play.txt` - Google Play promo text (max 170 chars)

## 🍎 Apple App Store

### App Name (30 characters max)
Located in: `shared/{lang}/name.txt`

### Subtitle (30 characters max)
Located in: `shared/{lang}/subtitle_app_store.txt`

### Keywords (100 characters max, comma-separated)
Located in: `shared/{lang}/keywords.txt`

### Description (4000 characters max)
Located in: `shared/{lang}/description.txt`

## 📱 Google Play Store

### Short Description (80 characters max)
Located in: `shared/{lang}/short_description_google_play.txt`

### Promotional Text (170 characters max)
Located in: `shared/{lang}/promo_text_google_play.txt`

This appears at the top of your store listing and can be updated without submitting a new app version.

### Full Description (4000 characters max)
Located in: `shared/{lang}/description.txt` (same as App Store)

## 📸 Screenshots

See `screenshots/descriptions/screenshot_guide.md` for detailed guidance.

### Required Sizes

**Google Play**:
- Phone: 2-8 screenshots, min 320px
- Tablet: 0-8 screenshots (optional)

**App Store**:
- iPhone 6.7" (1290x2796) - Required
- iPhone 6.5" (1242x2688) - Required
- iPhone 5.5" (1242x2208) - Legacy
- iPad 12.9" (2048x2732) - If supporting iPad

### Recommended Sequence
1. Scan feature (hero shot)
2. Analysis results
3. Allergen warnings
4. AI chat
5. Scan history
6. Premium features

## 🎯 ASO (App Store Optimization) Strategy

### Primary Keywords (High traffic)
Based on keyword research:

1. **ingredient scanner** - 13,051 traffic
2. **toxic ingredients** - 13,052 traffic
3. **cosmetics checker** - 6,918 traffic
4. **cosmetics scanner** - 1,318 traffic
5. **skincare ingredient scanner** - 693 traffic

### Keyword Integration
- **App Title**: Include primary keyword
- **Subtitle/Short Description**: Include 2-3 top keywords
- **Description**: Natural integration of all primary and secondary keywords
- **App Store Keywords**: Comma-separated, no duplicates

## 📊 Metadata File

`metadata.json` contains:
- App information
- Localization settings
- Store-specific requirements
- Feature descriptions
- Premium features list
- Target audience
- Competitor analysis
- ASO strategy
- Screenshot sequence
- Pricing information

Use this file as a reference when preparing materials for other languages.

## 🚀 Publishing Checklist

### Before Submission

- [ ] All text files created for target language
- [ ] Character limits verified for each field
- [ ] Screenshots created in all required sizes
- [ ] Screenshots localized (UI + text overlays)
- [ ] Keywords optimized for target market
- [ ] Privacy policy URL active
- [ ] Support URL active
- [ ] App tested on target devices
- [ ] Content rating appropriate
- [ ] Pricing finalized

### Google Play Store

- [ ] Short description (80 chars) - `shared/{lang}/short_description_google_play.txt`
- [ ] Full description (4000 chars) - `shared/{lang}/description.txt`
- [ ] Promo text (170 chars) - `shared/{lang}/promo_text_google_play.txt`
- [ ] 2-8 phone screenshots
- [ ] Feature graphic (1024x500)
- [ ] App icon (512x512)
- [ ] Privacy policy URL
- [ ] App category
- [ ] Content rating questionnaire

### Apple App Store

- [ ] App name (30 chars) - `shared/{lang}/name.txt`
- [ ] Subtitle (30 chars) - `shared/{lang}/subtitle_app_store.txt`
- [ ] Keywords (100 chars) - `shared/{lang}/keywords.txt`
- [ ] Description (4000 chars) - `shared/{lang}/description.txt`
- [ ] Screenshots (all required sizes)
- [ ] App icon (1024x1024)
- [ ] Privacy policy URL
- [ ] App category
- [ ] Age rating

## 🌐 Localization Tips

When creating materials for other languages:

1. **Character Expansion**:
   - Russian/Ukrainian: +15-20% longer
   - German: +20-30% longer
   - Spanish/French/Italian: +10-15% longer

2. **Cultural Adaptation**:
   - Adjust tone for target market
   - Use culturally appropriate examples
   - Verify emoji appropriateness
   - Check keyword relevance in target market

3. **Technical Considerations**:
   - Test for text overflow in UI
   - Verify special character rendering
   - Check right-to-left languages (if applicable)
   - Ensure consistent terminology

## 🔄 Update Schedule

- **Screenshots**: After every major UI update
- **Descriptions**: Quarterly review and optimization
- **Keywords**: Monthly monitoring and adjustment
- **Localization**: As needed based on new market entry

## 📈 Performance Monitoring

Track these metrics:
- Impression-to-install conversion rate
- Keyword rankings
- Competitor positioning
- User reviews mentioning specific features
- Geographic performance variations

Adjust store listing based on data.

## 🛠️ Tools Used

- **Keyword Research**: ASO tools, Google Play Console
- **Screenshots**: Figma, Photoshop, or screenshot.rocks
- **Translation**: Professional translators (recommended)
- **A/B Testing**: Google Play Experiments, App Store Custom Product Pages

## 📞 Support

For questions about store listing materials:
- Review `metadata.json` for comprehensive reference
- Check `screenshot_guide.md` for visual guidelines
- Refer to keyword research data

## 📝 Notes

- Keep source files (PSD, Figma) for easy updates
- Version control all text files
- Test listings with target audience before publishing
- Monitor competitor listings regularly
- Update seasonal promotions in promo text (can change without app update)

## 🔄 Migration Notes

**October 2024**: Directory structure reorganized to eliminate duplication:
- All common content moved to `shared/` directory
- Store-specific files renamed with appropriate suffixes
- Legacy directories (`app_store/`, `google_play/`) kept for reference
- New structure reduces maintenance overhead and ensures consistency

---

**Last Updated**: October 2024
**Version**: 2.0.0
**Status**: ✅ All languages complete with unified structure