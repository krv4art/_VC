-- =============================================================================
-- ДОБАВЛЕНИЕ СТАТУСА ПЕРЕВОДА ДЛЯ ВАРИАНТОВ ОПРОСА
-- =============================================================================
-- Этот файл добавляет поддержку автоматического перевода вариантов опроса
-- через Gemini API на все поддерживаемые языки
-- =============================================================================

-- Добавляем столбец translation_status к таблице poll_options
-- Возможные значения: 'pending' (ожидает перевода), 'translating' (идет перевод), 'completed' (готово), 'failed' (ошибка)
ALTER TABLE poll_options
ADD COLUMN translation_status TEXT DEFAULT 'pending',
ADD COLUMN translated_from_language TEXT DEFAULT 'en';

-- Создаем индекс для быстрого поиска вариантов, ожидающих перевода
CREATE INDEX idx_poll_options_translation_status
ON poll_options(translation_status)
WHERE translation_status IN ('pending', 'translating');

-- =============================================================================
-- RPC ФУНКЦИЯ ДЛЯ ДОБАВЛЕНИЯ ВАРИАНТА С АВТОМАТИЧЕСКИМ ПЕРЕВОДОМ
-- =============================================================================
-- Эта функция:
-- 1. Создает новый вариант опроса
-- 2. Добавляет перевод на язык пользователя
-- 3. Устанавливает статус "pending" для фонового перевода
-- 4. Возвращает ID новой опции

CREATE OR REPLACE FUNCTION add_custom_option_with_translation(
  p_text TEXT,
  p_language_code TEXT
) RETURNS jsonb AS $$
DECLARE
  v_option_id UUID;
  v_translation_id UUID;
BEGIN
  -- Валидация входных данных
  IF p_text IS NULL OR p_text = '' THEN
    RETURN jsonb_build_object(
      'success', false,
      'error', 'empty_text',
      'option_id', null
    );
  END IF;

  IF p_language_code IS NULL OR p_language_code = '' THEN
    RETURN jsonb_build_object(
      'success', false,
      'error', 'invalid_language',
      'option_id', null
    );
  END IF;

  -- Создаем новый вариант
  INSERT INTO poll_options (vote_count, is_user_created, translation_status, translated_from_language)
  VALUES (0, true, 'pending', p_language_code)
  RETURNING id INTO v_option_id;

  -- Создаем перевод для исходного языка
  INSERT INTO poll_option_translations (option_id, language_code, text)
  VALUES (v_option_id, p_language_code, TRIM(p_text))
  RETURNING id INTO v_translation_id;

  RETURN jsonb_build_object(
    'success', true,
    'error', null,
    'option_id', v_option_id,
    'translation_id', v_translation_id,
    'translation_status', 'pending',
    'language_code', p_language_code
  );
END;
$$ LANGUAGE plpgsql;

-- =============================================================================
-- RPC ФУНКЦИЯ ДЛЯ ОБНОВЛЕНИЯ ПЕРЕВОДОВ ВАРИАНТА
-- =============================================================================
-- Эта функция вызывается из Edge Function после перевода через Gemini
-- Добавляет переводы для остальных языков

CREATE OR REPLACE FUNCTION add_option_translations(
  p_option_id UUID,
  p_translations JSONB,
  p_translation_status TEXT
) RETURNS jsonb AS $$
DECLARE
  v_lang_code TEXT;
  v_text TEXT;
  v_count INT := 0;
BEGIN
  -- Валидация
  IF p_option_id IS NULL THEN
    RETURN jsonb_build_object(
      'success', false,
      'error', 'invalid_option_id'
    );
  END IF;

  IF p_translations IS NULL OR jsonb_object_length(p_translations) = 0 THEN
    RETURN jsonb_build_object(
      'success', false,
      'error', 'empty_translations'
    );
  END IF;

  -- Проходим по каждому переводу
  FOR v_lang_code, v_text IN
  SELECT key, value ->> 'text'
  FROM jsonb_each(p_translations)
  WHERE value ->> 'text' IS NOT NULL
  LOOP
    -- Проверяем, есть ли уже перевод для этого языка
    IF NOT EXISTS(
      SELECT 1 FROM poll_option_translations
      WHERE option_id = p_option_id AND language_code = v_lang_code
    ) THEN
      -- Добавляем новый перевод
      INSERT INTO poll_option_translations (option_id, language_code, text)
      VALUES (p_option_id, v_lang_code, v_text);
      v_count := v_count + 1;
    END IF;
  END LOOP;

  -- Обновляем статус перевода
  UPDATE poll_options
  SET translation_status = p_translation_status
  WHERE id = p_option_id;

  RETURN jsonb_build_object(
    'success', true,
    'error', null,
    'translations_added', v_count,
    'translation_status', p_translation_status
  );
END;
$$ LANGUAGE plpgsql;

-- =============================================================================
-- RPC ФУНКЦИЯ ДЛЯ ПОЛУЧЕНИЯ ОПЦИЙ, ТРЕБУЮЩИХ ПЕРЕВОДА
-- =============================================================================
-- Используется для фонового задания по переводу вариантов

CREATE OR REPLACE FUNCTION get_pending_translations(p_limit INT DEFAULT 10)
RETURNS TABLE (
  option_id UUID,
  original_text TEXT,
  language_code TEXT,
  created_at TIMESTAMP
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    po.id,
    pot.text,
    po.translated_from_language,
    po.created_at
  FROM poll_options po
  LEFT JOIN poll_option_translations pot ON po.id = pot.option_id AND pot.language_code = po.translated_from_language
  WHERE po.translation_status = 'pending'
  ORDER BY po.created_at DESC
  LIMIT p_limit;
END;
$$ LANGUAGE plpgsql;
