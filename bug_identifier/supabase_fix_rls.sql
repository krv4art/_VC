-- Отключить RLS для poll_options
ALTER TABLE poll_options DISABLE ROW LEVEL SECURITY;

-- Отключить RLS для poll_option_translations
ALTER TABLE poll_option_translations DISABLE ROW LEVEL SECURITY;

-- Отключить RLS для poll_votes
ALTER TABLE poll_votes DISABLE ROW LEVEL SECURITY;

-- Убедиться что таблицы доступны для anon role
GRANT SELECT, INSERT, UPDATE, DELETE ON poll_options TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON poll_option_translations TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON poll_votes TO anon;
