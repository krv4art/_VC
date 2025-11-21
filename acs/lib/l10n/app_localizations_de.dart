// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appName => 'AI Cosmetic Scanner';

  @override
  String get skinAnalysis => 'Hautanalyse';

  @override
  String get checkYourCosmetics => 'Überprüfen Sie Ihre Kosmetik';

  @override
  String get startScanning => 'Scannen starten';

  @override
  String get quickActions => 'Schnellaktionen';

  @override
  String get scanHistory => 'Scan-Verlauf';

  @override
  String get aiChat => 'KI-Chat';

  @override
  String get profile => 'Profil';

  @override
  String get settings => 'Einstellungen';

  @override
  String get skinType => 'Hauttyp';

  @override
  String get allergiesSensitivities => 'Allergien & Empfindlichkeiten';

  @override
  String get subscription => 'Abonnement';

  @override
  String get age => 'Alter';

  @override
  String get language => 'Sprache';

  @override
  String get selectYourPreferredLanguage => 'Wählen Sie Ihre bevorzugte Sprache';

  @override
  String get save => 'Speichern';

  @override
  String get selectIngredientsAllergicSensitive => 'Wählen Sie Inhaltsstoffe, auf die Sie eine erhöhte Empfindlichkeit haben';

  @override
  String get commonAllergens => 'Häufige Allergene';

  @override
  String get fragrance => 'Parfüm';

  @override
  String get parabens => 'Parabene';

  @override
  String get sulfates => 'Sulfate';

  @override
  String get alcohol => 'Alkohol';

  @override
  String get essentialOils => 'Ätherische Öle';

  @override
  String get silicones => 'Silikone';

  @override
  String get mineralOil => 'Mineralöl';

  @override
  String get formaldehyde => 'Formaldehyd';

  @override
  String get addCustomAllergen => 'Benutzerdefiniertes Allergen hinzufügen';

  @override
  String get typeIngredientName => 'Inhaltsstoffnamen eingeben...';

  @override
  String get selectedAllergens => 'Ausgewählte Allergene';

  @override
  String saveSelected(int count) {
    return 'Speichern ($count ausgewählt)';
  }

  @override
  String get analysisResults => 'Analyseergebnisse';

  @override
  String get overallSafetyScore => 'Gesamtsicherheitsbewertung';

  @override
  String get personalizedWarnings => 'Personalisierte Warnungen';

  @override
  String ingredientsAnalysis(int count) {
    return 'Inhaltsstoffanalyse ($count)';
  }

  @override
  String get highRisk => 'Hohes Risiko';

  @override
  String get moderateRisk => 'Mäßiges Risiko';

  @override
  String get lowRisk => 'Geringes Risiko';

  @override
  String get benefitsAnalysis => 'Vorteilsanalyse';

  @override
  String get recommendedAlternatives => 'Empfohlene Alternativen';

  @override
  String get reason => 'Grund:';

  @override
  String get quickSummary => 'Schnellübersicht';

  @override
  String get ingredientsChecked => 'Inhaltsstoffe geprüft';

  @override
  String get personalWarnings => 'persönliche Warnungen';

  @override
  String get ourVerdict => 'Unser Urteil';

  @override
  String get productInfo => 'Produktinformationen';

  @override
  String get productType => 'Produkttyp';

  @override
  String get brand => 'Marke';

  @override
  String get premiumInsights => 'Premium Insights';

  @override
  String get researchArticles => 'Forschungsartikel';

  @override
  String get categoryRanking => 'Kategorie-Ranking';

  @override
  String get safetyTrend => 'Sicherheitstrend';

  @override
  String get saveToFavorites => 'Speichern';

  @override
  String get shareResults => 'Teilen';

  @override
  String get compareProducts => 'Vergleichen';

  @override
  String get exportPDF => 'PDF';

  @override
  String get scanSimilar => 'Ähnlich';

  @override
  String get aiChatTitle => 'KI-Chat';

  @override
  String get typeYourMessage => 'Nachricht eingeben...';

  @override
  String get errorSupabaseClientNotInitialized => 'Fehler: Supabase-Client nicht initialisiert.';

  @override
  String get serverError => 'Serverfehler:';

  @override
  String get networkErrorOccurred => 'Netzwerkfehler aufgetreten. Bitte versuchen Sie es später erneut.';

  @override
  String get sorryAnErrorOccurred => 'Entschuldigung, ein Fehler ist aufgetreten. Bitte versuchen Sie es erneut.';

  @override
  String get couldNotGetResponse => 'Keine Antwort erhalten.';

  @override
  String get aiAssistant => 'KI-Assistent';

  @override
  String get online => 'Online';

  @override
  String get typing => 'Schreibt...';

  @override
  String get writeAMessage => 'Nachricht schreiben...';

  @override
  String get hiIAmYourAIAssistantHowCanIHelp => 'Hallo! Ich bin Ihr KI-Assistent. Wie kann ich Ihnen helfen?';

  @override
  String get iCanSeeYourScanResultsFeelFreeToAskMeAnyQuestionsAboutTheIngredientsSafetyConcernsOrRecommendations => 'Ich kann Ihre Scan-Ergebnisse sehen! Fühlen Sie sich frei, mir Fragen zu den Inhaltsstoffen, Sicherheitsbedenken oder Empfehlungen zu stellen.';

  @override
  String get userQuestion => 'Benutzerfrage:';

  @override
  String get databaseExplorer => 'Datenbank-Explorer';

  @override
  String get currentUser => 'Aktueller Benutzer:';

  @override
  String get notSignedIn => 'Nicht angemeldet';

  @override
  String get failedToFetchTables => 'Tabellen konnten nicht abgerufen werden:';

  @override
  String get tablesInYourSupabaseDatabase => 'Tabellen in Ihrer Supabase-Datenbank:';

  @override
  String get viewSampleData => 'Beispieldaten anzeigen';

  @override
  String get failedToFetchSampleDataFor => 'Beispieldaten konnten nicht abgerufen werden für';

  @override
  String get sampleData => 'Beispieldaten:';

  @override
  String get aiChats => 'KI-Chats';

  @override
  String get noDialoguesYet => 'Noch keine Dialoge.';

  @override
  String get startANewChat => 'Starten Sie einen neuen Chat!';

  @override
  String get created => 'Erstellt:';

  @override
  String get failedToSaveImage => 'Bild konnte nicht gespeichert werden:';

  @override
  String get editName => 'Name bearbeiten';

  @override
  String get enterYourName => 'Geben Sie Ihren Namen ein';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get premiumUser => 'Premium-Benutzer';

  @override
  String get freeUser => 'Kostenloser Benutzer';

  @override
  String get skinProfile => 'Hautprofil';

  @override
  String get notSet => 'Nicht festgelegt';

  @override
  String get legal => 'Rechtliches';

  @override
  String get privacyPolicy => 'Datenschutzrichtlinie';

  @override
  String get termsOfService => 'Nutzungsbedingungen';

  @override
  String get dataManagement => 'Datenverwaltung';

  @override
  String get clearAllData => 'Alle Daten löschen';

  @override
  String get clearAllDataConfirmation => 'Sind Sie sicher, dass Sie alle Ihre lokalen Daten löschen möchten? Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get selectDataToClear => 'Daten zum Löschen auswählen';

  @override
  String get scanResults => 'Scanergebnisse';

  @override
  String get chatHistory => 'Chats';

  @override
  String get personalData => 'Persönliche Daten';

  @override
  String get clearData => 'Daten löschen';

  @override
  String get allLocalDataHasBeenCleared => 'Daten wurden gelöscht.';

  @override
  String get signOut => 'Abmelden';

  @override
  String get deleteScan => 'Scan löschen';

  @override
  String get deleteScanConfirmation => 'Sind Sie sicher, dass Sie diesen Scan aus Ihrem Verlauf löschen möchten?';

  @override
  String get deleteChat => 'Chat löschen';

  @override
  String get deleteChatConfirmation => 'Sind Sie sicher, dass Sie diesen Chat löschen möchten? Alle Nachrichten gehen verloren.';

  @override
  String get delete => 'Löschen';

  @override
  String get noScanHistoryFound => 'Kein Scan-Verlauf gefunden.';

  @override
  String get scanOn => 'Gescannt am';

  @override
  String get ingredientsFound => 'Inhaltsstoffe gefunden';

  @override
  String get noCamerasFoundOnThisDevice => 'Auf diesem Gerät wurden keine Kameras gefunden.';

  @override
  String get failedToInitializeCamera => 'Kamera konnte nicht initialisiert werden:';

  @override
  String get analysisFailed => 'Analyse fehlgeschlagen:';

  @override
  String get analyzingPleaseWait => 'Analyse läuft, bitte warten...';

  @override
  String get positionTheLabelWithinTheFrame => 'Fokussieren Sie die Kamera auf die Zutatenliste';

  @override
  String get createAccount => 'Konto erstellen';

  @override
  String get signUpToGetStarted => 'Registrieren Sie sich, um zu beginnen';

  @override
  String get fullName => 'Vollständiger Name';

  @override
  String get pleaseEnterYourName => 'Bitte geben Sie Ihren Namen ein';

  @override
  String get email => 'E-Mail';

  @override
  String get pleaseEnterYourEmail => 'Bitte geben Sie Ihre E-Mail ein';

  @override
  String get pleaseEnterAValidEmail => 'Bitte geben Sie eine gültige E-Mail ein';

  @override
  String get password => 'Passwort';

  @override
  String get pleaseEnterYourPassword => 'Bitte geben Sie Ihr Passwort ein';

  @override
  String get passwordMustBeAtLeast6Characters => 'Das Passwort muss mindestens 6 Zeichen lang sein';

  @override
  String get signUp => 'Registrieren';

  @override
  String get orContinueWith => 'oder fortfahren mit';

  @override
  String get google => 'Google';

  @override
  String get apple => 'Apple';

  @override
  String get alreadyHaveAnAccount => 'Haben Sie bereits ein Konto? ';

  @override
  String get signIn => 'Anmelden';

  @override
  String get selectYourSkinTypeDescription => 'Wählen Sie Ihren Hauttyp';

  @override
  String get normal => 'Normal';

  @override
  String get normalSkinDescription => 'Ausgewogen, nicht zu fettig oder trocken';

  @override
  String get dry => 'Trocken';

  @override
  String get drySkinDescription => 'Straff, schuppig, raue Textur';

  @override
  String get oily => 'Fettig';

  @override
  String get oilySkinDescription => 'Glänzend, große Poren, neigt zu Akne';

  @override
  String get combination => 'Kombiniert';

  @override
  String get combinationSkinDescription => 'Fettige T-Zone, trockene Wangen';

  @override
  String get sensitive => 'Empfindlich';

  @override
  String get sensitiveSkinDescription => 'Leicht reizbar, neigt zu Rötungen';

  @override
  String get selectSkinType => 'Hauttyp auswählen';

  @override
  String get restore => 'Wiederherstellen';

  @override
  String get restorePurchases => 'Käufe wiederherstellen';

  @override
  String get subscriptionRestored => 'Abonnement erfolgreich wiederhergestellt!';

  @override
  String get noPurchasesToRestore => 'Keine Käufe zum Wiederherstellen';

  @override
  String get goPremium => 'Premium werden';

  @override
  String get unlockExclusiveFeatures => 'Schalten Sie exklusive Funktionen frei, um das Beste aus Ihrer Hautanalyse herauszuholen.';

  @override
  String get unlimitedProductScans => 'Unbegrenzte Produktscans';

  @override
  String get advancedAIIngredientAnalysis => 'Erweiterte KI-Inhaltsstoffanalyse';

  @override
  String get fullScanAndSearchHistory => 'Vollständiger Scan- und Suchverlauf';

  @override
  String get adFreeExperience => '100% werbefreie Erfahrung';

  @override
  String get yearly => 'Jährlich';

  @override
  String savePercentage(int percentage) {
    return '$percentage% sparen';
  }

  @override
  String get monthly => 'Monatlich';

  @override
  String get perMonth => '/ Monat';

  @override
  String get startFreeTrial => 'Kostenlose Testversion starten';

  @override
  String trialDescription(String planName) {
    return '7-tägige kostenlose Testversion, dann wird $planName berechnet. Jederzeit kündbar.';
  }

  @override
  String get home => 'Start';

  @override
  String get scan => 'Scanner';

  @override
  String get aiChatNav => 'Beauty-Berater';

  @override
  String get profileNav => 'Profil';

  @override
  String get doYouEnjoyOurApp => 'Gefällt Ihnen unsere App?';

  @override
  String get notReally => 'Nein';

  @override
  String get yesItsGreat => 'Sie gefällt mir';

  @override
  String get rateOurApp => 'Bewerten Sie unsere App';

  @override
  String get bestRatingWeCanGet => 'Beste Bewertung, die wir bekommen können';

  @override
  String get rateOnGooglePlay => 'Auf Google Play bewerten';

  @override
  String get rate => 'Bewerten';

  @override
  String get whatCanBeImproved => 'Was kann verbessert werden?';

  @override
  String get wereSorryYouDidntHaveAGreatExperience => 'Es tut uns leid, dass Sie keine gute Erfahrung hatten. Bitte sagen Sie uns, was schief gelaufen ist.';

  @override
  String get yourFeedback => 'Ihr Feedback...';

  @override
  String get sendFeedback => 'Feedback senden';

  @override
  String get thankYouForYourFeedback => 'Vielen Dank für Ihr Feedback!';

  @override
  String get discussWithAI => 'Mit KI diskutieren';

  @override
  String get enterYourEmail => 'E-Mail eingeben';

  @override
  String get enterYourPassword => 'Passwort eingeben';

  @override
  String get aiDisclaimer => 'KI-Antworten können Ungenauigkeiten enthalten. Bitte überprüfen Sie kritische Informationen.';

  @override
  String get applicationThemes => 'Anwendungsthemen';

  @override
  String get highestRating => 'Höchste Bewertung';

  @override
  String get selectYourAgeDescription => 'Wählen Sie Ihr Alter';

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
  String get ageRange18_25Description => 'Junge Haut, Prävention';

  @override
  String get ageRange26_35Description => 'Erste Anzeichen von Hautalterung';

  @override
  String get ageRange36_45Description => 'Anti-Aging-Pflege';

  @override
  String get ageRange46_55Description => 'Intensive Pflege';

  @override
  String get ageRange56PlusDescription => 'Spezialisierte Pflege';

  @override
  String get userName => 'Ihr Name';

  @override
  String get yourName => 'Your Name';

  @override
  String get tryFreeAndSubscribe => 'Kostenlos testen & abonnieren';

  @override
  String get personalAIConsultant => 'Persönlicher KI-Berater 24/7';

  @override
  String get subscribe => 'Abonnieren';

  @override
  String get themes => 'Themen';

  @override
  String get selectPreferredTheme => 'Wählen Sie Ihr bevorzugtes Thema';

  @override
  String get naturalTheme => 'Natürlich';

  @override
  String get darkTheme => 'Dunkel';

  @override
  String get darkNatural => 'Dunkles Natürlich';

  @override
  String get oceanTheme => 'Ozean';

  @override
  String get forestTheme => 'Wald';

  @override
  String get sunsetTheme => 'Sonnenuntergang';

  @override
  String get naturalThemeDescription => 'Natürliches Thema mit umweltfreundlichen Farben';

  @override
  String get darkThemeDescription => 'Dunkles Thema für Augenkomfort';

  @override
  String get oceanThemeDescription => 'Frisches Ozean-Thema';

  @override
  String get forestThemeDescription => 'Natürliches Wald-Thema';

  @override
  String get sunsetThemeDescription => 'Warmes Sonnenuntergang-Thema';

  @override
  String get sunnyTheme => 'Sonnig';

  @override
  String get sunnyThemeDescription => 'Helles und fröhliches gelbes Thema';

  @override
  String get vibrantTheme => 'Lebendig';

  @override
  String get vibrantThemeDescription => 'Helles rosa und lila Thema';

  @override
  String get scanAnalysis => 'Scan-Analyse';

  @override
  String get ingredients => 'Zutaten';

  @override
  String get aiBotSettings => 'KI-Einstellungen';

  @override
  String get botName => 'Bot-Name';

  @override
  String get enterBotName => 'Bot-Namen eingeben';

  @override
  String get pleaseEnterBotName => 'Bitte geben Sie den Bot-Namen ein';

  @override
  String get botDescription => 'Bot-Beschreibung';

  @override
  String get selectAvatar => 'Avatar auswählen';

  @override
  String get defaultBotName => 'ACS';

  @override
  String defaultBotDescription(String name) {
    return 'Hallo! Ich bin $name (kurz für AI Cosmetic Scanner). Ich helfe Ihnen, die Zusammensetzung Ihrer Kosmetikprodukte zu verstehen. Ich habe ein riesiges Wissen in der Kosmetologie und Pflege. Ich werde gerne alle Ihre Fragen beantworten.';
  }

  @override
  String get settingsSaved => 'Einstellungen erfolgreich gespeichert';

  @override
  String get failedToSaveSettings => 'Fehler beim Speichern der Einstellungen';

  @override
  String get resetToDefault => 'Auf Standard zurücksetzen';

  @override
  String get resetSettings => 'Einstellungen zurücksetzen';

  @override
  String get resetSettingsConfirmation => 'Sind Sie sicher, dass Sie alle Einstellungen auf die Standardwerte zurücksetzen möchten?';

  @override
  String get settingsResetSuccessfully => 'Einstellungen erfolgreich zurückgesetzt';

  @override
  String get failedToResetSettings => 'Fehler beim Zurücksetzen der Einstellungen';

  @override
  String get unsavedChanges => 'Nicht gespeicherte Änderungen';

  @override
  String get unsavedChangesMessage => 'Sie haben nicht gespeicherte Änderungen. Möchten Sie wirklich die Seite verlassen?';

  @override
  String get stay => 'Bleiben';

  @override
  String get leave => 'Verlassen';

  @override
  String get errorLoadingSettings => 'Fehler beim Laden der Einstellungen';

  @override
  String get retry => 'Wiederholen';

  @override
  String get customPrompt => 'Besondere Wünsche';

  @override
  String get customPromptDescription => 'Fügen Sie personalisierte Anweisungen für den KI-Assistenten hinzu';

  @override
  String get customPromptPlaceholder => 'Geben Sie Ihre besonderen Wünsche ein...';

  @override
  String get enableCustomPrompt => 'Besondere Wünsche aktivieren';

  @override
  String get defaultCustomPrompt => 'Gib mir Komplimente.';

  @override
  String get close => 'Schließen';

  @override
  String get scanningHintTitle => 'Wie wird gescannt';

  @override
  String get scanLimitReached => 'Scan-Limit erreicht';

  @override
  String get scanLimitReachedMessage => 'Sie haben alle 5 kostenlosen Scans dieser Woche verwendet. Upgrade auf Premium für unbegrenzte Scans!';

  @override
  String get messageLimitReached => 'Daily Message Limit Reached';

  @override
  String get messageLimitReachedMessage => 'You\'ve sent 5 messages today. Upgrade to Premium for unlimited chat!';

  @override
  String get historyLimitReached => 'History Access Limited';

  @override
  String get historyLimitReachedMessage => 'Upgraden Sie auf Premium, um auf Ihren vollständigen Scan-Verlauf zuzugreifen!';

  @override
  String get upgradeToPremium => 'Upgrade auf Premium';

  @override
  String get upgradeToView => 'Upgrade zum Ansehen';

  @override
  String get upgradeToChat => 'Upgrade to Chat';

  @override
  String get premiumFeature => 'Premium-Funktion';

  @override
  String get freePlanUsage => 'Free Plan Usage';

  @override
  String get scansThisWeek => 'Scans this week';

  @override
  String get messagesToday => 'Messages today';

  @override
  String get limitsReached => 'Limits reached';

  @override
  String get remainingScans => 'Verbleibende Scans';

  @override
  String get remainingMessages => 'Verbleibende Nachrichten';

  @override
  String get usageLimitsBadge => 'Einschränkungen der kostenlosen Version';

  @override
  String get unlockUnlimitedAccess => 'Unlock Unlimited Access';

  @override
  String get upgradeToPremiumDescription => 'Get unlimited scans, messages, and full access to your scan history with Premium!';

  @override
  String get premiumBenefits => 'Premium Benefits';

  @override
  String get subscriptionBenefitsTitle => 'Premium-Funktionen freischalten';

  @override
  String get subscriptionBenefitsDescription => 'Upgraden Sie auf Premium und erhalten Sie unbegrenzten Zugriff auf alle Funktionen';

  @override
  String get getSubscription => 'Premium erhalten';

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
  String get slowInternetConnection => 'Langsame Internetverbindung';

  @override
  String get slowInternetMessage => 'Bei sehr langsamer Internetverbindung müssen Sie etwas warten... Wir analysieren immer noch Ihr Bild.';

  @override
  String get revolutionaryAI => 'Revolutionäre KI';

  @override
  String get revolutionaryAIDesc => 'Eine der intelligentesten der Welt';

  @override
  String get unlimitedScans => 'Unbegrenzte Scans';

  @override
  String get unlimitedScansDesc => 'Kosmetik ohne Grenzen erkunden';

  @override
  String get unlimitedChats => 'Unbegrenzte Chats';

  @override
  String get unlimitedChatsDesc => 'Persönlicher KI-Berater 24/7';

  @override
  String get fullHistory => 'Vollständige Historie';

  @override
  String get fullHistoryDesc => 'Unbegrenzte Scan-Historie';

  @override
  String get rememberContext => 'Merkt sich den Kontext';

  @override
  String get rememberContextDesc => 'KI erinnert sich an Ihre vorherigen Nachrichten';

  @override
  String get allIngredientsInfo => 'Alle Informationen zu Inhaltsstoffen';

  @override
  String get allIngredientsInfoDesc => 'Erfahre alle Details';

  @override
  String get noAds => '100% werbefrei';

  @override
  String get noAdsDesc => 'Für diejenigen, die ihre Zeit schätzen';

  @override
  String get multiLanguage => 'Kennt fast alle Sprachen der Welt';

  @override
  String get multiLanguageDesc => 'Verbesserter Übersetzer';

  @override
  String get paywallTitle => 'Entdecken Sie die Geheimnisse Ihrer Kosmetik mit KI';

  @override
  String paywallDescription(String price) {
    return 'Sie haben die Möglichkeit, ein Premium-Abonnement für 3 Tage kostenlos zu erhalten, danach $price pro Woche. Jederzeit kündbar.';
  }

  @override
  String get whatsIncluded => 'Was ist enthalten';

  @override
  String get basicPlan => 'Basis';

  @override
  String get premiumPlan => 'Premium';

  @override
  String get botGreeting1 => 'Guten Tag! Wie kann ich Ihnen heute helfen?';

  @override
  String get botGreeting2 => 'Hallo! Was führt Sie zu mir?';

  @override
  String get botGreeting3 => 'Ich begrüße Sie! Ich helfe gerne bei der Kosmetikanalyse.';

  @override
  String get botGreeting4 => 'Schön, Sie zu sehen! Wobei kann ich behilflich sein?';

  @override
  String get botGreeting5 => 'Willkommen! Lassen Sie uns gemeinsam die Zusammensetzung Ihrer Kosmetik untersuchen.';

  @override
  String get botGreeting6 => 'Hallo! Ich bin bereit, Ihre Fragen zur Kosmetik zu beantworten.';

  @override
  String get botGreeting7 => 'Hallo! Ich ist Ihr persönlicher Kosmetikassistent.';

  @override
  String get botGreeting8 => 'Guten Tag! Ich helfe Ihnen, die Zusammensetzung von Kosmetikprodukten zu verstehen.';

  @override
  String get botGreeting9 => 'Hallo! Lassen Sie uns Ihre Kosmetik sicherer machen.';

  @override
  String get botGreeting10 => 'Ich begrüße Sie! Ich teile gerne mein Wissen über Kosmetik.';

  @override
  String get botGreeting11 => 'Guten Tag! Ich helfe Ihnen, die besten Kosmetiklösungen zu finden.';

  @override
  String get botGreeting12 => 'Hallo! Ihr Kosmetiksicherheitsexperte steht zu Ihren Diensten.';

  @override
  String get botGreeting13 => 'Hallo! Lassen Sie uns gemeinsam die perfekte Kosmetik für Sie auswählen.';

  @override
  String get botGreeting14 => 'Willkommen! Ich helfe gerne bei der Analyse von Inhaltsstoffen.';

  @override
  String get botGreeting15 => 'Hallo! Ich helfe Ihnen, die Zusammensetzung Ihrer Kosmetik zu verstehen.';

  @override
  String get botGreeting16 => 'Ich begrüße Sie! Ihr Führer durch die Welt der Kosmetik ist bereit zu helfen.';

  @override
  String get copiedToClipboard => 'In die Zwischenablage kopiert';

  @override
  String get tryFree => 'Kostenlos Testen';

  @override
  String get cameraNotReady => 'Kamera nicht bereit / keine Berechtigung';

  @override
  String get cameraPermissionInstructions => 'App-Einstellungen:\nAI Cosmetic Scanner > Berechtigungen > Kamera > Erlauben';

  @override
  String get openSettingsAndGrantAccess => 'Öffnen Sie die Einstellungen und gewähren Sie Kamerazugriff';

  @override
  String get retryCamera => 'Wiederholen';

  @override
  String get errorServiceOverloaded => 'Der Dienst ist vorübergehend ausgelastet. Bitte versuchen Sie es in einem Moment erneut.';

  @override
  String get errorRateLimitExceeded => 'Zu viele Anfragen. Bitte warten Sie einen Moment und versuchen Sie es erneut.';

  @override
  String get errorTimeout => 'Zeitüberschreitung. Bitte überprüfen Sie Ihre Internetverbindung und versuchen Sie es erneut.';

  @override
  String get errorNetwork => 'Netzwerkfehler. Bitte überprüfen Sie Ihre Internetverbindung.';

  @override
  String get errorAuthentication => 'Authentifizierungsfehler. Bitte starten Sie die App neu.';

  @override
  String get errorInvalidResponse => 'Ungültige Antwort erhalten. Bitte versuchen Sie es erneut.';

  @override
  String get errorServer => 'Serverfehler. Bitte versuchen Sie es später erneut.';

  @override
  String get customThemes => 'Benutzerdefinierte Themen';

  @override
  String get createCustomTheme => 'Benutzerdefiniertes Thema Erstellen';

  @override
  String get basedOn => 'Basierend auf';

  @override
  String get lightMode => 'Hell';

  @override
  String get generateWithAI => 'Mit KI Generieren';

  @override
  String get resetToBaseTheme => 'Auf Basisthema Zurücksetzen';

  @override
  String colorsResetTo(Object themeName) {
    return 'Farben auf $themeName zurückgesetzt';
  }

  @override
  String get aiGenerationComingSoon => 'KI-Themengenerierung kommt in Iteration 5!';

  @override
  String get onboardingGreeting => 'Willkommen! Um die Qualität der Antworten zu verbessern, richten wir Ihr Profil ein';

  @override
  String get letsGo => 'Los geht\'s';

  @override
  String get next => 'Weiter';

  @override
  String get finish => 'Fertig';

  @override
  String get selectYourActionDescription => 'What would you like to do now?';

  @override
  String get scanCosmetic => 'Scan Cosmetic';

  @override
  String get goToChat => 'Go to Chat';

  @override
  String get enjoyingScanning => 'Enjoying the scanner?';

  @override
  String get enjoyingChat => 'Enjoying the chat?';

  @override
  String softPaywallScanMessage(int remaining) {
    return 'You\'ve used 3 scans! You have $remaining free scans left this week. Upgrade to Premium for unlimited access!';
  }

  @override
  String softPaywallMessageMessage(int remaining) {
    return 'You\'ve sent 3 messages! You have $remaining messages left today. Upgrade to Premium for unlimited chat!';
  }

  @override
  String get unlimitedScansAndChat => 'Unlimited scans and chat';

  @override
  String get fullScanHistory => 'Access full scan history';

  @override
  String get tryPremium => 'Try Premium';

  @override
  String get continueWithFree => 'Continue with free plan';

  @override
  String get customThemeInDevelopment => 'Benutzerdefinierte Themen befinden sich in der Entwicklung';

  @override
  String get customThemeComingSoon => 'Demnächst in zukünftigen Updates verfügbar';

  @override
  String get dailyMessageLimitReached => 'Limit erreicht';

  @override
  String get dailyMessageLimitReachedMessage => 'Sie haben heute 5 Nachrichten gesendet. Upgrade auf Premium für unbegrenzten Chat!';

  @override
  String get upgradeToPremiumForUnlimitedChat => 'Upgrade auf Premium für unbegrenzten Chat';

  @override
  String get messagesLeftToday => 'Nachrichten übrig für heute';

  @override
  String get designYourOwnTheme => 'Gestalten Sie Ihr eigenes Thema';

  @override
  String get darkOcean => 'Dunkler Ozean';

  @override
  String get darkForest => 'Dunkler Wald';

  @override
  String get darkSunset => 'Dunkler Sonnenuntergang';

  @override
  String get darkVibrant => 'Dunkel Lebendig';

  @override
  String get darkOceanThemeDescription => 'Dunkles Ozean-Thema mit Cyan-Akzenten';

  @override
  String get darkForestThemeDescription => 'Dunkles Wald-Thema mit hellgrünen Akzenten';

  @override
  String get darkSunsetThemeDescription => 'Dunkles Sonnenuntergang-Thema mit orangen Akzenten';

  @override
  String get darkVibrantThemeDescription => 'Dunkles lebendiges Thema mit rosa und lila Akzenten';

  @override
  String get customTheme => 'Benutzerdefiniertes Thema';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get deleteTheme => 'Thema löschen';

  @override
  String deleteThemeConfirmation(String themeName) {
    return 'Sind Sie sicher, dass Sie \"$themeName\" löschen möchten?';
  }

  @override
  String get pollTitle => 'Was fehlt?';

  @override
  String get pollCardTitle => 'Was fehlt in der App?';

  @override
  String get pollDescription => 'Stimmen Sie für die Optionen, die Sie sehen möchten';

  @override
  String get submitVote => 'Abstimmen';

  @override
  String get submitting => 'Wird gesendet...';

  @override
  String get voteSubmittedSuccess => 'Stimmen erfolgreich gesendet!';

  @override
  String votesRemaining(int count) {
    return '$count Stimmen übrig';
  }

  @override
  String get votes => 'Stimmen';

  @override
  String get addYourOption => 'Verbesserung vorschlagen';

  @override
  String get enterYourOption => 'Geben Sie Ihre Option ein...';

  @override
  String get add => 'Hinzufügen';

  @override
  String get filterTopVoted => 'Beliebt';

  @override
  String get filterNewest => 'Neu';

  @override
  String get filterMyOption => 'Meine Wahl';

  @override
  String get thankYouForVoting => 'Vielen Dank für Ihre Stimme!';

  @override
  String get votingComplete => 'Ihre Stimme wurde registriert';

  @override
  String get requestFeatureDevelopment => 'Benutzerdefinierte Feature-Entwicklung anfordern';

  @override
  String get requestFeatureDescription => 'Benötigen Sie eine bestimmte Funktion? Kontaktieren Sie uns, um die benutzerdefinierte Entwicklung für Ihre Geschäftsbedürfnisse zu besprechen.';

  @override
  String get pollHelpTitle => 'Wie man abstimmt';

  @override
  String get pollHelpDescription => '• Tippen Sie auf eine Option, um sie auszuwählen\n• Tippen Sie erneut, um die Auswahl aufzuheben\n• Wählen Sie so viele Optionen, wie Sie möchten\n• Klicken Sie auf \'Abstimmen\', um Ihre Stimmen zu senden\n• Fügen Sie Ihre eigene Option hinzu, wenn Sie nicht finden, was Sie brauchen';

  @override
  String get developer => 'Developer';

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
