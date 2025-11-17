// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appName => 'AI Cosmetic Scanner';

  @override
  String get skinAnalysis => 'Phân Tích Da';

  @override
  String get checkYourCosmetics => 'Kiểm tra mỹ phẩm của bạn';

  @override
  String get startScanning => 'Bắt Đầu Quét';

  @override
  String get quickActions => 'Thao Tác Nhanh';

  @override
  String get scanHistory => 'Lịch Sử Quét';

  @override
  String get aiChat => 'AI Cosmetic Scanner';

  @override
  String get profile => 'Hồ Sơ';

  @override
  String get settings => 'Cài Đặt';

  @override
  String get skinType => 'Loại Da';

  @override
  String get allergiesSensitivities => 'Dị Ứng & Nhạy Cảm';

  @override
  String get subscription => 'Đăng Ký';

  @override
  String get age => 'Tuổi';

  @override
  String get language => 'Ngôn Ngữ';

  @override
  String get selectYourPreferredLanguage => 'Chọn ngôn ngữ bạn muốn';

  @override
  String get save => 'Lưu';

  @override
  String get selectIngredientsAllergicSensitive => 'Chọn các thành phần bạn có độ nhạy cảm cao';

  @override
  String get commonAllergens => 'Chất Gây Dị Ứng Phổ Biến';

  @override
  String get fragrance => 'Nước Hoa';

  @override
  String get parabens => 'Paraben';

  @override
  String get sulfates => 'Sulfate';

  @override
  String get alcohol => 'Cồn';

  @override
  String get essentialOils => 'Tinh Dầu';

  @override
  String get silicones => 'Silicone';

  @override
  String get mineralOil => 'Dầu Khoáng';

  @override
  String get formaldehyde => 'Formaldehyde';

  @override
  String get addCustomAllergen => 'Thêm Chất Dị Ứng Tùy Chỉnh';

  @override
  String get typeIngredientName => 'Nhập tên thành phần...';

  @override
  String get selectedAllergens => 'Chất Dị Ứng Đã Chọn';

  @override
  String saveSelected(int count) {
    return 'Lưu ($count đã chọn)';
  }

  @override
  String get analysisResults => 'Kết Quả Phân Tích';

  @override
  String get overallSafetyScore => 'Điểm An Toàn Tổng Thể';

  @override
  String get personalizedWarnings => 'Cảnh Báo Cá Nhân';

  @override
  String ingredientsAnalysis(int count) {
    return 'Phân Tích Thành Phần ($count)';
  }

  @override
  String get highRisk => 'Rủi Ro Cao';

  @override
  String get moderateRisk => 'Rủi Ro Trung Bình';

  @override
  String get lowRisk => 'Rủi Ro Thấp';

  @override
  String get benefitsAnalysis => 'Phân Tích Lợi Ích';

  @override
  String get recommendedAlternatives => 'Lựa Chọn Thay Thế Đề Xuất';

  @override
  String get reason => 'Lý do:';

  @override
  String get quickSummary => 'Tóm Tắt Nhanh';

  @override
  String get ingredientsChecked => 'thành phần đã kiểm tra';

  @override
  String get personalWarnings => 'cảnh báo cá nhân';

  @override
  String get ourVerdict => 'Đánh Giá Của Chúng Tôi';

  @override
  String get productInfo => 'Thông Tin Sản Phẩm';

  @override
  String get productType => 'Loại Sản Phẩm';

  @override
  String get brand => 'Thương Hiệu';

  @override
  String get premiumInsights => 'Thông Tin Chuyên Sâu Premium';

  @override
  String get researchArticles => 'Bài Nghiên Cứu';

  @override
  String get categoryRanking => 'Xếp Hạng Danh Mục';

  @override
  String get safetyTrend => 'Xu Hướng An Toàn';

  @override
  String get saveToFavorites => 'Lưu';

  @override
  String get shareResults => 'Chia Sẻ';

  @override
  String get compareProducts => 'So Sánh';

  @override
  String get exportPDF => 'PDF';

  @override
  String get scanSimilar => 'Tương Tự';

  @override
  String get aiChatTitle => 'AI Cosmetic Scanner';

  @override
  String get typeYourMessage => 'Nhập tin nhắn của bạn...';

  @override
  String get errorSupabaseClientNotInitialized => 'Lỗi: Client Supabase chưa được khởi tạo.';

  @override
  String get serverError => 'Lỗi máy chủ:';

  @override
  String get networkErrorOccurred => 'Đã xảy ra lỗi mạng. Vui lòng thử lại sau.';

  @override
  String get sorryAnErrorOccurred => 'Xin lỗi, đã xảy ra lỗi. Vui lòng thử lại.';

  @override
  String get couldNotGetResponse => 'Không thể nhận được phản hồi.';

  @override
  String get aiAssistant => 'Trợ Lý AI';

  @override
  String get online => 'Trực Tuyến';

  @override
  String get typing => 'Đang nhập...';

  @override
  String get writeAMessage => 'Viết tin nhắn...';

  @override
  String get hiIAmYourAIAssistantHowCanIHelp => 'Xin chào! Tôi là trợ lý AI của bạn. Tôi có thể giúp gì cho bạn?';

  @override
  String get iCanSeeYourScanResultsFeelFreeToAskMeAnyQuestionsAboutTheIngredientsSafetyConcernsOrRecommendations => 'Tôi có thể xem kết quả quét của bạn! Hãy thoải mái hỏi tôi bất kỳ câu hỏi nào về thành phần, mối quan ngại an toàn hoặc đề xuất.';

  @override
  String get userQuestion => 'Câu hỏi của người dùng:';

  @override
  String get databaseExplorer => 'Trình Khám Phá Cơ Sở Dữ Liệu';

  @override
  String get currentUser => 'Người Dùng Hiện Tại:';

  @override
  String get notSignedIn => 'Chưa đăng nhập';

  @override
  String get failedToFetchTables => 'Không thể tải các bảng:';

  @override
  String get tablesInYourSupabaseDatabase => 'Các bảng trong cơ sở dữ liệu Supabase của bạn:';

  @override
  String get viewSampleData => 'Xem Dữ Liệu Mẫu';

  @override
  String get failedToFetchSampleDataFor => 'Không thể tải dữ liệu mẫu cho';

  @override
  String get sampleData => 'Dữ Liệu Mẫu:';

  @override
  String get aiChats => 'Trò chuyện AI';

  @override
  String get noDialoguesYet => 'Chưa có cuộc hội thoại nào.';

  @override
  String get startANewChat => 'Bắt đầu cuộc trò chuyện mới!';

  @override
  String get created => 'Đã tạo:';

  @override
  String get failedToSaveImage => 'Không thể lưu hình ảnh:';

  @override
  String get editName => 'Chỉnh Sửa Tên';

  @override
  String get enterYourName => 'Nhập tên của bạn';

  @override
  String get cancel => 'Hủy';

  @override
  String get premiumUser => 'Người Dùng Premium';

  @override
  String get freeUser => 'Người Dùng Miễn Phí';

  @override
  String get skinProfile => 'Hồ Sơ Da';

  @override
  String get notSet => 'Chưa đặt';

  @override
  String get legal => 'Pháp Lý';

  @override
  String get privacyPolicy => 'Chính Sách Bảo Mật';

  @override
  String get termsOfService => 'Điều Khoản Dịch Vụ';

  @override
  String get dataManagement => 'Quản Lý Dữ Liệu';

  @override
  String get clearAllData => 'Xóa Tất Cả Dữ Liệu';

  @override
  String get clearAllDataConfirmation => 'Bạn có chắc chắn muốn xóa tất cả dữ liệu cục bộ của mình không? Hành động này không thể hoàn tác.';

  @override
  String get selectDataToClear => 'Chọn dữ liệu cần xóa';

  @override
  String get scanResults => 'Kết Quả Quét';

  @override
  String get chatHistory => 'Cuộc Trò Chuyện';

  @override
  String get personalData => 'Dữ Liệu Cá Nhân';

  @override
  String get clearData => 'Xóa Dữ Liệu';

  @override
  String get allLocalDataHasBeenCleared => 'Dữ liệu đã được xóa.';

  @override
  String get signOut => 'Đăng Xuất';

  @override
  String get deleteScan => 'Xóa Kết Quả Quét';

  @override
  String get deleteScanConfirmation => 'Bạn có chắc chắn muốn xóa kết quả quét này khỏi lịch sử không?';

  @override
  String get deleteChat => 'Xóa Cuộc Trò Chuyện';

  @override
  String get deleteChatConfirmation => 'Bạn có chắc chắn muốn xóa cuộc trò chuyện này không? Tất cả tin nhắn sẽ bị mất.';

  @override
  String get delete => 'Xóa';

  @override
  String get noScanHistoryFound => 'Không tìm thấy lịch sử quét.';

  @override
  String get scanOn => 'Quét vào';

  @override
  String get ingredientsFound => 'thành phần được tìm thấy';

  @override
  String get noCamerasFoundOnThisDevice => 'Không tìm thấy camera trên thiết bị này.';

  @override
  String get failedToInitializeCamera => 'Không thể khởi tạo camera:';

  @override
  String get analysisFailed => 'Phân tích thất bại:';

  @override
  String get analyzingPleaseWait => 'Đang phân tích, vui lòng đợi...';

  @override
  String get positionTheLabelWithinTheFrame => 'Lấy nét camera vào danh sách thành phần';

  @override
  String get createAccount => 'Tạo Tài Khoản';

  @override
  String get signUpToGetStarted => 'Đăng ký để bắt đầu';

  @override
  String get fullName => 'Họ và Tên';

  @override
  String get pleaseEnterYourName => 'Vui lòng nhập tên của bạn';

  @override
  String get email => 'Email';

  @override
  String get pleaseEnterYourEmail => 'Vui lòng nhập email của bạn';

  @override
  String get pleaseEnterAValidEmail => 'Vui lòng nhập địa chỉ email hợp lệ';

  @override
  String get password => 'Mật Khẩu';

  @override
  String get pleaseEnterYourPassword => 'Vui lòng nhập mật khẩu của bạn';

  @override
  String get passwordMustBeAtLeast6Characters => 'Mật khẩu phải có ít nhất 6 ký tự';

  @override
  String get signUp => 'Đăng Ký';

  @override
  String get orContinueWith => 'hoặc tiếp tục với';

  @override
  String get google => 'Google';

  @override
  String get apple => 'Apple';

  @override
  String get alreadyHaveAnAccount => 'Đã có tài khoản? ';

  @override
  String get signIn => 'Đăng Nhập';

  @override
  String get selectYourSkinTypeDescription => 'Chọn loại da của bạn';

  @override
  String get normal => 'Da Thường';

  @override
  String get normalSkinDescription => 'Cân bằng, không quá dầu hoặc khô';

  @override
  String get dry => 'Da Khô';

  @override
  String get drySkinDescription => 'Căng, bong tróc, kết cấu thô';

  @override
  String get oily => 'Da Dầu';

  @override
  String get oilySkinDescription => 'Bóng, lỗ chân lông to, dễ mụn';

  @override
  String get combination => 'Da Hỗn Hợp';

  @override
  String get combinationSkinDescription => 'Vùng T dầu, má khô';

  @override
  String get sensitive => 'Da Nhạy Cảm';

  @override
  String get sensitiveSkinDescription => 'Dễ kích ứng, dễ đỏ';

  @override
  String get selectSkinType => 'Chọn loại da';

  @override
  String get restore => 'Khôi Phục';

  @override
  String get restorePurchases => 'Khôi Phục Giao Dịch Mua';

  @override
  String get subscriptionRestored => 'Đã khôi phục đăng ký thành công!';

  @override
  String get noPurchasesToRestore => 'Không có giao dịch mua nào để khôi phục';

  @override
  String get goPremium => 'Nâng Cấp Premium';

  @override
  String get unlockExclusiveFeatures => 'Mở khóa các tính năng độc quyền để tận dụng tối đa phân tích da của bạn.';

  @override
  String get unlimitedProductScans => 'Quét sản phẩm không giới hạn';

  @override
  String get advancedAIIngredientAnalysis => 'Phân Tích Thành Phần AI Nâng Cao';

  @override
  String get fullScanAndSearchHistory => 'Lịch Sử Quét và Tìm Kiếm Đầy Đủ';

  @override
  String get adFreeExperience => 'Trải Nghiệm 100% Không Quảng Cáo';

  @override
  String get yearly => 'Hàng Năm';

  @override
  String savePercentage(int percentage) {
    return 'Tiết kiệm $percentage%';
  }

  @override
  String get monthly => 'Hàng Tháng';

  @override
  String get perMonth => '/ tháng';

  @override
  String get startFreeTrial => 'Bắt Đầu Dùng Thử Miễn Phí';

  @override
  String trialDescription(String planName) {
    return 'Dùng thử miễn phí 7 ngày, sau đó tính phí $planName. Hủy bất cứ lúc nào.';
  }

  @override
  String get home => 'Trang Chủ';

  @override
  String get scan => 'Máy quét';

  @override
  String get aiChatNav => 'Cố vấn';

  @override
  String get profileNav => 'Hồ Sơ';

  @override
  String get doYouEnjoyOurApp => 'Bạn có thích ứng dụng của chúng tôi không?';

  @override
  String get notReally => 'Không';

  @override
  String get yesItsGreat => 'Tôi thích';

  @override
  String get rateOurApp => 'Đánh giá ứng dụng';

  @override
  String get bestRatingWeCanGet => 'Đánh giá tốt nhất chúng tôi có thể nhận';

  @override
  String get rateOnGooglePlay => 'Đánh Giá Trên Google Play';

  @override
  String get rate => 'Đánh Giá';

  @override
  String get whatCanBeImproved => 'Có thể cải thiện điều gì?';

  @override
  String get wereSorryYouDidntHaveAGreatExperience => 'Chúng tôi xin lỗi vì bạn không có trải nghiệm tuyệt vời. Vui lòng cho chúng tôi biết điều gì đã xảy ra.';

  @override
  String get yourFeedback => 'Phản hồi của bạn...';

  @override
  String get sendFeedback => 'Gửi Phản Hồi';

  @override
  String get thankYouForYourFeedback => 'Cảm ơn phản hồi của bạn!';

  @override
  String get discussWithAI => 'Thảo Luận Với AI';

  @override
  String get enterYourEmail => 'Nhập email của bạn';

  @override
  String get enterYourPassword => 'Nhập mật khẩu của bạn';

  @override
  String get aiDisclaimer => 'Phản hồi AI có thể chứa những thông tin không chính xác. Vui lòng xác minh thông tin quan trọng.';

  @override
  String get applicationThemes => 'Chủ Đề Ứng Dụng';

  @override
  String get highestRating => 'Đánh Giá Cao Nhất';

  @override
  String get selectYourAgeDescription => 'Chọn độ tuổi của bạn';

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
  String get ageRange18_25Description => 'Da trẻ, phòng ngừa';

  @override
  String get ageRange26_35Description => 'Dấu hiệu lão hóa đầu tiên';

  @override
  String get ageRange36_45Description => 'Chăm sóc chống lão hóa';

  @override
  String get ageRange46_55Description => 'Chăm sóc chuyên sâu';

  @override
  String get ageRange56PlusDescription => 'Chăm sóc chuyên biệt';

  @override
  String get userName => 'Tên Của Bạn';

  @override
  String get yourName => 'Your Name';

  @override
  String get tryFreeAndSubscribe => 'Dùng Thử Miễn Phí & Đăng Ký';

  @override
  String get personalAIConsultant => 'Cố Vấn AI Cá Nhân 24/7';

  @override
  String get subscribe => 'Đăng Ký';

  @override
  String get themes => 'Chủ Đề';

  @override
  String get selectPreferredTheme => 'Chọn chủ đề bạn thích';

  @override
  String get naturalTheme => 'Tự Nhiên';

  @override
  String get darkTheme => 'Tối';

  @override
  String get darkNatural => 'Tự Nhiên Tối';

  @override
  String get oceanTheme => 'Đại Dương';

  @override
  String get forestTheme => 'Rừng';

  @override
  String get sunsetTheme => 'Hoàng Hôn';

  @override
  String get naturalThemeDescription => 'Chủ đề tự nhiên với màu thân thiện môi trường';

  @override
  String get darkThemeDescription => 'Chủ đề tối thoải mái cho mắt';

  @override
  String get oceanThemeDescription => 'Chủ đề đại dương tươi mát';

  @override
  String get forestThemeDescription => 'Chủ đề rừng tự nhiên';

  @override
  String get sunsetThemeDescription => 'Chủ đề hoàng hôn ấm áp';

  @override
  String get sunnyTheme => 'Nắng';

  @override
  String get sunnyThemeDescription => 'Chủ đề vàng tươi sáng và vui vẻ';

  @override
  String get vibrantTheme => 'Rực Rỡ';

  @override
  String get vibrantThemeDescription => 'Chủ đề hồng và tím tươi sáng';

  @override
  String get scanAnalysis => 'Phân Tích Quét';

  @override
  String get ingredients => 'thành phần';

  @override
  String get aiBotSettings => 'Cài Đặt AI';

  @override
  String get botName => 'Tên Bot';

  @override
  String get enterBotName => 'Nhập tên bot';

  @override
  String get pleaseEnterBotName => 'Vui lòng nhập tên bot';

  @override
  String get botDescription => 'Mô Tả Bot';

  @override
  String get selectAvatar => 'Chọn Avatar';

  @override
  String get defaultBotName => 'ACS';

  @override
  String defaultBotDescription(String name) {
    return 'Xin chào! Tôi là $name (AI Cosmetic Scanner). Tôi sẽ giúp bạn hiểu thành phần của mỹ phẩm. Tôi có kiến thức rộng về mỹ phẩm học và chăm sóc da. Tôi rất vui lòng trả lời tất cả câu hỏi của bạn.';
  }

  @override
  String get settingsSaved => 'Đã lưu cài đặt thành công';

  @override
  String get failedToSaveSettings => 'Không thể lưu cài đặt';

  @override
  String get resetToDefault => 'Đặt Lại Về Mặc Định';

  @override
  String get resetSettings => 'Đặt Lại Cài Đặt';

  @override
  String get resetSettingsConfirmation => 'Bạn có chắc chắn muốn đặt lại tất cả cài đặt về giá trị mặc định không?';

  @override
  String get settingsResetSuccessfully => 'Đã đặt lại cài đặt thành công';

  @override
  String get failedToResetSettings => 'Không thể đặt lại cài đặt';

  @override
  String get unsavedChanges => 'Thay Đổi Chưa Lưu';

  @override
  String get unsavedChangesMessage => 'Bạn có các thay đổi chưa lưu. Bạn có chắc chắn muốn rời đi không?';

  @override
  String get stay => 'Ở Lại';

  @override
  String get leave => 'Rời Đi';

  @override
  String get errorLoadingSettings => 'Lỗi tải cài đặt';

  @override
  String get retry => 'Thử Lại';

  @override
  String get customPrompt => 'Yêu Cầu Đặc Biệt';

  @override
  String get customPromptDescription => 'Thêm hướng dẫn cá nhân cho trợ lý AI';

  @override
  String get customPromptPlaceholder => 'Nhập yêu cầu đặc biệt của bạn...';

  @override
  String get enableCustomPrompt => 'Bật yêu cầu đặc biệt';

  @override
  String get defaultCustomPrompt => 'Khen ngợi tôi.';

  @override
  String get close => 'Đóng';

  @override
  String get scanningHintTitle => 'Cách Quét';

  @override
  String get scanLimitReached => 'Đã Đạt Giới Hạn Quét';

  @override
  String get scanLimitReachedMessage => 'Bạn đã sử dụng hết 5 lần quét miễn phí trong tuần này. Nâng cấp lên Premium để quét không giới hạn!';

  @override
  String get messageLimitReached => 'Đã Đạt Giới Hạn Tin Nhắn Hàng Ngày';

  @override
  String get messageLimitReachedMessage => 'Bạn đã gửi 5 tin nhắn hôm nay. Nâng cấp lên Premium để trò chuyện không giới hạn!';

  @override
  String get historyLimitReached => 'Truy Cập Lịch Sử Bị Giới Hạn';

  @override
  String get historyLimitReachedMessage => 'Nâng cấp lên Premium để truy cập lịch sử quét đầy đủ của bạn!';

  @override
  String get upgradeToPremium => 'Nâng Cấp Lên Premium';

  @override
  String get upgradeToView => 'Nâng Cấp Để Xem';

  @override
  String get upgradeToChat => 'Nâng Cấp Để Trò Chuyện';

  @override
  String get premiumFeature => 'Tính Năng Premium';

  @override
  String get freePlanUsage => 'Sử Dụng Gói Miễn Phí';

  @override
  String get scansThisWeek => 'Số lần quét trong tuần';

  @override
  String get messagesToday => 'Tin nhắn hôm nay';

  @override
  String get limitsReached => 'Đã đạt giới hạn';

  @override
  String get remainingScans => 'Số lần quét còn lại';

  @override
  String get remainingMessages => 'Tin nhắn còn lại';

  @override
  String get unlockUnlimitedAccess => 'Mở Khóa Truy Cập Không Giới Hạn';

  @override
  String get upgradeToPremiumDescription => 'Nhận quét không giới hạn, tin nhắn không giới hạn và truy cập đầy đủ lịch sử quét của bạn với Premium!';

  @override
  String get premiumBenefits => 'Lợi Ích Premium';

  @override
  String get unlimitedAiChatMessages => 'Tin nhắn trò chuyện AI không giới hạn';

  @override
  String get fullAccessToScanHistory => 'Truy cập đầy đủ lịch sử quét';

  @override
  String get prioritySupport => 'Hỗ trợ ưu tiên';

  @override
  String get learnMore => 'Tìm Hiểu Thêm';

  @override
  String get upgradeNow => 'Nâng Cấp Ngay';

  @override
  String get maybeLater => 'Để Sau';

  @override
  String get scanHistoryLimit => 'Chỉ có lần quét gần nhất hiển thị trong lịch sử';

  @override
  String get upgradeForUnlimitedScans => 'Nâng cấp để quét không giới hạn!';

  @override
  String get upgradeForUnlimitedChat => 'Nâng cấp để trò chuyện không giới hạn!';

  @override
  String get slowInternetConnection => 'Kết Nối Internet Chậm';

  @override
  String get slowInternetMessage => 'Với kết nối internet rất chậm, bạn sẽ phải đợi một chút... Chúng tôi vẫn đang phân tích hình ảnh của bạn.';

  @override
  String get revolutionaryAI => 'AI Cách Mạng';

  @override
  String get revolutionaryAIDesc => 'Một trong những AI thông minh nhất thế giới';

  @override
  String get unlimitedScans => 'Quét Không Giới Hạn';

  @override
  String get unlimitedScansDesc => 'Khám phá mỹ phẩm không giới hạn';

  @override
  String get unlimitedChats => 'Trò Chuyện Không Giới Hạn';

  @override
  String get unlimitedChatsDesc => 'Cố vấn AI cá nhân 24/7';

  @override
  String get fullHistory => 'Lịch Sử Đầy Đủ';

  @override
  String get fullHistoryDesc => 'Lịch sử quét không giới hạn';

  @override
  String get rememberContext => 'Nhớ Ngữ Cảnh';

  @override
  String get rememberContextDesc => 'AI nhớ các tin nhắn trước đó của bạn';

  @override
  String get allIngredientsInfo => 'Tất Cả Thông Tin Thành Phần';

  @override
  String get allIngredientsInfoDesc => 'Tìm hiểu tất cả chi tiết';

  @override
  String get noAds => '100% Không Quảng Cáo';

  @override
  String get noAdsDesc => 'Dành cho những người trân trọng thời gian';

  @override
  String get multiLanguage => 'Biết Hầu Hết Các Ngôn Ngữ';

  @override
  String get multiLanguageDesc => 'Trình dịch được nâng cấp';

  @override
  String get paywallTitle => 'Mở khóa bí mật mỹ phẩm của bạn với AI';

  @override
  String paywallDescription(String price) {
    return 'Bạn có cơ hội nhận đăng ký Premium miễn phí trong 3 ngày, sau đó $price mỗi tuần. Hủy bất cứ lúc nào.';
  }

  @override
  String get whatsIncluded => 'Bao Gồm Những Gì';

  @override
  String get basicPlan => 'Cơ Bản';

  @override
  String get premiumPlan => 'Premium';

  @override
  String get botGreeting1 => 'Chào ngày tốt lành! Tôi có thể giúp gì cho bạn hôm nay?';

  @override
  String get botGreeting2 => 'Xin chào! Điều gì đưa bạn đến với tôi?';

  @override
  String get botGreeting3 => 'Tôi chào mừng bạn! Sẵn sàng giúp phân tích mỹ phẩm.';

  @override
  String get botGreeting4 => 'Rất vui được gặp bạn! Tôi có thể hữu ích như thế nào?';

  @override
  String get botGreeting5 => 'Chào mừng! Hãy cùng khám phá thành phần mỹ phẩm của bạn.';

  @override
  String get botGreeting6 => 'Xin chào! Sẵn sàng trả lời câu hỏi của bạn về mỹ phẩm.';

  @override
  String get botGreeting7 => 'Chào bạn! Tôi là trợ lý mỹ phẩm học cá nhân của bạn.';

  @override
  String get botGreeting8 => 'Chào ngày tốt lành! Tôi sẽ giúp bạn hiểu thành phần sản phẩm mỹ phẩm.';

  @override
  String get botGreeting9 => 'Xin chào! Hãy cùng làm cho mỹ phẩm của bạn an toàn hơn.';

  @override
  String get botGreeting10 => 'Tôi chào mừng bạn! Sẵn sàng chia sẻ kiến thức về mỹ phẩm.';

  @override
  String get botGreeting11 => 'Chào ngày tốt lành! Tôi sẽ giúp bạn tìm giải pháp mỹ phẩm tốt nhất cho bạn.';

  @override
  String get botGreeting12 => 'Xin chào! Chuyên gia an toàn mỹ phẩm của bạn sẵn sàng phục vụ.';

  @override
  String get botGreeting13 => 'Chào bạn! Hãy cùng chọn mỹ phẩm hoàn hảo cho bạn.';

  @override
  String get botGreeting14 => 'Chào mừng! Sẵn sàng giúp phân tích thành phần.';

  @override
  String get botGreeting15 => 'Xin chào! Tôi sẽ giúp bạn hiểu thành phần mỹ phẩm của bạn.';

  @override
  String get botGreeting16 => 'Tôi chào mừng bạn! Người hướng dẫn của bạn trong thế giới mỹ phẩm sẵn sàng giúp đỡ.';

  @override
  String get copiedToClipboard => 'Đã sao chép vào clipboard';

  @override
  String get tryFree => 'Dùng Thử Miễn Phí';

  @override
  String get cameraNotReady => 'Camera chưa sẵn sàng / không có quyền';

  @override
  String get cameraPermissionInstructions => 'Cài Đặt Ứng Dụng:\nAI Cosmetic Scanner > Quyền > Camera > Cho phép';

  @override
  String get openSettingsAndGrantAccess => 'Mở Cài Đặt và cấp quyền truy cập camera';

  @override
  String get retryCamera => 'Thử Lại';

  @override
  String get errorServiceOverloaded => 'Dịch vụ tạm thời bận. Vui lòng thử lại sau một lúc.';

  @override
  String get errorRateLimitExceeded => 'Quá nhiều yêu cầu. Vui lòng đợi một chút và thử lại.';

  @override
  String get errorTimeout => 'Yêu cầu hết thời gian. Vui lòng kiểm tra kết nối internet và thử lại.';

  @override
  String get errorNetwork => 'Lỗi mạng. Vui lòng kiểm tra kết nối internet của bạn.';

  @override
  String get errorAuthentication => 'Lỗi xác thực. Vui lòng khởi động lại ứng dụng.';

  @override
  String get errorInvalidResponse => 'Nhận được phản hồi không hợp lệ. Vui lòng thử lại.';

  @override
  String get errorServer => 'Lỗi máy chủ. Vui lòng thử lại sau.';

  @override
  String get customThemes => 'Chủ Đề Tùy Chỉnh';

  @override
  String get createCustomTheme => 'Tạo Chủ Đề Tùy Chỉnh';

  @override
  String get basedOn => 'Dựa Trên';

  @override
  String get lightMode => 'Sáng';

  @override
  String get generateWithAI => 'Tạo Bằng AI';

  @override
  String get resetToBaseTheme => 'Đặt Lại Về Chủ Đề Gốc';

  @override
  String colorsResetTo(Object themeName) {
    return 'Màu sắc đã đặt lại về $themeName';
  }

  @override
  String get aiGenerationComingSoon => 'Tạo chủ đề bằng AI sẽ có trong Phiên bản 5!';

  @override
  String get onboardingGreeting => 'Chào mừng! Để cải thiện chất lượng câu trả lời, hãy thiết lập hồ sơ của bạn';

  @override
  String get letsGo => 'Bắt Đầu Thôi';

  @override
  String get next => 'Tiếp Theo';

  @override
  String get finish => 'Hoàn Thành';

  @override
  String get customThemeInDevelopment => 'Tính năng chủ đề tùy chỉnh đang được phát triển';

  @override
  String get customThemeComingSoon => 'Sắp có trong các bản cập nhật tương lai';

  @override
  String get dailyMessageLimitReached => 'Đã Đạt Giới Hạn';

  @override
  String get dailyMessageLimitReachedMessage => 'Bạn đã gửi 5 tin nhắn hôm nay. Nâng cấp lên Premium để trò chuyện không giới hạn!';

  @override
  String get upgradeToPremiumForUnlimitedChat => 'Nâng cấp lên Premium để trò chuyện không giới hạn';

  @override
  String get messagesLeftToday => 'tin nhắn còn lại hôm nay';

  @override
  String get designYourOwnTheme => 'Thiết kế chủ đề riêng của bạn';

  @override
  String get darkOcean => 'Đại Dương Tối';

  @override
  String get darkForest => 'Rừng Tối';

  @override
  String get darkSunset => 'Hoàng Hôn Tối';

  @override
  String get darkVibrant => 'Rực Rỡ Tối';

  @override
  String get darkOceanThemeDescription => 'Chủ đề đại dương tối với điểm nhấn cyan';

  @override
  String get darkForestThemeDescription => 'Chủ đề rừng tối với điểm nhấn xanh chanh';

  @override
  String get darkSunsetThemeDescription => 'Chủ đề hoàng hôn tối với điểm nhấn cam';

  @override
  String get darkVibrantThemeDescription => 'Chủ đề rực rỡ tối với điểm nhấn hồng và tím';

  @override
  String get customTheme => 'Chủ đề tùy chỉnh';

  @override
  String get edit => 'Chỉnh Sửa';

  @override
  String get deleteTheme => 'Xóa Chủ Đề';

  @override
  String deleteThemeConfirmation(String themeName) {
    return 'Bạn có chắc chắn muốn xóa \"$themeName\" không?';
  }

  @override
  String get pollTitle => 'Thiếu gì?';

  @override
  String get pollCardTitle => 'Ứng dụng thiếu gì?';

  @override
  String get pollDescription => 'Bình chọn các tùy chọn bạn muốn thấy';

  @override
  String get submitVote => 'Bình Chọn';

  @override
  String get submitting => 'Đang gửi...';

  @override
  String get voteSubmittedSuccess => 'Đã gửi bình chọn thành công!';

  @override
  String votesRemaining(int count) {
    return 'Còn $count lượt bình chọn';
  }

  @override
  String get votes => 'lượt bình chọn';

  @override
  String get addYourOption => 'Đề xuất cải thiện';

  @override
  String get enterYourOption => 'Nhập tùy chọn của bạn...';

  @override
  String get add => 'Thêm';

  @override
  String get filterTopVoted => 'Phổ Biến';

  @override
  String get filterNewest => 'Mới';

  @override
  String get filterMyOption => 'Lựa Chọn Của Tôi';

  @override
  String get thankYouForVoting => 'Cảm ơn bạn đã bình chọn!';

  @override
  String get votingComplete => 'Bình chọn của bạn đã được ghi nhận';

  @override
  String get requestFeatureDevelopment => 'Yêu Cầu Phát Triển Tính Năng Tùy Chỉnh';

  @override
  String get requestFeatureDescription => 'Cần một tính năng cụ thể? Liên hệ với chúng tôi để thảo luận về phát triển tùy chỉnh cho nhu cầu kinh doanh của bạn.';

  @override
  String get pollHelpTitle => 'Cách bình chọn';

  @override
  String get pollHelpDescription => '• Nhấn vào tùy chọn để chọn\n• Nhấn lại để bỏ chọn\n• Chọn bao nhiêu tùy chọn tùy thích\n• Nhấn nút \'Bình Chọn\' để gửi\n• Thêm tùy chọn của bạn nếu không thấy những gì bạn cần';

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
