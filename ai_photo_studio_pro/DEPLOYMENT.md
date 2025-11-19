# AI Photo Studio Pro - Deployment Guide

Complete step-by-step deployment guide for AI Photo Studio Pro.

---

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Supabase Setup](#supabase-setup)
3. [Replicate Setup](#replicate-setup)
4. [RevenueCat Setup](#revenuecat-setup)
5. [Flutter App Configuration](#flutter-app-configuration)
6. [Building APK/IPA](#building-apkipa)
7. [App Store Deployment](#app-store-deployment)
8. [Testing](#testing)
9. [Monitoring](#monitoring)
10. [Troubleshooting](#troubleshooting)

---

## Prerequisites

### Required Accounts
- [ ] Supabase account (https://supabase.com)
- [ ] Replicate account (https://replicate.com)
- [ ] RevenueCat account (https://www.revenuecat.com)
- [ ] Apple Developer Program ($99/year for iOS)
- [ ] Google Play Console ($25 one-time for Android)
- [ ] Remove.bg account (optional, https://www.remove.bg)

### Required Tools
```bash
# Flutter
flutter --version  # Should be >= 3.0.0

# Supabase CLI
npm install -g supabase

# Fastlane (for deployment automation)
gem install fastlane
```

---

## 1. Supabase Setup

### Step 1: Create Project

1. Go to https://supabase.com
2. Click "New Project"
3. Fill in details:
   - **Name:** AI Photo Studio Pro
   - **Database Password:** (save this securely)
   - **Region:** Choose closest to target users
4. Wait for project creation (~2 minutes)

### Step 2: Get Credentials

1. Go to Project Settings → API
2. Copy these values:
   ```
   Project URL: https://YOUR_PROJECT.supabase.co
   anon public key: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
   ```

### Step 3: Deploy Edge Functions

See [SUPABASE_FUNCTIONS.md](SUPABASE_FUNCTIONS.md) for complete implementation.

Quick deploy:
```bash
# Login to Supabase
supabase login

# Link your project
supabase link --project-ref YOUR_PROJECT_REF

# Deploy all functions
cd supabase/functions
supabase functions deploy ai-photo-enhance --no-verify-jwt
supabase functions deploy background-removal --no-verify-jwt
supabase functions deploy image-upscaling --no-verify-jwt
supabase functions deploy image-expansion --no-verify-jwt
supabase functions deploy outfit-change --no-verify-jwt
```

### Step 4: Set Secrets

```bash
# Replicate API Token (required)
supabase secrets set REPLICATE_API_TOKEN=r8_xxxxxxxxxxxx

# Remove.bg API Key (optional)
supabase secrets set REMOVEBG_API_KEY=xxxxxxxxxxxx

# Verify secrets
supabase secrets list
```

### Step 5: Create Database Tables

```sql
-- Batch generation jobs table
CREATE TABLE batch_generation_jobs (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  request JSONB NOT NULL,
  status TEXT NOT NULL,
  total_photos INTEGER NOT NULL,
  completed_photos INTEGER DEFAULT 0,
  failed_photos INTEGER DEFAULT 0,
  generated_photo_ids TEXT[] DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  started_at TIMESTAMPTZ,
  completed_at TIMESTAMPTZ,
  error TEXT
);

-- Add indexes
CREATE INDEX idx_batch_jobs_user_id ON batch_generation_jobs(user_id);
CREATE INDEX idx_batch_jobs_status ON batch_generation_jobs(status);
CREATE INDEX idx_batch_jobs_created_at ON batch_generation_jobs(created_at DESC);

-- Enable RLS (Row Level Security)
ALTER TABLE batch_generation_jobs ENABLE ROW LEVEL SECURITY;

-- RLS Policy: Users can only see their own jobs
CREATE POLICY "Users can view own jobs"
  ON batch_generation_jobs
  FOR SELECT
  USING (auth.uid()::text = user_id);

CREATE POLICY "Users can insert own jobs"
  ON batch_generation_jobs
  FOR INSERT
  WITH CHECK (auth.uid()::text = user_id);
```

---

## 2. Replicate Setup

### Step 1: Create Account

1. Go to https://replicate.com
2. Sign up with GitHub or Email
3. Go to Account → API Tokens
4. Create new token
5. Copy token (starts with `r8_`)

### Step 2: Get API Credits

- Add payment method
- Consider starting with $50 credit
- Monitor usage in dashboard

### Cost Estimation:
- FLUX.1 Schnell: ~$0.003 per image
- Upscaling: ~$0.01 per image
- Background removal: ~$0.005 per image
- **Estimated cost per user/month:** $2-5

---

## 3. RevenueCat Setup

### Step 1: Create Account

1. Go to https://www.revenuecat.com
2. Sign up (free tier available)
3. Create new project: "AI Photo Studio Pro"

### Step 2: Configure Products

#### iOS Products (App Store Connect)
1. Go to App Store Connect
2. Features → In-App Purchases
3. Create products:

**Product 1: Basic Monthly**
- Product ID: `ai_photo_basic_monthly`
- Type: Auto-renewable subscription
- Price: $9.99/month

**Product 2: Pro Monthly**
- Product ID: `ai_photo_pro_monthly`
- Type: Auto-renewable subscription
- Price: $29.99/month

**Product 3: Enterprise Monthly**
- Product ID: `ai_photo_enterprise_monthly`
- Type: Auto-renewable subscription
- Price: $99/month

#### Android Products (Google Play Console)
1. Go to Google Play Console
2. Monetize → Products → Subscriptions
3. Create same products with matching IDs

### Step 3: Link RevenueCat

1. In RevenueCat dashboard → Apps
2. Add iOS app
   - Bundle ID: `com.yourcompany.aiphotostudiopro`
   - Shared Secret: (from App Store Connect)
3. Add Android app
   - Package Name: `com.yourcompany.aiphotostudiopro`
   - Service Account: (upload JSON)

### Step 4: Get API Keys

1. Go to RevenueCat → API Keys
2. Copy Public API Key (starts with `appl_`)
3. This goes into your Flutter app

---

## 4. Flutter App Configuration

### Step 1: Update Environment

Create `.env` file in project root:
```env
SUPABASE_URL=https://YOUR_PROJECT.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
REVENUECAT_API_KEY=appl_xxxxxxxxxxxx
```

### Step 2: Update `utils/supabase_constants.dart`

```dart
class SupabaseConfig {
  // Production
  static const String prodSupabaseUrl = 'https://YOUR_PROJECT.supabase.co';
  static const String prodSupabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...';

  // Development (use same or separate project)
  static const String devSupabaseUrl = 'https://YOUR_DEV_PROJECT.supabase.co';
  static const String devSupabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...';

  // Will use .env values if available, otherwise fallback to these
  static String supabaseUrl = '';
  static String supabaseAnonKey = '';
}
```

### Step 3: Update RevenueCat in `main.dart`

```dart
// Initialize RevenueCat
if (!kIsWeb) {
  await Purchases.configure(
    PurchasesConfiguration("appl_your_key_here"), // Replace
  );
}
```

### Step 4: Update App Identity

**pubspec.yaml:**
```yaml
name: ai_photo_studio_pro
description: "AI Photo Studio Pro - Professional AI Headshot Generator"
version: 1.0.0+1
```

**iOS (ios/Runner/Info.plist):**
```xml
<key>CFBundleDisplayName</key>
<string>AI Photo Studio Pro</string>
<key>CFBundleIdentifier</key>
<string>com.yourcompany.aiphotostudiopro</string>
```

**Android (android/app/build.gradle):**
```gradle
applicationId "com.yourcompany.aiphotostudiopro"
```

---

## 5. Building APK/IPA

### Android APK

```bash
# Clean
flutter clean
flutter pub get

# Build release APK
flutter build apk --release

# Build App Bundle (for Play Store)
flutter build appbundle --release

# Output locations:
# APK: build/app/outputs/flutter-apk/app-release.apk
# AAB: build/app/outputs/bundle/release/app-release.aab
```

### iOS IPA

```bash
# Clean
flutter clean
flutter pub get

# Build iOS (requires Mac + Xcode)
flutter build ios --release

# Archive in Xcode:
# 1. Open ios/Runner.xcworkspace in Xcode
# 2. Product → Archive
# 3. Distribute App → App Store Connect
```

---

## 6. App Store Deployment

### iOS - App Store Connect

1. **Create App**
   - Go to App Store Connect → My Apps → + → New App
   - Platform: iOS
   - Name: AI Photo Studio Pro
   - Bundle ID: com.yourcompany.aiphotostudiopro
   - SKU: ai-photo-studio-pro-001

2. **Upload Build**
   - Use Xcode Archive → Upload
   - Or use `fastlane deliver`

3. **Fill App Information**
   - Description, screenshots, keywords
   - Privacy Policy URL (required!)
   - Support URL
   - Age rating: 4+

4. **Submit for Review**
   - Add test account credentials
   - Review notes (mention AI features)
   - Submit

**Review Time:** 24-48 hours typically

### Android - Google Play Console

1. **Create App**
   - Go to Google Play Console → Create App
   - Name: AI Photo Studio Pro
   - Default language: English
   - Type: App or game → App

2. **Upload Build**
   - Release → Production → Create new release
   - Upload AAB file
   - Release notes

3. **Fill Store Listing**
   - Short description (80 chars)
   - Full description
   - Screenshots (min 2)
   - Feature graphic (1024x500)
   - App icon (512x512)

4. **Content Rating**
   - Complete questionnaire
   - AI Photo Studio → EVERYONE

5. **Pricing**
   - Free with in-app purchases
   - Select countries

6. **Submit for Review**

**Review Time:** Few hours to days

---

## 7. Testing

### Manual Testing Checklist

#### Core Features
- [ ] Take photo with camera
- [ ] Select photo from gallery
- [ ] Generate headshot with style
- [ ] View generated photo in gallery

#### New AI Features
- [ ] Open Advanced Editor
- [ ] Apply Natural retouch preset
- [ ] Remove background
- [ ] Change background to Office preset
- [ ] Change outfit to Business Suit
- [ ] Upscale to 4K
- [ ] Expand to Instagram (4:5) format

#### Batch Generation
- [ ] Select 5 photos
- [ ] Set variations to 3
- [ ] Enable retouch
- [ ] Enable background change
- [ ] Start batch generation
- [ ] Monitor progress
- [ ] View completed photos

#### Subscription
- [ ] View paywall
- [ ] Purchase Basic subscription (use test account)
- [ ] Verify premium features unlock
- [ ] Cancel subscription
- [ ] Verify downgrade

### Automated Testing

```bash
# Run all tests
flutter test

# Integration tests
flutter test integration_test/

# Generate coverage
flutter test --coverage
```

---

## 8. Monitoring

### Supabase Dashboard

Monitor:
- Functions → Logs (check errors)
- Database → Tables (check batch_generation_jobs)
- Auth → Users (user growth)
- Storage → Buckets (storage usage)

### RevenueCat Dashboard

Monitor:
- Overview → Revenue
- Charts → Active subscriptions
- Customers → Churn rate
- Charts → Trial conversions

### Replicate Dashboard

Monitor:
- Predictions → Usage
- Billing → Costs
- Models → Performance

### Set Up Alerts

**Supabase:**
1. Go to Project Settings → Integrations
2. Enable Webhook for errors
3. Connect to Slack/Discord

**Cost Alerts:**
1. Set budget alerts in Replicate
2. Set up Supabase usage notifications
3. Monitor RevenueCat MRR

---

## 9. Troubleshooting

### Common Issues

#### 1. "Supabase function error"
```
Error: Supabase function error: timeout
```
**Solution:**
- Check Supabase logs
- Verify API keys are set
- Check Replicate account has credits

#### 2. "Image generation failed"
```
Error: Generation job failed: insufficient credits
```
**Solution:**
- Add credits to Replicate account
- Check model availability

#### 3. "Subscription not detected"
```
RevenueCat: No active subscription found
```
**Solution:**
- Verify RevenueCat configuration
- Check product IDs match
- Ensure user is logged in

#### 4. "Background removal failed"
```
Error: Remove.bg API error: 403
```
**Solution:**
- Verify Remove.bg API key
- Check account has credits
- Fallback to Replicate background removal

### Debug Mode

Enable debug logging:
```dart
// In main.dart
void main() async {
  if (kDebugMode) {
    debugPrint('Debug mode enabled');
  }
  // ... rest of initialization
}
```

---

## 10. Post-Deployment Checklist

### Week 1
- [ ] Monitor error rates daily
- [ ] Check user feedback/reviews
- [ ] Verify subscription conversions
- [ ] Monitor API costs
- [ ] Test all features on production

### Month 1
- [ ] Analyze user engagement
- [ ] A/B test pricing if needed
- [ ] Optimize API usage
- [ ] Add missing features from feedback
- [ ] Update screenshots/marketing

### Ongoing
- [ ] Weekly cost monitoring
- [ ] Monthly feature updates
- [ ] Quarterly market research
- [ ] Annual pricing review

---

## Support & Resources

- **Supabase Docs:** https://supabase.com/docs
- **Replicate Docs:** https://replicate.com/docs
- **RevenueCat Docs:** https://docs.revenuecat.com
- **Flutter Docs:** https://docs.flutter.dev

---

## Next Steps

1. ✅ Complete Supabase setup
2. ✅ Deploy Edge Functions
3. ✅ Configure RevenueCat
4. ✅ Build and test APK/IPA
5. ✅ Submit to App Stores
6. ✅ Launch marketing campaign
7. ✅ Monitor and iterate

---

**Last Updated:** November 2025
**Version:** 1.0.0
