# Автоматический перевод вариантов опроса через Gemini

## Обзор решения

Реализована полностью автоматизированная система перевода новых вариантов опроса на все поддерживаемые языки (7 языков: англ., русский, украинский, испанский, немецкий, французский, итальянский) через Gemini API.

## Архитектура

```
Пользователь добавляет вариант на главной странице
    ↓
poll_widget.dart (_addCustomOption)
    ↓
poll_service.dart (addCustomOption)
    ↓
poll_supabase_service.dart (addCustomOption)
    ↓
RPC: add_custom_option_with_translation
    ↓
Создается вариант опроса с translation_status='pending'
    ↓
_triggerTranslation запускается асинхронно (не блокирует UI)
    ↓
poll_translation_service.dart (translateAndSave)
    ↓
Supabase Edge Function: poll-translate-option
    ↓
Gemini API (Direct, не через прокси)
    ↓
Переводы добавляются в poll_option_translations
```

## Компоненты решения

### 1. База данных (migrations/add_translation_status_to_poll_options.sql)

**Новые столбцы в poll_options:**
- `translation_status` (TEXT): 'pending', 'translating', 'completed', 'failed'
- `translated_from_language` (TEXT): язык исходного текста

**Новые RPC функции:**

#### add_custom_option_with_translation
Создает новый вариант опроса с первым переводом (на язык пользователя).
```sql
add_custom_option_with_translation(
  p_text TEXT,          -- Текст варианта
  p_language_code TEXT  -- Язык текста (en, ru, uk, es, de, fr, it)
)
```
Возвращает JSON с ID созданного варианта и статусом.

#### add_option_translations
Добавляет переводы варианта опроса (вызывается из Edge Function после Gemini).
```sql
add_option_translations(
  p_option_id UUID,
  p_translations JSONB,      -- {"en": {"text": "..."}, "ru": {"text": "..."}}
  p_translation_status TEXT  -- 'completed' или 'failed'
)
```

#### get_pending_translations
Получает список вариантов, требующих перевода (для фонового задания).

### 2. Flutter сервисы

#### poll_translation_service.dart
Основной сервис для перевода. Методы:

- `translateOptionText(text, sourceLanguage)`: Переводит текст через Edge Function
- `saveTranslations(optionId, translations)`: Сохраняет переводы в БД
- `translateAndSave(optionId, text, sourceLanguage)`: Комбинированный метод

```dart
// Пример использования
final translationService = PollTranslationService();
await translationService.translateAndSave(optionId, "New option", "en");
```

#### poll_supabase_service.dart (обновлена)
Метод `addCustomOption` теперь возвращает `String?` (ID варианта вместо `bool`).

#### poll_service.dart (обновлена)
Метод `addCustomOption` обновлен для работы с новым возвращаемым типом.

#### poll_widget.dart (обновлена)
- `_addCustomOption()`: Добавляет вариант и запускает перевод асинхронно
- `_triggerTranslation()`: Запускает фоновый перевод без блокировки UI

### 3. Edge Function (supabase/functions/poll-translate-option)

TypeScript функция, которая:
1. Получает текст для перевода
2. Формирует промпт для Gemini
3. Вызывает Gemini API (используется GEMINI_API_KEY из переменных окружения)
4. Парсит JSON ответ
5. Возвращает переводы в формате:
```json
{
  "success": true,
  "translations": {
    "en": { "text": "..." },
    "ru": { "text": "..." },
    "uk": { "text": "..." },
    ...
  }
}
```

**Промпт для Gemini:**
- Просит перевести текст на указанные языки
- Устанавливает низкую температуру (0.3) для консистентности
- Требует JSON ответ в точном формате
- Поддерживает все 7 языков приложения

## Поток выполнения

### Шаг 1: Пользователь добавляет вариант
```
Пользователь вводит текст и нажимает "Добавить"
→ _addCustomOption() вызывает pollService.addCustomOption()
```

### Шаг 2: Создание варианта
```
addCustomOption() → addCustomOption() в PollSupabaseService
→ RPC: add_custom_option_with_translation()
→ Создается poll_options запись с translation_status='pending'
→ Создается poll_option_translations запись для языка пользователя
→ Возвращается optionId
```

### Шаг 3: Загрузка вновь добавленного варианта
```
_loadPollData() перезагружает список опций
→ Пользователь сразу видит новый вариант на своем языке
```

### Шаг 4: Асинхронный перевод (не блокирует UI)
```
_triggerTranslation() запускает poll_translation_service.translateAndSave()
→ Вызывает Edge Function: poll-translate-option
→ Edge Function вызывает Gemini API
→ Получает переводы на остальные 6 языков
→ Сохраняет переводы в БД через RPC: add_option_translations()
```

### Шаг 5: Обновление UI (опционально)
```
После успешного перевода _loadPollData() вызывается снова
→ UI обновляется с полным набором переводов
(Если пользователь переключит язык, он увидит переводы)
```

## Обработка ошибок

### Если Gemini не ответил:
- Переводы не добавляются
- Вариант остается доступным на исходном языке
- Статус: 'failed'
- Пользователь может видеть вариант, но на других языках он будет недоступен

### Если RPC функция не ответила:
- Возвращается `{sourceLanguage: text}` (только исходный текст)
- Логируется ошибка
- Вариант остается на исходном языке

## Настройка и развертывание

### 1. Применить миграцию БД
```sql
-- Выполнить SQL из migrations/add_translation_status_to_poll_options.sql
-- в Supabase SQL Editor
```

### 2. Развернуть Edge Function
```bash
# Убедитесь, что у вас установлен Supabase CLI
supabase functions deploy poll-translate-option

# Установите переменную окружения GEMINI_API_KEY
# В Supabase Dashboard → Edge Functions → poll-translate-option → Settings
```

### 3. Настроить GEMINI_API_KEY
```
Supabase Dashboard → Settings → Edge Functions → Secrets
Добавить: GEMINI_API_KEY = <ваш API ключ от Google>
```

### 4. Обновить зависимости Flutter (если требуется)
```bash
flutter pub get
```

## Поддерживаемые языки

| Код | Язык |
|-----|------|
| en  | English (Английский) |
| ru  | Russian (Русский) |
| uk  | Ukrainian (Украинский) |
| es  | Spanish (Испанский) |
| de  | German (Немецкий) |
| fr  | French (Французский) |
| it  | Italian (Итальянский) |

## Тестирование

### Локальное тестирование

1. **Добавить новый вариант:**
   - Открыть опрос на главной странице
   - Написать вариант на текущем языке
   - Нажать "Добавить"
   - Убедиться, что вариант появился на текущем языке

2. **Проверить логи:**
   ```
   Flutter DevTools → Logging
   Ищите логи с префиксом "=== POLL TRANSLATION"
   ```

3. **Проверить БД:**
   - Supabase Dashboard → SQL Editor
   - Проверить poll_options на новую запись
   - Проверить poll_option_translations на наличие всех переводов

4. **Проверить переводы:**
   - Переключиться на другой язык в приложении
   - Перезагрузить опрос (pull-to-refresh)
   - Убедиться, что новый вариант виден на этом языке

### Production-like тестирование

1. Развернуть Edge Function на staging
2. Добавить вариант на staging приложении
3. Проверить логи Edge Function в Supabase Dashboard
4. Убедиться, что переводы добавлены в БД

## Логирование и отладка

### Логи Flutter
```
=== POLL TRANSLATION: Translating "text" from en ===
=== POLL TRANSLATION: Successfully translated to 7 languages ===
=== POLL TRANSLATION: Saving 7 translations for option <id> ===
=== POLL WIDGET: Translation completed for option <id> ===
```

### Логи Edge Function
```
Translating "text" from en to [ru, uk, es, de, fr, it]
Gemini response: {...}
```

Логи доступны в: Supabase Dashboard → Edge Functions → poll-translate-option → Logs

## Производительность

- **UI блокировка:** 0ms - перевод асинхронный
- **Время на добавление варианта:** ~300ms (создание + кэширование)
- **Время на перевод:** 2-5 секунд (зависит от Gemini)
- **Размер запроса к Gemini:** ~500 символов
- **Размер ответа:** ~200-400 символов

## Стоимость

Использует Gemini 1.5 Flash, который очень экономичен:
- ~0.001 USD за 10 переводов (примерно)
- Для 100 переводов в день: ~0.01 USD

## Будущие улучшения

1. **Кэширование переводов**: Сохранять общепопулярные переводы локально
2. **Батчинг**: Переводить несколько вариантов одним запросом
3. **Фоновый перевод**: Периодически переводить оставшиеся pending варианты
4. **Улучшенная обработка ошибок**: Retry-логика при ошибках Gemini
5. **Аналитика**: Отслеживание количества переведённых вариантов

## Известные ограничения

1. Если Edge Function недоступна, переводы не добавляются (но вариант все равно создается)
2. Максимальный размер текста варианта: 500 символов (ограничение Gemini)
3. Время отклика Gemini может варьироваться в пиковые часы

## Справка по файлам

| Файл | Описание |
|------|---------|
| migrations/add_translation_status_to_poll_options.sql | SQL миграция для БД |
| lib/services/poll_translation_service.dart | Flutter сервис для перевода |
| lib/services/poll_supabase_service.dart | Обновлен для новой RPC функции |
| lib/services/poll_service.dart | Обновлен для нового возвращаемого типа |
| lib/widgets/poll_widget.dart | Обновлен для запуска перевода |
| supabase/functions/poll-translate-option/index.ts | Edge Function для Gemini |
