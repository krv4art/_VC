# Supabase Edge Functions - Deployment Guide

This document provides implementation guides for all Supabase Edge Functions required by AI Photo Studio Pro.

## Overview

AI Photo Studio Pro requires 5 Supabase Edge Functions to power its AI features:

1. **ai-photo-enhance** - AI retouch and portrait enhancement
2. **background-removal** - Background removal and replacement
3. **image-upscaling** - 4K image upscaling
4. **image-expansion** - Aspect ratio expansion/outpainting
5. **outfit-change** - AI outfit/clothing modification

---

## Prerequisites

- Supabase project created
- Supabase CLI installed (`npm install -g supabase`)
- API keys for AI services:
  - Replicate API key (for FLUX.1 and other models)
  - Remove.bg API key (optional, for background removal)
  - DeepAI API key (optional, for upscaling fallback)

---

## 1. AI Photo Enhance Function

**Path:** `supabase/functions/ai-photo-enhance/index.ts`

### Purpose
Applies AI-powered retouching to portrait photos including:
- Blemish removal
- Skin smoothing
- Lighting enhancement
- Color correction
- Eye and teeth enhancement

### Implementation

```typescript
import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const REPLICATE_API_TOKEN = Deno.env.get('REPLICATE_API_TOKEN')!

serve(async (req) => {
  try {
    const { action, image, settings, job_id } = await req.json()

    // Check status
    if (action === 'check_status') {
      const status = await checkReplicateJob(job_id)
      return new Response(JSON.stringify(status), {
        headers: { 'Content-Type': 'application/json' },
      })
    }

    // Start retouching
    if (action === 'retouch') {
      // Build prompt based on settings
      const prompt = buildRetouchPrompt(settings)

      // Call Replicate API
      const response = await fetch('https://api.replicate.com/v1/predictions', {
        method: 'POST',
        headers: {
          'Authorization': `Token ${REPLICATE_API_TOKEN}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          version: 'MODEL_VERSION_HERE', // Use appropriate model
          input: {
            image: `data:image/jpeg;base64,${image}`,
            prompt,
            ...settings,
          },
        }),
      })

      const result = await response.json()
      return new Response(JSON.stringify({ job_id: result.id }), {
        headers: { 'Content-Type': 'application/json' },
      })
    }

    throw new Error('Invalid action')
  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), {
      status: 400,
      headers: { 'Content-Type': 'application/json' },
    })
  }
})

function buildRetouchPrompt(settings: any): string {
  let prompt = 'professional portrait retouching, '

  if (settings.remove_blemishes) prompt += 'remove blemishes and imperfections, '
  if (settings.smooth_skin) prompt += 'smooth skin with natural texture, '
  if (settings.enhance_lighting) prompt += 'perfect studio lighting, '
  if (settings.color_correction) prompt += 'color correction, '
  if (settings.enhance_eyes) prompt += 'bright expressive eyes, '
  if (settings.whiten_teeth) prompt += 'white teeth, '

  prompt += 'high quality, detailed, professional'
  return prompt
}

async function checkReplicateJob(jobId: string) {
  const response = await fetch(`https://api.replicate.com/v1/predictions/${jobId}`, {
    headers: {
      'Authorization': `Token ${REPLICATE_API_TOKEN}`,
    },
  })

  const result = await response.json()

  return {
    status: result.status,
    url: result.output?.[0],
    error: result.error,
  }
}
```

### Deploy Command
```bash
supabase functions deploy ai-photo-enhance --no-verify-jwt
```

---

## 2. Background Removal Function

**Path:** `supabase/functions/background-removal/index.ts`

### Purpose
Removes and replaces backgrounds using AI.

### Implementation

```typescript
import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'

const REMOVEBG_API_KEY = Deno.env.get('REMOVEBG_API_KEY')!
const REPLICATE_API_TOKEN = Deno.env.get('REPLICATE_API_TOKEN')!

serve(async (req) => {
  try {
    const { action, image, background_type, background_data, background_color, blur_amount, job_id } = await req.json()

    if (action === 'check_status') {
      const status = await checkReplicateJob(job_id)
      return new Response(JSON.stringify(status), {
        headers: { 'Content-Type': 'application/json' },
      })
    }

    if (action === 'remove') {
      // Use Remove.bg API
      const formData = new FormData()
      formData.append('image_file_b64', image)
      formData.append('size', 'full')

      const response = await fetch('https://api.remove.bg/v1.0/removebg', {
        method: 'POST',
        headers: {
          'X-Api-Key': REMOVEBG_API_KEY,
        },
        body: formData,
      })

      const resultBlob = await response.blob()
      const base64 = await blobToBase64(resultBlob)

      return new Response(JSON.stringify({ url: base64 }), {
        headers: { 'Content-Type': 'application/json' },
      })
    }

    if (action === 'replace') {
      // Use Replicate for background replacement
      const response = await fetch('https://api.replicate.com/v1/predictions', {
        method: 'POST',
        headers: {
          'Authorization': `Token ${REPLICATE_API_TOKEN}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          version: 'BACKGROUND_MODEL_VERSION',
          input: {
            image: `data:image/jpeg;base64,${image}`,
            background_type,
            background: background_data,
            color: background_color,
            blur: blur_amount,
          },
        }),
      })

      const result = await response.json()
      return new Response(JSON.stringify({ job_id: result.id }), {
        headers: { 'Content-Type': 'application/json' },
      })
    }

    throw new Error('Invalid action')
  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), {
      status: 400,
      headers: { 'Content-Type': 'application/json' },
    })
  }
})

async function blobToBase64(blob: Blob): Promise<string> {
  const buffer = await blob.arrayBuffer()
  const base64 = btoa(String.fromCharCode(...new Uint8Array(buffer)))
  return `data:image/png;base64,${base64}`
}

async function checkReplicateJob(jobId: string) {
  // Same as ai-photo-enhance
}
```

### Deploy Command
```bash
supabase functions deploy background-removal --no-verify-jwt
```

---

## 3. Image Upscaling Function

**Path:** `supabase/functions/image-upscaling/index.ts`

### Purpose
Upscales images to 4K resolution using AI.

### Implementation

```typescript
import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'

const REPLICATE_API_TOKEN = Deno.env.get('REPLICATE_API_TOKEN')!

serve(async (req) => {
  try {
    const { action, image, scale_factor, quality, job_id } = await req.json()

    if (action === 'check_status') {
      const status = await checkReplicateJob(job_id)
      return new Response(JSON.stringify(status), {
        headers: { 'Content-Type': 'application/json' },
      })
    }

    if (action === 'upscale' || action === 'enhance') {
      // Use Real-ESRGAN or similar model
      const response = await fetch('https://api.replicate.com/v1/predictions', {
        method: 'POST',
        headers: {
          'Authorization': `Token ${REPLICATE_API_TOKEN}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          version: 'nightmareai/real-esrgan:MODEL_VERSION',
          input: {
            image: `data:image/jpeg;base64,${image}`,
            scale: scale_factor || 4,
            face_enhance: action === 'enhance',
          },
        }),
      })

      const result = await response.json()
      return new Response(JSON.stringify({ job_id: result.id }), {
        headers: { 'Content-Type': 'application/json' },
      })
    }

    throw new Error('Invalid action')
  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), {
      status: 400,
      headers: { 'Content-Type': 'application/json' },
    })
  }
})

async function checkReplicateJob(jobId: string) {
  // Same as previous
}
```

### Deploy Command
```bash
supabase functions deploy image-upscaling --no-verify-jwt
```

---

## 4. Image Expansion Function

**Path:** `supabase/functions/image-expansion/index.ts`

### Purpose
Expands images to different aspect ratios using AI outpainting.

### Implementation

```typescript
import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'

const REPLICATE_API_TOKEN = Deno.env.get('REPLICATE_API_TOKEN')!

serve(async (req) => {
  try {
    const { action, image, target_ratio, direction, job_id } = await req.json()

    if (action === 'check_status') {
      const status = await checkReplicateJob(job_id)
      return new Response(JSON.stringify(status), {
        headers: { 'Content-Type': 'application/json' },
      })
    }

    if (action === 'expand') {
      const { width, height } = getTargetDimensions(target_ratio)

      const response = await fetch('https://api.replicate.com/v1/predictions', {
        method: 'POST',
        headers: {
          'Authorization': `Token ${REPLICATE_API_TOKEN}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          version: 'stability-ai/stable-diffusion-inpainting:MODEL_VERSION',
          input: {
            image: `data:image/jpeg;base64,${image}`,
            width,
            height,
            prompt: 'seamless professional background extension, consistent style',
          },
        }),
      })

      const result = await response.json()
      return new Response(JSON.stringify({ job_id: result.id }), {
        headers: { 'Content-Type': 'application/json' },
      })
    }

    throw new Error('Invalid action')
  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), {
      status: 400,
      headers: { 'Content-Type': 'application/json' },
    })
  }
})

function getTargetDimensions(ratio: string): { width: number; height: number } {
  const dimensions = {
    ratio1x1: { width: 1080, height: 1080 },
    ratio4x5: { width: 1080, height: 1350 },
    ratio9x16: { width: 1080, height: 1920 },
    ratio16x9: { width: 1920, height: 1080 },
    linkedInBanner: { width: 1584, height: 396 },
  }
  return dimensions[ratio] || dimensions.ratio1x1
}

async function checkReplicateJob(jobId: string) {
  // Same as previous
}
```

### Deploy Command
```bash
supabase functions deploy image-expansion --no-verify-jwt
```

---

## 5. Outfit Change Function

**Path:** `supabase/functions/outfit-change/index.ts`

### Purpose
Changes clothing/outfits on photos using AI.

### Implementation

```typescript
import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'

const REPLICATE_API_TOKEN = Deno.env.get('REPLICATE_API_TOKEN')!

serve(async (req) => {
  try {
    const { action, image, outfit_type, custom_prompt, job_id } = await req.json()

    if (action === 'check_status') {
      const status = await checkReplicateJob(job_id)
      return new Response(JSON.stringify(status), {
        headers: { 'Content-Type': 'application/json' },
      })
    }

    if (action === 'change_outfit') {
      const prompt = custom_prompt || getOutfitPrompt(outfit_type)

      const response = await fetch('https://api.replicate.com/v1/predictions', {
        method: 'POST',
        headers: {
          'Authorization': `Token ${REPLICATE_API_TOKEN}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          version: 'stability-ai/sdxl:MODEL_VERSION',
          input: {
            image: `data:image/jpeg;base64,${image}`,
            prompt: `person wearing ${prompt}, professional photo, same face, same person`,
            negative_prompt: 'different person, different face, low quality',
            num_inference_steps: 50,
          },
        }),
      })

      const result = await response.json()
      return new Response(JSON.stringify({ job_id: result.id }), {
        headers: { 'Content-Type': 'application/json' },
      })
    }

    throw new Error('Invalid action')
  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), {
      status: 400,
      headers: { 'Content-Type': 'application/json' },
    })
  }
})

function getOutfitPrompt(outfitType: string): string {
  const prompts = {
    businessSuitMale: 'professional dark blue business suit with tie',
    businessSuitFemale: 'professional business suit jacket',
    medicalScrubs: 'medical scrubs, healthcare professional',
    labCoat: 'white lab coat, doctor',
    casualShirt: 'smart casual button-up shirt',
    polo: 'polo shirt, business casual',
    sweater: 'professional sweater',
    blazer: 'smart blazer jacket',
    formalDress: 'professional formal dress',
    turtleneck: 'elegant turtleneck',
  }
  return prompts[outfitType] || prompts.businessSuitMale
}

async function checkReplicateJob(jobId: string) {
  // Same as previous
}
```

### Deploy Command
```bash
supabase functions deploy outfit-change --no-verify-jwt
```

---

## Environment Variables

Set the following secrets in your Supabase project:

```bash
# Replicate (required)
supabase secrets set REPLICATE_API_TOKEN=your_token_here

# Remove.bg (optional)
supabase secrets set REMOVEBG_API_KEY=your_key_here

# DeepAI (optional)
supabase secrets set DEEPAI_API_KEY=your_key_here
```

---

## Testing

Test each function using curl:

```bash
# Test AI Photo Enhance
curl -X POST 'https://YOUR_PROJECT.supabase.co/functions/v1/ai-photo-enhance' \
  -H 'Content-Type: application/json' \
  -d '{
    "action": "retouch",
    "image": "BASE64_IMAGE_HERE",
    "settings": {
      "remove_blemishes": true,
      "smooth_skin": true,
      "smoothness_level": 0.7
    }
  }'

# Check job status
curl -X POST 'https://YOUR_PROJECT.supabase.co/functions/v1/ai-photo-enhance' \
  -H 'Content-Type: application/json' \
  -d '{
    "action": "check_status",
    "job_id": "JOB_ID_HERE"
  }'
```

---

## Cost Optimization

1. **Caching**: Cache frequent requests (same photo + same settings)
2. **Rate Limiting**: Implement rate limits per user
3. **Queue System**: Use Supabase Realtime for job queue
4. **Compression**: Compress images before sending to API
5. **Model Selection**: Use faster/cheaper models when appropriate

---

## Monitoring

Monitor function performance in Supabase Dashboard:
- Functions → Logs
- Check error rates
- Monitor execution time
- Track API costs

---

## Alternative Providers

If Replicate is too expensive, consider:

1. **Stability AI** - Direct API access
2. **Together.ai** - Cheaper inference
3. **RunPod** - Custom model hosting
4. **Hugging Face** - Inference API
5. **Self-hosted** - Most control, highest setup cost

---

## Next Steps

1. Create Supabase project
2. Deploy all 5 functions
3. Set environment variables
4. Test each endpoint
5. Update Flutter app with your Supabase URL
6. Monitor costs and performance

---

For issues or questions, check the Supabase documentation:
https://supabase.com/docs/guides/functions
