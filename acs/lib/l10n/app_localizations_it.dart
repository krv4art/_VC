// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appName => 'AI Cosmetic Scanner';

  @override
  String get skinAnalysis => 'Analisi della Pelle';

  @override
  String get checkYourCosmetics => 'Controlla i tuoi cosmetici';

  @override
  String get startScanning => 'Inizia Scansione';

  @override
  String get quickActions => 'Azioni Rapide';

  @override
  String get scanHistory => 'Cronologia Scansioni';

  @override
  String get aiChat => 'Chat AI';

  @override
  String get profile => 'Profilo';

  @override
  String get settings => 'Impostazioni';

  @override
  String get skinType => 'Tipo di Pelle';

  @override
  String get allergiesSensitivities => 'Allergie & Sensibilità';

  @override
  String get subscription => 'Abbonamento';

  @override
  String get age => 'Età';

  @override
  String get language => 'Lingua';

  @override
  String get selectYourPreferredLanguage => 'Seleziona la tua lingua preferita';

  @override
  String get save => 'Salva';

  @override
  String get selectIngredientsAllergicSensitive => 'Seleziona gli ingredienti a cui hai una sensibilità elevata';

  @override
  String get commonAllergens => 'Allergeni Comuni';

  @override
  String get fragrance => 'Fragranza';

  @override
  String get parabens => 'Parabeni';

  @override
  String get sulfates => 'Solfati';

  @override
  String get alcohol => 'Alcol';

  @override
  String get essentialOils => 'Oli Essenziali';

  @override
  String get silicones => 'Siliconi';

  @override
  String get mineralOil => 'Olio Minerale';

  @override
  String get formaldehyde => 'Formaldeide';

  @override
  String get addCustomAllergen => 'Aggiungi Allergene Personalizzato';

  @override
  String get typeIngredientName => 'Digita nome ingrediente...';

  @override
  String get selectedAllergens => 'Allergeni Selezionati';

  @override
  String saveSelected(int count) {
    return 'Salva ($count selezionati)';
  }

  @override
  String get analysisResults => 'Risultati Analisi';

  @override
  String get overallSafetyScore => 'Punteggio di Sicurezza Complessivo';

  @override
  String get personalizedWarnings => 'Avvisi Personalizzati';

  @override
  String ingredientsAnalysis(int count) {
    return 'Analisi Ingredienti ($count)';
  }

  @override
  String get highRisk => 'Rischio elevato';

  @override
  String get moderateRisk => 'Rischio Moderato';

  @override
  String get lowRisk => 'Rischio Basso';

  @override
  String get benefitsAnalysis => 'Analisi Benefici';

  @override
  String get recommendedAlternatives => 'Alternative Consigliate';

  @override
  String get reason => 'Motivo:';

  @override
  String get quickSummary => 'Riepilogo rapido';

  @override
  String get ingredientsChecked => 'ingredienti verificati';

  @override
  String get personalWarnings => 'avvisi personali';

  @override
  String get ourVerdict => 'Il nostro verdetto';

  @override
  String get productInfo => 'Informazioni prodotto';

  @override
  String get productType => 'Tipo di prodotto';

  @override
  String get brand => 'Marca';

  @override
  String get premiumInsights => 'Premium Insights';

  @override
  String get researchArticles => 'Articoli di ricerca';

  @override
  String get categoryRanking => 'Classifica categoria';

  @override
  String get safetyTrend => 'Trend sicurezza';

  @override
  String get saveToFavorites => 'Salva';

  @override
  String get shareResults => 'Condividi';

  @override
  String get compareProducts => 'Confronta';

  @override
  String get exportPDF => 'PDF';

  @override
  String get scanSimilar => 'Simile';

  @override
  String get aiChatTitle => 'Chat AI';

  @override
  String get typeYourMessage => 'Digita il tuo messaggio...';

  @override
  String get errorSupabaseClientNotInitialized => 'Errore: Client Supabase non inizializzato.';

  @override
  String get serverError => 'Errore del server:';

  @override
  String get networkErrorOccurred => 'Si è verificato un errore di rete. Riprova più tardi.';

  @override
  String get sorryAnErrorOccurred => 'Spiacenti, si è verificato un errore. Riprova.';

  @override
  String get couldNotGetResponse => 'Impossibile ottenere una risposta.';

  @override
  String get aiAssistant => 'Assistente AI';

  @override
  String get online => 'Online';

  @override
  String get typing => 'Sto scrivendo...';

  @override
  String get writeAMessage => 'Scrivi un messaggio...';

  @override
  String get hiIAmYourAIAssistantHowCanIHelp => 'Ciao! Sono il tuo assistente AI. Come posso aiutarti?';

  @override
  String get iCanSeeYourScanResultsFeelFreeToAskMeAnyQuestionsAboutTheIngredientsSafetyConcernsOrRecommendations => 'Posso vedere i risultati della tua scansione! Sentiti libero di farmi qualsiasi domanda sugli ingredienti, preoccupazioni di sicurezza o raccomandazioni.';

  @override
  String get userQuestion => 'Domanda dell\'utente:';

  @override
  String get databaseExplorer => 'Esploratore Database';

  @override
  String get currentUser => 'Utente Attuale:';

  @override
  String get notSignedIn => 'Non hai effettuato l\'accesso';

  @override
  String get failedToFetchTables => 'Recupero tabelle fallito:';

  @override
  String get tablesInYourSupabaseDatabase => 'Tabelle nel tuo database Supabase:';

  @override
  String get viewSampleData => 'Visualizza Dati di Esempio';

  @override
  String get failedToFetchSampleDataFor => 'Recupero dati di esempio fallito per';

  @override
  String get sampleData => 'Dati di Esempio:';

  @override
  String get aiChats => 'Chat IA';

  @override
  String get noDialoguesYet => 'Nessun dialogo ancora.';

  @override
  String get startANewChat => 'Inizia una nuova chat!';

  @override
  String get created => 'Creato:';

  @override
  String get failedToSaveImage => 'Salvataggio immagine fallito:';

  @override
  String get editName => 'Modifica Nome';

  @override
  String get enterYourName => 'Inserisci il tuo nome';

  @override
  String get cancel => 'Annulla';

  @override
  String get premiumUser => 'Utente Premium';

  @override
  String get freeUser => 'Utente Gratuito';

  @override
  String get skinProfile => 'Profilo Pelle';

  @override
  String get notSet => 'Non impostato';

  @override
  String get legal => 'Legale';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get termsOfService => 'Termini di Servizio';

  @override
  String get dataManagement => 'Gestione Dati';

  @override
  String get clearAllData => 'Cancella Tutti i Dati';

  @override
  String get clearAllDataConfirmation => 'Sei sicuro di voler eliminare tutti i tuoi dati locali? Questa azione non può essere annullata.';

  @override
  String get selectDataToClear => 'Seleziona dati da cancellare';

  @override
  String get scanResults => 'Risultati Scansione';

  @override
  String get chatHistory => 'Chat';

  @override
  String get personalData => 'Dati Personali';

  @override
  String get clearData => 'Cancella Dati';

  @override
  String get allLocalDataHasBeenCleared => 'Tutti i dati locali sono stati cancellati.';

  @override
  String get signOut => 'Esci';

  @override
  String get deleteScan => 'Elimina Scansione';

  @override
  String get deleteScanConfirmation => 'Sei sicuro di voler eliminare questa scansione dalla tua cronologia?';

  @override
  String get deleteChat => 'Elimina Chat';

  @override
  String get deleteChatConfirmation => 'Sei sicuro di voler eliminare questa chat? Tutti i messaggi andranno persi.';

  @override
  String get delete => 'Elimina';

  @override
  String get noScanHistoryFound => 'Nessuna cronologia di scansioni trovata.';

  @override
  String get scanOn => 'Scansione del';

  @override
  String get ingredientsFound => 'ingredienti trovati';

  @override
  String get noCamerasFoundOnThisDevice => 'Nessuna fotocamera trovata su questo dispositivo.';

  @override
  String get failedToInitializeCamera => 'Inizializzazione fotocamera fallita:';

  @override
  String get analysisFailed => 'Analisi fallita:';

  @override
  String get analyzingPleaseWait => 'Analisi in corso, attendere...';

  @override
  String get positionTheLabelWithinTheFrame => 'Messa a fuoco della camera sull\'elenco degli ingredienti';

  @override
  String get createAccount => 'Crea Account';

  @override
  String get signUpToGetStarted => 'Registrati per iniziare';

  @override
  String get fullName => 'Nome Completo';

  @override
  String get pleaseEnterYourName => 'Per favore inserisci il tuo nome';

  @override
  String get email => 'Email';

  @override
  String get pleaseEnterYourEmail => 'Per favore inserisci la tua email';

  @override
  String get pleaseEnterAValidEmail => 'Per favore inserisci un\'email valida';

  @override
  String get password => 'Password';

  @override
  String get pleaseEnterYourPassword => 'Per favore inserisci la tua password';

  @override
  String get passwordMustBeAtLeast6Characters => 'La password deve essere di almeno 6 caratteri';

  @override
  String get signUp => 'Registrati';

  @override
  String get orContinueWith => 'o continua con';

  @override
  String get google => 'Google';

  @override
  String get apple => 'Apple';

  @override
  String get alreadyHaveAnAccount => 'Hai già un account? ';

  @override
  String get signIn => 'Accedi';

  @override
  String get selectYourSkinTypeDescription => 'Seleziona il tuo tipo di pelle';

  @override
  String get normal => 'Normale';

  @override
  String get normalSkinDescription => 'Equilibrata, né troppo grassa né troppo secca';

  @override
  String get dry => 'Secca';

  @override
  String get drySkinDescription => 'Tesa, squamosa, texture ruvida';

  @override
  String get oily => 'Grassa';

  @override
  String get oilySkinDescription => 'Luccicante, pori grandi, propensa all\'acne';

  @override
  String get combination => 'Mista';

  @override
  String get combinationSkinDescription => 'Zona T grassa, guance secche';

  @override
  String get sensitive => 'Sensibile';

  @override
  String get sensitiveSkinDescription => 'Facilmente irritabile, propensa al rossore';

  @override
  String get selectSkinType => 'Seleziona tipo di pelle';

  @override
  String get restore => 'Ripristina';

  @override
  String get restorePurchases => 'Ripristina acquisti';

  @override
  String get subscriptionRestored => 'Abbonamento ripristinato con successo!';

  @override
  String get noPurchasesToRestore => 'Nessun acquisto da ripristinare';

  @override
  String get goPremium => 'Diventa Premium';

  @override
  String get unlockExclusiveFeatures => 'Sblocca funzionalità esclusive per ottenere il massimo dalla tua analisi della pelle.';

  @override
  String get unlimitedProductScans => 'Scansioni di Prodotti Illimitate';

  @override
  String get advancedAIIngredientAnalysis => 'Analisi Avanzata degli Ingredienti con AI';

  @override
  String get fullScanAndSearchHistory => 'Cronologia Completa di Scansioni e Ricerche';

  @override
  String get adFreeExperience => 'Esperienza 100% Senza Pubblicità';

  @override
  String get yearly => 'Annuale';

  @override
  String savePercentage(int percentage) {
    return 'Risparmia $percentage%';
  }

  @override
  String get monthly => 'Mensile';

  @override
  String get perMonth => '/ mese';

  @override
  String get startFreeTrial => 'Inizia Prova Gratuita';

  @override
  String trialDescription(String planName) {
    return 'Prova gratuita di 7 giorni, poi addebitato $planName. Annulla in qualsiasi momento.';
  }

  @override
  String get home => 'Home';

  @override
  String get scan => 'Scanner';

  @override
  String get aiChatNav => 'Consulente di bellezza';

  @override
  String get profileNav => 'Profilo';

  @override
  String get doYouEnjoyOurApp => 'Ti piace la nostra app?';

  @override
  String get notReally => 'No';

  @override
  String get yesItsGreat => 'Mi piace';

  @override
  String get rateOurApp => 'Valuta la nostra app';

  @override
  String get bestRatingWeCanGet => 'Il miglior voto che possiamo ottenere';

  @override
  String get rateOnGooglePlay => 'Valuta su Google Play';

  @override
  String get rate => 'Valuta';

  @override
  String get whatCanBeImproved => 'Cosa può essere migliorato?';

  @override
  String get wereSorryYouDidntHaveAGreatExperience => 'Siamo spiacenti che tu non abbia avuto un\'ottima esperienza. Per favore dicci cosa è andato storto.';

  @override
  String get yourFeedback => 'Il tuo feedback...';

  @override
  String get sendFeedback => 'Invia Feedback';

  @override
  String get thankYouForYourFeedback => 'Grazie per il tuo feedback!';

  @override
  String get discussWithAI => 'Discuti con AI';

  @override
  String get enterYourEmail => 'Inserisci la tua email';

  @override
  String get enterYourPassword => 'Inserisci la tua password';

  @override
  String get aiDisclaimer => 'Le risposte AI possono contenere imprecisioni. Si prega di verificare le informazioni critiche.';

  @override
  String get applicationThemes => 'Temi Applicazione';

  @override
  String get highestRating => 'Voto Più Alto';

  @override
  String get selectYourAgeDescription => 'Seleziona la tua età';

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
  String get ageRange18_25Description => 'Pelle giovane, prevenzione';

  @override
  String get ageRange26_35Description => 'Primi segni di invecchiamento';

  @override
  String get ageRange36_45Description => 'Cura anti-invecchiamento';

  @override
  String get ageRange46_55Description => 'Cura intensiva';

  @override
  String get ageRange56PlusDescription => 'Cura specializzata';

  @override
  String get userName => 'Il Tuo Nome';

  @override
  String get yourName => 'Your Name';

  @override
  String get tryFreeAndSubscribe => 'Prova Gratis & Abbonati';

  @override
  String get personalAIConsultant => 'Consulente AI Personale 24/7';

  @override
  String get subscribe => 'Abbonati';

  @override
  String get themes => 'Temi';

  @override
  String get selectPreferredTheme => 'Seleziona il tuo tema preferito';

  @override
  String get naturalTheme => 'Naturale';

  @override
  String get darkTheme => 'Scuro';

  @override
  String get darkNatural => 'Naturale Scuro';

  @override
  String get oceanTheme => 'Oceano';

  @override
  String get forestTheme => 'Foresta';

  @override
  String get sunsetTheme => 'Tramonto';

  @override
  String get naturalThemeDescription => 'Tema naturale con colori ecologici';

  @override
  String get darkThemeDescription => 'Tema scuro per il comfort degli occhi';

  @override
  String get oceanThemeDescription => 'Tema oceano fresco';

  @override
  String get forestThemeDescription => 'Tema foresta naturale';

  @override
  String get sunsetThemeDescription => 'Tema tramonto caldo';

  @override
  String get sunnyTheme => 'Soleggiato';

  @override
  String get sunnyThemeDescription => 'Tema giallo luminoso e allegro';

  @override
  String get vibrantTheme => 'Vibrante';

  @override
  String get vibrantThemeDescription => 'Tema luminoso rosa e viola';

  @override
  String get scanAnalysis => 'Analisi Scan';

  @override
  String get ingredients => 'ingredienti';

  @override
  String get aiBotSettings => 'Impostazioni IA';

  @override
  String get botName => 'Nome del bot';

  @override
  String get enterBotName => 'Inserisci il nome del bot';

  @override
  String get pleaseEnterBotName => 'Per favore inserisci il nome del bot';

  @override
  String get botDescription => 'Descrizione del bot';

  @override
  String get selectAvatar => 'Seleziona avatar';

  @override
  String get defaultBotName => 'ACS';

  @override
  String defaultBotDescription(String name) {
    return 'Ciao! Sono $name (abbreviazione di AI Cosmetic Scanner). Ti aiuterò a capire la composizione dei tuoi cosmetici. Ho una grande conoscenza in cosmetologia e cura. Sarò felice di rispondere a tutte le tue domande.';
  }

  @override
  String get settingsSaved => 'Impostazioni salvate con successo';

  @override
  String get failedToSaveSettings => 'Impossibile salvare le impostazioni';

  @override
  String get resetToDefault => 'Ripristina impostazioni predefinite';

  @override
  String get resetSettings => 'Ripristina impostazioni';

  @override
  String get resetSettingsConfirmation => 'Sei sicuro di voler ripristinare tutte le impostazioni ai valori predefiniti?';

  @override
  String get settingsResetSuccessfully => 'Impostazioni ripristinate con successo';

  @override
  String get failedToResetSettings => 'Impossibile ripristinare le impostazioni';

  @override
  String get unsavedChanges => 'Modifiche non salvate';

  @override
  String get unsavedChangesMessage => 'Hai modifiche non salvate. Sei sicuro di voler uscire?';

  @override
  String get stay => 'Rimani';

  @override
  String get leave => 'Esci';

  @override
  String get errorLoadingSettings => 'Errore nel caricamento delle impostazioni';

  @override
  String get retry => 'Riprova';

  @override
  String get customPrompt => 'Richieste Speciali';

  @override
  String get customPromptDescription => 'Aggiungi istruzioni personalizzate per l\'assistente IA';

  @override
  String get customPromptPlaceholder => 'Inserisci le tue richieste speciali...';

  @override
  String get enableCustomPrompt => 'Abilita richieste speciali';

  @override
  String get defaultCustomPrompt => 'Fammi dei complimenti.';

  @override
  String get close => 'Chiudi';

  @override
  String get scanningHintTitle => 'Come scansionare';

  @override
  String get scanLimitReached => 'Limite scan raggiunto';

  @override
  String get scanLimitReachedMessage => 'Hai usato tutti i 5 scan gratuiti questa settimana. Aggiorna a Premium per scan illimitati!';

  @override
  String get messageLimitReached => 'Daily Message Limit Reached';

  @override
  String get messageLimitReachedMessage => 'You\'ve sent 5 messages today. Upgrade to Premium for unlimited chat!';

  @override
  String get historyLimitReached => 'History Access Limited';

  @override
  String get historyLimitReachedMessage => 'Aggiorna a Premium per accedere alla cronologia completa delle scansioni!';

  @override
  String get upgradeToPremium => 'Aggiorna a Premium';

  @override
  String get upgradeToView => 'Aggiorna per visualizzare';

  @override
  String get upgradeToChat => 'Upgrade to Chat';

  @override
  String get premiumFeature => 'Funzione Premium';

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
  String get slowInternetConnection => 'Connessione Internet lenta';

  @override
  String get slowInternetMessage => 'Su una connessione Internet molto lenta, dovrai aspettare un po\'... Stiamo ancora analizzando la tua immagine.';

  @override
  String get revolutionaryAI => 'IA rivoluzionaria';

  @override
  String get revolutionaryAIDesc => 'Una delle più intelligenti al mondo';

  @override
  String get unlimitedScans => 'Scansioni illimitate';

  @override
  String get unlimitedScansDesc => 'Esplora i cosmetici senza limiti';

  @override
  String get unlimitedChats => 'Chat illimitate';

  @override
  String get unlimitedChatsDesc => 'Consulente IA personale 24/7';

  @override
  String get fullHistory => 'Cronologia completa';

  @override
  String get fullHistoryDesc => 'Cronologia delle scansioni illimitata';

  @override
  String get rememberContext => 'Ricorda il contesto';

  @override
  String get rememberContextDesc => 'L\'IA ricorda i tuoi messaggi precedenti';

  @override
  String get allIngredientsInfo => 'Tutte le informazioni sugli ingredienti';

  @override
  String get allIngredientsInfoDesc => 'Scopri tutti i dettagli';

  @override
  String get noAds => '100% senza pubblicità';

  @override
  String get noAdsDesc => 'Per chi apprezza il proprio tempo';

  @override
  String get multiLanguage => 'Conosce quasi tutte le lingue del mondo';

  @override
  String get multiLanguageDesc => 'Traduttore migliorato';

  @override
  String get paywallTitle => 'Scopri i segreti dei tuoi cosmetici con l\'IA';

  @override
  String paywallDescription(String price) {
    return 'Hai l\'opportunità di ottenere un abbonamento Premium per 3 giorni gratuitamente, poi $price a settimana. Annulla in qualsiasi momento.';
  }

  @override
  String get whatsIncluded => 'Cosa è incluso';

  @override
  String get basicPlan => 'Base';

  @override
  String get premiumPlan => 'Premium';

  @override
  String get botGreeting1 => 'Buongiorno! Come posso aiutarti oggi?';

  @override
  String get botGreeting2 => 'Ciao! Cosa ti porta da me?';

  @override
  String get botGreeting3 => 'Ti saluto! Pronto ad aiutare con l\'analisi cosmetica.';

  @override
  String get botGreeting4 => 'Piacere di vederti! Come posso essere utile?';

  @override
  String get botGreeting5 => 'Benvenuto! Analizziamo insieme la composizione dei tuoi cosmetici.';

  @override
  String get botGreeting6 => 'Ciao! Pronto a rispondere alle tue domande sui cosmetici.';

  @override
  String get botGreeting7 => 'Ciao! Sono il tuo assistente personale di cosmetologia.';

  @override
  String get botGreeting8 => 'Buongiorno! Aiuterò a capire la composizione dei prodotti cosmetici.';

  @override
  String get botGreeting9 => 'Ciao! Rendiamo i tuoi cosmetici più sicuri insieme.';

  @override
  String get botGreeting10 => 'Ti saluto! Pronto a condividere conoscenze sui cosmetici.';

  @override
  String get botGreeting11 => 'Buongiorno! Aiuterò a trovare le migliori soluzioni cosmetiche per te.';

  @override
  String get botGreeting12 => 'Ciao! Il tuo esperto di sicurezza cosmetica è al tuo servizio.';

  @override
  String get botGreeting13 => 'Ciao! Scegliamo insieme i cosmetici perfetti per te.';

  @override
  String get botGreeting14 => 'Benvenuto! Pronto ad aiutare con l\'analisi degli ingredienti.';

  @override
  String get botGreeting15 => 'Ciao! Aiuterò a capire la composizione dei tuoi cosmetici.';

  @override
  String get botGreeting16 => 'Ti saluto! La tua guida nel mondo della cosmetologia è pronta ad aiutare.';

  @override
  String get copiedToClipboard => 'Copiato negli appunti';

  @override
  String get tryFree => 'Prova Gratis';

  @override
  String get cameraNotReady => 'Fotocamera non pronta / nessun permesso';

  @override
  String get cameraPermissionInstructions => 'Impostazioni dell\'app:\nAI Cosmetic Scanner > Autorizzazioni > Fotocamera > Consenti';

  @override
  String get openSettingsAndGrantAccess => 'Apri Impostazioni e concedi l\'accesso alla fotocamera';

  @override
  String get retryCamera => 'Riprova';

  @override
  String get errorServiceOverloaded => 'Il servizio è temporaneamente occupato. Riprova tra un momento.';

  @override
  String get errorRateLimitExceeded => 'Troppe richieste. Attendi un momento e riprova.';

  @override
  String get errorTimeout => 'Timeout della richiesta. Controlla la connessione Internet e riprova.';

  @override
  String get errorNetwork => 'Errore di rete. Controlla la connessione Internet.';

  @override
  String get errorAuthentication => 'Errore di autenticazione. Riavvia l\'app.';

  @override
  String get errorInvalidResponse => 'Risposta non valida ricevuta. Riprova.';

  @override
  String get errorServer => 'Errore del server. Riprova più tardi.';

  @override
  String get customThemes => 'Temi Personalizzati';

  @override
  String get createCustomTheme => 'Crea Tema Personalizzato';

  @override
  String get basedOn => 'Basato su';

  @override
  String get lightMode => 'Chiaro';

  @override
  String get generateWithAI => 'Genera con IA';

  @override
  String get resetToBaseTheme => 'Ripristina al Tema Base';

  @override
  String colorsResetTo(Object themeName) {
    return 'Colori ripristinati a $themeName';
  }

  @override
  String get aiGenerationComingSoon => 'La generazione di temi con IA arriverà nell\'Iteration 5!';

  @override
  String get onboardingGreeting => 'Benvenuto! Per migliorare la qualità delle risposte, configuriamo il tuo profilo';

  @override
  String get letsGo => 'Andiamo';

  @override
  String get next => 'Avanti';

  @override
  String get finish => 'Fine';

  @override
  String get customThemeInDevelopment => 'La funzione dei temi personalizzati è in sviluppo';

  @override
  String get customThemeComingSoon => 'Prossimamente nei futuri aggiornamenti';

  @override
  String get dailyMessageLimitReached => 'Limite raggiunto';

  @override
  String get dailyMessageLimitReachedMessage => 'Hai inviato 5 messaggi oggi. Aggiorna a Premium per chat illimitato!';

  @override
  String get upgradeToPremiumForUnlimitedChat => 'Aggiorna a Premium per chat illimitato';

  @override
  String get messagesLeftToday => 'messaggi rimasti oggi';

  @override
  String get designYourOwnTheme => 'Progetta il tuo tema personale';

  @override
  String get darkOcean => 'Oceano Scuro';

  @override
  String get darkForest => 'Foresta Scura';

  @override
  String get darkSunset => 'Tramonto Scuro';

  @override
  String get darkVibrant => 'Vibrante Scuro';

  @override
  String get darkOceanThemeDescription => 'Tema scuro dell\'oceano con accenti ciano';

  @override
  String get darkForestThemeDescription => 'Tema scuro della foresta con accenti verde lime';

  @override
  String get darkSunsetThemeDescription => 'Tema scuro del tramonto con accenti arancioni';

  @override
  String get darkVibrantThemeDescription => 'Tema scuro vibrante con accenti rosa e viola';

  @override
  String get customTheme => 'Tema personalizzato';

  @override
  String get edit => 'Modifica';

  @override
  String get deleteTheme => 'Elimina Tema';

  @override
  String deleteThemeConfirmation(String themeName) {
    return 'Sei sicuro di voler eliminare \"$themeName\"?';
  }

  @override
  String get pollTitle => 'Cosa manca?';

  @override
  String get pollCardTitle => 'Cosa manca nell\'app?';

  @override
  String get pollDescription => 'Vota per le opzioni che vuoi vedere';

  @override
  String get submitVote => 'Vota';

  @override
  String get submitting => 'Invio in corso...';

  @override
  String get voteSubmittedSuccess => 'Voti inviati con successo!';

  @override
  String votesRemaining(int count) {
    return '$count voti rimanenti';
  }

  @override
  String get votes => 'voti';

  @override
  String get addYourOption => 'Proporre miglioramento';

  @override
  String get enterYourOption => 'Inserisci la tua opzione...';

  @override
  String get add => 'Aggiungi';

  @override
  String get filterTopVoted => 'Popolare';

  @override
  String get filterNewest => 'Nuovo';

  @override
  String get filterMyOption => 'La mia scelta';

  @override
  String get thankYouForVoting => 'Grazie per aver votato!';

  @override
  String get votingComplete => 'Il tuo voto è stato registrato';

  @override
  String get requestFeatureDevelopment => 'Richiedi Sviluppo Funzionalità Personalizzata';

  @override
  String get requestFeatureDescription => 'Hai bisogno di una funzionalità specifica? Contattaci per discutere lo sviluppo personalizzato per le esigenze della tua azienda.';

  @override
  String get pollHelpTitle => 'Come votare';

  @override
  String get pollHelpDescription => '• Tocca un\'opzione per selezionarla\n• Tocca di nuovo per deselezionare\n• Seleziona tutte le opzioni che desideri\n• Clicca su \'Vota\' per inviare i tuoi voti\n• Aggiungi la tua opzione se non trovi quello che ti serve';

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
