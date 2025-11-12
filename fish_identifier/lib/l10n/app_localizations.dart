import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ru.dart';

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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('ja'),
    Locale('ru')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Fish Identifier'**
  String get appName;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'AI-Powered Fish Recognition'**
  String get appTagline;

  /// No description provided for @tabCamera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get tabCamera;

  /// No description provided for @tabHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get tabHistory;

  /// No description provided for @tabCollection.
  ///
  /// In en, this message translates to:
  /// **'Collection'**
  String get tabCollection;

  /// No description provided for @tabChat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get tabChat;

  /// No description provided for @tabSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get tabSettings;

  /// No description provided for @cameraTitle.
  ///
  /// In en, this message translates to:
  /// **'Identify Fish'**
  String get cameraTitle;

  /// No description provided for @cameraHint.
  ///
  /// In en, this message translates to:
  /// **'Take a photo or select from gallery'**
  String get cameraHint;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get takePhoto;

  /// No description provided for @selectFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Select from Gallery'**
  String get selectFromGallery;

  /// No description provided for @identifyingFish.
  ///
  /// In en, this message translates to:
  /// **'Identifying fish...'**
  String get identifyingFish;

  /// No description provided for @fishName.
  ///
  /// In en, this message translates to:
  /// **'Fish Name'**
  String get fishName;

  /// No description provided for @scientificName.
  ///
  /// In en, this message translates to:
  /// **'Scientific Name'**
  String get scientificName;

  /// No description provided for @habitat.
  ///
  /// In en, this message translates to:
  /// **'Habitat'**
  String get habitat;

  /// No description provided for @diet.
  ///
  /// In en, this message translates to:
  /// **'Diet'**
  String get diet;

  /// No description provided for @funFacts.
  ///
  /// In en, this message translates to:
  /// **'Fun Facts'**
  String get funFacts;

  /// No description provided for @confidence.
  ///
  /// In en, this message translates to:
  /// **'Confidence'**
  String get confidence;

  /// No description provided for @edibility.
  ///
  /// In en, this message translates to:
  /// **'Edibility'**
  String get edibility;

  /// No description provided for @cookingTips.
  ///
  /// In en, this message translates to:
  /// **'Cooking Tips'**
  String get cookingTips;

  /// No description provided for @fishingTips.
  ///
  /// In en, this message translates to:
  /// **'Fishing Tips'**
  String get fishingTips;

  /// No description provided for @conservationStatus.
  ///
  /// In en, this message translates to:
  /// **'Conservation Status'**
  String get conservationStatus;

  /// No description provided for @edible.
  ///
  /// In en, this message translates to:
  /// **'Edible'**
  String get edible;

  /// No description provided for @notRecommended.
  ///
  /// In en, this message translates to:
  /// **'Not Recommended'**
  String get notRecommended;

  /// No description provided for @toxic.
  ///
  /// In en, this message translates to:
  /// **'Toxic'**
  String get toxic;

  /// No description provided for @addToCollection.
  ///
  /// In en, this message translates to:
  /// **'Add to Collection'**
  String get addToCollection;

  /// No description provided for @chatAboutFish.
  ///
  /// In en, this message translates to:
  /// **'Chat about this fish'**
  String get chatAboutFish;

  /// No description provided for @shareResult.
  ///
  /// In en, this message translates to:
  /// **'Share Result'**
  String get shareResult;

  /// No description provided for @deleteResult.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteResult;

  /// No description provided for @collectionTitle.
  ///
  /// In en, this message translates to:
  /// **'My Collection'**
  String get collectionTitle;

  /// No description provided for @collectionEmpty.
  ///
  /// In en, this message translates to:
  /// **'No fish in your collection yet'**
  String get collectionEmpty;

  /// No description provided for @collectionHint.
  ///
  /// In en, this message translates to:
  /// **'Start identifying fish to build your collection!'**
  String get collectionHint;

  /// No description provided for @totalCatches.
  ///
  /// In en, this message translates to:
  /// **'Total Catches'**
  String get totalCatches;

  /// No description provided for @favoriteFish.
  ///
  /// In en, this message translates to:
  /// **'Favorite Fish'**
  String get favoriteFish;

  /// No description provided for @addNotes.
  ///
  /// In en, this message translates to:
  /// **'Add Notes'**
  String get addNotes;

  /// No description provided for @catchDetails.
  ///
  /// In en, this message translates to:
  /// **'Catch Details'**
  String get catchDetails;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @weight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weight;

  /// No description provided for @length.
  ///
  /// In en, this message translates to:
  /// **'Length'**
  String get length;

  /// No description provided for @baitUsed.
  ///
  /// In en, this message translates to:
  /// **'Bait Used'**
  String get baitUsed;

  /// No description provided for @weatherConditions.
  ///
  /// In en, this message translates to:
  /// **'Weather'**
  String get weatherConditions;

  /// No description provided for @chatTitle.
  ///
  /// In en, this message translates to:
  /// **'Fish AI Assistant'**
  String get chatTitle;

  /// No description provided for @chatHint.
  ///
  /// In en, this message translates to:
  /// **'Ask me anything about fish, fishing, or cooking!'**
  String get chatHint;

  /// No description provided for @chatPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Type your question...'**
  String get chatPlaceholder;

  /// No description provided for @chatSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get chatSend;

  /// No description provided for @chatSampleQuestions.
  ///
  /// In en, this message translates to:
  /// **'Sample Questions'**
  String get chatSampleQuestions;

  /// No description provided for @chatClear.
  ///
  /// In en, this message translates to:
  /// **'Clear Chat'**
  String get chatClear;

  /// No description provided for @historyTitle.
  ///
  /// In en, this message translates to:
  /// **'Identification History'**
  String get historyTitle;

  /// No description provided for @historyEmpty.
  ///
  /// In en, this message translates to:
  /// **'No identifications yet'**
  String get historyEmpty;

  /// No description provided for @historyHint.
  ///
  /// In en, this message translates to:
  /// **'Your identified fish will appear here'**
  String get historyHint;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// No description provided for @settingsThemeOcean.
  ///
  /// In en, this message translates to:
  /// **'Ocean Blue'**
  String get settingsThemeOcean;

  /// No description provided for @settingsThemeDeep.
  ///
  /// In en, this message translates to:
  /// **'Deep Sea'**
  String get settingsThemeDeep;

  /// No description provided for @settingsThemeTropical.
  ///
  /// In en, this message translates to:
  /// **'Tropical Waters'**
  String get settingsThemeTropical;

  /// No description provided for @settingsThemeKhaki.
  ///
  /// In en, this message translates to:
  /// **'Khaki Camouflage'**
  String get settingsThemeKhaki;

  /// No description provided for @settingsDarkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get settingsDarkMode;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @settingsClearData.
  ///
  /// In en, this message translates to:
  /// **'Clear All Data'**
  String get settingsClearData;

  /// No description provided for @settingsRate.
  ///
  /// In en, this message translates to:
  /// **'Rate App'**
  String get settingsRate;

  /// No description provided for @settingsShare.
  ///
  /// In en, this message translates to:
  /// **'Share App'**
  String get settingsShare;

  /// No description provided for @settingsFeedback.
  ///
  /// In en, this message translates to:
  /// **'Send Feedback'**
  String get settingsFeedback;

  /// No description provided for @confirmClearData.
  ///
  /// In en, this message translates to:
  /// **'Clear all data?'**
  String get confirmClearData;

  /// No description provided for @confirmClearDataMessage.
  ///
  /// In en, this message translates to:
  /// **'This will delete all identifications, collection items, and chat history. This action cannot be undone.'**
  String get confirmClearDataMessage;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @errorTitle.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get errorTitle;

  /// No description provided for @errorNetwork.
  ///
  /// In en, this message translates to:
  /// **'Network error. Please check your connection.'**
  String get errorNetwork;

  /// No description provided for @errorServiceOverloaded.
  ///
  /// In en, this message translates to:
  /// **'Service is temporarily overloaded. Please try again in a moment.'**
  String get errorServiceOverloaded;

  /// No description provided for @errorRateLimit.
  ///
  /// In en, this message translates to:
  /// **'Too many requests. Please wait a moment.'**
  String get errorRateLimit;

  /// No description provided for @errorInvalidResponse.
  ///
  /// In en, this message translates to:
  /// **'Unable to process the response. Please try again.'**
  String get errorInvalidResponse;

  /// No description provided for @errorNotFish.
  ///
  /// In en, this message translates to:
  /// **'This doesn\'t appear to be a fish. Please try another image.'**
  String get errorNotFish;

  /// No description provided for @errorGeneral.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorGeneral;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @feedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedback;

  /// No description provided for @catchNumber.
  ///
  /// In en, this message translates to:
  /// **'Catch #{number}'**
  String catchNumber(Object number);

  /// No description provided for @shareComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Share feature coming soon!'**
  String get shareComingSoon;

  /// No description provided for @dataCleared.
  ///
  /// In en, this message translates to:
  /// **'Data cleared successfully'**
  String get dataCleared;

  /// No description provided for @openingAppStore.
  ///
  /// In en, this message translates to:
  /// **'Opening app store...'**
  String get openingAppStore;

  /// No description provided for @ratingTitle.
  ///
  /// In en, this message translates to:
  /// **'Enjoying Fish Identifier?'**
  String get ratingTitle;

  /// No description provided for @ratingMessage.
  ///
  /// In en, this message translates to:
  /// **'Your feedback helps us improve the app!'**
  String get ratingMessage;

  /// No description provided for @rateNow.
  ///
  /// In en, this message translates to:
  /// **'Rate Now'**
  String get rateNow;

  /// No description provided for @maybeLater.
  ///
  /// In en, this message translates to:
  /// **'Maybe Later'**
  String get maybeLater;

  /// No description provided for @noThanks.
  ///
  /// In en, this message translates to:
  /// **'No Thanks'**
  String get noThanks;

  /// No description provided for @surveyTitle.
  ///
  /// In en, this message translates to:
  /// **'Help us improve!'**
  String get surveyTitle;

  /// No description provided for @surveyQuestion.
  ///
  /// In en, this message translates to:
  /// **'What feature would you like to see next?'**
  String get surveyQuestion;

  /// No description provided for @surveyOption1.
  ///
  /// In en, this message translates to:
  /// **'Social feed to share catches'**
  String get surveyOption1;

  /// No description provided for @surveyOption2.
  ///
  /// In en, this message translates to:
  /// **'Fishing spot recommendations'**
  String get surveyOption2;

  /// No description provided for @surveyOption3.
  ///
  /// In en, this message translates to:
  /// **'Weather-based predictions'**
  String get surveyOption3;

  /// No description provided for @surveyOption4.
  ///
  /// In en, this message translates to:
  /// **'Recipe database'**
  String get surveyOption4;

  /// No description provided for @surveySubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get surveySubmit;

  /// No description provided for @surveyThankYou.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your feedback!'**
  String get surveyThankYou;

  /// No description provided for @premiumTitle.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Premium'**
  String get premiumTitle;

  /// No description provided for @premiumFeature1.
  ///
  /// In en, this message translates to:
  /// **'Unlimited identifications'**
  String get premiumFeature1;

  /// No description provided for @premiumFeature2.
  ///
  /// In en, this message translates to:
  /// **'Unlimited AI chat'**
  String get premiumFeature2;

  /// No description provided for @premiumFeature3.
  ///
  /// In en, this message translates to:
  /// **'GPS location tracking'**
  String get premiumFeature3;

  /// No description provided for @premiumFeature4.
  ///
  /// In en, this message translates to:
  /// **'Advanced statistics'**
  String get premiumFeature4;

  /// No description provided for @premiumFeature5.
  ///
  /// In en, this message translates to:
  /// **'Cloud backup'**
  String get premiumFeature5;

  /// No description provided for @premiumFeature6.
  ///
  /// In en, this message translates to:
  /// **'Ad-free experience'**
  String get premiumFeature6;

  /// No description provided for @premiumPrice.
  ///
  /// In en, this message translates to:
  /// **'\$4.99/month or \$29.99/year'**
  String get premiumPrice;

  /// No description provided for @premiumUpgrade.
  ///
  /// In en, this message translates to:
  /// **'Upgrade Now'**
  String get premiumUpgrade;

  /// No description provided for @premiumRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore Purchase'**
  String get premiumRestore;

  /// No description provided for @doYouEnjoyOurApp.
  ///
  /// In en, this message translates to:
  /// **'Do you enjoy our app?'**
  String get doYouEnjoyOurApp;

  /// No description provided for @notReally.
  ///
  /// In en, this message translates to:
  /// **'Not really'**
  String get notReally;

  /// No description provided for @yesItsGreat.
  ///
  /// In en, this message translates to:
  /// **'Yes, it\'s great!'**
  String get yesItsGreat;

  /// No description provided for @rateOurApp.
  ///
  /// In en, this message translates to:
  /// **'Rate our app'**
  String get rateOurApp;

  /// No description provided for @bestRatingWeCanGet.
  ///
  /// In en, this message translates to:
  /// **'5 stars is the best rating we can get'**
  String get bestRatingWeCanGet;

  /// No description provided for @rateOnGooglePlay.
  ///
  /// In en, this message translates to:
  /// **'Rate on Google Play'**
  String get rateOnGooglePlay;

  /// No description provided for @rate.
  ///
  /// In en, this message translates to:
  /// **'Rate'**
  String get rate;

  /// No description provided for @whatCanBeImproved.
  ///
  /// In en, this message translates to:
  /// **'What can be improved?'**
  String get whatCanBeImproved;

  /// No description provided for @wereSorryYouDidntHaveAGreatExperience.
  ///
  /// In en, this message translates to:
  /// **'We\'re sorry you didn\'t have a great experience'**
  String get wereSorryYouDidntHaveAGreatExperience;

  /// No description provided for @yourFeedback.
  ///
  /// In en, this message translates to:
  /// **'Your feedback'**
  String get yourFeedback;

  /// No description provided for @sendFeedback.
  ///
  /// In en, this message translates to:
  /// **'Send Feedback'**
  String get sendFeedback;

  /// No description provided for @thankYouForYourFeedback.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your feedback!'**
  String get thankYouForYourFeedback;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es', 'ja', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
    case 'ja': return AppLocalizationsJa();
    case 'ru': return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
