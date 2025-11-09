// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'ماسح مستحضرات التجميل بالذكاء الاصطناعي';

  @override
  String get skinAnalysis => 'تحليل البشرة';

  @override
  String get checkYourCosmetics => 'افحص مستحضرات التجميل الخاصة بك';

  @override
  String get startScanning => 'ابدأ المسح';

  @override
  String get quickActions => 'إجراءات سريعة';

  @override
  String get scanHistory => 'سجل المسح';

  @override
  String get aiChat => 'ماسح مستحضرات التجميل بالذكاء الاصطناعي';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get settings => 'الإعدادات';

  @override
  String get skinType => 'نوع البشرة';

  @override
  String get allergiesSensitivities => 'الحساسية والحساسيات';

  @override
  String get subscription => 'الاشتراك';

  @override
  String get age => 'العمر';

  @override
  String get language => 'اللغة';

  @override
  String get selectYourPreferredLanguage => 'اختر لغتك المفضلة';

  @override
  String get save => 'حفظ';

  @override
  String get language_en => 'الإنجليزية';

  @override
  String get language_ru => 'الروسية';

  @override
  String get language_uk => 'الأوكرانية';

  @override
  String get language_es => 'الإسبانية';

  @override
  String get language_de => 'الألمانية';

  @override
  String get language_fr => 'الفرنسية';

  @override
  String get language_it => 'الإيطالية';

  @override
  String get selectIngredientsAllergicSensitive => 'اختر المكونات التي لديك حساسية متزايدة تجاهها';

  @override
  String get commonAllergens => 'مسببات الحساسية الشائعة';

  @override
  String get fragrance => 'العطر';

  @override
  String get parabens => 'البارابين';

  @override
  String get sulfates => 'الكبريتات';

  @override
  String get alcohol => 'الكحول';

  @override
  String get essentialOils => 'الزيوت الأساسية';

  @override
  String get silicones => 'السيليكون';

  @override
  String get mineralOil => 'الزيت المعدني';

  @override
  String get formaldehyde => 'الفورمالديهايد';

  @override
  String get addCustomAllergen => 'إضافة مسبب حساسية مخصص';

  @override
  String get typeIngredientName => 'اكتب اسم المكون...';

  @override
  String get selectedAllergens => 'مسببات الحساسية المحددة';

  @override
  String saveSelected(int count) {
    return 'حفظ ($count محدد)';
  }

  @override
  String get analysisResults => 'نتائج التحليل';

  @override
  String get overallSafetyScore => 'درجة السلامة الإجمالية';

  @override
  String get personalizedWarnings => 'تحذيرات شخصية';

  @override
  String ingredientsAnalysis(int count) {
    return 'تحليل المكونات ($count)';
  }

  @override
  String get highRisk => 'خطر عالي';

  @override
  String get moderateRisk => 'خطر متوسط';

  @override
  String get lowRisk => 'خطر منخفض';

  @override
  String get benefitsAnalysis => 'تحليل الفوائد';

  @override
  String get recommendedAlternatives => 'البدائل الموصى بها';

  @override
  String get reason => 'السبب:';

  @override
  String get quickSummary => 'ملخص سريع';

  @override
  String get ingredientsChecked => 'تم فحص المكونات';

  @override
  String get personalWarnings => 'تحذيرات شخصية';

  @override
  String get ourVerdict => 'حكمنا';

  @override
  String get productInfo => 'معلومات المنتج';

  @override
  String get productType => 'نوع المنتج';

  @override
  String get brand => 'العلامة التجارية';

  @override
  String get premiumInsights => 'رؤى مميزة';

  @override
  String get researchArticles => 'مقالات بحثية';

  @override
  String get categoryRanking => 'تصنيف الفئة';

  @override
  String get safetyTrend => 'اتجاه السلامة';

  @override
  String get saveToFavorites => 'حفظ';

  @override
  String get shareResults => 'مشاركة';

  @override
  String get compareProducts => 'مقارنة';

  @override
  String get exportPDF => 'PDF';

  @override
  String get scanSimilar => 'مشابه';

  @override
  String get aiChatTitle => 'ماسح مستحضرات التجميل بالذكاء الاصطناعي';

  @override
  String get typeYourMessage => 'اكتب رسالتك...';

  @override
  String get errorSupabaseClientNotInitialized => 'خطأ: لم يتم تهيئة عميل Supabase.';

  @override
  String get serverError => 'خطأ في الخادم:';

  @override
  String get networkErrorOccurred => 'حدث خطأ في الشبكة. يرجى المحاولة مرة أخرى لاحقاً.';

  @override
  String get sorryAnErrorOccurred => 'عذراً، حدث خطأ. يرجى المحاولة مرة أخرى.';

  @override
  String get couldNotGetResponse => 'تعذر الحصول على استجابة.';

  @override
  String get aiAssistant => 'مساعد الذكاء الاصطناعي';

  @override
  String get online => 'متصل';

  @override
  String get typing => 'يكتب...';

  @override
  String get writeAMessage => 'اكتب رسالة...';

  @override
  String get hiIAmYourAIAssistantHowCanIHelp => 'مرحباً! أنا مساعدك بالذكاء الاصطناعي. كيف يمكنني المساعدة؟';

  @override
  String get iCanSeeYourScanResultsFeelFreeToAskMeAnyQuestionsAboutTheIngredientsSafetyConcernsOrRecommendations => 'يمكنني رؤية نتائج المسح الخاصة بك! لا تتردد في طرح أي أسئلة حول المكونات أو مخاوف السلامة أو التوصيات.';

  @override
  String get userQuestion => 'سؤال المستخدم:';

  @override
  String get databaseExplorer => 'مستكشف قاعدة البيانات';

  @override
  String get currentUser => 'المستخدم الحالي:';

  @override
  String get notSignedIn => 'غير مسجل الدخول';

  @override
  String get failedToFetchTables => 'فشل في جلب الجداول:';

  @override
  String get tablesInYourSupabaseDatabase => 'الجداول في قاعدة بيانات Supabase الخاصة بك:';

  @override
  String get viewSampleData => 'عرض بيانات نموذجية';

  @override
  String get failedToFetchSampleDataFor => 'فشل في جلب بيانات نموذجية لـ';

  @override
  String get sampleData => 'بيانات نموذجية:';

  @override
  String get aiChats => 'ماسح مستحضرات التجميل بالذكاء الاصطناعي';

  @override
  String get noDialoguesYet => 'لا توجد حوارات بعد.';

  @override
  String get startANewChat => 'ابدأ محادثة جديدة!';

  @override
  String get created => 'تم الإنشاء:';

  @override
  String get failedToSaveImage => 'فشل في حفظ الصورة:';

  @override
  String get editName => 'تحرير الاسم';

  @override
  String get enterYourName => 'أدخل اسمك';

  @override
  String get cancel => 'إلغاء';

  @override
  String get premiumUser => 'مستخدم مميز';

  @override
  String get freeUser => 'مستخدم مجاني';

  @override
  String get skinProfile => 'ملف البشرة';

  @override
  String get notSet => 'غير محدد';

  @override
  String get legal => 'قانوني';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get termsOfService => 'شروط الخدمة';

  @override
  String get dataManagement => 'إدارة البيانات';

  @override
  String get clearAllData => 'مسح جميع البيانات';

  @override
  String get clearAllDataConfirmation => 'هل أنت متأكد من أنك تريد حذف جميع بياناتك المحلية؟ لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get selectDataToClear => 'حدد البيانات المراد مسحها';

  @override
  String get scanResults => 'نتائج المسح';

  @override
  String get chatHistory => 'المحادثات';

  @override
  String get personalData => 'البيانات الشخصية';

  @override
  String get clearData => 'مسح البيانات';

  @override
  String get allLocalDataHasBeenCleared => 'تم مسح البيانات.';

  @override
  String get signOut => 'تسجيل الخروج';

  @override
  String get deleteScan => 'حذف المسح';

  @override
  String get deleteScanConfirmation => 'هل أنت متأكد من أنك تريد حذف هذا المسح من سجلك؟';

  @override
  String get deleteChat => 'حذف المحادثة';

  @override
  String get deleteChatConfirmation => 'هل أنت متأكد من أنك تريد حذف هذه المحادثة؟ سيتم فقدان جميع الرسائل.';

  @override
  String get delete => 'حذف';

  @override
  String get noScanHistoryFound => 'لم يتم العثور على سجل مسح.';

  @override
  String get scanOn => 'تم المسح في';

  @override
  String get ingredientsFound => 'تم العثور على مكونات';

  @override
  String get noCamerasFoundOnThisDevice => 'لم يتم العثور على كاميرات على هذا الجهاز.';

  @override
  String get failedToInitializeCamera => 'فشل في تهيئة الكاميرا:';

  @override
  String get analysisFailed => 'فشل التحليل:';

  @override
  String get analyzingPleaseWait => 'جارٍ التحليل، يرجى الانتظار...';

  @override
  String get positionTheLabelWithinTheFrame => 'ركز الكاميرا على قائمة المكونات';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get signUpToGetStarted => 'سجل للبدء';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get pleaseEnterYourName => 'يرجى إدخال اسمك';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get pleaseEnterYourEmail => 'يرجى إدخال بريدك الإلكتروني';

  @override
  String get pleaseEnterAValidEmail => 'يرجى إدخال بريد إلكتروني صالح';

  @override
  String get password => 'كلمة المرور';

  @override
  String get pleaseEnterYourPassword => 'يرجى إدخال كلمة المرور';

  @override
  String get passwordMustBeAtLeast6Characters => 'يجب أن تتكون كلمة المرور من 6 أحرف على الأقل';

  @override
  String get signUp => 'التسجيل';

  @override
  String get orContinueWith => 'أو المتابعة باستخدام';

  @override
  String get google => 'Google';

  @override
  String get apple => 'Apple';

  @override
  String get alreadyHaveAnAccount => 'لديك حساب بالفعل؟ ';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get selectYourSkinTypeDescription => 'اختر نوع بشرتك';

  @override
  String get normal => 'عادية';

  @override
  String get normalSkinDescription => 'متوازنة، ليست دهنية جداً أو جافة';

  @override
  String get dry => 'جافة';

  @override
  String get drySkinDescription => 'مشدودة، متقشرة، ملمس خشن';

  @override
  String get oily => 'دهنية';

  @override
  String get oilySkinDescription => 'لامعة، مسام كبيرة، عرضة لحب الشباب';

  @override
  String get combination => 'مختلطة';

  @override
  String get combinationSkinDescription => 'منطقة T دهنية، خدود جافة';

  @override
  String get sensitive => 'حساسة';

  @override
  String get sensitiveSkinDescription => 'تتهيج بسهولة، عرضة للاحمرار';

  @override
  String get selectSkinType => 'اختر نوع البشرة';

  @override
  String get restore => 'استعادة';

  @override
  String get restorePurchases => 'استعادة المشتريات';

  @override
  String get subscriptionRestored => 'تمت استعادة الاشتراك بنجاح!';

  @override
  String get noPurchasesToRestore => 'لا توجد مشتريات لاستعادتها';

  @override
  String get goPremium => 'احصل على الاشتراك المميز';

  @override
  String get unlockExclusiveFeatures => 'افتح ميزات حصرية للحصول على أقصى استفادة من تحليل بشرتك.';

  @override
  String get unlimitedProductScans => 'مسح غير محدود للمنتجات';

  @override
  String get advancedAIIngredientAnalysis => 'تحليل متقدم للمكونات بالذكاء الاصطناعي';

  @override
  String get fullScanAndSearchHistory => 'سجل كامل للمسح والبحث';

  @override
  String get adFreeExperience => 'تجربة خالية من الإعلانات بنسبة 100٪';

  @override
  String get yearly => 'سنوي';

  @override
  String savePercentage(int percentage) {
    return 'وفر $percentage٪';
  }

  @override
  String get monthly => 'شهري';

  @override
  String get perMonth => '/ شهر';

  @override
  String get startFreeTrial => 'ابدأ الفترة التجريبية المجانية';

  @override
  String trialDescription(String planName) {
    return 'فترة تجريبية مجانية لمدة 7 أيام، ثم تحصيل الرسوم $planName. إلغاء في أي وقت.';
  }

  @override
  String get home => 'الرئيسية';

  @override
  String get scan => 'مسح';

  @override
  String get aiChatNav => 'ماسح مستحضرات التجميل بالذكاء الاصطناعي';

  @override
  String get profileNav => 'الملف الشخصي';

  @override
  String get doYouEnjoyOurApp => 'هل تستمتع بتطبيقنا؟';

  @override
  String get notReally => 'لا';

  @override
  String get yesItsGreat => 'أعجبني';

  @override
  String get rateOurApp => 'قيم تطبيقنا';

  @override
  String get bestRatingWeCanGet => 'أفضل تقييم يمكننا الحصول عليه';

  @override
  String get rateOnGooglePlay => 'قيم على Google Play';

  @override
  String get rate => 'قيم';

  @override
  String get whatCanBeImproved => 'ما الذي يمكن تحسينه؟';

  @override
  String get wereSorryYouDidntHaveAGreatExperience => 'نأسف لأنك لم تحصل على تجربة رائعة. يرجى إخبارنا بما حدث من خطأ.';

  @override
  String get yourFeedback => 'ملاحظاتك...';

  @override
  String get sendFeedback => 'إرسال الملاحظات';

  @override
  String get thankYouForYourFeedback => 'شكراً لك على ملاحظاتك!';

  @override
  String get discussWithAI => 'ناقش مع الذكاء الاصطناعي';

  @override
  String get enterYourEmail => 'أدخل بريدك الإلكتروني';

  @override
  String get enterYourPassword => 'أدخل كلمة المرور';

  @override
  String get aiDisclaimer => 'قد تحتوي استجابات الذكاء الاصطناعي على أخطاء. يرجى التحقق من المعلومات الهامة.';

  @override
  String get applicationThemes => 'سمات التطبيق';

  @override
  String get highestRating => 'أعلى تقييم';

  @override
  String get selectYourAgeDescription => 'اختر عمرك';

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
  String get ageRange18_25Description => 'بشرة شابة، الوقاية';

  @override
  String get ageRange26_35Description => 'أولى علامات الشيخوخة';

  @override
  String get ageRange36_45Description => 'العناية بمكافحة الشيخوخة';

  @override
  String get ageRange46_55Description => 'العناية المكثفة';

  @override
  String get ageRange56PlusDescription => 'العناية المتخصصة';

  @override
  String get userName => 'اسمك';

  @override
  String get tryFreeAndSubscribe => 'جرب مجاناً واشترك';

  @override
  String get personalAIConsultant => 'استشاري ذكاء اصطناعي شخصي 24/7';

  @override
  String get subscribe => 'اشترك';

  @override
  String get themes => 'السمات';

  @override
  String get selectPreferredTheme => 'اختر سمتك المفضلة';

  @override
  String get naturalTheme => 'طبيعي';

  @override
  String get darkTheme => 'داكن';

  @override
  String get darkNatural => 'طبيعي داكن';

  @override
  String get oceanTheme => 'محيط';

  @override
  String get forestTheme => 'غابة';

  @override
  String get sunsetTheme => 'غروب الشمس';

  @override
  String get naturalThemeDescription => 'سمة طبيعية مع ألوان صديقة للبيئة';

  @override
  String get darkThemeDescription => 'سمة داكنة لراحة العين';

  @override
  String get oceanThemeDescription => 'سمة المحيط المنعشة';

  @override
  String get forestThemeDescription => 'سمة الغابة الطبيعية';

  @override
  String get sunsetThemeDescription => 'سمة غروب الشمس الدافئة';

  @override
  String get sunnyTheme => 'مشمس';

  @override
  String get sunnyThemeDescription => 'سمة صفراء مشرقة ومبهجة';

  @override
  String get vibrantTheme => 'نابض بالحياة';

  @override
  String get vibrantThemeDescription => 'سمة وردية وأرجوانية مشرقة';

  @override
  String get scanAnalysis => 'تحليل المسح';

  @override
  String get ingredients => 'مكونات';

  @override
  String get aiBotSettings => 'إعدادات الذكاء الاصطناعي';

  @override
  String get botName => 'اسم الروبوت';

  @override
  String get enterBotName => 'أدخل اسم الروبوت';

  @override
  String get pleaseEnterBotName => 'يرجى إدخال اسم الروبوت';

  @override
  String get botDescription => 'وصف الروبوت';

  @override
  String get selectAvatar => 'اختر الصورة الرمزية';

  @override
  String get defaultBotName => 'ACS';

  @override
  String defaultBotDescription(String name) {
    return 'مرحباً! أنا $name (ماسح مستحضرات التجميل بالذكاء الاصطناعي). سأساعدك على فهم تركيبة مستحضرات التجميل الخاصة بك. لدي معرفة واسعة في مجال التجميل والعناية بالبشرة. سأكون سعيداً بالإجابة على جميع أسئلتك.';
  }

  @override
  String get settingsSaved => 'تم حفظ الإعدادات بنجاح';

  @override
  String get failedToSaveSettings => 'فشل في حفظ الإعدادات';

  @override
  String get resetToDefault => 'إعادة تعيين إلى الافتراضي';

  @override
  String get resetSettings => 'إعادة تعيين الإعدادات';

  @override
  String get resetSettingsConfirmation => 'هل أنت متأكد من أنك تريد إعادة تعيين جميع الإعدادات إلى القيم الافتراضية؟';

  @override
  String get settingsResetSuccessfully => 'تمت إعادة تعيين الإعدادات بنجاح';

  @override
  String get failedToResetSettings => 'فشل في إعادة تعيين الإعدادات';

  @override
  String get unsavedChanges => 'تغييرات غير محفوظة';

  @override
  String get unsavedChangesMessage => 'لديك تغييرات غير محفوظة. هل أنت متأكد من أنك تريد المغادرة؟';

  @override
  String get stay => 'البقاء';

  @override
  String get leave => 'المغادرة';

  @override
  String get errorLoadingSettings => 'خطأ في تحميل الإعدادات';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get customPrompt => 'طلبات خاصة';

  @override
  String get customPromptDescription => 'أضف تعليمات مخصصة لمساعد الذكاء الاصطناعي';

  @override
  String get customPromptPlaceholder => 'أدخل طلباتك الخاصة...';

  @override
  String get enableCustomPrompt => 'تمكين الطلبات الخاصة';

  @override
  String get defaultCustomPrompt => 'امنحني الإطراءات.';

  @override
  String get close => 'إغلاق';

  @override
  String get scanningHintTitle => 'كيفية المسح';

  @override
  String get scanLimitReached => 'تم الوصول إلى حد المسح';

  @override
  String get scanLimitReachedMessage => 'لقد استخدمت جميع عمليات المسح المجانية الـ 5 هذا الأسبوع. قم بالترقية إلى الاشتراك المميز للحصول على مسح غير محدود!';

  @override
  String get messageLimitReached => 'تم الوصول إلى حد الرسائل اليومية';

  @override
  String get messageLimitReachedMessage => 'لقد أرسلت 5 رسائل اليوم. قم بالترقية إلى الاشتراك المميز للحصول على محادثة غير محدودة!';

  @override
  String get historyLimitReached => 'الوصول إلى السجل محدود';

  @override
  String get historyLimitReachedMessage => 'قم بالترقية إلى الاشتراك المميز للوصول إلى سجل المسح الكامل الخاص بك!';

  @override
  String get upgradeToPremium => 'الترقية إلى الاشتراك المميز';

  @override
  String get upgradeToView => 'الترقية للعرض';

  @override
  String get upgradeToChat => 'الترقية للمحادثة';

  @override
  String get premiumFeature => 'ميزة مميزة';

  @override
  String get freePlanUsage => 'استخدام الخطة المجانية';

  @override
  String get scansThisWeek => 'عمليات المسح هذا الأسبوع';

  @override
  String get messagesToday => 'الرسائل اليوم';

  @override
  String get limitsReached => 'تم الوصول إلى الحدود';

  @override
  String get remainingScans => 'عمليات المسح المتبقية';

  @override
  String get remainingMessages => 'الرسائل المتبقية';

  @override
  String get unlockUnlimitedAccess => 'افتح الوصول غير المحدود';

  @override
  String get upgradeToPremiumDescription => 'احصل على مسح غير محدود ورسائل ووصول كامل إلى سجل المسح الخاص بك مع الاشتراك المميز!';

  @override
  String get premiumBenefits => 'فوائد الاشتراك المميز';

  @override
  String get unlimitedAiChatMessages => 'رسائل محادثة غير محدودة مع الذكاء الاصطناعي';

  @override
  String get fullAccessToScanHistory => 'وصول كامل إلى سجل المسح';

  @override
  String get prioritySupport => 'دعم ذو أولوية';

  @override
  String get learnMore => 'معرفة المزيد';

  @override
  String get upgradeNow => 'الترقية الآن';

  @override
  String get maybeLater => 'ربما لاحقاً';

  @override
  String get scanHistoryLimit => 'يظهر فقط أحدث مسح في السجل';

  @override
  String get upgradeForUnlimitedScans => 'قم بالترقية للحصول على مسح غير محدود!';

  @override
  String get upgradeForUnlimitedChat => 'قم بالترقية للحصول على محادثة غير محدودة!';

  @override
  String get slowInternetConnection => 'اتصال إنترنت بطيء';

  @override
  String get slowInternetMessage => 'على اتصال إنترنت بطيء جداً، سيتعين عليك الانتظار قليلاً... ما زلنا نحلل صورتك.';

  @override
  String get revolutionaryAI => 'ذكاء اصطناعي ثوري';

  @override
  String get revolutionaryAIDesc => 'واحد من أذكى في العالم';

  @override
  String get unlimitedScans => 'مسح غير محدود';

  @override
  String get unlimitedScansDesc => 'استكشف مستحضرات التجميل بدون حدود';

  @override
  String get unlimitedChats => 'محادثات غير محدودة';

  @override
  String get unlimitedChatsDesc => 'استشاري ذكاء اصطناعي شخصي 24/7';

  @override
  String get fullHistory => 'سجل كامل';

  @override
  String get fullHistoryDesc => 'سجل مسح غير محدود';

  @override
  String get rememberContext => 'يتذكر السياق';

  @override
  String get rememberContextDesc => 'الذكاء الاصطناعي يتذكر رسائلك السابقة';

  @override
  String get allIngredientsInfo => 'معلومات جميع المكونات';

  @override
  String get allIngredientsInfoDesc => 'تعرف على جميع التفاصيل';

  @override
  String get noAds => 'خالي من الإعلانات بنسبة 100٪';

  @override
  String get noAdsDesc => 'لمن يقدرون وقتهم';

  @override
  String get multiLanguage => 'يعرف تقريباً جميع اللغات';

  @override
  String get multiLanguageDesc => 'مترجم محسّن';

  @override
  String get paywallTitle => 'افتح أسرار مستحضرات التجميل الخاصة بك مع الذكاء الاصطناعي';

  @override
  String paywallDescription(String price) {
    return 'لديك فرصة للحصول على اشتراك مميز لمدة 3 أيام مجاناً، ثم $price في الأسبوع. الإلغاء في أي وقت.';
  }

  @override
  String get whatsIncluded => 'ما المتضمن';

  @override
  String get basicPlan => 'أساسي';

  @override
  String get premiumPlan => 'مميز';

  @override
  String get botGreeting1 => 'يوم سعيد! كيف يمكنني مساعدتك اليوم؟';

  @override
  String get botGreeting2 => 'مرحباً! ما الذي يجلبك إلي؟';

  @override
  String get botGreeting3 => 'أرحب بك! جاهز للمساعدة في التحليل التجميلي.';

  @override
  String get botGreeting4 => 'سعيد برؤيتك! كيف يمكنني أن أكون مفيداً؟';

  @override
  String get botGreeting5 => 'مرحباً! دعنا نستكشف تركيبة مستحضرات التجميل الخاصة بك معاً.';

  @override
  String get botGreeting6 => 'مرحباً! جاهز للإجابة على أسئلتك حول مستحضرات التجميل.';

  @override
  String get botGreeting7 => 'مرحباً! أنا مساعدك الشخصي في التجميل.';

  @override
  String get botGreeting8 => 'يوم سعيد! سأساعدك على فهم تركيبة المنتجات التجميلية.';

  @override
  String get botGreeting9 => 'مرحباً! دعنا نجعل مستحضرات التجميل الخاصة بك أكثر أماناً معاً.';

  @override
  String get botGreeting10 => 'أرحب بك! جاهز لمشاركة المعرفة حول مستحضرات التجميل.';

  @override
  String get botGreeting11 => 'يوم سعيد! سأساعدك في العثور على أفضل الحلول التجميلية لك.';

  @override
  String get botGreeting12 => 'مرحباً! خبير سلامة مستحضرات التجميل الخاص بك في خدمتك.';

  @override
  String get botGreeting13 => 'مرحباً! دعنا نختار مستحضرات التجميل المثالية لك معاً.';

  @override
  String get botGreeting14 => 'مرحباً! جاهز للمساعدة في تحليل المكونات.';

  @override
  String get botGreeting15 => 'مرحباً! سأساعدك على فهم تركيبة مستحضرات التجميل الخاصة بك.';

  @override
  String get botGreeting16 => 'أرحب بك! دليلك في عالم التجميل جاهز للمساعدة.';

  @override
  String get copiedToClipboard => 'تم النسخ إلى الحافظة';

  @override
  String get tryFree => 'جرب مجاناً';

  @override
  String get cameraNotReady => 'الكاميرا غير جاهزة / لا توجد إذن';

  @override
  String get cameraPermissionInstructions => 'إعدادات التطبيق:\nماسح مستحضرات التجميل بالذكاء الاصطناعي > الأذونات > الكاميرا > السماح';

  @override
  String get openSettingsAndGrantAccess => 'افتح الإعدادات ومنح الوصول إلى الكاميرا';

  @override
  String get retryCamera => 'إعادة المحاولة';

  @override
  String get errorServiceOverloaded => 'الخدمة مشغولة مؤقتاً. يرجى المحاولة مرة أخرى بعد لحظة.';

  @override
  String get errorRateLimitExceeded => 'عدد كبير جداً من الطلبات. يرجى الانتظار لحظة والمحاولة مرة أخرى.';

  @override
  String get errorTimeout => 'انتهت مهلة الطلب. يرجى التحقق من اتصالك بالإنترنت والمحاولة مرة أخرى.';

  @override
  String get errorNetwork => 'خطأ في الشبكة. يرجى التحقق من اتصالك بالإنترنت.';

  @override
  String get errorAuthentication => 'خطأ في المصادقة. يرجى إعادة تشغيل التطبيق.';

  @override
  String get errorInvalidResponse => 'تم تلقي استجابة غير صالحة. يرجى المحاولة مرة أخرى.';

  @override
  String get errorServer => 'خطأ في الخادم. يرجى المحاولة مرة أخرى لاحقاً.';

  @override
  String get customThemes => 'سمات مخصصة';

  @override
  String get createCustomTheme => 'إنشاء سمة مخصصة';

  @override
  String get basedOn => 'بناءً على';

  @override
  String get lightMode => 'فاتح';

  @override
  String get generateWithAI => 'إنشاء باستخدام الذكاء الاصطناعي';

  @override
  String get resetToBaseTheme => 'إعادة تعيين إلى السمة الأساسية';

  @override
  String colorsResetTo(Object themeName) {
    return 'تمت إعادة تعيين الألوان إلى $themeName';
  }

  @override
  String get aiGenerationComingSoon => 'إنشاء السمات بالذكاء الاصطناعي قادم في التكرار 5!';

  @override
  String get onboardingGreeting => 'مرحباً! لتحسين جودة الإجابات، دعنا نعد ملفك الشخصي';

  @override
  String get letsGo => 'لنبدأ';

  @override
  String get next => 'التالي';

  @override
  String get finish => 'إنهاء';

  @override
  String get customThemeInDevelopment => 'ميزة السمات المخصصة قيد التطوير';

  @override
  String get customThemeComingSoon => 'قريباً في التحديثات المستقبلية';

  @override
  String get dailyMessageLimitReached => 'تم الوصول إلى الحد';

  @override
  String get dailyMessageLimitReachedMessage => 'لقد أرسلت 5 رسائل اليوم. قم بالترقية إلى الاشتراك المميز للحصول على محادثة غير محدودة!';

  @override
  String get upgradeToPremiumForUnlimitedChat => 'قم بالترقية إلى الاشتراك المميز للحصول على محادثة غير محدودة';

  @override
  String get messagesLeftToday => 'رسائل متبقية اليوم';

  @override
  String get designYourOwnTheme => 'صمم سمتك الخاصة';

  @override
  String get darkOcean => 'محيط داكن';

  @override
  String get darkForest => 'غابة داكنة';

  @override
  String get darkSunset => 'غروب شمس داكن';

  @override
  String get darkVibrant => 'نابض بالحياة داكن';

  @override
  String get darkOceanThemeDescription => 'سمة محيط داكنة مع لمسات سماوية';

  @override
  String get darkForestThemeDescription => 'سمة غابة داكنة مع لمسات خضراء فاتحة';

  @override
  String get darkSunsetThemeDescription => 'سمة غروب شمس داكنة مع لمسات برتقالية';

  @override
  String get darkVibrantThemeDescription => 'سمة نابضة بالحياة داكنة مع لمسات وردية وأرجوانية';

  @override
  String get customTheme => 'سمة مخصصة';

  @override
  String get edit => 'تحرير';

  @override
  String get deleteTheme => 'حذف السمة';

  @override
  String deleteThemeConfirmation(String themeName) {
    return 'هل أنت متأكد من أنك تريد حذف \"$themeName\"؟';
  }

  @override
  String get pollTitle => 'ما الذي ينقص؟';

  @override
  String get pollCardTitle => 'ما الذي ينقص في التطبيق؟';

  @override
  String get pollCardSubtitle => 'ما هي الميزات الثلاث التي يجب إضافتها؟';

  @override
  String get pollDescription => 'صوت للخيارات التي تريد رؤيتها';

  @override
  String get submitVote => 'تصويت';

  @override
  String get submitting => 'جارٍ الإرسال...';

  @override
  String get voteSubmittedSuccess => 'تم إرسال الأصوات بنجاح!';

  @override
  String votesRemaining(int count) {
    return '$count أصوات متبقية';
  }

  @override
  String get votes => 'أصوات';

  @override
  String get addYourOption => 'اقترح تحسيناً';

  @override
  String get enterYourOption => 'أدخل خيارك...';

  @override
  String get add => 'إضافة';

  @override
  String get filterTopVoted => 'شائع';

  @override
  String get filterNewest => 'جديد';

  @override
  String get filterMyOption => 'اختياري';

  @override
  String get thankYouForVoting => 'شكراً لك على التصويت!';

  @override
  String get votingComplete => 'تم تسجيل صوتك';

  @override
  String get requestFeatureDevelopment => 'طلب تطوير ميزة مخصصة';

  @override
  String get requestFeatureDescription => 'هل تحتاج إلى ميزة معينة؟ اتصل بنا لمناقشة التطوير المخصص لاحتياجات عملك.';

  @override
  String get pollHelpTitle => 'كيفية التصويت';

  @override
  String get pollHelpDescription => '• انقر على خيار لتحديده\n• انقر مرة أخرى لإلغاء التحديد\n• حدد أكبر عدد تريده من الخيارات\n• انقر على زر \'تصويت\' لإرسال أصواتك\n• أضف خيارك الخاص إذا لم تر ما تحتاجه';
}
