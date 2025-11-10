import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_cs.dart';
import 'app_localizations_da.dart';
import 'app_localizations_de.dart';
import 'app_localizations_el.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fi.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_hu.dart';
import 'app_localizations_id.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_no.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ro.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_sv.dart';
import 'app_localizations_th.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_uk.dart';
import 'app_localizations_vi.dart';
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
    Locale('ar'),
    Locale('cs'),
    Locale('da'),
    Locale('de'),
    Locale('el'),
    Locale('en'),
    Locale('es'),
    Locale('es', '419'),
    Locale('es', 'ES'),
    Locale('fi'),
    Locale('fr'),
    Locale('hi'),
    Locale('hu'),
    Locale('id'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('nl'),
    Locale('no'),
    Locale('pl'),
    Locale('pt'),
    Locale('pt', 'BR'),
    Locale('pt', 'PT'),
    Locale('ro'),
    Locale('ru'),
    Locale('sv'),
    Locale('th'),
    Locale('tr'),
    Locale('uk'),
    Locale('vi'),
    Locale('zh'),
    Locale('zh', 'CN'),
    Locale('zh', 'TW')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'AI Cosmetic Scanner'**
  String get appName;

  /// No description provided for @skinAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Skin Analysis'**
  String get skinAnalysis;

  /// No description provided for @checkYourCosmetics.
  ///
  /// In en, this message translates to:
  /// **'Check your cosmetics'**
  String get checkYourCosmetics;

  /// No description provided for @startScanning.
  ///
  /// In en, this message translates to:
  /// **'Start Scanning'**
  String get startScanning;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @scanHistory.
  ///
  /// In en, this message translates to:
  /// **'Scan History'**
  String get scanHistory;

  /// No description provided for @aiChat.
  ///
  /// In en, this message translates to:
  /// **'AI Cosmetic Scanner'**
  String get aiChat;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @skinType.
  ///
  /// In en, this message translates to:
  /// **'Skin Type'**
  String get skinType;

  /// No description provided for @allergiesSensitivities.
  ///
  /// In en, this message translates to:
  /// **'Allergies & Sensitivities'**
  String get allergiesSensitivities;

  /// No description provided for @subscription.
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get subscription;

  /// No description provided for @age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @selectYourPreferredLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select your preferred language'**
  String get selectYourPreferredLanguage;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @language_en.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get language_en;

  /// No description provided for @language_ru.
  ///
  /// In en, this message translates to:
  /// **'Russian'**
  String get language_ru;

  /// No description provided for @language_uk.
  ///
  /// In en, this message translates to:
  /// **'Ukrainian'**
  String get language_uk;

  /// No description provided for @language_es.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get language_es;

  /// No description provided for @language_de.
  ///
  /// In en, this message translates to:
  /// **'German'**
  String get language_de;

  /// No description provided for @language_fr.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get language_fr;

  /// No description provided for @language_it.
  ///
  /// In en, this message translates to:
  /// **'Italian'**
  String get language_it;

  /// No description provided for @language_ar.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get language_ar;

  /// No description provided for @language_ko.
  ///
  /// In en, this message translates to:
  /// **'Korean'**
  String get language_ko;

  /// No description provided for @language_cs.
  ///
  /// In en, this message translates to:
  /// **'Czech'**
  String get language_cs;

  /// No description provided for @language_da.
  ///
  /// In en, this message translates to:
  /// **'Danish'**
  String get language_da;

  /// No description provided for @language_el.
  ///
  /// In en, this message translates to:
  /// **'Greek'**
  String get language_el;

  /// No description provided for @language_fi.
  ///
  /// In en, this message translates to:
  /// **'Finnish'**
  String get language_fi;

  /// No description provided for @language_hi.
  ///
  /// In en, this message translates to:
  /// **'Hindi'**
  String get language_hi;

  /// No description provided for @language_hu.
  ///
  /// In en, this message translates to:
  /// **'Hungarian'**
  String get language_hu;

  /// No description provided for @language_id.
  ///
  /// In en, this message translates to:
  /// **'Indonesian'**
  String get language_id;

  /// No description provided for @language_ja.
  ///
  /// In en, this message translates to:
  /// **'Japanese'**
  String get language_ja;

  /// No description provided for @language_nl.
  ///
  /// In en, this message translates to:
  /// **'Dutch'**
  String get language_nl;

  /// No description provided for @language_no.
  ///
  /// In en, this message translates to:
  /// **'Norwegian'**
  String get language_no;

  /// No description provided for @language_pl.
  ///
  /// In en, this message translates to:
  /// **'Polish'**
  String get language_pl;

  /// No description provided for @language_pt.
  ///
  /// In en, this message translates to:
  /// **'Portuguese'**
  String get language_pt;

  /// No description provided for @language_ro.
  ///
  /// In en, this message translates to:
  /// **'Romanian'**
  String get language_ro;

  /// No description provided for @language_sv.
  ///
  /// In en, this message translates to:
  /// **'Swedish'**
  String get language_sv;

  /// No description provided for @language_th.
  ///
  /// In en, this message translates to:
  /// **'Thai'**
  String get language_th;

  /// No description provided for @language_tr.
  ///
  /// In en, this message translates to:
  /// **'Turkish'**
  String get language_tr;

  /// No description provided for @language_vi.
  ///
  /// In en, this message translates to:
  /// **'Vietnamese'**
  String get language_vi;

  /// No description provided for @language_zh.
  ///
  /// In en, this message translates to:
  /// **'Chinese'**
  String get language_zh;

  /// No description provided for @selectIngredientsAllergicSensitive.
  ///
  /// In en, this message translates to:
  /// **'Select ingredients you have increased sensitivity to'**
  String get selectIngredientsAllergicSensitive;

  /// No description provided for @commonAllergens.
  ///
  /// In en, this message translates to:
  /// **'Common Allergens'**
  String get commonAllergens;

  /// No description provided for @fragrance.
  ///
  /// In en, this message translates to:
  /// **'Fragrance'**
  String get fragrance;

  /// No description provided for @parabens.
  ///
  /// In en, this message translates to:
  /// **'Parabens'**
  String get parabens;

  /// No description provided for @sulfates.
  ///
  /// In en, this message translates to:
  /// **'Sulfates'**
  String get sulfates;

  /// No description provided for @alcohol.
  ///
  /// In en, this message translates to:
  /// **'Alcohol'**
  String get alcohol;

  /// No description provided for @essentialOils.
  ///
  /// In en, this message translates to:
  /// **'Essential Oils'**
  String get essentialOils;

  /// No description provided for @silicones.
  ///
  /// In en, this message translates to:
  /// **'Silicones'**
  String get silicones;

  /// No description provided for @mineralOil.
  ///
  /// In en, this message translates to:
  /// **'Mineral Oil'**
  String get mineralOil;

  /// No description provided for @formaldehyde.
  ///
  /// In en, this message translates to:
  /// **'Formaldehyde'**
  String get formaldehyde;

  /// No description provided for @addCustomAllergen.
  ///
  /// In en, this message translates to:
  /// **'Add Custom Allergen'**
  String get addCustomAllergen;

  /// No description provided for @typeIngredientName.
  ///
  /// In en, this message translates to:
  /// **'Type ingredient name...'**
  String get typeIngredientName;

  /// No description provided for @selectedAllergens.
  ///
  /// In en, this message translates to:
  /// **'Selected Allergens'**
  String get selectedAllergens;

  /// No description provided for @saveSelected.
  ///
  /// In en, this message translates to:
  /// **'Save ({count} selected)'**
  String saveSelected(int count);

  /// No description provided for @analysisResults.
  ///
  /// In en, this message translates to:
  /// **'Analysis Results'**
  String get analysisResults;

  /// No description provided for @overallSafetyScore.
  ///
  /// In en, this message translates to:
  /// **'Overall Safety Score'**
  String get overallSafetyScore;

  /// No description provided for @personalizedWarnings.
  ///
  /// In en, this message translates to:
  /// **'Personalized Warnings'**
  String get personalizedWarnings;

  /// No description provided for @ingredientsAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Ingredients Analysis ({count})'**
  String ingredientsAnalysis(int count);

  /// No description provided for @highRisk.
  ///
  /// In en, this message translates to:
  /// **'High Risk'**
  String get highRisk;

  /// No description provided for @moderateRisk.
  ///
  /// In en, this message translates to:
  /// **'Moderate Risk'**
  String get moderateRisk;

  /// No description provided for @lowRisk.
  ///
  /// In en, this message translates to:
  /// **'Low Risk'**
  String get lowRisk;

  /// No description provided for @benefitsAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Benefits Analysis'**
  String get benefitsAnalysis;

  /// No description provided for @recommendedAlternatives.
  ///
  /// In en, this message translates to:
  /// **'Recommended Alternatives'**
  String get recommendedAlternatives;

  /// No description provided for @reason.
  ///
  /// In en, this message translates to:
  /// **'Reason:'**
  String get reason;

  /// No description provided for @quickSummary.
  ///
  /// In en, this message translates to:
  /// **'Quick Summary'**
  String get quickSummary;

  /// No description provided for @ingredientsChecked.
  ///
  /// In en, this message translates to:
  /// **'ingredients checked'**
  String get ingredientsChecked;

  /// No description provided for @personalWarnings.
  ///
  /// In en, this message translates to:
  /// **'personal warnings'**
  String get personalWarnings;

  /// No description provided for @ourVerdict.
  ///
  /// In en, this message translates to:
  /// **'Our Verdict'**
  String get ourVerdict;

  /// No description provided for @productInfo.
  ///
  /// In en, this message translates to:
  /// **'Product Information'**
  String get productInfo;

  /// No description provided for @productType.
  ///
  /// In en, this message translates to:
  /// **'Product Type'**
  String get productType;

  /// No description provided for @brand.
  ///
  /// In en, this message translates to:
  /// **'Brand'**
  String get brand;

  /// No description provided for @premiumInsights.
  ///
  /// In en, this message translates to:
  /// **'Premium Insights'**
  String get premiumInsights;

  /// No description provided for @researchArticles.
  ///
  /// In en, this message translates to:
  /// **'Research Articles'**
  String get researchArticles;

  /// No description provided for @categoryRanking.
  ///
  /// In en, this message translates to:
  /// **'Category Ranking'**
  String get categoryRanking;

  /// No description provided for @safetyTrend.
  ///
  /// In en, this message translates to:
  /// **'Safety Trend'**
  String get safetyTrend;

  /// No description provided for @saveToFavorites.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveToFavorites;

  /// No description provided for @shareResults.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get shareResults;

  /// No description provided for @compareProducts.
  ///
  /// In en, this message translates to:
  /// **'Compare'**
  String get compareProducts;

  /// No description provided for @exportPDF.
  ///
  /// In en, this message translates to:
  /// **'PDF'**
  String get exportPDF;

  /// No description provided for @scanSimilar.
  ///
  /// In en, this message translates to:
  /// **'Similar'**
  String get scanSimilar;

  /// No description provided for @aiChatTitle.
  ///
  /// In en, this message translates to:
  /// **'AI Cosmetic Scanner'**
  String get aiChatTitle;

  /// No description provided for @typeYourMessage.
  ///
  /// In en, this message translates to:
  /// **'Type your message...'**
  String get typeYourMessage;

  /// No description provided for @errorSupabaseClientNotInitialized.
  ///
  /// In en, this message translates to:
  /// **'Error: Supabase client not initialized.'**
  String get errorSupabaseClientNotInitialized;

  /// No description provided for @serverError.
  ///
  /// In en, this message translates to:
  /// **'Server error:'**
  String get serverError;

  /// No description provided for @networkErrorOccurred.
  ///
  /// In en, this message translates to:
  /// **'Network error occurred. Please try again later.'**
  String get networkErrorOccurred;

  /// No description provided for @sorryAnErrorOccurred.
  ///
  /// In en, this message translates to:
  /// **'Sorry, an error occurred. Please try again.'**
  String get sorryAnErrorOccurred;

  /// No description provided for @couldNotGetResponse.
  ///
  /// In en, this message translates to:
  /// **'Could not get a response.'**
  String get couldNotGetResponse;

  /// No description provided for @aiAssistant.
  ///
  /// In en, this message translates to:
  /// **'AI Assistant'**
  String get aiAssistant;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// No description provided for @typing.
  ///
  /// In en, this message translates to:
  /// **'Typing...'**
  String get typing;

  /// No description provided for @writeAMessage.
  ///
  /// In en, this message translates to:
  /// **'Write a message...'**
  String get writeAMessage;

  /// No description provided for @hiIAmYourAIAssistantHowCanIHelp.
  ///
  /// In en, this message translates to:
  /// **'Hi! I am your AI assistant. How can I help?'**
  String get hiIAmYourAIAssistantHowCanIHelp;

  /// No description provided for @iCanSeeYourScanResultsFeelFreeToAskMeAnyQuestionsAboutTheIngredientsSafetyConcernsOrRecommendations.
  ///
  /// In en, this message translates to:
  /// **'I can see your scan results! Feel free to ask me any questions about ingredients, safety concerns, or recommendations.'**
  String get iCanSeeYourScanResultsFeelFreeToAskMeAnyQuestionsAboutTheIngredientsSafetyConcernsOrRecommendations;

  /// No description provided for @userQuestion.
  ///
  /// In en, this message translates to:
  /// **'User question:'**
  String get userQuestion;

  /// No description provided for @databaseExplorer.
  ///
  /// In en, this message translates to:
  /// **'Database Explorer'**
  String get databaseExplorer;

  /// No description provided for @currentUser.
  ///
  /// In en, this message translates to:
  /// **'Current User:'**
  String get currentUser;

  /// No description provided for @notSignedIn.
  ///
  /// In en, this message translates to:
  /// **'Not signed in'**
  String get notSignedIn;

  /// No description provided for @failedToFetchTables.
  ///
  /// In en, this message translates to:
  /// **'Failed to fetch tables:'**
  String get failedToFetchTables;

  /// No description provided for @tablesInYourSupabaseDatabase.
  ///
  /// In en, this message translates to:
  /// **'Tables in your Supabase database:'**
  String get tablesInYourSupabaseDatabase;

  /// No description provided for @viewSampleData.
  ///
  /// In en, this message translates to:
  /// **'View Sample Data'**
  String get viewSampleData;

  /// No description provided for @failedToFetchSampleDataFor.
  ///
  /// In en, this message translates to:
  /// **'Failed to fetch sample data for'**
  String get failedToFetchSampleDataFor;

  /// No description provided for @sampleData.
  ///
  /// In en, this message translates to:
  /// **'Sample Data:'**
  String get sampleData;

  /// No description provided for @aiChats.
  ///
  /// In en, this message translates to:
  /// **'AI Cosmetic Scanners'**
  String get aiChats;

  /// No description provided for @noDialoguesYet.
  ///
  /// In en, this message translates to:
  /// **'No dialogues yet.'**
  String get noDialoguesYet;

  /// No description provided for @startANewChat.
  ///
  /// In en, this message translates to:
  /// **'Start a new chat!'**
  String get startANewChat;

  /// No description provided for @created.
  ///
  /// In en, this message translates to:
  /// **'Created:'**
  String get created;

  /// No description provided for @failedToSaveImage.
  ///
  /// In en, this message translates to:
  /// **'Failed to save image:'**
  String get failedToSaveImage;

  /// No description provided for @editName.
  ///
  /// In en, this message translates to:
  /// **'Edit Name'**
  String get editName;

  /// No description provided for @enterYourName.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enterYourName;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @premiumUser.
  ///
  /// In en, this message translates to:
  /// **'Premium User'**
  String get premiumUser;

  /// No description provided for @freeUser.
  ///
  /// In en, this message translates to:
  /// **'Free User'**
  String get freeUser;

  /// No description provided for @skinProfile.
  ///
  /// In en, this message translates to:
  /// **'Skin Profile'**
  String get skinProfile;

  /// No description provided for @notSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get notSet;

  /// No description provided for @legal.
  ///
  /// In en, this message translates to:
  /// **'Legal'**
  String get legal;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @dataManagement.
  ///
  /// In en, this message translates to:
  /// **'Data Management'**
  String get dataManagement;

  /// No description provided for @clearAllData.
  ///
  /// In en, this message translates to:
  /// **'Clear All Data'**
  String get clearAllData;

  /// No description provided for @clearAllDataConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete all your local data? This action cannot be undone.'**
  String get clearAllDataConfirmation;

  /// No description provided for @selectDataToClear.
  ///
  /// In en, this message translates to:
  /// **'Select data to clear'**
  String get selectDataToClear;

  /// No description provided for @scanResults.
  ///
  /// In en, this message translates to:
  /// **'Scan Results'**
  String get scanResults;

  /// No description provided for @chatHistory.
  ///
  /// In en, this message translates to:
  /// **'Chats'**
  String get chatHistory;

  /// No description provided for @personalData.
  ///
  /// In en, this message translates to:
  /// **'Personal Data'**
  String get personalData;

  /// No description provided for @clearData.
  ///
  /// In en, this message translates to:
  /// **'Clear Data'**
  String get clearData;

  /// No description provided for @allLocalDataHasBeenCleared.
  ///
  /// In en, this message translates to:
  /// **'Data has been cleared.'**
  String get allLocalDataHasBeenCleared;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @deleteScan.
  ///
  /// In en, this message translates to:
  /// **'Delete Scan'**
  String get deleteScan;

  /// No description provided for @deleteScanConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this scan from your history?'**
  String get deleteScanConfirmation;

  /// No description provided for @deleteChat.
  ///
  /// In en, this message translates to:
  /// **'Delete Chat'**
  String get deleteChat;

  /// No description provided for @deleteChatConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this chat? All messages will be lost.'**
  String get deleteChatConfirmation;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @noScanHistoryFound.
  ///
  /// In en, this message translates to:
  /// **'No scan history found.'**
  String get noScanHistoryFound;

  /// No description provided for @scanOn.
  ///
  /// In en, this message translates to:
  /// **'Scan on'**
  String get scanOn;

  /// No description provided for @ingredientsFound.
  ///
  /// In en, this message translates to:
  /// **'ingredients found'**
  String get ingredientsFound;

  /// No description provided for @noCamerasFoundOnThisDevice.
  ///
  /// In en, this message translates to:
  /// **'No cameras found on this device.'**
  String get noCamerasFoundOnThisDevice;

  /// No description provided for @failedToInitializeCamera.
  ///
  /// In en, this message translates to:
  /// **'Failed to initialize camera:'**
  String get failedToInitializeCamera;

  /// No description provided for @analysisFailed.
  ///
  /// In en, this message translates to:
  /// **'Analysis failed:'**
  String get analysisFailed;

  /// No description provided for @analyzingPleaseWait.
  ///
  /// In en, this message translates to:
  /// **'Analyzing, please wait...'**
  String get analyzingPleaseWait;

  /// No description provided for @positionTheLabelWithinTheFrame.
  ///
  /// In en, this message translates to:
  /// **'Focus the camera on the ingredients list'**
  String get positionTheLabelWithinTheFrame;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @signUpToGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Sign up to get started'**
  String get signUpToGetStarted;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @pleaseEnterYourName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get pleaseEnterYourName;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @pleaseEnterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get pleaseEnterYourEmail;

  /// No description provided for @pleaseEnterAValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get pleaseEnterAValidEmail;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @pleaseEnterYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get pleaseEnterYourPassword;

  /// No description provided for @passwordMustBeAtLeast6Characters.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMustBeAtLeast6Characters;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @orContinueWith.
  ///
  /// In en, this message translates to:
  /// **'or continue with'**
  String get orContinueWith;

  /// No description provided for @google.
  ///
  /// In en, this message translates to:
  /// **'Google'**
  String get google;

  /// No description provided for @apple.
  ///
  /// In en, this message translates to:
  /// **'Apple'**
  String get apple;

  /// No description provided for @alreadyHaveAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAnAccount;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @selectYourSkinTypeDescription.
  ///
  /// In en, this message translates to:
  /// **'Select your skin type'**
  String get selectYourSkinTypeDescription;

  /// No description provided for @normal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get normal;

  /// No description provided for @normalSkinDescription.
  ///
  /// In en, this message translates to:
  /// **'Balanced, not too oily or dry'**
  String get normalSkinDescription;

  /// No description provided for @dry.
  ///
  /// In en, this message translates to:
  /// **'Dry'**
  String get dry;

  /// No description provided for @drySkinDescription.
  ///
  /// In en, this message translates to:
  /// **'Tight, flaky, rough texture'**
  String get drySkinDescription;

  /// No description provided for @oily.
  ///
  /// In en, this message translates to:
  /// **'Oily'**
  String get oily;

  /// No description provided for @oilySkinDescription.
  ///
  /// In en, this message translates to:
  /// **'Shiny, large pores, prone to acne'**
  String get oilySkinDescription;

  /// No description provided for @combination.
  ///
  /// In en, this message translates to:
  /// **'Combination'**
  String get combination;

  /// No description provided for @combinationSkinDescription.
  ///
  /// In en, this message translates to:
  /// **'Oily T-zone, dry cheeks'**
  String get combinationSkinDescription;

  /// No description provided for @sensitive.
  ///
  /// In en, this message translates to:
  /// **'Sensitive'**
  String get sensitive;

  /// No description provided for @sensitiveSkinDescription.
  ///
  /// In en, this message translates to:
  /// **'Easily irritated, prone to redness'**
  String get sensitiveSkinDescription;

  /// No description provided for @selectSkinType.
  ///
  /// In en, this message translates to:
  /// **'Select skin type'**
  String get selectSkinType;

  /// No description provided for @restore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restore;

  /// No description provided for @restorePurchases.
  ///
  /// In en, this message translates to:
  /// **'Restore Purchases'**
  String get restorePurchases;

  /// No description provided for @subscriptionRestored.
  ///
  /// In en, this message translates to:
  /// **'Subscription restored successfully!'**
  String get subscriptionRestored;

  /// No description provided for @noPurchasesToRestore.
  ///
  /// In en, this message translates to:
  /// **'No purchases to restore'**
  String get noPurchasesToRestore;

  /// No description provided for @goPremium.
  ///
  /// In en, this message translates to:
  /// **'Go Premium'**
  String get goPremium;

  /// No description provided for @unlockExclusiveFeatures.
  ///
  /// In en, this message translates to:
  /// **'Unlock exclusive features to get most out of your skin analysis.'**
  String get unlockExclusiveFeatures;

  /// No description provided for @unlimitedProductScans.
  ///
  /// In en, this message translates to:
  /// **'Unlimited product scans'**
  String get unlimitedProductScans;

  /// No description provided for @advancedAIIngredientAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Advanced AI Ingredient Analysis'**
  String get advancedAIIngredientAnalysis;

  /// No description provided for @fullScanAndSearchHistory.
  ///
  /// In en, this message translates to:
  /// **'Full Scan and Search History'**
  String get fullScanAndSearchHistory;

  /// No description provided for @adFreeExperience.
  ///
  /// In en, this message translates to:
  /// **'100% Ad-Free Experience'**
  String get adFreeExperience;

  /// No description provided for @yearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get yearly;

  /// No description provided for @savePercentage.
  ///
  /// In en, this message translates to:
  /// **'Save {percentage}%'**
  String savePercentage(int percentage);

  /// No description provided for @monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthly;

  /// No description provided for @perMonth.
  ///
  /// In en, this message translates to:
  /// **'/ month'**
  String get perMonth;

  /// No description provided for @startFreeTrial.
  ///
  /// In en, this message translates to:
  /// **'Start Free Trial'**
  String get startFreeTrial;

  /// No description provided for @trialDescription.
  ///
  /// In en, this message translates to:
  /// **'7-day free trial, then billed {planName}. Cancel anytime.'**
  String trialDescription(String planName);

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

  /// No description provided for @aiChatNav.
  ///
  /// In en, this message translates to:
  /// **'AI Cosmetic Scanner'**
  String get aiChatNav;

  /// No description provided for @profileNav.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileNav;

  /// No description provided for @doYouEnjoyOurApp.
  ///
  /// In en, this message translates to:
  /// **'Do you enjoy our app?'**
  String get doYouEnjoyOurApp;

  /// No description provided for @notReally.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get notReally;

  /// No description provided for @yesItsGreat.
  ///
  /// In en, this message translates to:
  /// **'I like it'**
  String get yesItsGreat;

  /// No description provided for @rateOurApp.
  ///
  /// In en, this message translates to:
  /// **'Rate our app'**
  String get rateOurApp;

  /// No description provided for @bestRatingWeCanGet.
  ///
  /// In en, this message translates to:
  /// **'Best rating we can get'**
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
  /// **'We\'re sorry you didn\'t have a great experience. Please tell us what went wrong.'**
  String get wereSorryYouDidntHaveAGreatExperience;

  /// No description provided for @yourFeedback.
  ///
  /// In en, this message translates to:
  /// **'Your feedback...'**
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

  /// No description provided for @discussWithAI.
  ///
  /// In en, this message translates to:
  /// **'Discuss with AI'**
  String get discussWithAI;

  /// No description provided for @enterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterYourEmail;

  /// No description provided for @enterYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterYourPassword;

  /// No description provided for @aiDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'AI responses may contain inaccuracies. Please verify critical information.'**
  String get aiDisclaimer;

  /// No description provided for @applicationThemes.
  ///
  /// In en, this message translates to:
  /// **'Application Themes'**
  String get applicationThemes;

  /// No description provided for @highestRating.
  ///
  /// In en, this message translates to:
  /// **'Highest Rating'**
  String get highestRating;

  /// No description provided for @selectYourAgeDescription.
  ///
  /// In en, this message translates to:
  /// **'Select your age'**
  String get selectYourAgeDescription;

  /// No description provided for @ageRange18_25.
  ///
  /// In en, this message translates to:
  /// **'18-25'**
  String get ageRange18_25;

  /// No description provided for @ageRange26_35.
  ///
  /// In en, this message translates to:
  /// **'26-35'**
  String get ageRange26_35;

  /// No description provided for @ageRange36_45.
  ///
  /// In en, this message translates to:
  /// **'36-45'**
  String get ageRange36_45;

  /// No description provided for @ageRange46_55.
  ///
  /// In en, this message translates to:
  /// **'46-55'**
  String get ageRange46_55;

  /// No description provided for @ageRange56Plus.
  ///
  /// In en, this message translates to:
  /// **'56+'**
  String get ageRange56Plus;

  /// No description provided for @ageRange18_25Description.
  ///
  /// In en, this message translates to:
  /// **'Young skin, prevention'**
  String get ageRange18_25Description;

  /// No description provided for @ageRange26_35Description.
  ///
  /// In en, this message translates to:
  /// **'First signs of aging'**
  String get ageRange26_35Description;

  /// No description provided for @ageRange36_45Description.
  ///
  /// In en, this message translates to:
  /// **'Anti-ageing care'**
  String get ageRange36_45Description;

  /// No description provided for @ageRange46_55Description.
  ///
  /// In en, this message translates to:
  /// **'Intensive care'**
  String get ageRange46_55Description;

  /// No description provided for @ageRange56PlusDescription.
  ///
  /// In en, this message translates to:
  /// **'Specialized care'**
  String get ageRange56PlusDescription;

  /// No description provided for @userName.
  ///
  /// In en, this message translates to:
  /// **'Your Name'**
  String get userName;

  /// No description provided for @tryFreeAndSubscribe.
  ///
  /// In en, this message translates to:
  /// **'Try Free & Subscribe'**
  String get tryFreeAndSubscribe;

  /// No description provided for @personalAIConsultant.
  ///
  /// In en, this message translates to:
  /// **'Personal AI Consultant 24/7'**
  String get personalAIConsultant;

  /// No description provided for @subscribe.
  ///
  /// In en, this message translates to:
  /// **'Subscribe'**
  String get subscribe;

  /// No description provided for @themes.
  ///
  /// In en, this message translates to:
  /// **'Themes'**
  String get themes;

  /// No description provided for @selectPreferredTheme.
  ///
  /// In en, this message translates to:
  /// **'Select your preferred theme'**
  String get selectPreferredTheme;

  /// No description provided for @naturalTheme.
  ///
  /// In en, this message translates to:
  /// **'Natural'**
  String get naturalTheme;

  /// No description provided for @darkTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get darkTheme;

  /// No description provided for @darkNatural.
  ///
  /// In en, this message translates to:
  /// **'Dark Natural'**
  String get darkNatural;

  /// No description provided for @oceanTheme.
  ///
  /// In en, this message translates to:
  /// **'Ocean'**
  String get oceanTheme;

  /// No description provided for @forestTheme.
  ///
  /// In en, this message translates to:
  /// **'Forest'**
  String get forestTheme;

  /// No description provided for @sunsetTheme.
  ///
  /// In en, this message translates to:
  /// **'Sunset'**
  String get sunsetTheme;

  /// No description provided for @naturalThemeDescription.
  ///
  /// In en, this message translates to:
  /// **'Natural theme with eco-friendly colors'**
  String get naturalThemeDescription;

  /// No description provided for @darkThemeDescription.
  ///
  /// In en, this message translates to:
  /// **'Dark theme for eye comfort'**
  String get darkThemeDescription;

  /// No description provided for @oceanThemeDescription.
  ///
  /// In en, this message translates to:
  /// **'Fresh ocean theme'**
  String get oceanThemeDescription;

  /// No description provided for @forestThemeDescription.
  ///
  /// In en, this message translates to:
  /// **'Natural forest theme'**
  String get forestThemeDescription;

  /// No description provided for @sunsetThemeDescription.
  ///
  /// In en, this message translates to:
  /// **'Warm sunset theme'**
  String get sunsetThemeDescription;

  /// No description provided for @sunnyTheme.
  ///
  /// In en, this message translates to:
  /// **'Sunny'**
  String get sunnyTheme;

  /// No description provided for @sunnyThemeDescription.
  ///
  /// In en, this message translates to:
  /// **'Bright and cheerful yellow theme'**
  String get sunnyThemeDescription;

  /// No description provided for @vibrantTheme.
  ///
  /// In en, this message translates to:
  /// **'Vibrant'**
  String get vibrantTheme;

  /// No description provided for @vibrantThemeDescription.
  ///
  /// In en, this message translates to:
  /// **'Bright pink and purple theme'**
  String get vibrantThemeDescription;

  /// Title for scan analysis card in chat
  ///
  /// In en, this message translates to:
  /// **'Scan Analysis'**
  String get scanAnalysis;

  /// Label for number of ingredients
  ///
  /// In en, this message translates to:
  /// **'ingredients'**
  String get ingredients;

  /// No description provided for @aiBotSettings.
  ///
  /// In en, this message translates to:
  /// **'AI Settings'**
  String get aiBotSettings;

  /// No description provided for @botName.
  ///
  /// In en, this message translates to:
  /// **'Bot Name'**
  String get botName;

  /// No description provided for @enterBotName.
  ///
  /// In en, this message translates to:
  /// **'Enter bot name'**
  String get enterBotName;

  /// No description provided for @pleaseEnterBotName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a bot name'**
  String get pleaseEnterBotName;

  /// No description provided for @botDescription.
  ///
  /// In en, this message translates to:
  /// **'Bot Description'**
  String get botDescription;

  /// No description provided for @selectAvatar.
  ///
  /// In en, this message translates to:
  /// **'Select Avatar'**
  String get selectAvatar;

  /// No description provided for @defaultBotName.
  ///
  /// In en, this message translates to:
  /// **'ACS'**
  String get defaultBotName;

  /// No description provided for @defaultBotDescription.
  ///
  /// In en, this message translates to:
  /// **'Hi! I\'m {name} (AI Cosmetic Scanner). I\'ll help you understand the composition of your cosmetics. I have extensive knowledge in cosmetology and skincare. I\'ll be happy to answer all your questions.'**
  String defaultBotDescription(String name);

  /// No description provided for @settingsSaved.
  ///
  /// In en, this message translates to:
  /// **'Settings saved successfully'**
  String get settingsSaved;

  /// No description provided for @failedToSaveSettings.
  ///
  /// In en, this message translates to:
  /// **'Failed to save settings'**
  String get failedToSaveSettings;

  /// No description provided for @resetToDefault.
  ///
  /// In en, this message translates to:
  /// **'Reset to Default'**
  String get resetToDefault;

  /// No description provided for @resetSettings.
  ///
  /// In en, this message translates to:
  /// **'Reset Settings'**
  String get resetSettings;

  /// No description provided for @resetSettingsConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reset all settings to default values?'**
  String get resetSettingsConfirmation;

  /// No description provided for @settingsResetSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Settings reset successfully'**
  String get settingsResetSuccessfully;

  /// No description provided for @failedToResetSettings.
  ///
  /// In en, this message translates to:
  /// **'Failed to reset settings'**
  String get failedToResetSettings;

  /// No description provided for @unsavedChanges.
  ///
  /// In en, this message translates to:
  /// **'Unsaved Changes'**
  String get unsavedChanges;

  /// No description provided for @unsavedChangesMessage.
  ///
  /// In en, this message translates to:
  /// **'You have unsaved changes. Are you sure you want to leave?'**
  String get unsavedChangesMessage;

  /// No description provided for @stay.
  ///
  /// In en, this message translates to:
  /// **'Stay'**
  String get stay;

  /// No description provided for @leave.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get leave;

  /// No description provided for @errorLoadingSettings.
  ///
  /// In en, this message translates to:
  /// **'Error loading settings'**
  String get errorLoadingSettings;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @customPrompt.
  ///
  /// In en, this message translates to:
  /// **'Special Requests'**
  String get customPrompt;

  /// No description provided for @customPromptDescription.
  ///
  /// In en, this message translates to:
  /// **'Add personalized instructions for the AI assistant'**
  String get customPromptDescription;

  /// No description provided for @customPromptPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Enter your special requests...'**
  String get customPromptPlaceholder;

  /// No description provided for @enableCustomPrompt.
  ///
  /// In en, this message translates to:
  /// **'Enable special requests'**
  String get enableCustomPrompt;

  /// No description provided for @defaultCustomPrompt.
  ///
  /// In en, this message translates to:
  /// **'Give me compliments.'**
  String get defaultCustomPrompt;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @scanningHintTitle.
  ///
  /// In en, this message translates to:
  /// **'How to Scan'**
  String get scanningHintTitle;

  /// No description provided for @scanLimitReached.
  ///
  /// In en, this message translates to:
  /// **'Scan Limit Reached'**
  String get scanLimitReached;

  /// No description provided for @scanLimitReachedMessage.
  ///
  /// In en, this message translates to:
  /// **'You\'ve used all 5 free scans this week. Upgrade to Premium for unlimited scans!'**
  String get scanLimitReachedMessage;

  /// No description provided for @messageLimitReached.
  ///
  /// In en, this message translates to:
  /// **'Daily Message Limit Reached'**
  String get messageLimitReached;

  /// No description provided for @messageLimitReachedMessage.
  ///
  /// In en, this message translates to:
  /// **'You\'ve sent 5 messages today. Upgrade to Premium for unlimited chat!'**
  String get messageLimitReachedMessage;

  /// No description provided for @historyLimitReached.
  ///
  /// In en, this message translates to:
  /// **'History Access Limited'**
  String get historyLimitReached;

  /// No description provided for @historyLimitReachedMessage.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Premium to access your full scan history!'**
  String get historyLimitReachedMessage;

  /// No description provided for @upgradeToPremium.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Premium'**
  String get upgradeToPremium;

  /// No description provided for @upgradeToView.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to View'**
  String get upgradeToView;

  /// No description provided for @upgradeToChat.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Chat'**
  String get upgradeToChat;

  /// No description provided for @premiumFeature.
  ///
  /// In en, this message translates to:
  /// **'Premium Feature'**
  String get premiumFeature;

  /// No description provided for @freePlanUsage.
  ///
  /// In en, this message translates to:
  /// **'Free Plan Usage'**
  String get freePlanUsage;

  /// No description provided for @scansThisWeek.
  ///
  /// In en, this message translates to:
  /// **'Scans this week'**
  String get scansThisWeek;

  /// No description provided for @messagesToday.
  ///
  /// In en, this message translates to:
  /// **'Messages today'**
  String get messagesToday;

  /// No description provided for @limitsReached.
  ///
  /// In en, this message translates to:
  /// **'Limits reached'**
  String get limitsReached;

  /// No description provided for @remainingScans.
  ///
  /// In en, this message translates to:
  /// **'Remaining scans'**
  String get remainingScans;

  /// No description provided for @remainingMessages.
  ///
  /// In en, this message translates to:
  /// **'Remaining messages'**
  String get remainingMessages;

  /// No description provided for @unlockUnlimitedAccess.
  ///
  /// In en, this message translates to:
  /// **'Unlock Unlimited Access'**
  String get unlockUnlimitedAccess;

  /// No description provided for @upgradeToPremiumDescription.
  ///
  /// In en, this message translates to:
  /// **'Get unlimited scans, messages, and full access to your scan history with Premium!'**
  String get upgradeToPremiumDescription;

  /// No description provided for @premiumBenefits.
  ///
  /// In en, this message translates to:
  /// **'Premium Benefits'**
  String get premiumBenefits;

  /// No description provided for @unlimitedAiChatMessages.
  ///
  /// In en, this message translates to:
  /// **'Unlimited AI chat messages'**
  String get unlimitedAiChatMessages;

  /// No description provided for @fullAccessToScanHistory.
  ///
  /// In en, this message translates to:
  /// **'Full access to scan history'**
  String get fullAccessToScanHistory;

  /// No description provided for @prioritySupport.
  ///
  /// In en, this message translates to:
  /// **'Priority support'**
  String get prioritySupport;

  /// No description provided for @learnMore.
  ///
  /// In en, this message translates to:
  /// **'Learn More'**
  String get learnMore;

  /// No description provided for @upgradeNow.
  ///
  /// In en, this message translates to:
  /// **'Upgrade Now'**
  String get upgradeNow;

  /// No description provided for @maybeLater.
  ///
  /// In en, this message translates to:
  /// **'Maybe Later'**
  String get maybeLater;

  /// No description provided for @scanHistoryLimit.
  ///
  /// In en, this message translates to:
  /// **'Only the most recent scan is visible in history'**
  String get scanHistoryLimit;

  /// No description provided for @upgradeForUnlimitedScans.
  ///
  /// In en, this message translates to:
  /// **'Upgrade for unlimited scans!'**
  String get upgradeForUnlimitedScans;

  /// No description provided for @upgradeForUnlimitedChat.
  ///
  /// In en, this message translates to:
  /// **'Upgrade for unlimited chat!'**
  String get upgradeForUnlimitedChat;

  /// No description provided for @slowInternetConnection.
  ///
  /// In en, this message translates to:
  /// **'Slow Internet Connection'**
  String get slowInternetConnection;

  /// No description provided for @slowInternetMessage.
  ///
  /// In en, this message translates to:
  /// **'On a very slow internet connection, you\'ll have to wait a bit... We\'re still analyzing your image.'**
  String get slowInternetMessage;

  /// No description provided for @revolutionaryAI.
  ///
  /// In en, this message translates to:
  /// **'Revolutionary AI'**
  String get revolutionaryAI;

  /// No description provided for @revolutionaryAIDesc.
  ///
  /// In en, this message translates to:
  /// **'One of the smartest in the world'**
  String get revolutionaryAIDesc;

  /// No description provided for @unlimitedScans.
  ///
  /// In en, this message translates to:
  /// **'Unlimited Scans'**
  String get unlimitedScans;

  /// No description provided for @unlimitedScansDesc.
  ///
  /// In en, this message translates to:
  /// **'Explore cosmetics without limits'**
  String get unlimitedScansDesc;

  /// No description provided for @unlimitedChats.
  ///
  /// In en, this message translates to:
  /// **'Unlimited Chats'**
  String get unlimitedChats;

  /// No description provided for @unlimitedChatsDesc.
  ///
  /// In en, this message translates to:
  /// **'Personal AI consultant 24/7'**
  String get unlimitedChatsDesc;

  /// No description provided for @fullHistory.
  ///
  /// In en, this message translates to:
  /// **'Full History'**
  String get fullHistory;

  /// No description provided for @fullHistoryDesc.
  ///
  /// In en, this message translates to:
  /// **'Unlimited scan history'**
  String get fullHistoryDesc;

  /// No description provided for @rememberContext.
  ///
  /// In en, this message translates to:
  /// **'Remembers Context'**
  String get rememberContext;

  /// No description provided for @rememberContextDesc.
  ///
  /// In en, this message translates to:
  /// **'AI remembers your previous messages'**
  String get rememberContextDesc;

  /// No description provided for @allIngredientsInfo.
  ///
  /// In en, this message translates to:
  /// **'All Ingredient Information'**
  String get allIngredientsInfo;

  /// No description provided for @allIngredientsInfoDesc.
  ///
  /// In en, this message translates to:
  /// **'Learn all the details'**
  String get allIngredientsInfoDesc;

  /// No description provided for @noAds.
  ///
  /// In en, this message translates to:
  /// **'100% Ad-Free'**
  String get noAds;

  /// No description provided for @noAdsDesc.
  ///
  /// In en, this message translates to:
  /// **'For those who value their time'**
  String get noAdsDesc;

  /// No description provided for @multiLanguage.
  ///
  /// In en, this message translates to:
  /// **'Knows Almost All Languages'**
  String get multiLanguage;

  /// No description provided for @multiLanguageDesc.
  ///
  /// In en, this message translates to:
  /// **'Enhanced translator'**
  String get multiLanguageDesc;

  /// No description provided for @paywallTitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock the secrets of your cosmetics with AI'**
  String get paywallTitle;

  /// No description provided for @paywallDescription.
  ///
  /// In en, this message translates to:
  /// **'You have the opportunity to get a Premium subscription for 3 days free, then {price} per week. Cancel anytime.'**
  String paywallDescription(String price);

  /// No description provided for @whatsIncluded.
  ///
  /// In en, this message translates to:
  /// **'What\'s Included'**
  String get whatsIncluded;

  /// No description provided for @basicPlan.
  ///
  /// In en, this message translates to:
  /// **'Basic'**
  String get basicPlan;

  /// No description provided for @premiumPlan.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get premiumPlan;

  /// No description provided for @botGreeting1.
  ///
  /// In en, this message translates to:
  /// **'Good day! How can I help you today?'**
  String get botGreeting1;

  /// No description provided for @botGreeting2.
  ///
  /// In en, this message translates to:
  /// **'Hello! What brings you to me?'**
  String get botGreeting2;

  /// No description provided for @botGreeting3.
  ///
  /// In en, this message translates to:
  /// **'I welcome you! Ready to help with cosmetic analysis.'**
  String get botGreeting3;

  /// No description provided for @botGreeting4.
  ///
  /// In en, this message translates to:
  /// **'Glad to see you! How can I be useful?'**
  String get botGreeting4;

  /// No description provided for @botGreeting5.
  ///
  /// In en, this message translates to:
  /// **'Welcome! Let\'s explore the composition of your cosmetics together.'**
  String get botGreeting5;

  /// No description provided for @botGreeting6.
  ///
  /// In en, this message translates to:
  /// **'Hello! Ready to answer your questions about cosmetics.'**
  String get botGreeting6;

  /// No description provided for @botGreeting7.
  ///
  /// In en, this message translates to:
  /// **'Hi! I\'m your personal cosmetology assistant.'**
  String get botGreeting7;

  /// No description provided for @botGreeting8.
  ///
  /// In en, this message translates to:
  /// **'Good day! I\'ll help you understand the composition of cosmetic products.'**
  String get botGreeting8;

  /// No description provided for @botGreeting9.
  ///
  /// In en, this message translates to:
  /// **'Hello! Let\'s make your cosmetics safer together.'**
  String get botGreeting9;

  /// No description provided for @botGreeting10.
  ///
  /// In en, this message translates to:
  /// **'I welcome you! Ready to share knowledge about cosmetics.'**
  String get botGreeting10;

  /// No description provided for @botGreeting11.
  ///
  /// In en, this message translates to:
  /// **'Good day! I\'ll help you find the best cosmetic solutions for you.'**
  String get botGreeting11;

  /// No description provided for @botGreeting12.
  ///
  /// In en, this message translates to:
  /// **'Hello! Your cosmetics safety expert is at your service.'**
  String get botGreeting12;

  /// No description provided for @botGreeting13.
  ///
  /// In en, this message translates to:
  /// **'Hi! Let\'s choose the perfect cosmetics for you together.'**
  String get botGreeting13;

  /// No description provided for @botGreeting14.
  ///
  /// In en, this message translates to:
  /// **'Welcome! Ready to help with ingredient analysis.'**
  String get botGreeting14;

  /// No description provided for @botGreeting15.
  ///
  /// In en, this message translates to:
  /// **'Hello! I\'ll help you understand the composition of your cosmetics.'**
  String get botGreeting15;

  /// No description provided for @botGreeting16.
  ///
  /// In en, this message translates to:
  /// **'I welcome you! Your guide in the world of cosmetology is ready to help.'**
  String get botGreeting16;

  /// No description provided for @copiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get copiedToClipboard;

  /// No description provided for @tryFree.
  ///
  /// In en, this message translates to:
  /// **'Try Free'**
  String get tryFree;

  /// No description provided for @cameraNotReady.
  ///
  /// In en, this message translates to:
  /// **'Camera not ready / no permission'**
  String get cameraNotReady;

  /// No description provided for @cameraPermissionInstructions.
  ///
  /// In en, this message translates to:
  /// **'App Settings:\nAI Cosmetic Scanner > Permissions > Camera > Allow'**
  String get cameraPermissionInstructions;

  /// No description provided for @openSettingsAndGrantAccess.
  ///
  /// In en, this message translates to:
  /// **'Open Settings and grant camera access'**
  String get openSettingsAndGrantAccess;

  /// No description provided for @retryCamera.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retryCamera;

  /// No description provided for @errorServiceOverloaded.
  ///
  /// In en, this message translates to:
  /// **'Service is temporarily busy. Please try again in a moment.'**
  String get errorServiceOverloaded;

  /// No description provided for @errorRateLimitExceeded.
  ///
  /// In en, this message translates to:
  /// **'Too many requests. Please wait a moment and try again.'**
  String get errorRateLimitExceeded;

  /// No description provided for @errorTimeout.
  ///
  /// In en, this message translates to:
  /// **'Request timed out. Please check your internet connection and try again.'**
  String get errorTimeout;

  /// No description provided for @errorNetwork.
  ///
  /// In en, this message translates to:
  /// **'Network error. Please check your internet connection.'**
  String get errorNetwork;

  /// No description provided for @errorAuthentication.
  ///
  /// In en, this message translates to:
  /// **'Authentication error. Please restart the app.'**
  String get errorAuthentication;

  /// No description provided for @errorInvalidResponse.
  ///
  /// In en, this message translates to:
  /// **'Invalid response received. Please try again.'**
  String get errorInvalidResponse;

  /// No description provided for @errorServer.
  ///
  /// In en, this message translates to:
  /// **'Server error. Please try again later.'**
  String get errorServer;

  /// No description provided for @customThemes.
  ///
  /// In en, this message translates to:
  /// **'Custom Themes'**
  String get customThemes;

  /// No description provided for @createCustomTheme.
  ///
  /// In en, this message translates to:
  /// **'Create Custom Theme'**
  String get createCustomTheme;

  /// No description provided for @basedOn.
  ///
  /// In en, this message translates to:
  /// **'Based on'**
  String get basedOn;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get lightMode;

  /// No description provided for @generateWithAI.
  ///
  /// In en, this message translates to:
  /// **'Generate with AI'**
  String get generateWithAI;

  /// No description provided for @resetToBaseTheme.
  ///
  /// In en, this message translates to:
  /// **'Reset to Base Theme'**
  String get resetToBaseTheme;

  /// No description provided for @colorsResetTo.
  ///
  /// In en, this message translates to:
  /// **'Colors reset to {themeName}'**
  String colorsResetTo(Object themeName);

  /// No description provided for @aiGenerationComingSoon.
  ///
  /// In en, this message translates to:
  /// **'AI theme generation coming in Iteration 5!'**
  String get aiGenerationComingSoon;

  /// No description provided for @onboardingGreeting.
  ///
  /// In en, this message translates to:
  /// **'Welcome! To improve the quality of answers, let\'s set up your profile'**
  String get onboardingGreeting;

  /// No description provided for @letsGo.
  ///
  /// In en, this message translates to:
  /// **'Let\'s Go'**
  String get letsGo;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @finish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// No description provided for @customThemeInDevelopment.
  ///
  /// In en, this message translates to:
  /// **'Custom themes feature is under development'**
  String get customThemeInDevelopment;

  /// No description provided for @customThemeComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon in future updates'**
  String get customThemeComingSoon;

  /// No description provided for @dailyMessageLimitReached.
  ///
  /// In en, this message translates to:
  /// **'Limit Reached'**
  String get dailyMessageLimitReached;

  /// No description provided for @dailyMessageLimitReachedMessage.
  ///
  /// In en, this message translates to:
  /// **'You\'ve sent 5 messages today. Upgrade to Premium for unlimited chat!'**
  String get dailyMessageLimitReachedMessage;

  /// No description provided for @upgradeToPremiumForUnlimitedChat.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Premium for unlimited chat'**
  String get upgradeToPremiumForUnlimitedChat;

  /// No description provided for @messagesLeftToday.
  ///
  /// In en, this message translates to:
  /// **'messages left today'**
  String get messagesLeftToday;

  /// No description provided for @designYourOwnTheme.
  ///
  /// In en, this message translates to:
  /// **'Design your own theme'**
  String get designYourOwnTheme;

  /// No description provided for @darkOcean.
  ///
  /// In en, this message translates to:
  /// **'Dark Ocean'**
  String get darkOcean;

  /// No description provided for @darkForest.
  ///
  /// In en, this message translates to:
  /// **'Dark Forest'**
  String get darkForest;

  /// No description provided for @darkSunset.
  ///
  /// In en, this message translates to:
  /// **'Dark Sunset'**
  String get darkSunset;

  /// No description provided for @darkVibrant.
  ///
  /// In en, this message translates to:
  /// **'Dark Vibrant'**
  String get darkVibrant;

  /// No description provided for @darkOceanThemeDescription.
  ///
  /// In en, this message translates to:
  /// **'Dark ocean theme with cyan accents'**
  String get darkOceanThemeDescription;

  /// No description provided for @darkForestThemeDescription.
  ///
  /// In en, this message translates to:
  /// **'Dark forest theme with lime green accents'**
  String get darkForestThemeDescription;

  /// No description provided for @darkSunsetThemeDescription.
  ///
  /// In en, this message translates to:
  /// **'Dark sunset theme with orange accents'**
  String get darkSunsetThemeDescription;

  /// No description provided for @darkVibrantThemeDescription.
  ///
  /// In en, this message translates to:
  /// **'Dark vibrant theme with pink and purple accents'**
  String get darkVibrantThemeDescription;

  /// No description provided for @customTheme.
  ///
  /// In en, this message translates to:
  /// **'Custom theme'**
  String get customTheme;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @deleteTheme.
  ///
  /// In en, this message translates to:
  /// **'Delete Theme'**
  String get deleteTheme;

  /// No description provided for @deleteThemeConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{themeName}\"?'**
  String deleteThemeConfirmation(String themeName);

  /// No description provided for @pollTitle.
  ///
  /// In en, this message translates to:
  /// **'What\'s missing?'**
  String get pollTitle;

  /// No description provided for @pollCardTitle.
  ///
  /// In en, this message translates to:
  /// **'What\'s missing in the app?'**
  String get pollCardTitle;

  /// No description provided for @pollCardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Which 3 features should be added?'**
  String get pollCardSubtitle;

  /// No description provided for @pollDescription.
  ///
  /// In en, this message translates to:
  /// **'Vote for the options you want to see'**
  String get pollDescription;

  /// No description provided for @submitVote.
  ///
  /// In en, this message translates to:
  /// **'Vote'**
  String get submitVote;

  /// No description provided for @submitting.
  ///
  /// In en, this message translates to:
  /// **'Submitting...'**
  String get submitting;

  /// No description provided for @voteSubmittedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Votes submitted successfully!'**
  String get voteSubmittedSuccess;

  /// No description provided for @votesRemaining.
  ///
  /// In en, this message translates to:
  /// **'{count} votes remaining'**
  String votesRemaining(int count);

  /// No description provided for @votes.
  ///
  /// In en, this message translates to:
  /// **'votes'**
  String get votes;

  /// No description provided for @addYourOption.
  ///
  /// In en, this message translates to:
  /// **'Suggest improvement'**
  String get addYourOption;

  /// No description provided for @enterYourOption.
  ///
  /// In en, this message translates to:
  /// **'Enter your option...'**
  String get enterYourOption;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @filterTopVoted.
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get filterTopVoted;

  /// No description provided for @filterNewest.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get filterNewest;

  /// No description provided for @filterMyOption.
  ///
  /// In en, this message translates to:
  /// **'My Choice'**
  String get filterMyOption;

  /// No description provided for @thankYouForVoting.
  ///
  /// In en, this message translates to:
  /// **'Thank you for voting!'**
  String get thankYouForVoting;

  /// No description provided for @votingComplete.
  ///
  /// In en, this message translates to:
  /// **'Your vote has been recorded'**
  String get votingComplete;

  /// No description provided for @requestFeatureDevelopment.
  ///
  /// In en, this message translates to:
  /// **'Request Custom Feature Development'**
  String get requestFeatureDevelopment;

  /// No description provided for @requestFeatureDescription.
  ///
  /// In en, this message translates to:
  /// **'Need a specific feature? Contact us to discuss custom development for your business needs.'**
  String get requestFeatureDescription;

  /// No description provided for @pollHelpTitle.
  ///
  /// In en, this message translates to:
  /// **'How to vote'**
  String get pollHelpTitle;

  /// No description provided for @pollHelpDescription.
  ///
  /// In en, this message translates to:
  /// **'• Tap an option to select it\n• Tap again to deselect\n• Select as many options as you like\n• Click \'Vote\' button to submit your votes\n• Add your own option if you don\'t see what you need'**
  String get pollHelpDescription;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'cs', 'da', 'de', 'el', 'en', 'es', 'fi', 'fr', 'hi', 'hu', 'id', 'it', 'ja', 'ko', 'nl', 'no', 'pl', 'pt', 'ro', 'ru', 'sv', 'th', 'tr', 'uk', 'vi', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {

  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'es': {
  switch (locale.countryCode) {
    case '419': return AppLocalizationsEs419();
case 'ES': return AppLocalizationsEsEs();
   }
  break;
   }
    case 'pt': {
  switch (locale.countryCode) {
    case 'BR': return AppLocalizationsPtBr();
case 'PT': return AppLocalizationsPtPt();
   }
  break;
   }
    case 'zh': {
  switch (locale.countryCode) {
    case 'CN': return AppLocalizationsZhCn();
case 'TW': return AppLocalizationsZhTw();
   }
  break;
   }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'cs': return AppLocalizationsCs();
    case 'da': return AppLocalizationsDa();
    case 'de': return AppLocalizationsDe();
    case 'el': return AppLocalizationsEl();
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
    case 'fi': return AppLocalizationsFi();
    case 'fr': return AppLocalizationsFr();
    case 'hi': return AppLocalizationsHi();
    case 'hu': return AppLocalizationsHu();
    case 'id': return AppLocalizationsId();
    case 'it': return AppLocalizationsIt();
    case 'ja': return AppLocalizationsJa();
    case 'ko': return AppLocalizationsKo();
    case 'nl': return AppLocalizationsNl();
    case 'no': return AppLocalizationsNo();
    case 'pl': return AppLocalizationsPl();
    case 'pt': return AppLocalizationsPt();
    case 'ro': return AppLocalizationsRo();
    case 'ru': return AppLocalizationsRu();
    case 'sv': return AppLocalizationsSv();
    case 'th': return AppLocalizationsTh();
    case 'tr': return AppLocalizationsTr();
    case 'uk': return AppLocalizationsUk();
    case 'vi': return AppLocalizationsVi();
    case 'zh': return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
