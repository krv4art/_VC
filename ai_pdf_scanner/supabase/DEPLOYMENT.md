# AI PDF Scanner - Supabase Deployment Guide

This guide explains how to deploy the backend infrastructure for AI PDF Scanner.

## Prerequisites

1. Supabase account (https://supabase.com)
2. Supabase CLI installed (`npm install -g supabase`)
3. Google AI Studio API key for Gemini (https://makersuite.google.com/app/apikey)

## Step 1: Initialize Supabase Project

```bash
# Login to Supabase
supabase login

# Link to your project
supabase link --project-ref YOUR_PROJECT_REF

# You can find YOUR_PROJECT_REF in your Supabase dashboard URL
# Example: https://supabase.com/dashboard/project/YOUR_PROJECT_REF
```

## Step 2: Set Environment Variables

### For Edge Functions

```bash
# Set Gemini API Key
supabase secrets set GEMINI_API_KEY=your_gemini_api_key_here

# Verify secrets
supabase secrets list
```

## Step 3: Deploy Edge Functions

### Deploy AI Processing Function

```bash
# Navigate to project root
cd ai_pdf_scanner

# Deploy the function
supabase functions deploy ai-process

# Test the function (optional)
supabase functions serve ai-process
```

### Test Edge Function Locally

```bash
# Start local development
supabase start

# Serve function locally
supabase functions serve ai-process --env-file ./supabase/.env.local

# In another terminal, test the function
curl -i --location --request POST 'http://localhost:54321/functions/v1/ai-process' \
  --header 'Authorization: Bearer YOUR_ANON_KEY' \
  --header 'Content-Type: application/json' \
  --data '{"type":"translate","text":"Hello world","target_language":"Russian"}'
```

## Step 4: Configure Storage Buckets

Create storage buckets for PDF files and thumbnails:

```sql
-- Run this in Supabase SQL Editor

-- Create pdf-documents bucket
INSERT INTO storage.buckets (id, name, public)
VALUES ('pdf-documents', 'pdf-documents', false);

-- Create pdf-thumbnails bucket
INSERT INTO storage.buckets (id, name, public)
VALUES ('pdf-thumbnails', 'pdf-thumbnails', true);

-- Set up RLS policies for pdf-documents (read/write for all)
CREATE POLICY "Allow public read access"
ON storage.objects FOR SELECT
USING (bucket_id = 'pdf-documents');

CREATE POLICY "Allow public insert access"
ON storage.objects FOR INSERT
WITH CHECK (bucket_id = 'pdf-documents');

CREATE POLICY "Allow public update access"
ON storage.objects FOR UPDATE
USING (bucket_id = 'pdf-documents');

CREATE POLICY "Allow public delete access"
ON storage.objects FOR DELETE
USING (bucket_id = 'pdf-documents');

-- Set up RLS policies for pdf-thumbnails (read/write for all)
CREATE POLICY "Allow public read access"
ON storage.objects FOR SELECT
USING (bucket_id = 'pdf-thumbnails');

CREATE POLICY "Allow public insert access"
ON storage.objects FOR INSERT
WITH CHECK (bucket_id = 'pdf-thumbnails');

CREATE POLICY "Allow public update access"
ON storage.objects FOR UPDATE
USING (bucket_id = 'pdf-thumbnails');

CREATE POLICY "Allow public delete access"
ON storage.objects FOR DELETE
USING (bucket_id = 'pdf-thumbnails');
```

## Step 5: (Optional) Set up Database Tables for Cloud Sync

If you want to sync documents to the cloud:

```sql
-- Create documents_sync table
CREATE TABLE documents_sync (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  device_id TEXT NOT NULL,
  document_id TEXT NOT NULL,
  title TEXT NOT NULL,
  file_path TEXT NOT NULL,
  thumbnail_path TEXT,
  document_type TEXT NOT NULL,
  page_count INTEGER DEFAULT 1,
  file_size INTEGER NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  is_favorite BOOLEAN DEFAULT FALSE,
  tags TEXT[],
  ai_metadata JSONB
);

-- Create index
CREATE INDEX idx_documents_sync_device ON documents_sync(device_id);
CREATE INDEX idx_documents_sync_created ON documents_sync(created_at DESC);

-- Create ai_usage_stats table for tracking API usage
CREATE TABLE ai_usage_stats (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  device_id TEXT NOT NULL,
  operation_type TEXT NOT NULL,
  tokens_used INTEGER,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create index
CREATE INDEX idx_ai_usage_device ON ai_usage_stats(device_id);
CREATE INDEX idx_ai_usage_date ON ai_usage_stats(created_at DESC);

-- Enable RLS
ALTER TABLE documents_sync ENABLE ROW LEVEL SECURITY;
ALTER TABLE ai_usage_stats ENABLE ROW LEVEL SECURITY;

-- RLS Policies (allow all for now - adjust based on your auth requirements)
CREATE POLICY "Allow all operations on documents_sync"
ON documents_sync FOR ALL
USING (true)
WITH CHECK (true);

CREATE POLICY "Allow all operations on ai_usage_stats"
ON ai_usage_stats FOR ALL
USING (true)
WITH CHECK (true);
```

## Step 6: Update Flutter App Configuration

Update the API configuration in your Flutter app:

```dart
// lib/config/api_config.dart

class ApiConfig {
  static const String supabaseUrl = 'YOUR_SUPABASE_URL';
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';

  // These should match your deployed function
  static const String aiEndpoint = '$supabaseUrl/functions/v1/ai-process';

  static const String pdfStorageBucket = 'pdf-documents';
  static const String thumbnailStorageBucket = 'pdf-thumbnails';
}
```

## Step 7: Test the Integration

1. Run the Flutter app
2. Try scanning a document
3. Check Supabase logs for Edge Function calls:
   ```bash
   supabase functions logs ai-process
   ```

## Monitoring and Logs

### View Edge Function Logs
```bash
# Real-time logs
supabase functions logs ai-process --tail

# Recent logs
supabase functions logs ai-process
```

### View Database Logs
Check the Supabase dashboard > Logs section

## Cost Optimization

### Gemini API
- Use `gemini-1.5-flash` for cost-effective operations
- Implement rate limiting in the app
- Cache results when possible

### Supabase
- Monitor storage usage (Storage > Usage)
- Set up database backups
- Use Edge Functions sparingly (they have execution limits)

## Troubleshooting

### Edge Function Issues

1. **Function not found**
   ```bash
   supabase functions deploy ai-process
   ```

2. **CORS errors**
   - Check CORS headers in index.ts
   - Ensure OPTIONS method is handled

3. **API key not working**
   ```bash
   supabase secrets set GEMINI_API_KEY=your_new_key
   supabase functions deploy ai-process
   ```

### Storage Issues

1. **Upload failed**
   - Check bucket exists
   - Verify RLS policies
   - Check file size limits

2. **Access denied**
   - Update RLS policies
   - Check authentication

## Production Checklist

- [ ] Set GEMINI_API_KEY secret
- [ ] Deploy ai-process Edge Function
- [ ] Create storage buckets
- [ ] Set up RLS policies
- [ ] Test Edge Function with real requests
- [ ] Monitor API usage
- [ ] Set up error tracking
- [ ] Configure rate limiting
- [ ] Set up backups

## Security Best Practices

1. **Never expose API keys in client code**
   - Always use Edge Functions as proxy

2. **Implement rate limiting**
   - Limit requests per user/device

3. **Validate inputs**
   - Sanitize all user inputs

4. **Monitor usage**
   - Track API calls and costs

5. **Use RLS policies**
   - Secure database access

## Support

For issues:
- Supabase Docs: https://supabase.com/docs
- Gemini API Docs: https://ai.google.dev/docs
- GitHub Issues: [Your repo URL]
