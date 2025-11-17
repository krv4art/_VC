// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appName => 'Skaner Kosmetyków AI';

  @override
  String get skinAnalysis => 'Analiza Skóry';

  @override
  String get checkYourCosmetics => 'Sprawdź swoje kosmetyki';

  @override
  String get startScanning => 'Rozpocznij Skanowanie';

  @override
  String get quickActions => 'Szybkie Akcje';

  @override
  String get scanHistory => 'Historia Skanowania';

  @override
  String get aiChat => 'Skaner Kosmetyków AI';

  @override
  String get profile => 'Profil';

  @override
  String get settings => 'Ustawienia';

  @override
  String get skinType => 'Typ Skóry';

  @override
  String get allergiesSensitivities => 'Alergie i Wrażliwości';

  @override
  String get subscription => 'Subskrypcja';

  @override
  String get age => 'Wiek';

  @override
  String get language => 'Język';

  @override
  String get selectYourPreferredLanguage => 'Wybierz swój preferowany język';

  @override
  String get save => 'Zapisz';

  @override
  String get selectIngredientsAllergicSensitive => 'Wybierz składniki, na które jesteś wrażliwy';

  @override
  String get commonAllergens => 'Częste Alergeny';

  @override
  String get fragrance => 'Zapach';

  @override
  String get parabens => 'Parabeny';

  @override
  String get sulfates => 'Siarczany';

  @override
  String get alcohol => 'Alkohol';

  @override
  String get essentialOils => 'Olejki Eteryczne';

  @override
  String get silicones => 'Silikony';

  @override
  String get mineralOil => 'Olej Mineralny';

  @override
  String get formaldehyde => 'Formaldehyd';

  @override
  String get addCustomAllergen => 'Dodaj Niestandardowy Alergen';

  @override
  String get typeIngredientName => 'Wpisz nazwę składnika...';

  @override
  String get selectedAllergens => 'Wybrane Alergeny';

  @override
  String saveSelected(int count) {
    return 'Zapisz ($count wybranych)';
  }

  @override
  String get analysisResults => 'Wyniki Analizy';

  @override
  String get overallSafetyScore => 'Ogólny Wynik Bezpieczeństwa';

  @override
  String get personalizedWarnings => 'Spersonalizowane Ostrzeżenia';

  @override
  String ingredientsAnalysis(int count) {
    return 'Analiza Składników ($count)';
  }

  @override
  String get highRisk => 'Wysokie Ryzyko';

  @override
  String get moderateRisk => 'Umiarkowane Ryzyko';

  @override
  String get lowRisk => 'Niskie Ryzyko';

  @override
  String get benefitsAnalysis => 'Analiza Korzyści';

  @override
  String get recommendedAlternatives => 'Zalecane Alternatywy';

  @override
  String get reason => 'Powód:';

  @override
  String get quickSummary => 'Szybkie Podsumowanie';

  @override
  String get ingredientsChecked => 'składników sprawdzonych';

  @override
  String get personalWarnings => 'ostrzeżeń osobistych';

  @override
  String get ourVerdict => 'Nasza Opinia';

  @override
  String get productInfo => 'Informacje o Produkcie';

  @override
  String get productType => 'Typ Produktu';

  @override
  String get brand => 'Marka';

  @override
  String get premiumInsights => 'Premium Insights';

  @override
  String get researchArticles => 'Artykuły Badawcze';

  @override
  String get categoryRanking => 'Ranking Kategorii';

  @override
  String get safetyTrend => 'Trend Bezpieczeństwa';

  @override
  String get saveToFavorites => 'Zapisz';

  @override
  String get shareResults => 'Udostępnij';

  @override
  String get compareProducts => 'Porównaj';

  @override
  String get exportPDF => 'PDF';

  @override
  String get scanSimilar => 'Podobne';

  @override
  String get aiChatTitle => 'Skaner Kosmetyków AI';

  @override
  String get typeYourMessage => 'Wpisz swoją wiadomość...';

  @override
  String get errorSupabaseClientNotInitialized => 'Błąd: Klient Supabase nie został zainicjowany.';

  @override
  String get serverError => 'Błąd serwera:';

  @override
  String get networkErrorOccurred => 'Wystąpił błąd sieci. Spróbuj ponownie później.';

  @override
  String get sorryAnErrorOccurred => 'Przepraszamy, wystąpił błąd. Spróbuj ponownie.';

  @override
  String get couldNotGetResponse => 'Nie można uzyskać odpowiedzi.';

  @override
  String get aiAssistant => 'Asystent AI';

  @override
  String get online => 'Online';

  @override
  String get typing => 'Pisze...';

  @override
  String get writeAMessage => 'Napisz wiadomość...';

  @override
  String get hiIAmYourAIAssistantHowCanIHelp => 'Cześć! Jestem twoim asystentem AI. Jak mogę pomóc?';

  @override
  String get iCanSeeYourScanResultsFeelFreeToAskMeAnyQuestionsAboutTheIngredientsSafetyConcernsOrRecommendations => 'Widzę wyniki twojego skanowania! Śmiało zadawaj pytania o składniki, obawy dotyczące bezpieczeństwa lub rekomendacje.';

  @override
  String get userQuestion => 'Pytanie użytkownika:';

  @override
  String get databaseExplorer => 'Eksplorator Bazy Danych';

  @override
  String get currentUser => 'Bieżący Użytkownik:';

  @override
  String get notSignedIn => 'Niezalogowany';

  @override
  String get failedToFetchTables => 'Nie udało się pobrać tabel:';

  @override
  String get tablesInYourSupabaseDatabase => 'Tabele w twojej bazie danych Supabase:';

  @override
  String get viewSampleData => 'Wyświetl Przykładowe Dane';

  @override
  String get failedToFetchSampleDataFor => 'Nie udało się pobrać przykładowych danych dla';

  @override
  String get sampleData => 'Przykładowe Dane:';

  @override
  String get aiChats => 'Czaty SI';

  @override
  String get noDialoguesYet => 'Nie ma jeszcze dialogów.';

  @override
  String get startANewChat => 'Rozpocznij nowy czat!';

  @override
  String get created => 'Utworzono:';

  @override
  String get failedToSaveImage => 'Nie udało się zapisać obrazu:';

  @override
  String get editName => 'Edytuj Imię';

  @override
  String get enterYourName => 'Wprowadź swoje imię';

  @override
  String get cancel => 'Anuluj';

  @override
  String get premiumUser => 'Użytkownik Premium';

  @override
  String get freeUser => 'Użytkownik Bezpłatny';

  @override
  String get skinProfile => 'Profil Skóry';

  @override
  String get notSet => 'Nie ustawiono';

  @override
  String get legal => 'Prawne';

  @override
  String get privacyPolicy => 'Polityka Prywatności';

  @override
  String get termsOfService => 'Warunki Usługi';

  @override
  String get dataManagement => 'Zarządzanie Danymi';

  @override
  String get clearAllData => 'Wyczyść Wszystkie Dane';

  @override
  String get clearAllDataConfirmation => 'Czy na pewno chcesz usunąć wszystkie lokalne dane? Ta czynność nie może być cofnięta.';

  @override
  String get selectDataToClear => 'Wybierz dane do wyczyszczenia';

  @override
  String get scanResults => 'Wyniki Skanowania';

  @override
  String get chatHistory => 'Czaty';

  @override
  String get personalData => 'Dane Osobowe';

  @override
  String get clearData => 'Wyczyść Dane';

  @override
  String get allLocalDataHasBeenCleared => 'Dane zostały wyczyszczone.';

  @override
  String get signOut => 'Wyloguj się';

  @override
  String get deleteScan => 'Usuń Skanowanie';

  @override
  String get deleteScanConfirmation => 'Czy na pewno chcesz usunąć to skanowanie z historii?';

  @override
  String get deleteChat => 'Usuń Czat';

  @override
  String get deleteChatConfirmation => 'Czy na pewno chcesz usunąć ten czat? Wszystkie wiadomości zostaną utracone.';

  @override
  String get delete => 'Usuń';

  @override
  String get noScanHistoryFound => 'Nie znaleziono historii skanowania.';

  @override
  String get scanOn => 'Skanowanie';

  @override
  String get ingredientsFound => 'znalezionych składników';

  @override
  String get noCamerasFoundOnThisDevice => 'Nie znaleziono kamer na tym urządzeniu.';

  @override
  String get failedToInitializeCamera => 'Nie udało się zainicjować kamery:';

  @override
  String get analysisFailed => 'Analiza nie powiodła się:';

  @override
  String get analyzingPleaseWait => 'Analizowanie, proszę czekać...';

  @override
  String get positionTheLabelWithinTheFrame => 'Skup kamerę na liście składników';

  @override
  String get createAccount => 'Utwórz Konto';

  @override
  String get signUpToGetStarted => 'Zarejestruj się, aby rozpocząć';

  @override
  String get fullName => 'Pełne Imię';

  @override
  String get pleaseEnterYourName => 'Proszę wprowadzić swoje imię';

  @override
  String get email => 'E-mail';

  @override
  String get pleaseEnterYourEmail => 'Proszę wprowadzić swój e-mail';

  @override
  String get pleaseEnterAValidEmail => 'Proszę wprowadzić prawidłowy e-mail';

  @override
  String get password => 'Hasło';

  @override
  String get pleaseEnterYourPassword => 'Proszę wprowadzić swoje hasło';

  @override
  String get passwordMustBeAtLeast6Characters => 'Hasło musi mieć co najmniej 6 znaków';

  @override
  String get signUp => 'Zarejestruj się';

  @override
  String get orContinueWith => 'lub kontynuuj z';

  @override
  String get google => 'Google';

  @override
  String get apple => 'Apple';

  @override
  String get alreadyHaveAnAccount => 'Masz już konto? ';

  @override
  String get signIn => 'Zaloguj się';

  @override
  String get selectYourSkinTypeDescription => 'Wybierz swój typ skóry';

  @override
  String get normal => 'Normalna';

  @override
  String get normalSkinDescription => 'Zrównoważona, ani za tłusta, ani za sucha';

  @override
  String get dry => 'Sucha';

  @override
  String get drySkinDescription => 'Napięta, łuszcząca się, szorstka tekstura';

  @override
  String get oily => 'Tłusta';

  @override
  String get oilySkinDescription => 'Lśniąca, duże pory, skłonna do trądziku';

  @override
  String get combination => 'Mieszana';

  @override
  String get combinationSkinDescription => 'Tłusta strefa T, suche policzki';

  @override
  String get sensitive => 'Wrażliwa';

  @override
  String get sensitiveSkinDescription => 'Łatwo się drażni, skłonna do zaczerwienień';

  @override
  String get selectSkinType => 'Wybierz typ skóry';

  @override
  String get restore => 'Przywróć';

  @override
  String get restorePurchases => 'Przywróć Zakupy';

  @override
  String get subscriptionRestored => 'Subskrypcja została pomyślnie przywrócona!';

  @override
  String get noPurchasesToRestore => 'Brak zakupów do przywrócenia';

  @override
  String get goPremium => 'Przejdź na Premium';

  @override
  String get unlockExclusiveFeatures => 'Odblokuj ekskluzywne funkcje, aby w pełni wykorzystać analizę skóry.';

  @override
  String get unlimitedProductScans => 'Nieograniczone skanowanie produktów';

  @override
  String get advancedAIIngredientAnalysis => 'Zaawansowana Analiza Składników AI';

  @override
  String get fullScanAndSearchHistory => 'Pełna Historia Skanowania i Wyszukiwania';

  @override
  String get adFreeExperience => '100% Bez Reklam';

  @override
  String get yearly => 'Rocznie';

  @override
  String savePercentage(int percentage) {
    return 'Oszczędź $percentage%';
  }

  @override
  String get monthly => 'Miesięcznie';

  @override
  String get perMonth => '/ miesiąc';

  @override
  String get startFreeTrial => 'Rozpocznij Darmowy Okres Próbny';

  @override
  String trialDescription(String planName) {
    return '7-dniowy darmowy okres próbny, następnie $planName. Anuluj w dowolnym momencie.';
  }

  @override
  String get home => 'Główna';

  @override
  String get scan => 'Skaner';

  @override
  String get aiChatNav => 'Konsultant kosmetyczny';

  @override
  String get profileNav => 'Profil';

  @override
  String get doYouEnjoyOurApp => 'Czy podoba Ci się nasza aplikacja?';

  @override
  String get notReally => 'Nie';

  @override
  String get yesItsGreat => 'Podoba mi się';

  @override
  String get rateOurApp => 'Oceń naszą aplikację';

  @override
  String get bestRatingWeCanGet => 'Najlepsza ocena, jaką możemy otrzymać';

  @override
  String get rateOnGooglePlay => 'Oceń w Google Play';

  @override
  String get rate => 'Oceń';

  @override
  String get whatCanBeImproved => 'Co można poprawić?';

  @override
  String get wereSorryYouDidntHaveAGreatExperience => 'Przepraszamy, że nie miałeś świetnego doświadczenia. Powiedz nam, co poszło nie tak.';

  @override
  String get yourFeedback => 'Twoja opinia...';

  @override
  String get sendFeedback => 'Wyślij Opinię';

  @override
  String get thankYouForYourFeedback => 'Dziękujemy za Twoją opinię!';

  @override
  String get discussWithAI => 'Omów z AI';

  @override
  String get enterYourEmail => 'Wprowadź swój e-mail';

  @override
  String get enterYourPassword => 'Wprowadź swoje hasło';

  @override
  String get aiDisclaimer => 'Odpowiedzi AI mogą zawierać nieścisłości. Zweryfikuj krytyczne informacje.';

  @override
  String get applicationThemes => 'Motywy Aplikacji';

  @override
  String get highestRating => 'Najwyższa Ocena';

  @override
  String get selectYourAgeDescription => 'Wybierz swój wiek';

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
  String get ageRange18_25Description => 'Młoda skóra, prewencja';

  @override
  String get ageRange26_35Description => 'Pierwsze oznaki starzenia';

  @override
  String get ageRange36_45Description => 'Pielęgnacja przeciwstarzeniowa';

  @override
  String get ageRange46_55Description => 'Intensywna pielęgnacja';

  @override
  String get ageRange56PlusDescription => 'Specjalistyczna pielęgnacja';

  @override
  String get userName => 'Twoje Imię';

  @override
  String get yourName => 'Your Name';

  @override
  String get tryFreeAndSubscribe => 'Wypróbuj Za Darmo i Subskrybuj';

  @override
  String get personalAIConsultant => 'Osobisty Konsultant AI 24/7';

  @override
  String get subscribe => 'Subskrybuj';

  @override
  String get themes => 'Motywy';

  @override
  String get selectPreferredTheme => 'Wybierz swój ulubiony motyw';

  @override
  String get naturalTheme => 'Naturalny';

  @override
  String get darkTheme => 'Ciemny';

  @override
  String get darkNatural => 'Ciemny Naturalny';

  @override
  String get oceanTheme => 'Ocean';

  @override
  String get forestTheme => 'Las';

  @override
  String get sunsetTheme => 'Zachód Słońca';

  @override
  String get naturalThemeDescription => 'Naturalny motyw z ekologicznymi kolorami';

  @override
  String get darkThemeDescription => 'Ciemny motyw dla komfortu oczu';

  @override
  String get oceanThemeDescription => 'Świeży motyw oceanu';

  @override
  String get forestThemeDescription => 'Naturalny motyw lasu';

  @override
  String get sunsetThemeDescription => 'Ciepły motyw zachodu słońca';

  @override
  String get sunnyTheme => 'Słoneczny';

  @override
  String get sunnyThemeDescription => 'Jasny i radosny żółty motyw';

  @override
  String get vibrantTheme => 'Żywy';

  @override
  String get vibrantThemeDescription => 'Jasny różowy i fioletowy motyw';

  @override
  String get scanAnalysis => 'Analiza Skanowania';

  @override
  String get ingredients => 'składników';

  @override
  String get aiBotSettings => 'Ustawienia AI';

  @override
  String get botName => 'Nazwa Bota';

  @override
  String get enterBotName => 'Wprowadź nazwę bota';

  @override
  String get pleaseEnterBotName => 'Proszę wprowadzić nazwę bota';

  @override
  String get botDescription => 'Opis Bota';

  @override
  String get selectAvatar => 'Wybierz Awatar';

  @override
  String get defaultBotName => 'ACS';

  @override
  String defaultBotDescription(String name) {
    return 'Cześć! Jestem $name (Skaner Kosmetyków AI). Pomogę Ci zrozumieć skład Twoich kosmetyków. Posiadam szeroką wiedzę z zakresu kosmetologii i pielęgnacji skóry. Chętnie odpowiem na wszystkie Twoje pytania.';
  }

  @override
  String get settingsSaved => 'Ustawienia zostały pomyślnie zapisane';

  @override
  String get failedToSaveSettings => 'Nie udało się zapisać ustawień';

  @override
  String get resetToDefault => 'Resetuj do Domyślnych';

  @override
  String get resetSettings => 'Resetuj Ustawienia';

  @override
  String get resetSettingsConfirmation => 'Czy na pewno chcesz zresetować wszystkie ustawienia do wartości domyślnych?';

  @override
  String get settingsResetSuccessfully => 'Ustawienia zostały pomyślnie zresetowane';

  @override
  String get failedToResetSettings => 'Nie udało się zresetować ustawień';

  @override
  String get unsavedChanges => 'Niezapisane Zmiany';

  @override
  String get unsavedChangesMessage => 'Masz niezapisane zmiany. Czy na pewno chcesz wyjść?';

  @override
  String get stay => 'Zostań';

  @override
  String get leave => 'Wyjdź';

  @override
  String get errorLoadingSettings => 'Błąd wczytywania ustawień';

  @override
  String get retry => 'Spróbuj Ponownie';

  @override
  String get customPrompt => 'Specjalne Żądania';

  @override
  String get customPromptDescription => 'Dodaj spersonalizowane instrukcje dla asystenta AI';

  @override
  String get customPromptPlaceholder => 'Wprowadź swoje specjalne żądania...';

  @override
  String get enableCustomPrompt => 'Włącz specjalne żądania';

  @override
  String get defaultCustomPrompt => 'Daj mi komplementy.';

  @override
  String get close => 'Zamknij';

  @override
  String get scanningHintTitle => 'Jak Skanować';

  @override
  String get scanLimitReached => 'Osiągnięto Limit Skanowania';

  @override
  String get scanLimitReachedMessage => 'Wykorzystałeś wszystkie 5 darmowych skanowań w tym tygodniu. Przejdź na Premium dla nieograniczonego skanowania!';

  @override
  String get messageLimitReached => 'Osiągnięto Dzienny Limit Wiadomości';

  @override
  String get messageLimitReachedMessage => 'Wysłałeś dziś 5 wiadomości. Przejdź na Premium dla nieograniczonego czatu!';

  @override
  String get historyLimitReached => 'Ograniczony Dostęp do Historii';

  @override
  String get historyLimitReachedMessage => 'Przejdź na Premium, aby uzyskać dostęp do pełnej historii skanowania!';

  @override
  String get upgradeToPremium => 'Przejdź na Premium';

  @override
  String get upgradeToView => 'Przejdź na Premium, aby Wyświetlić';

  @override
  String get upgradeToChat => 'Przejdź na Premium, aby Czatować';

  @override
  String get premiumFeature => 'Funkcja Premium';

  @override
  String get freePlanUsage => 'Wykorzystanie Planu Darmowego';

  @override
  String get scansThisWeek => 'Skanowania w tym tygodniu';

  @override
  String get messagesToday => 'Wiadomości dzisiaj';

  @override
  String get limitsReached => 'Osiągnięte limity';

  @override
  String get remainingScans => 'Pozostałe skanowania';

  @override
  String get remainingMessages => 'Pozostałe wiadomości';

  @override
  String get unlockUnlimitedAccess => 'Odblokuj Nieograniczony Dostęp';

  @override
  String get upgradeToPremiumDescription => 'Uzyskaj nieograniczone skanowania, wiadomości i pełny dostęp do historii skanowania z Premium!';

  @override
  String get premiumBenefits => 'Korzyści Premium';

  @override
  String get unlimitedAiChatMessages => 'Nieograniczone wiadomości czatu AI';

  @override
  String get fullAccessToScanHistory => 'Pełny dostęp do historii skanowania';

  @override
  String get prioritySupport => 'Priorytetowe wsparcie';

  @override
  String get learnMore => 'Dowiedz Się Więcej';

  @override
  String get upgradeNow => 'Przejdź Teraz';

  @override
  String get maybeLater => 'Może Później';

  @override
  String get scanHistoryLimit => 'Tylko najnowsze skanowanie jest widoczne w historii';

  @override
  String get upgradeForUnlimitedScans => 'Przejdź na Premium dla nieograniczonego skanowania!';

  @override
  String get upgradeForUnlimitedChat => 'Przejdź na Premium dla nieograniczonego czatu!';

  @override
  String get slowInternetConnection => 'Wolne Połączenie Internetowe';

  @override
  String get slowInternetMessage => 'Przy bardzo wolnym połączeniu internetowym będziesz musiał trochę poczekać... Wciąż analizujemy Twój obraz.';

  @override
  String get revolutionaryAI => 'Rewolucyjna AI';

  @override
  String get revolutionaryAIDesc => 'Jedna z najmądrzejszych na świecie';

  @override
  String get unlimitedScans => 'Nieograniczone Skanowania';

  @override
  String get unlimitedScansDesc => 'Odkrywaj kosmetyki bez ograniczeń';

  @override
  String get unlimitedChats => 'Nieograniczone Czaty';

  @override
  String get unlimitedChatsDesc => 'Osobisty konsultant AI 24/7';

  @override
  String get fullHistory => 'Pełna Historia';

  @override
  String get fullHistoryDesc => 'Nieograniczona historia skanowania';

  @override
  String get rememberContext => 'Pamięta Kontekst';

  @override
  String get rememberContextDesc => 'AI pamięta Twoje poprzednie wiadomości';

  @override
  String get allIngredientsInfo => 'Wszystkie Informacje o Składnikach';

  @override
  String get allIngredientsInfoDesc => 'Poznaj wszystkie szczegóły';

  @override
  String get noAds => '100% Bez Reklam';

  @override
  String get noAdsDesc => 'Dla tych, którzy cenią swój czas';

  @override
  String get multiLanguage => 'Zna Prawie Wszystkie Języki';

  @override
  String get multiLanguageDesc => 'Ulepszony tłumacz';

  @override
  String get paywallTitle => 'Odblokuj sekrety swoich kosmetyków z AI';

  @override
  String paywallDescription(String price) {
    return 'Masz możliwość uzyskania subskrypcji Premium przez 3 dni za darmo, następnie $price tygodniowo. Anuluj w dowolnym momencie.';
  }

  @override
  String get whatsIncluded => 'Co Jest Zawarte';

  @override
  String get basicPlan => 'Podstawowy';

  @override
  String get premiumPlan => 'Premium';

  @override
  String get botGreeting1 => 'Dzień dobry! Jak mogę Ci dzisiaj pomóc?';

  @override
  String get botGreeting2 => 'Cześć! Co Cię do mnie sprowadza?';

  @override
  String get botGreeting3 => 'Witam! Gotowy do pomocy z analizą kosmetyków.';

  @override
  String get botGreeting4 => 'Cieszę się, że Cię widzę! W czym mogę być pomocny?';

  @override
  String get botGreeting5 => 'Witam! Odkryjmy razem skład Twoich kosmetyków.';

  @override
  String get botGreeting6 => 'Cześć! Gotowy do odpowiedzi na Twoje pytania o kosmetyki.';

  @override
  String get botGreeting7 => 'Cześć! Jestem Twoim osobistym asystentem kosmetologicznym.';

  @override
  String get botGreeting8 => 'Dzień dobry! Pomogę Ci zrozumieć skład produktów kosmetycznych.';

  @override
  String get botGreeting9 => 'Cześć! Uczyńmy razem Twoje kosmetyki bezpieczniejszymi.';

  @override
  String get botGreeting10 => 'Witam! Gotowy do dzielenia się wiedzą o kosmetykach.';

  @override
  String get botGreeting11 => 'Dzień dobry! Pomogę Ci znaleźć najlepsze rozwiązania kosmetyczne dla Ciebie.';

  @override
  String get botGreeting12 => 'Cześć! Twój ekspert od bezpieczeństwa kosmetyków do usług.';

  @override
  String get botGreeting13 => 'Cześć! Wybierzmy razem idealne kosmetyki dla Ciebie.';

  @override
  String get botGreeting14 => 'Witam! Gotowy do pomocy z analizą składników.';

  @override
  String get botGreeting15 => 'Cześć! Pomogę Ci zrozumieć skład Twoich kosmetyków.';

  @override
  String get botGreeting16 => 'Witam! Twój przewodnik w świecie kosmetologii jest gotowy do pomocy.';

  @override
  String get copiedToClipboard => 'Skopiowano do schowka';

  @override
  String get tryFree => 'Wypróbuj Za Darmo';

  @override
  String get cameraNotReady => 'Kamera nie jest gotowa / brak uprawnień';

  @override
  String get cameraPermissionInstructions => 'Ustawienia aplikacji:\nSkaner Kosmetyków AI > Uprawnienia > Kamera > Zezwól';

  @override
  String get openSettingsAndGrantAccess => 'Otwórz Ustawienia i przyznaj dostęp do kamery';

  @override
  String get retryCamera => 'Spróbuj Ponownie';

  @override
  String get errorServiceOverloaded => 'Usługa jest tymczasowo zajęta. Spróbuj ponownie za chwilę.';

  @override
  String get errorRateLimitExceeded => 'Zbyt wiele żądań. Poczekaj chwilę i spróbuj ponownie.';

  @override
  String get errorTimeout => 'Upłynął limit czasu żądania. Sprawdź połączenie internetowe i spróbuj ponownie.';

  @override
  String get errorNetwork => 'Błąd sieci. Sprawdź połączenie internetowe.';

  @override
  String get errorAuthentication => 'Błąd uwierzytelniania. Uruchom ponownie aplikację.';

  @override
  String get errorInvalidResponse => 'Otrzymano nieprawidłową odpowiedź. Spróbuj ponownie.';

  @override
  String get errorServer => 'Błąd serwera. Spróbuj ponownie później.';

  @override
  String get customThemes => 'Niestandardowe Motywy';

  @override
  String get createCustomTheme => 'Utwórz Niestandardowy Motyw';

  @override
  String get basedOn => 'Oparte na';

  @override
  String get lightMode => 'Jasny';

  @override
  String get generateWithAI => 'Wygeneruj z AI';

  @override
  String get resetToBaseTheme => 'Resetuj do Motywu Podstawowego';

  @override
  String colorsResetTo(Object themeName) {
    return 'Kolory zresetowane do $themeName';
  }

  @override
  String get aiGenerationComingSoon => 'Generowanie motywów AI już wkrótce w Iteracji 5!';

  @override
  String get onboardingGreeting => 'Witamy! Aby poprawić jakość odpowiedzi, skonfigurujmy Twój profil';

  @override
  String get letsGo => 'Zaczynajmy';

  @override
  String get next => 'Dalej';

  @override
  String get finish => 'Zakończ';

  @override
  String get customThemeInDevelopment => 'Funkcja niestandardowych motywów jest w trakcie rozwoju';

  @override
  String get customThemeComingSoon => 'Wkrótce w przyszłych aktualizacjach';

  @override
  String get dailyMessageLimitReached => 'Osiągnięto Limit';

  @override
  String get dailyMessageLimitReachedMessage => 'Wysłałeś dziś 5 wiadomości. Przejdź na Premium dla nieograniczonego czatu!';

  @override
  String get upgradeToPremiumForUnlimitedChat => 'Przejdź na Premium dla nieograniczonego czatu';

  @override
  String get messagesLeftToday => 'wiadomości pozostało dzisiaj';

  @override
  String get designYourOwnTheme => 'Zaprojektuj własny motyw';

  @override
  String get darkOcean => 'Ciemny Ocean';

  @override
  String get darkForest => 'Ciemny Las';

  @override
  String get darkSunset => 'Ciemny Zachód Słońca';

  @override
  String get darkVibrant => 'Ciemny Żywy';

  @override
  String get darkOceanThemeDescription => 'Ciemny motyw oceanu z akcentami cyjanowymi';

  @override
  String get darkForestThemeDescription => 'Ciemny motyw lasu z akcentami limonkowo-zielonymi';

  @override
  String get darkSunsetThemeDescription => 'Ciemny motyw zachodu słońca z akcentami pomarańczowymi';

  @override
  String get darkVibrantThemeDescription => 'Ciemny żywy motyw z akcentami różowymi i fioletowymi';

  @override
  String get customTheme => 'Niestandardowy motyw';

  @override
  String get edit => 'Edytuj';

  @override
  String get deleteTheme => 'Usuń Motyw';

  @override
  String deleteThemeConfirmation(String themeName) {
    return 'Czy na pewno chcesz usunąć \"$themeName\"?';
  }

  @override
  String get pollTitle => 'Czego brakuje?';

  @override
  String get pollCardTitle => 'Czego brakuje w aplikacji?';

  @override
  String get pollDescription => 'Głosuj na opcje, które chcesz zobaczyć';

  @override
  String get submitVote => 'Głosuj';

  @override
  String get submitting => 'Wysyłanie...';

  @override
  String get voteSubmittedSuccess => 'Głosy zostały pomyślnie wysłane!';

  @override
  String votesRemaining(int count) {
    return 'Pozostało $count głosów';
  }

  @override
  String get votes => 'głosy';

  @override
  String get addYourOption => 'Zaproponuj ulepszenie';

  @override
  String get enterYourOption => 'Wprowadź swoją opcję...';

  @override
  String get add => 'Dodaj';

  @override
  String get filterTopVoted => 'Popularne';

  @override
  String get filterNewest => 'Nowe';

  @override
  String get filterMyOption => 'Mój Wybór';

  @override
  String get thankYouForVoting => 'Dziękujemy za głosowanie!';

  @override
  String get votingComplete => 'Twój głos został zarejestrowany';

  @override
  String get requestFeatureDevelopment => 'Poproś o Rozwój Niestandardowej Funkcji';

  @override
  String get requestFeatureDescription => 'Potrzebujesz konkretnej funkcji? Skontaktuj się z nami, aby omówić niestandardowy rozwój dla Twoich potrzeb biznesowych.';

  @override
  String get pollHelpTitle => 'Jak głosować';

  @override
  String get pollHelpDescription => '• Dotknij opcję, aby ją wybrać\n• Dotknij ponownie, aby cofnąć wybór\n• Wybierz tyle opcji, ile chcesz\n• Kliknij przycisk \'Głosuj\', aby wysłać swoje głosy\n• Dodaj własną opcję, jeśli nie widzisz tego, czego potrzebujesz';

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
