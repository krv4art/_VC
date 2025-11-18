import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_uk.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated_l10n/app_localizations.dart';
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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
    Locale('es'),
    Locale('de'),
    Locale('fr'),
    Locale('it'),
    Locale('pt'),
    Locale('ja'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Antique Identifier'**
  String get appTitle;

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

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Identify Your Antiques'**
  String get homeTitle;

  /// No description provided for @homeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'AI-powered identification with expert analysis, historical context, and valuation'**
  String get homeSubtitle;

  /// No description provided for @scanTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan Antique'**
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

  /// No description provided for @analyzing.
  ///
  /// In en, this message translates to:
  /// **'Analyzing...'**
  String get analyzing;

  /// No description provided for @analyzeWithAI.
  ///
  /// In en, this message translates to:
  /// **'Analyze with AI'**
  String get analyzeWithAI;

  /// No description provided for @photoTipsTitle.
  ///
  /// In en, this message translates to:
  /// **'Photo Tips for Better Results'**
  String get photoTipsTitle;

  /// No description provided for @photoTip1.
  ///
  /// In en, this message translates to:
  /// **'Use good natural lighting'**
  String get photoTip1;

  /// No description provided for @photoTip2.
  ///
  /// In en, this message translates to:
  /// **'Show all sides or key details'**
  String get photoTip2;

  /// No description provided for @photoTip3.
  ///
  /// In en, this message translates to:
  /// **'Focus on unique characteristics'**
  String get photoTip3;

  /// No description provided for @photoTip4.
  ///
  /// In en, this message translates to:
  /// **'Avoid shadows and reflections'**
  String get photoTip4;

  /// No description provided for @analysisResults.
  ///
  /// In en, this message translates to:
  /// **'Analysis Results'**
  String get analysisResults;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @materials.
  ///
  /// In en, this message translates to:
  /// **'Materials'**
  String get materials;

  /// No description provided for @historicalContext.
  ///
  /// In en, this message translates to:
  /// **'Historical Context'**
  String get historicalContext;

  /// No description provided for @estimatedValue.
  ///
  /// In en, this message translates to:
  /// **'Estimated Value'**
  String get estimatedValue;

  /// No description provided for @similarItems.
  ///
  /// In en, this message translates to:
  /// **'Similar Items'**
  String get similarItems;

  /// No description provided for @chatWithExpert.
  ///
  /// In en, this message translates to:
  /// **'Chat with AI Expert'**
  String get chatWithExpert;

  /// No description provided for @saveToCollection.
  ///
  /// In en, this message translates to:
  /// **'Save to Collection'**
  String get saveToCollection;

  /// No description provided for @confidence.
  ///
  /// In en, this message translates to:
  /// **'Confidence'**
  String get confidence;

  /// No description provided for @basedOn.
  ///
  /// In en, this message translates to:
  /// **'Based on'**
  String get basedOn;

  /// No description provided for @importantNotes.
  ///
  /// In en, this message translates to:
  /// **'Important Notes'**
  String get importantNotes;

  /// No description provided for @estimationDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'This is an estimate based on AI analysis. Professional appraisal recommended for significant items.'**
  String get estimationDisclaimer;

  /// No description provided for @noAnalysisResults.
  ///
  /// In en, this message translates to:
  /// **'No analysis results available'**
  String get noAnalysisResults;

  /// No description provided for @goHome.
  ///
  /// In en, this message translates to:
  /// **'Go Home'**
  String get goHome;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @chatHistory.
  ///
  /// In en, this message translates to:
  /// **'Chat History'**
  String get chatHistory;

  /// No description provided for @askAboutAntique.
  ///
  /// In en, this message translates to:
  /// **'Ask about this antique...'**
  String get askAboutAntique;

  /// No description provided for @noMessages.
  ///
  /// In en, this message translates to:
  /// **'No messages'**
  String get noMessages;

  /// No description provided for @noAnalysesYet.
  ///
  /// In en, this message translates to:
  /// **'No analyses yet'**
  String get noAnalysesYet;

  /// No description provided for @startByScanningAntique.
  ///
  /// In en, this message translates to:
  /// **'Start by scanning an antique'**
  String get startByScanningAntique;

  /// No description provided for @clearHistory.
  ///
  /// In en, this message translates to:
  /// **'Clear History'**
  String get clearHistory;

  /// No description provided for @clearHistoryConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete all analyses from history?'**
  String get clearHistoryConfirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'saved to collection!'**
  String get saved;

  /// No description provided for @shareComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Share functionality coming soon!'**
  String get shareComingSoon;

  /// No description provided for @failedToCapture.
  ///
  /// In en, this message translates to:
  /// **'Failed to capture photo:'**
  String get failedToCapture;

  /// No description provided for @failedToPick.
  ///
  /// In en, this message translates to:
  /// **'Failed to pick photo:'**
  String get failedToPick;

  /// No description provided for @analysisFailedMessage.
  ///
  /// In en, this message translates to:
  /// **'Analysis failed:'**
  String get analysisFailedMessage;

  /// No description provided for @period.
  ///
  /// In en, this message translates to:
  /// **'Period'**
  String get period;

  /// No description provided for @origin.
  ///
  /// In en, this message translates to:
  /// **'Origin'**
  String get origin;

  /// No description provided for @howItWorks.
  ///
  /// In en, this message translates to:
  /// **'How it works:'**
  String get howItWorks;

  /// No description provided for @step1.
  ///
  /// In en, this message translates to:
  /// **'Take a clear photo of your antique'**
  String get step1;

  /// No description provided for @step2.
  ///
  /// In en, this message translates to:
  /// **'Get AI-powered analysis and valuation'**
  String get step2;

  /// No description provided for @step3.
  ///
  /// In en, this message translates to:
  /// **'Chat with AI expert for more details'**
  String get step3;

  /// No description provided for @step4.
  ///
  /// In en, this message translates to:
  /// **'Save to your collection'**
  String get step4;
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
      <String>['en', 'ru'].contains(locale.languageCode);

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
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
