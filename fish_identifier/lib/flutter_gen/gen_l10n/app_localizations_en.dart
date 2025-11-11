// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Fish Identifier';

  @override
  String get appTagline => 'AI-Powered Fish Recognition';

  @override
  String get tabCamera => 'Camera';

  @override
  String get tabHistory => 'History';

  @override
  String get tabCollection => 'Collection';

  @override
  String get tabChat => 'Chat';

  @override
  String get tabSettings => 'Settings';

  @override
  String get cameraTitle => 'Identify Fish';

  @override
  String get cameraHint => 'Take a photo or select from gallery';

  @override
  String get takePhoto => 'Take Photo';

  @override
  String get selectFromGallery => 'Select from Gallery';

  @override
  String get identifyingFish => 'Identifying fish...';

  @override
  String get fishName => 'Fish Name';

  @override
  String get scientificName => 'Scientific Name';

  @override
  String get habitat => 'Habitat';

  @override
  String get diet => 'Diet';

  @override
  String get funFacts => 'Fun Facts';

  @override
  String get confidence => 'Confidence';

  @override
  String get edibility => 'Edibility';

  @override
  String get cookingTips => 'Cooking Tips';

  @override
  String get fishingTips => 'Fishing Tips';

  @override
  String get conservationStatus => 'Conservation Status';

  @override
  String get edible => 'Edible';

  @override
  String get notRecommended => 'Not Recommended';

  @override
  String get toxic => 'Toxic';

  @override
  String get addToCollection => 'Add to Collection';

  @override
  String get chatAboutFish => 'Chat about this fish';

  @override
  String get shareResult => 'Share Result';

  @override
  String get deleteResult => 'Delete';

  @override
  String get collectionTitle => 'My Collection';

  @override
  String get collectionEmpty => 'No fish in your collection yet';

  @override
  String get collectionHint => 'Start identifying fish to build your collection!';

  @override
  String get totalCatches => 'Total Catches';

  @override
  String get favoriteFish => 'Favorite Fish';

  @override
  String get addNotes => 'Add Notes';

  @override
  String get catchDetails => 'Catch Details';

  @override
  String get location => 'Location';

  @override
  String get date => 'Date';

  @override
  String get weight => 'Weight';

  @override
  String get length => 'Length';

  @override
  String get baitUsed => 'Bait Used';

  @override
  String get weatherConditions => 'Weather';

  @override
  String get chatTitle => 'Fish AI Assistant';

  @override
  String get chatHint => 'Ask me anything about fish, fishing, or cooking!';

  @override
  String get chatPlaceholder => 'Type your question...';

  @override
  String get chatSend => 'Send';

  @override
  String get chatSampleQuestions => 'Sample Questions';

  @override
  String get chatClear => 'Clear Chat';

  @override
  String get historyTitle => 'Identification History';

  @override
  String get historyEmpty => 'No identifications yet';

  @override
  String get historyHint => 'Your identified fish will appear here';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsThemeOcean => 'Ocean Blue';

  @override
  String get settingsThemeDeep => 'Deep Sea';

  @override
  String get settingsThemeTropical => 'Tropical Waters';

  @override
  String get settingsThemeKhaki => 'Khaki Camouflage';

  @override
  String get settingsDarkMode => 'Dark Mode';

  @override
  String get settingsAbout => 'About';

  @override
  String get settingsClearData => 'Clear All Data';

  @override
  String get settingsRate => 'Rate App';

  @override
  String get settingsShare => 'Share App';

  @override
  String get settingsFeedback => 'Send Feedback';

  @override
  String get confirmClearData => 'Clear all data?';

  @override
  String get confirmClearDataMessage => 'This will delete all identifications, collection items, and chat history. This action cannot be undone.';

  @override
  String get confirm => 'Confirm';

  @override
  String get cancel => 'Cancel';

  @override
  String get errorTitle => 'Error';

  @override
  String get errorNetwork => 'Network error. Please check your connection.';

  @override
  String get errorServiceOverloaded => 'Service is temporarily overloaded. Please try again in a moment.';

  @override
  String get errorRateLimit => 'Too many requests. Please wait a moment.';

  @override
  String get errorInvalidResponse => 'Unable to process the response. Please try again.';

  @override
  String get errorNotFish => 'This doesn\'t appear to be a fish. Please try another image.';

  @override
  String get errorGeneral => 'Something went wrong. Please try again.';

  @override
  String get retry => 'Retry';

  @override
  String get close => 'Close';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get done => 'Done';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get feedback => 'Feedback';

  @override
  String catchNumber(Object number) {
    return 'Catch #$number';
  }

  @override
  String get shareComingSoon => 'Share feature coming soon!';

  @override
  String get dataCleared => 'Data cleared successfully';

  @override
  String get openingAppStore => 'Opening app store...';

  @override
  String get ratingTitle => 'Enjoying Fish Identifier?';

  @override
  String get ratingMessage => 'Your feedback helps us improve the app!';

  @override
  String get rateNow => 'Rate Now';

  @override
  String get maybeLater => 'Maybe Later';

  @override
  String get noThanks => 'No Thanks';

  @override
  String get surveyTitle => 'Help us improve!';

  @override
  String get surveyQuestion => 'What feature would you like to see next?';

  @override
  String get surveyOption1 => 'Social feed to share catches';

  @override
  String get surveyOption2 => 'Fishing spot recommendations';

  @override
  String get surveyOption3 => 'Weather-based predictions';

  @override
  String get surveyOption4 => 'Recipe database';

  @override
  String get surveySubmit => 'Submit';

  @override
  String get surveyThankYou => 'Thank you for your feedback!';

  @override
  String get premiumTitle => 'Upgrade to Premium';

  @override
  String get premiumFeature1 => 'Unlimited identifications';

  @override
  String get premiumFeature2 => 'Unlimited AI chat';

  @override
  String get premiumFeature3 => 'GPS location tracking';

  @override
  String get premiumFeature4 => 'Advanced statistics';

  @override
  String get premiumFeature5 => 'Cloud backup';

  @override
  String get premiumFeature6 => 'Ad-free experience';

  @override
  String get premiumPrice => '\$4.99/month or \$29.99/year';

  @override
  String get premiumUpgrade => 'Upgrade Now';

  @override
  String get premiumRestore => 'Restore Purchase';
}
