// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appName => 'Определитель Рыб';

  @override
  String get appTagline => 'Распознавание рыб с помощью ИИ';

  @override
  String get tabCamera => 'Камера';

  @override
  String get tabHistory => 'История';

  @override
  String get tabCollection => 'Коллекция';

  @override
  String get tabChat => 'Чат';

  @override
  String get tabSettings => 'Настройки';

  @override
  String get cameraTitle => 'Определить рыбу';

  @override
  String get cameraHint => 'Сделайте фото или выберите из галереи';

  @override
  String get takePhoto => 'Сделать фото';

  @override
  String get selectFromGallery => 'Выбрать из галереи';

  @override
  String get identifyingFish => 'Определяю рыбу...';

  @override
  String get fishName => 'Название рыбы';

  @override
  String get scientificName => 'Научное название';

  @override
  String get habitat => 'Среда обитания';

  @override
  String get diet => 'Питание';

  @override
  String get funFacts => 'Интересные факты';

  @override
  String get confidence => 'Уверенность';

  @override
  String get edibility => 'Съедобность';

  @override
  String get cookingTips => 'Советы по приготовлению';

  @override
  String get fishingTips => 'Советы по ловле';

  @override
  String get conservationStatus => 'Охранный статус';

  @override
  String get edible => 'Съедобная';

  @override
  String get notRecommended => 'Не рекомендуется';

  @override
  String get toxic => 'Ядовитая';

  @override
  String get addToCollection => 'Добавить в коллекцию';

  @override
  String get chatAboutFish => 'Спросить об этой рыбе';

  @override
  String get shareResult => 'Поделиться';

  @override
  String get deleteResult => 'Удалить';

  @override
  String get collectionTitle => 'Моя коллекция';

  @override
  String get collectionEmpty => 'В вашей коллекции пока нет рыб';

  @override
  String get collectionHint => 'Начните определять рыб, чтобы создать коллекцию!';

  @override
  String get totalCatches => 'Всего уловов';

  @override
  String get favoriteFish => 'Избранные рыбы';

  @override
  String get addNotes => 'Добавить заметки';

  @override
  String get catchDetails => 'Детали улова';

  @override
  String get location => 'Место';

  @override
  String get date => 'Дата';

  @override
  String get weight => 'Вес';

  @override
  String get length => 'Длина';

  @override
  String get baitUsed => 'Использованная приманка';

  @override
  String get weatherConditions => 'Погода';

  @override
  String get chatTitle => 'Рыболовный ИИ-помощник';

  @override
  String get chatHint => 'Спросите меня о рыбах, рыбалке или приготовлении!';

  @override
  String get chatPlaceholder => 'Введите ваш вопрос...';

  @override
  String get chatSend => 'Отправить';

  @override
  String get chatSampleQuestions => 'Примеры вопросов';

  @override
  String get chatClear => 'Очистить чат';

  @override
  String get historyTitle => 'История определений';

  @override
  String get historyEmpty => 'Определений пока нет';

  @override
  String get historyHint => 'Ваши определённые рыбы появятся здесь';

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get settingsLanguage => 'Язык';

  @override
  String get settingsTheme => 'Тема';

  @override
  String get settingsThemeOcean => 'Океанская синева';

  @override
  String get settingsThemeDeep => 'Глубокое море';

  @override
  String get settingsThemeTropical => 'Тропические воды';

  @override
  String get settingsThemeKhaki => 'Камуфляж Хаки';

  @override
  String get settingsDarkMode => 'Тёмная тема';

  @override
  String get settingsAbout => 'О приложении';

  @override
  String get settingsClearData => 'Очистить все данные';

  @override
  String get settingsRate => 'Оценить приложение';

  @override
  String get settingsShare => 'Поделиться приложением';

  @override
  String get settingsFeedback => 'Отправить отзыв';

  @override
  String get confirmClearData => 'Очистить все данные?';

  @override
  String get confirmClearDataMessage => 'Это удалит все определения, элементы коллекции и историю чата. Это действие нельзя отменить.';

  @override
  String get confirm => 'Подтвердить';

  @override
  String get cancel => 'Отмена';

  @override
  String get errorTitle => 'Ошибка';

  @override
  String get errorNetwork => 'Ошибка сети. Проверьте подключение к интернету.';

  @override
  String get errorServiceOverloaded => 'Сервис временно перегружен. Попробуйте через минуту.';

  @override
  String get errorRateLimit => 'Слишком много запросов. Подождите немного.';

  @override
  String get errorInvalidResponse => 'Не удалось обработать ответ. Попробуйте ещё раз.';

  @override
  String get errorNotFish => 'Это не похоже на рыбу. Попробуйте другое изображение.';

  @override
  String get errorGeneral => 'Что-то пошло не так. Попробуйте ещё раз.';

  @override
  String get retry => 'Повторить';

  @override
  String get close => 'Закрыть';

  @override
  String get save => 'Сохранить';

  @override
  String get delete => 'Удалить';

  @override
  String get edit => 'Редактировать';

  @override
  String get done => 'Готово';

  @override
  String get yes => 'Да';

  @override
  String get no => 'Нет';

  @override
  String get feedback => 'Обратная связь';

  @override
  String catchNumber(Object number) {
    return 'Улов №$number';
  }

  @override
  String get shareComingSoon => 'Функция поделиться скоро появится!';

  @override
  String get dataCleared => 'Данные успешно очищены';

  @override
  String get openingAppStore => 'Открываем магазин приложений...';

  @override
  String get ratingTitle => 'Нравится приложение?';

  @override
  String get ratingMessage => 'Ваш отзыв помогает нам улучшать приложение!';

  @override
  String get rateNow => 'Оценить сейчас';

  @override
  String get maybeLater => 'Может быть, позже';

  @override
  String get noThanks => 'Нет, спасибо';

  @override
  String get surveyTitle => 'Помогите нам стать лучше!';

  @override
  String get surveyQuestion => 'Какую функцию вы хотели бы видеть следующей?';

  @override
  String get surveyOption1 => 'Социальная лента для обмена уловами';

  @override
  String get surveyOption2 => 'Рекомендации мест для рыбалки';

  @override
  String get surveyOption3 => 'Прогнозы на основе погоды';

  @override
  String get surveyOption4 => 'База рецептов';

  @override
  String get surveySubmit => 'Отправить';

  @override
  String get surveyThankYou => 'Спасибо за ваш отзыв!';

  @override
  String get premiumTitle => 'Перейти на Premium';

  @override
  String get premiumFeature1 => 'Неограниченные определения';

  @override
  String get premiumFeature2 => 'Неограниченный AI-чат';

  @override
  String get premiumFeature3 => 'Отслеживание GPS';

  @override
  String get premiumFeature4 => 'Расширенная статистика';

  @override
  String get premiumFeature5 => 'Резервное копирование в облако';

  @override
  String get premiumFeature6 => 'Без рекламы';

  @override
  String get premiumPrice => '\$4.99/месяц или \$29.99/год';

  @override
  String get premiumUpgrade => 'Улучшить сейчас';

  @override
  String get premiumRestore => 'Восстановить покупку';
}
