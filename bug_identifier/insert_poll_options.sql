-- Вставить варианты ответов в опрос с поддержкой всех языков
-- Вариант 1: "Very Interested"
WITH option_1 AS (
  INSERT INTO poll_options (vote_count, is_user_created)
  VALUES (0, false)
  RETURNING id
)
INSERT INTO poll_option_translations (option_id, language_code, text)
SELECT id, language_code, text FROM (
  SELECT (SELECT id FROM option_1) as id,
  CASE
    WHEN lang = 'en' THEN 'Very Interested'
    WHEN lang = 'ru' THEN 'Очень интересует'
    WHEN lang = 'uk' THEN 'Дуже цікаво'
    WHEN lang = 'de' THEN 'Sehr interessant'
    WHEN lang = 'es' THEN 'Muy interesado'
    WHEN lang = 'fr' THEN 'Très intéressé'
    WHEN lang = 'it' THEN 'Molto interessato'
  END as text,
  lang as language_code
  FROM (SELECT 'en' as lang UNION SELECT 'ru' UNION SELECT 'uk' UNION SELECT 'de' UNION SELECT 'es' UNION SELECT 'fr' UNION SELECT 'it') langs
) t;

-- Вариант 2: "Somewhat Interested"
WITH option_2 AS (
  INSERT INTO poll_options (vote_count, is_user_created)
  VALUES (0, false)
  RETURNING id
)
INSERT INTO poll_option_translations (option_id, language_code, text)
SELECT id, language_code, text FROM (
  SELECT (SELECT id FROM option_2) as id,
  CASE
    WHEN lang = 'en' THEN 'Somewhat Interested'
    WHEN lang = 'ru' THEN 'Частично интересует'
    WHEN lang = 'uk' THEN 'Частково цікаво'
    WHEN lang = 'de' THEN 'Etwas interessant'
    WHEN lang = 'es' THEN 'Algo interesado'
    WHEN lang = 'fr' THEN 'Un peu intéressé'
    WHEN lang = 'it' THEN 'Abbastanza interessato'
  END as text,
  lang as language_code
  FROM (SELECT 'en' as lang UNION SELECT 'ru' UNION SELECT 'uk' UNION SELECT 'de' UNION SELECT 'es' UNION SELECT 'fr' UNION SELECT 'it') langs
) t;

-- Вариант 3: "Not Interested"
WITH option_3 AS (
  INSERT INTO poll_options (vote_count, is_user_created)
  VALUES (0, false)
  RETURNING id
)
INSERT INTO poll_option_translations (option_id, language_code, text)
SELECT id, language_code, text FROM (
  SELECT (SELECT id FROM option_3) as id,
  CASE
    WHEN lang = 'en' THEN 'Not Interested'
    WHEN lang = 'ru' THEN 'Не интересует'
    WHEN lang = 'uk' THEN 'Не цікаво'
    WHEN lang = 'de' THEN 'Nicht interessant'
    WHEN lang = 'es' THEN 'No interesado'
    WHEN lang = 'fr' THEN 'Pas intéressé'
    WHEN lang = 'it' THEN 'Non interessato'
  END as text,
  lang as language_code
  FROM (SELECT 'en' as lang UNION SELECT 'ru' UNION SELECT 'uk' UNION SELECT 'de' UNION SELECT 'es' UNION SELECT 'fr' UNION SELECT 'it') langs
) t;

-- Вариант 4: "Need More Information"
WITH option_4 AS (
  INSERT INTO poll_options (vote_count, is_user_created)
  VALUES (0, false)
  RETURNING id
)
INSERT INTO poll_option_translations (option_id, language_code, text)
SELECT id, language_code, text FROM (
  SELECT (SELECT id FROM option_4) as id,
  CASE
    WHEN lang = 'en' THEN 'Need More Information'
    WHEN lang = 'ru' THEN 'Нужна дополнительная информация'
    WHEN lang = 'uk' THEN 'Потрібна додаткова інформація'
    WHEN lang = 'de' THEN 'Brauche mehr Informationen'
    WHEN lang = 'es' THEN 'Necesito más información'
    WHEN lang = 'fr' THEN 'Besoin de plus d\'informations'
    WHEN lang = 'it' THEN 'Ho bisogno di più informazioni'
  END as text,
  lang as language_code
  FROM (SELECT 'en' as lang UNION SELECT 'ru' UNION SELECT 'uk' UNION SELECT 'de' UNION SELECT 'es' UNION SELECT 'fr' UNION SELECT 'it') langs
) t;
