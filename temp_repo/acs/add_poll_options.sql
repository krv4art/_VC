-- Добавить варианты ответов для опроса (poll_options)
-- Вставляем 4 предустановленных варианта

-- Вариант 1
INSERT INTO poll_options (vote_count, is_user_created)
VALUES (0, false)
RETURNING id AS option_1_id;

-- Вариант 2
INSERT INTO poll_options (vote_count, is_user_created)
VALUES (0, false)
RETURNING id AS option_2_id;

-- Вариант 3
INSERT INTO poll_options (vote_count, is_user_created)
VALUES (0, false)
RETURNING id AS option_3_id;

-- Вариант 4
INSERT INTO poll_options (vote_count, is_user_created)
VALUES (0, false)
RETURNING id AS option_4_id;

-- Теперь добавляем переводы для каждого варианта
-- После выполнения первой части скрипта замените {option_1_id}, {option_2_id} и т.д. на реальные ID

-- Языки: en (English), ru (Русский), uk (Українська), de (Deutsch), es (Español), fr (Français), it (Italiano)

-- Вариант 1 переводы
INSERT INTO poll_option_translations (option_id, language_code, text)
VALUES
  ('{option_1_id}', 'en', 'Very Interested'),
  ('{option_1_id}', 'ru', 'Очень интересует'),
  ('{option_1_id}', 'uk', 'Дуже цікаво'),
  ('{option_1_id}', 'de', 'Sehr interessant'),
  ('{option_1_id}', 'es', 'Muy interesado'),
  ('{option_1_id}', 'fr', 'Très intéressé'),
  ('{option_1_id}', 'it', 'Molto interessato');

-- Вариант 2 переводы
INSERT INTO poll_option_translations (option_id, language_code, text)
VALUES
  ('{option_2_id}', 'en', 'Somewhat Interested'),
  ('{option_2_id}', 'ru', 'Частично интересует'),
  ('{option_2_id}', 'uk', 'Частково цікаво'),
  ('{option_2_id}', 'de', 'Etwas interessant'),
  ('{option_2_id}', 'es', 'Algo interesado'),
  ('{option_2_id}', 'fr', 'Un peu intéressé'),
  ('{option_2_id}', 'it', 'Abbastanza interessato');

-- Вариант 3 переводы
INSERT INTO poll_option_translations (option_id, language_code, text)
VALUES
  ('{option_3_id}', 'en', 'Not Interested'),
  ('{option_3_id}', 'ru', 'Не интересует'),
  ('{option_3_id}', 'uk', 'Не цікаво'),
  ('{option_3_id}', 'de', 'Nicht interessant'),
  ('{option_3_id}', 'es', 'No interesado'),
  ('{option_3_id}', 'fr', 'Pas intéressé'),
  ('{option_3_id}', 'it', 'Non interessato');

-- Вариант 4 переводы
INSERT INTO poll_option_translations (option_id, language_code, text)
VALUES
  ('{option_4_id}', 'en', 'Need More Information'),
  ('{option_4_id}', 'ru', 'Нужна дополнительная информация'),
  ('{option_4_id}', 'uk', 'Потрібна додаткова інформація'),
  ('{option_4_id}', 'de', 'Brauche mehr Informationen'),
  ('{option_4_id}', 'es', 'Necesito más información'),
  ('{option_4_id}', 'fr', 'Besoin de plus d\'informations'),
  ('{option_4_id}', 'it', 'Ho bisogno di più informazioni');
