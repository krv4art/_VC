import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
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
  ];

  /// Application title
  ///
  /// In en, this message translates to:
  /// **'AI Tutor'**
  String get appTitle;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

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

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @onboardingWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to AI Tutor!'**
  String get onboardingWelcomeTitle;

  /// No description provided for @onboardingWelcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your personalized learning companion'**
  String get onboardingWelcomeSubtitle;

  /// No description provided for @onboardingWelcomeDescription.
  ///
  /// In en, this message translates to:
  /// **'Learn through your interests with AI-powered tutoring'**
  String get onboardingWelcomeDescription;

  /// No description provided for @yourInterests.
  ///
  /// In en, this message translates to:
  /// **'Your Interests'**
  String get yourInterests;

  /// No description provided for @selectInterestsPrompt.
  ///
  /// In en, this message translates to:
  /// **'What are you interested in?'**
  String get selectInterestsPrompt;

  /// No description provided for @selectInterestsDescription.
  ///
  /// In en, this message translates to:
  /// **'We\'ll use these to make learning fun and relatable!\nSelect 1-5 interests.'**
  String get selectInterestsDescription;

  /// Number of interests selected
  ///
  /// In en, this message translates to:
  /// **'{count}/{max} selected'**
  String interestsSelected(int count, int max);

  /// No description provided for @addYourOwnInterest.
  ///
  /// In en, this message translates to:
  /// **'Add Your Own Interest'**
  String get addYourOwnInterest;

  /// No description provided for @selectAtLeastOneInterest.
  ///
  /// In en, this message translates to:
  /// **'Please select at least 1 interest'**
  String get selectAtLeastOneInterest;

  /// No description provided for @maxInterestsReached.
  ///
  /// In en, this message translates to:
  /// **'You can select up to {max} interests'**
  String maxInterestsReached(int max);

  /// No description provided for @addCustomInterestTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Your Own Interest'**
  String get addCustomInterestTitle;

  /// No description provided for @chooseEmoji.
  ///
  /// In en, this message translates to:
  /// **'Choose an emoji'**
  String get chooseEmoji;

  /// No description provided for @interestName.
  ///
  /// In en, this message translates to:
  /// **'Interest name'**
  String get interestName;

  /// No description provided for @interestNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., LEGO, Dinosaurs, Dancing'**
  String get interestNameHint;

  /// No description provided for @keywordsForAI.
  ///
  /// In en, this message translates to:
  /// **'Keywords (for AI personalization)'**
  String get keywordsForAI;

  /// No description provided for @keywordsSeparator.
  ///
  /// In en, this message translates to:
  /// **'Separate with commas or spaces'**
  String get keywordsSeparator;

  /// No description provided for @keywordsHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., blocks, build, bricks, pieces'**
  String get keywordsHint;

  /// No description provided for @keywordsInfo.
  ///
  /// In en, this message translates to:
  /// **'AI will use these keywords to create personalized examples in all lessons!'**
  String get keywordsInfo;

  /// No description provided for @enterInterestName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a name for your interest'**
  String get enterInterestName;

  /// No description provided for @enterKeywords.
  ///
  /// In en, this message translates to:
  /// **'Please enter at least one keyword'**
  String get enterKeywords;

  /// No description provided for @enterValidKeywords.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid keywords'**
  String get enterValidKeywords;

  /// No description provided for @addInterest.
  ///
  /// In en, this message translates to:
  /// **'Add Interest'**
  String get addInterest;

  /// No description provided for @culturalTheme.
  ///
  /// In en, this message translates to:
  /// **'Cultural Theme'**
  String get culturalTheme;

  /// No description provided for @chooseCulturalTheme.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Style'**
  String get chooseCulturalTheme;

  /// No description provided for @culturalThemeDescription.
  ///
  /// In en, this message translates to:
  /// **'Pick a theme that resonates with you'**
  String get culturalThemeDescription;

  /// No description provided for @learningStyle.
  ///
  /// In en, this message translates to:
  /// **'Learning Style'**
  String get learningStyle;

  /// No description provided for @chooseLearningStyle.
  ///
  /// In en, this message translates to:
  /// **'How do you learn best?'**
  String get chooseLearningStyle;

  /// No description provided for @learningStyleDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred teaching approach'**
  String get learningStyleDescription;

  /// No description provided for @levelAssessment.
  ///
  /// In en, this message translates to:
  /// **'Level Assessment'**
  String get levelAssessment;

  /// No description provided for @setYourLevel.
  ///
  /// In en, this message translates to:
  /// **'Set your grade level for each subject'**
  String get setYourLevel;

  /// No description provided for @gradeLevel.
  ///
  /// In en, this message translates to:
  /// **'Grade {level}'**
  String gradeLevel(int level);

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @practice.
  ///
  /// In en, this message translates to:
  /// **'Practice'**
  String get practice;

  /// No description provided for @progress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progress;

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

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get goodMorning;

  /// No description provided for @goodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get goodEvening;

  /// No description provided for @dailyChallenge.
  ///
  /// In en, this message translates to:
  /// **'Daily Challenge'**
  String get dailyChallenge;

  /// No description provided for @todaysChallenge.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Challenge'**
  String get todaysChallenge;

  /// No description provided for @completedChallenges.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completedChallenges;

  /// No description provided for @activeGoals.
  ///
  /// In en, this message translates to:
  /// **'Active Goals'**
  String get activeGoals;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @startPractice.
  ///
  /// In en, this message translates to:
  /// **'Practice'**
  String get startPractice;

  /// No description provided for @challenges.
  ///
  /// In en, this message translates to:
  /// **'Challenges'**
  String get challenges;

  /// No description provided for @weeklyReport.
  ///
  /// In en, this message translates to:
  /// **'Weekly Report'**
  String get weeklyReport;

  /// No description provided for @aiTutor.
  ///
  /// In en, this message translates to:
  /// **'AI Tutor'**
  String get aiTutor;

  /// No description provided for @askQuestion.
  ///
  /// In en, this message translates to:
  /// **'Ask a question...'**
  String get askQuestion;

  /// No description provided for @typeMessage.
  ///
  /// In en, this message translates to:
  /// **'Type your message...'**
  String get typeMessage;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @practiceMode.
  ///
  /// In en, this message translates to:
  /// **'Practice Mode'**
  String get practiceMode;

  /// No description provided for @selectDifficulty.
  ///
  /// In en, this message translates to:
  /// **'Select Difficulty'**
  String get selectDifficulty;

  /// No description provided for @easy.
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get easy;

  /// No description provided for @medium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// No description provided for @hard.
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get hard;

  /// No description provided for @generateProblems.
  ///
  /// In en, this message translates to:
  /// **'Generate Problems'**
  String get generateProblems;

  /// No description provided for @checkAnswer.
  ///
  /// In en, this message translates to:
  /// **'Check Answer'**
  String get checkAnswer;

  /// No description provided for @nextProblem.
  ///
  /// In en, this message translates to:
  /// **'Next Problem'**
  String get nextProblem;

  /// No description provided for @showHint.
  ///
  /// In en, this message translates to:
  /// **'Show Hint'**
  String get showHint;

  /// No description provided for @showSolution.
  ///
  /// In en, this message translates to:
  /// **'Show Solution'**
  String get showSolution;

  /// No description provided for @correct.
  ///
  /// In en, this message translates to:
  /// **'Correct'**
  String get correct;

  /// No description provided for @incorrect.
  ///
  /// In en, this message translates to:
  /// **'Incorrect'**
  String get incorrect;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @yourProgress.
  ///
  /// In en, this message translates to:
  /// **'Your Progress'**
  String get yourProgress;

  /// No description provided for @totalProblems.
  ///
  /// In en, this message translates to:
  /// **'Total Problems'**
  String get totalProblems;

  /// No description provided for @accuracy.
  ///
  /// In en, this message translates to:
  /// **'Accuracy'**
  String get accuracy;

  /// No description provided for @currentStreak.
  ///
  /// In en, this message translates to:
  /// **'Current Streak'**
  String get currentStreak;

  /// No description provided for @longestStreak.
  ///
  /// In en, this message translates to:
  /// **'Longest Streak'**
  String get longestStreak;

  /// No description provided for @studyTime.
  ///
  /// In en, this message translates to:
  /// **'Study Time'**
  String get studyTime;

  /// No description provided for @achievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievements;

  /// No description provided for @unlocked.
  ///
  /// In en, this message translates to:
  /// **'Unlocked'**
  String get unlocked;

  /// No description provided for @locked.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get locked;

  /// No description provided for @challengesAndGoals.
  ///
  /// In en, this message translates to:
  /// **'Challenges & Goals'**
  String get challengesAndGoals;

  /// No description provided for @createNewGoal.
  ///
  /// In en, this message translates to:
  /// **'Create New Goal'**
  String get createNewGoal;

  /// No description provided for @goalType.
  ///
  /// In en, this message translates to:
  /// **'Goal Type'**
  String get goalType;

  /// No description provided for @targetValue.
  ///
  /// In en, this message translates to:
  /// **'Target Value'**
  String get targetValue;

  /// No description provided for @deadline.
  ///
  /// In en, this message translates to:
  /// **'Deadline'**
  String get deadline;

  /// No description provided for @problemsSolved.
  ///
  /// In en, this message translates to:
  /// **'Problems Solved'**
  String get problemsSolved;

  /// No description provided for @accuracyTarget.
  ///
  /// In en, this message translates to:
  /// **'Accuracy Target'**
  String get accuracyTarget;

  /// No description provided for @streakGoal.
  ///
  /// In en, this message translates to:
  /// **'Streak Goal'**
  String get streakGoal;

  /// No description provided for @studyTimeGoal.
  ///
  /// In en, this message translates to:
  /// **'Study Time'**
  String get studyTimeGoal;

  /// No description provided for @topicMastery.
  ///
  /// In en, this message translates to:
  /// **'Topic Mastery'**
  String get topicMastery;

  /// No description provided for @weeklyReportTitle.
  ///
  /// In en, this message translates to:
  /// **'Weekly Report'**
  String get weeklyReportTitle;

  /// No description provided for @last7Days.
  ///
  /// In en, this message translates to:
  /// **'Last 7 Days'**
  String get last7Days;

  /// No description provided for @problemsPerDay.
  ///
  /// In en, this message translates to:
  /// **'Problems per Day'**
  String get problemsPerDay;

  /// No description provided for @averageAccuracy.
  ///
  /// In en, this message translates to:
  /// **'Average Accuracy'**
  String get averageAccuracy;

  /// No description provided for @totalStudyTime.
  ///
  /// In en, this message translates to:
  /// **'Total Study Time'**
  String get totalStudyTime;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'{count} min'**
  String minutes(int count);

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'{count} hrs'**
  String hours(int count);

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @editInterests.
  ///
  /// In en, this message translates to:
  /// **'Edit Interests'**
  String get editInterests;

  /// No description provided for @changeTheme.
  ///
  /// In en, this message translates to:
  /// **'Change Theme'**
  String get changeTheme;

  /// No description provided for @changeLearningStyle.
  ///
  /// In en, this message translates to:
  /// **'Change Learning Style'**
  String get changeLearningStyle;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @enableNotifications.
  ///
  /// In en, this message translates to:
  /// **'Enable Notifications'**
  String get enableNotifications;

  /// No description provided for @dailyReminders.
  ///
  /// In en, this message translates to:
  /// **'Daily Reminders'**
  String get dailyReminders;

  /// No description provided for @streakReminders.
  ///
  /// In en, this message translates to:
  /// **'Streak Reminders'**
  String get streakReminders;

  /// No description provided for @achievementAlerts.
  ///
  /// In en, this message translates to:
  /// **'Achievement Alerts'**
  String get achievementAlerts;

  /// No description provided for @progressAndGoals.
  ///
  /// In en, this message translates to:
  /// **'Progress & Goals'**
  String get progressAndGoals;

  /// No description provided for @viewGoals.
  ///
  /// In en, this message translates to:
  /// **'View Goals'**
  String get viewGoals;

  /// No description provided for @resetProgress.
  ///
  /// In en, this message translates to:
  /// **'Reset Progress'**
  String get resetProgress;

  /// No description provided for @resetProgressWarning.
  ///
  /// In en, this message translates to:
  /// **'This will delete all your progress. Are you sure?'**
  String get resetProgressWarning;

  /// No description provided for @data.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get data;

  /// No description provided for @shareProgress.
  ///
  /// In en, this message translates to:
  /// **'Share Progress'**
  String get shareProgress;

  /// No description provided for @exportData.
  ///
  /// In en, this message translates to:
  /// **'Export Data'**
  String get exportData;

  /// No description provided for @exportDataComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get exportDataComingSoon;

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

  /// No description provided for @feedback.
  ///
  /// In en, this message translates to:
  /// **'Send Feedback'**
  String get feedback;

  /// No description provided for @rateApp.
  ///
  /// In en, this message translates to:
  /// **'Rate App'**
  String get rateApp;

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

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @russian.
  ///
  /// In en, this message translates to:
  /// **'Русский'**
  String get russian;

  /// No description provided for @subjects.
  ///
  /// In en, this message translates to:
  /// **'Subjects'**
  String get subjects;

  /// No description provided for @mathematics.
  ///
  /// In en, this message translates to:
  /// **'Mathematics'**
  String get mathematics;

  /// No description provided for @physics.
  ///
  /// In en, this message translates to:
  /// **'Physics'**
  String get physics;

  /// No description provided for @chemistry.
  ///
  /// In en, this message translates to:
  /// **'Chemistry'**
  String get chemistry;

  /// No description provided for @programming.
  ///
  /// In en, this message translates to:
  /// **'Programming'**
  String get programming;

  /// No description provided for @biology.
  ///
  /// In en, this message translates to:
  /// **'Biology'**
  String get biology;

  /// No description provided for @englishSubject.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get englishSubject;

  /// No description provided for @interests.
  ///
  /// In en, this message translates to:
  /// **'Interests'**
  String get interests;

  /// No description provided for @gaming.
  ///
  /// In en, this message translates to:
  /// **'Gaming'**
  String get gaming;

  /// No description provided for @sports.
  ///
  /// In en, this message translates to:
  /// **'Sports'**
  String get sports;

  /// No description provided for @spaceAstronomy.
  ///
  /// In en, this message translates to:
  /// **'Space & Astronomy'**
  String get spaceAstronomy;

  /// No description provided for @animalsNature.
  ///
  /// In en, this message translates to:
  /// **'Animals & Nature'**
  String get animalsNature;

  /// No description provided for @music.
  ///
  /// In en, this message translates to:
  /// **'Music'**
  String get music;

  /// No description provided for @artDrawing.
  ///
  /// In en, this message translates to:
  /// **'Art & Drawing'**
  String get artDrawing;

  /// No description provided for @coding.
  ///
  /// In en, this message translates to:
  /// **'Programming'**
  String get coding;

  /// No description provided for @moviesTV.
  ///
  /// In en, this message translates to:
  /// **'Movies & TV'**
  String get moviesTV;

  /// No description provided for @booksReading.
  ///
  /// In en, this message translates to:
  /// **'Books & Reading'**
  String get booksReading;

  /// No description provided for @cookingFood.
  ///
  /// In en, this message translates to:
  /// **'Cooking & Food'**
  String get cookingFood;

  /// No description provided for @themes.
  ///
  /// In en, this message translates to:
  /// **'Themes'**
  String get themes;

  /// No description provided for @classic.
  ///
  /// In en, this message translates to:
  /// **'Classic'**
  String get classic;

  /// No description provided for @japanese.
  ///
  /// In en, this message translates to:
  /// **'Japanese'**
  String get japanese;

  /// No description provided for @eastern.
  ///
  /// In en, this message translates to:
  /// **'Eastern'**
  String get eastern;

  /// No description provided for @cyberpunk.
  ///
  /// In en, this message translates to:
  /// **'Cyberpunk'**
  String get cyberpunk;

  /// No description provided for @scandinavian.
  ///
  /// In en, this message translates to:
  /// **'Scandinavian'**
  String get scandinavian;

  /// No description provided for @vibrant.
  ///
  /// In en, this message translates to:
  /// **'Vibrant'**
  String get vibrant;

  /// No description provided for @african.
  ///
  /// In en, this message translates to:
  /// **'African'**
  String get african;

  /// No description provided for @latinAmerican.
  ///
  /// In en, this message translates to:
  /// **'Latin American'**
  String get latinAmerican;

  /// No description provided for @learningStyles.
  ///
  /// In en, this message translates to:
  /// **'Learning Styles'**
  String get learningStyles;

  /// No description provided for @visual.
  ///
  /// In en, this message translates to:
  /// **'Visual (Charts & Diagrams)'**
  String get visual;

  /// No description provided for @practical.
  ///
  /// In en, this message translates to:
  /// **'Practical (Examples & Practice)'**
  String get practical;

  /// No description provided for @theoretical.
  ///
  /// In en, this message translates to:
  /// **'Theoretical (Detailed Explanations)'**
  String get theoretical;

  /// No description provided for @balanced.
  ///
  /// In en, this message translates to:
  /// **'Balanced (Mix of Everything)'**
  String get balanced;

  /// No description provided for @quick.
  ///
  /// In en, this message translates to:
  /// **'Quick (Fast & Concise)'**
  String get quick;

  /// No description provided for @achievementUnlocked.
  ///
  /// In en, this message translates to:
  /// **'Achievement Unlocked!'**
  String get achievementUnlocked;

  /// No description provided for @achievementMathWizard.
  ///
  /// In en, this message translates to:
  /// **'Math Wizard'**
  String get achievementMathWizard;

  /// No description provided for @achievementScholar.
  ///
  /// In en, this message translates to:
  /// **'Scholar'**
  String get achievementScholar;

  /// No description provided for @achievementEinstein.
  ///
  /// In en, this message translates to:
  /// **'Einstein'**
  String get achievementEinstein;

  /// No description provided for @achievementOnFire.
  ///
  /// In en, this message translates to:
  /// **'On Fire'**
  String get achievementOnFire;

  /// No description provided for @achievementUnstoppable.
  ///
  /// In en, this message translates to:
  /// **'Unstoppable'**
  String get achievementUnstoppable;

  /// No description provided for @achievementDiamondStreak.
  ///
  /// In en, this message translates to:
  /// **'Diamond Streak'**
  String get achievementDiamondStreak;

  /// No description provided for @achievementPerfectionist.
  ///
  /// In en, this message translates to:
  /// **'Perfectionist'**
  String get achievementPerfectionist;

  /// No description provided for @achievementAceStudent.
  ///
  /// In en, this message translates to:
  /// **'Ace Student'**
  String get achievementAceStudent;

  /// No description provided for @achievementSpeedDemon.
  ///
  /// In en, this message translates to:
  /// **'Speed Demon'**
  String get achievementSpeedDemon;

  /// No description provided for @achievementBookworm.
  ///
  /// In en, this message translates to:
  /// **'Bookworm'**
  String get achievementBookworm;

  /// No description provided for @achievementRisingStar.
  ///
  /// In en, this message translates to:
  /// **'Rising Star'**
  String get achievementRisingStar;

  /// No description provided for @achievementMasterLearner.
  ///
  /// In en, this message translates to:
  /// **'Master Learner'**
  String get achievementMasterLearner;

  /// No description provided for @shareProgressText.
  ///
  /// In en, this message translates to:
  /// **'🎓 My AI Tutor Progress\n📊 Problems Solved: {problems}\n✅ Accuracy: {accuracy}%\n🔥 Streak: {streak} days'**
  String shareProgressText(int problems, int accuracy, int streak);

  /// No description provided for @brainTraining.
  ///
  /// In en, this message translates to:
  /// **'Brain Training'**
  String get brainTraining;

  /// No description provided for @stroopTest.
  ///
  /// In en, this message translates to:
  /// **'Stroop Test'**
  String get stroopTest;

  /// No description provided for @memoryCards.
  ///
  /// In en, this message translates to:
  /// **'Memory Cards'**
  String get memoryCards;

  /// No description provided for @speedReading.
  ///
  /// In en, this message translates to:
  /// **'Speed Reading'**
  String get speedReading;

  /// No description provided for @shapeCounter.
  ///
  /// In en, this message translates to:
  /// **'Shape Counter'**
  String get shapeCounter;

  /// No description provided for @numberSequences.
  ///
  /// In en, this message translates to:
  /// **'Number Sequences'**
  String get numberSequences;

  /// No description provided for @nBackTest.
  ///
  /// In en, this message translates to:
  /// **'N-Back Test'**
  String get nBackTest;

  /// No description provided for @quickMath.
  ///
  /// In en, this message translates to:
  /// **'Quick Math'**
  String get quickMath;

  /// No description provided for @spotTheDifference.
  ///
  /// In en, this message translates to:
  /// **'Spot the Difference'**
  String get spotTheDifference;

  /// No description provided for @overallStats.
  ///
  /// In en, this message translates to:
  /// **'Overall Stats'**
  String get overallStats;

  /// No description provided for @exercises.
  ///
  /// In en, this message translates to:
  /// **'Exercises'**
  String get exercises;

  /// No description provided for @played.
  ///
  /// In en, this message translates to:
  /// **'Played'**
  String get played;

  /// No description provided for @best.
  ///
  /// In en, this message translates to:
  /// **'Best'**
  String get best;

  /// No description provided for @newExercise.
  ///
  /// In en, this message translates to:
  /// **'New!'**
  String get newExercise;

  /// No description provided for @efficiency.
  ///
  /// In en, this message translates to:
  /// **'Efficiency'**
  String get efficiency;

  /// No description provided for @moves.
  ///
  /// In en, this message translates to:
  /// **'Moves'**
  String get moves;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @leaderboard.
  ///
  /// In en, this message translates to:
  /// **'Leaderboard'**
  String get leaderboard;

  /// No description provided for @friends.
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get friends;

  /// No description provided for @analytics.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analytics;

  /// No description provided for @premium.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get premium;

  /// No description provided for @transformProblem.
  ///
  /// In en, this message translates to:
  /// **'Make it Fun ✨'**
  String get transformProblem;

  /// No description provided for @transforming.
  ///
  /// In en, this message translates to:
  /// **'Transforming...'**
  String get transforming;

  /// No description provided for @transformed.
  ///
  /// In en, this message translates to:
  /// **'Transformed: {interest}'**
  String transformed(String interest);

  /// No description provided for @original.
  ///
  /// In en, this message translates to:
  /// **'Original'**
  String get original;

  /// No description provided for @errorTransforming.
  ///
  /// In en, this message translates to:
  /// **'Error transforming problem'**
  String get errorTransforming;
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
