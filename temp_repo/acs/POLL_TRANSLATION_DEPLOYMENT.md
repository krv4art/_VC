# Инструкция по развертыванию автоматического перевода опросов

## Быстрый старт (5 минут)

### Шаг 1: Применить миграцию БД (1 минута)

1. Откройте Supabase Dashboard для вашего проекта
2. Перейдите в **SQL Editor** → нажмите **"New Query"**
3. Скопируйте содержимое файла `migrations/add_translation_status_to_poll_options.sql`
4. Вставьте в редактор и нажмите **"Run"**
5. Дождитесь завершения выполнения

**Проверка:** В таблице `poll_options` должны появиться 2 новых столбца:
- `translation_status`
- `translated_from_language`

### Шаг 2: Получить Gemini API ключ (2 минуты)

1. Перейдите на https://aistudio.google.com
2. Нажмите **"Get API Key"** (или **"Create API Key"**)
3. Выберите ваш проект Google Cloud
4. Скопируйте API ключ (начинается с `AIza...`)
5. **Сохраните его в надежном месте**

### Шаг 3: Развернуть Edge Function (1 минута)

1. Откройте terminal в папке проекта
2. Убедитесь, что установлен Supabase CLI:
   ```bash
   supabase --version
   ```
   Если не установлен:
   ```bash
   npm install -g supabase
   ```

3. Разверните функцию:
   ```bash
   supabase functions deploy poll-translate-option
   ```

   Если вас попросят залогиниться:
   ```bash
   supabase login
   ```

### Шаг 4: Установить переменную окружения (1 минута)

1. Откройте Supabase Dashboard
2. Перейдите в **Edge Functions** → найдите **poll-translate-option**
3. Нажмите на функцию
4. Перейдите в вкладку **Settings** (или **Environment variables**)
5. Нажмите **"Add secret"**
6. Заполните:
   - **Name:** `GEMINI_API_KEY`
   - **Value:** (вставьте API ключ из Шага 2)
7. Нажмите **"Save"**

**Проверка:** Переменная должна появиться в списке с статусом "Active"

### Шаг 5: Проверить логи функции (1 минута)

1. В том же окне Edge Function нажмите вкладку **Logs**
2. Должны быть логи типа:
   ```
   Function loaded successfully
   ```

## Тестирование

### Локальное тестирование (5 минут)

1. **Запустите приложение:**
   ```bash
   flutter run
   ```

2. **Откройте главный экран** и перейдите в опрос

3. **Добавьте новый вариант:**
   - Нажмите на карточку опроса
   - Прокрутите вниз до кнопки "Add your option"
   - Введите текст: "Amazing new feature"
   - Нажмите "Submit"

4. **Проверьте логи:**
   - В Flutter DevTools → Logging ищите:
     ```
     === POLL TRANSLATION: Translating "Amazing new feature" from en ===
     === POLL TRANSLATION: Successfully translated to 7 languages ===
     ```

5. **Проверьте БД:**
   - Supabase Dashboard → Table Editor → poll_options
   - Найдите новую запись с вашим текстом
   - `translation_status` должен быть "completed"

6. **Проверьте переводы:**
   - Supabase Dashboard → Table Editor → poll_option_translations
   - Должно быть 7 записей для нового варианта (для каждого языка)

7. **Переключитесь на другой язык:**
   - В приложении нажмите Settings → Language → Russian (или другой)
   - Вернитесь в опрос (pull-to-refresh)
   - Ваш новый вариант должен быть виден на русском языке

### Если тестирование не прошло

**Проблема: логов о переводе нет, функция не вызывается**
- Проверьте, что `poll-translate-option` функция развернута
- Посмотрите логи функции в Supabase Dashboard → Edge Functions

**Проблема: "401 Unauthorized" в логах функции**
- GEMINI_API_KEY неправильный или не установлен
- Проверьте переменную в Settings функции
- Убедитесь, что API ключ начинается с `AIza...`

**Проблема: "Resource exhausted" или "Rate limit"**
- Вы превысили лимит Gemini API
- Подождите несколько минут и попробуйте снова
- Возможно, нужно обновить биллинг в Google Cloud

**Проблема: Вариант добавлен, но переводов нет**
- Может быть задержка на обработку (2-5 секунд)
- Перезагрузите приложение
- Проверьте status в БД (может быть "failed")

## Развертывание в production

### Для staging/продакшена

1. Повторите все шаги выше, но для staging проекта
2. Убедитесь, что используется **отдельный** Gemini API ключ для продакшена
3. Протестируйте с реальными данными

### Мониторинг

Регулярно проверяйте:
- **Logs функции:** Supabase Dashboard → Edge Functions → poll-translate-option → Logs
- **Статус варианта:** Убедитесь, что нет варианто со статусом "failed" или "pending"
- **Использование API:** Google Cloud Console → Gemini API usage

## Откат (если что-то пошло не так)

### Откатить Edge Function
```bash
supabase functions delete poll-translate-option
```

### Откатить миграцию БД
```sql
-- В Supabase SQL Editor удалить функции:
DROP FUNCTION IF EXISTS add_custom_option_with_translation;
DROP FUNCTION IF EXISTS add_option_translations;
DROP FUNCTION IF EXISTS get_pending_translations;

-- Удалить столбцы:
ALTER TABLE poll_options
DROP COLUMN IF EXISTS translation_status,
DROP COLUMN IF EXISTS translated_from_language;

-- Удалить индекс:
DROP INDEX IF EXISTS idx_poll_options_translation_status;
```

## Полезные команды

```bash
# Проверить статус функции
supabase functions list

# Увидеть логи локально (если запускаете локально)
supabase start
supabase functions serve

# Проверить связь с Supabase
flutter pub get
```

## Стоимость использования

**Gemini 1.5 Flash (very cheap):**
- Input: $0.075 / 1M tokens (~$0.0001 за перевод)
- Output: $0.3 / 1M tokens (~$0.00001 за перевод)
- **Итого:** ~$0.0001 за перевод одного варианта

**Примеры:**
- 100 переводов в день: ~$0.01
- 1000 переводов в месяц: ~$0.10
- 10000 переводов в месяц: ~$1

**Мониторинг стоимости:**
- Google Cloud Console → Billing → Gemini API

## Вопросы и ответы

**В: Что будет, если Edge Function недоступна?**
О: Вариант все равно добавится на исходном языке. Переводы просто не добавятся. Статус будет "failed".

**В: Могу я переводить на больше языков?**
О: Да, отредактируйте файл `supabase/functions/poll-translate-option/index.ts` и добавьте новые языки в функцию `buildTranslationPrompt`.

**В: Какой максимальный размер текста можно переводить?**
О: Gemini поддерживает до 32k токенов на вход. Для одного варианта (обычно 50-200 символов) это не проблема.

**В: Как ускорить перевод?**
О: Используйте Gemini 1.5 Pro вместо Flash (он немного быстрее, но дороже). Измените URL в Edge Function с `gemini-1.5-flash` на `gemini-1.5-pro`.

## Контакты и поддержка

Если возникли проблемы:
1. Проверьте логи (Flutter + Edge Function)
2. Посмотрите ошибки в БД (статус в poll_options)
3. Убедитесь, что API ключ верный и активен

Для более подробной информации см. `POLL_TRANSLATION_SETUP.md`
