// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Finnish (`fi`).
class AppLocalizationsFi extends AppLocalizations {
  AppLocalizationsFi([String locale = 'fi']) : super(locale);

  @override
  String get appName => 'AI Cosmetic Scanner';

  @override
  String get skinAnalysis => 'Ihon analyysi';

  @override
  String get checkYourCosmetics => 'Tarkista kosmetiikkasi';

  @override
  String get startScanning => 'Aloita skannaus';

  @override
  String get quickActions => 'Pikatoiminnot';

  @override
  String get scanHistory => 'Skannaushistoria';

  @override
  String get aiChat => 'AI-keskustelu';

  @override
  String get profile => 'Profiili';

  @override
  String get settings => 'Asetukset';

  @override
  String get skinType => 'Ihotyyppi';

  @override
  String get allergiesSensitivities => 'Allergiat ja herkkyys';

  @override
  String get subscription => 'Tilaus';

  @override
  String get age => 'Ikä';

  @override
  String get language => 'Kieli';

  @override
  String get selectYourPreferredLanguage => 'Valitse haluamasi kieli';

  @override
  String get save => 'Tallenna';

  @override
  String get selectIngredientsAllergicSensitive => 'Valitse aineosat, joille olet erityisen herkkä';

  @override
  String get commonAllergens => 'Yleiset allergeenit';

  @override
  String get fragrance => 'Tuoksu';

  @override
  String get parabens => 'Parabeenit';

  @override
  String get sulfates => 'Sulfaatit';

  @override
  String get alcohol => 'Alkoholi';

  @override
  String get essentialOils => 'Eteriset öljyt';

  @override
  String get silicones => 'Silikonit';

  @override
  String get mineralOil => 'Mineraaliöljy';

  @override
  String get formaldehyde => 'Formaldehydi';

  @override
  String get addCustomAllergen => 'Lisää oma allergeeni';

  @override
  String get typeIngredientName => 'Kirjoita ainesosan nimi...';

  @override
  String get selectedAllergens => 'Valitut allergeenit';

  @override
  String saveSelected(int count) {
    return 'Tallenna ($count valittu)';
  }

  @override
  String get analysisResults => 'Analyysitulokset';

  @override
  String get overallSafetyScore => 'Yleinen turvallisuuspistemäärä';

  @override
  String get personalizedWarnings => 'Henkilökohtaiset varoitukset';

  @override
  String ingredientsAnalysis(int count) {
    return 'Ainesosien analyysi ($count)';
  }

  @override
  String get highRisk => 'Korkea riski';

  @override
  String get moderateRisk => 'Kohtalainen riski';

  @override
  String get lowRisk => 'Matala riski';

  @override
  String get benefitsAnalysis => 'Hyötyjen analyysi';

  @override
  String get recommendedAlternatives => 'Suositellut vaihtoehdot';

  @override
  String get reason => 'Syy:';

  @override
  String get quickSummary => 'Pikayhteenveto';

  @override
  String get ingredientsChecked => 'ainesosaa tarkistettu';

  @override
  String get personalWarnings => 'henkilökohtaista varoitusta';

  @override
  String get ourVerdict => 'Arvio';

  @override
  String get productInfo => 'Tuotetiedot';

  @override
  String get productType => 'Tuotetyyppi';

  @override
  String get brand => 'Merkki';

  @override
  String get premiumInsights => 'Premium-tiedot';

  @override
  String get researchArticles => 'Tutkimusartikkelit';

  @override
  String get categoryRanking => 'Kategoria-asema';

  @override
  String get safetyTrend => 'Turvallisuustrendi';

  @override
  String get saveToFavorites => 'Tallenna';

  @override
  String get shareResults => 'Jaa';

  @override
  String get compareProducts => 'Vertaa';

  @override
  String get exportPDF => 'PDF';

  @override
  String get scanSimilar => 'Samankaltainen';

  @override
  String get aiChatTitle => 'AI-keskustelu';

  @override
  String get typeYourMessage => 'Kirjoita viesti...';

  @override
  String get errorSupabaseClientNotInitialized => 'Virhe: Supabase-asiakasta ei ole alustettu.';

  @override
  String get serverError => 'Palvelinvirhe:';

  @override
  String get networkErrorOccurred => 'Verkkovirhe. Yritä myöhemmin uudelleen.';

  @override
  String get sorryAnErrorOccurred => 'Tapahtui virhe. Yritä uudelleen.';

  @override
  String get couldNotGetResponse => 'Vastausta ei saatu.';

  @override
  String get aiAssistant => 'AI-avustaja';

  @override
  String get online => 'Paikalla';

  @override
  String get typing => 'Kirjoittaa...';

  @override
  String get writeAMessage => 'Kirjoita viesti...';

  @override
  String get hiIAmYourAIAssistantHowCanIHelp => 'Hei! Olen AI-avustajasi. Miten voin auttaa?';

  @override
  String get iCanSeeYourScanResultsFeelFreeToAskMeAnyQuestionsAboutTheIngredientsSafetyConcernsOrRecommendations => 'Näen skannauksen tulokset! Kysy rohkeasti ainesosista, turvallisuushuolista tai suosituksista.';

  @override
  String get userQuestion => 'Käyttäjän kysymys:';

  @override
  String get databaseExplorer => 'Tietokantatutkija';

  @override
  String get currentUser => 'Nykyinen käyttäjä:';

  @override
  String get notSignedIn => 'Ei kirjautuneena';

  @override
  String get failedToFetchTables => 'Taulukoiden haku epäonnistui:';

  @override
  String get tablesInYourSupabaseDatabase => 'Taulukot Supabase-tietokannassasi:';

  @override
  String get viewSampleData => 'Näytä esimerkkidata';

  @override
  String get failedToFetchSampleDataFor => 'Esimerkkidatan haku epäonnistui:';

  @override
  String get sampleData => 'Esimerkkidata:';

  @override
  String get aiChats => 'AI-keskustelut';

  @override
  String get noDialoguesYet => 'Ei vielä keskusteluja.';

  @override
  String get startANewChat => 'Aloita uusi keskustelu!';

  @override
  String get created => 'Luotu:';

  @override
  String get failedToSaveImage => 'Kuvan tallennus epäonnistui:';

  @override
  String get editName => 'Muokkaa nimeä';

  @override
  String get enterYourName => 'Syötä nimesi';

  @override
  String get cancel => 'Peruuta';

  @override
  String get premiumUser => 'Premium-käyttäjä';

  @override
  String get freeUser => 'Ilmaiskäyttäjä';

  @override
  String get skinProfile => 'Ihoprofiili';

  @override
  String get notSet => 'Ei asetettu';

  @override
  String get legal => 'Juridiset tiedot';

  @override
  String get privacyPolicy => 'Tietosuojakäytäntö';

  @override
  String get termsOfService => 'Käyttöehdot';

  @override
  String get dataManagement => 'Tiedonhallinta';

  @override
  String get clearAllData => 'Tyhjennä kaikki tiedot';

  @override
  String get clearAllDataConfirmation => 'Haluatko varmasti poistaa kaikki paikalliset tiedot? Toimintoa ei voi perua.';

  @override
  String get selectDataToClear => 'Valitse tyhjennettävät tiedot';

  @override
  String get scanResults => 'Skannaukset';

  @override
  String get chatHistory => 'Keskustelut';

  @override
  String get personalData => 'Henkilötiedot';

  @override
  String get clearData => 'Tyhjennä tiedot';

  @override
  String get allLocalDataHasBeenCleared => 'Tiedot on tyhjennetty.';

  @override
  String get signOut => 'Kirjaudu ulos';

  @override
  String get deleteScan => 'Poista skannaus';

  @override
  String get deleteScanConfirmation => 'Haluatko varmasti poistaa tämän skannauksen historiasta?';

  @override
  String get deleteChat => 'Poista keskustelu';

  @override
  String get deleteChatConfirmation => 'Haluatko varmasti poistaa tämän keskustelun? Kaikki viestit menetetään.';

  @override
  String get delete => 'Poista';

  @override
  String get noScanHistoryFound => 'Skannaushistoriaa ei löytynyt.';

  @override
  String get scanOn => 'Skannaus';

  @override
  String get ingredientsFound => 'ainesosaa löytyi';

  @override
  String get noCamerasFoundOnThisDevice => 'Laitteesta ei löytynyt kameroita.';

  @override
  String get failedToInitializeCamera => 'Kameran alustus epäonnistui:';

  @override
  String get analysisFailed => 'Analyysi epäonnistui:';

  @override
  String get analyzingPleaseWait => 'Analysoidaan, odota...';

  @override
  String get positionTheLabelWithinTheFrame => 'Kohdista kamera ainesosaluetteloon';

  @override
  String get createAccount => 'Luo tili';

  @override
  String get signUpToGetStarted => 'Rekisteröidy aloittaaksesi';

  @override
  String get fullName => 'Koko nimi';

  @override
  String get pleaseEnterYourName => 'Syötä nimesi';

  @override
  String get email => 'Sähköposti';

  @override
  String get pleaseEnterYourEmail => 'Syötä sähköpostiosoitteesi';

  @override
  String get pleaseEnterAValidEmail => 'Syötä kelvollinen sähköpostiosoite';

  @override
  String get password => 'Salasana';

  @override
  String get pleaseEnterYourPassword => 'Syötä salasanasi';

  @override
  String get passwordMustBeAtLeast6Characters => 'Salasanan on oltava vähintään 6 merkkiä';

  @override
  String get signUp => 'Rekisteröidy';

  @override
  String get orContinueWith => 'tai jatka';

  @override
  String get google => 'Google';

  @override
  String get apple => 'Apple';

  @override
  String get alreadyHaveAnAccount => 'Onko sinulla jo tili? ';

  @override
  String get signIn => 'Kirjaudu';

  @override
  String get selectYourSkinTypeDescription => 'Valitse ihotyyppisi';

  @override
  String get normal => 'Normaali';

  @override
  String get normalSkinDescription => 'Tasapainoinen, ei liian rasvainen tai kuiva';

  @override
  String get dry => 'Kuiva';

  @override
  String get drySkinDescription => 'Kireä, hilseilevä, karkea rakenne';

  @override
  String get oily => 'Rasvainen';

  @override
  String get oilySkinDescription => 'Kiiltävä, suuret huokoset, taipumus akneen';

  @override
  String get combination => 'Sekaiho';

  @override
  String get combinationSkinDescription => 'Rasvainen T-alue, kuivat posket';

  @override
  String get sensitive => 'Herkkä';

  @override
  String get sensitiveSkinDescription => 'Ärtyyherkkä, taipuvainen punoitukseen';

  @override
  String get selectSkinType => 'Valitse ihotyyppi';

  @override
  String get restore => 'Palauta';

  @override
  String get restorePurchases => 'Palauta ostokset';

  @override
  String get subscriptionRestored => 'Tilaus palautettu onnistuneesti!';

  @override
  String get noPurchasesToRestore => 'Ei palautettavia ostoksia';

  @override
  String get goPremium => 'Hanki Premium';

  @override
  String get unlockExclusiveFeatures => 'Avaa eksklusiiviset ominaisuudet saadaksesi kaiken irti ihon analyysistä.';

  @override
  String get unlimitedProductScans => 'Rajattomat tuoteskannaukset';

  @override
  String get advancedAIIngredientAnalysis => 'Kehittynyt AI-ainesosa-analyysi';

  @override
  String get fullScanAndSearchHistory => 'Täydellinen skannaus- ja hakuhistoria';

  @override
  String get adFreeExperience => '100% mainokseton';

  @override
  String get yearly => 'Vuosittain';

  @override
  String savePercentage(int percentage) {
    return 'Säästä $percentage%';
  }

  @override
  String get monthly => 'Kuukausittain';

  @override
  String get perMonth => '/ kk';

  @override
  String get startFreeTrial => 'Aloita ilmainen kokeilu';

  @override
  String trialDescription(String planName) {
    return '7 päivän ilmainen kokeilu, sen jälkeen $planName. Voit peruuttaa milloin tahansa.';
  }

  @override
  String get home => 'Etusivu';

  @override
  String get scan => 'Skanneri';

  @override
  String get aiChatNav => 'Konsultti';

  @override
  String get profileNav => 'Profiili';

  @override
  String get doYouEnjoyOurApp => 'Pidätkö sovelluksestamme?';

  @override
  String get notReally => 'En';

  @override
  String get yesItsGreat => 'Pidän';

  @override
  String get rateOurApp => 'Arvostele sovellus';

  @override
  String get bestRatingWeCanGet => 'Paras mahdollinen arvio';

  @override
  String get rateOnGooglePlay => 'Arvostele Google Playssa';

  @override
  String get rate => 'Arvostele';

  @override
  String get whatCanBeImproved => 'Mitä voisi parantaa?';

  @override
  String get wereSorryYouDidntHaveAGreatExperience => 'Pahoittelemme huonoa kokemustasi. Kerro, mikä meni pieleen.';

  @override
  String get yourFeedback => 'Palautteesi...';

  @override
  String get sendFeedback => 'Lähetä palaute';

  @override
  String get thankYouForYourFeedback => 'Kiitos palautteestasi!';

  @override
  String get discussWithAI => 'Keskustele AI:n kanssa';

  @override
  String get enterYourEmail => 'Syötä sähköpostiosoitteesi';

  @override
  String get enterYourPassword => 'Syötä salasanasi';

  @override
  String get aiDisclaimer => 'AI-vastaukset voivat sisältää virheitä. Tarkista kriittinen tieto.';

  @override
  String get applicationThemes => 'Sovelluksen teemat';

  @override
  String get highestRating => 'Korkein arvosana';

  @override
  String get selectYourAgeDescription => 'Valitse ikäsi';

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
  String get ageRange18_25Description => 'Nuori iho, ennaltaehkäisy';

  @override
  String get ageRange26_35Description => 'Ensimmäiset ikääntymisen merkit';

  @override
  String get ageRange36_45Description => 'Ikääntymisenestohoito';

  @override
  String get ageRange46_55Description => 'Intensiivinen hoito';

  @override
  String get ageRange56PlusDescription => 'Erikoishoito';

  @override
  String get userName => 'Nimesi';

  @override
  String get yourName => 'Your Name';

  @override
  String get tryFreeAndSubscribe => 'Kokeile ilmaiseksi ja tilaa';

  @override
  String get personalAIConsultant => 'Henkilökohtainen AI-konsultti 24/7';

  @override
  String get subscribe => 'Tilaa';

  @override
  String get themes => 'Teemat';

  @override
  String get selectPreferredTheme => 'Valitse haluamasi teema';

  @override
  String get naturalTheme => 'Luonnollinen';

  @override
  String get darkTheme => 'Tumma';

  @override
  String get darkNatural => 'Tumma luonnollinen';

  @override
  String get oceanTheme => 'Valtameri';

  @override
  String get forestTheme => 'Metsä';

  @override
  String get sunsetTheme => 'Auringonlasku';

  @override
  String get naturalThemeDescription => 'Luonnollinen teema ekologisilla väreillä';

  @override
  String get darkThemeDescription => 'Tumma teema silmien mukavuutta varten';

  @override
  String get oceanThemeDescription => 'Raikas valtameriteema';

  @override
  String get forestThemeDescription => 'Luonnollinen metsäteema';

  @override
  String get sunsetThemeDescription => 'Lämmin auringonlaskuteema';

  @override
  String get sunnyTheme => 'Aurinkoinen';

  @override
  String get sunnyThemeDescription => 'Kirkas ja iloinen keltainen teema';

  @override
  String get vibrantTheme => 'Eloisa';

  @override
  String get vibrantThemeDescription => 'Kirkas pinkki ja violetti teema';

  @override
  String get scanAnalysis => 'Skannausanalyysi';

  @override
  String get ingredients => 'ainesosaa';

  @override
  String get aiBotSettings => 'AI-asetukset';

  @override
  String get botName => 'Botin nimi';

  @override
  String get enterBotName => 'Syötä botin nimi';

  @override
  String get pleaseEnterBotName => 'Syötä botin nimi';

  @override
  String get botDescription => 'Botin kuvaus';

  @override
  String get selectAvatar => 'Valitse avatar';

  @override
  String get defaultBotName => 'ACS';

  @override
  String defaultBotDescription(String name) {
    return 'Hei! Olen $name (AI Cosmetic Scanner). Autan sinua ymmärtämään kosmetiikkasi koostumusta. Minulla on laaja tietämys kosmetologiasta ja ihonhoidosta. Vastaan mielellään kaikkiin kysymyksiisi.';
  }

  @override
  String get settingsSaved => 'Asetukset tallennettu onnistuneesti';

  @override
  String get failedToSaveSettings => 'Asetusten tallennus epäonnistui';

  @override
  String get resetToDefault => 'Palauta oletukset';

  @override
  String get resetSettings => 'Palauta asetukset';

  @override
  String get resetSettingsConfirmation => 'Haluatko varmasti palauttaa kaikki asetukset oletusarvoihin?';

  @override
  String get settingsResetSuccessfully => 'Asetukset palautettu onnistuneesti';

  @override
  String get failedToResetSettings => 'Asetusten palautus epäonnistui';

  @override
  String get unsavedChanges => 'Tallentamattomat muutokset';

  @override
  String get unsavedChangesMessage => 'Sinulla on tallentamattomia muutoksia. Haluatko varmasti poistua?';

  @override
  String get stay => 'Pysy';

  @override
  String get leave => 'Poistu';

  @override
  String get errorLoadingSettings => 'Virhe asetusten latauksessa';

  @override
  String get retry => 'Yritä uudelleen';

  @override
  String get customPrompt => 'Erityistoiveet';

  @override
  String get customPromptDescription => 'Lisää henkilökohtaisia ohjeita AI-avustajalle';

  @override
  String get customPromptPlaceholder => 'Syötä erityistoiveesi...';

  @override
  String get enableCustomPrompt => 'Ota käyttöön erityistoiveet';

  @override
  String get defaultCustomPrompt => 'Anna minulle kohteliaisuuksia.';

  @override
  String get close => 'Sulje';

  @override
  String get scanningHintTitle => 'Kuinka skannata';

  @override
  String get scanLimitReached => 'Skannausraja saavutettu';

  @override
  String get scanLimitReachedMessage => 'Olet käyttänyt kaikki 5 ilmaista skannausta tällä viikolla. Päivitä Premium-tilaukseen rajattomia skannauksia varten!';

  @override
  String get messageLimitReached => 'Päivittäinen viestiraja saavutettu';

  @override
  String get messageLimitReachedMessage => 'Olet lähettänyt 5 viestiä tänään. Päivitä Premium-tilaukseen rajatonta keskustelua varten!';

  @override
  String get historyLimitReached => 'Historian käyttö rajoitettu';

  @override
  String get historyLimitReachedMessage => 'Päivitä Premium-tilaukseen käyttääksesi täydellistä skannaushistoriaasi!';

  @override
  String get upgradeToPremium => 'Päivitä Premium-versioon';

  @override
  String get upgradeToView => 'Näe Premium-versiolla';

  @override
  String get upgradeToChat => 'Keskustele Premium-versiolla';

  @override
  String get premiumFeature => 'Premium-ominaisuus';

  @override
  String get freePlanUsage => 'Ilmaisen version käyttö';

  @override
  String get scansThisWeek => 'Skannaukset tällä viikolla';

  @override
  String get messagesToday => 'Viestit tänään';

  @override
  String get limitsReached => 'Rajat saavutettu';

  @override
  String get remainingScans => 'Jäljellä olevia skannauksia';

  @override
  String get remainingMessages => 'Jäljellä olevia viestejä';

  @override
  String get unlockUnlimitedAccess => 'Avaa rajaton käyttö';

  @override
  String get upgradeToPremiumDescription => 'Hanki rajattomat skannaukset, viestit ja täysi pääsy skannaushistoriaasi Premium-versiolla!';

  @override
  String get premiumBenefits => 'Premium-edut';

  @override
  String get unlimitedAiChatMessages => 'Rajattomat AI-keskusteluviestit';

  @override
  String get fullAccessToScanHistory => 'Täysi pääsy skannaushistoriaan';

  @override
  String get prioritySupport => 'Ensisijainen tuki';

  @override
  String get learnMore => 'Lue lisää';

  @override
  String get upgradeNow => 'Päivitä nyt';

  @override
  String get maybeLater => 'Ehkä myöhemmin';

  @override
  String get scanHistoryLimit => 'Vain viimeisin skannaus näkyy historiassa';

  @override
  String get upgradeForUnlimitedScans => 'Päivitä rajattomiin skannauksiin!';

  @override
  String get upgradeForUnlimitedChat => 'Päivitä rajattomaan keskusteluun!';

  @override
  String get slowInternetConnection => 'Hidas internetyhteys';

  @override
  String get slowInternetMessage => 'Erittäin hitaalla internetyhteydellä joudut odottamaan hetken... Analysoimme edelleen kuvaa.';

  @override
  String get revolutionaryAI => 'Vallankumouksellinen AI';

  @override
  String get revolutionaryAIDesc => 'Yksi maailman älykkäimmistä';

  @override
  String get unlimitedScans => 'Rajattomat skannaukset';

  @override
  String get unlimitedScansDesc => 'Tutustu kosmetiikkaan ilman rajoituksia';

  @override
  String get unlimitedChats => 'Rajattomat keskustelut';

  @override
  String get unlimitedChatsDesc => 'Henkilökohtainen AI-konsultti 24/7';

  @override
  String get fullHistory => 'Täysi historia';

  @override
  String get fullHistoryDesc => 'Rajaton skannaushistoria';

  @override
  String get rememberContext => 'Muistaa kontekstin';

  @override
  String get rememberContextDesc => 'AI muistaa aiemmat viestisi';

  @override
  String get allIngredientsInfo => 'Kaikki ainesosatiedot';

  @override
  String get allIngredientsInfoDesc => 'Opi kaikki yksityiskohdat';

  @override
  String get noAds => '100% mainokseton';

  @override
  String get noAdsDesc => 'Niille, jotka arvostavat aikaansa';

  @override
  String get multiLanguage => 'Tuntee lähes kaikki kielet';

  @override
  String get multiLanguageDesc => 'Parannettu kääntäjä';

  @override
  String get paywallTitle => 'Avaa kosmetiikkasi salaisuudet AI:n avulla';

  @override
  String paywallDescription(String price) {
    return 'Voit hankkia Premium-tilauksen 3 päivän ilmaisella kokeilulla, sen jälkeen $price viikossa. Voit peruuttaa milloin tahansa.';
  }

  @override
  String get whatsIncluded => 'Mitä sisältyy';

  @override
  String get basicPlan => 'Perus';

  @override
  String get premiumPlan => 'Premium';

  @override
  String get botGreeting1 => 'Hyvää päivää! Miten voin auttaa sinua tänään?';

  @override
  String get botGreeting2 => 'Hei! Mikä tuo sinut luokseni?';

  @override
  String get botGreeting3 => 'Tervetuloa! Valmis auttamaan kosmetiikka-analyysissa.';

  @override
  String get botGreeting4 => 'Mukava nähdä! Miten voin olla avuksi?';

  @override
  String get botGreeting5 => 'Tervetuloa! Tutkitaan kosmetiikkasi koostumusta yhdessä.';

  @override
  String get botGreeting6 => 'Hei! Valmis vastaamaan kysymyksiisi kosmetiikasta.';

  @override
  String get botGreeting7 => 'Hei! Olen henkilökohtainen kosmetologia-avustajasi.';

  @override
  String get botGreeting8 => 'Hyvää päivää! Autan sinua ymmärtämään kosmeettisten tuotteiden koostumusta.';

  @override
  String get botGreeting9 => 'Hei! Tehdään kosmetiikastasi turvallisempi yhdessä.';

  @override
  String get botGreeting10 => 'Tervetuloa! Valmis jakamaan tietoa kosmetiikasta.';

  @override
  String get botGreeting11 => 'Hyvää päivää! Autan sinua löytämään parhaat kosmetiikkaratkaisut sinulle.';

  @override
  String get botGreeting12 => 'Hei! Kosmetiikan turvallisuusasiantuntijasi palveluksessasi.';

  @override
  String get botGreeting13 => 'Hei! Valitaan täydellinen kosmetiikka sinulle yhdessä.';

  @override
  String get botGreeting14 => 'Tervetuloa! Valmis auttamaan ainesosien analyysissa.';

  @override
  String get botGreeting15 => 'Hei! Autan sinua ymmärtämään kosmetiikkasi koostumusta.';

  @override
  String get botGreeting16 => 'Tervetuloa! Oppaasi kosmetologian maailmassa on valmis auttamaan.';

  @override
  String get copiedToClipboard => 'Kopioitu leikepöydälle';

  @override
  String get tryFree => 'Kokeile ilmaiseksi';

  @override
  String get cameraNotReady => 'Kamera ei ole valmis / ei käyttöoikeutta';

  @override
  String get cameraPermissionInstructions => 'Sovelluksen asetukset:\nAI Cosmetic Scanner > Käyttöoikeudet > Kamera > Salli';

  @override
  String get openSettingsAndGrantAccess => 'Avaa Asetukset ja anna kameran käyttöoikeus';

  @override
  String get retryCamera => 'Yritä uudelleen';

  @override
  String get errorServiceOverloaded => 'Palvelu on väliaikaisesti ylikuormitettu. Yritä hetken kuluttua uudelleen.';

  @override
  String get errorRateLimitExceeded => 'Liian monta pyyntöä. Odota hetki ja yritä uudelleen.';

  @override
  String get errorTimeout => 'Pyyntö aikakatkaistiin. Tarkista internetyhteytesi ja yritä uudelleen.';

  @override
  String get errorNetwork => 'Verkkovirhe. Tarkista internetyhteytesi.';

  @override
  String get errorAuthentication => 'Todennusvirhe. Käynnistä sovellus uudelleen.';

  @override
  String get errorInvalidResponse => 'Saatiin virheellinen vastaus. Yritä uudelleen.';

  @override
  String get errorServer => 'Palvelinvirhe. Yritä myöhemmin uudelleen.';

  @override
  String get customThemes => 'Omat teemat';

  @override
  String get createCustomTheme => 'Luo oma teema';

  @override
  String get basedOn => 'Perustuen';

  @override
  String get lightMode => 'Vaalea';

  @override
  String get generateWithAI => 'Generoi AI:lla';

  @override
  String get resetToBaseTheme => 'Palauta perusteemaan';

  @override
  String colorsResetTo(Object themeName) {
    return 'Värit palautettu teemaan $themeName';
  }

  @override
  String get aiGenerationComingSoon => 'AI-teemojen generointi tulossa iteraatiossa 5!';

  @override
  String get onboardingGreeting => 'Tervetuloa! Parantaaksemme vastausten laatua, määritetään profiilisi';

  @override
  String get letsGo => 'Aloitetaan';

  @override
  String get next => 'Seuraava';

  @override
  String get finish => 'Valmis';

  @override
  String get customThemeInDevelopment => 'Omien teemojen ominaisuus on kehitteillä';

  @override
  String get customThemeComingSoon => 'Tulossa pian tulevissa päivityksissä';

  @override
  String get dailyMessageLimitReached => 'Raja saavutettu';

  @override
  String get dailyMessageLimitReachedMessage => 'Olet lähettänyt 5 viestiä tänään. Päivitä Premium-tilaukseen rajatonta keskustelua varten!';

  @override
  String get upgradeToPremiumForUnlimitedChat => 'Päivitä Premium-tilaukseen rajatonta keskustelua varten';

  @override
  String get messagesLeftToday => 'viestiä jäljellä tänään';

  @override
  String get designYourOwnTheme => 'Suunnittele oma teemasi';

  @override
  String get darkOcean => 'Tumma valtameri';

  @override
  String get darkForest => 'Tumma metsä';

  @override
  String get darkSunset => 'Tumma auringonlasku';

  @override
  String get darkVibrant => 'Tumma eloisa';

  @override
  String get darkOceanThemeDescription => 'Tumma valtameriteema syaaneilla korostuksilla';

  @override
  String get darkForestThemeDescription => 'Tumma metsäteema vihreillä korostuksilla';

  @override
  String get darkSunsetThemeDescription => 'Tumma auringonlaskuteema oransseilla korostuksilla';

  @override
  String get darkVibrantThemeDescription => 'Tumma eloisa teema pinkillä ja violeteilla korostuksilla';

  @override
  String get customTheme => 'Oma teema';

  @override
  String get edit => 'Muokkaa';

  @override
  String get deleteTheme => 'Poista teema';

  @override
  String deleteThemeConfirmation(String themeName) {
    return 'Haluatko varmasti poistaa teeman \"$themeName\"?';
  }

  @override
  String get pollTitle => 'Mitä puuttuu?';

  @override
  String get pollCardTitle => 'Mitä sovelluksesta puuttuu?';

  @override
  String get pollDescription => 'Äänestä vaihtoehtoja, jotka haluat nähdä';

  @override
  String get submitVote => 'Äänestä';

  @override
  String get submitting => 'Lähetetään...';

  @override
  String get voteSubmittedSuccess => 'Äänet lähetetty onnistuneesti!';

  @override
  String votesRemaining(int count) {
    return '$count ääntä jäljellä';
  }

  @override
  String get votes => 'ääntä';

  @override
  String get addYourOption => 'Ehdota parannusta';

  @override
  String get enterYourOption => 'Syötä vaihtoehto...';

  @override
  String get add => 'Lisää';

  @override
  String get filterTopVoted => 'Suositut';

  @override
  String get filterNewest => 'Uusimmat';

  @override
  String get filterMyOption => 'Valintani';

  @override
  String get thankYouForVoting => 'Kiitos äänestämisestä!';

  @override
  String get votingComplete => 'Äänesi on tallennettu';

  @override
  String get requestFeatureDevelopment => 'Pyydä ominaisuuden kehittämistä';

  @override
  String get requestFeatureDescription => 'Tarvitsetko tietyn ominaisuuden? Ota yhteyttä keskustellaksemme räätälöidystä kehityksestä liiketoimintatarpeisiisi.';

  @override
  String get pollHelpTitle => 'Kuinka äänestää';

  @override
  String get pollHelpDescription => '• Napauta vaihtoehtoa valitaksesi sen\n• Napauta uudelleen poistaaksesi valinnan\n• Valitse niin monta vaihtoehtoa kuin haluat\n• Napsauta \'Äänestä\'-painiketta lähettääksesi äänesi\n• Lisää oma vaihtoehto, jos et näe tarvitsemaasi';

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
