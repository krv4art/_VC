# Supabase Setup Guide for CV Engineer

## Overview
CV Engineer is configured to use Supabase for cloud storage and AI features. This document explains how to set up and configure Supabase for your deployment.

## Prerequisites
- Supabase account (https://supabase.com)
- Project created in Supabase dashboard

## Configuration

### 1. Environment Setup

The Supabase configuration is stored in `lib/utils/supabase_constants.dart`:

```dart
class SupabaseConfig {
  static const String supabaseUrl = 'YOUR_SUPABASE_URL';
  static const String supabaseAnonKey = 'YOUR_ANON_KEY';
}
```

**To configure:**
1. Go to your Supabase project settings
2. Copy the Project URL and paste into `supabaseUrl`
3. Copy the anon/public key and paste into `supabaseAnonKey`

### 2. Database Schema

#### Resumes Table
```sql
CREATE TABLE resumes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  template_id TEXT NOT NULL,
  personal_info JSONB NOT NULL,
  experiences JSONB DEFAULT '[]'::jsonb,
  educations JSONB DEFAULT '[]'::jsonb,
  skills JSONB DEFAULT '[]'::jsonb,
  languages JSONB DEFAULT '[]'::jsonb,
  custom_sections JSONB DEFAULT '[]'::jsonb,
  font_size DECIMAL DEFAULT 12.0,
  margin_size DECIMAL DEFAULT 20.0,
  font_family TEXT DEFAULT 'Roboto',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE resumes ENABLE ROW LEVEL SECURITY;

-- Policy: Users can only access their own resumes
CREATE POLICY "Users can view their own resumes"
  ON resumes FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own resumes"
  ON resumes FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own resumes"
  ON resumes FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own resumes"
  ON resumes FOR DELETE
  USING (auth.uid() = user_id);

-- Index for faster queries
CREATE INDEX idx_resumes_user_id ON resumes(user_id);
CREATE INDEX idx_resumes_updated_at ON resumes(updated_at DESC);
```

#### Cover Letters Table
```sql
CREATE TABLE cover_letters (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  resume_id UUID REFERENCES resumes(id) ON DELETE SET NULL,
  recipient_name TEXT,
  recipient_title TEXT,
  company_name TEXT,
  company_address TEXT,
  opening_paragraph TEXT,
  body_paragraphs JSONB DEFAULT '[]'::jsonb,
  closing_paragraph TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE cover_letters ENABLE ROW LEVEL SECURITY;

-- Policies (same pattern as resumes)
CREATE POLICY "Users can view their own cover letters"
  ON cover_letters FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own cover letters"
  ON cover_letters FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own cover letters"
  ON cover_letters FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own cover letters"
  ON cover_letters FOR DELETE
  USING (auth.uid() = user_id);
```

### 3. Storage Buckets

Create storage buckets for profile photos:

```sql
-- Create storage bucket for profile photos
INSERT INTO storage.buckets (id, name, public)
VALUES ('profile-photos', 'profile-photos', true);

-- Policy: Users can upload their own photos
CREATE POLICY "Users can upload profile photos"
  ON storage.objects FOR INSERT
  WITH CHECK (
    bucket_id = 'profile-photos' AND
    auth.uid()::text = (storage.foldername(name))[1]
  );

-- Policy: Anyone can view photos (public bucket)
CREATE POLICY "Public access to profile photos"
  ON storage.objects FOR SELECT
  USING (bucket_id = 'profile-photos');

-- Policy: Users can update their own photos
CREATE POLICY "Users can update their own photos"
  ON storage.objects FOR UPDATE
  USING (
    bucket_id = 'profile-photos' AND
    auth.uid()::text = (storage.foldername(name))[1]
  );

-- Policy: Users can delete their own photos
CREATE POLICY "Users can delete their own photos"
  ON storage.objects FOR DELETE
  USING (
    bucket_id = 'profile-photos' AND
    auth.uid()::text = (storage.foldername(name))[1]
  );
```

### 4. Edge Functions

#### AI Assistant Edge Function

Create a new Edge Function named `ai-assist`:

```typescript
// supabase/functions/ai-assist/index.ts
import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const openAIKey = Deno.env.get('OPENAI_API_KEY')

serve(async (req) => {
  try {
    const { action, text, context } = await req.json()

    let prompt = ''
    switch (action) {
      case 'improve_text':
        prompt = `Improve this professional text: "${text}"`
        break
      case 'generate_summary':
        prompt = `Generate a professional summary based on this information: ${text}`
        break
      case 'suggest_skills':
        prompt = `Suggest relevant skills for a ${text} position`
        break
      case 'fix_grammar':
        prompt = `Fix grammar and punctuation: "${text}"`
        break
      default:
        throw new Error('Unknown action')
    }

    const response = await fetch('https://api.openai.com/v1/chat/completions', {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${openAIKey}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        model: 'gpt-3.5-turbo',
        messages: [{ role: 'user', content: prompt }],
        temperature: 0.7,
        max_tokens: 500,
      }),
    })

    const data = await response.json()

    return new Response(
      JSON.stringify({ result: data.choices[0].message.content }),
      { headers: { 'Content-Type': 'application/json' } }
    )
  } catch (error) {
    return new Response(
      JSON.stringify({ error: error.message }),
      { status: 500, headers: { 'Content-Type': 'application/json' } }
    )
  }
})
```

**Deploy the function:**
```bash
supabase functions deploy ai-assist --no-verify-jwt
```

**Set the OpenAI API key:**
```bash
supabase secrets set OPENAI_API_KEY=your_openai_api_key
```

### 5. Authentication Setup

Enable authentication providers in Supabase dashboard:

1. Go to Authentication → Providers
2. Enable Email provider
3. (Optional) Enable Google/Apple/GitHub for social login
4. Configure email templates for verification/password reset

### 6. Realtime Setup (Optional)

Enable realtime for collaborative features:

```sql
-- Enable realtime for resumes table
ALTER PUBLICATION supabase_realtime ADD TABLE resumes;
```

## Implementation in Flutter

### Cloud Sync Service

Create `lib/services/cloud_sync_service.dart`:

```dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/resume.dart';

class CloudSyncService {
  final SupabaseClient _client = Supabase.instance.client;

  // Sync resume to cloud
  Future<void> syncResume(Resume resume) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    await _client.from('resumes').upsert({
      'id': resume.id,
      'user_id': user.id,
      'template_id': resume.templateId,
      'personal_info': resume.personalInfo.toJson(),
      'experiences': resume.experiences.map((e) => e.toJson()).toList(),
      'educations': resume.educations.map((e) => e.toJson()).toList(),
      'skills': resume.skills.map((s) => s.toJson()).toList(),
      'languages': resume.languages.map((l) => l.toJson()).toList(),
      'custom_sections': resume.customSections.map((s) => s.toJson()).toList(),
      'updated_at': DateTime.now().toIso8601String(),
    });
  }

  // Load resumes from cloud
  Future<List<Resume>> loadResumes() async {
    final user = _client.auth.currentUser;
    if (user == null) return [];

    final response = await _client
        .from('resumes')
        .select()
        .eq('user_id', user.id)
        .order('updated_at', ascending: false);

    return (response as List)
        .map((json) => Resume.fromJson(json))
        .toList();
  }

  // Delete resume from cloud
  Future<void> deleteResume(String resumeId) async {
    await _client.from('resumes').delete().eq('id', resumeId);
  }
}
```

## Security Best Practices

1. **Never commit API keys** - Use environment variables
2. **Enable RLS** - Always use Row Level Security policies
3. **Validate input** - Sanitize all user inputs on both client and server
4. **Rate limiting** - Configure rate limits in Supabase dashboard
5. **Monitor usage** - Set up alerts for unusual activity
6. **Backup data** - Enable automated backups in Supabase settings

## Testing

1. **Local development**: Use Supabase CLI for local testing
   ```bash
   supabase init
   supabase start
   ```

2. **Test authentication**: Create test users and verify RLS policies
3. **Test edge functions**: Use `supabase functions serve` for local testing

## Troubleshooting

### Common Issues

1. **Connection refused**
   - Check if Supabase URL and keys are correct
   - Verify network connectivity
   - Check if Supabase project is active

2. **Permission denied**
   - Verify RLS policies are correct
   - Check if user is authenticated
   - Ensure user_id matches auth.uid()

3. **Edge function timeout**
   - Increase timeout in function configuration
   - Optimize function code
   - Check external API availability

## Migration from Local to Cloud

To migrate existing local resumes to cloud:

```dart
Future<void> migrateToCloud(StorageService local, CloudSyncService cloud) async {
  final localResumes = await local.loadResumes();

  for (final resume in localResumes) {
    try {
      await cloud.syncResume(resume);
      print('Migrated: ${resume.id}');
    } catch (e) {
      print('Failed to migrate ${resume.id}: $e');
    }
  }
}
```

## Additional Resources

- [Supabase Documentation](https://supabase.com/docs)
- [Flutter Supabase Package](https://pub.dev/packages/supabase_flutter)
- [Row Level Security Guide](https://supabase.com/docs/guides/auth/row-level-security)
- [Edge Functions Guide](https://supabase.com/docs/guides/functions)
