import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_uk.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
    Locale('uk'),
  ];

  /// Application name
  ///
  /// In en, this message translates to:
  /// **'Plant Identifier'**
  String get appName;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @scan.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get scan;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Identify Plants & Mushrooms'**
  String get homeTitle;

  /// No description provided for @homeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Take a photo or upload an image to identify any plant, flower, tree, or mushroom instantly.'**
  String get homeSubtitle;

  /// No description provided for @identifyPlant.
  ///
  /// In en, this message translates to:
  /// **'Identify Plant'**
  String get identifyPlant;

  /// No description provided for @viewHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get viewHistory;

  /// No description provided for @viewHistoryDesc.
  ///
  /// In en, this message translates to:
  /// **'View your past identifications'**
  String get viewHistoryDesc;

  /// No description provided for @aboutApp.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutApp;

  /// No description provided for @aboutAppDesc.
  ///
  /// In en, this message translates to:
  /// **'Learn more about plant identification'**
  String get aboutAppDesc;

  /// No description provided for @scanTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan Plant'**
  String get scanTitle;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get takePhoto;

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get chooseFromGallery;

  /// No description provided for @scanDescription.
  ///
  /// In en, this message translates to:
  /// **'Take a photo or select from gallery to identify plants'**
  String get scanDescription;

  /// No description provided for @historyTitle.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get historyTitle;

  /// No description provided for @noHistory.
  ///
  /// In en, this message translates to:
  /// **'No History Yet'**
  String get noHistory;

  /// No description provided for @noHistoryDesc.
  ///
  /// In en, this message translates to:
  /// **'Start identifying plants to see your history here'**
  String get noHistoryDesc;

  /// No description provided for @clearHistory.
  ///
  /// In en, this message translates to:
  /// **'Clear History'**
  String get clearHistory;

  /// No description provided for @clearHistoryConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to clear all history?'**
  String get clearHistoryConfirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @environmentalConditions.
  ///
  /// In en, this message translates to:
  /// **'Environmental Conditions'**
  String get environmentalConditions;

  /// No description provided for @temperature.
  ///
  /// In en, this message translates to:
  /// **'Temperature'**
  String get temperature;

  /// No description provided for @humidity.
  ///
  /// In en, this message translates to:
  /// **'Humidity'**
  String get humidity;

  /// No description provided for @notSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get notSet;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @showToxicWarnings.
  ///
  /// In en, this message translates to:
  /// **'Show Toxic Warnings'**
  String get showToxicWarnings;

  /// No description provided for @careReminders.
  ///
  /// In en, this message translates to:
  /// **'Care Reminders'**
  String get careReminders;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @setTemperature.
  ///
  /// In en, this message translates to:
  /// **'Set Temperature'**
  String get setTemperature;

  /// No description provided for @setTemperatureDesc.
  ///
  /// In en, this message translates to:
  /// **'Enter average temperature in Celsius'**
  String get setTemperatureDesc;

  /// No description provided for @temperatureLabel.
  ///
  /// In en, this message translates to:
  /// **'Temperature (°C)'**
  String get temperatureLabel;

  /// No description provided for @temperatureHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., 22.5'**
  String get temperatureHint;

  /// No description provided for @setHumidity.
  ///
  /// In en, this message translates to:
  /// **'Set Humidity'**
  String get setHumidity;

  /// No description provided for @setHumidityDesc.
  ///
  /// In en, this message translates to:
  /// **'Enter average humidity percentage'**
  String get setHumidityDesc;

  /// No description provided for @humidityLabel.
  ///
  /// In en, this message translates to:
  /// **'Humidity (%)'**
  String get humidityLabel;

  /// No description provided for @humidityHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., 65'**
  String get humidityHint;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @themeGreenNature.
  ///
  /// In en, this message translates to:
  /// **'Green Nature'**
  String get themeGreenNature;

  /// No description provided for @themeForest.
  ///
  /// In en, this message translates to:
  /// **'Forest'**
  String get themeForest;

  /// No description provided for @themeBotanical.
  ///
  /// In en, this message translates to:
  /// **'Botanical Garden'**
  String get themeBotanical;

  /// No description provided for @themeMushroom.
  ///
  /// In en, this message translates to:
  /// **'Mushroom'**
  String get themeMushroom;

  /// No description provided for @themeDarkGreen.
  ///
  /// In en, this message translates to:
  /// **'Dark Green'**
  String get themeDarkGreen;

  /// No description provided for @chooseTheme.
  ///
  /// In en, this message translates to:
  /// **'Choose Theme'**
  String get chooseTheme;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose Language'**
  String get chooseLanguage;

  /// No description provided for @plantName.
  ///
  /// In en, this message translates to:
  /// **'Plant Name'**
  String get plantName;

  /// No description provided for @scientificName.
  ///
  /// In en, this message translates to:
  /// **'Scientific Name'**
  String get scientificName;

  /// No description provided for @commonNames.
  ///
  /// In en, this message translates to:
  /// **'Common Names'**
  String get commonNames;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @family.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get family;

  /// No description provided for @origin.
  ///
  /// In en, this message translates to:
  /// **'Origin'**
  String get origin;

  /// No description provided for @toxicity.
  ///
  /// In en, this message translates to:
  /// **'Toxicity'**
  String get toxicity;

  /// No description provided for @toxic.
  ///
  /// In en, this message translates to:
  /// **'Toxic'**
  String get toxic;

  /// No description provided for @nonToxic.
  ///
  /// In en, this message translates to:
  /// **'Non-toxic'**
  String get nonToxic;

  /// No description provided for @edibility.
  ///
  /// In en, this message translates to:
  /// **'Edibility'**
  String get edibility;

  /// No description provided for @edible.
  ///
  /// In en, this message translates to:
  /// **'Edible'**
  String get edible;

  /// No description provided for @nonEdible.
  ///
  /// In en, this message translates to:
  /// **'Non-edible'**
  String get nonEdible;

  /// No description provided for @usesAndBenefits.
  ///
  /// In en, this message translates to:
  /// **'Uses and Benefits'**
  String get usesAndBenefits;

  /// No description provided for @careInformation.
  ///
  /// In en, this message translates to:
  /// **'Care Information'**
  String get careInformation;

  /// No description provided for @watering.
  ///
  /// In en, this message translates to:
  /// **'Watering'**
  String get watering;

  /// No description provided for @sunlight.
  ///
  /// In en, this message translates to:
  /// **'Sunlight'**
  String get sunlight;

  /// No description provided for @soilType.
  ///
  /// In en, this message translates to:
  /// **'Soil Type'**
  String get soilType;

  /// No description provided for @temperatureRange.
  ///
  /// In en, this message translates to:
  /// **'Temperature'**
  String get temperatureRange;

  /// No description provided for @humidityRequirement.
  ///
  /// In en, this message translates to:
  /// **'Humidity'**
  String get humidityRequirement;

  /// No description provided for @fertilizer.
  ///
  /// In en, this message translates to:
  /// **'Fertilizer'**
  String get fertilizer;

  /// No description provided for @commonPests.
  ///
  /// In en, this message translates to:
  /// **'Common Pests'**
  String get commonPests;

  /// No description provided for @commonDiseases.
  ///
  /// In en, this message translates to:
  /// **'Common Diseases'**
  String get commonDiseases;

  /// No description provided for @confidence.
  ///
  /// In en, this message translates to:
  /// **'Confidence'**
  String get confidence;

  /// No description provided for @identifiedAt.
  ///
  /// In en, this message translates to:
  /// **'Identified at'**
  String get identifiedAt;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru', 'uk'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
    case 'uk':
      return AppLocalizationsUk();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
