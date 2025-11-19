# AI Photo Studio Pro

Professional AI Headshot Generator powered by FLUX.1 with Advanced AI Features

## 🚀 Features

### Core Features
- **AI Headshot Generation** - Create professional headshots using FLUX.1 AI
- **Style Catalog** - Browse and select from various professional styles
- **Camera Integration** - Take photos with front/back camera support
- **Gallery** - View and manage your generated photos
- **RevenueCat Integration** - Premium subscriptions and in-app purchases
- **Multi-language** - Supports English, Russian, Ukrainian

### 🆕 Advanced AI Features (2025)
- **AI Portrait Retouch** - Professional retouching with 3 presets (Natural, Professional, Glamour)
  - Automatic blemish removal
  - Skin smoothing with texture preservation
  - Lighting and color correction
  - Eye and teeth enhancement

- **Background Editing** - Complete background control
  - AI background removal (transparent PNG)
  - 8 professional background presets
  - Custom background upload
  - Blur/bokeh effect

- **Batch Generation** - Enterprise-ready bulk processing
  - Multiple photo upload (8-15 images)
  - Up to 20 variations per photo
  - Automatic retouch and background processing
  - Real-time progress tracking

- **4K Upscaling** - Professional quality enhancement
  - Upscale to 3840x2160 resolution
  - 3 quality modes (Standard, High, Ultra)
  - AI detail enhancement

- **Aspect Ratio Expansion** - Platform optimization
  - 5 aspect ratios (Square, Instagram, Stories, YouTube, LinkedIn)
  - AI-powered outpainting
  - Seamless background extension

- **Outfit Customization** - Professional wardrobe changes
  - 10 outfit types (business suits, medical scrubs, casual, etc.)
  - Profession-specific presets (doctor, lawyer, executive)
  - Custom outfit prompts

## 🏗️ Tech Stack

- **Flutter** - Cross-platform mobile development
- **Provider** - State management
- **GoRouter** - Navigation
- **Supabase** - Backend & API proxy
- **RevenueCat** - Monetization
- **Replicate FLUX.1** - AI image generation
- **Replicate AI Models** - Retouch, background removal, upscaling, outfit change
- **SQLite** - Local database
- **Remove.bg API** - Background removal (optional)

## 📚 Documentation

- [MARKET_RESEARCH.md](MARKET_RESEARCH.md) - Comprehensive market analysis and competitor research
- [SUPABASE_FUNCTIONS.md](SUPABASE_FUNCTIONS.md) - Supabase Edge Functions implementation guide
- [DEPLOYMENT.md](DEPLOYMENT.md) - Deployment instructions (coming soon)

## 📱 Supported Platforms

- iOS
- Android

## 🎨 Design System

Professional studio theme with blue/purple color palette, clean typography (Lora + Open Sans), and smooth animations.

## 🔑 Environment Setup

Create `.env` file with:
```
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key
REVENUECAT_API_KEY=your_revenuecat_key
```

## 🚀 Getting Started

1. **Install dependencies**
   ```bash
   flutter pub get
   ```

2. **Deploy Supabase Edge Functions**
   ```bash
   cd supabase/functions
   supabase functions deploy ai-photo-enhance
   supabase functions deploy background-removal
   supabase functions deploy image-upscaling
   supabase functions deploy image-expansion
   supabase functions deploy outfit-change
   ```
   See [SUPABASE_FUNCTIONS.md](SUPABASE_FUNCTIONS.md) for detailed implementation.

3. **Set Supabase secrets**
   ```bash
   supabase secrets set REPLICATE_API_TOKEN=your_token
   supabase secrets set REMOVEBG_API_KEY=your_key
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## 🎯 Key Screens

- **Homepage** - Main dashboard with quick actions
- **Advanced Photo Editor** - Full AI editing suite with 5 tabs
- **Batch Generation** - Bulk photo processing interface
- **Gallery** - View and manage generated photos
- **Styles Catalog** - Browse professional styles
- **Profile** - Account settings and subscription management

## 💰 Monetization

### Tier 1: Basic - $9.99/month
- 10 generations/month
- Basic AI retouch
- Standard resolution
- 5 background presets

### Tier 2: Pro - $29.99/month
- 100 generations/month
- Advanced AI retouch
- 4K resolution
- All backgrounds and outfits
- Batch processing (5 photos)
- Priority processing

### Tier 3: Enterprise - From $99/month
- Unlimited generations
- Team dashboard
- Bulk processing
- API access
- Custom branding

See [MARKET_RESEARCH.md](MARKET_RESEARCH.md) for detailed market analysis and pricing strategy.

## 📄 License

Proprietary - All rights reserved
