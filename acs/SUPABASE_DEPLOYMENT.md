# Развёртывание Supabase для системы опросов

## Предварительные требования

1. Установите Supabase CLI:
```bash
npm install -g supabase
```

2. Войдите в аккаунт Supabase:
```bash
supabase login
```

3. Свяжите проект с вашим Supabase проектом:
```bash
supabase link --project-ref yerbryysrnaraqmbhqdm
```

## 1. Применение миграций БД

Примените все миграции для настройки базы данных:

```bash
cd acs

# Миграция 1: Исправление типов device_id
supabase db push --file migrations/fix_poll_functions_device_id_type.sql

# Миграция 2: Добавление поддержки переводов
supabase db push --file migrations/add_translation_status_to_poll_options.sql
```

Или примените миграции через SQL Editor в веб-интерфейсе Supabase:
1. Откройте [Supabase Dashboard](https://supabase.com/dashboard/project/yerbryysrnaraqmbhqdm)
2. Перейдите в SQL Editor
3. Скопируйте содержимое файла миграции
4. Выполните SQL запрос

## 2. Развёртывание Edge Function для перевода

### Настройка секрета Gemini API Key

1. Получите API ключ от Google Gemini:
   - Перейдите на [Google AI Studio](https://aistudio.google.com/app/apikey)
   - Создайте новый API ключ

2. Добавьте ключ в секреты Supabase:
```bash
supabase secrets set GEMINI_API_KEY=ваш_gemini_api_key
```

Или через веб-интерфейс:
1. Откройте [Supabase Dashboard](https://supabase.com/dashboard/project/yerbryysrnaraqmbhqdm/settings/secrets)
2. Добавьте секрет: `GEMINI_API_KEY` = ваш API ключ

### Развёртывание функции

```bash
cd acs
supabase functions deploy poll-translate-option
```

### Проверка развёртывания

Проверьте, что функция развёрнута:
```bash
supabase functions list
```

Вы должны увидеть `poll-translate-option` в списке.

## 3. Тестирование Edge Function

Проверьте работу функции через curl:

```bash
curl -X POST "https://yerbryysrnaraqmbhqdm.supabase.co/functions/v1/poll-translate-option" \
  -H "Authorization: Bearer YOUR_ANON_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "text": "Улучшенная формула",
    "sourceLanguage": "ru",
    "targetLanguages": ["en", "uk", "es", "de", "fr", "it"]
  }'
```

Ожидаемый ответ:
```json
{
  "success": true,
  "error": null,
  "translations": {
    "en": { "text": "Improved formula" },
    "uk": { "text": "Покращена формула" },
    "es": { "text": "Fórmula mejorada" },
    "de": { "text": "Verbesserte Formel" },
    "fr": { "text": "Formule améliorée" },
    "it": { "text": "Formula migliorata" }
  }
}
```

## 4. Проверка RPC функций

Проверьте, что все RPC функции работают:

### add_custom_option_with_translation
```bash
curl -X POST "https://yerbryysrnaraqmbhqdm.supabase.co/rest/v1/rpc/add_custom_option_with_translation" \
  -H "apikey: YOUR_ANON_KEY" \
  -H "Content-Type: application/json" \
  -d '{"p_text":"Тестовый вариант","p_language_code":"ru"}'
```

### get_pending_translations
```bash
curl -X POST "https://yerbryysrnaraqmbhqdm.supabase.co/rest/v1/rpc/get_pending_translations" \
  -H "apikey: YOUR_ANON_KEY" \
  -H "Content-Type: application/json" \
  -d '{"p_limit":10}'
```

## 5. Мониторинг логов Edge Function

Для просмотра логов функции:
```bash
supabase functions logs poll-translate-option
```

Или через веб-интерфейс:
1. Откройте [Supabase Dashboard](https://supabase.com/dashboard/project/yerbryysrnaraqmbhqdm/functions)
2. Выберите `poll-translate-option`
3. Перейдите на вкладку Logs

## Поддерживаемые языки

Система автоматически переводит варианты опросов на следующие языки:
- English (en)
- Русский (ru)
- Українська (uk)
- Español (es)
- Deutsch (de)
- Français (fr)
- Italiano (it)

## Устранение проблем

### CORS ошибка при вызове Edge Function

**Симптомы:**
```
Access to fetch has been blocked by CORS policy: Request header field authorization is not allowed
```

**Решение:**
1. Убедитесь, что Edge Function обновлена с исправленными CORS headers
2. Заголовки должны включать: `Authorization, apikey, x-client-info`
3. Переразверните функцию: `supabase functions deploy poll-translate-option`

### Ошибка: function jsonb_object_length does not exist

**Симптомы:**
```
PostgrestException(message: function jsonb_object_length(jsonb) does not exist, code: 42883)
```

**Решение:**
1. Эта функция доступна только в PostgreSQL 17+, но Supabase использует более старую версию
2. Миграция `add_translation_status_to_poll_options.sql` уже исправлена
3. Примените обновлённую миграцию заново:
```bash
cd acs
supabase db push --file migrations/add_translation_status_to_poll_options.sql
```

Или выполните в SQL Editor:
```sql
-- Удалите старую функцию
DROP FUNCTION IF EXISTS add_option_translations(UUID, JSONB, TEXT);

-- Примените обновлённую миграцию из файла
```

### Функция не переводит варианты

1. Проверьте, что `GEMINI_API_KEY` установлен:
```bash
supabase secrets list
```

2. Проверьте логи функции:
```bash
supabase functions logs poll-translate-option --tail
```

3. Проверьте, что миграция `add_translation_status_to_poll_options.sql` применена:
```sql
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'poll_options'
AND column_name IN ('translation_status', 'translated_from_language');
```

### Edge Function возвращает ошибку 404

Убедитесь, что функция развёрнута:
```bash
supabase functions deploy poll-translate-option
```

### Переводы не сохраняются в БД

Проверьте, что RPC функция `add_option_translations` существует:
```sql
SELECT routine_name
FROM information_schema.routines
WHERE routine_name = 'add_option_translations';
```

## Дополнительная информация

- [Документация Supabase Edge Functions](https://supabase.com/docs/guides/functions)
- [Документация Gemini API](https://ai.google.dev/docs)
- [Файл SUPABASE_FIXES.md](./SUPABASE_FIXES.md) - список всех исправлений
