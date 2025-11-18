# Supabase Setup Guide для AI Tutor

Полное руководство по настройке backend infrastructure для AI Tutor приложения.

## Оглавление
1. [Создание Supabase проекта](#1-создание-supabase-проекта)
2. [Database Schema](#2-database-schema)
3. [Row Level Security (RLS)](#3-row-level-security-rls)
4. [Edge Functions](#4-edge-functions)
5. [Storage](#5-storage)
6. [Realtime](#6-realtime)
7. [Локальная настройка](#7-локальная-настройка)

---

## 1. Создание Supabase проекта

### Шаг 1.1: Создать аккаунт
1. Перейти на [supabase.com](https://supabase.com)
2. Зарегистрироваться или войти
3. Создать новый проект
4. Сохранить **Project URL** и **anon/public API key**

### Шаг 1.2: Настроить .env файл
Создать `/ai_tutor/.env` со следующими значениями:

```env
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key-here
OPENAI_API_KEY=sk-your-openai-key-here

# RevenueCat (опционально)
REVENUECAT_IOS_KEY=appl_your_ios_key
REVENUECAT_ANDROID_KEY=goog_your_android_key
```

---

## 2. Database Schema

### Таблица: `user_profiles`
Хранит профили пользователей.

```sql
CREATE TABLE user_profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  full_name TEXT NOT NULL,
  email TEXT NOT NULL,
  avatar_url TEXT,
  selected_interests JSONB DEFAULT '[]'::jsonb,
  custom_interests JSONB DEFAULT '[]'::jsonb,
  cultural_theme_id TEXT DEFAULT 'default',
  learning_style TEXT DEFAULT 'balanced',
  subject_levels JSONB DEFAULT '{}'::jsonb,
  preferred_language TEXT DEFAULT 'en',
  is_onboarding_complete BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Index for faster lookups
CREATE INDEX idx_user_profiles_email ON user_profiles(email);
CREATE INDEX idx_user_profiles_created_at ON user_profiles(created_at);
```

### Таблица: `progress`
Хранит прогресс обучения пользователей.

```sql
CREATE TABLE progress (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  problems_solved INTEGER DEFAULT 0,
  correct_answers INTEGER DEFAULT 0,
  current_streak INTEGER DEFAULT 0,
  longest_streak INTEGER DEFAULT 0,
  total_study_time INTEGER DEFAULT 0, -- in seconds
  last_study_date DATE,
  topic_progress JSONB DEFAULT '{}'::jsonb,
  topic_mastery JSONB DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id)
);

-- Index
CREATE INDEX idx_progress_user_id ON progress(user_id);
CREATE INDEX idx_progress_current_streak ON progress(current_streak DESC);
```

### Таблица: `achievements`
Хранит достижения пользователей.

```sql
CREATE TABLE achievements (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  total_xp INTEGER DEFAULT 0,
  unlocked_achievements JSONB DEFAULT '[]'::jsonb,
  achievement_dates JSONB DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id)
);

-- Index
CREATE INDEX idx_achievements_user_id ON achievements(user_id);
CREATE INDEX idx_achievements_total_xp ON achievements(total_xp DESC);
```

### Таблица: `brain_training_stats`
Хранит статистику Brain Training упражнений.

```sql
CREATE TABLE brain_training_stats (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  stats_data JSONB NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id)
);

-- Index
CREATE INDEX idx_brain_training_user_id ON brain_training_stats(user_id);
```

### Таблица: `friends`
Хранит дружеские связи между пользователями.

```sql
CREATE TABLE friends (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  friend_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  status TEXT NOT NULL DEFAULT 'pending', -- pending, accepted, blocked
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, friend_id),
  CHECK (user_id != friend_id)
);

-- Indexes
CREATE INDEX idx_friends_user_id ON friends(user_id);
CREATE INDEX idx_friends_friend_id ON friends(friend_id);
CREATE INDEX idx_friends_status ON friends(status);
```

### Таблица: `blocked_users`
Хранит заблокированных пользователей.

```sql
CREATE TABLE blocked_users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  blocked_user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, blocked_user_id),
  CHECK (user_id != blocked_user_id)
);

-- Index
CREATE INDEX idx_blocked_users_user_id ON blocked_users(user_id);
```

### Таблица: `notifications`
Хранит уведомления для пользователей.

```sql
CREATE TABLE notifications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  type TEXT NOT NULL, -- friend_request, achievement, etc.
  from_user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  title TEXT,
  message TEXT,
  is_read BOOLEAN DEFAULT false,
  data JSONB,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_notifications_user_id ON notifications(user_id);
CREATE INDEX idx_notifications_is_read ON notifications(is_read);
CREATE INDEX idx_notifications_created_at ON notifications(created_at DESC);
```

### View: `leaderboard_view`
Представление для отображения лидерборда.

```sql
CREATE OR REPLACE VIEW leaderboard_view AS
SELECT
  up.id AS user_id,
  up.full_name,
  up.avatar_url,
  COALESCE(a.total_xp, 0) AS total_xp,
  COALESCE(p.problems_solved, 0) AS problems_solved,
  COALESCE(p.current_streak, 0) AS current_streak,
  p.last_study_date
FROM user_profiles up
LEFT JOIN achievements a ON up.id = a.user_id
LEFT JOIN progress p ON up.id = p.user_id
ORDER BY total_xp DESC;
```

---

## 3. Row Level Security (RLS)

Включить RLS для всех таблиц и создать политики безопасности.

### 3.1 Включить RLS

```sql
ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE progress ENABLE ROW LEVEL SECURITY;
ALTER TABLE achievements ENABLE ROW LEVEL SECURITY;
ALTER TABLE brain_training_stats ENABLE ROW LEVEL SECURITY;
ALTER TABLE friends ENABLE ROW LEVEL SECURITY;
ALTER TABLE blocked_users ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;
```

### 3.2 Политики для `user_profiles`

```sql
-- Users can view their own profile
CREATE POLICY "Users can view own profile"
  ON user_profiles FOR SELECT
  USING (auth.uid() = id);

-- Users can update their own profile
CREATE POLICY "Users can update own profile"
  ON user_profiles FOR UPDATE
  USING (auth.uid() = id);

-- Users can insert their own profile
CREATE POLICY "Users can insert own profile"
  ON user_profiles FOR INSERT
  WITH CHECK (auth.uid() = id);

-- Users can view profiles of friends
CREATE POLICY "Users can view friends' profiles"
  ON user_profiles FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM friends
      WHERE friends.user_id = auth.uid()
        AND friends.friend_id = user_profiles.id
        AND friends.status = 'accepted'
    )
  );
```

### 3.3 Политики для `progress`

```sql
-- Users can view their own progress
CREATE POLICY "Users can view own progress"
  ON progress FOR SELECT
  USING (auth.uid() = user_id);

-- Users can update their own progress
CREATE POLICY "Users can update own progress"
  ON progress FOR ALL
  USING (auth.uid() = user_id);

-- Users can view friends' progress
CREATE POLICY "Users can view friends' progress"
  ON progress FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM friends
      WHERE friends.user_id = auth.uid()
        AND friends.friend_id = progress.user_id
        AND friends.status = 'accepted'
    )
  );
```

### 3.4 Политики для `achievements`

```sql
-- Users can view their own achievements
CREATE POLICY "Users can view own achievements"
  ON achievements FOR SELECT
  USING (auth.uid() = user_id);

-- Users can update their own achievements
CREATE POLICY "Users can update own achievements"
  ON achievements FOR ALL
  USING (auth.uid() = user_id);

-- Users can view friends' achievements
CREATE POLICY "Users can view friends' achievements"
  ON achievements FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM friends
      WHERE friends.user_id = auth.uid()
        AND friends.friend_id = achievements.user_id
        AND friends.status = 'accepted'
    )
  );
```

### 3.5 Политики для `friends`

```sql
-- Users can view their own friends
CREATE POLICY "Users can view own friends"
  ON friends FOR SELECT
  USING (auth.uid() = user_id OR auth.uid() = friend_id);

-- Users can insert friend requests
CREATE POLICY "Users can send friend requests"
  ON friends FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Users can update friend status
CREATE POLICY "Users can update friend status"
  ON friends FOR UPDATE
  USING (auth.uid() = friend_id);

-- Users can delete their friendships
CREATE POLICY "Users can delete friendships"
  ON friends FOR DELETE
  USING (auth.uid() = user_id OR auth.uid() = friend_id);
```

### 3.6 Политики для `notifications`

```sql
-- Users can view their own notifications
CREATE POLICY "Users can view own notifications"
  ON notifications FOR SELECT
  USING (auth.uid() = user_id);

-- Users can update their own notifications (mark as read)
CREATE POLICY "Users can update own notifications"
  ON notifications FOR UPDATE
  USING (auth.uid() = user_id);

-- Anyone can insert notifications (for system)
CREATE POLICY "System can insert notifications"
  ON notifications FOR INSERT
  WITH CHECK (true);
```

---

## 4. Edge Functions

### 4.1 Функция: `ai-tutor`
Обрабатывает AI запросы для чата и практики.

Файл: `/supabase/functions/ai-tutor/index.ts`

```typescript
import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const openAIApiKey = Deno.env.get('OPENAI_API_KEY')

serve(async (req) => {
  try {
    const { messages, userProfile, mode } = await req.json()

    // Call OpenAI API
    const response = await fetch('https://api.openai.com/v1/chat/completions', {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${openAIApiKey}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        model: 'gpt-4-turbo-preview',
        messages: messages,
        temperature: 0.7,
      }),
    })

    const data = await response.json()
    const aiMessage = data.choices[0].message.content

    return new Response(
      JSON.stringify({ message: aiMessage }),
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

### 4.2 Функция: `generate-practice`
Генерирует практические задачи.

Файл: `/supabase/functions/generate-practice/index.ts`

```typescript
import { serve } from "https://deno.land/std@0.168.0/http/server.ts"

const openAIApiKey = Deno.env.get('OPENAI_API_KEY')

serve(async (req) => {
  try {
    const { subject, difficulty, interests } = await req.json()

    const prompt = `Generate a ${difficulty} level ${subject} practice problem personalized for someone interested in: ${interests.join(', ')}.
    Return JSON with: question, correctAnswer, explanation, hints array.`

    const response = await fetch('https://api.openai.com/v1/chat/completions', {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${openAIApiKey}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        model: 'gpt-4-turbo-preview',
        messages: [{ role: 'user', content: prompt }],
        temperature: 0.8,
      }),
    })

    const data = await response.json()
    const problem = JSON.parse(data.choices[0].message.content)

    return new Response(
      JSON.stringify({ problem }),
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

### 4.3 Database Functions (RPC)

```sql
-- Get friends with their stats
CREATE OR REPLACE FUNCTION get_friends(p_user_id UUID)
RETURNS TABLE (
  user_id UUID,
  full_name TEXT,
  avatar_url TEXT,
  total_xp INTEGER,
  problems_solved INTEGER,
  current_streak INTEGER,
  last_active TIMESTAMPTZ,
  status TEXT
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    up.id,
    up.full_name,
    up.avatar_url,
    COALESCE(a.total_xp, 0) AS total_xp,
    COALESCE(p.problems_solved, 0) AS problems_solved,
    COALESCE(p.current_streak, 0) AS current_streak,
    up.updated_at AS last_active,
    f.status
  FROM friends f
  JOIN user_profiles up ON f.friend_id = up.id
  LEFT JOIN achievements a ON up.id = a.user_id
  LEFT JOIN progress p ON up.id = p.user_id
  WHERE f.user_id = p_user_id AND f.status = 'accepted';
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Get pending friend requests
CREATE OR REPLACE FUNCTION get_pending_friend_requests(p_user_id UUID)
RETURNS TABLE (
  user_id UUID,
  full_name TEXT,
  avatar_url TEXT,
  total_xp INTEGER,
  problems_solved INTEGER,
  current_streak INTEGER,
  status TEXT
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    up.id,
    up.full_name,
    up.avatar_url,
    COALESCE(a.total_xp, 0) AS total_xp,
    COALESCE(p.problems_solved, 0) AS problems_solved,
    COALESCE(p.current_streak, 0) AS current_streak,
    f.status
  FROM friends f
  JOIN user_profiles up ON f.user_id = up.id
  LEFT JOIN achievements a ON up.id = a.user_id
  LEFT JOIN progress p ON up.id = p.user_id
  WHERE f.friend_id = p_user_id AND f.status = 'pending';
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Get mutual friends count
CREATE OR REPLACE FUNCTION get_mutual_friends_count(user_id_1 UUID, user_id_2 UUID)
RETURNS INTEGER AS $$
DECLARE
  count INTEGER;
BEGIN
  SELECT COUNT(*) INTO count
  FROM friends f1
  JOIN friends f2 ON f1.friend_id = f2.friend_id
  WHERE f1.user_id = user_id_1
    AND f2.user_id = user_id_2
    AND f1.status = 'accepted'
    AND f2.status = 'accepted';
  RETURN count;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Delete user (admin function)
CREATE OR REPLACE FUNCTION delete_user()
RETURNS VOID AS $$
BEGIN
  DELETE FROM auth.users WHERE id = auth.uid();
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
```

---

## 5. Storage

### 5.1 Создать Storage Buckets

```sql
-- Bucket для аватаров
INSERT INTO storage.buckets (id, name, public)
VALUES ('avatars', 'avatars', true);

-- Bucket для пользовательского контента
INSERT INTO storage.buckets (id, name, public)
VALUES ('user-content', 'user-content', false);
```

### 5.2 Storage Policies

```sql
-- Users can upload their own avatars
CREATE POLICY "Users can upload own avatar"
  ON storage.objects FOR INSERT
  WITH CHECK (
    bucket_id = 'avatars' AND
    auth.uid()::text = (storage.foldername(name))[1]
  );

-- Users can update their own avatars
CREATE POLICY "Users can update own avatar"
  ON storage.objects FOR UPDATE
  USING (
    bucket_id = 'avatars' AND
    auth.uid()::text = (storage.foldername(name))[1]
  );

-- Anyone can view avatars (public bucket)
CREATE POLICY "Anyone can view avatars"
  ON storage.objects FOR SELECT
  USING (bucket_id = 'avatars');
```

---

## 6. Realtime

### Включить Realtime для таблиц

```sql
-- Enable realtime for notifications
ALTER PUBLICATION supabase_realtime ADD TABLE notifications;

-- Enable realtime for friends
ALTER PUBLICATION supabase_realtime ADD TABLE friends;
```

---

## 7. Локальная настройка

### 7.1 Установить Supabase CLI

```bash
npm install -g supabase
```

### 7.2 Инициализировать проект

```bash
cd ai_tutor
supabase init
```

### 7.3 Запустить локально

```bash
supabase start
```

### 7.4 Deploy Edge Functions

```bash
# Deploy ai-tutor function
supabase functions deploy ai-tutor --no-verify-jwt

# Deploy generate-practice function
supabase functions deploy generate-practice --no-verify-jwt

# Set secrets
supabase secrets set OPENAI_API_KEY=your-key-here
```

### 7.5 Push migrations

```bash
supabase db push
```

---

## 8. Environment Variables

### Supabase Dashboard → Settings → API
Добавить environment variables для Edge Functions:

```
OPENAI_API_KEY=sk-your-key
```

---

## 9. Проверка установки

### 9.1 Тестирование Auth
```dart
final response = await Supabase.instance.client.auth.signUp(
  email: 'test@example.com',
  password: 'password123',
);
```

### 9.2 Тестирование Database
```dart
final data = await Supabase.instance.client
  .from('user_profiles')
  .select()
  .eq('id', userId)
  .single();
```

### 9.3 Тестирование Edge Functions
```dart
final response = await Supabase.instance.client.functions.invoke(
  'ai-tutor',
  body: {'messages': []},
);
```

---

## 10. Troubleshooting

### Проблема: "Row Level Security policy violation"
**Решение**: Проверить, что все RLS политики созданы правильно.

### Проблема: "Edge Function timeout"
**Решение**: Увеличить timeout в настройках функции или оптимизировать код.

### Проблема: "CORS error"
**Решение**: Добавить `'Access-Control-Allow-Origin': '*'` в headers Edge Function.

---

## 11. Production Checklist

- [ ] Все таблицы созданы
- [ ] RLS включен для всех таблиц
- [ ] Все политики безопасности настроены
- [ ] Edge Functions задеплоены
- [ ] Environment variables настроены
- [ ] Storage buckets созданы
- [ ] Realtime включен
- [ ] Database functions (RPC) созданы
- [ ] `.env` файл с правильными ключами
- [ ] Тестирование Auth, Database, Functions

---

## Поддержка

Если возникли проблемы:
1. Проверить логи в Supabase Dashboard → Logs
2. Проверить Edge Function logs
3. Проверить RLS policies

**Документация Supabase**: https://supabase.com/docs
