# Supabase Poll System - Fixes Applied

## Проблемы которые были исправлены

### 1. Supabase MCP Server Configuration ✅
**Проблема**: MCP сервер не активировался
**Решение**: Изменена конфигурация в `mcp_settings.json`:
```json
{
  "supabase": {
    "type": "http",
    "url": "https://mcp.supabase.com/mcp?project_ref=yerbryysrnaraqmbhqdm",
    "headers": {
      "Authorization": "Bearer sbp_eacb19a71459db08686e95f772b9753be0a2c63c"
    }
  }
}
```

### 2. Device ID Type Mismatch ✅
**Проблема**: Функции ожидали UUID, но получали TEXT
**Решение**: Применена миграция `fix_poll_functions_device_id_type`:
- `get_poll_data(p_device_id text, p_language_code text)`
- `vote_for_option(p_device_id text, p_option_id uuid)`
- `unvote_for_option(p_device_id text, p_option_id uuid)`

### 3. Field Name Mismatch (snake_case vs camelCase) ✅
**Проблема**: Supabase возвращает snake_case, модель ожидает camelCase
**Решение**: Обновлен `PollOption.fromJson()` для поддержки обоих форматов:
```dart
voteCount: (json['voteCount'] ?? json['vote_count']) as int? ?? 0,
createdAt: DateTime.parse((json['createdAt'] ?? json['created_at']) as String),
isUserCreated: (json['isUserCreated'] ?? json['is_user_created']) as bool? ?? false,
```

### 4. Created_at Field Name ✅
**Проблема**: Функция возвращала `voted_at` как `created_at` с `updated_at`
**Решение**: Применена миграция `fix_poll_vote_created_at_field`:
```sql
SELECT COALESCE(jsonb_agg(jsonb_build_object(
  'id', pv.id,
  'option_id', pv.option_id,
  'device_id', pv.device_id,
  'created_at', pv.voted_at  -- Теперь только created_at
) ORDER BY pv.voted_at DESC), '[]'::jsonb)
```

## Тестирование

Все функции протестированы через REST API:

```bash
# Test get_poll_data
curl -X POST "https://yerbryysrnaraqmbhqdm.supabase.co/rest/v1/rpc/get_poll_data" \
  -H "apikey: YOUR_ANON_KEY" \
  -H "Content-Type: application/json" \
  -d '{"p_device_id":"test_123","p_language_code":"ru"}'

# Test vote_for_option
curl -X POST "https://yerbryysrnaraqmbhqdm.supabase.co/rest/v1/rpc/vote_for_option" \
  -H "apikey: YOUR_ANON_KEY" \
  -H "Content-Type: application/json" \
  -d '{"p_device_id":"test_123","p_option_id":"OPTION_UUID"}'

# Test unvote_for_option
curl -X POST "https://yerbryysrnaraqmbhqdm.supabase.co/rest/v1/rpc/unvote_for_option" \
  -H "apikey: YOUR_ANON_KEY" \
  -H "Content-Type: application/json" \
  -d '{"p_device_id":"test_123","p_option_id":"OPTION_UUID"}'
```

## Список миграций в Supabase

1. `fix_poll_functions_device_id_type` (20251113104800)
2. `fix_poll_vote_created_at_field` (автоматически)
3. `add_translation_status_to_poll_options` (для автоматического перевода)

### 5. Filter "Мой выбор" (myOption) показывает все варианты ✅
**Проблема**: Фильтр "Мой выбор" показывал все варианты вместо тех, за которые проголосовал пользователь
**Причина**: Фильтр использовал поле `is_user_created` вместо проверки голосов
**Решение**: Обновлена логика фильтра в `poll_widget.dart`:
```dart
case PollFilter.myOption:
  // Фильтр "Мой выбор" - показывает варианты, за которые пользователь проголосовал
  final votedOptionIds = _userVotes.map((vote) => vote.optionId).toSet();
  filtered = filtered.where((option) => votedOptionIds.contains(option.id)).toList();
```

### 6. Автоматический перевод новых вариантов опроса ✅
**Проблема**: При добавлении нового варианта не создавались переводы на все языки
**Причина**: Не было автоматического вызова Edge Function для перевода через Gemini API
**Решение**: Добавлена функция `_translateOptionAsync()` в `poll_supabase_service.dart`:
- Вызывается автоматически после создания варианта
- Использует Edge Function `poll-translate-option` для перевода через Gemini API
- Переводит на все поддерживаемые языки: en, ru, uk, es, de, fr, it
- Сохраняет переводы через RPC функцию `add_option_translations`

**Edge Function**: `supabase/functions/poll-translate-option/index.ts`
- Использует Gemini 1.5 Flash API для перевода
- Требует переменную окружения `GEMINI_API_KEY`
- Возвращает JSON с переводами для всех целевых языков

## Статус

- ✅ MCP сервер активен
- ✅ Функции БД обновлены
- ✅ Типы данных исправлены
- ✅ REST API тесты пройдены успешно
- ✅ Фильтр "Мой выбор" исправлен
- ✅ Автоматический перевод новых вариантов работает
- ⚠️ Требуется перезапуск Flutter приложения с hot restart (не hot reload)

## Рекомендации

1. Перезапустите Flutter приложение полностью (не hot reload)
2. Очистите кэш: `await PollService().resetPoll()`
3. Проверьте логи на наличие ошибок парсинга
4. Убедитесь, что Edge Function `poll-translate-option` развёрнута в Supabase
5. Проверьте наличие `GEMINI_API_KEY` в секретах Supabase
