// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appName => 'AI Cosmetic Scanner';

  @override
  String get skinAnalysis => 'Анализ кожи';

  @override
  String get checkYourCosmetics => 'Проверьте свои косметические средства';

  @override
  String get startScanning => 'Начать сканирование';

  @override
  String get quickActions => 'Быстрые действия';

  @override
  String get scanHistory => 'История сканирования';

  @override
  String get aiChat => 'Чат с ИИ';

  @override
  String get profile => 'Профиль';

  @override
  String get settings => 'Настройки';

  @override
  String get skinType => 'Тип кожи';

  @override
  String get allergiesSensitivities => 'Аллергии и чувствительность';

  @override
  String get subscription => 'Подписка';

  @override
  String get age => 'Возраст';

  @override
  String get language => 'Язык';

  @override
  String get selectYourPreferredLanguage => 'Выберите предпочитаемый язык';

  @override
  String get save => 'Сохранить';

  @override
  String get selectIngredientsAllergicSensitive => 'Выберите ингредиенты, на которые у вас повышенная чувствительность';

  @override
  String get commonAllergens => 'Распространенные аллергены';

  @override
  String get fragrance => 'Ароматизатор';

  @override
  String get parabens => 'Парабены';

  @override
  String get sulfates => 'Сульфаты';

  @override
  String get alcohol => 'Спирт';

  @override
  String get essentialOils => 'Эфирные масла';

  @override
  String get silicones => 'Силиконы';

  @override
  String get mineralOil => 'Минеральное масло';

  @override
  String get formaldehyde => 'Формальдегид';

  @override
  String get addCustomAllergen => 'Добавить свой аллерген';

  @override
  String get typeIngredientName => 'Введите название ингредиента...';

  @override
  String get selectedAllergens => 'Выбранные аллергены';

  @override
  String saveSelected(int count) {
    return 'Сохранить ($count выбрано)';
  }

  @override
  String get analysisResults => 'Результаты анализа';

  @override
  String get overallSafetyScore => 'Общий балл безопасности';

  @override
  String get personalizedWarnings => 'Персонализированные предупреждения';

  @override
  String ingredientsAnalysis(int count) {
    return 'Анализ ингредиентов ($count)';
  }

  @override
  String get highRisk => 'Высокий риск';

  @override
  String get moderateRisk => 'Умеренный риск';

  @override
  String get lowRisk => 'Низкий риск';

  @override
  String get benefitsAnalysis => 'Анализ преимуществ';

  @override
  String get recommendedAlternatives => 'Рекомендуемые альтернативы';

  @override
  String get reason => 'Причина:';

  @override
  String get quickSummary => 'Быстрая сводка';

  @override
  String get ingredientsChecked => 'ингредиентов проверено';

  @override
  String get personalWarnings => 'персональных предупреждений';

  @override
  String get ourVerdict => 'Наш вердикт';

  @override
  String get productInfo => 'Информация о продукте';

  @override
  String get productType => 'Тип продукта';

  @override
  String get brand => 'Бренд';

  @override
  String get premiumInsights => 'Premium Insights';

  @override
  String get researchArticles => 'Научные исследования';

  @override
  String get categoryRanking => 'Рейтинг в категории';

  @override
  String get safetyTrend => 'Тренд безопасности';

  @override
  String get saveToFavorites => 'В избранное';

  @override
  String get shareResults => 'Поделиться';

  @override
  String get compareProducts => 'Сравнить';

  @override
  String get exportPDF => 'PDF';

  @override
  String get scanSimilar => 'Похожий';

  @override
  String get aiChatTitle => 'Чат с ИИ';

  @override
  String get typeYourMessage => 'Введите ваше сообщение...';

  @override
  String get errorSupabaseClientNotInitialized => 'Ошибка: Клиент Supabase не инициализирован.';

  @override
  String get serverError => 'Ошибка сервера:';

  @override
  String get networkErrorOccurred => 'Произошла ошибка сети. Пожалуйста, попробуйте позже.';

  @override
  String get sorryAnErrorOccurred => 'К сожалению, произошла ошибка. Пожалуйста, попробуйте снова.';

  @override
  String get couldNotGetResponse => 'Не удалось получить ответ.';

  @override
  String get aiAssistant => 'Ассистент ИИ';

  @override
  String get online => 'В сети';

  @override
  String get typing => 'Печатает...';

  @override
  String get writeAMessage => 'Написать сообщение...';

  @override
  String get hiIAmYourAIAssistantHowCanIHelp => 'Привет! Я ваш помощник ИИ. Чем я могу вам помочь?';

  @override
  String get iCanSeeYourScanResultsFeelFreeToAskMeAnyQuestionsAboutTheIngredientsSafetyConcernsOrRecommendations => 'Я вижу ваши результаты сканирования! Не стесняйтесь задавать мне любые вопросы о ингредиентах, проблемах безопасности или рекомендациях.';

  @override
  String get userQuestion => 'Вопрос пользователя:';

  @override
  String get databaseExplorer => 'Обозреватель базы данных';

  @override
  String get currentUser => 'Текущий пользователь:';

  @override
  String get notSignedIn => 'Не вошли в систему';

  @override
  String get failedToFetchTables => 'Не удалось получить таблицы:';

  @override
  String get tablesInYourSupabaseDatabase => 'Таблицы в вашей базе данных Supabase:';

  @override
  String get viewSampleData => 'Просмотреть пример данных';

  @override
  String get failedToFetchSampleDataFor => 'Не удалось получить пример данных для';

  @override
  String get sampleData => 'Пример данных:';

  @override
  String get aiChats => 'Чаты с ИИ';

  @override
  String get noDialoguesYet => 'Диалогов пока нет.';

  @override
  String get startANewChat => 'Начать новый чат!';

  @override
  String get created => 'Создано:';

  @override
  String get failedToSaveImage => 'Не удалось сохранить изображение:';

  @override
  String get editName => 'Изменить имя';

  @override
  String get enterYourName => 'Введите ваше имя';

  @override
  String get cancel => 'Отмена';

  @override
  String get premiumUser => 'Премиум-пользователь';

  @override
  String get freeUser => 'Бесплатный пользователь';

  @override
  String get skinProfile => 'Профиль кожи';

  @override
  String get notSet => 'Не установлено';

  @override
  String get legal => 'Правовая информация';

  @override
  String get privacyPolicy => 'Политика конфиденциальности';

  @override
  String get termsOfService => 'Условия предоставления услуг';

  @override
  String get dataManagement => 'Управление данными';

  @override
  String get clearAllData => 'Очистить все данные';

  @override
  String get clearAllDataConfirmation => 'Вы уверены, что хотите удалить все ваши локальные данные? Это действие нельзя отменить.';

  @override
  String get selectDataToClear => 'Выберите данные для очистки';

  @override
  String get scanResults => 'Сканирования';

  @override
  String get chatHistory => 'Чаты';

  @override
  String get personalData => 'Личные данные';

  @override
  String get clearData => 'Очистить данные';

  @override
  String get allLocalDataHasBeenCleared => 'Данные были очищены.';

  @override
  String get signOut => 'Выйти';

  @override
  String get deleteScan => 'Удалить сканирование';

  @override
  String get deleteScanConfirmation => 'Вы уверены, что хотите удалить это сканирование из вашей истории?';

  @override
  String get deleteChat => 'Удалить чат';

  @override
  String get deleteChatConfirmation => 'Вы уверены, что хотите удалить этот чат? Все сообщения будут потеряны.';

  @override
  String get delete => 'Удалить';

  @override
  String get noScanHistoryFound => 'История сканирования не найдена.';

  @override
  String get scanOn => 'Сканирование';

  @override
  String get ingredientsFound => 'ингредиентов найдено';

  @override
  String get noCamerasFoundOnThisDevice => 'На этом устройстве не найдено камер.';

  @override
  String get failedToInitializeCamera => 'Не удалось инициализировать камеру:';

  @override
  String get analysisFailed => 'Анализ не удался:';

  @override
  String get analyzingPleaseWait => 'Анализируем, подождите...';

  @override
  String get positionTheLabelWithinTheFrame => 'Наведите камеру на список ингредиентов';

  @override
  String get createAccount => 'Создать аккаунт';

  @override
  String get signUpToGetStarted => 'Зарегистрируйтесь, чтобы начать';

  @override
  String get fullName => 'Полное имя';

  @override
  String get pleaseEnterYourName => 'Пожалуйста, введите ваше имя';

  @override
  String get email => 'Электронная почта';

  @override
  String get pleaseEnterYourEmail => 'Пожалуйста, введите вашу электронную почту';

  @override
  String get pleaseEnterAValidEmail => 'Пожалуйста, введите действительный адрес электронной почты';

  @override
  String get password => 'Пароль';

  @override
  String get pleaseEnterYourPassword => 'Пожалуйста, введите ваш пароль';

  @override
  String get passwordMustBeAtLeast6Characters => 'Пароль должен содержать не менее 6 символов';

  @override
  String get signUp => 'Зарегистрироваться';

  @override
  String get orContinueWith => 'или продолжить с';

  @override
  String get google => 'Google';

  @override
  String get apple => 'Apple';

  @override
  String get alreadyHaveAnAccount => 'Уже есть аккаунт? ';

  @override
  String get signIn => 'Войти';

  @override
  String get selectYourSkinTypeDescription => 'Выберите тип вашей кожи';

  @override
  String get normal => 'Нормальная';

  @override
  String get normalSkinDescription => 'Сбалансированная, не слишком жирная и не сухая';

  @override
  String get dry => 'Сухая';

  @override
  String get drySkinDescription => 'Стянутая, шелушащаяся, грубая текстура';

  @override
  String get oily => 'Жирная';

  @override
  String get oilySkinDescription => 'Блестящая, большие поры, склонность к акне';

  @override
  String get combination => 'Комбинированная';

  @override
  String get combinationSkinDescription => 'Жирная Т-зона, сухие щеки';

  @override
  String get sensitive => 'Чувствительная';

  @override
  String get sensitiveSkinDescription => 'Легко раздражается, склонна к покраснению';

  @override
  String get selectSkinType => 'Выбрать тип кожи';

  @override
  String get restore => 'Восстановить';

  @override
  String get restorePurchases => 'Восстановить покупки';

  @override
  String get subscriptionRestored => 'Подписка успешно восстановлена!';

  @override
  String get noPurchasesToRestore => 'Нет покупок для восстановления';

  @override
  String get goPremium => 'Перейти на Премиум';

  @override
  String get unlockExclusiveFeatures => 'Разблокируйте эксклюзивные функции, чтобы получить максимум от анализа вашей кожи.';

  @override
  String get unlimitedProductScans => 'Неограниченное количество сканирований продуктов';

  @override
  String get advancedAIIngredientAnalysis => 'Расширенный ИИ-анализ ингредиентов';

  @override
  String get fullScanAndSearchHistory => 'Полная история сканирований и поиска';

  @override
  String get adFreeExperience => '100% без рекламы';

  @override
  String get yearly => 'Ежегодно';

  @override
  String savePercentage(int percentage) {
    return 'Экономия $percentage%';
  }

  @override
  String get monthly => 'Ежемесячно';

  @override
  String get perMonth => '/ месяц';

  @override
  String get startFreeTrial => 'Начать бесплатный период';

  @override
  String trialDescription(String planName) {
    return '7-дневная бесплатная пробная версия, затем списание $planName. Отменить можно в любое время.';
  }

  @override
  String get home => 'Главная';

  @override
  String get scan => 'Сканер';

  @override
  String get aiChatNav => 'Консультант';

  @override
  String get profileNav => 'Профиль';

  @override
  String get doYouEnjoyOurApp => 'Вам нравится наше приложение?';

  @override
  String get notReally => 'Нет';

  @override
  String get yesItsGreat => 'Нравится';

  @override
  String get rateOurApp => 'Оцените наше приложение';

  @override
  String get bestRatingWeCanGet => 'Лучшая оценка, которую мы можем получить';

  @override
  String get rateOnGooglePlay => 'Оценить в Google Play';

  @override
  String get rate => 'Оценить';

  @override
  String get whatCanBeImproved => 'Что можно улучшить?';

  @override
  String get wereSorryYouDidntHaveAGreatExperience => 'Нам жаль, что вы остались недовольны. Пожалуйста, сообщите нам, что пошло не так.';

  @override
  String get yourFeedback => 'Ваш отзыв...';

  @override
  String get sendFeedback => 'Отправить отзыв';

  @override
  String get thankYouForYourFeedback => 'Спасибо за ваш отзыв!';

  @override
  String get discussWithAI => 'Обсудить с ИИ';

  @override
  String get enterYourEmail => 'Введите вашу электронную почту';

  @override
  String get enterYourPassword => 'Введите ваш пароль';

  @override
  String get aiDisclaimer => 'Ответы ИИ могут содержать неточности. Пожалуйста, проверяйте критическую информацию.';

  @override
  String get applicationThemes => 'Темы приложения';

  @override
  String get highestRating => 'Наивысшая оценка';

  @override
  String get selectYourAgeDescription => 'Выберите ваш возраст';

  @override
  String get ageRange18_25 => '18-25';

  @override
  String get ageRange26_35 => '26-35';

  @override
  String get ageRange36_45 => '36-45';

  @override
  String get ageRange46_55 => '46-55';

  @override
  String get ageRange56Plus => '56+';

  @override
  String get ageRange18_25Description => 'Молодая кожа, профилактика';

  @override
  String get ageRange26_35Description => 'Первые признаки старения';

  @override
  String get ageRange36_45Description => 'Антивозрастной уход';

  @override
  String get ageRange46_55Description => 'Интенсивный уход';

  @override
  String get ageRange56PlusDescription => 'Специализированный уход';

  @override
  String get userName => 'Ваше имя';

  @override
  String get yourName => 'Ваше имя';

  @override
  String get tryFreeAndSubscribe => 'Попробовать бесплатно и подписаться';

  @override
  String get personalAIConsultant => 'Персональный ИИ-консультант 24/7';

  @override
  String get subscribe => 'Подписаться';

  @override
  String get themes => 'Темы';

  @override
  String get selectPreferredTheme => 'Выберите предпочитаемую тему';

  @override
  String get naturalTheme => 'Натуральная';

  @override
  String get darkTheme => 'Темная';

  @override
  String get darkNatural => 'Темная Натуральная';

  @override
  String get oceanTheme => 'Океан';

  @override
  String get forestTheme => 'Лес';

  @override
  String get sunsetTheme => 'Закат';

  @override
  String get naturalThemeDescription => 'Натуральная тема с экологичными цветами';

  @override
  String get darkThemeDescription => 'Темная тема для комфорта глаз';

  @override
  String get oceanThemeDescription => 'Свежая океанская тема';

  @override
  String get forestThemeDescription => 'Природная лесная тема';

  @override
  String get sunsetThemeDescription => 'Теплая тема в тонах заката';

  @override
  String get sunnyTheme => 'Солнечная';

  @override
  String get sunnyThemeDescription => 'Яркая и жизнерадостная желтая тема';

  @override
  String get vibrantTheme => 'Яркая';

  @override
  String get vibrantThemeDescription => 'Яркая розово-фиолетовая тема';

  @override
  String get scanAnalysis => 'Анализ сканирования';

  @override
  String get ingredients => 'ингредиентов';

  @override
  String get aiBotSettings => 'Настройка ИИ';

  @override
  String get botName => 'Имя бота';

  @override
  String get enterBotName => 'Введите имя бота';

  @override
  String get pleaseEnterBotName => 'Пожалуйста, введите имя бота';

  @override
  String get botDescription => 'Описание бота';

  @override
  String get selectAvatar => 'Выбрать аватар';

  @override
  String get defaultBotName => 'ACS';

  @override
  String defaultBotDescription(String name) {
    return 'Привет! Я $name (AI Cosmetic Scanner). Помогу вам разобраться в составе вашей косметики. У меня большие знания в области косметологии и ухода за кожей. С удовольствием отвечу на все ваши вопросы.';
  }

  @override
  String get settingsSaved => 'Настройки успешно сохранены';

  @override
  String get failedToSaveSettings => 'Не удалось сохранить настройки';

  @override
  String get resetToDefault => 'Сбросить настройки';

  @override
  String get resetSettings => 'Сбросить настройки';

  @override
  String get resetSettingsConfirmation => 'Вы уверены, что хотите сбросить все настройки к значениям по умолчанию?';

  @override
  String get settingsResetSuccessfully => 'Настройки успешно сброшены';

  @override
  String get failedToResetSettings => 'Не удалось сбросить настройки';

  @override
  String get unsavedChanges => 'Несохраненные изменения';

  @override
  String get unsavedChangesMessage => 'У вас есть несохраненные изменения. Вы уверены, что хотите уйти?';

  @override
  String get stay => 'Остаться';

  @override
  String get leave => 'Уйти';

  @override
  String get errorLoadingSettings => 'Ошибка загрузки настроек';

  @override
  String get retry => 'Повторить';

  @override
  String get customPrompt => 'Особые пожелания';

  @override
  String get customPromptDescription => 'Добавьте персонализированные инструкции для AI-ассистента';

  @override
  String get customPromptPlaceholder => 'Введите ваши особые пожелания...';

  @override
  String get enableCustomPrompt => 'Включить особые пожелания';

  @override
  String get defaultCustomPrompt => 'Говори мне комплименты.';

  @override
  String get close => 'Закрыть';

  @override
  String get scanningHintTitle => 'Как сканировать';

  @override
  String get scanLimitReached => 'Лимит сканирований достигнут';

  @override
  String get scanLimitReachedMessage => 'Вы использовали все 5 бесплатных сканирований на этой неделе. Оформите подписку Premium для неограниченного количества сканирований!';

  @override
  String get messageLimitReached => 'Дневной лимит сообщений достигнут';

  @override
  String get messageLimitReachedMessage => 'Вы отправили 5 сообщений сегодня. Оформите подписку Premium для неограниченного чата!';

  @override
  String get historyLimitReached => 'Доступ к истории ограничен';

  @override
  String get historyLimitReachedMessage => 'Оформите подписку Premium для доступа к полной истории сканирований!';

  @override
  String get upgradeToPremium => 'Оформить Premium';

  @override
  String get upgradeToView => 'Просмотреть с Premium';

  @override
  String get upgradeToChat => 'Чат с Premium';

  @override
  String get premiumFeature => 'Функция Premium';

  @override
  String get freePlanUsage => 'Использование бесплатного плана';

  @override
  String get scansThisWeek => 'Сканирования на этой неделе';

  @override
  String get messagesToday => 'Сообщения сегодня';

  @override
  String get limitsReached => 'Лимиты достигнуты';

  @override
  String get remainingScans => 'Осталось сканирований';

  @override
  String get remainingMessages => 'Осталось сообщений';

  @override
  String get unlockUnlimitedAccess => 'Разблокируйте неограниченный доступ';

  @override
  String get upgradeToPremiumDescription => 'Получите неограниченные сканирования, сообщения и полный доступ к истории сканирований с Premium!';

  @override
  String get premiumBenefits => 'Преимущества Premium';

  @override
  String get unlimitedAiChatMessages => 'Неограниченные сообщения в чате с ИИ';

  @override
  String get fullAccessToScanHistory => 'Полный доступ к истории сканирований';

  @override
  String get prioritySupport => 'Приоритетная поддержка';

  @override
  String get learnMore => 'Узнать больше';

  @override
  String get upgradeNow => 'Оформить сейчас';

  @override
  String get maybeLater => 'Может быть позже';

  @override
  String get scanHistoryLimit => 'Только самое последнее сканирование видно в истории';

  @override
  String get upgradeForUnlimitedScans => 'Оформите Premium для неограниченных сканирований!';

  @override
  String get upgradeForUnlimitedChat => 'Оформите Premium для неограниченного чата!';

  @override
  String get slowInternetConnection => 'Медленное интернет-соединение';

  @override
  String get slowInternetMessage => 'На очень медленном интернете придется немного подождать... Мы все еще анализируем ваше изображение.';

  @override
  String get revolutionaryAI => 'Революционный ИИ';

  @override
  String get revolutionaryAIDesc => 'Один из самых умных в мире';

  @override
  String get unlimitedScans => 'Неограниченные сканирования';

  @override
  String get unlimitedScansDesc => 'Изучайте косметику без ограничений';

  @override
  String get unlimitedChats => 'Неограниченные чаты';

  @override
  String get unlimitedChatsDesc => 'Персональный ИИ-консультант 24/7';

  @override
  String get fullHistory => 'Полная история';

  @override
  String get fullHistoryDesc => 'Неограниченная история сканирований';

  @override
  String get rememberContext => 'Помнит контекст';

  @override
  String get rememberContextDesc => 'ИИ помнит ваши предыдущие сообщения';

  @override
  String get allIngredientsInfo => 'Вся информация про ингредиенты';

  @override
  String get allIngredientsInfoDesc => 'Узнайте все подробности';

  @override
  String get noAds => '100% без рекламы';

  @override
  String get noAdsDesc => 'Для тех, кто ценит своё время';

  @override
  String get multiLanguage => 'Знает почти все языки мира';

  @override
  String get multiLanguageDesc => 'Улучшенный переводчик';

  @override
  String get paywallTitle => 'Раскройте секреты вашей косметики с помощью ИИ';

  @override
  String paywallDescription(String price) {
    return 'У вас есть возможность взять Премиум-версию подписки на 3 дня бесплатно, затем $price в неделю. Отмена в любое время.';
  }

  @override
  String get whatsIncluded => 'Что включено';

  @override
  String get basicPlan => 'Базовая';

  @override
  String get premiumPlan => 'Премиум';

  @override
  String get botGreeting1 => 'Добрый день! Как я могу вам помочь сегодня?';

  @override
  String get botGreeting2 => 'Здравствуйте! Что вас привело ко мне?';

  @override
  String get botGreeting3 => 'Приветствую вас! Готов помочь с анализом косметики.';

  @override
  String get botGreeting4 => 'Рад вас видеть! Чем могу быть полезен?';

  @override
  String get botGreeting5 => 'Добро пожаловать! Давайте вместе изучим состав вашей косметики.';

  @override
  String get botGreeting6 => 'Здравствуйте! Готов ответить на ваши вопросы о косметике.';

  @override
  String get botGreeting7 => 'Привет! Я ваш персональный помощник по косметологии.';

  @override
  String get botGreeting8 => 'Добрый день! Помогу разобраться в составе косметических средств.';

  @override
  String get botGreeting9 => 'Здравствуйте! Давайте сделаем вашу косметику безопаснее.';

  @override
  String get botGreeting10 => 'Приветствую! Готов поделиться знаниями о косметике.';

  @override
  String get botGreeting11 => 'Добрый день! Помогу найти лучшие косметические решения для вас.';

  @override
  String get botGreeting12 => 'Здравствуйте! Ваш эксперт по безопасности косметики к вашим услугам.';

  @override
  String get botGreeting13 => 'Привет! Давайте вместе подберем идеальную косметику для вас.';

  @override
  String get botGreeting14 => 'Добро пожаловать! Готов помочь с анализом ингредиентов.';

  @override
  String get botGreeting15 => 'Здравствуйте! Помогу понять состав вашей косметики.';

  @override
  String get botGreeting16 => 'Приветствую! Ваш гид в мире косметологии готов помочь.';

  @override
  String get copiedToClipboard => 'Скопировано в буфер обмена';

  @override
  String get tryFree => 'Попробуйте бесплатно';

  @override
  String get cameraNotReady => 'Камера не готова / нет разрешения';

  @override
  String get cameraPermissionInstructions => 'Настройки приложения:\nAI Cosmetic Scanner > Разрешения > Камера > Разрешить';

  @override
  String get openSettingsAndGrantAccess => 'Откройте Настройки и предоставьте доступ к камере';

  @override
  String get retryCamera => 'Повторить';

  @override
  String get errorServiceOverloaded => 'Сервис временно перегружен. Попробуйте через несколько секунд.';

  @override
  String get errorRateLimitExceeded => 'Слишком много запросов. Подождите немного и попробуйте снова.';

  @override
  String get errorTimeout => 'Превышено время ожидания. Проверьте подключение к интернету и попробуйте снова.';

  @override
  String get errorNetwork => 'Ошибка сети. Проверьте подключение к интернету.';

  @override
  String get errorAuthentication => 'Ошибка аутентификации. Пожалуйста, перезапустите приложение.';

  @override
  String get errorInvalidResponse => 'Получен некорректный ответ. Попробуйте снова.';

  @override
  String get errorServer => 'Ошибка сервера. Попробуйте позже.';

  @override
  String get customThemes => 'Кастомные темы';

  @override
  String get createCustomTheme => 'Создать кастомную тему';

  @override
  String get basedOn => 'На основе';

  @override
  String get lightMode => 'Светлая';

  @override
  String get generateWithAI => 'Генерация с AI';

  @override
  String get resetToBaseTheme => 'Сбросить к базовой теме';

  @override
  String colorsResetTo(Object themeName) {
    return 'Цвета сброшены к $themeName';
  }

  @override
  String get aiGenerationComingSoon => 'Генерация тем с AI будет в Iteration 5!';

  @override
  String get onboardingGreeting => 'Добро пожаловать! Чтобы улучшить качество ответов, давайте настроим ваш профиль';

  @override
  String get letsGo => 'Поехали';

  @override
  String get next => 'Далее';

  @override
  String get finish => 'Завершить';

  @override
  String get customThemeInDevelopment => 'Функция кастомных тем находится в разработке';

  @override
  String get customThemeComingSoon => 'Скоро будет доступно в следующих обновлениях';

  @override
  String get dailyMessageLimitReached => 'Лимит достигнут';

  @override
  String get dailyMessageLimitReachedMessage => 'Вы отправили 5 сообщений сегодня. Оформите подписку Premium для неограниченного чата!';

  @override
  String get upgradeToPremiumForUnlimitedChat => 'Оформить Premium для неограниченного чата';

  @override
  String get messagesLeftToday => 'сообщений осталось на сегодня';

  @override
  String get designYourOwnTheme => 'Создайте свою собственную тему';

  @override
  String get darkOcean => 'Темный океан';

  @override
  String get darkForest => 'Темный лес';

  @override
  String get darkSunset => 'Темный закат';

  @override
  String get darkVibrant => 'Темная яркая';

  @override
  String get darkOceanThemeDescription => 'Темная океанская тема с голубыми акцентами';

  @override
  String get darkForestThemeDescription => 'Темная лесная тема с салатовыми акцентами';

  @override
  String get darkSunsetThemeDescription => 'Темная тема заката с оранжевыми акцентами';

  @override
  String get darkVibrantThemeDescription => 'Темная яркая тема с розовыми и фиолетовыми акцентами';

  @override
  String get customTheme => 'Кастомная тема';

  @override
  String get edit => 'Изменить';

  @override
  String get deleteTheme => 'Удалить тему';

  @override
  String deleteThemeConfirmation(String themeName) {
    return 'Вы уверены, что хотите удалить \"$themeName\"?';
  }

  @override
  String get pollTitle => 'Чего не хватает?';

  @override
  String get pollCardTitle => 'Какую функцию нужно добавить в приложение';

  @override
  String get pollDescription => 'Голосуйте за варианты, которые хотите видеть';

  @override
  String get submitVote => 'Голосовать';

  @override
  String get submitting => 'Отправка...';

  @override
  String get voteSubmittedSuccess => 'Голоса успешно отправлены!';

  @override
  String votesRemaining(int count) {
    return 'Осталось голосов: $count';
  }

  @override
  String get votes => 'голосов';

  @override
  String get addYourOption => 'Предложить улучшение';

  @override
  String get enterYourOption => 'Введите свой вариант...';

  @override
  String get add => 'Добавить';

  @override
  String get filterTopVoted => 'Популярные';

  @override
  String get filterNewest => 'Новые';

  @override
  String get filterMyOption => 'Мой выбор';

  @override
  String get thankYouForVoting => 'Спасибо за участие в голосовании!';

  @override
  String get votingComplete => 'Ваш голос учтен';

  @override
  String get requestFeatureDevelopment => 'Запросить разработку функции';

  @override
  String get requestFeatureDescription => 'Нужна особая функция? Свяжитесь с нами для обсуждения индивидуальной разработки под ваши бизнес-потребности.';

  @override
  String get pollHelpTitle => 'Как голосовать';

  @override
  String get pollHelpDescription => 'Дорогие пользователи, я хочу сделать приложение лучше. Пожалуйста, посоветуйте, как это сделать лучше?\n\n• Нажмите на вариант, чтобы выбрать его\n• Нажмите снова, чтобы снять выбор\n• Выбирайте столько вариантов, сколько хотите\n• Добавьте свой вариант, если не нашли нужный';

  @override
  String get developer => 'Разработчик';

  @override
  String get marketing_screen1_title => 'Instant Cosmetics Analysis';

  @override
  String get marketing_screen1_subtitle => 'Scan any product and discover what\'s inside';

  @override
  String get marketing_screen1_feature1 => 'AI-powered ingredient detection';

  @override
  String get marketing_screen1_feature2 => 'Safety ratings in seconds';

  @override
  String get marketing_screen1_feature3 => 'Works with any cosmetic product';

  @override
  String get marketing_screen2_title => 'Know What You\'re Putting On Your Skin';

  @override
  String get marketing_screen2_subtitle => 'Detailed analysis of every ingredient';

  @override
  String get marketing_screen2_feature1 => 'Personalized safety warnings';

  @override
  String get marketing_screen2_feature2 => 'Allergen detection';

  @override
  String get marketing_screen2_feature3 => 'Research-backed insights';

  @override
  String get marketing_screen3_title => 'Your AI Skincare Expert';

  @override
  String get marketing_screen3_subtitle => 'Get instant answers about any cosmetic ingredient';

  @override
  String get marketing_screen3_feature1 => '24/7 AI consultant';

  @override
  String get marketing_screen3_feature2 => 'Unlimited questions';

  @override
  String get marketing_screen4_title => 'Track Your Cosmetics';

  @override
  String get marketing_screen4_subtitle => 'Build your personal product database';

  @override
  String get marketing_screen4_feature1 => 'Full scan history';

  @override
  String get marketing_screen4_feature2 => 'Compare products side-by-side';

  @override
  String get marketing_screen5_title => 'Go Premium';

  @override
  String get marketing_screen5_subtitle => 'Unlock unlimited scans and expert features';

  @override
  String get marketing_screen5_feature1 => 'Unlimited product scans';

  @override
  String get marketing_screen5_feature2 => 'Advanced AI analysis';

  @override
  String get marketing_screen5_feature3 => 'Ad-free experience';
}
