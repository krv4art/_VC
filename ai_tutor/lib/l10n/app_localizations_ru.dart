// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'AI Репетитор';

  @override
  String get welcome => 'Добро пожаловать';

  @override
  String get continueButton => 'Продолжить';

  @override
  String get cancel => 'Отмена';

  @override
  String get done => 'Готово';

  @override
  String get save => 'Сохранить';

  @override
  String get delete => 'Удалить';

  @override
  String get edit => 'Изменить';

  @override
  String get add => 'Добавить';

  @override
  String get back => 'Назад';

  @override
  String get next => 'Далее';

  @override
  String get skip => 'Пропустить';

  @override
  String get onboardingWelcomeTitle => 'Добро пожаловать в AI Репетитор!';

  @override
  String get onboardingWelcomeSubtitle =>
      'Ваш персонализированный помощник в обучении';

  @override
  String get onboardingWelcomeDescription =>
      'Учитесь через свои интересы с AI-репетитором';

  @override
  String get yourInterests => 'Ваши интересы';

  @override
  String get selectInterestsPrompt => 'Что вам интересно?';

  @override
  String get selectInterestsDescription =>
      'Мы используем это, чтобы сделать обучение веселым и понятным!\nВыберите 1-5 интересов.';

  @override
  String interestsSelected(int count, int max) {
    return '$count/$max выбрано';
  }

  @override
  String get addYourOwnInterest => 'Добавить свой интерес';

  @override
  String get selectAtLeastOneInterest =>
      'Пожалуйста, выберите хотя бы 1 интерес';

  @override
  String maxInterestsReached(int max) {
    return 'Вы можете выбрать до $max интересов';
  }

  @override
  String get addCustomInterestTitle => 'Добавить свой интерес';

  @override
  String get chooseEmoji => 'Выберите эмодзи';

  @override
  String get interestName => 'Название интереса';

  @override
  String get interestNameHint => 'например: LEGO, Динозавры, Танцы';

  @override
  String get keywordsForAI => 'Ключевые слова (для персонализации AI)';

  @override
  String get keywordsSeparator => 'Разделите запятыми или пробелами';

  @override
  String get keywordsHint => 'например: блоки, строить, кирпичи, детали';

  @override
  String get keywordsInfo =>
      'AI будет использовать эти слова для создания персонализированных примеров во всех уроках!';

  @override
  String get enterInterestName => 'Пожалуйста, введите название интереса';

  @override
  String get enterKeywords => 'Пожалуйста, введите хотя бы одно ключевое слово';

  @override
  String get enterValidKeywords =>
      'Пожалуйста, введите корректные ключевые слова';

  @override
  String get addInterest => 'Добавить интерес';

  @override
  String get culturalTheme => 'Культурная тема';

  @override
  String get chooseCulturalTheme => 'Выберите свой стиль';

  @override
  String get culturalThemeDescription => 'Выберите тему, которая вам близка';

  @override
  String get learningStyle => 'Стиль обучения';

  @override
  String get chooseLearningStyle => 'Как вы лучше учитесь?';

  @override
  String get learningStyleDescription =>
      'Выберите предпочтительный подход к обучению';

  @override
  String get levelAssessment => 'Оценка уровня';

  @override
  String get setYourLevel => 'Установите свой класс для каждого предмета';

  @override
  String gradeLevel(int level) {
    return '$level класс';
  }

  @override
  String get home => 'Главная';

  @override
  String get chat => 'Чат';

  @override
  String get practice => 'Практика';

  @override
  String get progress => 'Прогресс';

  @override
  String get profile => 'Профиль';

  @override
  String get settings => 'Настройки';

  @override
  String get goodMorning => 'Доброе утро';

  @override
  String get goodAfternoon => 'Добрый день';

  @override
  String get goodEvening => 'Добрый вечер';

  @override
  String get dailyChallenge => 'Ежедневное задание';

  @override
  String get todaysChallenge => 'Задание на сегодня';

  @override
  String get completedChallenges => 'Выполнено';

  @override
  String get activeGoals => 'Активные цели';

  @override
  String get viewAll => 'Посмотреть все';

  @override
  String get quickActions => 'Быстрые действия';

  @override
  String get startPractice => 'Практика';

  @override
  String get challenges => 'Задания';

  @override
  String get weeklyReport => 'Недельный отчёт';

  @override
  String get aiTutor => 'AI Репетитор';

  @override
  String get askQuestion => 'Задайте вопрос...';

  @override
  String get typeMessage => 'Введите сообщение...';

  @override
  String get send => 'Отправить';

  @override
  String get practiceMode => 'Режим практики';

  @override
  String get selectDifficulty => 'Выберите сложность';

  @override
  String get easy => 'Легко';

  @override
  String get medium => 'Средне';

  @override
  String get hard => 'Сложно';

  @override
  String get generateProblems => 'Создать задачи';

  @override
  String get checkAnswer => 'Проверить ответ';

  @override
  String get nextProblem => 'Следующая задача';

  @override
  String get showHint => 'Показать подсказку';

  @override
  String get showSolution => 'Показать решение';

  @override
  String get correct => 'Правильных';

  @override
  String get incorrect => 'Неправильно';

  @override
  String get tryAgain => 'Попробуйте снова';

  @override
  String get yourProgress => 'Ваш прогресс';

  @override
  String get totalProblems => 'Всего задач';

  @override
  String get accuracy => 'Точность';

  @override
  String get currentStreak => 'Текущая серия';

  @override
  String get longestStreak => 'Лучшая серия';

  @override
  String get studyTime => 'Время учёбы';

  @override
  String get achievements => 'Достижения';

  @override
  String get unlocked => 'Разблокировано';

  @override
  String get locked => 'Заблокировано';

  @override
  String get challengesAndGoals => 'Задания и цели';

  @override
  String get createNewGoal => 'Создать новую цель';

  @override
  String get goalType => 'Тип цели';

  @override
  String get targetValue => 'Целевое значение';

  @override
  String get deadline => 'Срок';

  @override
  String get problemsSolved => 'Решено задач';

  @override
  String get accuracyTarget => 'Целевая точность';

  @override
  String get streakGoal => 'Цель серии';

  @override
  String get studyTimeGoal => 'Время учёбы';

  @override
  String get topicMastery => 'Освоение темы';

  @override
  String get weeklyReportTitle => 'Недельный отчёт';

  @override
  String get last7Days => 'Последние 7 дней';

  @override
  String get problemsPerDay => 'Задач в день';

  @override
  String get averageAccuracy => 'Средняя точность';

  @override
  String get totalStudyTime => 'Всего времени учёбы';

  @override
  String minutes(int count) {
    return '$count мин';
  }

  @override
  String hours(int count) {
    return '$count ч';
  }

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get account => 'Аккаунт';

  @override
  String get editProfile => 'Редактировать профиль';

  @override
  String get editInterests => 'Редактировать интересы';

  @override
  String get changeTheme => 'Изменить тему';

  @override
  String get changeLearningStyle => 'Изменить стиль обучения';

  @override
  String get notifications => 'Уведомления';

  @override
  String get enableNotifications => 'Включить уведомления';

  @override
  String get dailyReminders => 'Ежедневные напоминания';

  @override
  String get streakReminders => 'Напоминания о серии';

  @override
  String get achievementAlerts => 'Уведомления о достижениях';

  @override
  String get progressAndGoals => 'Прогресс и цели';

  @override
  String get viewGoals => 'Посмотреть цели';

  @override
  String get resetProgress => 'Сбросить прогресс';

  @override
  String get resetProgressWarning =>
      'Это удалит весь ваш прогресс. Вы уверены?';

  @override
  String get data => 'Данные';

  @override
  String get shareProgress => 'Поделиться прогрессом';

  @override
  String get exportData => 'Экспортировать данные';

  @override
  String get exportDataComingSoon => 'Скоро будет';

  @override
  String get about => 'О приложении';

  @override
  String get version => 'Версия';

  @override
  String get feedback => 'Отправить отзыв';

  @override
  String get rateApp => 'Оценить приложение';

  @override
  String get privacyPolicy => 'Политика конфиденциальности';

  @override
  String get termsOfService => 'Условия использования';

  @override
  String get language => 'Язык';

  @override
  String get selectLanguage => 'Выбрать язык';

  @override
  String get english => 'English';

  @override
  String get russian => 'Русский';

  @override
  String get subjects => 'Предметы';

  @override
  String get mathematics => 'Математика';

  @override
  String get physics => 'Физика';

  @override
  String get chemistry => 'Химия';

  @override
  String get programming => 'Программирование';

  @override
  String get biology => 'Биология';

  @override
  String get englishSubject => 'Английский язык';

  @override
  String get interests => 'Интересы';

  @override
  String get gaming => 'Игры';

  @override
  String get sports => 'Спорт';

  @override
  String get spaceAstronomy => 'Космос и астрономия';

  @override
  String get animalsNature => 'Животные и природа';

  @override
  String get music => 'Музыка';

  @override
  String get artDrawing => 'Искусство и рисование';

  @override
  String get coding => 'Программирование';

  @override
  String get moviesTV => 'Фильмы и ТВ';

  @override
  String get booksReading => 'Книги и чтение';

  @override
  String get cookingFood => 'Кулинария и еда';

  @override
  String get themes => 'Темы';

  @override
  String get classic => 'Классическая';

  @override
  String get japanese => 'Японская';

  @override
  String get eastern => 'Восточная';

  @override
  String get cyberpunk => 'Киберпанк';

  @override
  String get scandinavian => 'Скандинавская';

  @override
  String get vibrant => 'Яркая';

  @override
  String get african => 'Африканская';

  @override
  String get latinAmerican => 'Латиноамериканская';

  @override
  String get learningStyles => 'Стили обучения';

  @override
  String get visual => 'Визуальный (графики и диаграммы)';

  @override
  String get practical => 'Практический (примеры и практика)';

  @override
  String get theoretical => 'Теоретический (подробные объяснения)';

  @override
  String get balanced => 'Сбалансированный (всё понемногу)';

  @override
  String get quick => 'Быстрый (кратко и по делу)';

  @override
  String get achievementUnlocked => 'Достижение разблокировано!';

  @override
  String get achievementMathWizard => 'Мастер математики';

  @override
  String get achievementScholar => 'Учёный';

  @override
  String get achievementEinstein => 'Эйнштейн';

  @override
  String get achievementOnFire => 'В огне';

  @override
  String get achievementUnstoppable => 'Неостановимый';

  @override
  String get achievementDiamondStreak => 'Алмазная серия';

  @override
  String get achievementPerfectionist => 'Перфекционист';

  @override
  String get achievementAceStudent => 'Отличник';

  @override
  String get achievementSpeedDemon => 'Скоростной демон';

  @override
  String get achievementBookworm => 'Книжный червь';

  @override
  String get achievementRisingStar => 'Восходящая звезда';

  @override
  String get achievementMasterLearner => 'Мастер обучения';

  @override
  String shareProgressText(int problems, int accuracy, int streak) {
    return '🎓 Мой прогресс в AI Репетитор\n📊 Решено задач: $problems\n✅ Точность: $accuracy%\n🔥 Серия: $streak дней';
  }

  @override
  String get brainTraining => 'Тренировки мозга';

  @override
  String get stroopTest => 'Тест Струппа';

  @override
  String get memoryCards => 'Карточки памяти';

  @override
  String get speedReading => 'Скоростное чтение';

  @override
  String get shapeCounter => 'Подсчет фигур';

  @override
  String get numberSequences => 'Числовые последовательности';

  @override
  String get nBackTest => 'N-Back тест';

  @override
  String get quickMath => 'Быстрый счет';

  @override
  String get spotTheDifference => 'Найди отличия';

  @override
  String get overallStats => 'Общая статистика';

  @override
  String get exercises => 'Упражнений';

  @override
  String get played => 'Сыграно';

  @override
  String get best => 'Рекорд';

  @override
  String get newExercise => 'Новое!';

  @override
  String get efficiency => 'Эффективность';

  @override
  String get moves => 'Ходов';

  @override
  String get signIn => 'Войти';

  @override
  String get signUp => 'Регистрация';

  @override
  String get leaderboard => 'Таблица лидеров';

  @override
  String get friends => 'Друзья';

  @override
  String get analytics => 'Аналитика';

  @override
  String get premium => 'Premium';

  @override
  String get transformProblem => 'Сделать интереснее ✨';

  @override
  String get transforming => 'Трансформация...';

  @override
  String transformed(String interest) {
    return 'Трансформировано: $interest';
  }

  @override
  String get original => 'Оригинал';

  @override
  String get errorTransforming => 'Ошибка трансформации задачи';
}
