-- =============================================================================
-- ОПТИМИЗАЦИЯ ЗАПРОСОВ СИСТЕМЫ ГОЛОСОВАНИЯ
-- =============================================================================
-- Этот файл содержит SQL функции для оптимизации количества запросов к БД
-- Цель: Снизить количество запросов на 60-80%
--
-- ВАЖНО: Выполните эти команды в Supabase SQL Editor в указанном порядке
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 1. Функция атомарного голосования
-- -----------------------------------------------------------------------------
-- Объединяет 4 операции в 1:
-- - Проверка лимита голосов
-- - Проверка дубликата
-- - Вставка голоса
-- - Инкремент счетчика
--
-- Возвращает: JSON с результатом операции
-- -----------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION vote_for_option(
  p_device_id UUID,
  p_option_id UUID
) RETURNS jsonb AS $$
DECLARE
  v_existing_votes INT;
  v_already_voted BOOLEAN;
  v_new_vote_id UUID;
BEGIN
  -- Проверяем количество существующих голосов
  SELECT COUNT(*) INTO v_existing_votes
  FROM poll_votes
  WHERE device_id = p_device_id;

  IF v_existing_votes >= 3 THEN
    RETURN jsonb_build_object(
      'success', false,
      'error', 'max_votes_reached',
      'vote_id', null
    );
  END IF;

  -- Проверяем, не проголосовал ли уже за эту опцию
  SELECT EXISTS(
    SELECT 1 FROM poll_votes
    WHERE device_id = p_device_id AND option_id = p_option_id
  ) INTO v_already_voted;

  IF v_already_voted THEN
    RETURN jsonb_build_object(
      'success', false,
      'error', 'already_voted',
      'vote_id', null
    );
  END IF;

  -- Вставляем голос и получаем ID
  INSERT INTO poll_votes (device_id, option_id, created_at, updated_at)
  VALUES (p_device_id, p_option_id, NOW(), NOW())
  RETURNING id INTO v_new_vote_id;

  -- Инкрементим vote_count атомарно
  UPDATE poll_options
  SET vote_count = vote_count + 1, updated_at = NOW()
  WHERE id = p_option_id;

  RETURN jsonb_build_object(
    'success', true,
    'error', null,
    'vote_id', v_new_vote_id
  );
EXCEPTION
  WHEN OTHERS THEN
    RETURN jsonb_build_object(
      'success', false,
      'error', SQLERRM,
      'vote_id', null
    );
END;
$$ LANGUAGE plpgsql;

-- -----------------------------------------------------------------------------
-- 2. Функция атомарной отмены голоса
-- -----------------------------------------------------------------------------
-- Объединяет 3 операции в 1:
-- - Проверка существования голоса
-- - Удаление голоса
-- - Декремент счетчика
--
-- Возвращает: JSON с результатом операции
-- -----------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION unvote_for_option(
  p_device_id UUID,
  p_option_id UUID
) RETURNS jsonb AS $$
DECLARE
  v_vote_exists BOOLEAN;
  v_deleted_count INT;
BEGIN
  -- Проверяем, есть ли голос
  SELECT EXISTS(
    SELECT 1 FROM poll_votes
    WHERE device_id = p_device_id AND option_id = p_option_id
  ) INTO v_vote_exists;

  IF NOT v_vote_exists THEN
    RETURN jsonb_build_object(
      'success', false,
      'error', 'vote_not_found'
    );
  END IF;

  -- Удаляем голос
  DELETE FROM poll_votes
  WHERE device_id = p_device_id AND option_id = p_option_id;

  GET DIAGNOSTICS v_deleted_count = ROW_COUNT;

  -- Уменьшаем счетчик голосов (с защитой от отрицательных значений)
  UPDATE poll_options
  SET vote_count = GREATEST(0, vote_count - 1), updated_at = NOW()
  WHERE id = p_option_id;

  RETURN jsonb_build_object(
    'success', true,
    'error', null,
    'deleted_count', v_deleted_count
  );
EXCEPTION
  WHEN OTHERS THEN
    RETURN jsonb_build_object(
      'success', false,
      'error', SQLERRM
    );
END;
$$ LANGUAGE plpgsql;

-- -----------------------------------------------------------------------------
-- 3. Функция консолидированной загрузки данных опроса
-- -----------------------------------------------------------------------------
-- Объединяет 3 запроса в 1:
-- - Получение вариантов с переводами
-- - Получение голосов пользователя
-- - Вычисление оставшихся голосов
--
-- Возвращает: JSON со всеми данными
-- -----------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION get_poll_data(
  p_device_id UUID,
  p_language_code TEXT
) RETURNS jsonb AS $$
DECLARE
  v_options jsonb;
  v_votes jsonb;
  v_vote_count INT;
  v_remaining_votes INT;
BEGIN
  -- Получаем варианты с переводами
  SELECT COALESCE(jsonb_agg(jsonb_build_object(
    'id', po.id,
    'text', pot.text,
    'vote_count', po.vote_count,
    'created_at', po.created_at,
    'is_user_created', po.is_user_created
  ) ORDER BY po.created_at DESC), '[]'::jsonb)
  INTO v_options
  FROM poll_options po
  INNER JOIN poll_option_translations pot
    ON po.id = pot.option_id
  WHERE pot.language_code = p_language_code;

  -- Получаем голоса пользователя
  SELECT COALESCE(jsonb_agg(jsonb_build_object(
    'id', pv.id,
    'option_id', pv.option_id,
    'device_id', pv.device_id,
    'created_at', pv.created_at,
    'updated_at', pv.updated_at
  ) ORDER BY pv.created_at DESC), '[]'::jsonb)
  INTO v_votes
  FROM poll_votes pv
  WHERE pv.device_id = p_device_id;

  -- Подсчитываем количество голосов пользователя
  SELECT COUNT(*) INTO v_vote_count
  FROM poll_votes
  WHERE device_id = p_device_id;

  -- Вычисляем оставшиеся голоса (максимум 3)
  v_remaining_votes := GREATEST(0, 3 - v_vote_count);

  -- Возвращаем все данные в одном объекте
  RETURN jsonb_build_object(
    'options', v_options,
    'votes', v_votes,
    'remaining_votes', v_remaining_votes,
    'language_code', p_language_code
  );
EXCEPTION
  WHEN OTHERS THEN
    RETURN jsonb_build_object(
      'error', SQLERRM,
      'options', '[]'::jsonb,
      'votes', '[]'::jsonb,
      'remaining_votes', 3
    );
END;
$$ LANGUAGE plpgsql;

-- =============================================================================
-- ПРОВЕРКА РАБОТОСПОСОБНОСТИ
-- =============================================================================
-- Раскомментируйте для тестирования после создания функций:
--
-- -- Тест 1: Получение данных опроса
-- SELECT get_poll_data(
--   'your-device-id-here'::uuid,
--   'en'
-- );
--
-- -- Тест 2: Голосование
-- SELECT vote_for_option(
--   'your-device-id-here'::uuid,
--   'your-option-id-here'::uuid
-- );
--
-- -- Тест 3: Отмена голоса
-- SELECT unvote_for_option(
--   'your-device-id-here'::uuid,
--   'your-option-id-here'::uuid
-- );
-- =============================================================================
