// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get appName => 'AI Cosmetic Scanner';

  @override
  String get appTitle => 'MAS - Math AI Solver';

  @override
  String get chooseMode => 'Choose Mode';

  @override
  String get mathAiAssistant => 'AI assistant for solving math problems';

  @override
  String get solve => 'Solve';

  @override
  String get solveWithAI => 'Solve problem with AI';

  @override
  String get check => 'Check';

  @override
  String get checkSolution => 'Check your solution';

  @override
  String get train => 'Train';

  @override
  String get trainOnProblems => 'Practice on similar problems';

  @override
  String get unitConverter => 'Unit Converter';

  @override
  String get unitConverterDesc => 'g→kg, cm→m, °C→°F';

  @override
  String get mathChat => 'Math Chat';

  @override
  String get askQuestions => 'Ask questions to Math AI';

  @override
  String get history => 'History';

  @override
  String get startScanning => 'Почати сканування';

  @override
  String get quickActions => 'Швидкі дії';

  @override
  String get scanHistory => 'Історія сканування';

  @override
  String get aiChat => 'Чат зі ШІ';

  @override
  String get profile => 'Профіль';

  @override
  String get settings => 'Налаштування';

  @override
  String get skinType => 'Тип шкіри';

  @override
  String get allergiesSensitivities => 'Алергії та чутливість';

  @override
  String get subscription => 'Підписка';

  @override
  String get age => 'Вік';

  @override
  String get language => 'Мова';

  @override
  String get selectYourPreferredLanguage => 'Оберіть бажану мову';

  @override
  String get save => 'Зберегти';

  @override
  String get language_en => 'Англійська';

  @override
  String get language_ru => 'Російська';

  @override
  String get language_uk => 'Українська';

  @override
  String get language_es => 'Іспанська';

  @override
  String get language_de => 'Німецька';

  @override
  String get language_fr => 'Французька';

  @override
  String get language_it => 'Італійська';

  @override
  String get language_ar => 'العربية';

  @override
  String get language_ko => '한국어';

  @override
  String get language_cs => 'Čeština';

  @override
  String get language_da => 'Dansk';

  @override
  String get language_el => 'Ελληνικά';

  @override
  String get language_fi => 'Suomi';

  @override
  String get language_hi => 'हिन्दी';

  @override
  String get language_hu => 'Magyar';

  @override
  String get language_id => 'Bahasa Indonesia';

  @override
  String get language_ja => '日本語';

  @override
  String get language_nl => 'Nederlands';

  @override
  String get language_no => 'Norsk';

  @override
  String get language_pl => 'Polski';

  @override
  String get language_pt => 'Português';

  @override
  String get language_ro => 'Română';

  @override
  String get language_sv => 'Svenska';

  @override
  String get language_th => 'ไทย';

  @override
  String get language_tr => 'Türkçe';

  @override
  String get language_vi => 'Tiếng Việt';

  @override
  String get language_zh => '中文';

  @override
  String get selectIngredientsAllergicSensitive => 'Оберіть інгредієнти, на які у вас підвищена чутливість';

  @override
  String get commonAllergens => 'Поширені алергени';

  @override
  String get fragrance => 'Ароматизатор';

  @override
  String get parabens => 'Парабени';

  @override
  String get sulfates => 'Сульфати';

  @override
  String get alcohol => 'Спирт';

  @override
  String get essentialOils => 'Ефірні масла';

  @override
  String get silicones => 'Силікони';

  @override
  String get mineralOil => 'Мінеральна олія';

  @override
  String get formaldehyde => 'Формальдегід';

  @override
  String get addCustomAllergen => 'Додати власний алерген';

  @override
  String get typeIngredientName => 'Введіть назву інгредієнта...';

  @override
  String get selectedAllergens => 'Обрані алергени';

  @override
  String saveSelected(int count) {
    return 'Зберегти ($count обрано)';
  }

  @override
  String get analysisResults => 'Результати аналізу';

  @override
  String get overallSafetyScore => 'Загальний бал безпеки';

  @override
  String get personalizedWarnings => 'Персоналізовані попередження';

  @override
  String ingredientsAnalysis(int count) {
    return 'Аналіз інгредієнтів ($count)';
  }

  @override
  String get highRisk => 'Високий ризик';

  @override
  String get moderateRisk => 'Помірний ризик';

  @override
  String get lowRisk => 'Низький ризик';

  @override
  String get benefitsAnalysis => 'Аналіз переваг';

  @override
  String get recommendedAlternatives => 'Рекомендовані альтернативи';

  @override
  String get reason => 'Причина:';

  @override
  String get quickSummary => 'Швидкий огляд';

  @override
  String get ingredientsChecked => 'інгредієнтів перевірено';

  @override
  String get personalWarnings => 'персональних попереджень';

  @override
  String get ourVerdict => 'Наш вердикт';

  @override
  String get productInfo => 'Інформація про продукт';

  @override
  String get productType => 'Тип продукту';

  @override
  String get brand => 'Бренд';

  @override
  String get premiumInsights => 'Premium Insights';

  @override
  String get researchArticles => 'Наукові дослідження';

  @override
  String get categoryRanking => 'Рейтинг в категорії';

  @override
  String get safetyTrend => 'Тренд безпеки';

  @override
  String get saveToFavorites => 'В обране';

  @override
  String get shareResults => 'Поділитися';

  @override
  String get compareProducts => 'Порівняти';

  @override
  String get exportPDF => 'PDF';

  @override
  String get scanSimilar => 'Схожий';

  @override
  String get aiChatTitle => 'Чат зі ШІ';

  @override
  String get typeYourMessage => 'Введіть ваше повідомлення...';

  @override
  String get errorSupabaseClientNotInitialized => 'Помилка: клієнт Supabase не ініціалізовано.';

  @override
  String get serverError => 'Помилка сервера:';

  @override
  String get networkErrorOccurred => 'Сталася помилка мережі. Будь ласка, спробуйте пізніше.';

  @override
  String get sorryAnErrorOccurred => 'Вибачте, сталася помилка. Будь ласка, спробуйте ще раз.';

  @override
  String get couldNotGetResponse => 'Не вдалося отримати відповідь.';

  @override
  String get aiAssistant => 'ШІ-помічник';

  @override
  String get online => 'В мережі';

  @override
  String get typing => 'Друкує...';

  @override
  String get writeAMessage => 'Написати повідомлення...';

  @override
  String get hiIAmYourAIAssistantHowCanIHelp => 'Привіт! Я ваш ШІ-помічник. Чим можу вам допомогти?';

  @override
  String get iCanSeeYourScanResultsFeelFreeToAskMeAnyQuestionsAboutTheIngredientsSafetyConcernsOrRecommendations => 'Я бачу ваші результати сканування! Не соромтеся задавати мені будь-які запитання про інгредієнти, питання безпеки або рекомендації.';

  @override
  String get userQuestion => 'Питання користувача:';

  @override
  String get databaseExplorer => 'Оглядач бази даних';

  @override
  String get currentUser => 'Поточний користувач:';

  @override
  String get notSignedIn => 'Не увійшли в систему';

  @override
  String get failedToFetchTables => 'Не вдалося отримати таблиці:';

  @override
  String get tablesInYourSupabaseDatabase => 'Таблиці у вашій базі даних Supabase:';

  @override
  String get viewSampleData => 'Переглянути приклад даних';

  @override
  String get failedToFetchSampleDataFor => 'Не вдалося отримати приклад даних для';

  @override
  String get sampleData => 'Приклад даних:';

  @override
  String get aiChats => 'Чати зі ШІ';

  @override
  String get noDialoguesYet => 'Діалогів поки немає.';

  @override
  String get startANewChat => 'Почати новий чат!';

  @override
  String get created => 'Створено:';

  @override
  String get failedToSaveImage => 'Не вдалося зберегти зображення:';

  @override
  String get editName => 'Редагувати ім\'я';

  @override
  String get enterYourName => 'Введіть ваше ім\'я';

  @override
  String get cancel => 'Скасувати';

  @override
  String get premiumUser => 'Преміум-користувач';

  @override
  String get freeUser => 'Безкоштовний користувач';

  @override
  String get skinProfile => 'Профіль шкіри';

  @override
  String get notSet => 'Не встановлено';

  @override
  String get legal => 'Юридична інформація';

  @override
  String get privacyPolicy => 'Політика конфіденційності';

  @override
  String get termsOfService => 'Умови надання послуг';

  @override
  String get dataManagement => 'Керування даними';

  @override
  String get clearAllData => 'Очистити всі дані';

  @override
  String get clearAllDataConfirmation => 'Ви впевнені, що хочете видалити всі ваші локальні дані? Цю дію не можна скасувати.';

  @override
  String get selectDataToClear => 'Оберіть дані для очищення';

  @override
  String get scanResults => 'Сканування';

  @override
  String get chatHistory => 'Чати';

  @override
  String get personalData => 'Особисті дані';

  @override
  String get clearData => 'Очистити дані';

  @override
  String get allLocalDataHasBeenCleared => 'Дані були очищені.';

  @override
  String get signOut => 'Вийти';

  @override
  String get deleteScan => 'Видалити сканування';

  @override
  String get deleteScanConfirmation => 'Ви впевнені, що хочете видалити це сканування з вашої історії?';

  @override
  String get deleteChat => 'Видалити чат';

  @override
  String get deleteChatConfirmation => 'Ви впевнені, що хочете видалити цей чат? Усі повідомлення буде втрачено.';

  @override
  String get delete => 'Видалити';

  @override
  String get noScanHistoryFound => 'Історію сканування не знайдено.';

  @override
  String get scanOn => 'Сканування';

  @override
  String get ingredientsFound => 'інгредієнтів знайдено';

  @override
  String get noCamerasFoundOnThisDevice => 'На цьому пристрої не знайдено камер.';

  @override
  String get failedToInitializeCamera => 'Не вдалося ініціалізувати камеру:';

  @override
  String get analysisFailed => 'Аналіз не вдався:';

  @override
  String get analyzingPleaseWait => 'Аналізуємо, зачекайте...';

  @override
  String get positionTheLabelWithinTheFrame => 'Наведіть камеру на список інгредієнтів';

  @override
  String get createAccount => 'Створити обліковий запис';

  @override
  String get signUpToGetStarted => 'Зареєструйтеся, щоб почати';

  @override
  String get fullName => 'Повне ім\'я';

  @override
  String get pleaseEnterYourName => 'Будь ласка, введіть ваше ім\'я';

  @override
  String get email => 'Електронна пошта';

  @override
  String get pleaseEnterYourEmail => 'Будь ласка, введіть вашу електронну пошту';

  @override
  String get pleaseEnterAValidEmail => 'Будь ласка, введіть дійсну адресу електронної пошти';

  @override
  String get password => 'Пароль';

  @override
  String get pleaseEnterYourPassword => 'Будь ласка, введіть ваш пароль';

  @override
  String get passwordMustBeAtLeast6Characters => 'Пароль має містити принаймні 6 символів';

  @override
  String get signUp => 'Зареєструватися';

  @override
  String get orContinueWith => 'або продовжити з';

  @override
  String get google => 'Google';

  @override
  String get apple => 'Apple';

  @override
  String get alreadyHaveAnAccount => 'Вже маєте обліковий запис? ';

  @override
  String get signIn => 'Увійти';

  @override
  String get selectYourSkinTypeDescription => 'Оберіть тип вашої шкіри';

  @override
  String get normal => 'Нормальна';

  @override
  String get normalSkinDescription => 'Збалансована, не надто жирна і не суха';

  @override
  String get dry => 'Суха';

  @override
  String get drySkinDescription => 'Натягнута, лущиться, груба текстура';

  @override
  String get oily => 'Жирна';

  @override
  String get oilySkinDescription => 'Блискуча, великі пори, схильна до акне';

  @override
  String get combination => 'Комбінована';

  @override
  String get combinationSkinDescription => 'Жирна Т-зона, сухі щоки';

  @override
  String get sensitive => 'Чутлива';

  @override
  String get sensitiveSkinDescription => 'Легко подразнюється, схильна до почервоніння';

  @override
  String get selectSkinType => 'Обрати тип шкіри';

  @override
  String get restore => 'Відновити';

  @override
  String get restorePurchases => 'Відновити покупки';

  @override
  String get subscriptionRestored => 'Підписку успішно відновлено!';

  @override
  String get noPurchasesToRestore => 'Немає покупок для відновлення';

  @override
  String get goPremium => 'Перейти на Преміум';

  @override
  String get unlockExclusiveFeatures => 'Розблокуйте ексклюзивні функції, щоб отримати максимум від аналізу вашої шкіри.';

  @override
  String get unlimitedProductScans => 'Необмежена кількість сканувань продуктів';

  @override
  String get advancedAIIngredientAnalysis => 'Розширений ШІ-аналіз інгредієнтів';

  @override
  String get fullScanAndSearchHistory => 'Повна історія сканувань та пошуку';

  @override
  String get adFreeExperience => '100% без реклами';

  @override
  String get yearly => 'Щорічно';

  @override
  String savePercentage(int percentage) {
    return 'Економія $percentage%';
  }

  @override
  String get monthly => 'Щомісячно';

  @override
  String get perMonth => '/ місяць';

  @override
  String get startFreeTrial => 'Почати безкоштовний період';

  @override
  String trialDescription(String planName) {
    return '7-денна безкоштовна пробна версія, потім стягується плата $planName. Скасувати можна в будь-який час.';
  }

  @override
  String get home => 'Головна';

  @override
  String get scan => 'Скан';

  @override
  String get aiChatNav => 'Чат';

  @override
  String get profileNav => 'Профіль';

  @override
  String get doYouEnjoyOurApp => 'Вам подобається наш застосунок?';

  @override
  String get notReally => 'Ні';

  @override
  String get yesItsGreat => 'Подобається';

  @override
  String get rateOurApp => 'Оцініть наш застосунок';

  @override
  String get bestRatingWeCanGet => 'Найкраща оцінка, яку ми можемо отримати';

  @override
  String get rateOnGooglePlay => 'Оцінити в Google Play';

  @override
  String get rate => 'Оцінити';

  @override
  String get whatCanBeImproved => 'Що можна вдосконалити?';

  @override
  String get wereSorryYouDidntHaveAGreatExperience => 'Нам шкода, що ви залишилися незадоволені. Будь ласка, повідомте нам, що пішло не так.';

  @override
  String get yourFeedback => 'Ваш відгук...';

  @override
  String get sendFeedback => 'Надіслати відгук';

  @override
  String get thankYouForYourFeedback => 'Дякуємо за ваш відгук!';

  @override
  String get discussWithAI => 'Обговорити зі ШІ';

  @override
  String get enterYourEmail => 'Введіть вашу електронну пошту';

  @override
  String get enterYourPassword => 'Введіть ваш пароль';

  @override
  String get aiDisclaimer => 'Відповіді ШІ можуть містити неточності. Будь ласка, перевіряйте критичну інформацію.';

  @override
  String get applicationThemes => 'Теми застосунку';

  @override
  String get highestRating => 'Найвища оцінка';

  @override
  String get selectYourAgeDescription => 'Оберіть ваш вік';

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
  String get ageRange18_25Description => 'Молода шкіра, профілактика';

  @override
  String get ageRange26_35Description => 'Перші ознаки старіння';

  @override
  String get ageRange36_45Description => 'Антивіковий догляд';

  @override
  String get ageRange46_55Description => 'Інтенсивний догляд';

  @override
  String get ageRange56PlusDescription => 'Спеціалізований догляд';

  @override
  String get userName => 'Ваше ім\'я';

  @override
  String get tryFreeAndSubscribe => 'Спробувати безкоштовно та підписатися';

  @override
  String get personalAIConsultant => 'Персональний ШІ-консультант 24/7';

  @override
  String get subscribe => 'Підписатися';

  @override
  String get themes => 'Теми';

  @override
  String get selectPreferredTheme => 'Оберіть бажану тему';

  @override
  String get naturalTheme => 'Природна';

  @override
  String get darkTheme => 'Темна';

  @override
  String get darkNatural => 'Темна Природна';

  @override
  String get oceanTheme => 'Океан';

  @override
  String get forestTheme => 'Ліс';

  @override
  String get sunsetTheme => 'Захід';

  @override
  String get naturalThemeDescription => 'Природна тема з екологічними кольорами';

  @override
  String get darkThemeDescription => 'Темна тема для комфорту очей';

  @override
  String get oceanThemeDescription => 'Свіжа океанічна тема';

  @override
  String get forestThemeDescription => 'Природна лісова тема';

  @override
  String get sunsetThemeDescription => 'Тепла тема в тонах заходу';

  @override
  String get sunnyTheme => 'Сонячна';

  @override
  String get sunnyThemeDescription => 'Яскрава та життєрадісна жовта тема';

  @override
  String get vibrantTheme => 'Яскрава';

  @override
  String get vibrantThemeDescription => 'Яскрава рожево-фіолетова тема';

  @override
  String get scanAnalysis => 'Аналіз сканування';

  @override
  String get ingredients => 'інгредієнтів';

  @override
  String get aiBotSettings => 'Налаштування ШІ';

  @override
  String get botName => 'Ім\'я бота';

  @override
  String get enterBotName => 'Введіть ім\'я бота';

  @override
  String get pleaseEnterBotName => 'Будь ласка, введіть ім\'я бота';

  @override
  String get botDescription => 'Опис бота';

  @override
  String get selectAvatar => 'Обрати аватар';

  @override
  String get defaultBotName => 'ACS';

  @override
  String defaultBotDescription(String name) {
    return 'Привіт! Я $name (AI Cosmetic Scanner). Допоможу вам розібратися зі складом вашої косметики. Маю великі знання в галузі косметології та догляду за шкірою. Із задоволенням відповім на всі ваші запитання.';
  }

  @override
  String get settingsSaved => 'Налаштування успішно збережено';

  @override
  String get failedToSaveSettings => 'Не вдалося зберегти налаштування';

  @override
  String get resetToDefault => 'Скинути до стандартних';

  @override
  String get resetSettings => 'Скинути налаштування';

  @override
  String get resetSettingsConfirmation => 'Ви впевнені, що хочете скинути всі налаштування до стандартних значень?';

  @override
  String get settingsResetSuccessfully => 'Налаштування успішно скинуто';

  @override
  String get failedToResetSettings => 'Не вдалося скинути налаштування';

  @override
  String get unsavedChanges => 'Незбережені зміни';

  @override
  String get unsavedChangesMessage => 'У вас є незбережені зміни. Ви впевнені, що хочете вийти?';

  @override
  String get stay => 'Залишитися';

  @override
  String get leave => 'Вийти';

  @override
  String get errorLoadingSettings => 'Помилка завантаження налаштувань';

  @override
  String get retry => 'Повторити';

  @override
  String get customPrompt => 'Особливі побажання';

  @override
  String get customPromptDescription => 'Додайте персоналізовані інструкції для ШІ-асистента';

  @override
  String get customPromptPlaceholder => 'Введіть ваші особливі побажання...';

  @override
  String get enableCustomPrompt => 'Увімкнути особливі побажання';

  @override
  String get defaultCustomPrompt => 'Говори мені компліменти.';

  @override
  String get close => 'Закрити';

  @override
  String get scanningHintTitle => 'Як сканувати';

  @override
  String get scanLimitReached => 'Ліміт сканувань досягнуто';

  @override
  String get scanLimitReachedMessage => 'Ви використали всі 5 безкоштовних сканувань на цьому тижні. Оформіть підписку Premium для необмеженої кількості сканувань!';

  @override
  String get messageLimitReached => 'Daily Message Limit Reached';

  @override
  String get messageLimitReachedMessage => 'You\'ve sent 5 messages today. Upgrade to Premium for unlimited chat!';

  @override
  String get historyLimitReached => 'History Access Limited';

  @override
  String get historyLimitReachedMessage => 'Оформіть підписку Premium для доступу до повної історії сканувань!';

  @override
  String get upgradeToPremium => 'Оформити Premium';

  @override
  String get upgradeToView => 'Переглянути з Premium';

  @override
  String get upgradeToChat => 'Upgrade to Chat';

  @override
  String get premiumFeature => 'Функція Premium';

  @override
  String get freePlanUsage => 'Free Plan Usage';

  @override
  String get scansThisWeek => 'Scans this week';

  @override
  String get messagesToday => 'Messages today';

  @override
  String get limitsReached => 'Limits reached';

  @override
  String get remainingScans => 'Remaining scans';

  @override
  String get remainingMessages => 'Remaining messages';

  @override
  String get unlockUnlimitedAccess => 'Unlock Unlimited Access';

  @override
  String get upgradeToPremiumDescription => 'Get unlimited scans, messages, and full access to your scan history with Premium!';

  @override
  String get premiumBenefits => 'Premium Benefits';

  @override
  String get unlimitedAiChatMessages => 'Unlimited AI chat messages';

  @override
  String get fullAccessToScanHistory => 'Full access to scan history';

  @override
  String get prioritySupport => 'Priority support';

  @override
  String get learnMore => 'Learn More';

  @override
  String get upgradeNow => 'Upgrade Now';

  @override
  String get maybeLater => 'Maybe Later';

  @override
  String get scanHistoryLimit => 'Only the most recent scan is visible in history';

  @override
  String get upgradeForUnlimitedScans => 'Upgrade for unlimited scans!';

  @override
  String get upgradeForUnlimitedChat => 'Upgrade for unlimited chat!';

  @override
  String get slowInternetConnection => 'Повільне інтернет-з\'єднання';

  @override
  String get slowInternetMessage => 'На дуже повільному інтернеті доведеться трохи зачекати... Ми все ще аналізуємо ваше зображення.';

  @override
  String get revolutionaryAI => 'Революційний ШІ';

  @override
  String get revolutionaryAIDesc => 'Один з найрозумніших у світі';

  @override
  String get unlimitedScans => 'Необмежені сканування';

  @override
  String get unlimitedScansDesc => 'Вивчайте косметику без обмежень';

  @override
  String get unlimitedChats => 'Необмежені чати';

  @override
  String get unlimitedChatsDesc => 'Персональний ШІ-консультант 24/7';

  @override
  String get fullHistory => 'Повна історія';

  @override
  String get fullHistoryDesc => 'Необмежена історія сканувань';

  @override
  String get rememberContext => 'Пам\'ятає контекст';

  @override
  String get rememberContextDesc => 'ШІ пам\'ятає ваші попередні повідомлення';

  @override
  String get allIngredientsInfo => 'Вся інформація про інгредієнти';

  @override
  String get allIngredientsInfoDesc => 'Дізнайся всі подробиці';

  @override
  String get noAds => '100% без реклами';

  @override
  String get noAdsDesc => 'Для тих, хто цінує свій час';

  @override
  String get multiLanguage => 'Знає майже всі мови світу';

  @override
  String get multiLanguageDesc => 'Покращений перекладач';

  @override
  String get paywallTitle => 'Розкрийте секрети вашої косметики за допомогою ШІ';

  @override
  String paywallDescription(String price) {
    return 'У вас є можливість отримати Преміум-версію підписки на 3 дні безкоштовно, потім $price на тиждень. Скасування в будь-який час.';
  }

  @override
  String get whatsIncluded => 'Що включено';

  @override
  String get basicPlan => 'Базова';

  @override
  String get premiumPlan => 'Преміум';

  @override
  String get botGreeting1 => 'Добрий день! Чим я можу вам допомогти сьогодні?';

  @override
  String get botGreeting2 => 'Вітаю! Що привело вас до мене?';

  @override
  String get botGreeting3 => 'Привітую вас! Готовий допомогти з аналізом косметики.';

  @override
  String get botGreeting4 => 'Радий вас бачити! Чим можу бути корисним?';

  @override
  String get botGreeting5 => 'Ласкаво просимо! Давайте разом вивчимо склад вашої косметики.';

  @override
  String get botGreeting6 => 'Вітаю! Готовий відповісти на ваші запитання про косметику.';

  @override
  String get botGreeting7 => 'Привіт! Я ваш персональний помічник з косметології.';

  @override
  String get botGreeting8 => 'Добрий день! Допоможу розібратися зі складом косметичних засобів.';

  @override
  String get botGreeting9 => 'Вітаю! Давайте зробимо вашу косметику безпечнішою.';

  @override
  String get botGreeting10 => 'Привітую! Готовий поділитися знаннями про косметику.';

  @override
  String get botGreeting11 => 'Добрий день! Допоможу знайти найкращі косметичні рішення для вас.';

  @override
  String get botGreeting12 => 'Вітаю! Ваш експерт з безпеки косметики до ваших послуг.';

  @override
  String get botGreeting13 => 'Привіт! Давайте разом підберемо ідеальну косметику для вас.';

  @override
  String get botGreeting14 => 'Ласкаво просимо! Готовий допомогти з аналізом інгредієнтів.';

  @override
  String get botGreeting15 => 'Вітаю! Допоможу зрозуміти склад вашої косметики.';

  @override
  String get botGreeting16 => 'Привітую! Ваш гід у світі косметології готовий допомогти.';

  @override
  String get copiedToClipboard => 'Скопійовано в буфер обміну';

  @override
  String get tryFree => 'Спробувати безкоштовно';

  @override
  String get cameraNotReady => 'Камера не готова / немає дозволу';

  @override
  String get cameraPermissionInstructions => 'Налаштування застосунку:\nAI Cosmetic Scanner > Дозволи > Камера > Дозволити';

  @override
  String get openSettingsAndGrantAccess => 'Відкрийте Налаштування і надайте доступ до камери';

  @override
  String get retryCamera => 'Повторити';

  @override
  String get errorServiceOverloaded => 'Сервіс тимчасово перевантажений. Спробуйте через кілька секунд.';

  @override
  String get errorRateLimitExceeded => 'Занадто багато запитів. Зачекайте трохи і спробуйте знову.';

  @override
  String get errorTimeout => 'Перевищено час очікування. Перевірте підключення до інтернету і спробуйте знову.';

  @override
  String get errorNetwork => 'Помилка мережі. Перевірте підключення до інтернету.';

  @override
  String get errorAuthentication => 'Помилка автентифікації. Будь ласка, перезапустіть застосунок.';

  @override
  String get errorInvalidResponse => 'Отримано некоректну відповідь. Спробуйте знову.';

  @override
  String get errorServer => 'Помилка сервера. Спробуйте пізніше.';

  @override
  String get customThemes => 'Кастомні теми';

  @override
  String get createCustomTheme => 'Створити кастомну тему';

  @override
  String get basedOn => 'На основі';

  @override
  String get lightMode => 'Світла';

  @override
  String get generateWithAI => 'Генерація з AI';

  @override
  String get resetToBaseTheme => 'Скинути до базової теми';

  @override
  String colorsResetTo(Object themeName) {
    return 'Кольори скинуті до $themeName';
  }

  @override
  String get aiGenerationComingSoon => 'Генерація тем з AI буде в Iteration 5!';

  @override
  String get onboardingGreeting => 'Ласкаво просимо! Щоб поліпшити якість відповідей, налаштуйте ваш профіль';

  @override
  String get letsGo => 'Поїхали';

  @override
  String get next => 'Далі';

  @override
  String get finish => 'Завершити';

  @override
  String get customThemeInDevelopment => 'Функція кастомних тем знаходиться в розробці';

  @override
  String get customThemeComingSoon => 'Скоро буде доступно в майбутніх оновленнях';

  @override
  String get dailyMessageLimitReached => 'Ліміт досягнуто';

  @override
  String get dailyMessageLimitReachedMessage => 'Ви надіслали 5 повідомлень сьогодні. Оформіть підписку Premium для необмеженого чату!';

  @override
  String get upgradeToPremiumForUnlimitedChat => 'Оформити Premium для необмеженого чату';

  @override
  String get messagesLeftToday => 'повідомлень залишилось на сьогодні';

  @override
  String get designYourOwnTheme => 'Створіть власну тему';

  @override
  String get darkOcean => 'Темний океан';

  @override
  String get darkForest => 'Темний ліс';

  @override
  String get darkSunset => 'Темний захід';

  @override
  String get darkVibrant => 'Темна яскрава';

  @override
  String get darkOceanThemeDescription => 'Темна океанічна тема з блакитними акцентами';

  @override
  String get darkForestThemeDescription => 'Темна лісова тема з лаймовими акцентами';

  @override
  String get darkSunsetThemeDescription => 'Темна тема заходу з помаранчевими акцентами';

  @override
  String get darkVibrantThemeDescription => 'Темна яскрава тема з рожевими та фіолетовими акцентами';

  @override
  String get customTheme => 'Кастомна тема';

  @override
  String get edit => 'Редагувати';

  @override
  String get deleteTheme => 'Видалити тему';

  @override
  String deleteThemeConfirmation(String themeName) {
    return 'Ви впевнені, що хочете видалити \"$themeName\"?';
  }

  @override
  String get pollTitle => 'Чого не вистачає?';

  @override
  String get pollCardTitle => 'Чого не вистачає в додатку?';

  @override
  String get pollCardSubtitle => 'Які 3 функції потрібно додати в додаток?';

  @override
  String get pollDescription => 'Голосуйте за варіанти, які хочете бачити';

  @override
  String get submitVote => 'Голосувати';

  @override
  String get submitting => 'Відправка...';

  @override
  String get voteSubmittedSuccess => 'Голоси успішно відправлено!';

  @override
  String votesRemaining(int count) {
    return 'Залишилось голосів: $count';
  }

  @override
  String get votes => 'голосів';

  @override
  String get addYourOption => 'Запропонувати покращення';

  @override
  String get enterYourOption => 'Введіть свій варіант...';

  @override
  String get add => 'Додати';

  @override
  String get filterTopVoted => 'Популярні';

  @override
  String get filterNewest => 'Нові';

  @override
  String get filterMyOption => 'Мій вибір';

  @override
  String get thankYouForVoting => 'Дякуємо за участь у голосуванні!';

  @override
  String get votingComplete => 'Ваш голос враховано';

  @override
  String get requestFeatureDevelopment => 'Запросити розробку функції';

  @override
  String get requestFeatureDescription => 'Потрібна особлива функція? Зв\'яжіться із нами для обговорення індивідуальної розробки під ваші бізнес-потреби.';

  @override
  String get pollHelpTitle => 'Як голосувати';

  @override
  String get pollHelpDescription => '• Натисніть на варіант, щоб вибрати його\n• Натисніть знову, щоб скасувати вибір\n• Вибирайте стільки варіантів, скільки хочете\n• Натисніть кнопку \'Голосувати\' для відправки голосів\n• Додайте свій варіант, якщо не знайшли потрібний';
}
