# Supabase Edge Functions for AI PDF Scanner

This directory contains Supabase Edge Functions that provide secure AI processing capabilities for the AI PDF Scanner app.

## Functions

### ai-process

Secure proxy to Google Gemini API for AI-powered document analysis.

**Features:**
- Image analysis and OCR
- Document classification
- Key information extraction
- Text translation
- Privacy scanning

## Prerequisites

1. Supabase CLI installed: `npm install -g supabase`
2. Google Gemini API key: Get from [Google AI Studio](https://makersuite.google.com/app/apikey)
3. Supabase project initialized: `supabase init`

## Deployment

### 1. Set up environment variables

```bash
# Set the GEMINI_API_KEY secret in your Supabase project
supabase secrets set GEMINI_API_KEY=your_gemini_api_key_here
```

### 2. Deploy the function

```bash
# Deploy from project root
supabase functions deploy ai-process

# Or deploy with verification
supabase functions deploy ai-process --verify-jwt false
```

### 3. Verify deployment

```bash
# List all deployed functions
supabase functions list

# Test the function
supabase functions invoke ai-process --body '{"type":"translate","text":"Hello","target_language":"Russian"}'
```

## Local Development

### Run function locally

```bash
# Start local Supabase (includes Edge Functions runtime)
supabase start

# Serve the function locally
supabase functions serve ai-process

# Or serve with environment variable
supabase functions serve ai-process --env-file ./supabase/.env.local
```

### Test locally

```bash
curl -i --location --request POST 'http://localhost:54321/functions/v1/ai-process' \
  --header 'Authorization: Bearer YOUR_ANON_KEY' \
  --header 'Content-Type: application/json' \
  --data '{"type":"translate","text":"Hello world","target_language":"Russian"}'
```

## Environment Variables

Required secrets:
- `GEMINI_API_KEY`: Your Google Gemini API key

## API Usage

### Analyze Image

```json
{
  "type": "analyze_image",
  "image": "base64_encoded_image_data",
  "prompt": "Extract all text from this document",
  "temperature": 0.4
}
```

### Translate Text

```json
{
  "type": "translate",
  "text": "Hello world",
  "target_language": "Russian"
}
```

## Security Notes

- Never expose your GEMINI_API_KEY in client code
- Always use Supabase Edge Functions as a secure proxy
- The function validates requests and handles errors safely
- CORS is configured for web client access

## Troubleshooting

### Function deployment fails
- Ensure Supabase CLI is up to date: `npm install -g supabase@latest`
- Check your Supabase project is linked: `supabase link`

### API key not working
- Verify the secret is set: `supabase secrets list`
- Ensure the API key is valid in Google AI Studio

### CORS errors
- Check CORS headers in the function code
- Verify your app's domain is allowed

## Cost Considerations

- Gemini 2.0 Flash pricing: Check [Google AI pricing](https://ai.google.dev/pricing)
- Supabase Edge Functions: Check [Supabase pricing](https://supabase.com/pricing)
- Consider rate limiting for production use

## Resources

- [Supabase Edge Functions Docs](https://supabase.com/docs/guides/functions)
- [Google Gemini API Docs](https://ai.google.dev/docs)
- [Deno Deploy Docs](https://deno.com/deploy/docs)
