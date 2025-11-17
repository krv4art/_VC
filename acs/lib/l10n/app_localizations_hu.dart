// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hungarian (`hu`).
class AppLocalizationsHu extends AppLocalizations {
  AppLocalizationsHu([String locale = 'hu']) : super(locale);

  @override
  String get appName => 'AI Kozmetikai Szkenner';

  @override
  String get skinAnalysis => 'Bőrelemzés';

  @override
  String get checkYourCosmetics => 'Ellenőrizze kozmetikumait';

  @override
  String get startScanning => 'Szkennelés indítása';

  @override
  String get quickActions => 'Gyors műveletek';

  @override
  String get scanHistory => 'Szkennelési előzmények';

  @override
  String get aiChat => 'AI Kozmetikai Szkenner';

  @override
  String get profile => 'Profil';

  @override
  String get settings => 'Beállítások';

  @override
  String get skinType => 'Bőrtípus';

  @override
  String get allergiesSensitivities => 'Allergiák és érzékenységek';

  @override
  String get subscription => 'Előfizetés';

  @override
  String get age => 'Kor';

  @override
  String get language => 'Nyelv';

  @override
  String get selectYourPreferredLanguage => 'Válassza ki a kívánt nyelvet';

  @override
  String get save => 'Mentés';

  @override
  String get selectIngredientsAllergicSensitive => 'Válassza ki az összetevőket, amelyekre fokozott érzékenységgel rendelkezik';

  @override
  String get commonAllergens => 'Gyakori allergének';

  @override
  String get fragrance => 'Illat';

  @override
  String get parabens => 'Parabének';

  @override
  String get sulfates => 'Szulfátok';

  @override
  String get alcohol => 'Alkohol';

  @override
  String get essentialOils => 'Illóolajok';

  @override
  String get silicones => 'Szilikonok';

  @override
  String get mineralOil => 'Ásványi olaj';

  @override
  String get formaldehyde => 'Formaldehid';

  @override
  String get addCustomAllergen => 'Egyéni allergén hozzáadása';

  @override
  String get typeIngredientName => 'Írja be az összetevő nevét...';

  @override
  String get selectedAllergens => 'Kiválasztott allergének';

  @override
  String saveSelected(int count) {
    return 'Mentés ($count kiválasztva)';
  }

  @override
  String get analysisResults => 'Elemzési eredmények';

  @override
  String get overallSafetyScore => 'Általános biztonsági pontszám';

  @override
  String get personalizedWarnings => 'Személyre szabott figyelmeztetések';

  @override
  String ingredientsAnalysis(int count) {
    return 'Összetevők elemzése ($count)';
  }

  @override
  String get highRisk => 'Magas kockázat';

  @override
  String get moderateRisk => 'Közepes kockázat';

  @override
  String get lowRisk => 'Alacsony kockázat';

  @override
  String get benefitsAnalysis => 'Előnyök elemzése';

  @override
  String get recommendedAlternatives => 'Ajánlott alternatívák';

  @override
  String get reason => 'Indok:';

  @override
  String get quickSummary => 'Gyors összefoglaló';

  @override
  String get ingredientsChecked => 'összetevő ellenőrizve';

  @override
  String get personalWarnings => 'személyes figyelmeztetés';

  @override
  String get ourVerdict => 'Véleményünk';

  @override
  String get productInfo => 'Termékinformáció';

  @override
  String get productType => 'Terméktípus';

  @override
  String get brand => 'Márka';

  @override
  String get premiumInsights => 'Prémium betekintések';

  @override
  String get researchArticles => 'Kutatási cikkek';

  @override
  String get categoryRanking => 'Kategória rangsor';

  @override
  String get safetyTrend => 'Biztonsági trend';

  @override
  String get saveToFavorites => 'Mentés';

  @override
  String get shareResults => 'Megosztás';

  @override
  String get compareProducts => 'Összehasonlítás';

  @override
  String get exportPDF => 'PDF';

  @override
  String get scanSimilar => 'Hasonló';

  @override
  String get aiChatTitle => 'AI Kozmetikai Szkenner';

  @override
  String get typeYourMessage => 'Írja be az üzenetét...';

  @override
  String get errorSupabaseClientNotInitialized => 'Hiba: A Supabase kliens nincs inicializálva.';

  @override
  String get serverError => 'Szerverhiba:';

  @override
  String get networkErrorOccurred => 'Hálózati hiba történt. Kérjük, próbálja újra később.';

  @override
  String get sorryAnErrorOccurred => 'Sajnáljuk, hiba történt. Kérjük, próbálja újra.';

  @override
  String get couldNotGetResponse => 'Nem sikerült választ kapni.';

  @override
  String get aiAssistant => 'AI Asszisztens';

  @override
  String get online => 'Online';

  @override
  String get typing => 'Gépel...';

  @override
  String get writeAMessage => 'Írjon üzenetet...';

  @override
  String get hiIAmYourAIAssistantHowCanIHelp => 'Szia! Az AI asszisztensed vagyok. Miben segíthetek?';

  @override
  String get iCanSeeYourScanResultsFeelFreeToAskMeAnyQuestionsAboutTheIngredientsSafetyConcernsOrRecommendations => 'Látom a szkennelési eredményeit! Bátran tegyen fel kérdéseket az összetevőkről, biztonsági aggályokról vagy ajánlásokról.';

  @override
  String get userQuestion => 'Felhasználói kérdés:';

  @override
  String get databaseExplorer => 'Adatbázis böngésző';

  @override
  String get currentUser => 'Jelenlegi felhasználó:';

  @override
  String get notSignedIn => 'Nincs bejelentkezve';

  @override
  String get failedToFetchTables => 'Nem sikerült betölteni a táblákat:';

  @override
  String get tablesInYourSupabaseDatabase => 'Táblák a Supabase adatbázisban:';

  @override
  String get viewSampleData => 'Mintaadatok megtekintése';

  @override
  String get failedToFetchSampleDataFor => 'Nem sikerült betölteni a mintaadatokat:';

  @override
  String get sampleData => 'Mintaadatok:';

  @override
  String get aiChats => 'MI csevegések';

  @override
  String get noDialoguesYet => 'Még nincsenek párbeszédek.';

  @override
  String get startANewChat => 'Indítson új beszélgetést!';

  @override
  String get created => 'Létrehozva:';

  @override
  String get failedToSaveImage => 'Nem sikerült menteni a képet:';

  @override
  String get editName => 'Név szerkesztése';

  @override
  String get enterYourName => 'Adja meg a nevét';

  @override
  String get cancel => 'Mégse';

  @override
  String get premiumUser => 'Prémium felhasználó';

  @override
  String get freeUser => 'Ingyenes felhasználó';

  @override
  String get skinProfile => 'Bőrprofil';

  @override
  String get notSet => 'Nincs beállítva';

  @override
  String get legal => 'Jogi információk';

  @override
  String get privacyPolicy => 'Adatvédelmi szabályzat';

  @override
  String get termsOfService => 'Felhasználási feltételek';

  @override
  String get dataManagement => 'Adatkezelés';

  @override
  String get clearAllData => 'Minden adat törlése';

  @override
  String get clearAllDataConfirmation => 'Biztosan törölni szeretné az összes helyi adatot? Ez a művelet nem vonható vissza.';

  @override
  String get selectDataToClear => 'Válassza ki a törölni kívánt adatokat';

  @override
  String get scanResults => 'Szkennelési eredmények';

  @override
  String get chatHistory => 'Beszélgetések';

  @override
  String get personalData => 'Személyes adatok';

  @override
  String get clearData => 'Adatok törlése';

  @override
  String get allLocalDataHasBeenCleared => 'Az adatok törölve lettek.';

  @override
  String get signOut => 'Kijelentkezés';

  @override
  String get deleteScan => 'Szkennelés törlése';

  @override
  String get deleteScanConfirmation => 'Biztosan törölni szeretné ezt a szkennelést az előzményekből?';

  @override
  String get deleteChat => 'Beszélgetés törlése';

  @override
  String get deleteChatConfirmation => 'Biztosan törölni szeretné ezt a beszélgetést? Minden üzenet elveszik.';

  @override
  String get delete => 'Törlés';

  @override
  String get noScanHistoryFound => 'Nem találhatók szkennelési előzmények.';

  @override
  String get scanOn => 'Szkennelés ideje:';

  @override
  String get ingredientsFound => 'összetevő találva';

  @override
  String get noCamerasFoundOnThisDevice => 'Nem található kamera ezen az eszközön.';

  @override
  String get failedToInitializeCamera => 'Nem sikerült inicializálni a kamerát:';

  @override
  String get analysisFailed => 'Elemzés sikertelen:';

  @override
  String get analyzingPleaseWait => 'Elemzés folyamatban, kérem várjon...';

  @override
  String get positionTheLabelWithinTheFrame => 'Fókuszálja a kamerát az összetevők listájára';

  @override
  String get createAccount => 'Fiók létrehozása';

  @override
  String get signUpToGetStarted => 'Regisztráljon a kezdéshez';

  @override
  String get fullName => 'Teljes név';

  @override
  String get pleaseEnterYourName => 'Kérjük, adja meg a nevét';

  @override
  String get email => 'E-mail';

  @override
  String get pleaseEnterYourEmail => 'Kérjük, adja meg az e-mail címét';

  @override
  String get pleaseEnterAValidEmail => 'Kérjük, adjon meg érvényes e-mail címet';

  @override
  String get password => 'Jelszó';

  @override
  String get pleaseEnterYourPassword => 'Kérjük, adja meg a jelszavát';

  @override
  String get passwordMustBeAtLeast6Characters => 'A jelszónak legalább 6 karakterből kell állnia';

  @override
  String get signUp => 'Regisztráció';

  @override
  String get orContinueWith => 'vagy folytatás ezzel:';

  @override
  String get google => 'Google';

  @override
  String get apple => 'Apple';

  @override
  String get alreadyHaveAnAccount => 'Már van fiókja? ';

  @override
  String get signIn => 'Bejelentkezés';

  @override
  String get selectYourSkinTypeDescription => 'Válassza ki bőrtípusát';

  @override
  String get normal => 'Normál';

  @override
  String get normalSkinDescription => 'Kiegyensúlyozott, sem túl zsíros, sem túl száraz';

  @override
  String get dry => 'Száraz';

  @override
  String get drySkinDescription => 'Feszes, pelyhes, érdes textúra';

  @override
  String get oily => 'Zsíros';

  @override
  String get oilySkinDescription => 'Fényes, nagy pórusok, pattanásokra hajlamos';

  @override
  String get combination => 'Kombinált';

  @override
  String get combinationSkinDescription => 'Zsíros T-zóna, száraz arcpír';

  @override
  String get sensitive => 'Érzékeny';

  @override
  String get sensitiveSkinDescription => 'Könnyen irritálódik, pirosságra hajlamos';

  @override
  String get selectSkinType => 'Bőrtípus kiválasztása';

  @override
  String get restore => 'Visszaállítás';

  @override
  String get restorePurchases => 'Vásárlások visszaállítása';

  @override
  String get subscriptionRestored => 'Előfizetés sikeresen visszaállítva!';

  @override
  String get noPurchasesToRestore => 'Nincs visszaállítható vásárlás';

  @override
  String get goPremium => 'Váltson Prémiumra';

  @override
  String get unlockExclusiveFeatures => 'Oldja fel az exkluzív funkciókat a bőrelemzés legtöbbjének kiaknázásához.';

  @override
  String get unlimitedProductScans => 'Korlátlan termékszkenneléa';

  @override
  String get advancedAIIngredientAnalysis => 'Fejlett AI összetevő-elemzés';

  @override
  String get fullScanAndSearchHistory => 'Teljes szkennelési és keresési előzmények';

  @override
  String get adFreeExperience => '100%-ban reklám mentes élmény';

  @override
  String get yearly => 'Éves';

  @override
  String savePercentage(int percentage) {
    return '$percentage% megtakarítás';
  }

  @override
  String get monthly => 'Havi';

  @override
  String get perMonth => '/ hónap';

  @override
  String get startFreeTrial => 'Ingyenes próba indítása';

  @override
  String trialDescription(String planName) {
    return '7 napos ingyenes próba, majd $planName számlázás. Bármikor lemondható.';
  }

  @override
  String get home => 'Kezdőlap';

  @override
  String get scan => 'Szkenner';

  @override
  String get aiChatNav => 'Tanacsado';

  @override
  String get profileNav => 'Profil';

  @override
  String get doYouEnjoyOurApp => 'Tetszik az alkalmazásunk?';

  @override
  String get notReally => 'Nem';

  @override
  String get yesItsGreat => 'Tetszik';

  @override
  String get rateOurApp => 'Értékelje alkalmazásunkat';

  @override
  String get bestRatingWeCanGet => 'A legjobb értékelés, amit kaphatunk';

  @override
  String get rateOnGooglePlay => 'Értékelés a Google Play-en';

  @override
  String get rate => 'Értékelés';

  @override
  String get whatCanBeImproved => 'Mit lehet javítani?';

  @override
  String get wereSorryYouDidntHaveAGreatExperience => 'Sajnáljuk, hogy nem volt nagyszerű élménye. Kérjük, mondja el, mi ment rosszul.';

  @override
  String get yourFeedback => 'Visszajelzése...';

  @override
  String get sendFeedback => 'Visszajelzés küldése';

  @override
  String get thankYouForYourFeedback => 'Köszönjük visszajelzését!';

  @override
  String get discussWithAI => 'Beszélje meg AI-val';

  @override
  String get enterYourEmail => 'Adja meg e-mail címét';

  @override
  String get enterYourPassword => 'Adja meg jelszavát';

  @override
  String get aiDisclaimer => 'Az AI válaszok pontatlanságokat tartalmazhatnak. Kérjük, ellenőrizze a kritikus információkat.';

  @override
  String get applicationThemes => 'Alkalmazás témák';

  @override
  String get highestRating => 'Legmagasabb értékelés';

  @override
  String get selectYourAgeDescription => 'Válassza ki korcsoportját';

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
  String get ageRange18_25Description => 'Fiatal bőr, prevenció';

  @override
  String get ageRange26_35Description => 'Első öregedési jelek';

  @override
  String get ageRange36_45Description => 'Anti-aging ápolás';

  @override
  String get ageRange46_55Description => 'Intenzív ápolás';

  @override
  String get ageRange56PlusDescription => 'Speciális ápolás';

  @override
  String get userName => 'Az Ön neve';

  @override
  String get yourName => 'Your Name';

  @override
  String get tryFreeAndSubscribe => 'Próbálja ki ingyen és fizessen elő';

  @override
  String get personalAIConsultant => 'Személyes AI tanácsadó 24/7';

  @override
  String get subscribe => 'Előfizetés';

  @override
  String get themes => 'Témák';

  @override
  String get selectPreferredTheme => 'Válassza ki kedvenc témáját';

  @override
  String get naturalTheme => 'Természetes';

  @override
  String get darkTheme => 'Sötét';

  @override
  String get darkNatural => 'Sötét természetes';

  @override
  String get oceanTheme => 'Óceán';

  @override
  String get forestTheme => 'Erdő';

  @override
  String get sunsetTheme => 'Napnyugta';

  @override
  String get naturalThemeDescription => 'Természetes téma környezetbarát színekkel';

  @override
  String get darkThemeDescription => 'Sötét téma a szemkíméléshez';

  @override
  String get oceanThemeDescription => 'Friss óceán téma';

  @override
  String get forestThemeDescription => 'Természetes erdő téma';

  @override
  String get sunsetThemeDescription => 'Meleg napnyugta téma';

  @override
  String get sunnyTheme => 'Napos';

  @override
  String get sunnyThemeDescription => 'Ragyogó és vidám sárga téma';

  @override
  String get vibrantTheme => 'Vibráló';

  @override
  String get vibrantThemeDescription => 'Élénk rózsaszín és lila téma';

  @override
  String get scanAnalysis => 'Szkennelési elemzés';

  @override
  String get ingredients => 'összetevők';

  @override
  String get aiBotSettings => 'AI beállítások';

  @override
  String get botName => 'Bot neve';

  @override
  String get enterBotName => 'Adja meg a bot nevét';

  @override
  String get pleaseEnterBotName => 'Kérjük, adja meg a bot nevét';

  @override
  String get botDescription => 'Bot leírása';

  @override
  String get selectAvatar => 'Avatar kiválasztása';

  @override
  String get defaultBotName => 'ACS';

  @override
  String defaultBotDescription(String name) {
    return 'Szia! $name vagyok (AI Kozmetikai Szkenner). Segítek megérteni kozmetikumaid összetételét. Széleskörű tudással rendelkezem a kozmetológia és bőrápolás területén. Szívesen válaszolok minden kérdésedre.';
  }

  @override
  String get settingsSaved => 'Beállítások sikeresen mentve';

  @override
  String get failedToSaveSettings => 'Nem sikerült menteni a beállításokat';

  @override
  String get resetToDefault => 'Alapértelmezett visszaállítása';

  @override
  String get resetSettings => 'Beállítások visszaállítása';

  @override
  String get resetSettingsConfirmation => 'Biztosan visszaállítja az összes beállítást az alapértelmezett értékekre?';

  @override
  String get settingsResetSuccessfully => 'Beállítások sikeresen visszaállítva';

  @override
  String get failedToResetSettings => 'Nem sikerült visszaállítani a beállításokat';

  @override
  String get unsavedChanges => 'Nem mentett változások';

  @override
  String get unsavedChangesMessage => 'Nem mentett változások vannak. Biztosan el szeretne navigálni?';

  @override
  String get stay => 'Maradok';

  @override
  String get leave => 'Elmegyek';

  @override
  String get errorLoadingSettings => 'Hiba a beállítások betöltésekor';

  @override
  String get retry => 'Újra';

  @override
  String get customPrompt => 'Speciális kérések';

  @override
  String get customPromptDescription => 'Adjon hozzá személyre szabott utasításokat az AI asszisztenshez';

  @override
  String get customPromptPlaceholder => 'Írja be speciális kéréseit...';

  @override
  String get enableCustomPrompt => 'Speciális kérések engedélyezése';

  @override
  String get defaultCustomPrompt => 'Mondj bókokat.';

  @override
  String get close => 'Bezárás';

  @override
  String get scanningHintTitle => 'Hogyan szkenneljünk';

  @override
  String get scanLimitReached => 'Szkennelési limit elérve';

  @override
  String get scanLimitReachedMessage => 'Felhasználta mind az 5 ingyenes szkennelést ezen a héten. Váltson Prémiumra a korlátlan szkenneléshez!';

  @override
  String get messageLimitReached => 'Napi üzenetlimit elérve';

  @override
  String get messageLimitReachedMessage => 'Ma már 5 üzenetet küldött. Váltson Prémiumra a korlátlan csevegéshez!';

  @override
  String get historyLimitReached => 'Előzmények hozzáférés korlátozott';

  @override
  String get historyLimitReachedMessage => 'Váltson Prémiumra a teljes szkennelési előzmények eléréséhez!';

  @override
  String get upgradeToPremium => 'Váltson Prémiumra';

  @override
  String get upgradeToView => 'Váltson Prémiumra a megtekintéshez';

  @override
  String get upgradeToChat => 'Váltson Prémiumra a csevegéshez';

  @override
  String get premiumFeature => 'Prémium funkció';

  @override
  String get freePlanUsage => 'Ingyenes csomag használat';

  @override
  String get scansThisWeek => 'Szkennelések ezen a héten';

  @override
  String get messagesToday => 'Üzenetek ma';

  @override
  String get limitsReached => 'Elért limitek';

  @override
  String get remainingScans => 'Hátralevő szkennelések';

  @override
  String get remainingMessages => 'Hátralevő üzenetek';

  @override
  String get unlockUnlimitedAccess => 'Korlátlan hozzáférés feloldása';

  @override
  String get upgradeToPremiumDescription => 'Kapjon korlátlan szkennelést, üzeneteket és teljes hozzáférést szkennelési előzményeihez a Prémiummal!';

  @override
  String get premiumBenefits => 'Prémium előnyök';

  @override
  String get unlimitedAiChatMessages => 'Korlátlan AI csevegési üzenetek';

  @override
  String get fullAccessToScanHistory => 'Teljes hozzáférés a szkennelési előzményekhez';

  @override
  String get prioritySupport => 'Prioritásos támogatás';

  @override
  String get learnMore => 'Tudjon meg többet';

  @override
  String get upgradeNow => 'Váltson most';

  @override
  String get maybeLater => 'Talán később';

  @override
  String get scanHistoryLimit => 'Csak a legutóbbi szkennelés látható az előzményekben';

  @override
  String get upgradeForUnlimitedScans => 'Váltson Prémiumra a korlátlan szkenneléshez!';

  @override
  String get upgradeForUnlimitedChat => 'Váltson Prémiumra a korlátlan csevegéshez!';

  @override
  String get slowInternetConnection => 'Lassú internetkapcsolat';

  @override
  String get slowInternetMessage => 'Nagyon lassú internetkapcsolat esetén egy kicsit várnia kell... Még mindig elemezzük a képét.';

  @override
  String get revolutionaryAI => 'Forradalmi AI';

  @override
  String get revolutionaryAIDesc => 'Az egyik legokosabb a világon';

  @override
  String get unlimitedScans => 'Korlátlan szkennelések';

  @override
  String get unlimitedScansDesc => 'Fedezze fel a kozmetikumokat korlátok nélkül';

  @override
  String get unlimitedChats => 'Korlátlan csevegések';

  @override
  String get unlimitedChatsDesc => 'Személyes AI tanácsadó 24/7';

  @override
  String get fullHistory => 'Teljes előzmények';

  @override
  String get fullHistoryDesc => 'Korlátlan szkennelési előzmények';

  @override
  String get rememberContext => 'Emlékezik a kontextusra';

  @override
  String get rememberContextDesc => 'Az AI emlékezik korábbi üzeneteire';

  @override
  String get allIngredientsInfo => 'Minden összetevő információ';

  @override
  String get allIngredientsInfoDesc => 'Tudja meg az összes részletet';

  @override
  String get noAds => '100%-ban reklám mentes';

  @override
  String get noAdsDesc => 'Azoknak, akik értékelik az idejüket';

  @override
  String get multiLanguage => 'Majdnem minden nyelvet ismer';

  @override
  String get multiLanguageDesc => 'Továbbfejlesztett fordító';

  @override
  String get paywallTitle => 'Oldja fel kozmetikumai titkait AI-val';

  @override
  String paywallDescription(String price) {
    return 'Lehetősége van 3 napra ingyen Prémium előfizetést szerezni, majd $price hetente. Bármikor lemondható.';
  }

  @override
  String get whatsIncluded => 'Amit tartalmaz';

  @override
  String get basicPlan => 'Alap';

  @override
  String get premiumPlan => 'Prémium';

  @override
  String get botGreeting1 => 'Jó napot! Miben segíthetek ma?';

  @override
  String get botGreeting2 => 'Helló! Mi hozott hozzám?';

  @override
  String get botGreeting3 => 'Üdvözlöm! Készen állok a kozmetikai elemzésre.';

  @override
  String get botGreeting4 => 'Örülök, hogy látlak! Miben lehetek hasznos?';

  @override
  String get botGreeting5 => 'Üdvözöllek! Fedezzük fel együtt kozmetikumaid összetételét.';

  @override
  String get botGreeting6 => 'Helló! Készen állok a kozmetikumokkal kapcsolatos kérdések megválaszolására.';

  @override
  String get botGreeting7 => 'Szia! A személyes kozmetológiai asszisztensed vagyok.';

  @override
  String get botGreeting8 => 'Jó napot! Segítek megérteni a kozmetikai termékek összetételét.';

  @override
  String get botGreeting9 => 'Helló! Tegyük biztonságosabbá kozmetikumaidat együtt.';

  @override
  String get botGreeting10 => 'Üdvözlöm! Készen állok megosztani tudásomat a kozmetikumokról.';

  @override
  String get botGreeting11 => 'Jó napot! Segítek megtalálni az Önnek legjobb kozmetikai megoldásokat.';

  @override
  String get botGreeting12 => 'Helló! A kozmetikumok biztonsági szakértője a szolgálatában.';

  @override
  String get botGreeting13 => 'Szia! Válasszuk ki együtt a tökéletes kozmetikumokat számodra.';

  @override
  String get botGreeting14 => 'Üdvözöllek! Készen állok az összetevők elemzésére.';

  @override
  String get botGreeting15 => 'Helló! Segítek megérteni kozmetikumaid összetételét.';

  @override
  String get botGreeting16 => 'Üdvözlöm! A kozmetológia világában az Ön útmutatója készen áll a segítségre.';

  @override
  String get copiedToClipboard => 'Vágólapra másolva';

  @override
  String get tryFree => 'Próbálja ki ingyen';

  @override
  String get cameraNotReady => 'Kamera nem elérhető / nincs engedély';

  @override
  String get cameraPermissionInstructions => 'Alkalmazás beállítások:\nAI Kozmetikai Szkenner > Engedélyek > Kamera > Engedélyezés';

  @override
  String get openSettingsAndGrantAccess => 'Nyissa meg a Beállításokat és engedélyezze a kamera hozzáférést';

  @override
  String get retryCamera => 'Újra';

  @override
  String get errorServiceOverloaded => 'A szolgáltatás ideiglenesen túlterhelt. Kérjük, próbálja újra egy pillanat múlva.';

  @override
  String get errorRateLimitExceeded => 'Túl sok kérés. Kérjük, várjon egy kicsit és próbálja újra.';

  @override
  String get errorTimeout => 'A kérés időtúllépést szenvedett. Kérjük, ellenőrizze internetkapcsolatát és próbálja újra.';

  @override
  String get errorNetwork => 'Hálózati hiba. Kérjük, ellenőrizze internetkapcsolatát.';

  @override
  String get errorAuthentication => 'Hitelesítési hiba. Kérjük, indítsa újra az alkalmazást.';

  @override
  String get errorInvalidResponse => 'Érvénytelen válasz érkezett. Kérjük, próbálja újra.';

  @override
  String get errorServer => 'Szerverhiba. Kérjük, próbálja újra később.';

  @override
  String get customThemes => 'Egyéni témák';

  @override
  String get createCustomTheme => 'Egyéni téma létrehozása';

  @override
  String get basedOn => 'Alapja';

  @override
  String get lightMode => 'Világos';

  @override
  String get generateWithAI => 'Generálás AI-val';

  @override
  String get resetToBaseTheme => 'Alaptéma visszaállítása';

  @override
  String colorsResetTo(Object themeName) {
    return 'Színek visszaállítva $themeName értékekre';
  }

  @override
  String get aiGenerationComingSoon => 'AI téma generálás hamarosan az 5. iterációban!';

  @override
  String get onboardingGreeting => 'Üdvözöljük! A válaszok minőségének javításához állítsuk be profilját';

  @override
  String get letsGo => 'Induljon';

  @override
  String get next => 'Következő';

  @override
  String get finish => 'Befejezés';

  @override
  String get customThemeInDevelopment => 'Az egyéni témák funkció fejlesztés alatt áll';

  @override
  String get customThemeComingSoon => 'Hamarosan érkezik a jövőbeli frissítésekben';

  @override
  String get dailyMessageLimitReached => 'Limit elérve';

  @override
  String get dailyMessageLimitReachedMessage => 'Ma már 5 üzenetet küldött. Váltson Prémiumra a korlátlan csevegéshez!';

  @override
  String get upgradeToPremiumForUnlimitedChat => 'Váltson Prémiumra a korlátlan csevegéshez';

  @override
  String get messagesLeftToday => 'mai üzenetek maradtak';

  @override
  String get designYourOwnTheme => 'Tervezze meg saját témáját';

  @override
  String get darkOcean => 'Sötét óceán';

  @override
  String get darkForest => 'Sötét erdő';

  @override
  String get darkSunset => 'Sötét napnyugta';

  @override
  String get darkVibrant => 'Sötét vibráló';

  @override
  String get darkOceanThemeDescription => 'Sötét óceán téma cián kiemelésekkel';

  @override
  String get darkForestThemeDescription => 'Sötét erdő téma lime zöld kiemelésekkel';

  @override
  String get darkSunsetThemeDescription => 'Sötét napnyugta téma narancssárga kiemelésekkel';

  @override
  String get darkVibrantThemeDescription => 'Sötét vibráló téma rózsaszín és lila kiemelésekkel';

  @override
  String get customTheme => 'Egyéni téma';

  @override
  String get edit => 'Szerkesztés';

  @override
  String get deleteTheme => 'Téma törlése';

  @override
  String deleteThemeConfirmation(String themeName) {
    return 'Biztosan törölni szeretné a(z) \"$themeName\" témát?';
  }

  @override
  String get pollTitle => 'Mi hiányzik?';

  @override
  String get pollCardTitle => 'Mi hiányzik az alkalmazásból?';

  @override
  String get pollDescription => 'Szavazzon a kívánt lehetőségekre';

  @override
  String get submitVote => 'Szavazat';

  @override
  String get submitting => 'Beküldés...';

  @override
  String get voteSubmittedSuccess => 'Szavazatok sikeresen beküldve!';

  @override
  String votesRemaining(int count) {
    return '$count szavazat maradt';
  }

  @override
  String get votes => 'szavazatok';

  @override
  String get addYourOption => 'Javaslat hozzáadása';

  @override
  String get enterYourOption => 'Írja be lehetőségét...';

  @override
  String get add => 'Hozzáadás';

  @override
  String get filterTopVoted => 'Népszerű';

  @override
  String get filterNewest => 'Új';

  @override
  String get filterMyOption => 'Választásom';

  @override
  String get thankYouForVoting => 'Köszönjük a szavazatát!';

  @override
  String get votingComplete => 'Szavazata rögzítve lett';

  @override
  String get requestFeatureDevelopment => 'Egyéni funkciófejlesztés igénylése';

  @override
  String get requestFeatureDescription => 'Szüksége van egy konkrét funkcióra? Lépjen kapcsolatba velünk, hogy megbeszéljük az egyéni fejlesztést üzleti igényeihez.';

  @override
  String get pollHelpTitle => 'Hogyan szavazzunk';

  @override
  String get pollHelpDescription => '• Érintsen meg egy lehetőséget a kiválasztáshoz\n• Érintse meg újra a kijelölés törléshez\n• Válasszon annyi lehetőséget, amennyit szeretne\n• Kattintson a \'Szavazat\' gombra a szavazatok beküldéséhez\n• Adja hozzá saját lehetőségét, ha nem látja, amit keres';

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
