// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appName => 'AI 화장품 스캐너';

  @override
  String get skinAnalysis => '피부 분석';

  @override
  String get checkYourCosmetics => '화장품을 확인하세요';

  @override
  String get startScanning => '스캔 시작';

  @override
  String get quickActions => '빠른 작업';

  @override
  String get scanHistory => '스캔 기록';

  @override
  String get aiChat => 'AI 화장품 스캐너';

  @override
  String get profile => '프로필';

  @override
  String get settings => '설정';

  @override
  String get skinType => '피부 타입';

  @override
  String get allergiesSensitivities => '알레르기 및 민감성';

  @override
  String get subscription => '구독';

  @override
  String get age => '나이';

  @override
  String get language => '언어';

  @override
  String get selectYourPreferredLanguage => '원하는 언어를 선택하세요';

  @override
  String get save => '저장';

  @override
  String get selectIngredientsAllergicSensitive => '민감한 성분을 선택하세요';

  @override
  String get commonAllergens => '일반 알레르기 유발 물질';

  @override
  String get fragrance => '향료';

  @override
  String get parabens => '파라벤';

  @override
  String get sulfates => '황산염';

  @override
  String get alcohol => '알코올';

  @override
  String get essentialOils => '에센셜 오일';

  @override
  String get silicones => '실리콘';

  @override
  String get mineralOil => '미네랄 오일';

  @override
  String get formaldehyde => '포름알데히드';

  @override
  String get addCustomAllergen => '맞춤 알레르기 유발 물질 추가';

  @override
  String get typeIngredientName => '성분 이름을 입력하세요...';

  @override
  String get selectedAllergens => '선택한 알레르기 유발 물질';

  @override
  String saveSelected(int count) {
    return '저장 ($count개 선택됨)';
  }

  @override
  String get analysisResults => '분석 결과';

  @override
  String get overallSafetyScore => '전체 안전성 점수';

  @override
  String get personalizedWarnings => '맞춤형 경고';

  @override
  String ingredientsAnalysis(int count) {
    return '성분 분석 ($count개)';
  }

  @override
  String get highRisk => '고위험';

  @override
  String get moderateRisk => '중위험';

  @override
  String get lowRisk => '저위험';

  @override
  String get benefitsAnalysis => '효능 분석';

  @override
  String get recommendedAlternatives => '추천 대체품';

  @override
  String get reason => '이유:';

  @override
  String get quickSummary => '빠른 요약';

  @override
  String get ingredientsChecked => '성분 확인됨';

  @override
  String get personalWarnings => '개인 경고';

  @override
  String get ourVerdict => '종합 평가';

  @override
  String get productInfo => '제품 정보';

  @override
  String get productType => '제품 유형';

  @override
  String get brand => '브랜드';

  @override
  String get premiumInsights => '프리미엄 인사이트';

  @override
  String get researchArticles => '연구 논문';

  @override
  String get categoryRanking => '카테고리 순위';

  @override
  String get safetyTrend => '안전성 트렌드';

  @override
  String get saveToFavorites => '저장';

  @override
  String get shareResults => '공유';

  @override
  String get compareProducts => '비교';

  @override
  String get exportPDF => 'PDF';

  @override
  String get scanSimilar => '유사';

  @override
  String get aiChatTitle => 'AI 화장품 스캐너';

  @override
  String get typeYourMessage => '메시지를 입력하세요...';

  @override
  String get errorSupabaseClientNotInitialized => '오류: Supabase 클라이언트가 초기화되지 않았습니다.';

  @override
  String get serverError => '서버 오류:';

  @override
  String get networkErrorOccurred => '네트워크 오류가 발생했습니다. 나중에 다시 시도해 주세요.';

  @override
  String get sorryAnErrorOccurred => '죄송합니다. 오류가 발생했습니다. 다시 시도해 주세요.';

  @override
  String get couldNotGetResponse => '응답을 받을 수 없습니다.';

  @override
  String get aiAssistant => 'AI 어시스턴트';

  @override
  String get online => '온라인';

  @override
  String get typing => '입력 중...';

  @override
  String get writeAMessage => '메시지를 작성하세요...';

  @override
  String get hiIAmYourAIAssistantHowCanIHelp => '안녕하세요! AI 어시스턴트입니다. 무엇을 도와드릴까요?';

  @override
  String get iCanSeeYourScanResultsFeelFreeToAskMeAnyQuestionsAboutTheIngredientsSafetyConcernsOrRecommendations => '스캔 결과를 확인했습니다! 성분, 안전성 문제 또는 추천에 대해 자유롭게 질문해 주세요.';

  @override
  String get userQuestion => '사용자 질문:';

  @override
  String get databaseExplorer => '데이터베이스 탐색기';

  @override
  String get currentUser => '현재 사용자:';

  @override
  String get notSignedIn => '로그인하지 않음';

  @override
  String get failedToFetchTables => '테이블을 가져오지 못했습니다:';

  @override
  String get tablesInYourSupabaseDatabase => 'Supabase 데이터베이스의 테이블:';

  @override
  String get viewSampleData => '샘플 데이터 보기';

  @override
  String get failedToFetchSampleDataFor => '샘플 데이터를 가져오지 못했습니다:';

  @override
  String get sampleData => '샘플 데이터:';

  @override
  String get aiChats => 'AI 채팅';

  @override
  String get noDialoguesYet => '아직 대화가 없습니다.';

  @override
  String get startANewChat => '새 채팅을 시작하세요!';

  @override
  String get created => '생성일:';

  @override
  String get failedToSaveImage => '이미지를 저장하지 못했습니다:';

  @override
  String get editName => '이름 편집';

  @override
  String get enterYourName => '이름을 입력하세요';

  @override
  String get cancel => '취소';

  @override
  String get premiumUser => '프리미엄 사용자';

  @override
  String get freeUser => '무료 사용자';

  @override
  String get skinProfile => '스킨 프로필';

  @override
  String get notSet => '설정되지 않음';

  @override
  String get legal => '법적 정보';

  @override
  String get privacyPolicy => '개인정보 보호정책';

  @override
  String get termsOfService => '서비스 약관';

  @override
  String get dataManagement => '데이터 관리';

  @override
  String get clearAllData => '모든 데이터 지우기';

  @override
  String get clearAllDataConfirmation => '모든 로컬 데이터를 삭제하시겠습니까? 이 작업은 취소할 수 없습니다.';

  @override
  String get selectDataToClear => '지울 데이터를 선택하세요';

  @override
  String get scanResults => '스캔 결과';

  @override
  String get chatHistory => '채팅';

  @override
  String get personalData => '개인 데이터';

  @override
  String get clearData => '데이터 지우기';

  @override
  String get allLocalDataHasBeenCleared => '데이터가 지워졌습니다.';

  @override
  String get signOut => '로그아웃';

  @override
  String get deleteScan => '스캔 삭제';

  @override
  String get deleteScanConfirmation => '기록에서 이 스캔을 삭제하시겠습니까?';

  @override
  String get deleteChat => '채팅 삭제';

  @override
  String get deleteChatConfirmation => '이 채팅을 삭제하시겠습니까? 모든 메시지가 손실됩니다.';

  @override
  String get delete => '삭제';

  @override
  String get noScanHistoryFound => '스캔 기록을 찾을 수 없습니다.';

  @override
  String get scanOn => '스캔 날짜:';

  @override
  String get ingredientsFound => '성분 발견됨';

  @override
  String get noCamerasFoundOnThisDevice => '이 기기에서 카메라를 찾을 수 없습니다.';

  @override
  String get failedToInitializeCamera => '카메라를 초기화하지 못했습니다:';

  @override
  String get analysisFailed => '분석 실패:';

  @override
  String get analyzingPleaseWait => '분석 중입니다. 잠시만 기다려 주세요...';

  @override
  String get positionTheLabelWithinTheFrame => '성분 목록에 카메라를 맞추세요';

  @override
  String get createAccount => '계정 만들기';

  @override
  String get signUpToGetStarted => '가입하여 시작하세요';

  @override
  String get fullName => '이름';

  @override
  String get pleaseEnterYourName => '이름을 입력해 주세요';

  @override
  String get email => '이메일';

  @override
  String get pleaseEnterYourEmail => '이메일을 입력해 주세요';

  @override
  String get pleaseEnterAValidEmail => '유효한 이메일을 입력해 주세요';

  @override
  String get password => '비밀번호';

  @override
  String get pleaseEnterYourPassword => '비밀번호를 입력해 주세요';

  @override
  String get passwordMustBeAtLeast6Characters => '비밀번호는 최소 6자 이상이어야 합니다';

  @override
  String get signUp => '가입';

  @override
  String get orContinueWith => '또는 다음으로 계속';

  @override
  String get google => 'Google';

  @override
  String get apple => 'Apple';

  @override
  String get alreadyHaveAnAccount => '이미 계정이 있으신가요? ';

  @override
  String get signIn => '로그인';

  @override
  String get selectYourSkinTypeDescription => '피부 타입을 선택하세요';

  @override
  String get normal => '중성';

  @override
  String get normalSkinDescription => '균형잡힌, 너무 지성이거나 건성이 아닌';

  @override
  String get dry => '건성';

  @override
  String get drySkinDescription => '당기는, 각질이 생기는, 거친 질감';

  @override
  String get oily => '지성';

  @override
  String get oilySkinDescription => '번들거리는, 넓은 모공, 여드름이 나기 쉬운';

  @override
  String get combination => '복합성';

  @override
  String get combinationSkinDescription => 'T존은 지성, 볼은 건성';

  @override
  String get sensitive => '민감성';

  @override
  String get sensitiveSkinDescription => '쉽게 자극받는, 붉어지기 쉬운';

  @override
  String get selectSkinType => '피부 타입 선택';

  @override
  String get restore => '복원';

  @override
  String get restorePurchases => '구매 복원';

  @override
  String get subscriptionRestored => '구독이 성공적으로 복원되었습니다!';

  @override
  String get noPurchasesToRestore => '복원할 구매가 없습니다';

  @override
  String get goPremium => '프리미엄으로 업그레이드';

  @override
  String get unlockExclusiveFeatures => '독점 기능을 잠금 해제하여 피부 분석을 최대한 활용하세요.';

  @override
  String get unlimitedProductScans => '무제한 제품 스캔';

  @override
  String get advancedAIIngredientAnalysis => '고급 AI 성분 분석';

  @override
  String get fullScanAndSearchHistory => '전체 스캔 및 검색 기록';

  @override
  String get adFreeExperience => '100% 광고 없음';

  @override
  String get yearly => '연간';

  @override
  String savePercentage(int percentage) {
    return '$percentage% 절약';
  }

  @override
  String get monthly => '월간';

  @override
  String get perMonth => '/ 월';

  @override
  String get startFreeTrial => '무료 체험 시작';

  @override
  String trialDescription(String planName) {
    return '7일 무료 체험, 그 후 $planName로 청구됩니다. 언제든지 취소할 수 있습니다.';
  }

  @override
  String get home => '홈';

  @override
  String get scan => '스캐너';

  @override
  String get aiChatNav => '컨설턴트';

  @override
  String get profileNav => '프로필';

  @override
  String get doYouEnjoyOurApp => '앱이 마음에 드시나요?';

  @override
  String get notReally => '아니요';

  @override
  String get yesItsGreat => '좋아요';

  @override
  String get rateOurApp => '앱 평가하기';

  @override
  String get bestRatingWeCanGet => '최고의 평가를 받을 수 있습니다';

  @override
  String get rateOnGooglePlay => 'Google Play에서 평가하기';

  @override
  String get rate => '평가';

  @override
  String get whatCanBeImproved => '개선할 점은 무엇인가요?';

  @override
  String get wereSorryYouDidntHaveAGreatExperience => '만족스럽지 못한 경험을 드려 죄송합니다. 무엇이 잘못되었는지 알려주세요.';

  @override
  String get yourFeedback => '피드백...';

  @override
  String get sendFeedback => '피드백 보내기';

  @override
  String get thankYouForYourFeedback => '피드백 감사합니다!';

  @override
  String get discussWithAI => 'AI와 상담하기';

  @override
  String get enterYourEmail => '이메일을 입력하세요';

  @override
  String get enterYourPassword => '비밀번호를 입력하세요';

  @override
  String get aiDisclaimer => 'AI 응답에는 부정확한 내용이 포함될 수 있습니다. 중요한 정보는 확인해 주세요.';

  @override
  String get applicationThemes => '애플리케이션 테마';

  @override
  String get highestRating => '최고 평점';

  @override
  String get selectYourAgeDescription => '나이를 선택하세요';

  @override
  String get ageRange18_25 => '18-25세';

  @override
  String get ageRange26_35 => '26-35세';

  @override
  String get ageRange36_45 => '36-45세';

  @override
  String get ageRange46_55 => '46-55세';

  @override
  String get ageRange56Plus => '56세 이상';

  @override
  String get ageRange18_25Description => '젊은 피부, 예방 케어';

  @override
  String get ageRange26_35Description => '첫 노화 징후';

  @override
  String get ageRange36_45Description => '안티에이징 케어';

  @override
  String get ageRange46_55Description => '집중 케어';

  @override
  String get ageRange56PlusDescription => '전문 케어';

  @override
  String get userName => '이름';

  @override
  String get yourName => 'Your Name';

  @override
  String get tryFreeAndSubscribe => '무료 체험 및 구독';

  @override
  String get personalAIConsultant => '24시간 개인 AI 컨설턴트';

  @override
  String get subscribe => '구독';

  @override
  String get themes => '테마';

  @override
  String get selectPreferredTheme => '원하는 테마를 선택하세요';

  @override
  String get naturalTheme => '내추럴';

  @override
  String get darkTheme => '다크';

  @override
  String get darkNatural => '다크 내추럴';

  @override
  String get oceanTheme => '오션';

  @override
  String get forestTheme => '포레스트';

  @override
  String get sunsetTheme => '선셋';

  @override
  String get naturalThemeDescription => '친환경 색상의 내추럴 테마';

  @override
  String get darkThemeDescription => '눈의 편안함을 위한 다크 테마';

  @override
  String get oceanThemeDescription => '상쾌한 오션 테마';

  @override
  String get forestThemeDescription => '자연스러운 포레스트 테마';

  @override
  String get sunsetThemeDescription => '따뜻한 선셋 테마';

  @override
  String get sunnyTheme => '써니';

  @override
  String get sunnyThemeDescription => '밝고 쾌활한 노란색 테마';

  @override
  String get vibrantTheme => '비브런트';

  @override
  String get vibrantThemeDescription => '밝은 핑크와 퍼플 테마';

  @override
  String get scanAnalysis => '스캔 분석';

  @override
  String get ingredients => '성분';

  @override
  String get aiBotSettings => 'AI 설정';

  @override
  String get botName => '봇 이름';

  @override
  String get enterBotName => '봇 이름을 입력하세요';

  @override
  String get pleaseEnterBotName => '봇 이름을 입력해 주세요';

  @override
  String get botDescription => '봇 설명';

  @override
  String get selectAvatar => '아바타 선택';

  @override
  String get defaultBotName => 'ACS';

  @override
  String defaultBotDescription(String name) {
    return '안녕하세요! 저는 $name(AI 화장품 스캐너)입니다. 화장품의 성분을 이해하는 데 도움을 드리겠습니다. 저는 화장품학과 스킨케어 분야에 대한 광범위한 지식을 가지고 있습니다. 모든 질문에 기꺼이 답변해 드리겠습니다.';
  }

  @override
  String get settingsSaved => '설정이 성공적으로 저장되었습니다';

  @override
  String get failedToSaveSettings => '설정 저장에 실패했습니다';

  @override
  String get resetToDefault => '기본값으로 재설정';

  @override
  String get resetSettings => '설정 재설정';

  @override
  String get resetSettingsConfirmation => '모든 설정을 기본값으로 재설정하시겠습니까?';

  @override
  String get settingsResetSuccessfully => '설정이 성공적으로 재설정되었습니다';

  @override
  String get failedToResetSettings => '설정 재설정에 실패했습니다';

  @override
  String get unsavedChanges => '저장되지 않은 변경사항';

  @override
  String get unsavedChangesMessage => '저장되지 않은 변경사항이 있습니다. 정말 나가시겠습니까?';

  @override
  String get stay => '머물기';

  @override
  String get leave => '나가기';

  @override
  String get errorLoadingSettings => '설정 로딩 오류';

  @override
  String get retry => '다시 시도';

  @override
  String get customPrompt => '특별 요청';

  @override
  String get customPromptDescription => 'AI 어시스턴트에 대한 맞춤 지침 추가';

  @override
  String get customPromptPlaceholder => '특별 요청을 입력하세요...';

  @override
  String get enableCustomPrompt => '특별 요청 활성화';

  @override
  String get defaultCustomPrompt => '칭찬해 주세요.';

  @override
  String get close => '닫기';

  @override
  String get scanningHintTitle => '스캔 방법';

  @override
  String get scanLimitReached => '스캔 제한 도달';

  @override
  String get scanLimitReachedMessage => '이번 주 무료 스캔 5회를 모두 사용했습니다. 무제한 스캔을 위해 프리미엄으로 업그레이드하세요!';

  @override
  String get messageLimitReached => '일일 메시지 제한 도달';

  @override
  String get messageLimitReachedMessage => '오늘 5개의 메시지를 보냈습니다. 무제한 채팅을 위해 프리미엄으로 업그레이드하세요!';

  @override
  String get historyLimitReached => '기록 액세스 제한';

  @override
  String get historyLimitReachedMessage => '전체 스캔 기록에 액세스하려면 프리미엄으로 업그레이드하세요!';

  @override
  String get upgradeToPremium => '프리미엄으로 업그레이드';

  @override
  String get upgradeToView => '보기 위해 업그레이드';

  @override
  String get upgradeToChat => '채팅하기 위해 업그레이드';

  @override
  String get premiumFeature => '프리미엄 기능';

  @override
  String get freePlanUsage => '무료 플랜 사용량';

  @override
  String get scansThisWeek => '이번 주 스캔';

  @override
  String get messagesToday => '오늘 메시지';

  @override
  String get limitsReached => '제한 도달';

  @override
  String get remainingScans => '남은 스캔';

  @override
  String get remainingMessages => '남은 메시지';

  @override
  String get unlockUnlimitedAccess => '무제한 액세스 잠금 해제';

  @override
  String get upgradeToPremiumDescription => '프리미엄으로 무제한 스캔, 메시지 및 전체 스캔 기록에 대한 액세스를 얻으세요!';

  @override
  String get premiumBenefits => '프리미엄 혜택';

  @override
  String get unlimitedAiChatMessages => '무제한 AI 채팅 메시지';

  @override
  String get fullAccessToScanHistory => '스캔 기록에 대한 전체 액세스';

  @override
  String get prioritySupport => '우선 지원';

  @override
  String get learnMore => '자세히 알아보기';

  @override
  String get upgradeNow => '지금 업그레이드';

  @override
  String get maybeLater => '나중에';

  @override
  String get scanHistoryLimit => '기록에서 가장 최근 스캔만 표시됩니다';

  @override
  String get upgradeForUnlimitedScans => '무제한 스캔을 위해 업그레이드하세요!';

  @override
  String get upgradeForUnlimitedChat => '무제한 채팅을 위해 업그레이드하세요!';

  @override
  String get slowInternetConnection => '느린 인터넷 연결';

  @override
  String get slowInternetMessage => '매우 느린 인터넷 연결에서는 잠시 기다려야 합니다... 아직 이미지를 분석 중입니다.';

  @override
  String get revolutionaryAI => '혁신적인 AI';

  @override
  String get revolutionaryAIDesc => '세계에서 가장 똑똑한 AI 중 하나';

  @override
  String get unlimitedScans => '무제한 스캔';

  @override
  String get unlimitedScansDesc => '제한 없이 화장품 탐색';

  @override
  String get unlimitedChats => '무제한 채팅';

  @override
  String get unlimitedChatsDesc => '24시간 개인 AI 컨설턴트';

  @override
  String get fullHistory => '전체 기록';

  @override
  String get fullHistoryDesc => '무제한 스캔 기록';

  @override
  String get rememberContext => '맥락 기억';

  @override
  String get rememberContextDesc => 'AI가 이전 메시지를 기억합니다';

  @override
  String get allIngredientsInfo => '모든 성분 정보';

  @override
  String get allIngredientsInfoDesc => '모든 세부 사항 배우기';

  @override
  String get noAds => '100% 광고 없음';

  @override
  String get noAdsDesc => '시간을 소중히 여기는 분들을 위해';

  @override
  String get multiLanguage => '거의 모든 언어 구사';

  @override
  String get multiLanguageDesc => '향상된 번역기';

  @override
  String get paywallTitle => 'AI로 화장품의 비밀을 밝히세요';

  @override
  String paywallDescription(String price) {
    return '3일 무료로 프리미엄 구독을 받을 수 있는 기회가 있으며, 그 후 주당 $price입니다. 언제든지 취소할 수 있습니다.';
  }

  @override
  String get whatsIncluded => '포함 사항';

  @override
  String get basicPlan => '기본';

  @override
  String get premiumPlan => '프리미엄';

  @override
  String get botGreeting1 => '안녕하세요! 오늘 어떻게 도와드릴까요?';

  @override
  String get botGreeting2 => '안녕하세요! 무엇 때문에 오셨나요?';

  @override
  String get botGreeting3 => '환영합니다! 화장품 분석을 도와드릴 준비가 되었습니다.';

  @override
  String get botGreeting4 => '만나서 반갑습니다! 어떻게 도움을 드릴까요?';

  @override
  String get botGreeting5 => '환영합니다! 함께 화장품 성분을 살펴봅시다.';

  @override
  String get botGreeting6 => '안녕하세요! 화장품에 관한 질문에 답변할 준비가 되었습니다.';

  @override
  String get botGreeting7 => '안녕하세요! 개인 화장품 어시스턴트입니다.';

  @override
  String get botGreeting8 => '안녕하세요! 화장품 성분을 이해하는 데 도움을 드리겠습니다.';

  @override
  String get botGreeting9 => '안녕하세요! 함께 화장품을 더 안전하게 만들어봅시다.';

  @override
  String get botGreeting10 => '환영합니다! 화장품에 대한 지식을 공유할 준비가 되었습니다.';

  @override
  String get botGreeting11 => '안녕하세요! 최적의 화장품 솔루션을 찾도록 도와드리겠습니다.';

  @override
  String get botGreeting12 => '안녕하세요! 화장품 안전 전문가가 서비스를 제공합니다.';

  @override
  String get botGreeting13 => '안녕하세요! 함께 완벽한 화장품을 선택해 봅시다.';

  @override
  String get botGreeting14 => '환영합니다! 성분 분석을 도와드릴 준비가 되었습니다.';

  @override
  String get botGreeting15 => '안녕하세요! 화장품 성분을 이해하는 데 도움을 드리겠습니다.';

  @override
  String get botGreeting16 => '환영합니다! 화장품 세계의 가이드가 도움을 드릴 준비가 되었습니다.';

  @override
  String get copiedToClipboard => '클립보드에 복사됨';

  @override
  String get tryFree => '무료 체험';

  @override
  String get cameraNotReady => '카메라가 준비되지 않음 / 권한 없음';

  @override
  String get cameraPermissionInstructions => '앱 설정:\nAI 화장품 스캐너 > 권한 > 카메라 > 허용';

  @override
  String get openSettingsAndGrantAccess => '설정을 열고 카메라 액세스 권한을 부여하세요';

  @override
  String get retryCamera => '다시 시도';

  @override
  String get errorServiceOverloaded => '서비스가 일시적으로 사용 중입니다. 잠시 후 다시 시도해 주세요.';

  @override
  String get errorRateLimitExceeded => '요청이 너무 많습니다. 잠시 기다렸다가 다시 시도해 주세요.';

  @override
  String get errorTimeout => '요청 시간이 초과되었습니다. 인터넷 연결을 확인하고 다시 시도해 주세요.';

  @override
  String get errorNetwork => '네트워크 오류. 인터넷 연결을 확인해 주세요.';

  @override
  String get errorAuthentication => '인증 오류. 앱을 다시 시작해 주세요.';

  @override
  String get errorInvalidResponse => '잘못된 응답을 받았습니다. 다시 시도해 주세요.';

  @override
  String get errorServer => '서버 오류. 나중에 다시 시도해 주세요.';

  @override
  String get customThemes => '커스텀 테마';

  @override
  String get createCustomTheme => '커스텀 테마 만들기';

  @override
  String get basedOn => '기반';

  @override
  String get lightMode => '라이트';

  @override
  String get generateWithAI => 'AI로 생성';

  @override
  String get resetToBaseTheme => '기본 테마로 재설정';

  @override
  String colorsResetTo(Object themeName) {
    return '색상이 $themeName(으)로 재설정됨';
  }

  @override
  String get aiGenerationComingSoon => 'AI 테마 생성은 반복 5에서 제공됩니다!';

  @override
  String get onboardingGreeting => '환영합니다! 답변의 질을 향상시키기 위해 프로필을 설정하겠습니다';

  @override
  String get letsGo => '시작하기';

  @override
  String get next => '다음';

  @override
  String get finish => '완료';

  @override
  String get customThemeInDevelopment => '커스텀 테마 기능은 개발 중입니다';

  @override
  String get customThemeComingSoon => '향후 업데이트에서 제공 예정';

  @override
  String get dailyMessageLimitReached => '제한 도달';

  @override
  String get dailyMessageLimitReachedMessage => '오늘 5개의 메시지를 보냈습니다. 무제한 채팅을 위해 프리미엄으로 업그레이드하세요!';

  @override
  String get upgradeToPremiumForUnlimitedChat => '무제한 채팅을 위해 프리미엄으로 업그레이드';

  @override
  String get messagesLeftToday => '오늘 남은 메시지';

  @override
  String get designYourOwnTheme => '나만의 테마 디자인';

  @override
  String get darkOcean => '다크 오션';

  @override
  String get darkForest => '다크 포레스트';

  @override
  String get darkSunset => '다크 선셋';

  @override
  String get darkVibrant => '다크 비브런트';

  @override
  String get darkOceanThemeDescription => '시안 액센트의 다크 오션 테마';

  @override
  String get darkForestThemeDescription => '라임 그린 액센트의 다크 포레스트 테마';

  @override
  String get darkSunsetThemeDescription => '오렌지 액센트의 다크 선셋 테마';

  @override
  String get darkVibrantThemeDescription => '핑크와 퍼플 액센트의 다크 비브런트 테마';

  @override
  String get customTheme => '커스텀 테마';

  @override
  String get edit => '편집';

  @override
  String get deleteTheme => '테마 삭제';

  @override
  String deleteThemeConfirmation(String themeName) {
    return '\"$themeName\"을(를) 삭제하시겠습니까?';
  }

  @override
  String get pollTitle => '무엇이 빠졌나요?';

  @override
  String get pollCardTitle => '앱에 무엇이 빠졌나요?';

  @override
  String get pollDescription => '원하는 옵션에 투표하세요';

  @override
  String get submitVote => '투표';

  @override
  String get submitting => '제출 중...';

  @override
  String get voteSubmittedSuccess => '투표가 성공적으로 제출되었습니다!';

  @override
  String votesRemaining(int count) {
    return '$count표 남음';
  }

  @override
  String get votes => '표';

  @override
  String get addYourOption => '개선 제안';

  @override
  String get enterYourOption => '옵션을 입력하세요...';

  @override
  String get add => '추가';

  @override
  String get filterTopVoted => '인기';

  @override
  String get filterNewest => '새로운';

  @override
  String get filterMyOption => '내 선택';

  @override
  String get thankYouForVoting => '투표해 주셔서 감사합니다!';

  @override
  String get votingComplete => '투표가 기록되었습니다';

  @override
  String get requestFeatureDevelopment => '맞춤 기능 개발 요청';

  @override
  String get requestFeatureDescription => '특정 기능이 필요하신가요? 비즈니스 요구에 맞는 맞춤 개발에 대해 문의하세요.';

  @override
  String get pollHelpTitle => '투표 방법';

  @override
  String get pollHelpDescription => '• 옵션을 탭하여 선택\n• 다시 탭하여 선택 취소\n• 원하는 만큼 선택\n• \'투표\' 버튼을 클릭하여 투표 제출\n• 필요한 것이 없으면 직접 옵션을 추가';

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
