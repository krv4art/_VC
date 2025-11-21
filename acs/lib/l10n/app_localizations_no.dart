// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Norwegian (`no`).
class AppLocalizationsNo extends AppLocalizations {
  AppLocalizationsNo([String locale = 'no']) : super(locale);

  @override
  String get appName => 'AI Kosmetikk-skanner';

  @override
  String get skinAnalysis => 'Hudanalyse';

  @override
  String get checkYourCosmetics => 'Sjekk kosmetikken din';

  @override
  String get startScanning => 'Start Skanning';

  @override
  String get quickActions => 'Hurtighandlinger';

  @override
  String get scanHistory => 'Skannehistorikk';

  @override
  String get aiChat => 'AI Kosmetikk-skanner';

  @override
  String get profile => 'Profil';

  @override
  String get settings => 'Innstillinger';

  @override
  String get skinType => 'Hudtype';

  @override
  String get allergiesSensitivities => 'Allergier og Følsomheter';

  @override
  String get subscription => 'Abonnement';

  @override
  String get age => 'Alder';

  @override
  String get language => 'Språk';

  @override
  String get selectYourPreferredLanguage => 'Velg ditt foretrukne språk';

  @override
  String get save => 'Lagre';

  @override
  String get selectIngredientsAllergicSensitive => 'Velg ingredienser du er følsom for';

  @override
  String get commonAllergens => 'Vanlige Allergener';

  @override
  String get fragrance => 'Parfyme';

  @override
  String get parabens => 'Parabener';

  @override
  String get sulfates => 'Sulfater';

  @override
  String get alcohol => 'Alkohol';

  @override
  String get essentialOils => 'Essensielle Oljer';

  @override
  String get silicones => 'Silikoner';

  @override
  String get mineralOil => 'Mineralolje';

  @override
  String get formaldehyde => 'Formaldehyd';

  @override
  String get addCustomAllergen => 'Legg til Egendefinert Allergen';

  @override
  String get typeIngredientName => 'Skriv inn ingrediensnavn...';

  @override
  String get selectedAllergens => 'Valgte Allergener';

  @override
  String saveSelected(int count) {
    return 'Lagre ($count valgt)';
  }

  @override
  String get analysisResults => 'Analyseresultater';

  @override
  String get overallSafetyScore => 'Samlet Sikkerhetsscore';

  @override
  String get personalizedWarnings => 'Personlige Advarsler';

  @override
  String ingredientsAnalysis(int count) {
    return 'Ingrediensanalyse ($count)';
  }

  @override
  String get highRisk => 'Høy Risiko';

  @override
  String get moderateRisk => 'Moderat Risiko';

  @override
  String get lowRisk => 'Lav Risiko';

  @override
  String get benefitsAnalysis => 'Fordelsanalyse';

  @override
  String get recommendedAlternatives => 'Anbefalte Alternativer';

  @override
  String get reason => 'Grunn:';

  @override
  String get quickSummary => 'Hurtigsammendrag';

  @override
  String get ingredientsChecked => 'ingredienser sjekket';

  @override
  String get personalWarnings => 'personlige advarsler';

  @override
  String get ourVerdict => 'Vår Vurdering';

  @override
  String get productInfo => 'Produktinformasjon';

  @override
  String get productType => 'Produkttype';

  @override
  String get brand => 'Merke';

  @override
  String get premiumInsights => 'Premium Innsikt';

  @override
  String get researchArticles => 'Forskningsartikler';

  @override
  String get categoryRanking => 'Kategorirangering';

  @override
  String get safetyTrend => 'Sikkerhetstrend';

  @override
  String get saveToFavorites => 'Lagre';

  @override
  String get shareResults => 'Del';

  @override
  String get compareProducts => 'Sammenlign';

  @override
  String get exportPDF => 'PDF';

  @override
  String get scanSimilar => 'Lignende';

  @override
  String get aiChatTitle => 'AI Kosmetikk-skanner';

  @override
  String get typeYourMessage => 'Skriv inn meldingen din...';

  @override
  String get errorSupabaseClientNotInitialized => 'Feil: Supabase-klient ikke initialisert.';

  @override
  String get serverError => 'Serverfeil:';

  @override
  String get networkErrorOccurred => 'Nettverksfeil oppstod. Vennligst prøv igjen senere.';

  @override
  String get sorryAnErrorOccurred => 'Beklager, en feil oppstod. Vennligst prøv igjen.';

  @override
  String get couldNotGetResponse => 'Kunne ikke få respons.';

  @override
  String get aiAssistant => 'AI Assistent';

  @override
  String get online => 'Online';

  @override
  String get typing => 'Skriver...';

  @override
  String get writeAMessage => 'Skriv en melding...';

  @override
  String get hiIAmYourAIAssistantHowCanIHelp => 'Hei! Jeg er din AI-assistent. Hvordan kan jeg hjelpe deg?';

  @override
  String get iCanSeeYourScanResultsFeelFreeToAskMeAnyQuestionsAboutTheIngredientsSafetyConcernsOrRecommendations => 'Jeg kan se skanneresultatene dine! Still gjerne spørsmål om ingredienser, sikkerhetsbekymringer eller anbefalinger.';

  @override
  String get userQuestion => 'Brukerspørsmål:';

  @override
  String get databaseExplorer => 'Database Utforsker';

  @override
  String get currentUser => 'Nåværende Bruker:';

  @override
  String get notSignedIn => 'Ikke pålogget';

  @override
  String get failedToFetchTables => 'Kunne ikke hente tabeller:';

  @override
  String get tablesInYourSupabaseDatabase => 'Tabeller i din Supabase-database:';

  @override
  String get viewSampleData => 'Vis Eksempeldata';

  @override
  String get failedToFetchSampleDataFor => 'Kunne ikke hente eksempeldata for';

  @override
  String get sampleData => 'Eksempeldata:';

  @override
  String get aiChats => 'AI-samtaler';

  @override
  String get noDialoguesYet => 'Ingen dialoger ennå.';

  @override
  String get startANewChat => 'Start en ny chat!';

  @override
  String get created => 'Opprettet:';

  @override
  String get failedToSaveImage => 'Kunne ikke lagre bilde:';

  @override
  String get editName => 'Rediger Navn';

  @override
  String get enterYourName => 'Skriv inn navnet ditt';

  @override
  String get cancel => 'Avbryt';

  @override
  String get premiumUser => 'Premium Bruker';

  @override
  String get freeUser => 'Gratis Bruker';

  @override
  String get skinProfile => 'Hudprofil';

  @override
  String get notSet => 'Ikke angitt';

  @override
  String get legal => 'Juridisk';

  @override
  String get privacyPolicy => 'Personvernregler';

  @override
  String get termsOfService => 'Vilkår for bruk';

  @override
  String get dataManagement => 'Databehandling';

  @override
  String get clearAllData => 'Slett Alle Data';

  @override
  String get clearAllDataConfirmation => 'Er du sikker på at du vil slette alle dine lokale data? Denne handlingen kan ikke angres.';

  @override
  String get selectDataToClear => 'Velg data som skal slettes';

  @override
  String get scanResults => 'Skanneresultater';

  @override
  String get chatHistory => 'Chatter';

  @override
  String get personalData => 'Personlige Data';

  @override
  String get clearData => 'Slett Data';

  @override
  String get allLocalDataHasBeenCleared => 'Data er slettet.';

  @override
  String get signOut => 'Logg ut';

  @override
  String get deleteScan => 'Slett Skanning';

  @override
  String get deleteScanConfirmation => 'Er du sikker på at du vil slette denne skanningen fra historikken?';

  @override
  String get deleteChat => 'Slett Chat';

  @override
  String get deleteChatConfirmation => 'Er du sikker på at du vil slette denne chatten? Alle meldinger vil gå tapt.';

  @override
  String get delete => 'Slett';

  @override
  String get noScanHistoryFound => 'Ingen skannehistorikk funnet.';

  @override
  String get scanOn => 'Skanning den';

  @override
  String get ingredientsFound => 'ingredienser funnet';

  @override
  String get noCamerasFoundOnThisDevice => 'Ingen kameraer funnet på denne enheten.';

  @override
  String get failedToInitializeCamera => 'Kunne ikke initialisere kamera:';

  @override
  String get analysisFailed => 'Analyse mislyktes:';

  @override
  String get analyzingPleaseWait => 'Analyserer, vennligst vent...';

  @override
  String get positionTheLabelWithinTheFrame => 'Fokuser kameraet på ingredienslisten';

  @override
  String get createAccount => 'Opprett Konto';

  @override
  String get signUpToGetStarted => 'Registrer deg for å komme i gang';

  @override
  String get fullName => 'Fullt Navn';

  @override
  String get pleaseEnterYourName => 'Vennligst skriv inn navnet ditt';

  @override
  String get email => 'E-post';

  @override
  String get pleaseEnterYourEmail => 'Vennligst skriv inn e-postadressen din';

  @override
  String get pleaseEnterAValidEmail => 'Vennligst skriv inn en gyldig e-postadresse';

  @override
  String get password => 'Passord';

  @override
  String get pleaseEnterYourPassword => 'Vennligst skriv inn passordet ditt';

  @override
  String get passwordMustBeAtLeast6Characters => 'Passordet må være minst 6 tegn';

  @override
  String get signUp => 'Registrer deg';

  @override
  String get orContinueWith => 'eller fortsett med';

  @override
  String get google => 'Google';

  @override
  String get apple => 'Apple';

  @override
  String get alreadyHaveAnAccount => 'Har du allerede en konto? ';

  @override
  String get signIn => 'Logg inn';

  @override
  String get selectYourSkinTypeDescription => 'Velg din hudtype';

  @override
  String get normal => 'Normal';

  @override
  String get normalSkinDescription => 'Balansert, ikke for fet eller tørr';

  @override
  String get dry => 'Tørr';

  @override
  String get drySkinDescription => 'Stram, flassete, grov tekstur';

  @override
  String get oily => 'Fet';

  @override
  String get oilySkinDescription => 'Blank, store porer, utsatt for akne';

  @override
  String get combination => 'Kombinert';

  @override
  String get combinationSkinDescription => 'Fet T-sone, tørre kinn';

  @override
  String get sensitive => 'Sensitiv';

  @override
  String get sensitiveSkinDescription => 'Lett irritert, utsatt for rødhet';

  @override
  String get selectSkinType => 'Velg hudtype';

  @override
  String get restore => 'Gjenopprett';

  @override
  String get restorePurchases => 'Gjenopprett Kjøp';

  @override
  String get subscriptionRestored => 'Abonnement gjenopprettet!';

  @override
  String get noPurchasesToRestore => 'Ingen kjøp å gjenopprette';

  @override
  String get goPremium => 'Oppgrader til Premium';

  @override
  String get unlockExclusiveFeatures => 'Lås opp eksklusive funksjoner for å få mest mulig ut av hudanalysen din.';

  @override
  String get unlimitedProductScans => 'Ubegrensede produktskanninger';

  @override
  String get advancedAIIngredientAnalysis => 'Avansert AI Ingrediensanalyse';

  @override
  String get fullScanAndSearchHistory => 'Fullstendig Skanne- og Søkehistorikk';

  @override
  String get adFreeExperience => '100% Reklamefri Opplevelse';

  @override
  String get yearly => 'Årlig';

  @override
  String savePercentage(int percentage) {
    return 'Spar $percentage%';
  }

  @override
  String get monthly => 'Månedlig';

  @override
  String get perMonth => '/ måned';

  @override
  String get startFreeTrial => 'Start Gratis Prøveperiode';

  @override
  String trialDescription(String planName) {
    return '7 dagers gratis prøveperiode, deretter $planName. Kan avbrytes når som helst.';
  }

  @override
  String get home => 'Hjem';

  @override
  String get scan => 'Skanner';

  @override
  String get aiChatNav => 'Konsulent';

  @override
  String get profileNav => 'Profil';

  @override
  String get doYouEnjoyOurApp => 'Liker du appen vår?';

  @override
  String get notReally => 'Nei';

  @override
  String get yesItsGreat => 'Jeg liker den';

  @override
  String get rateOurApp => 'Vurder appen vår';

  @override
  String get bestRatingWeCanGet => 'Beste vurdering vi kan få';

  @override
  String get rateOnGooglePlay => 'Vurder på Google Play';

  @override
  String get rate => 'Vurder';

  @override
  String get whatCanBeImproved => 'Hva kan forbedres?';

  @override
  String get wereSorryYouDidntHaveAGreatExperience => 'Vi beklager at du ikke hadde en god opplevelse. Vennligst fortell oss hva som gikk galt.';

  @override
  String get yourFeedback => 'Din tilbakemelding...';

  @override
  String get sendFeedback => 'Send Tilbakemelding';

  @override
  String get thankYouForYourFeedback => 'Takk for tilbakemeldingen!';

  @override
  String get discussWithAI => 'Diskuter med AI';

  @override
  String get enterYourEmail => 'Skriv inn e-postadressen din';

  @override
  String get enterYourPassword => 'Skriv inn passordet ditt';

  @override
  String get aiDisclaimer => 'AI-svar kan inneholde unøyaktigheter. Vennligst verifiser kritisk informasjon.';

  @override
  String get applicationThemes => 'Applikasjonstemaer';

  @override
  String get highestRating => 'Høyeste Vurdering';

  @override
  String get selectYourAgeDescription => 'Velg din alder';

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
  String get ageRange18_25Description => 'Ung hud, forebygging';

  @override
  String get ageRange26_35Description => 'Første tegn på aldring';

  @override
  String get ageRange36_45Description => 'Anti-aldring behandling';

  @override
  String get ageRange46_55Description => 'Intensiv behandling';

  @override
  String get ageRange56PlusDescription => 'Spesialisert behandling';

  @override
  String get userName => 'Ditt Navn';

  @override
  String get yourName => 'Your Name';

  @override
  String get tryFreeAndSubscribe => 'Prøv Gratis og Abonner';

  @override
  String get personalAIConsultant => 'Personlig AI-konsulent 24/7';

  @override
  String get subscribe => 'Abonner';

  @override
  String get themes => 'Temaer';

  @override
  String get selectPreferredTheme => 'Velg ditt foretrukne tema';

  @override
  String get naturalTheme => 'Naturlig';

  @override
  String get darkTheme => 'Mørk';

  @override
  String get darkNatural => 'Mørk Naturlig';

  @override
  String get oceanTheme => 'Hav';

  @override
  String get forestTheme => 'Skog';

  @override
  String get sunsetTheme => 'Solnedgang';

  @override
  String get naturalThemeDescription => 'Naturlig tema med miljøvennlige farger';

  @override
  String get darkThemeDescription => 'Mørkt tema for øyekomfort';

  @override
  String get oceanThemeDescription => 'Friskt havtema';

  @override
  String get forestThemeDescription => 'Naturlig skogtema';

  @override
  String get sunsetThemeDescription => 'Varmt solnedgangstema';

  @override
  String get sunnyTheme => 'Solfylt';

  @override
  String get sunnyThemeDescription => 'Lyst og munter gult tema';

  @override
  String get vibrantTheme => 'Levende';

  @override
  String get vibrantThemeDescription => 'Lyst rosa og lilla tema';

  @override
  String get scanAnalysis => 'Skanneanalyse';

  @override
  String get ingredients => 'ingredienser';

  @override
  String get aiBotSettings => 'AI Innstillinger';

  @override
  String get botName => 'Bot Navn';

  @override
  String get enterBotName => 'Skriv inn botnavn';

  @override
  String get pleaseEnterBotName => 'Vennligst skriv inn et botnavn';

  @override
  String get botDescription => 'Bot Beskrivelse';

  @override
  String get selectAvatar => 'Velg Avatar';

  @override
  String get defaultBotName => 'ACS';

  @override
  String defaultBotDescription(String name) {
    return 'Hei! Jeg er $name (AI Kosmetikk-skanner). Jeg vil hjelpe deg med å forstå sammensetningen av kosmetikken din. Jeg har omfattende kunnskap innen kosmetologi og hudpleie. Jeg vil gjerne svare på alle spørsmålene dine.';
  }

  @override
  String get settingsSaved => 'Innstillinger lagret';

  @override
  String get failedToSaveSettings => 'Kunne ikke lagre innstillinger';

  @override
  String get resetToDefault => 'Tilbakestill til Standard';

  @override
  String get resetSettings => 'Tilbakestill Innstillinger';

  @override
  String get resetSettingsConfirmation => 'Er du sikker på at du vil tilbakestille alle innstillinger til standardverdier?';

  @override
  String get settingsResetSuccessfully => 'Innstillinger tilbakestilt';

  @override
  String get failedToResetSettings => 'Kunne ikke tilbakestille innstillinger';

  @override
  String get unsavedChanges => 'Ulagrede Endringer';

  @override
  String get unsavedChangesMessage => 'Du har ulagrede endringer. Er du sikker på at du vil forlate?';

  @override
  String get stay => 'Bli';

  @override
  String get leave => 'Forlat';

  @override
  String get errorLoadingSettings => 'Feil ved lasting av innstillinger';

  @override
  String get retry => 'Prøv Igjen';

  @override
  String get customPrompt => 'Spesielle Forespørsler';

  @override
  String get customPromptDescription => 'Legg til personlige instruksjoner for AI-assistenten';

  @override
  String get customPromptPlaceholder => 'Skriv inn dine spesielle forespørsler...';

  @override
  String get enableCustomPrompt => 'Aktiver spesielle forespørsler';

  @override
  String get defaultCustomPrompt => 'Gi meg komplimenter.';

  @override
  String get close => 'Lukk';

  @override
  String get scanningHintTitle => 'Hvordan Skanne';

  @override
  String get scanLimitReached => 'Skannegrense Nådd';

  @override
  String get scanLimitReachedMessage => 'Du har brukt alle 5 gratis skanninger denne uken. Oppgrader til Premium for ubegrensede skanninger!';

  @override
  String get messageLimitReached => 'Daglig Meldingsgrense Nådd';

  @override
  String get messageLimitReachedMessage => 'Du har sendt 5 meldinger i dag. Oppgrader til Premium for ubegrenset chat!';

  @override
  String get historyLimitReached => 'Historikktilgang Begrenset';

  @override
  String get historyLimitReachedMessage => 'Oppgrader til Premium for tilgang til full skannehistorikk!';

  @override
  String get upgradeToPremium => 'Oppgrader til Premium';

  @override
  String get upgradeToView => 'Oppgrader for å Se';

  @override
  String get upgradeToChat => 'Oppgrader for å Chatte';

  @override
  String get premiumFeature => 'Premium Funksjon';

  @override
  String get freePlanUsage => 'Gratis Plan Bruk';

  @override
  String get scansThisWeek => 'Skanninger denne uken';

  @override
  String get messagesToday => 'Meldinger i dag';

  @override
  String get limitsReached => 'Grenser nådd';

  @override
  String get remainingScans => 'Gjenstående skanninger';

  @override
  String get remainingMessages => 'Gjenstående meldinger';

  @override
  String get usageLimitsBadge => 'Begrensninger for gratisversjonen';

  @override
  String get unlockUnlimitedAccess => 'Lås Opp Ubegrenset Tilgang';

  @override
  String get upgradeToPremiumDescription => 'Få ubegrensede skanninger, meldinger og full tilgang til skannehistorikken din med Premium!';

  @override
  String get premiumBenefits => 'Premium Fordeler';

  @override
  String get subscriptionBenefitsTitle => 'Lås opp Premium-funksjoner';

  @override
  String get subscriptionBenefitsDescription => 'Oppgrader til Premium og få ubegrenset tilgang til alle funksjoner';

  @override
  String get getSubscription => 'Få Premium';

  @override
  String get unlimitedAiChatMessages => 'Ubegrensede AI-chatmeldinger';

  @override
  String get fullAccessToScanHistory => 'Full tilgang til skannehistorikk';

  @override
  String get prioritySupport => 'Prioritetsstøtte';

  @override
  String get learnMore => 'Lær Mer';

  @override
  String get upgradeNow => 'Oppgrader Nå';

  @override
  String get maybeLater => 'Kanskje Senere';

  @override
  String get scanHistoryLimit => 'Bare den siste skanningen er synlig i historikk';

  @override
  String get upgradeForUnlimitedScans => 'Oppgrader for ubegrensede skanninger!';

  @override
  String get upgradeForUnlimitedChat => 'Oppgrader for ubegrenset chat!';

  @override
  String get slowInternetConnection => 'Treg Internettforbindelse';

  @override
  String get slowInternetMessage => 'Med en veldig treg internettforbindelse må du vente litt... Vi analyserer fortsatt bildet ditt.';

  @override
  String get revolutionaryAI => 'Revolusjonerende AI';

  @override
  String get revolutionaryAIDesc => 'En av de smarteste i verden';

  @override
  String get unlimitedScans => 'Ubegrensede Skanninger';

  @override
  String get unlimitedScansDesc => 'Utforsk kosmetikk uten grenser';

  @override
  String get unlimitedChats => 'Ubegrensede Chatter';

  @override
  String get unlimitedChatsDesc => 'Personlig AI-konsulent 24/7';

  @override
  String get fullHistory => 'Full Historikk';

  @override
  String get fullHistoryDesc => 'Ubegrenset skannehistorikk';

  @override
  String get rememberContext => 'Husker Kontekst';

  @override
  String get rememberContextDesc => 'AI husker dine tidligere meldinger';

  @override
  String get allIngredientsInfo => 'All Ingrediensinformasjon';

  @override
  String get allIngredientsInfoDesc => 'Lær alle detaljene';

  @override
  String get noAds => '100% Reklamefri';

  @override
  String get noAdsDesc => 'For de som verdsetter tiden sin';

  @override
  String get multiLanguage => 'Kan Nesten Alle Språk';

  @override
  String get multiLanguageDesc => 'Forbedret oversetter';

  @override
  String get paywallTitle => 'Lås opp hemmelighetene til kosmetikken din med AI';

  @override
  String paywallDescription(String price) {
    return 'Du har muligheten til å få Premium-abonnement gratis i 3 dager, deretter $price per uke. Kan avbrytes når som helst.';
  }

  @override
  String get whatsIncluded => 'Hva er Inkludert';

  @override
  String get basicPlan => 'Basis';

  @override
  String get premiumPlan => 'Premium';

  @override
  String get botGreeting1 => 'God dag! Hvordan kan jeg hjelpe deg i dag?';

  @override
  String get botGreeting2 => 'Hei! Hva bringer deg til meg?';

  @override
  String get botGreeting3 => 'Velkommen! Klar til å hjelpe med kosmetikkanalyse.';

  @override
  String get botGreeting4 => 'Glad for å se deg! Hvordan kan jeg være nyttig?';

  @override
  String get botGreeting5 => 'Velkommen! La oss utforske sammensetningen av kosmetikken din sammen.';

  @override
  String get botGreeting6 => 'Hei! Klar til å svare på spørsmålene dine om kosmetikk.';

  @override
  String get botGreeting7 => 'Hei! Jeg er din personlige kosmetologiassistent.';

  @override
  String get botGreeting8 => 'God dag! Jeg vil hjelpe deg med å forstå sammensetningen av kosmetiske produkter.';

  @override
  String get botGreeting9 => 'Hei! La oss gjøre kosmetikken din tryggere sammen.';

  @override
  String get botGreeting10 => 'Velkommen! Klar til å dele kunnskap om kosmetikk.';

  @override
  String get botGreeting11 => 'God dag! Jeg vil hjelpe deg med å finne de beste kosmetiske løsningene for deg.';

  @override
  String get botGreeting12 => 'Hei! Din ekspert på kosmetikksikkerhet til tjeneste.';

  @override
  String get botGreeting13 => 'Hei! La oss velge den perfekte kosmetikken for deg sammen.';

  @override
  String get botGreeting14 => 'Velkommen! Klar til å hjelpe med ingrediensanalyse.';

  @override
  String get botGreeting15 => 'Hei! Jeg vil hjelpe deg med å forstå sammensetningen av kosmetikken din.';

  @override
  String get botGreeting16 => 'Velkommen! Din guide i kosmetologiens verden er klar til å hjelpe.';

  @override
  String get copiedToClipboard => 'Kopiert til utklippstavlen';

  @override
  String get tryFree => 'Prøv Gratis';

  @override
  String get cameraNotReady => 'Kamera ikke klar / ingen tillatelse';

  @override
  String get cameraPermissionInstructions => 'App-innstillinger:\nAI Kosmetikk-skanner > Tillatelser > Kamera > Tillat';

  @override
  String get openSettingsAndGrantAccess => 'Åpne Innstillinger og gi kameratilgang';

  @override
  String get retryCamera => 'Prøv Igjen';

  @override
  String get errorServiceOverloaded => 'Tjenesten er midlertidig opptatt. Vennligst prøv igjen om et øyeblikk.';

  @override
  String get errorRateLimitExceeded => 'For mange forespørsler. Vennligst vent et øyeblikk og prøv igjen.';

  @override
  String get errorTimeout => 'Forespørsel gikk ut. Vennligst sjekk internettforbindelsen din og prøv igjen.';

  @override
  String get errorNetwork => 'Nettverksfeil. Vennligst sjekk internettforbindelsen din.';

  @override
  String get errorAuthentication => 'Autentiseringsfeil. Vennligst start appen på nytt.';

  @override
  String get errorInvalidResponse => 'Ugyldig respons mottatt. Vennligst prøv igjen.';

  @override
  String get errorServer => 'Serverfeil. Vennligst prøv igjen senere.';

  @override
  String get customThemes => 'Egendefinerte Temaer';

  @override
  String get createCustomTheme => 'Lag Egendefinert Tema';

  @override
  String get basedOn => 'Basert på';

  @override
  String get lightMode => 'Lys';

  @override
  String get generateWithAI => 'Generer med AI';

  @override
  String get resetToBaseTheme => 'Tilbakestill til Grunnleggende Tema';

  @override
  String colorsResetTo(Object themeName) {
    return 'Farger tilbakestilt til $themeName';
  }

  @override
  String get aiGenerationComingSoon => 'AI-temagenerering kommer i Iterasjon 5!';

  @override
  String get onboardingGreeting => 'Velkommen! For å forbedre kvaliteten på svarene, la oss sette opp profilen din';

  @override
  String get letsGo => 'La Oss Gå';

  @override
  String get next => 'Neste';

  @override
  String get finish => 'Fullfør';

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
  String get customThemeInDevelopment => 'Egendefinerte temaer er under utvikling';

  @override
  String get customThemeComingSoon => 'Kommer snart i fremtidige oppdateringer';

  @override
  String get dailyMessageLimitReached => 'Grense Nådd';

  @override
  String get dailyMessageLimitReachedMessage => 'Du har sendt 5 meldinger i dag. Oppgrader til Premium for ubegrenset chat!';

  @override
  String get upgradeToPremiumForUnlimitedChat => 'Oppgrader til Premium for ubegrenset chat';

  @override
  String get messagesLeftToday => 'meldinger igjen i dag';

  @override
  String get designYourOwnTheme => 'Design ditt eget tema';

  @override
  String get darkOcean => 'Mørkt Hav';

  @override
  String get darkForest => 'Mørk Skog';

  @override
  String get darkSunset => 'Mørk Solnedgang';

  @override
  String get darkVibrant => 'Mørk Levende';

  @override
  String get darkOceanThemeDescription => 'Mørkt havtema med cyan-accenter';

  @override
  String get darkForestThemeDescription => 'Mørkt skogtema med limegrønne accenter';

  @override
  String get darkSunsetThemeDescription => 'Mørkt solnedgangstema med oransje accenter';

  @override
  String get darkVibrantThemeDescription => 'Mørkt levende tema med rosa og lilla accenter';

  @override
  String get customTheme => 'Egendefinert tema';

  @override
  String get edit => 'Rediger';

  @override
  String get deleteTheme => 'Slett Tema';

  @override
  String deleteThemeConfirmation(String themeName) {
    return 'Er du sikker på at du vil slette \"$themeName\"?';
  }

  @override
  String get pollTitle => 'Hva mangler?';

  @override
  String get pollCardTitle => 'Hva mangler i appen?';

  @override
  String get pollDescription => 'Stem på alternativene du vil se';

  @override
  String get submitVote => 'Stem';

  @override
  String get submitting => 'Sender inn...';

  @override
  String get voteSubmittedSuccess => 'Stemmer sendt inn!';

  @override
  String votesRemaining(int count) {
    return '$count stemmer igjen';
  }

  @override
  String get votes => 'stemmer';

  @override
  String get addYourOption => 'Foreslå forbedring';

  @override
  String get enterYourOption => 'Skriv inn ditt alternativ...';

  @override
  String get add => 'Legg til';

  @override
  String get filterTopVoted => 'Populær';

  @override
  String get filterNewest => 'Ny';

  @override
  String get filterMyOption => 'Mitt Valg';

  @override
  String get thankYouForVoting => 'Takk for at du stemte!';

  @override
  String get votingComplete => 'Stemmen din er registrert';

  @override
  String get requestFeatureDevelopment => 'Forespør Egendefinert Funksjonsutvikling';

  @override
  String get requestFeatureDescription => 'Trenger du en spesifikk funksjon? Kontakt oss for å diskutere tilpasset utvikling for dine forretningsbehov.';

  @override
  String get pollHelpTitle => 'Hvordan stemme';

  @override
  String get pollHelpDescription => '• Trykk på et alternativ for å velge det\n• Trykk igjen for å oppheve valget\n• Velg så mange alternativer du vil\n• Klikk på \'Stem\'-knappen for å sende inn stemmene dine\n• Legg til ditt eget alternativ hvis du ikke ser det du trenger';

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
