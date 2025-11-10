// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appName => 'AI Cosmetic Scanner';

  @override
  String get skinAnalysis => '肌肤分析';

  @override
  String get checkYourCosmetics => '检查你的化妆品';

  @override
  String get startScanning => '开始扫描';

  @override
  String get quickActions => '快捷操作';

  @override
  String get scanHistory => '扫描历史';

  @override
  String get aiChat => 'AI Cosmetic Scanner';

  @override
  String get profile => '个人资料';

  @override
  String get settings => '设置';

  @override
  String get skinType => '肤质';

  @override
  String get allergiesSensitivities => '过敏和敏感';

  @override
  String get subscription => '订阅';

  @override
  String get age => '年龄';

  @override
  String get language => '语言';

  @override
  String get selectYourPreferredLanguage => '选择你的首选语言';

  @override
  String get save => '保存';

  @override
  String get language_en => '英语';

  @override
  String get language_ru => '俄语';

  @override
  String get language_uk => '乌克兰语';

  @override
  String get language_es => '西班牙语';

  @override
  String get language_de => '德语';

  @override
  String get language_fr => '法语';

  @override
  String get language_it => '意大利语';

  @override
  String get language_ar => '阿拉伯语';

  @override
  String get language_ko => '韩语';

  @override
  String get language_cs => '捷克语';

  @override
  String get language_da => '丹麦语';

  @override
  String get language_el => '希腊语';

  @override
  String get language_fi => '芬兰语';

  @override
  String get language_hi => '印地语';

  @override
  String get language_hu => '匈牙利语';

  @override
  String get language_id => '印度尼西亚语';

  @override
  String get language_ja => '日语';

  @override
  String get language_nl => '荷兰语';

  @override
  String get language_no => '挪威语';

  @override
  String get language_pl => '波兰语';

  @override
  String get language_pt => '葡萄牙语';

  @override
  String get language_ro => '罗马尼亚语';

  @override
  String get language_sv => '瑞典语';

  @override
  String get language_th => '泰语';

  @override
  String get language_tr => '土耳其语';

  @override
  String get language_vi => '越南语';

  @override
  String get language_zh => '中文';

  @override
  String get selectIngredientsAllergicSensitive => '选择你敏感的成分';

  @override
  String get commonAllergens => '常见过敏原';

  @override
  String get fragrance => '香精';

  @override
  String get parabens => '对羟基苯甲酸酯';

  @override
  String get sulfates => '硫酸盐';

  @override
  String get alcohol => '酒精';

  @override
  String get essentialOils => '精油';

  @override
  String get silicones => '硅';

  @override
  String get mineralOil => '矿物油';

  @override
  String get formaldehyde => '甲醛';

  @override
  String get addCustomAllergen => '添加自定义过敏原';

  @override
  String get typeIngredientName => '输入成分名称...';

  @override
  String get selectedAllergens => '已选过敏原';

  @override
  String saveSelected(int count) {
    return '保存 ($count 个已选)';
  }

  @override
  String get analysisResults => '分析结果';

  @override
  String get overallSafetyScore => '总体安全评分';

  @override
  String get personalizedWarnings => '个性化警告';

  @override
  String ingredientsAnalysis(int count) {
    return '成分分析 ($count)';
  }

  @override
  String get highRisk => '高风险';

  @override
  String get moderateRisk => '中度风险';

  @override
  String get lowRisk => '低风险';

  @override
  String get benefitsAnalysis => '功效分析';

  @override
  String get recommendedAlternatives => '推荐替代品';

  @override
  String get reason => '原因:';

  @override
  String get quickSummary => '快速摘要';

  @override
  String get ingredientsChecked => '成分已检测';

  @override
  String get personalWarnings => '个人警告';

  @override
  String get ourVerdict => '我们的评价';

  @override
  String get productInfo => '产品信息';

  @override
  String get productType => '产品类型';

  @override
  String get brand => '品牌';

  @override
  String get premiumInsights => '高级见解';

  @override
  String get researchArticles => '研究文章';

  @override
  String get categoryRanking => '类别排名';

  @override
  String get safetyTrend => '安全趋势';

  @override
  String get saveToFavorites => '保存';

  @override
  String get shareResults => '分享';

  @override
  String get compareProducts => '对比';

  @override
  String get exportPDF => 'PDF';

  @override
  String get scanSimilar => '相似';

  @override
  String get aiChatTitle => 'AI Cosmetic Scanner';

  @override
  String get typeYourMessage => '输入你的消息...';

  @override
  String get errorSupabaseClientNotInitialized => '错误:Supabase客户端未初始化。';

  @override
  String get serverError => '服务器错误:';

  @override
  String get networkErrorOccurred => '网络错误。请稍后重试。';

  @override
  String get sorryAnErrorOccurred => '抱歉,出错了。请重试。';

  @override
  String get couldNotGetResponse => '无法获得响应。';

  @override
  String get aiAssistant => 'AI助手';

  @override
  String get online => '在线';

  @override
  String get typing => '正在输入...';

  @override
  String get writeAMessage => '写消息...';

  @override
  String get hiIAmYourAIAssistantHowCanIHelp => '你好!我是你的AI助手。我能帮你什么?';

  @override
  String get iCanSeeYourScanResultsFeelFreeToAskMeAnyQuestionsAboutTheIngredientsSafetyConcernsOrRecommendations => '我可以看到你的扫描结果!随时向我询问有关成分、安全问题或建议的任何问题。';

  @override
  String get userQuestion => '用户问题:';

  @override
  String get databaseExplorer => '数据库浏览器';

  @override
  String get currentUser => '当前用户:';

  @override
  String get notSignedIn => '未登录';

  @override
  String get failedToFetchTables => '获取表失败:';

  @override
  String get tablesInYourSupabaseDatabase => '你的Supabase数据库中的表:';

  @override
  String get viewSampleData => '查看示例数据';

  @override
  String get failedToFetchSampleDataFor => '获取示例数据失败';

  @override
  String get sampleData => '示例数据:';

  @override
  String get aiChats => 'AI Cosmetic Scanners';

  @override
  String get noDialoguesYet => '还没有对话。';

  @override
  String get startANewChat => '开始新聊天!';

  @override
  String get created => '创建于:';

  @override
  String get failedToSaveImage => '保存图片失败:';

  @override
  String get editName => '编辑名称';

  @override
  String get enterYourName => '输入你的名字';

  @override
  String get cancel => '取消';

  @override
  String get premiumUser => '高级用户';

  @override
  String get freeUser => '免费用户';

  @override
  String get skinProfile => '肌肤档案';

  @override
  String get notSet => '未设置';

  @override
  String get legal => '法律';

  @override
  String get privacyPolicy => '隐私政策';

  @override
  String get termsOfService => '服务条款';

  @override
  String get dataManagement => '数据管理';

  @override
  String get clearAllData => '清除所有数据';

  @override
  String get clearAllDataConfirmation => '确定要删除所有本地数据吗?此操作无法撤销。';

  @override
  String get selectDataToClear => '选择要清除的数据';

  @override
  String get scanResults => '扫描结果';

  @override
  String get chatHistory => '聊天';

  @override
  String get personalData => '个人数据';

  @override
  String get clearData => '清除数据';

  @override
  String get allLocalDataHasBeenCleared => '数据已清除。';

  @override
  String get signOut => '退出';

  @override
  String get deleteScan => '删除扫描';

  @override
  String get deleteScanConfirmation => '确定要从历史记录中删除此扫描吗?';

  @override
  String get deleteChat => '删除聊天';

  @override
  String get deleteChatConfirmation => '确定要删除此聊天吗?所有消息都将丢失。';

  @override
  String get delete => '删除';

  @override
  String get noScanHistoryFound => '未找到扫描历史。';

  @override
  String get scanOn => '扫描于';

  @override
  String get ingredientsFound => '找到成分';

  @override
  String get noCamerasFoundOnThisDevice => '此设备上未找到摄像头。';

  @override
  String get failedToInitializeCamera => '初始化摄像头失败:';

  @override
  String get analysisFailed => '分析失败:';

  @override
  String get analyzingPleaseWait => '正在分析,请稍候...';

  @override
  String get positionTheLabelWithinTheFrame => '将摄像头对准成分表';

  @override
  String get createAccount => '创建账号';

  @override
  String get signUpToGetStarted => '注册开始使用';

  @override
  String get fullName => '全名';

  @override
  String get pleaseEnterYourName => '请输入你的名字';

  @override
  String get email => '邮箱';

  @override
  String get pleaseEnterYourEmail => '请输入你的邮箱';

  @override
  String get pleaseEnterAValidEmail => '请输入有效的邮箱';

  @override
  String get password => '密码';

  @override
  String get pleaseEnterYourPassword => '请输入你的密码';

  @override
  String get passwordMustBeAtLeast6Characters => '密码必须至少6个字符';

  @override
  String get signUp => '注册';

  @override
  String get orContinueWith => '或继续使用';

  @override
  String get google => 'Google';

  @override
  String get apple => 'Apple';

  @override
  String get alreadyHaveAnAccount => '已有账号? ';

  @override
  String get signIn => '登录';

  @override
  String get selectYourSkinTypeDescription => '选择你的肤质';

  @override
  String get normal => '中性';

  @override
  String get normalSkinDescription => '平衡,不太油也不太干';

  @override
  String get dry => '干性';

  @override
  String get drySkinDescription => '紧绷、脱皮、粗糙';

  @override
  String get oily => '油性';

  @override
  String get oilySkinDescription => '油光、毛孔粗大、易长痘';

  @override
  String get combination => '混合性';

  @override
  String get combinationSkinDescription => 'T区油、两颊干';

  @override
  String get sensitive => '敏感';

  @override
  String get sensitiveSkinDescription => '易刺激、易泛红';

  @override
  String get selectSkinType => '选择肤质';

  @override
  String get restore => '恢复';

  @override
  String get restorePurchases => '恢复购买';

  @override
  String get subscriptionRestored => '订阅恢复成功!';

  @override
  String get noPurchasesToRestore => '没有可恢复的购买';

  @override
  String get goPremium => '升级高级版';

  @override
  String get unlockExclusiveFeatures => '解锁独家功能,充分利用肌肤分析。';

  @override
  String get unlimitedProductScans => '无限产品扫描';

  @override
  String get advancedAIIngredientAnalysis => '高级AI成分分析';

  @override
  String get fullScanAndSearchHistory => '完整扫描和搜索历史';

  @override
  String get adFreeExperience => '100%无广告体验';

  @override
  String get yearly => '年度';

  @override
  String savePercentage(int percentage) {
    return '节省 $percentage%';
  }

  @override
  String get monthly => '月度';

  @override
  String get perMonth => '/ 月';

  @override
  String get startFreeTrial => '开始免费试用';

  @override
  String trialDescription(String planName) {
    return '7天免费试用,然后按$planName收费。随时取消。';
  }

  @override
  String get home => '首页';

  @override
  String get scan => '扫描';

  @override
  String get aiChatNav => 'AI Cosmetic Scanner';

  @override
  String get profileNav => '个人资料';

  @override
  String get doYouEnjoyOurApp => '你喜欢我们的应用吗?';

  @override
  String get notReally => '不太喜欢';

  @override
  String get yesItsGreat => '喜欢';

  @override
  String get rateOurApp => '给应用评分';

  @override
  String get bestRatingWeCanGet => '我们能获得的最高评分';

  @override
  String get rateOnGooglePlay => '在Google Play评分';

  @override
  String get rate => '评分';

  @override
  String get whatCanBeImproved => '有什么可以改进的?';

  @override
  String get wereSorryYouDidntHaveAGreatExperience => '很抱歉你没有很好的体验。请告诉我们哪里出了问题。';

  @override
  String get yourFeedback => '你的反馈...';

  @override
  String get sendFeedback => '发送反馈';

  @override
  String get thankYouForYourFeedback => '感谢你的反馈!';

  @override
  String get discussWithAI => '与AI讨论';

  @override
  String get enterYourEmail => '输入你的邮箱';

  @override
  String get enterYourPassword => '输入你的密码';

  @override
  String get aiDisclaimer => 'AI响应可能包含不准确信息。请验证重要信息。';

  @override
  String get applicationThemes => '应用主题';

  @override
  String get highestRating => '最高评分';

  @override
  String get selectYourAgeDescription => '选择你的年龄';

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
  String get ageRange18_25Description => '年轻肌肤,预防';

  @override
  String get ageRange26_35Description => '初老迹象';

  @override
  String get ageRange36_45Description => '抗衰老护理';

  @override
  String get ageRange46_55Description => '密集护理';

  @override
  String get ageRange56PlusDescription => '专业护理';

  @override
  String get userName => '你的名字';

  @override
  String get tryFreeAndSubscribe => '免费试用并订阅';

  @override
  String get personalAIConsultant => '个人AI顾问24/7';

  @override
  String get subscribe => '订阅';

  @override
  String get themes => '主题';

  @override
  String get selectPreferredTheme => '选择你喜欢的主题';

  @override
  String get naturalTheme => '自然';

  @override
  String get darkTheme => '暗色';

  @override
  String get darkNatural => '暗色自然';

  @override
  String get oceanTheme => '海洋';

  @override
  String get forestTheme => '森林';

  @override
  String get sunsetTheme => '日落';

  @override
  String get naturalThemeDescription => '环保色彩的自然主题';

  @override
  String get darkThemeDescription => '舒适眼睛的暗色主题';

  @override
  String get oceanThemeDescription => '清新海洋主题';

  @override
  String get forestThemeDescription => '自然森林主题';

  @override
  String get sunsetThemeDescription => '温暖日落主题';

  @override
  String get sunnyTheme => '阳光';

  @override
  String get sunnyThemeDescription => '明亮欢快的黄色主题';

  @override
  String get vibrantTheme => '活力';

  @override
  String get vibrantThemeDescription => '明亮的粉紫主题';

  @override
  String get scanAnalysis => '扫描分析';

  @override
  String get ingredients => '成分';

  @override
  String get aiBotSettings => 'AI设置';

  @override
  String get botName => '机器人名称';

  @override
  String get enterBotName => '输入机器人名称';

  @override
  String get pleaseEnterBotName => '请输入机器人名称';

  @override
  String get botDescription => '机器人描述';

  @override
  String get selectAvatar => '选择头像';

  @override
  String get defaultBotName => 'ACS';

  @override
  String defaultBotDescription(String name) {
    return '你好!我是$name(AI Cosmetic Scanner)。我会帮助你了解化妆品的成分。我在化妆品学和护肤方面有广泛的知识。我很乐意回答你的所有问题。';
  }

  @override
  String get settingsSaved => '设置保存成功';

  @override
  String get failedToSaveSettings => '保存设置失败';

  @override
  String get resetToDefault => '重置为默认';

  @override
  String get resetSettings => '重置设置';

  @override
  String get resetSettingsConfirmation => '确定要将所有设置重置为默认值吗?';

  @override
  String get settingsResetSuccessfully => '设置重置成功';

  @override
  String get failedToResetSettings => '重置设置失败';

  @override
  String get unsavedChanges => '未保存的更改';

  @override
  String get unsavedChangesMessage => '你有未保存的更改。确定要离开吗?';

  @override
  String get stay => '留下';

  @override
  String get leave => '离开';

  @override
  String get errorLoadingSettings => '加载设置时出错';

  @override
  String get retry => '重试';

  @override
  String get customPrompt => '特殊要求';

  @override
  String get customPromptDescription => '为AI助手添加个性化指令';

  @override
  String get customPromptPlaceholder => '输入你的特殊要求...';

  @override
  String get enableCustomPrompt => '启用特殊要求';

  @override
  String get defaultCustomPrompt => '夸夸我。';

  @override
  String get close => '关闭';

  @override
  String get scanningHintTitle => '如何扫描';

  @override
  String get scanLimitReached => '已达扫描限制';

  @override
  String get scanLimitReachedMessage => '你已用完本周5次免费扫描。升级到高级版可无限扫描!';

  @override
  String get messageLimitReached => '已达每日消息限制';

  @override
  String get messageLimitReachedMessage => '你今天已发送5条消息。升级到高级版可无限聊天!';

  @override
  String get historyLimitReached => '历史访问受限';

  @override
  String get historyLimitReachedMessage => '升级到高级版以访问完整扫描历史!';

  @override
  String get upgradeToPremium => '升级到高级版';

  @override
  String get upgradeToView => '升级查看';

  @override
  String get upgradeToChat => '升级聊天';

  @override
  String get premiumFeature => '高级功能';

  @override
  String get freePlanUsage => '免费计划使用';

  @override
  String get scansThisWeek => '本周扫描';

  @override
  String get messagesToday => '今日消息';

  @override
  String get limitsReached => '已达限制';

  @override
  String get remainingScans => '剩余扫描';

  @override
  String get remainingMessages => '剩余消息';

  @override
  String get unlockUnlimitedAccess => '解锁无限访问';

  @override
  String get upgradeToPremiumDescription => '使用高级版获得无限扫描、无限消息和完整扫描历史访问!';

  @override
  String get premiumBenefits => '高级版权益';

  @override
  String get unlimitedAiChatMessages => '无限AI聊天消息';

  @override
  String get fullAccessToScanHistory => '完全访问扫描历史';

  @override
  String get prioritySupport => '优先支持';

  @override
  String get learnMore => '了解更多';

  @override
  String get upgradeNow => '立即升级';

  @override
  String get maybeLater => '稍后再说';

  @override
  String get scanHistoryLimit => '历史中仅显示最近一次扫描';

  @override
  String get upgradeForUnlimitedScans => '升级获取无限扫描!';

  @override
  String get upgradeForUnlimitedChat => '升级获取无限聊天!';

  @override
  String get slowInternetConnection => '网络连接缓慢';

  @override
  String get slowInternetMessage => '在非常慢的网络连接下,你需要等待一下...我们仍在分析你的图片。';

  @override
  String get revolutionaryAI => '革命性AI';

  @override
  String get revolutionaryAIDesc => '世界上最智能的AI之一';

  @override
  String get unlimitedScans => '无限扫描';

  @override
  String get unlimitedScansDesc => '无限探索化妆品';

  @override
  String get unlimitedChats => '无限聊天';

  @override
  String get unlimitedChatsDesc => '个人AI顾问24/7';

  @override
  String get fullHistory => '完整历史';

  @override
  String get fullHistoryDesc => '无限扫描历史';

  @override
  String get rememberContext => '记住上下文';

  @override
  String get rememberContextDesc => 'AI记住你之前的消息';

  @override
  String get allIngredientsInfo => '所有成分信息';

  @override
  String get allIngredientsInfoDesc => '了解所有细节';

  @override
  String get noAds => '100%无广告';

  @override
  String get noAdsDesc => '为珍惜时间的人准备';

  @override
  String get multiLanguage => '几乎懂所有语言';

  @override
  String get multiLanguageDesc => '增强型翻译器';

  @override
  String get paywallTitle => '用AI解锁化妆品的秘密';

  @override
  String paywallDescription(String price) {
    return '你有机会免费获得3天高级订阅,然后每周$price。随时取消。';
  }

  @override
  String get whatsIncluded => '包含内容';

  @override
  String get basicPlan => '基础';

  @override
  String get premiumPlan => '高级';

  @override
  String get botGreeting1 => '你好!今天我能帮你什么?';

  @override
  String get botGreeting2 => '你好!什么风把你吹来了?';

  @override
  String get botGreeting3 => '欢迎!准备好帮助你进行化妆品分析。';

  @override
  String get botGreeting4 => '很高兴见到你!我能帮什么忙?';

  @override
  String get botGreeting5 => '欢迎!让我们一起探索你的化妆品成分吧。';

  @override
  String get botGreeting6 => '你好!准备好回答你关于化妆品的问题。';

  @override
  String get botGreeting7 => '嗨!我是你的个人化妆品学助手。';

  @override
  String get botGreeting8 => '你好!我会帮助你了解化妆品的成分。';

  @override
  String get botGreeting9 => '你好!让我们一起让你的化妆品更安全。';

  @override
  String get botGreeting10 => '欢迎!准备好分享化妆品知识。';

  @override
  String get botGreeting11 => '你好!我会帮你找到最适合你的化妆品解决方案。';

  @override
  String get botGreeting12 => '你好!你的化妆品安全专家随时为你服务。';

  @override
  String get botGreeting13 => '嗨!让我们一起为你选择完美的化妆品。';

  @override
  String get botGreeting14 => '欢迎!准备好帮助你进行成分分析。';

  @override
  String get botGreeting15 => '你好!我会帮助你了解化妆品的成分。';

  @override
  String get botGreeting16 => '欢迎!你的化妆品学世界向导随时准备帮助。';

  @override
  String get copiedToClipboard => '已复制到剪贴板';

  @override
  String get tryFree => '免费试用';

  @override
  String get cameraNotReady => '摄像头未就绪/无权限';

  @override
  String get cameraPermissionInstructions => '应用设置:\nAI Cosmetic Scanner > 权限 > 摄像头 > 允许';

  @override
  String get openSettingsAndGrantAccess => '打开设置并授予摄像头访问权限';

  @override
  String get retryCamera => '重试';

  @override
  String get errorServiceOverloaded => '服务暂时繁忙。请稍后重试。';

  @override
  String get errorRateLimitExceeded => '请求过多。请稍等片刻后重试。';

  @override
  String get errorTimeout => '请求超时。请检查网络连接后重试。';

  @override
  String get errorNetwork => '网络错误。请检查你的网络连接。';

  @override
  String get errorAuthentication => '身份验证错误。请重启应用。';

  @override
  String get errorInvalidResponse => '收到无效响应。请重试。';

  @override
  String get errorServer => '服务器错误。请稍后重试。';

  @override
  String get customThemes => '自定义主题';

  @override
  String get createCustomTheme => '创建自定义主题';

  @override
  String get basedOn => '基于';

  @override
  String get lightMode => '浅色';

  @override
  String get generateWithAI => '用AI生成';

  @override
  String get resetToBaseTheme => '重置为基础主题';

  @override
  String colorsResetTo(Object themeName) {
    return '颜色已重置为$themeName';
  }

  @override
  String get aiGenerationComingSoon => 'AI主题生成将在第5次迭代中推出!';

  @override
  String get onboardingGreeting => '欢迎!为了提高答案质量,让我们设置你的个人资料';

  @override
  String get letsGo => '开始吧';

  @override
  String get next => '下一步';

  @override
  String get finish => '完成';

  @override
  String get customThemeInDevelopment => '自定义主题功能正在开发中';

  @override
  String get customThemeComingSoon => '即将在未来更新中推出';

  @override
  String get dailyMessageLimitReached => '已达限制';

  @override
  String get dailyMessageLimitReachedMessage => '你今天已发送5条消息。升级到高级版可无限聊天!';

  @override
  String get upgradeToPremiumForUnlimitedChat => '升级到高级版获取无限聊天';

  @override
  String get messagesLeftToday => '今天剩余消息';

  @override
  String get designYourOwnTheme => '设计你自己的主题';

  @override
  String get darkOcean => '深色海洋';

  @override
  String get darkForest => '深色森林';

  @override
  String get darkSunset => '深色日落';

  @override
  String get darkVibrant => '深色活力';

  @override
  String get darkOceanThemeDescription => '带青色点缀的深色海洋主题';

  @override
  String get darkForestThemeDescription => '带青柠色点缀的深色森林主题';

  @override
  String get darkSunsetThemeDescription => '带橙色点缀的深色日落主题';

  @override
  String get darkVibrantThemeDescription => '带粉紫色点缀的深色活力主题';

  @override
  String get customTheme => '自定义主题';

  @override
  String get edit => '编辑';

  @override
  String get deleteTheme => '删除主题';

  @override
  String deleteThemeConfirmation(String themeName) {
    return '确定要删除\"$themeName\"吗?';
  }

  @override
  String get pollTitle => '缺少什么?';

  @override
  String get pollCardTitle => '应用缺少什么?';

  @override
  String get pollCardSubtitle => '应该添加哪3个功能?';

  @override
  String get pollDescription => '为你想看到的选项投票';

  @override
  String get submitVote => '投票';

  @override
  String get submitting => '提交中...';

  @override
  String get voteSubmittedSuccess => '投票提交成功!';

  @override
  String votesRemaining(int count) {
    return '剩余$count票';
  }

  @override
  String get votes => '票';

  @override
  String get addYourOption => '建议改进';

  @override
  String get enterYourOption => '输入你的选项...';

  @override
  String get add => '添加';

  @override
  String get filterTopVoted => '热门';

  @override
  String get filterNewest => '最新';

  @override
  String get filterMyOption => '我的选择';

  @override
  String get thankYouForVoting => '感谢投票!';

  @override
  String get votingComplete => '你的投票已记录';

  @override
  String get requestFeatureDevelopment => '请求定制功能开发';

  @override
  String get requestFeatureDescription => '需要特定功能?联系我们讨论为你的业务需求定制开发。';

  @override
  String get pollHelpTitle => '如何投票';

  @override
  String get pollHelpDescription => '• 点击选项进行选择\n• 再次点击取消选择\n• 可以选择任意多个选项\n• 点击\'投票\'按钮提交\n• 如果没有看到需要的选项,可以添加自己的选项';
}

/// The translations for Chinese, as used in China (`zh_CN`).
class AppLocalizationsZhCn extends AppLocalizationsZh {
  AppLocalizationsZhCn(): super('zh_CN');

  @override
  String get appName => 'AI Cosmetic Scanner';

  @override
  String get skinAnalysis => '肌肤分析';

  @override
  String get checkYourCosmetics => '检查你的化妆品';

  @override
  String get startScanning => '开始扫描';

  @override
  String get quickActions => '快捷操作';

  @override
  String get scanHistory => '扫描历史';

  @override
  String get aiChat => 'AI Cosmetic Scanner';

  @override
  String get profile => '个人资料';

  @override
  String get settings => '设置';

  @override
  String get skinType => '肤质';

  @override
  String get allergiesSensitivities => '过敏和敏感';

  @override
  String get subscription => '订阅';

  @override
  String get age => '年龄';

  @override
  String get language => '语言';

  @override
  String get selectYourPreferredLanguage => '选择你的首选语言';

  @override
  String get save => '保存';

  @override
  String get language_en => 'English';

  @override
  String get language_ru => 'Russian';

  @override
  String get language_uk => 'Ukrainian';

  @override
  String get language_es => 'Spanish';

  @override
  String get language_de => 'German';

  @override
  String get language_fr => 'French';

  @override
  String get language_it => 'Italian';

  @override
  String get language_ar => 'العربية';

  @override
  String get language_ko => '한국어';

  @override
  String get language_cs => 'Čeština';

  @override
  String get language_da => 'Dansk';

  @override
  String get language_el => 'Ελληνικά';

  @override
  String get language_fi => 'Suomi';

  @override
  String get language_hi => 'हिन्दी';

  @override
  String get language_hu => 'Magyar';

  @override
  String get language_id => 'Bahasa Indonesia';

  @override
  String get language_ja => '日本語';

  @override
  String get language_nl => 'Nederlands';

  @override
  String get language_no => 'Norsk';

  @override
  String get language_pl => 'Polski';

  @override
  String get language_pt => 'Português';

  @override
  String get language_ro => 'Română';

  @override
  String get language_sv => 'Svenska';

  @override
  String get language_th => 'ไทย';

  @override
  String get language_tr => 'Türkçe';

  @override
  String get language_vi => 'Tiếng Việt';

  @override
  String get language_zh => '中文';

  @override
  String get selectIngredientsAllergicSensitive => '选择你敏感的成分';

  @override
  String get commonAllergens => '常见过敏原';

  @override
  String get fragrance => '香精';

  @override
  String get parabens => '对羟基苯甲酸酯';

  @override
  String get sulfates => '硫酸盐';

  @override
  String get alcohol => '酒精';

  @override
  String get essentialOils => '精油';

  @override
  String get silicones => '硅';

  @override
  String get mineralOil => '矿物油';

  @override
  String get formaldehyde => '甲醛';

  @override
  String get addCustomAllergen => '添加自定义过敏原';

  @override
  String get typeIngredientName => '输入成分名称...';

  @override
  String get selectedAllergens => '已选过敏原';

  @override
  String saveSelected(int count) {
    return '保存 ($count 个已选)';
  }

  @override
  String get analysisResults => '分析结果';

  @override
  String get overallSafetyScore => '总体安全评分';

  @override
  String get personalizedWarnings => '个性化警告';

  @override
  String ingredientsAnalysis(int count) {
    return '成分分析 ($count)';
  }

  @override
  String get highRisk => '高风险';

  @override
  String get moderateRisk => '中度风险';

  @override
  String get lowRisk => '低风险';

  @override
  String get benefitsAnalysis => '功效分析';

  @override
  String get recommendedAlternatives => '推荐替代品';

  @override
  String get reason => '原因:';

  @override
  String get quickSummary => '快速摘要';

  @override
  String get ingredientsChecked => '成分已检测';

  @override
  String get personalWarnings => '个人警告';

  @override
  String get ourVerdict => '我们的评价';

  @override
  String get productInfo => '产品信息';

  @override
  String get productType => '产品类型';

  @override
  String get brand => '品牌';

  @override
  String get premiumInsights => '高级见解';

  @override
  String get researchArticles => '研究文章';

  @override
  String get categoryRanking => '类别排名';

  @override
  String get safetyTrend => '安全趋势';

  @override
  String get saveToFavorites => '保存';

  @override
  String get shareResults => '分享';

  @override
  String get compareProducts => '对比';

  @override
  String get exportPDF => 'PDF';

  @override
  String get scanSimilar => '相似';

  @override
  String get aiChatTitle => 'AI Cosmetic Scanner';

  @override
  String get typeYourMessage => '输入你的消息...';

  @override
  String get errorSupabaseClientNotInitialized => '错误:Supabase客户端未初始化。';

  @override
  String get serverError => '服务器错误:';

  @override
  String get networkErrorOccurred => '网络错误。请稍后重试。';

  @override
  String get sorryAnErrorOccurred => '抱歉,出错了。请重试。';

  @override
  String get couldNotGetResponse => '无法获得响应。';

  @override
  String get aiAssistant => 'AI助手';

  @override
  String get online => '在线';

  @override
  String get typing => '正在输入...';

  @override
  String get writeAMessage => '写消息...';

  @override
  String get hiIAmYourAIAssistantHowCanIHelp => '你好!我是你的AI助手。我能帮你什么?';

  @override
  String get iCanSeeYourScanResultsFeelFreeToAskMeAnyQuestionsAboutTheIngredientsSafetyConcernsOrRecommendations => '我可以看到你的扫描结果!随时向我询问有关成分、安全问题或建议的任何问题。';

  @override
  String get userQuestion => '用户问题:';

  @override
  String get databaseExplorer => '数据库浏览器';

  @override
  String get currentUser => '当前用户:';

  @override
  String get notSignedIn => '未登录';

  @override
  String get failedToFetchTables => '获取表失败:';

  @override
  String get tablesInYourSupabaseDatabase => '你的Supabase数据库中的表:';

  @override
  String get viewSampleData => '查看示例数据';

  @override
  String get failedToFetchSampleDataFor => '获取示例数据失败';

  @override
  String get sampleData => '示例数据:';

  @override
  String get aiChats => 'AI Cosmetic Scanners';

  @override
  String get noDialoguesYet => '还没有对话。';

  @override
  String get startANewChat => '开始新聊天!';

  @override
  String get created => '创建于:';

  @override
  String get failedToSaveImage => '保存图片失败:';

  @override
  String get editName => '编辑名称';

  @override
  String get enterYourName => '输入你的名字';

  @override
  String get cancel => '取消';

  @override
  String get premiumUser => '高级用户';

  @override
  String get freeUser => '免费用户';

  @override
  String get skinProfile => '肌肤档案';

  @override
  String get notSet => '未设置';

  @override
  String get legal => '法律';

  @override
  String get privacyPolicy => '隐私政策';

  @override
  String get termsOfService => '服务条款';

  @override
  String get dataManagement => '数据管理';

  @override
  String get clearAllData => '清除所有数据';

  @override
  String get clearAllDataConfirmation => '确定要删除所有本地数据吗?此操作无法撤销。';

  @override
  String get selectDataToClear => '选择要清除的数据';

  @override
  String get scanResults => '扫描结果';

  @override
  String get chatHistory => '聊天';

  @override
  String get personalData => '个人数据';

  @override
  String get clearData => '清除数据';

  @override
  String get allLocalDataHasBeenCleared => '数据已清除。';

  @override
  String get signOut => '退出';

  @override
  String get deleteScan => '删除扫描';

  @override
  String get deleteScanConfirmation => '确定要从历史记录中删除此扫描吗?';

  @override
  String get deleteChat => '删除聊天';

  @override
  String get deleteChatConfirmation => '确定要删除此聊天吗?所有消息都将丢失。';

  @override
  String get delete => '删除';

  @override
  String get noScanHistoryFound => '未找到扫描历史。';

  @override
  String get scanOn => '扫描于';

  @override
  String get ingredientsFound => '找到成分';

  @override
  String get noCamerasFoundOnThisDevice => '此设备上未找到摄像头。';

  @override
  String get failedToInitializeCamera => '初始化摄像头失败:';

  @override
  String get analysisFailed => '分析失败:';

  @override
  String get analyzingPleaseWait => '正在分析,请稍候...';

  @override
  String get positionTheLabelWithinTheFrame => '将摄像头对准成分表';

  @override
  String get createAccount => '创建账号';

  @override
  String get signUpToGetStarted => '注册开始使用';

  @override
  String get fullName => '全名';

  @override
  String get pleaseEnterYourName => '请输入你的名字';

  @override
  String get email => '邮箱';

  @override
  String get pleaseEnterYourEmail => '请输入你的邮箱';

  @override
  String get pleaseEnterAValidEmail => '请输入有效的邮箱';

  @override
  String get password => '密码';

  @override
  String get pleaseEnterYourPassword => '请输入你的密码';

  @override
  String get passwordMustBeAtLeast6Characters => '密码必须至少6个字符';

  @override
  String get signUp => '注册';

  @override
  String get orContinueWith => '或继续使用';

  @override
  String get google => 'Google';

  @override
  String get apple => 'Apple';

  @override
  String get alreadyHaveAnAccount => '已有账号? ';

  @override
  String get signIn => '登录';

  @override
  String get selectYourSkinTypeDescription => '选择你的肤质';

  @override
  String get normal => '中性';

  @override
  String get normalSkinDescription => '平衡,不太油也不太干';

  @override
  String get dry => '干性';

  @override
  String get drySkinDescription => '紧绷、脱皮、粗糙';

  @override
  String get oily => '油性';

  @override
  String get oilySkinDescription => '油光、毛孔粗大、易长痘';

  @override
  String get combination => '混合性';

  @override
  String get combinationSkinDescription => 'T区油、两颊干';

  @override
  String get sensitive => '敏感';

  @override
  String get sensitiveSkinDescription => '易刺激、易泛红';

  @override
  String get selectSkinType => '选择肤质';

  @override
  String get restore => '恢复';

  @override
  String get restorePurchases => '恢复购买';

  @override
  String get subscriptionRestored => '订阅恢复成功!';

  @override
  String get noPurchasesToRestore => '没有可恢复的购买';

  @override
  String get goPremium => '升级高级版';

  @override
  String get unlockExclusiveFeatures => '解锁独家功能,充分利用肌肤分析。';

  @override
  String get unlimitedProductScans => '无限产品扫描';

  @override
  String get advancedAIIngredientAnalysis => '高级AI成分分析';

  @override
  String get fullScanAndSearchHistory => '完整扫描和搜索历史';

  @override
  String get adFreeExperience => '100%无广告体验';

  @override
  String get yearly => '年度';

  @override
  String savePercentage(int percentage) {
    return '节省 $percentage%';
  }

  @override
  String get monthly => '月度';

  @override
  String get perMonth => '/ 月';

  @override
  String get startFreeTrial => '开始免费试用';

  @override
  String trialDescription(String planName) {
    return '7天免费试用,然后按$planName收费。随时取消。';
  }

  @override
  String get home => '首页';

  @override
  String get scan => '扫描';

  @override
  String get aiChatNav => 'AI Cosmetic Scanner';

  @override
  String get profileNav => '个人资料';

  @override
  String get doYouEnjoyOurApp => '你喜欢我们的应用吗?';

  @override
  String get notReally => '不太喜欢';

  @override
  String get yesItsGreat => '喜欢';

  @override
  String get rateOurApp => '给应用评分';

  @override
  String get bestRatingWeCanGet => '我们能获得的最高评分';

  @override
  String get rateOnGooglePlay => '在Google Play评分';

  @override
  String get rate => '评分';

  @override
  String get whatCanBeImproved => '有什么可以改进的?';

  @override
  String get wereSorryYouDidntHaveAGreatExperience => '很抱歉你没有很好的体验。请告诉我们哪里出了问题。';

  @override
  String get yourFeedback => '你的反馈...';

  @override
  String get sendFeedback => '发送反馈';

  @override
  String get thankYouForYourFeedback => '感谢你的反馈!';

  @override
  String get discussWithAI => '与AI讨论';

  @override
  String get enterYourEmail => '输入你的邮箱';

  @override
  String get enterYourPassword => '输入你的密码';

  @override
  String get aiDisclaimer => 'AI响应可能包含不准确信息。请验证重要信息。';

  @override
  String get applicationThemes => '应用主题';

  @override
  String get highestRating => '最高评分';

  @override
  String get selectYourAgeDescription => '选择你的年龄';

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
  String get ageRange18_25Description => '年轻肌肤,预防';

  @override
  String get ageRange26_35Description => '初老迹象';

  @override
  String get ageRange36_45Description => '抗衰老护理';

  @override
  String get ageRange46_55Description => '密集护理';

  @override
  String get ageRange56PlusDescription => '专业护理';

  @override
  String get userName => '你的名字';

  @override
  String get tryFreeAndSubscribe => '免费试用并订阅';

  @override
  String get personalAIConsultant => '个人AI顾问24/7';

  @override
  String get subscribe => '订阅';

  @override
  String get themes => '主题';

  @override
  String get selectPreferredTheme => '选择你喜欢的主题';

  @override
  String get naturalTheme => '自然';

  @override
  String get darkTheme => '暗色';

  @override
  String get darkNatural => '暗色自然';

  @override
  String get oceanTheme => '海洋';

  @override
  String get forestTheme => '森林';

  @override
  String get sunsetTheme => '日落';

  @override
  String get naturalThemeDescription => '环保色彩的自然主题';

  @override
  String get darkThemeDescription => '舒适眼睛的暗色主题';

  @override
  String get oceanThemeDescription => '清新海洋主题';

  @override
  String get forestThemeDescription => '自然森林主题';

  @override
  String get sunsetThemeDescription => '温暖日落主题';

  @override
  String get sunnyTheme => '阳光';

  @override
  String get sunnyThemeDescription => '明亮欢快的黄色主题';

  @override
  String get vibrantTheme => '活力';

  @override
  String get vibrantThemeDescription => '明亮的粉紫主题';

  @override
  String get scanAnalysis => '扫描分析';

  @override
  String get ingredients => '成分';

  @override
  String get aiBotSettings => 'AI设置';

  @override
  String get botName => '机器人名称';

  @override
  String get enterBotName => '输入机器人名称';

  @override
  String get pleaseEnterBotName => '请输入机器人名称';

  @override
  String get botDescription => '机器人描述';

  @override
  String get selectAvatar => '选择头像';

  @override
  String get defaultBotName => 'ACS';

  @override
  String defaultBotDescription(String name) {
    return '你好!我是$name(AI Cosmetic Scanner)。我会帮助你了解化妆品的成分。我在化妆品学和护肤方面有广泛的知识。我很乐意回答你的所有问题。';
  }

  @override
  String get settingsSaved => '设置保存成功';

  @override
  String get failedToSaveSettings => '保存设置失败';

  @override
  String get resetToDefault => '重置为默认';

  @override
  String get resetSettings => '重置设置';

  @override
  String get resetSettingsConfirmation => '确定要将所有设置重置为默认值吗?';

  @override
  String get settingsResetSuccessfully => '设置重置成功';

  @override
  String get failedToResetSettings => '重置设置失败';

  @override
  String get unsavedChanges => '未保存的更改';

  @override
  String get unsavedChangesMessage => '你有未保存的更改。确定要离开吗?';

  @override
  String get stay => '留下';

  @override
  String get leave => '离开';

  @override
  String get errorLoadingSettings => '加载设置时出错';

  @override
  String get retry => '重试';

  @override
  String get customPrompt => '特殊要求';

  @override
  String get customPromptDescription => '为AI助手添加个性化指令';

  @override
  String get customPromptPlaceholder => '输入你的特殊要求...';

  @override
  String get enableCustomPrompt => '启用特殊要求';

  @override
  String get defaultCustomPrompt => '夸夸我。';

  @override
  String get close => '关闭';

  @override
  String get scanningHintTitle => '如何扫描';

  @override
  String get scanLimitReached => '已达扫描限制';

  @override
  String get scanLimitReachedMessage => '你已用完本周5次免费扫描。升级到高级版可无限扫描!';

  @override
  String get messageLimitReached => '已达每日消息限制';

  @override
  String get messageLimitReachedMessage => '你今天已发送5条消息。升级到高级版可无限聊天!';

  @override
  String get historyLimitReached => '历史访问受限';

  @override
  String get historyLimitReachedMessage => '升级到高级版以访问完整扫描历史!';

  @override
  String get upgradeToPremium => '升级到高级版';

  @override
  String get upgradeToView => '升级查看';

  @override
  String get upgradeToChat => '升级聊天';

  @override
  String get premiumFeature => '高级功能';

  @override
  String get freePlanUsage => '免费计划使用';

  @override
  String get scansThisWeek => '本周扫描';

  @override
  String get messagesToday => '今日消息';

  @override
  String get limitsReached => '已达限制';

  @override
  String get remainingScans => '剩余扫描';

  @override
  String get remainingMessages => '剩余消息';

  @override
  String get unlockUnlimitedAccess => '解锁无限访问';

  @override
  String get upgradeToPremiumDescription => '使用高级版获得无限扫描、无限消息和完整扫描历史访问!';

  @override
  String get premiumBenefits => '高级版权益';

  @override
  String get unlimitedAiChatMessages => '无限AI聊天消息';

  @override
  String get fullAccessToScanHistory => '完全访问扫描历史';

  @override
  String get prioritySupport => '优先支持';

  @override
  String get learnMore => '了解更多';

  @override
  String get upgradeNow => '立即升级';

  @override
  String get maybeLater => '稍后再说';

  @override
  String get scanHistoryLimit => '历史中仅显示最近一次扫描';

  @override
  String get upgradeForUnlimitedScans => '升级获取无限扫描!';

  @override
  String get upgradeForUnlimitedChat => '升级获取无限聊天!';

  @override
  String get slowInternetConnection => '网络连接缓慢';

  @override
  String get slowInternetMessage => '在非常慢的网络连接下,你需要等待一下...我们仍在分析你的图片。';

  @override
  String get revolutionaryAI => '革命性AI';

  @override
  String get revolutionaryAIDesc => '世界上最智能的AI之一';

  @override
  String get unlimitedScans => '无限扫描';

  @override
  String get unlimitedScansDesc => '无限探索化妆品';

  @override
  String get unlimitedChats => '无限聊天';

  @override
  String get unlimitedChatsDesc => '个人AI顾问24/7';

  @override
  String get fullHistory => '完整历史';

  @override
  String get fullHistoryDesc => '无限扫描历史';

  @override
  String get rememberContext => '记住上下文';

  @override
  String get rememberContextDesc => 'AI记住你之前的消息';

  @override
  String get allIngredientsInfo => '所有成分信息';

  @override
  String get allIngredientsInfoDesc => '了解所有细节';

  @override
  String get noAds => '100%无广告';

  @override
  String get noAdsDesc => '为珍惜时间的人准备';

  @override
  String get multiLanguage => '几乎懂所有语言';

  @override
  String get multiLanguageDesc => '增强型翻译器';

  @override
  String get paywallTitle => '用AI解锁化妆品的秘密';

  @override
  String paywallDescription(String price) {
    return '你有机会免费获得3天高级订阅,然后每周$price。随时取消。';
  }

  @override
  String get whatsIncluded => '包含内容';

  @override
  String get basicPlan => '基础';

  @override
  String get premiumPlan => '高级';

  @override
  String get botGreeting1 => '你好!今天我能帮你什么?';

  @override
  String get botGreeting2 => '你好!什么风把你吹来了?';

  @override
  String get botGreeting3 => '欢迎!准备好帮助你进行化妆品分析。';

  @override
  String get botGreeting4 => '很高兴见到你!我能帮什么忙?';

  @override
  String get botGreeting5 => '欢迎!让我们一起探索你的化妆品成分吧。';

  @override
  String get botGreeting6 => '你好!准备好回答你关于化妆品的问题。';

  @override
  String get botGreeting7 => '嗨!我是你的个人化妆品学助手。';

  @override
  String get botGreeting8 => '你好!我会帮助你了解化妆品的成分。';

  @override
  String get botGreeting9 => '你好!让我们一起让你的化妆品更安全。';

  @override
  String get botGreeting10 => '欢迎!准备好分享化妆品知识。';

  @override
  String get botGreeting11 => '你好!我会帮你找到最适合你的化妆品解决方案。';

  @override
  String get botGreeting12 => '你好!你的化妆品安全专家随时为你服务。';

  @override
  String get botGreeting13 => '嗨!让我们一起为你选择完美的化妆品。';

  @override
  String get botGreeting14 => '欢迎!准备好帮助你进行成分分析。';

  @override
  String get botGreeting15 => '你好!我会帮助你了解化妆品的成分。';

  @override
  String get botGreeting16 => '欢迎!你的化妆品学世界向导随时准备帮助。';

  @override
  String get copiedToClipboard => '已复制到剪贴板';

  @override
  String get tryFree => '免费试用';

  @override
  String get cameraNotReady => '摄像头未就绪/无权限';

  @override
  String get cameraPermissionInstructions => '应用设置:\nAI Cosmetic Scanner > 权限 > 摄像头 > 允许';

  @override
  String get openSettingsAndGrantAccess => '打开设置并授予摄像头访问权限';

  @override
  String get retryCamera => '重试';

  @override
  String get errorServiceOverloaded => '服务暂时繁忙。请稍后重试。';

  @override
  String get errorRateLimitExceeded => '请求过多。请稍等片刻后重试。';

  @override
  String get errorTimeout => '请求超时。请检查网络连接后重试。';

  @override
  String get errorNetwork => '网络错误。请检查你的网络连接。';

  @override
  String get errorAuthentication => '身份验证错误。请重启应用。';

  @override
  String get errorInvalidResponse => '收到无效响应。请重试。';

  @override
  String get errorServer => '服务器错误。请稍后重试。';

  @override
  String get customThemes => '自定义主题';

  @override
  String get createCustomTheme => '创建自定义主题';

  @override
  String get basedOn => '基于';

  @override
  String get lightMode => '浅色';

  @override
  String get generateWithAI => '用AI生成';

  @override
  String get resetToBaseTheme => '重置为基础主题';

  @override
  String colorsResetTo(Object themeName) {
    return '颜色已重置为$themeName';
  }

  @override
  String get aiGenerationComingSoon => 'AI主题生成将在第5次迭代中推出!';

  @override
  String get onboardingGreeting => '欢迎!为了提高答案质量,让我们设置你的个人资料';

  @override
  String get letsGo => '开始吧';

  @override
  String get next => '下一步';

  @override
  String get finish => '完成';

  @override
  String get customThemeInDevelopment => '自定义主题功能正在开发中';

  @override
  String get customThemeComingSoon => '即将在未来更新中推出';

  @override
  String get dailyMessageLimitReached => '已达限制';

  @override
  String get dailyMessageLimitReachedMessage => '你今天已发送5条消息。升级到高级版可无限聊天!';

  @override
  String get upgradeToPremiumForUnlimitedChat => '升级到高级版获取无限聊天';

  @override
  String get messagesLeftToday => '今天剩余消息';

  @override
  String get designYourOwnTheme => '设计你自己的主题';

  @override
  String get darkOcean => '深色海洋';

  @override
  String get darkForest => '深色森林';

  @override
  String get darkSunset => '深色日落';

  @override
  String get darkVibrant => '深色活力';

  @override
  String get darkOceanThemeDescription => '带青色点缀的深色海洋主题';

  @override
  String get darkForestThemeDescription => '带青柠色点缀的深色森林主题';

  @override
  String get darkSunsetThemeDescription => '带橙色点缀的深色日落主题';

  @override
  String get darkVibrantThemeDescription => '带粉紫色点缀的深色活力主题';

  @override
  String get customTheme => '自定义主题';

  @override
  String get edit => '编辑';

  @override
  String get deleteTheme => '删除主题';

  @override
  String deleteThemeConfirmation(String themeName) {
    return '确定要删除\"$themeName\"吗?';
  }

  @override
  String get pollTitle => '缺少什么?';

  @override
  String get pollCardTitle => '应用缺少什么?';

  @override
  String get pollCardSubtitle => '应该添加哪3个功能?';

  @override
  String get pollDescription => '为你想看到的选项投票';

  @override
  String get submitVote => '投票';

  @override
  String get submitting => '提交中...';

  @override
  String get voteSubmittedSuccess => '投票提交成功!';

  @override
  String votesRemaining(int count) {
    return '剩余$count票';
  }

  @override
  String get votes => '票';

  @override
  String get addYourOption => '建议改进';

  @override
  String get enterYourOption => '输入你的选项...';

  @override
  String get add => '添加';

  @override
  String get filterTopVoted => '热门';

  @override
  String get filterNewest => '最新';

  @override
  String get filterMyOption => '我的选择';

  @override
  String get thankYouForVoting => '感谢投票!';

  @override
  String get votingComplete => '你的投票已记录';

  @override
  String get requestFeatureDevelopment => '请求定制功能开发';

  @override
  String get requestFeatureDescription => '需要特定功能?联系我们讨论为你的业务需求定制开发。';

  @override
  String get pollHelpTitle => '如何投票';

  @override
  String get pollHelpDescription => '• 点击选项进行选择\n• 再次点击取消选择\n• 可以选择任意多个选项\n• 点击\'投票\'按钮提交\n• 如果没有看到需要的选项,可以添加自己的选项';
}

/// The translations for Chinese, as used in Taiwan (`zh_TW`).
class AppLocalizationsZhTw extends AppLocalizationsZh {
  AppLocalizationsZhTw(): super('zh_TW');

  @override
  String get appName => 'AI Cosmetic Scanner';

  @override
  String get skinAnalysis => '肌膚分析';

  @override
  String get checkYourCosmetics => '檢查你的化妝品';

  @override
  String get startScanning => '開始掃描';

  @override
  String get quickActions => '快捷操作';

  @override
  String get scanHistory => '掃描歷史';

  @override
  String get aiChat => 'AI Cosmetic Scanner';

  @override
  String get profile => '個人檔案';

  @override
  String get settings => '設定';

  @override
  String get skinType => '膚質';

  @override
  String get allergiesSensitivities => '過敏和敏感';

  @override
  String get subscription => '訂閱';

  @override
  String get age => '年齡';

  @override
  String get language => '語言';

  @override
  String get selectYourPreferredLanguage => '選擇你的偏好語言';

  @override
  String get save => '儲存';

  @override
  String get language_en => 'English';

  @override
  String get language_ru => 'Russian';

  @override
  String get language_uk => 'Ukrainian';

  @override
  String get language_es => 'Spanish';

  @override
  String get language_de => 'German';

  @override
  String get language_fr => 'French';

  @override
  String get language_it => 'Italian';

  @override
  String get language_ar => 'العربية';

  @override
  String get language_ko => '한국어';

  @override
  String get language_cs => 'Čeština';

  @override
  String get language_da => 'Dansk';

  @override
  String get language_el => 'Ελληνικά';

  @override
  String get language_fi => 'Suomi';

  @override
  String get language_hi => 'हिन्दी';

  @override
  String get language_hu => 'Magyar';

  @override
  String get language_id => 'Bahasa Indonesia';

  @override
  String get language_ja => '日本語';

  @override
  String get language_nl => 'Nederlands';

  @override
  String get language_no => 'Norsk';

  @override
  String get language_pl => 'Polski';

  @override
  String get language_pt => 'Português';

  @override
  String get language_ro => 'Română';

  @override
  String get language_sv => 'Svenska';

  @override
  String get language_th => 'ไทย';

  @override
  String get language_tr => 'Türkçe';

  @override
  String get language_vi => 'Tiếng Việt';

  @override
  String get language_zh => '中文';

  @override
  String get selectIngredientsAllergicSensitive => '選擇你敏感的成分';

  @override
  String get commonAllergens => '常見過敏原';

  @override
  String get fragrance => '香精';

  @override
  String get parabens => '對羥基苯甲酸酯';

  @override
  String get sulfates => '硫酸鹽';

  @override
  String get alcohol => '酒精';

  @override
  String get essentialOils => '精油';

  @override
  String get silicones => '矽';

  @override
  String get mineralOil => '礦物油';

  @override
  String get formaldehyde => '甲醛';

  @override
  String get addCustomAllergen => '新增自訂過敏原';

  @override
  String get typeIngredientName => '輸入成分名稱...';

  @override
  String get selectedAllergens => '已選過敏原';

  @override
  String saveSelected(int count) {
    return '儲存 ($count 個已選)';
  }

  @override
  String get analysisResults => '分析結果';

  @override
  String get overallSafetyScore => '整體安全評分';

  @override
  String get personalizedWarnings => '個人化警告';

  @override
  String ingredientsAnalysis(int count) {
    return '成分分析 ($count)';
  }

  @override
  String get highRisk => '高風險';

  @override
  String get moderateRisk => '中度風險';

  @override
  String get lowRisk => '低風險';

  @override
  String get benefitsAnalysis => '功效分析';

  @override
  String get recommendedAlternatives => '推薦替代品';

  @override
  String get reason => '原因:';

  @override
  String get quickSummary => '快速摘要';

  @override
  String get ingredientsChecked => '成分已檢測';

  @override
  String get personalWarnings => '個人警告';

  @override
  String get ourVerdict => '我們的評價';

  @override
  String get productInfo => '產品資訊';

  @override
  String get productType => '產品類型';

  @override
  String get brand => '品牌';

  @override
  String get premiumInsights => '進階洞察';

  @override
  String get researchArticles => '研究文章';

  @override
  String get categoryRanking => '類別排名';

  @override
  String get safetyTrend => '安全趨勢';

  @override
  String get saveToFavorites => '儲存';

  @override
  String get shareResults => '分享';

  @override
  String get compareProducts => '比較';

  @override
  String get exportPDF => 'PDF';

  @override
  String get scanSimilar => '相似';

  @override
  String get aiChatTitle => 'AI Cosmetic Scanner';

  @override
  String get typeYourMessage => '輸入你的訊息...';

  @override
  String get errorSupabaseClientNotInitialized => '錯誤:Supabase客戶端未初始化。';

  @override
  String get serverError => '伺服器錯誤:';

  @override
  String get networkErrorOccurred => '網路錯誤。請稍後重試。';

  @override
  String get sorryAnErrorOccurred => '抱歉,發生錯誤。請重試。';

  @override
  String get couldNotGetResponse => '無法取得回應。';

  @override
  String get aiAssistant => 'AI助手';

  @override
  String get online => '線上';

  @override
  String get typing => '正在輸入...';

  @override
  String get writeAMessage => '寫訊息...';

  @override
  String get hiIAmYourAIAssistantHowCanIHelp => '你好!我是你的AI助手。我能幫你什麼?';

  @override
  String get iCanSeeYourScanResultsFeelFreeToAskMeAnyQuestionsAboutTheIngredientsSafetyConcernsOrRecommendations => '我可以看到你的掃描結果!隨時向我詢問有關成分、安全問題或建議的任何問題。';

  @override
  String get userQuestion => '使用者問題:';

  @override
  String get databaseExplorer => '資料庫瀏覽器';

  @override
  String get currentUser => '目前使用者:';

  @override
  String get notSignedIn => '未登入';

  @override
  String get failedToFetchTables => '取得表格失敗:';

  @override
  String get tablesInYourSupabaseDatabase => '你的Supabase資料庫中的表格:';

  @override
  String get viewSampleData => '檢視範例資料';

  @override
  String get failedToFetchSampleDataFor => '取得範例資料失敗';

  @override
  String get sampleData => '範例資料:';

  @override
  String get aiChats => 'AI Cosmetic Scanners';

  @override
  String get noDialoguesYet => '還沒有對話。';

  @override
  String get startANewChat => '開始新聊天!';

  @override
  String get created => '建立於:';

  @override
  String get failedToSaveImage => '儲存圖片失敗:';

  @override
  String get editName => '編輯名稱';

  @override
  String get enterYourName => '輸入你的名字';

  @override
  String get cancel => '取消';

  @override
  String get premiumUser => '進階使用者';

  @override
  String get freeUser => '免費使用者';

  @override
  String get skinProfile => '肌膚檔案';

  @override
  String get notSet => '未設定';

  @override
  String get legal => '法律';

  @override
  String get privacyPolicy => '隱私權政策';

  @override
  String get termsOfService => '服務條款';

  @override
  String get dataManagement => '資料管理';

  @override
  String get clearAllData => '清除所有資料';

  @override
  String get clearAllDataConfirmation => '確定要刪除所有本機資料嗎?此操作無法復原。';

  @override
  String get selectDataToClear => '選擇要清除的資料';

  @override
  String get scanResults => '掃描結果';

  @override
  String get chatHistory => '聊天';

  @override
  String get personalData => '個人資料';

  @override
  String get clearData => '清除資料';

  @override
  String get allLocalDataHasBeenCleared => '資料已清除。';

  @override
  String get signOut => '登出';

  @override
  String get deleteScan => '刪除掃描';

  @override
  String get deleteScanConfirmation => '確定要從歷史記錄中刪除此掃描嗎?';

  @override
  String get deleteChat => '刪除聊天';

  @override
  String get deleteChatConfirmation => '確定要刪除此聊天嗎?所有訊息都將遺失。';

  @override
  String get delete => '刪除';

  @override
  String get noScanHistoryFound => '未找到掃描歷史。';

  @override
  String get scanOn => '掃描於';

  @override
  String get ingredientsFound => '找到成分';

  @override
  String get noCamerasFoundOnThisDevice => '此裝置上未找到相機。';

  @override
  String get failedToInitializeCamera => '初始化相機失敗:';

  @override
  String get analysisFailed => '分析失敗:';

  @override
  String get analyzingPleaseWait => '正在分析,請稍候...';

  @override
  String get positionTheLabelWithinTheFrame => '將相機對準成分表';

  @override
  String get createAccount => '建立帳號';

  @override
  String get signUpToGetStarted => '註冊開始使用';

  @override
  String get fullName => '全名';

  @override
  String get pleaseEnterYourName => '請輸入你的名字';

  @override
  String get email => '電子郵件';

  @override
  String get pleaseEnterYourEmail => '請輸入你的電子郵件';

  @override
  String get pleaseEnterAValidEmail => '請輸入有效的電子郵件';

  @override
  String get password => '密碼';

  @override
  String get pleaseEnterYourPassword => '請輸入你的密碼';

  @override
  String get passwordMustBeAtLeast6Characters => '密碼必須至少6個字元';

  @override
  String get signUp => '註冊';

  @override
  String get orContinueWith => '或繼續使用';

  @override
  String get google => 'Google';

  @override
  String get apple => 'Apple';

  @override
  String get alreadyHaveAnAccount => '已有帳號? ';

  @override
  String get signIn => '登入';

  @override
  String get selectYourSkinTypeDescription => '選擇你的膚質';

  @override
  String get normal => '中性';

  @override
  String get normalSkinDescription => '平衡,不太油也不太乾';

  @override
  String get dry => '乾性';

  @override
  String get drySkinDescription => '緊繃、脫皮、粗糙';

  @override
  String get oily => '油性';

  @override
  String get oilySkinDescription => '油光、毛孔粗大、易長痘';

  @override
  String get combination => '混合性';

  @override
  String get combinationSkinDescription => 'T字部位油、兩頰乾';

  @override
  String get sensitive => '敏感';

  @override
  String get sensitiveSkinDescription => '易刺激、易泛紅';

  @override
  String get selectSkinType => '選擇膚質';

  @override
  String get restore => '恢復';

  @override
  String get restorePurchases => '恢復購買';

  @override
  String get subscriptionRestored => '訂閱恢復成功!';

  @override
  String get noPurchasesToRestore => '沒有可恢復的購買';

  @override
  String get goPremium => '升級進階版';

  @override
  String get unlockExclusiveFeatures => '解鎖獨家功能,充分利用肌膚分析。';

  @override
  String get unlimitedProductScans => '無限產品掃描';

  @override
  String get advancedAIIngredientAnalysis => '進階AI成分分析';

  @override
  String get fullScanAndSearchHistory => '完整掃描和搜尋歷史';

  @override
  String get adFreeExperience => '100%無廣告體驗';

  @override
  String get yearly => '年度';

  @override
  String savePercentage(int percentage) {
    return '節省 $percentage%';
  }

  @override
  String get monthly => '月度';

  @override
  String get perMonth => '/ 月';

  @override
  String get startFreeTrial => '開始免費試用';

  @override
  String trialDescription(String planName) {
    return '7天免費試用,然後按$planName收費。隨時取消。';
  }

  @override
  String get home => '首頁';

  @override
  String get scan => '掃描';

  @override
  String get aiChatNav => 'AI Cosmetic Scanner';

  @override
  String get profileNav => '個人檔案';

  @override
  String get doYouEnjoyOurApp => '你喜歡我們的應用程式嗎?';

  @override
  String get notReally => '不太喜歡';

  @override
  String get yesItsGreat => '喜歡';

  @override
  String get rateOurApp => '為應用程式評分';

  @override
  String get bestRatingWeCanGet => '我們能獲得的最高評分';

  @override
  String get rateOnGooglePlay => '在Google Play評分';

  @override
  String get rate => '評分';

  @override
  String get whatCanBeImproved => '有什麼可以改進的?';

  @override
  String get wereSorryYouDidntHaveAGreatExperience => '很抱歉你沒有很好的體驗。請告訴我們哪裡出了問題。';

  @override
  String get yourFeedback => '你的回饋...';

  @override
  String get sendFeedback => '傳送回饋';

  @override
  String get thankYouForYourFeedback => '感謝你的回饋!';

  @override
  String get discussWithAI => '與AI討論';

  @override
  String get enterYourEmail => '輸入你的電子郵件';

  @override
  String get enterYourPassword => '輸入你的密碼';

  @override
  String get aiDisclaimer => 'AI回應可能包含不準確資訊。請驗證重要資訊。';

  @override
  String get applicationThemes => '應用程式主題';

  @override
  String get highestRating => '最高評分';

  @override
  String get selectYourAgeDescription => '選擇你的年齡';

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
  String get ageRange18_25Description => '年輕肌膚,預防';

  @override
  String get ageRange26_35Description => '初老跡象';

  @override
  String get ageRange36_45Description => '抗老化保養';

  @override
  String get ageRange46_55Description => '密集保養';

  @override
  String get ageRange56PlusDescription => '專業保養';

  @override
  String get userName => '你的名字';

  @override
  String get tryFreeAndSubscribe => '免費試用並訂閱';

  @override
  String get personalAIConsultant => '個人AI顧問24/7';

  @override
  String get subscribe => '訂閱';

  @override
  String get themes => '主題';

  @override
  String get selectPreferredTheme => '選擇你喜歡的主題';

  @override
  String get naturalTheme => '自然';

  @override
  String get darkTheme => '深色';

  @override
  String get darkNatural => '深色自然';

  @override
  String get oceanTheme => '海洋';

  @override
  String get forestTheme => '森林';

  @override
  String get sunsetTheme => '日落';

  @override
  String get naturalThemeDescription => '環保色彩的自然主題';

  @override
  String get darkThemeDescription => '舒適眼睛的深色主題';

  @override
  String get oceanThemeDescription => '清新海洋主題';

  @override
  String get forestThemeDescription => '自然森林主題';

  @override
  String get sunsetThemeDescription => '溫暖日落主題';

  @override
  String get sunnyTheme => '陽光';

  @override
  String get sunnyThemeDescription => '明亮歡快的黃色主題';

  @override
  String get vibrantTheme => '活力';

  @override
  String get vibrantThemeDescription => '明亮的粉紫主題';

  @override
  String get scanAnalysis => '掃描分析';

  @override
  String get ingredients => '成分';

  @override
  String get aiBotSettings => 'AI設定';

  @override
  String get botName => '機器人名稱';

  @override
  String get enterBotName => '輸入機器人名稱';

  @override
  String get pleaseEnterBotName => '請輸入機器人名稱';

  @override
  String get botDescription => '機器人描述';

  @override
  String get selectAvatar => '選擇頭像';

  @override
  String get defaultBotName => 'ACS';

  @override
  String defaultBotDescription(String name) {
    return '你好!我是$name(AI Cosmetic Scanner)。我會幫助你了解化妝品的成分。我在化妝品學和護膚方面有廣泛的知識。我很樂意回答你的所有問題。';
  }

  @override
  String get settingsSaved => '設定儲存成功';

  @override
  String get failedToSaveSettings => '儲存設定失敗';

  @override
  String get resetToDefault => '重設為預設';

  @override
  String get resetSettings => '重設設定';

  @override
  String get resetSettingsConfirmation => '確定要將所有設定重設為預設值嗎?';

  @override
  String get settingsResetSuccessfully => '設定重設成功';

  @override
  String get failedToResetSettings => '重設設定失敗';

  @override
  String get unsavedChanges => '未儲存的變更';

  @override
  String get unsavedChangesMessage => '你有未儲存的變更。確定要離開嗎?';

  @override
  String get stay => '留下';

  @override
  String get leave => '離開';

  @override
  String get errorLoadingSettings => '載入設定時發生錯誤';

  @override
  String get retry => '重試';

  @override
  String get customPrompt => '特殊要求';

  @override
  String get customPromptDescription => '為AI助手新增個人化指示';

  @override
  String get customPromptPlaceholder => '輸入你的特殊要求...';

  @override
  String get enableCustomPrompt => '啟用特殊要求';

  @override
  String get defaultCustomPrompt => '誇誇我。';

  @override
  String get close => '關閉';

  @override
  String get scanningHintTitle => '如何掃描';

  @override
  String get scanLimitReached => '已達掃描限制';

  @override
  String get scanLimitReachedMessage => '你已用完本週5次免費掃描。升級到進階版可無限掃描!';

  @override
  String get messageLimitReached => '已達每日訊息限制';

  @override
  String get messageLimitReachedMessage => '你今天已傳送5則訊息。升級到進階版可無限聊天!';

  @override
  String get historyLimitReached => '歷史存取受限';

  @override
  String get historyLimitReachedMessage => '升級到進階版以存取完整掃描歷史!';

  @override
  String get upgradeToPremium => '升級到進階版';

  @override
  String get upgradeToView => '升級檢視';

  @override
  String get upgradeToChat => '升級聊天';

  @override
  String get premiumFeature => '進階功能';

  @override
  String get freePlanUsage => '免費方案使用';

  @override
  String get scansThisWeek => '本週掃描';

  @override
  String get messagesToday => '今日訊息';

  @override
  String get limitsReached => '已達限制';

  @override
  String get remainingScans => '剩餘掃描';

  @override
  String get remainingMessages => '剩餘訊息';

  @override
  String get unlockUnlimitedAccess => '解鎖無限存取';

  @override
  String get upgradeToPremiumDescription => '使用進階版獲得無限掃描、無限訊息和完整掃描歷史存取!';

  @override
  String get premiumBenefits => '進階版權益';

  @override
  String get unlimitedAiChatMessages => '無限AI聊天訊息';

  @override
  String get fullAccessToScanHistory => '完全存取掃描歷史';

  @override
  String get prioritySupport => '優先支援';

  @override
  String get learnMore => '了解更多';

  @override
  String get upgradeNow => '立即升級';

  @override
  String get maybeLater => '稍後再說';

  @override
  String get scanHistoryLimit => '歷史中僅顯示最近一次掃描';

  @override
  String get upgradeForUnlimitedScans => '升級取得無限掃描!';

  @override
  String get upgradeForUnlimitedChat => '升級取得無限聊天!';

  @override
  String get slowInternetConnection => '網路連線緩慢';

  @override
  String get slowInternetMessage => '在非常慢的網路連線下,你需要等待一下...我們仍在分析你的圖片。';

  @override
  String get revolutionaryAI => '革命性AI';

  @override
  String get revolutionaryAIDesc => '世界上最智慧的AI之一';

  @override
  String get unlimitedScans => '無限掃描';

  @override
  String get unlimitedScansDesc => '無限探索化妝品';

  @override
  String get unlimitedChats => '無限聊天';

  @override
  String get unlimitedChatsDesc => '個人AI顧問24/7';

  @override
  String get fullHistory => '完整歷史';

  @override
  String get fullHistoryDesc => '無限掃描歷史';

  @override
  String get rememberContext => '記住上下文';

  @override
  String get rememberContextDesc => 'AI記住你之前的訊息';

  @override
  String get allIngredientsInfo => '所有成分資訊';

  @override
  String get allIngredientsInfoDesc => '了解所有細節';

  @override
  String get noAds => '100%無廣告';

  @override
  String get noAdsDesc => '為珍惜時間的人準備';

  @override
  String get multiLanguage => '幾乎懂所有語言';

  @override
  String get multiLanguageDesc => '增強型翻譯器';

  @override
  String get paywallTitle => '用AI解鎖化妝品的秘密';

  @override
  String paywallDescription(String price) {
    return '你有機會免費取得3天進階訂閱,然後每週$price。隨時取消。';
  }

  @override
  String get whatsIncluded => '包含內容';

  @override
  String get basicPlan => '基礎';

  @override
  String get premiumPlan => '進階';

  @override
  String get botGreeting1 => '你好!今天我能幫你什麼?';

  @override
  String get botGreeting2 => '你好!什麼風把你吹來了?';

  @override
  String get botGreeting3 => '歡迎!準備好幫助你進行化妝品分析。';

  @override
  String get botGreeting4 => '很高興見到你!我能幫什麼忙?';

  @override
  String get botGreeting5 => '歡迎!讓我們一起探索你的化妝品成分吧。';

  @override
  String get botGreeting6 => '你好!準備好回答你關於化妝品的問題。';

  @override
  String get botGreeting7 => '嗨!我是你的個人化妝品學助手。';

  @override
  String get botGreeting8 => '你好!我會幫助你了解化妝品的成分。';

  @override
  String get botGreeting9 => '你好!讓我們一起讓你的化妝品更安全。';

  @override
  String get botGreeting10 => '歡迎!準備好分享化妝品知識。';

  @override
  String get botGreeting11 => '你好!我會幫你找到最適合你的化妝品解決方案。';

  @override
  String get botGreeting12 => '你好!你的化妝品安全專家隨時為你服務。';

  @override
  String get botGreeting13 => '嗨!讓我們一起為你選擇完美的化妝品。';

  @override
  String get botGreeting14 => '歡迎!準備好幫助你進行成分分析。';

  @override
  String get botGreeting15 => '你好!我會幫助你了解化妝品的成分。';

  @override
  String get botGreeting16 => '歡迎!你的化妝品學世界嚮導隨時準備幫助。';

  @override
  String get copiedToClipboard => '已複製到剪貼簿';

  @override
  String get tryFree => '免費試用';

  @override
  String get cameraNotReady => '相機未就緒/無權限';

  @override
  String get cameraPermissionInstructions => '應用程式設定:\nAI Cosmetic Scanner > 權限 > 相機 > 允許';

  @override
  String get openSettingsAndGrantAccess => '開啟設定並授予相機存取權限';

  @override
  String get retryCamera => '重試';

  @override
  String get errorServiceOverloaded => '服務暫時繁忙。請稍後重試。';

  @override
  String get errorRateLimitExceeded => '請求過多。請稍等片刻後重試。';

  @override
  String get errorTimeout => '請求逾時。請檢查網路連線後重試。';

  @override
  String get errorNetwork => '網路錯誤。請檢查你的網路連線。';

  @override
  String get errorAuthentication => '身份驗證錯誤。請重新啟動應用程式。';

  @override
  String get errorInvalidResponse => '收到無效回應。請重試。';

  @override
  String get errorServer => '伺服器錯誤。請稍後重試。';

  @override
  String get customThemes => '自訂主題';

  @override
  String get createCustomTheme => '建立自訂主題';

  @override
  String get basedOn => '基於';

  @override
  String get lightMode => '淺色';

  @override
  String get generateWithAI => '用AI產生';

  @override
  String get resetToBaseTheme => '重設為基礎主題';

  @override
  String colorsResetTo(Object themeName) {
    return '顏色已重設為$themeName';
  }

  @override
  String get aiGenerationComingSoon => 'AI主題產生將在第5次迭代中推出!';

  @override
  String get onboardingGreeting => '歡迎!為了提高答案品質,讓我們設定你的個人檔案';

  @override
  String get letsGo => '開始吧';

  @override
  String get next => '下一步';

  @override
  String get finish => '完成';

  @override
  String get customThemeInDevelopment => '自訂主題功能正在開發中';

  @override
  String get customThemeComingSoon => '即將在未來更新中推出';

  @override
  String get dailyMessageLimitReached => '已達限制';

  @override
  String get dailyMessageLimitReachedMessage => '你今天已傳送5則訊息。升級到進階版可無限聊天!';

  @override
  String get upgradeToPremiumForUnlimitedChat => '升級到進階版取得無限聊天';

  @override
  String get messagesLeftToday => '今天剩餘訊息';

  @override
  String get designYourOwnTheme => '設計你自己的主題';

  @override
  String get darkOcean => '深色海洋';

  @override
  String get darkForest => '深色森林';

  @override
  String get darkSunset => '深色日落';

  @override
  String get darkVibrant => '深色活力';

  @override
  String get darkOceanThemeDescription => '帶青色點綴的深色海洋主題';

  @override
  String get darkForestThemeDescription => '帶青檸色點綴的深色森林主題';

  @override
  String get darkSunsetThemeDescription => '帶橙色點綴的深色日落主題';

  @override
  String get darkVibrantThemeDescription => '帶粉紫色點綴的深色活力主題';

  @override
  String get customTheme => '自訂主題';

  @override
  String get edit => '編輯';

  @override
  String get deleteTheme => '刪除主題';

  @override
  String deleteThemeConfirmation(String themeName) {
    return '確定要刪除「$themeName」嗎?';
  }

  @override
  String get pollTitle => '缺少什麼?';

  @override
  String get pollCardTitle => '應用程式缺少什麼?';

  @override
  String get pollCardSubtitle => '應該新增哪3個功能?';

  @override
  String get pollDescription => '為你想看到的選項投票';

  @override
  String get submitVote => '投票';

  @override
  String get submitting => '提交中...';

  @override
  String get voteSubmittedSuccess => '投票提交成功!';

  @override
  String votesRemaining(int count) {
    return '剩餘$count票';
  }

  @override
  String get votes => '票';

  @override
  String get addYourOption => '建議改進';

  @override
  String get enterYourOption => '輸入你的選項...';

  @override
  String get add => '新增';

  @override
  String get filterTopVoted => '熱門';

  @override
  String get filterNewest => '最新';

  @override
  String get filterMyOption => '我的選擇';

  @override
  String get thankYouForVoting => '感謝投票!';

  @override
  String get votingComplete => '你的投票已記錄';

  @override
  String get requestFeatureDevelopment => '請求訂製功能開發';

  @override
  String get requestFeatureDescription => '需要特定功能?聯絡我們討論為你的業務需求訂製開發。';

  @override
  String get pollHelpTitle => '如何投票';

  @override
  String get pollHelpDescription => '• 點選選項進行選擇\n• 再次點選取消選擇\n• 可以選擇任意多個選項\n• 點選「投票」按鈕提交\n• 如果沒有看到需要的選項,可以新增自己的選項';
}
