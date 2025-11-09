// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Modern Greek (`el`).
class AppLocalizationsEl extends AppLocalizations {
  AppLocalizationsEl([String locale = 'el']) : super(locale);

  @override
  String get appName => 'AI Cosmetic Scanner';

  @override
  String get skinAnalysis => 'Ανάλυση Δέρματος';

  @override
  String get checkYourCosmetics => 'Ελέγξτε τα καλλυντικά σας';

  @override
  String get startScanning => 'Έναρξη Σάρωσης';

  @override
  String get quickActions => 'Γρήγορες Ενέργειες';

  @override
  String get scanHistory => 'Ιστορικό Σαρώσεων';

  @override
  String get aiChat => 'AI Cosmetic Scanner';

  @override
  String get profile => 'Προφίλ';

  @override
  String get settings => 'Ρυθμίσεις';

  @override
  String get skinType => 'Τύπος Δέρματος';

  @override
  String get allergiesSensitivities => 'Αλλεργίες & Ευαισθησίες';

  @override
  String get subscription => 'Συνδρομή';

  @override
  String get age => 'Ηλικία';

  @override
  String get language => 'Γλώσσα';

  @override
  String get selectYourPreferredLanguage => 'Επιλέξτε την προτιμώμενη γλώσσα';

  @override
  String get save => 'Αποθήκευση';

  @override
  String get language_en => 'Αγγλικά';

  @override
  String get language_ru => 'Ρωσικά';

  @override
  String get language_uk => 'Ουκρανικά';

  @override
  String get language_es => 'Ισπανικά';

  @override
  String get language_de => 'Γερμανικά';

  @override
  String get language_fr => 'Γαλλικά';

  @override
  String get language_it => 'Ιταλικά';

  @override
  String get selectIngredientsAllergicSensitive => 'Επιλέξτε συστατικά στα οποία έχετε αυξημένη ευαισθησία';

  @override
  String get commonAllergens => 'Κοινά Αλλεργιογόνα';

  @override
  String get fragrance => 'Άρωμα';

  @override
  String get parabens => 'Παραβένια';

  @override
  String get sulfates => 'Θειικά';

  @override
  String get alcohol => 'Αλκοόλη';

  @override
  String get essentialOils => 'Αιθέρια Έλαια';

  @override
  String get silicones => 'Σιλικόνες';

  @override
  String get mineralOil => 'Ορυκτέλαιο';

  @override
  String get formaldehyde => 'Φορμαλδεΰδη';

  @override
  String get addCustomAllergen => 'Προσθήκη Προσαρμοσμένου Αλλεργιογόνου';

  @override
  String get typeIngredientName => 'Πληκτρολογήστε όνομα συστατικού...';

  @override
  String get selectedAllergens => 'Επιλεγμένα Αλλεργιογόνα';

  @override
  String saveSelected(int count) {
    return 'Αποθήκευση ($count επιλεγμένα)';
  }

  @override
  String get analysisResults => 'Αποτελέσματα Ανάλυσης';

  @override
  String get overallSafetyScore => 'Συνολική Βαθμολογία Ασφάλειας';

  @override
  String get personalizedWarnings => 'Εξατομικευμένες Προειδοποιήσεις';

  @override
  String ingredientsAnalysis(int count) {
    return 'Ανάλυση Συστατικών ($count)';
  }

  @override
  String get highRisk => 'Υψηλός Κίνδυνος';

  @override
  String get moderateRisk => 'Μέτριος Κίνδυνος';

  @override
  String get lowRisk => 'Χαμηλός Κίνδυνος';

  @override
  String get benefitsAnalysis => 'Ανάλυση Οφελών';

  @override
  String get recommendedAlternatives => 'Προτεινόμενες Εναλλακτικές';

  @override
  String get reason => 'Αιτία:';

  @override
  String get quickSummary => 'Γρήγορη Περίληψη';

  @override
  String get ingredientsChecked => 'συστατικά ελέγχθηκαν';

  @override
  String get personalWarnings => 'προσωπικές προειδοποιήσεις';

  @override
  String get ourVerdict => 'Η Κρίση μας';

  @override
  String get productInfo => 'Πληροφορίες Προϊόντος';

  @override
  String get productType => 'Τύπος Προϊόντος';

  @override
  String get brand => 'Μάρκα';

  @override
  String get premiumInsights => 'Premium Πληροφορίες';

  @override
  String get researchArticles => 'Ερευνητικά Άρθρα';

  @override
  String get categoryRanking => 'Κατάταξη Κατηγορίας';

  @override
  String get safetyTrend => 'Τάση Ασφάλειας';

  @override
  String get saveToFavorites => 'Αποθήκευση';

  @override
  String get shareResults => 'Κοινοποίηση';

  @override
  String get compareProducts => 'Σύγκριση';

  @override
  String get exportPDF => 'PDF';

  @override
  String get scanSimilar => 'Παρόμοια';

  @override
  String get aiChatTitle => 'AI Cosmetic Scanner';

  @override
  String get typeYourMessage => 'Πληκτρολογήστε το μήνυμά σας...';

  @override
  String get errorSupabaseClientNotInitialized => 'Σφάλμα: Ο πελάτης Supabase δεν έχει αρχικοποιηθεί.';

  @override
  String get serverError => 'Σφάλμα διακομιστή:';

  @override
  String get networkErrorOccurred => 'Προέκυψε σφάλμα δικτύου. Δοκιμάστε ξανά αργότερα.';

  @override
  String get sorryAnErrorOccurred => 'Λυπούμαστε, προέκυψε σφάλμα. Δοκιμάστε ξανά.';

  @override
  String get couldNotGetResponse => 'Δεν ήταν δυνατή η λήψη απάντησης.';

  @override
  String get aiAssistant => 'AI Βοηθός';

  @override
  String get online => 'Συνδεδεμένος';

  @override
  String get typing => 'Πληκτρολογεί...';

  @override
  String get writeAMessage => 'Γράψτε ένα μήνυμα...';

  @override
  String get hiIAmYourAIAssistantHowCanIHelp => 'Γεια! Είμαι ο AI βοηθός σας. Πώς μπορώ να βοηθήσω;';

  @override
  String get iCanSeeYourScanResultsFeelFreeToAskMeAnyQuestionsAboutTheIngredientsSafetyConcernsOrRecommendations => 'Μπορώ να δω τα αποτελέσματα της σάρωσής σας! Μη διστάσετε να με ρωτήσετε οτιδήποτε για τα συστατικά, τις ανησυχίες ασφάλειας ή τις συστάσεις.';

  @override
  String get userQuestion => 'Ερώτηση χρήστη:';

  @override
  String get databaseExplorer => 'Εξερευνητής Βάσης Δεδομένων';

  @override
  String get currentUser => 'Τρέχων Χρήστης:';

  @override
  String get notSignedIn => 'Δεν έχετε συνδεθεί';

  @override
  String get failedToFetchTables => 'Αποτυχία ανάκτησης πινάκων:';

  @override
  String get tablesInYourSupabaseDatabase => 'Πίνακες στη βάση δεδομένων Supabase:';

  @override
  String get viewSampleData => 'Προβολή Δεδομένων Δείγματος';

  @override
  String get failedToFetchSampleDataFor => 'Αποτυχία ανάκτησης δεδομένων δείγματος για';

  @override
  String get sampleData => 'Δεδομένα Δείγματος:';

  @override
  String get aiChats => 'AI Cosmetic Scanner';

  @override
  String get noDialoguesYet => 'Δεν υπάρχουν ακόμη διάλογοι.';

  @override
  String get startANewChat => 'Ξεκινήστε μια νέα συνομιλία!';

  @override
  String get created => 'Δημιουργήθηκε:';

  @override
  String get failedToSaveImage => 'Αποτυχία αποθήκευσης εικόνας:';

  @override
  String get editName => 'Επεξεργασία Ονόματος';

  @override
  String get enterYourName => 'Εισάγετε το όνομά σας';

  @override
  String get cancel => 'Ακύρωση';

  @override
  String get premiumUser => 'Premium Χρήστης';

  @override
  String get freeUser => 'Δωρεάν Χρήστης';

  @override
  String get skinProfile => 'Προφίλ Δέρματος';

  @override
  String get notSet => 'Δεν έχει οριστεί';

  @override
  String get legal => 'Νομικά';

  @override
  String get privacyPolicy => 'Πολιτική Απορρήτου';

  @override
  String get termsOfService => 'Όροι Χρήσης';

  @override
  String get dataManagement => 'Διαχείριση Δεδομένων';

  @override
  String get clearAllData => 'Διαγραφή Όλων των Δεδομένων';

  @override
  String get clearAllDataConfirmation => 'Είστε βέβαιοι ότι θέλετε να διαγράψετε όλα τα τοπικά δεδομένα; Αυτή η ενέργεια δεν μπορεί να αναιρεθεί.';

  @override
  String get selectDataToClear => 'Επιλέξτε δεδομένα προς διαγραφή';

  @override
  String get scanResults => 'Αποτελέσματα Σάρωσης';

  @override
  String get chatHistory => 'Συνομιλίες';

  @override
  String get personalData => 'Προσωπικά Δεδομένα';

  @override
  String get clearData => 'Διαγραφή Δεδομένων';

  @override
  String get allLocalDataHasBeenCleared => 'Τα δεδομένα διαγράφηκαν.';

  @override
  String get signOut => 'Αποσύνδεση';

  @override
  String get deleteScan => 'Διαγραφή Σάρωσης';

  @override
  String get deleteScanConfirmation => 'Είστε βέβαιοι ότι θέλετε να διαγράψετε αυτή τη σάρωση από το ιστορικό σας;';

  @override
  String get deleteChat => 'Διαγραφή Συνομιλίας';

  @override
  String get deleteChatConfirmation => 'Είστε βέβαιοι ότι θέλετε να διαγράψετε αυτή τη συνομιλία; Όλα τα μηνύματα θα χαθούν.';

  @override
  String get delete => 'Διαγραφή';

  @override
  String get noScanHistoryFound => 'Δεν βρέθηκε ιστορικό σαρώσεων.';

  @override
  String get scanOn => 'Σάρωση στις';

  @override
  String get ingredientsFound => 'συστατικά βρέθηκαν';

  @override
  String get noCamerasFoundOnThisDevice => 'Δεν βρέθηκαν κάμερες σε αυτή τη συσκευή.';

  @override
  String get failedToInitializeCamera => 'Αποτυχία αρχικοποίησης κάμερας:';

  @override
  String get analysisFailed => 'Η ανάλυση απέτυχε:';

  @override
  String get analyzingPleaseWait => 'Αναλύεται, παρακαλώ περιμένετε...';

  @override
  String get positionTheLabelWithinTheFrame => 'Εστιάστε την κάμερα στη λίστα συστατικών';

  @override
  String get createAccount => 'Δημιουργία Λογαριασμού';

  @override
  String get signUpToGetStarted => 'Εγγραφείτε για να ξεκινήσετε';

  @override
  String get fullName => 'Πλήρες Όνομα';

  @override
  String get pleaseEnterYourName => 'Παρακαλώ εισάγετε το όνομά σας';

  @override
  String get email => 'Email';

  @override
  String get pleaseEnterYourEmail => 'Παρακαλώ εισάγετε το email σας';

  @override
  String get pleaseEnterAValidEmail => 'Παρακαλώ εισάγετε έγκυρο email';

  @override
  String get password => 'Κωδικός Πρόσβασης';

  @override
  String get pleaseEnterYourPassword => 'Παρακαλώ εισάγετε τον κωδικό σας';

  @override
  String get passwordMustBeAtLeast6Characters => 'Ο κωδικός πρέπει να έχει τουλάχιστον 6 χαρακτήρες';

  @override
  String get signUp => 'Εγγραφή';

  @override
  String get orContinueWith => 'ή συνεχίστε με';

  @override
  String get google => 'Google';

  @override
  String get apple => 'Apple';

  @override
  String get alreadyHaveAnAccount => 'Έχετε ήδη λογαριασμό; ';

  @override
  String get signIn => 'Σύνδεση';

  @override
  String get selectYourSkinTypeDescription => 'Επιλέξτε τον τύπο δέρματός σας';

  @override
  String get normal => 'Κανονικό';

  @override
  String get normalSkinDescription => 'Ισορροπημένο, όχι πολύ λιπαρό ή ξηρό';

  @override
  String get dry => 'Ξηρό';

  @override
  String get drySkinDescription => 'Σφιχτό, ξεφλουδισμένο, τραχιά υφή';

  @override
  String get oily => 'Λιπαρό';

  @override
  String get oilySkinDescription => 'Γυαλιστερό, μεγάλοι πόροι, επιρρεπές σε ακμή';

  @override
  String get combination => 'Μικτό';

  @override
  String get combinationSkinDescription => 'Λιπαρή ζώνη Τ, ξηρά μάγουλα';

  @override
  String get sensitive => 'Ευαίσθητο';

  @override
  String get sensitiveSkinDescription => 'Ευκολα ερεθίζεται, επιρρεπές σε ερυθρότητα';

  @override
  String get selectSkinType => 'Επιλέξτε τύπο δέρματος';

  @override
  String get restore => 'Επαναφορά';

  @override
  String get restorePurchases => 'Επαναφορά Αγορών';

  @override
  String get subscriptionRestored => 'Η συνδρομή επαναφέρθηκε επιτυχώς!';

  @override
  String get noPurchasesToRestore => 'Δεν υπάρχουν αγορές προς επαναφορά';

  @override
  String get goPremium => 'Αποκτήστε Premium';

  @override
  String get unlockExclusiveFeatures => 'Ξεκλειδώστε αποκλειστικές λειτουργίες για να αξιοποιήσετε στο έπακρο την ανάλυση δέρματός σας.';

  @override
  String get unlimitedProductScans => 'Απεριόριστες σαρώσεις προϊόντων';

  @override
  String get advancedAIIngredientAnalysis => 'Προηγμένη Ανάλυση Συστατικών AI';

  @override
  String get fullScanAndSearchHistory => 'Πλήρες Ιστορικό Σάρωσης και Αναζήτησης';

  @override
  String get adFreeExperience => '100% Εμπειρία Χωρίς Διαφημίσεις';

  @override
  String get yearly => 'Ετήσια';

  @override
  String savePercentage(int percentage) {
    return 'Εξοικονόμηση $percentage%';
  }

  @override
  String get monthly => 'Μηνιαία';

  @override
  String get perMonth => '/ μήνα';

  @override
  String get startFreeTrial => 'Έναρξη Δωρεάν Δοκιμής';

  @override
  String trialDescription(String planName) {
    return 'Δωρεάν δοκιμή 7 ημερών, στη συνέχεια χρέωση $planName. Ακύρωση ανά πάσα στιγμή.';
  }

  @override
  String get home => 'Αρχική';

  @override
  String get scan => 'Σάρωση';

  @override
  String get aiChatNav => 'AI Cosmetic Scanner';

  @override
  String get profileNav => 'Προφίλ';

  @override
  String get doYouEnjoyOurApp => 'Σας αρέσει η εφαρμογή μας;';

  @override
  String get notReally => 'Όχι';

  @override
  String get yesItsGreat => 'Μου αρέσει';

  @override
  String get rateOurApp => 'Αξιολογήστε την εφαρμογή μας';

  @override
  String get bestRatingWeCanGet => 'Η καλύτερη αξιολόγηση που μπορούμε να πάρουμε';

  @override
  String get rateOnGooglePlay => 'Αξιολογήστε στο Google Play';

  @override
  String get rate => 'Αξιολόγηση';

  @override
  String get whatCanBeImproved => 'Τι μπορεί να βελτιωθεί;';

  @override
  String get wereSorryYouDidntHaveAGreatExperience => 'Λυπούμαστε που δεν είχατε μια υπέροχη εμπειρία. Παρακαλούμε πείτε μας τι πήγε στραβά.';

  @override
  String get yourFeedback => 'Τα σχόλιά σας...';

  @override
  String get sendFeedback => 'Αποστολή Σχολίων';

  @override
  String get thankYouForYourFeedback => 'Ευχαριστούμε για τα σχόλιά σας!';

  @override
  String get discussWithAI => 'Συζητήστε με AI';

  @override
  String get enterYourEmail => 'Εισάγετε το email σας';

  @override
  String get enterYourPassword => 'Εισάγετε τον κωδικό σας';

  @override
  String get aiDisclaimer => 'Οι απαντήσεις AI μπορεί να περιέχουν ανακρίβειες. Παρακαλούμε επαληθεύστε τις κρίσιμες πληροφορίες.';

  @override
  String get applicationThemes => 'Θέματα Εφαρμογής';

  @override
  String get highestRating => 'Υψηλότερη Αξιολόγηση';

  @override
  String get selectYourAgeDescription => 'Επιλέξτε την ηλικία σας';

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
  String get ageRange18_25Description => 'Νεανικό δέρμα, πρόληψη';

  @override
  String get ageRange26_35Description => 'Πρώτα σημάδια γήρανσης';

  @override
  String get ageRange36_45Description => 'Φροντίδα κατά της γήρανσης';

  @override
  String get ageRange46_55Description => 'Εντατική φροντίδα';

  @override
  String get ageRange56PlusDescription => 'Εξειδικευμένη φροντίδα';

  @override
  String get userName => 'Το Όνομά σας';

  @override
  String get tryFreeAndSubscribe => 'Δοκιμάστε Δωρεάν & Εγγραφείτε';

  @override
  String get personalAIConsultant => 'Προσωπικός Σύμβουλος AI 24/7';

  @override
  String get subscribe => 'Εγγραφή';

  @override
  String get themes => 'Θέματα';

  @override
  String get selectPreferredTheme => 'Επιλέξτε το προτιμώμενο θέμα';

  @override
  String get naturalTheme => 'Φυσικό';

  @override
  String get darkTheme => 'Σκούρο';

  @override
  String get darkNatural => 'Σκούρο Φυσικό';

  @override
  String get oceanTheme => 'Ωκεανός';

  @override
  String get forestTheme => 'Δάσος';

  @override
  String get sunsetTheme => 'Ηλιοβασίλεμα';

  @override
  String get naturalThemeDescription => 'Φυσικό θέμα με οικολογικά χρώματα';

  @override
  String get darkThemeDescription => 'Σκούρο θέμα για άνεση ματιών';

  @override
  String get oceanThemeDescription => 'Δροσερό θέμα ωκεανού';

  @override
  String get forestThemeDescription => 'Φυσικό θέμα δάσους';

  @override
  String get sunsetThemeDescription => 'Ζεστό θέμα ηλιοβασιλέματος';

  @override
  String get sunnyTheme => 'Ηλιόλουστο';

  @override
  String get sunnyThemeDescription => 'Φωτεινό και χαρούμενο κίτρινο θέμα';

  @override
  String get vibrantTheme => 'Ζωντανό';

  @override
  String get vibrantThemeDescription => 'Φωτεινό ροζ και μωβ θέμα';

  @override
  String get scanAnalysis => 'Ανάλυση Σάρωσης';

  @override
  String get ingredients => 'συστατικά';

  @override
  String get aiBotSettings => 'Ρυθμίσεις AI';

  @override
  String get botName => 'Όνομα Bot';

  @override
  String get enterBotName => 'Εισάγετε όνομα bot';

  @override
  String get pleaseEnterBotName => 'Παρακαλώ εισάγετε όνομα bot';

  @override
  String get botDescription => 'Περιγραφή Bot';

  @override
  String get selectAvatar => 'Επιλέξτε Avatar';

  @override
  String get defaultBotName => 'ACS';

  @override
  String defaultBotDescription(String name) {
    return 'Γεια! Είμαι ο $name (AI Cosmetic Scanner). Θα σας βοηθήσω να κατανοήσετε τη σύνθεση των καλλυντικών σας. Έχω εκτεταμένες γνώσεις στην κοσμητολογία και τη φροντίδα δέρματος. Θα χαρώ να απαντήσω σε όλες τις ερωτήσεις σας.';
  }

  @override
  String get settingsSaved => 'Οι ρυθμίσεις αποθηκεύτηκαν επιτυχώς';

  @override
  String get failedToSaveSettings => 'Αποτυχία αποθήκευσης ρυθμίσεων';

  @override
  String get resetToDefault => 'Επαναφορά στις Προεπιλογές';

  @override
  String get resetSettings => 'Επαναφορά Ρυθμίσεων';

  @override
  String get resetSettingsConfirmation => 'Είστε βέβαιοι ότι θέλετε να επαναφέρετε όλες τις ρυθμίσεις στις προεπιλεγμένες τιμές;';

  @override
  String get settingsResetSuccessfully => 'Οι ρυθμίσεις επαναφέρθηκαν επιτυχώς';

  @override
  String get failedToResetSettings => 'Αποτυχία επαναφοράς ρυθμίσεων';

  @override
  String get unsavedChanges => 'Μη Αποθηκευμένες Αλλαγές';

  @override
  String get unsavedChangesMessage => 'Έχετε μη αποθηκευμένες αλλαγές. Είστε βέβαιοι ότι θέλετε να φύγετε;';

  @override
  String get stay => 'Παραμονή';

  @override
  String get leave => 'Αποχώρηση';

  @override
  String get errorLoadingSettings => 'Σφάλμα φόρτωσης ρυθμίσεων';

  @override
  String get retry => 'Επανάληψη';

  @override
  String get customPrompt => 'Ειδικά Αιτήματα';

  @override
  String get customPromptDescription => 'Προσθέστε εξατομικευμένες οδηγίες για τον AI βοηθό';

  @override
  String get customPromptPlaceholder => 'Εισάγετε τα ειδικά αιτήματά σας...';

  @override
  String get enableCustomPrompt => 'Ενεργοποίηση ειδικών αιτημάτων';

  @override
  String get defaultCustomPrompt => 'Κάντε μου κομπλιμέντα.';

  @override
  String get close => 'Κλείσιμο';

  @override
  String get scanningHintTitle => 'Πώς να Σαρώσετε';

  @override
  String get scanLimitReached => 'Το Όριο Σάρωσης Επιτεύχθηκε';

  @override
  String get scanLimitReachedMessage => 'Χρησιμοποιήσατε όλες τις 5 δωρεάν σαρώσεις αυτή την εβδομάδα. Αναβαθμίστε σε Premium για απεριόριστες σαρώσεις!';

  @override
  String get messageLimitReached => 'Το Ημερήσιο Όριο Μηνυμάτων Επιτεύχθηκε';

  @override
  String get messageLimitReachedMessage => 'Στείλατε 5 μηνύματα σήμερα. Αναβαθμίστε σε Premium για απεριόριστη συνομιλία!';

  @override
  String get historyLimitReached => 'Περιορισμένη Πρόσβαση στο Ιστορικό';

  @override
  String get historyLimitReachedMessage => 'Αναβαθμίστε σε Premium για πρόσβαση στο πλήρες ιστορικό σαρώσεών σας!';

  @override
  String get upgradeToPremium => 'Αναβάθμιση σε Premium';

  @override
  String get upgradeToView => 'Αναβάθμιση για Προβολή';

  @override
  String get upgradeToChat => 'Αναβάθμιση για Συνομιλία';

  @override
  String get premiumFeature => 'Premium Λειτουργία';

  @override
  String get freePlanUsage => 'Χρήση Δωρεάν Πλάνου';

  @override
  String get scansThisWeek => 'Σαρώσεις αυτή την εβδομάδα';

  @override
  String get messagesToday => 'Μηνύματα σήμερα';

  @override
  String get limitsReached => 'Όρια επιτεύχθηκαν';

  @override
  String get remainingScans => 'Εναπομείνασες σαρώσεις';

  @override
  String get remainingMessages => 'Εναπομείναντα μηνύματα';

  @override
  String get unlockUnlimitedAccess => 'Ξεκλειδώστε Απεριόριστη Πρόσβαση';

  @override
  String get upgradeToPremiumDescription => 'Αποκτήστε απεριόριστες σαρώσεις, μηνύματα και πλήρη πρόσβαση στο ιστορικό σαρώσεών σας με Premium!';

  @override
  String get premiumBenefits => 'Premium Οφέλη';

  @override
  String get unlimitedAiChatMessages => 'Απεριόριστα μηνύματα συνομιλίας AI';

  @override
  String get fullAccessToScanHistory => 'Πλήρης πρόσβαση στο ιστορικό σαρώσεων';

  @override
  String get prioritySupport => 'Υποστήριξη Προτεραιότητας';

  @override
  String get learnMore => 'Μάθετε Περισσότερα';

  @override
  String get upgradeNow => 'Αναβάθμιση Τώρα';

  @override
  String get maybeLater => 'Ίσως Αργότερα';

  @override
  String get scanHistoryLimit => 'Μόνο η πιο πρόσφατη σάρωση είναι ορατή στο ιστορικό';

  @override
  String get upgradeForUnlimitedScans => 'Αναβαθμίστε για απεριόριστες σαρώσεις!';

  @override
  String get upgradeForUnlimitedChat => 'Αναβαθμίστε για απεριόριστη συνομιλία!';

  @override
  String get slowInternetConnection => 'Αργή Σύνδεση Internet';

  @override
  String get slowInternetMessage => 'Σε πολύ αργή σύνδεση internet, θα πρέπει να περιμένετε λίγο... Εξακολουθούμε να αναλύουμε την εικόνα σας.';

  @override
  String get revolutionaryAI => 'Επαναστατική AI';

  @override
  String get revolutionaryAIDesc => 'Ένα από τα πιο έξυπνα στον κόσμο';

  @override
  String get unlimitedScans => 'Απεριόριστες Σαρώσεις';

  @override
  String get unlimitedScansDesc => 'Εξερευνήστε καλλυντικά χωρίς όρια';

  @override
  String get unlimitedChats => 'Απεριόριστες Συνομιλίες';

  @override
  String get unlimitedChatsDesc => 'Προσωπικός σύμβουλος AI 24/7';

  @override
  String get fullHistory => 'Πλήρες Ιστορικό';

  @override
  String get fullHistoryDesc => 'Απεριόριστο ιστορικό σαρώσεων';

  @override
  String get rememberContext => 'Θυμάται το Πλαίσιο';

  @override
  String get rememberContextDesc => 'Η AI θυμάται τα προηγούμενα μηνύματά σας';

  @override
  String get allIngredientsInfo => 'Όλες οι Πληροφορίες Συστατικών';

  @override
  String get allIngredientsInfoDesc => 'Μάθετε όλες τις λεπτομέρειες';

  @override
  String get noAds => '100% Χωρίς Διαφημίσεις';

  @override
  String get noAdsDesc => 'Για όσους εκτιμούν το χρόνο τους';

  @override
  String get multiLanguage => 'Γνωρίζει Σχεδόν Όλες τις Γλώσσες';

  @override
  String get multiLanguageDesc => 'Βελτιωμένος μεταφραστής';

  @override
  String get paywallTitle => 'Ξεκλειδώστε τα μυστικά των καλλυντικών σας με AI';

  @override
  String paywallDescription(String price) {
    return 'Έχετε την ευκαιρία να αποκτήσετε συνδρομή Premium για 3 ημέρες δωρεάν, στη συνέχεια $price ανά εβδομάδα. Ακύρωση ανά πάσα στιγμή.';
  }

  @override
  String get whatsIncluded => 'Τι Περιλαμβάνεται';

  @override
  String get basicPlan => 'Βασικό';

  @override
  String get premiumPlan => 'Premium';

  @override
  String get botGreeting1 => 'Καλημέρα! Πώς μπορώ να σας βοηθήσω σήμερα;';

  @override
  String get botGreeting2 => 'Γεια! Τι σας φέρνει σε μένα;';

  @override
  String get botGreeting3 => 'Σας καλωσορίζω! Έτοιμος να βοηθήσω με κοσμητική ανάλυση.';

  @override
  String get botGreeting4 => 'Χαίρομαι που σας βλέπω! Πώς μπορώ να είμαι χρήσιμος;';

  @override
  String get botGreeting5 => 'Καλώς ήρθατε! Ας εξερευνήσουμε τη σύνθεση των καλλυντικών σας μαζί.';

  @override
  String get botGreeting6 => 'Γεια! Έτοιμος να απαντήσω στις ερωτήσεις σας για καλλυντικά.';

  @override
  String get botGreeting7 => 'Γεια! Είμαι ο προσωπικός σας βοηθός κοσμητολογίας.';

  @override
  String get botGreeting8 => 'Καλημέρα! Θα σας βοηθήσω να κατανοήσετε τη σύνθεση των κοσμητικών προϊόντων.';

  @override
  String get botGreeting9 => 'Γεια! Ας κάνουμε τα καλλυντικά σας πιο ασφαλή μαζί.';

  @override
  String get botGreeting10 => 'Σας καλωσορίζω! Έτοιμος να μοιραστώ γνώσεις για καλλυντικά.';

  @override
  String get botGreeting11 => 'Καλημέρα! Θα σας βοηθήσω να βρείτε τις καλύτερες κοσμητικές λύσεις για εσάς.';

  @override
  String get botGreeting12 => 'Γεια! Ο ειδικός σας στην ασφάλεια καλλυντικών είναι στην υπηρεσία σας.';

  @override
  String get botGreeting13 => 'Γεια! Ας επιλέξουμε τα τέλεια καλλυντικά για εσάς μαζί.';

  @override
  String get botGreeting14 => 'Καλώς ήρθατε! Έτοιμος να βοηθήσω με ανάλυση συστατικών.';

  @override
  String get botGreeting15 => 'Γεια! Θα σας βοηθήσω να κατανοήσετε τη σύνθεση των καλλυντικών σας.';

  @override
  String get botGreeting16 => 'Σας καλωσορίζω! Ο οδηγός σας στον κόσμο της κοσμητολογίας είναι έτοιμος να βοηθήσει.';

  @override
  String get copiedToClipboard => 'Αντιγράφηκε στο πρόχειρο';

  @override
  String get tryFree => 'Δοκιμάστε Δωρεάν';

  @override
  String get cameraNotReady => 'Η κάμερα δεν είναι έτοιμη / δεν υπάρχει άδεια';

  @override
  String get cameraPermissionInstructions => 'Ρυθμίσεις Εφαρμογής:\nAI Cosmetic Scanner > Δικαιώματα > Κάμερα > Να επιτρέπεται';

  @override
  String get openSettingsAndGrantAccess => 'Ανοίξτε τις ρυθμίσεις και παραχωρήστε πρόσβαση στην κάμερα';

  @override
  String get retryCamera => 'Επανάληψη';

  @override
  String get errorServiceOverloaded => 'Η υπηρεσία είναι προσωρινά απασχολημένη. Δοκιμάστε ξανά σε λίγο.';

  @override
  String get errorRateLimitExceeded => 'Πάρα πολλά αιτήματα. Περιμένετε λίγο και δοκιμάστε ξανά.';

  @override
  String get errorTimeout => 'Το αίτημα έληξε. Ελέγξτε τη σύνδεσή σας στο internet και δοκιμάστε ξανά.';

  @override
  String get errorNetwork => 'Σφάλμα δικτύου. Ελέγξτε τη σύνδεσή σας στο internet.';

  @override
  String get errorAuthentication => 'Σφάλμα ελέγχου ταυτότητας. Επανεκκινήστε την εφαρμογή.';

  @override
  String get errorInvalidResponse => 'Ελήφθη μη έγκυρη απάντηση. Δοκιμάστε ξανά.';

  @override
  String get errorServer => 'Σφάλμα διακομιστή. Δοκιμάστε ξανά αργότερα.';

  @override
  String get customThemes => 'Προσαρμοσμένα Θέματα';

  @override
  String get createCustomTheme => 'Δημιουργία Προσαρμοσμένου Θέματος';

  @override
  String get basedOn => 'Βασισμένο σε';

  @override
  String get lightMode => 'Φωτεινό';

  @override
  String get generateWithAI => 'Δημιουργία με AI';

  @override
  String get resetToBaseTheme => 'Επαναφορά στο Βασικό Θέμα';

  @override
  String colorsResetTo(Object themeName) {
    return 'Χρώματα επαναφέρθηκαν σε $themeName';
  }

  @override
  String get aiGenerationComingSoon => 'Δημιουργία θεμάτων AI έρχεται στην Επανάληψη 5!';

  @override
  String get onboardingGreeting => 'Καλώς ήρθατε! Για να βελτιώσουμε την ποιότητα των απαντήσεων, ας ρυθμίσουμε το προφίλ σας';

  @override
  String get letsGo => 'Πάμε';

  @override
  String get next => 'Επόμενο';

  @override
  String get finish => 'Τέλος';

  @override
  String get customThemeInDevelopment => 'Η λειτουργία προσαρμοσμένων θεμάτων είναι υπό ανάπτυξη';

  @override
  String get customThemeComingSoon => 'Έρχεται σύντομα σε μελλοντικές ενημερώσεις';

  @override
  String get dailyMessageLimitReached => 'Το Όριο Επιτεύχθηκε';

  @override
  String get dailyMessageLimitReachedMessage => 'Στείλατε 5 μηνύματα σήμερα. Αναβαθμίστε σε Premium για απεριόριστη συνομιλία!';

  @override
  String get upgradeToPremiumForUnlimitedChat => 'Αναβαθμίστε σε Premium για απεριόριστη συνομιλία';

  @override
  String get messagesLeftToday => 'μηνύματα απομένουν σήμερα';

  @override
  String get designYourOwnTheme => 'Σχεδιάστε το δικό σας θέμα';

  @override
  String get darkOcean => 'Σκούρος Ωκεανός';

  @override
  String get darkForest => 'Σκούρο Δάσος';

  @override
  String get darkSunset => 'Σκούρο Ηλιοβασίλεμα';

  @override
  String get darkVibrant => 'Σκούρο Ζωντανό';

  @override
  String get darkOceanThemeDescription => 'Σκούρο θέμα ωκεανού με κυανές πινελιές';

  @override
  String get darkForestThemeDescription => 'Σκούρο θέμα δάσους με λαχανί πινελιές';

  @override
  String get darkSunsetThemeDescription => 'Σκούρο θέμα ηλιοβασιλέματος με πορτοκαλί πινελιές';

  @override
  String get darkVibrantThemeDescription => 'Σκούρο ζωντανό θέμα με ροζ και μωβ πινελιές';

  @override
  String get customTheme => 'Προσαρμοσμένο θέμα';

  @override
  String get edit => 'Επεξεργασία';

  @override
  String get deleteTheme => 'Διαγραφή Θέματος';

  @override
  String deleteThemeConfirmation(String themeName) {
    return 'Είστε βέβαιοι ότι θέλετε να διαγράψετε το \"$themeName\";';
  }

  @override
  String get pollTitle => 'Τι λείπει;';

  @override
  String get pollCardTitle => 'Τι λείπει από την εφαρμογή;';

  @override
  String get pollCardSubtitle => 'Ποιες 3 λειτουργίες θα πρέπει να προστεθούν;';

  @override
  String get pollDescription => 'Ψηφίστε για τις επιλογές που θέλετε να δείτε';

  @override
  String get submitVote => 'Ψήφος';

  @override
  String get submitting => 'Υποβολή...';

  @override
  String get voteSubmittedSuccess => 'Οι ψήφοι υποβλήθηκαν επιτυχώς!';

  @override
  String votesRemaining(int count) {
    return '$count ψήφοι απομένουν';
  }

  @override
  String get votes => 'ψήφοι';

  @override
  String get addYourOption => 'Προτείνετε βελτίωση';

  @override
  String get enterYourOption => 'Εισάγετε την επιλογή σας...';

  @override
  String get add => 'Προσθήκη';

  @override
  String get filterTopVoted => 'Δημοφιλές';

  @override
  String get filterNewest => 'Νέο';

  @override
  String get filterMyOption => 'Η Επιλογή μου';

  @override
  String get thankYouForVoting => 'Ευχαριστούμε για την ψήφο σας!';

  @override
  String get votingComplete => 'Η ψήφος σας καταγράφηκε';

  @override
  String get requestFeatureDevelopment => 'Αίτηση Ανάπτυξης Προσαρμοσμένης Λειτουργίας';

  @override
  String get requestFeatureDescription => 'Χρειάζεστε συγκεκριμένη λειτουργία; Επικοινωνήστε μαζί μας για να συζητήσουμε προσαρμοσμένη ανάπτυξη για τις επιχειρηματικές σας ανάγκες.';

  @override
  String get pollHelpTitle => 'Πώς να ψηφίσετε';

  @override
  String get pollHelpDescription => '• Πατήστε μια επιλογή για να την επιλέξετε\n• Πατήστε ξανά για να την αποεπιλέξετε\n• Επιλέξτε όσες επιλογές θέλετε\n• Κάντε κλικ στο κουμπί \'Ψήφος\' για να υποβάλετε τις ψήφους σας\n• Προσθέστε τη δική σας επιλογή αν δεν βλέπετε αυτό που χρειάζεστε';
}
