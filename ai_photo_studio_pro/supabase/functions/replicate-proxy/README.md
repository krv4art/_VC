# Replicate Proxy Edge Function

This Supabase Edge Function acts as a secure proxy for the Replicate API, keeping your API key safe on the server side.

## Setup

1. Set the Replicate API key as a secret:
```bash
supabase secrets set REPLICATE_API_KEY=your_replicate_api_key_here
```

2. Deploy the function:
```bash
supabase functions deploy replicate-proxy
```

## Usage

### Generate Headshot

```typescript
const { data, error } = await supabase.functions.invoke('replicate-proxy', {
  body: {
    image: 'base64_encoded_image',
    prompt: 'professional business headshot, blue background',
    quality: 'high',
  }
})
```

### Check Status

```typescript
const { data, error } = await supabase.functions.invoke('replicate-proxy', {
  body: {
    action: 'check_status',
    job_id: 'prediction_id_here',
  }
})
```

### Cancel Job

```typescript
const { data, error } = await supabase.functions.invoke('replicate-proxy', {
  body: {
    action: 'cancel',
    job_id: 'prediction_id_here',
  }
})
```

## Models

- `black-forest-labs/flux-1-schnell` - Fast generation (default, ~1-2 seconds)
- `black-forest-labs/flux-pro` - Highest quality
- `black-forest-labs/flux-dev` - Development version

## Quality Settings

- `low` - 70% quality
- `medium` - 85% quality (default)
- `high` - 95% quality
