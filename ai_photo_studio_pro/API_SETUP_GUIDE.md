# API Setup Guide
Complete guide for configuring all API keys and services for AI Photo Studio Pro

## Table of Contents
1. [Supabase Setup](#supabase-setup)
2. [Replicate API Setup](#replicate-api-setup)
3. [Remove.bg API Setup](#removebg-api-setup)
4. [RevenueCat Setup](#revenuecat-setup)
5. [Environment Variables](#environment-variables)
6. [Testing Configuration](#testing-configuration)
7. [Cost Estimates](#cost-estimates)
8. [Troubleshooting](#troubleshooting)

---

## Supabase Setup

### 1. Create Supabase Project

1. Go to [https://supabase.com](https://supabase.com)
2. Click "Start your project" or "New Project"
3. Choose organization and create project:
   - **Project Name**: `ai-photo-studio-pro`
   - **Database Password**: Generate strong password (save it!)
   - **Region**: Choose closest to your users
   - **Pricing Plan**: Free to start (can upgrade later)

### 2. Get API Keys

1. Navigate to **Project Settings** → **API**
2. Copy the following:
   - **Project URL**: `https://xxxxxxxxxxxxx.supabase.co`
   - **anon/public key**: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...`
   - **service_role key**: (Keep this secret! Only for Edge Functions)

### 3. Set Up Database

1. Navigate to **SQL Editor**
2. Upload and run migration file:
   ```bash
   supabase/migrations/20250119_create_enhanced_features_schema.sql
   ```
3. Verify tables created:
   - `batch_generation_jobs`
   - `batch_generation_items`
   - `enhanced_photos`
   - `retouch_history`
   - `background_changes`
   - `outfit_changes`
   - `image_expansions`
   - `image_upscaling`

### 4. Set Up Storage Buckets

1. Navigate to **Storage**
2. Create buckets:
   - **Bucket Name**: `enhanced-photos`
     - **Public**: No
     - **File size limit**: 10MB
   - **Bucket Name**: `batch-generations`
     - **Public**: No
     - **File size limit**: 10MB

3. Set up Storage Policies:
   ```sql
   -- Allow authenticated users to upload to their own folder
   CREATE POLICY "Users can upload own photos"
   ON storage.objects FOR INSERT
   WITH CHECK (
     bucket_id = 'enhanced-photos'
     AND auth.uid()::text = (storage.foldername(name))[1]
   );

   -- Allow users to read their own files
   CREATE POLICY "Users can read own photos"
   ON storage.objects FOR SELECT
   USING (
     bucket_id = 'enhanced-photos'
     AND auth.uid()::text = (storage.foldername(name))[1]
   );

   -- Allow users to delete their own files
   CREATE POLICY "Users can delete own photos"
   ON storage.objects FOR DELETE
   USING (
     bucket_id = 'enhanced-photos'
     AND auth.uid()::text = (storage.foldername(name))[1]
   );
   ```

### 5. Deploy Edge Functions

1. Install Supabase CLI:
   ```bash
   npm install -g supabase
   ```

2. Login to Supabase:
   ```bash
   supabase login
   ```

3. Link to your project:
   ```bash
   supabase link --project-ref your-project-id
   ```

4. Set secrets (see [Replicate](#replicate-api-setup) and [Remove.bg](#removebg-api-setup) first):
   ```bash
   supabase secrets set REPLICATE_API_TOKEN=r8_xxxxxxxxxxxxx
   supabase secrets set REMOVE_BG_API_KEY=xxxxxxxxxxxxx
   ```

5. Deploy all functions:
   ```bash
   supabase functions deploy ai-photo-enhance
   supabase functions deploy background-removal
   supabase functions deploy image-upscaling
   supabase functions deploy image-expansion
   supabase functions deploy outfit-change
   ```

---

## Replicate API Setup

### 1. Create Replicate Account

1. Go to [https://replicate.com](https://replicate.com)
2. Sign up with GitHub or email
3. Verify your email

### 2. Get API Token

1. Navigate to **Account** → **API Tokens**
2. Click "Create token"
3. Copy your token: `r8_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`

### 3. Add Billing (Required for Production)

1. Navigate to **Billing**
2. Add payment method
3. **Pricing**: Pay-per-use
   - FLUX.1 Schnell: ~$0.003 per generation (~333 generations per $1)
   - Real-ESRGAN (4K upscaling): ~$0.02 per upscale (~50 upscales per $1)
   - Background removal: ~$0.01 per image (~100 images per $1)

### 4. Find Model Versions

Get the latest model versions from Replicate:

- **FLUX.1 Schnell** (Fast AI generation):
  ```
  black-forest-labs/flux-schnell
  ```

- **Real-ESRGAN** (4K upscaling):
  ```
  nightmareai/real-esrgan:42fed1c4974146d4d2414e2be2c5277c7fcf05fcc3a73abf41610695738c1d7b
  ```

- **Background Removal**:
  ```
  lucataco/remove-bg:95fcc2a26d3899cd6c2691c900465aaeff466285a65c14638cc5f36f34befaf1
  ```

### 5. Test API

```bash
curl -X POST https://api.replicate.com/v1/predictions \
  -H "Authorization: Token r8_your_token_here" \
  -H "Content-Type: application/json" \
  -d '{
    "version": "black-forest-labs/flux-schnell",
    "input": {
      "prompt": "professional headshot of a person in business attire"
    }
  }'
```

---

## Remove.bg API Setup

### 1. Create Account

1. Go to [https://www.remove.bg/api](https://www.remove.bg/api)
2. Sign up for an account
3. Verify your email

### 2. Get API Key

1. Navigate to **Dashboard** → **API Key**
2. Copy your API key: `xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`

### 3. Choose Plan

**Free Tier** (Good for testing):
- 50 API calls/month
- Preview quality (0.25 megapixels)
- Good for development

**Subscription Plans** (For production):
- **Starter**: $9/month - 500 images
- **Pro**: $29/month - 2,000 images
- **Business**: Custom pricing

### 4. Test API

```bash
curl -X POST https://api.remove.bg/v1.0/removebg \
  -H "X-Api-Key: your_api_key_here" \
  -F "image_url=https://example.com/photo.jpg" \
  -F "size=auto"
```

### Alternative: Use Replicate for Background Removal

If you want to avoid Remove.bg costs, you can use Replicate's background removal model instead:

```typescript
// In background-removal edge function
const prediction = await replicate.predictions.create({
  version: "lucataco/remove-bg:95fcc2a26d3899cd6c2691c900465aaeff466285a65c14638cc5f36f34befaf1",
  input: {
    image: imageBase64
  }
});
```

---

## RevenueCat Setup

### 1. Create RevenueCat Account

1. Go to [https://app.revenuecat.com](https://app.revenuecat.com)
2. Sign up for free account
3. Create new project: "AI Photo Studio Pro"

### 2. Configure App

**iOS Setup**:
1. Navigate to **Apps** → **Add App**
2. Select **iOS**
3. Enter Bundle ID: `com.yourcompany.aiphotostudiopro`
4. Upload App Store Connect API Key (from Apple Developer)

**Android Setup**:
1. Navigate to **Apps** → **Add App**
2. Select **Android**
3. Enter Package Name: `com.yourcompany.aiphotostudiopro`
4. Upload Google Service Account JSON (from Google Play Console)

### 3. Create Products

1. Navigate to **Products** → **Add Product**

**Monthly Subscription**:
- **Product ID**: `ai_photo_studio_pro_monthly`
- **Type**: Subscription
- **Duration**: 1 month
- **Price**: $9.99
- **Store Product IDs**:
  - iOS: `monthly_999` (create in App Store Connect)
  - Android: `monthly_999` (create in Google Play Console)

**Yearly Subscription**:
- **Product ID**: `ai_photo_studio_pro_yearly`
- **Type**: Subscription
- **Duration**: 1 year
- **Price**: $49.99
- **Store Product IDs**:
  - iOS: `yearly_4999`
  - Android: `yearly_4999`

**Lifetime Purchase**:
- **Product ID**: `ai_photo_studio_pro_lifetime`
- **Type**: Non-consumable
- **Price**: $99.99
- **Store Product IDs**:
  - iOS: `lifetime_9999`
  - Android: `lifetime_9999`

### 4. Create Entitlements

1. Navigate to **Entitlements** → **Add Entitlement**
2. Create entitlement:
   - **Identifier**: `pro`
   - **Attached Products**: All 3 products above

### 5. Get API Keys

1. Navigate to **API Keys**
2. Copy:
   - **Public App-specific API Key**: `appl_xxxxx` (iOS)
   - **Public App-specific API Key**: `goog_xxxxx` (Android)

---

## Environment Variables

### Flutter App (.env)

Create `.env` file in project root:

```env
# Supabase
SUPABASE_URL=https://xxxxxxxxxxxxx.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...

# RevenueCat
REVENUECAT_APPLE_API_KEY=appl_xxxxxxxxxxxxx
REVENUECAT_GOOGLE_API_KEY=goog_xxxxxxxxxxxxx

# Product IDs
PRODUCT_ID_MONTHLY=ai_photo_studio_pro_monthly
PRODUCT_ID_YEARLY=ai_photo_studio_pro_yearly
PRODUCT_ID_LIFETIME=ai_photo_studio_pro_lifetime
ENTITLEMENT_ID_PRO=pro

# Feature Flags
ENABLE_AI_RETOUCH=true
ENABLE_BACKGROUND_EDITING=true
ENABLE_OUTFIT_CUSTOMIZATION=true
ENABLE_ASPECT_EXPANSION=true
ENABLE_4K_UPSCALING=true
ENABLE_BATCH_GENERATION=true
```

### Supabase Edge Functions

Set secrets using Supabase CLI:

```bash
# Replicate API
supabase secrets set REPLICATE_API_TOKEN=r8_xxxxxxxxxxxxx

# Remove.bg API (optional)
supabase secrets set REMOVE_BG_API_KEY=xxxxxxxxxxxxx

# Model versions
supabase secrets set FLUX_MODEL_VERSION=black-forest-labs/flux-schnell
supabase secrets set REAL_ESRGAN_MODEL_VERSION=nightmareai/real-esrgan:42fed1c4974146d4d2414e2be2c5277c7fcf05fcc3a73abf41610695738c1d7b
```

---

## Testing Configuration

### 1. Test Supabase Connection

```dart
// In your Flutter app
import 'package:supabase_flutter/supabase_flutter.dart';

void testSupabaseConnection() async {
  try {
    final response = await Supabase.instance.client
        .from('batch_generation_jobs')
        .select()
        .limit(1);
    print('Supabase connected: ${response}');
  } catch (e) {
    print('Supabase error: $e');
  }
}
```

### 2. Test Edge Functions

```bash
# Test AI photo enhance
curl -X POST 'https://your-project.supabase.co/functions/v1/ai-photo-enhance' \
  -H 'Authorization: Bearer YOUR_ANON_KEY' \
  -H 'Content-Type: application/json' \
  -d '{
    "action": "retouch",
    "image": "base64_image_data_here",
    "settings": {
      "preset": "professional"
    }
  }'
```

### 3. Test RevenueCat

```dart
// In your Flutter app
import 'package:purchases_flutter/purchases_flutter.dart';

void testRevenueCat() async {
  try {
    await Purchases.configure(
      PurchasesConfiguration('your_api_key_here')
    );
    final customerInfo = await Purchases.getCustomerInfo();
    print('RevenueCat configured: ${customerInfo.activeSubscriptions}');
  } catch (e) {
    print('RevenueCat error: $e');
  }
}
```

---

## Cost Estimates

### Development Phase
- **Supabase**: Free (stays within free tier limits)
- **Replicate**: ~$10-20/month (for testing ~1,000 generations)
- **Remove.bg**: Free (50 images/month)
- **RevenueCat**: Free (up to $10k MRR)
- **Total**: ~$10-20/month

### Production (1,000 active users)
Assumptions:
- Average 10 generations per user/month = 10,000 generations
- 20% use retouch = 2,000 retouches
- 10% use background removal = 1,000 removals
- 5% use 4K upscaling = 500 upscales

**Costs**:
- **Supabase**: Free tier or ~$25/month (Pro plan)
- **Replicate**:
  - Generations: 10,000 × $0.003 = $30
  - Retouch: 2,000 × $0.003 = $6
  - Background removal: 1,000 × $0.01 = $10
  - 4K upscaling: 500 × $0.02 = $10
  - **Total**: ~$56/month
- **Remove.bg**: Pro plan $29/month (if using instead of Replicate)
- **RevenueCat**: Free (under $10k MRR)
- **Storage (AWS S3 or similar)**: ~$5-10/month
- **Total Monthly Cost**: ~$90-100/month

**Revenue** (assuming 5% conversion to $9.99/month):
- 1,000 users × 5% × $9.99 = $499.50/month
- **Profit**: ~$400/month

### Scaling (10,000 active users)
- **Costs**: ~$900/month
- **Revenue** (5% conversion): ~$5,000/month
- **Profit**: ~$4,100/month

---

## Troubleshooting

### Supabase Issues

**Error: "Invalid API key"**
- Verify you're using the correct anon key
- Check if key has been regenerated in dashboard
- Ensure no extra spaces in .env file

**Error: "Row Level Security policy violation"**
- Verify user is authenticated
- Check RLS policies are created
- Test with service_role key (only in Edge Functions!)

### Replicate Issues

**Error: "Insufficient credits"**
- Add billing information in Replicate dashboard
- Check account balance
- Consider using free tier models for development

**Error: "Model not found"**
- Verify model version is correct
- Check if model is still available (some may be deprecated)
- Use latest version from Replicate website

### Remove.bg Issues

**Error: "API limit exceeded"**
- Check monthly usage in dashboard
- Upgrade plan or switch to Replicate alternative
- Implement client-side rate limiting

**Error: "Invalid image format"**
- Ensure image is JPG or PNG
- Check image size (max 12 MB for free tier)
- Verify image is not corrupted

### RevenueCat Issues

**Error: "Invalid API key"**
- Use app-specific key (appl_ or goog_), not account key
- Verify key matches platform (iOS vs Android)
- Check key is not expired

**Error: "Product not found"**
- Verify product IDs match in RevenueCat and stores
- Check products are approved in App Store/Play Store
- Wait 24 hours after creating products

---

## Security Best Practices

1. **Never commit API keys to git**
   - Add `.env` to `.gitignore`
   - Use environment variables
   - Rotate keys if accidentally exposed

2. **Use Row Level Security**
   - Enable RLS on all Supabase tables
   - Test policies thoroughly
   - Use service_role key only in Edge Functions

3. **Validate all inputs**
   - Check file sizes before upload
   - Validate image formats
   - Sanitize user inputs

4. **Monitor API usage**
   - Set up billing alerts in Replicate
   - Monitor Supabase dashboard for anomalies
   - Track costs per user

5. **Rate limiting**
   - Implement client-side rate limiting
   - Use Supabase Edge Functions for server-side limiting
   - Set maximum requests per user

---

## Next Steps

1. ✅ Set up all API accounts
2. ✅ Configure environment variables
3. ✅ Deploy Edge Functions
4. ✅ Test all integrations
5. ✅ Set up monitoring and alerts
6. ✅ Configure billing limits
7. ✅ Create production environment
8. ✅ Deploy to App Store and Play Store

For deployment instructions, see [DEPLOYMENT.md](./DEPLOYMENT.md).
