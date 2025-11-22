// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appName => 'AI化粧品スキャナー';

  @override
  String get skinAnalysis => '肌分析';

  @override
  String get checkYourCosmetics => '化粧品をチェック';

  @override
  String get startScanning => 'スキャン開始';

  @override
  String get quickActions => 'クイックアクション';

  @override
  String get scanHistory => 'スキャン履歴';

  @override
  String get aiChat => 'AI化粧品スキャナー';

  @override
  String get profile => 'プロフィール';

  @override
  String get settings => '設定';

  @override
  String get skinType => '肌タイプ';

  @override
  String get allergiesSensitivities => 'アレルギー・敏感成分';

  @override
  String get subscription => 'サブスクリプション';

  @override
  String get age => '年齢';

  @override
  String get language => '言語';

  @override
  String get selectYourPreferredLanguage => 'ご希望の言語を選択してください';

  @override
  String get save => '保存';

  @override
  String get selectIngredientsAllergicSensitive => '敏感な成分を選択してください';

  @override
  String get commonAllergens => '一般的なアレルゲン';

  @override
  String get fragrance => '香料';

  @override
  String get parabens => 'パラベン';

  @override
  String get sulfates => '硫酸塩';

  @override
  String get alcohol => 'アルコール';

  @override
  String get essentialOils => '精油';

  @override
  String get silicones => 'シリコン';

  @override
  String get mineralOil => '鉱物油';

  @override
  String get formaldehyde => 'ホルムアルデヒド';

  @override
  String get addCustomAllergen => 'カスタムアレルゲンを追加';

  @override
  String get typeIngredientName => '成分名を入力...';

  @override
  String get selectedAllergens => '選択したアレルゲン';

  @override
  String saveSelected(int count) {
    return '保存（$count件選択）';
  }

  @override
  String get analysisResults => '分析結果';

  @override
  String get overallSafetyScore => '総合安全スコア';

  @override
  String get personalizedWarnings => 'パーソナライズされた警告';

  @override
  String ingredientsAnalysis(int count) {
    return '成分分析（$count件）';
  }

  @override
  String get highRisk => '高リスク';

  @override
  String get moderateRisk => '中リスク';

  @override
  String get lowRisk => '低リスク';

  @override
  String get benefitsAnalysis => '効果分析';

  @override
  String get recommendedAlternatives => 'おすすめの代替品';

  @override
  String get reason => '理由：';

  @override
  String get quickSummary => 'クイックサマリー';

  @override
  String get ingredientsChecked => '成分をチェックしました';

  @override
  String get personalWarnings => '個人的な警告';

  @override
  String get ourVerdict => '総合評価';

  @override
  String get productInfo => '製品情報';

  @override
  String get productType => '製品タイプ';

  @override
  String get brand => 'ブランド';

  @override
  String get premiumInsights => 'プレミアムインサイト';

  @override
  String get researchArticles => '研究論文';

  @override
  String get categoryRanking => 'カテゴリーランキング';

  @override
  String get safetyTrend => '安全性トレンド';

  @override
  String get saveToFavorites => '保存';

  @override
  String get shareResults => '共有';

  @override
  String get compareProducts => '比較';

  @override
  String get exportPDF => 'PDF';

  @override
  String get scanSimilar => '類似';

  @override
  String get aiChatTitle => 'AI化粧品スキャナー';

  @override
  String get typeYourMessage => 'メッセージを入力...';

  @override
  String get errorSupabaseClientNotInitialized => 'エラー：Supabaseクライアントが初期化されていません。';

  @override
  String get serverError => 'サーバーエラー：';

  @override
  String get networkErrorOccurred => 'ネットワークエラーが発生しました。後でもう一度お試しください。';

  @override
  String get sorryAnErrorOccurred => '申し訳ございません、エラーが発生しました。もう一度お試しください。';

  @override
  String get couldNotGetResponse => '応答を取得できませんでした。';

  @override
  String get aiAssistant => 'AIアシスタント';

  @override
  String get online => 'オンライン';

  @override
  String get typing => '入力中...';

  @override
  String get writeAMessage => 'メッセージを書く...';

  @override
  String get hiIAmYourAIAssistantHowCanIHelp => 'こんにちは！AIアシスタントです。どのようなお手伝いができますか？';

  @override
  String get iCanSeeYourScanResultsFeelFreeToAskMeAnyQuestionsAboutTheIngredientsSafetyConcernsOrRecommendations => 'スキャン結果を確認しました！成分、安全性の懸念、おすすめについて、お気軽にご質問ください。';

  @override
  String get userQuestion => 'ユーザーの質問：';

  @override
  String get databaseExplorer => 'データベースエクスプローラー';

  @override
  String get currentUser => '現在のユーザー：';

  @override
  String get notSignedIn => 'サインインしていません';

  @override
  String get failedToFetchTables => 'テーブルの取得に失敗しました：';

  @override
  String get tablesInYourSupabaseDatabase => 'Supabaseデータベース内のテーブル：';

  @override
  String get viewSampleData => 'サンプルデータを表示';

  @override
  String get failedToFetchSampleDataFor => 'サンプルデータの取得に失敗しました：';

  @override
  String get sampleData => 'サンプルデータ：';

  @override
  String get aiChats => 'AIチャット';

  @override
  String get noDialoguesYet => 'まだ会話がありません。';

  @override
  String get startANewChat => '新しいチャットを開始！';

  @override
  String get created => '作成日：';

  @override
  String get failedToSaveImage => '画像の保存に失敗しました：';

  @override
  String get editName => '名前を編集';

  @override
  String get enterYourName => 'お名前を入力してください';

  @override
  String get cancel => 'キャンセル';

  @override
  String get premiumUser => 'プレミアムユーザー';

  @override
  String get freeUser => '無料ユーザー';

  @override
  String get skinProfile => 'スキンプロフィール';

  @override
  String get notSet => '未設定';

  @override
  String get legal => '法的情報';

  @override
  String get privacyPolicy => 'プライバシーポリシー';

  @override
  String get termsOfService => '利用規約';

  @override
  String get dataManagement => 'データ管理';

  @override
  String get clearAllData => 'すべてのデータを消去';

  @override
  String get clearAllDataConfirmation => 'すべてのローカルデータを削除してもよろしいですか？この操作は元に戻せません。';

  @override
  String get selectDataToClear => '消去するデータを選択';

  @override
  String get scanResults => 'スキャン結果';

  @override
  String get chatHistory => 'チャット';

  @override
  String get personalData => '個人データ';

  @override
  String get clearData => 'データを消去';

  @override
  String get allLocalDataHasBeenCleared => 'データが消去されました。';

  @override
  String get signOut => 'サインアウト';

  @override
  String get deleteScan => 'スキャンを削除';

  @override
  String get deleteScanConfirmation => 'このスキャンを履歴から削除してもよろしいですか？';

  @override
  String get deleteChat => 'チャットを削除';

  @override
  String get deleteChatConfirmation => 'このチャットを削除してもよろしいですか？すべてのメッセージが失われます。';

  @override
  String get delete => '削除';

  @override
  String get noScanHistoryFound => 'スキャン履歴が見つかりません。';

  @override
  String get scanOn => 'スキャン日時：';

  @override
  String get ingredientsFound => '成分が見つかりました';

  @override
  String get noCamerasFoundOnThisDevice => 'このデバイスにカメラが見つかりません。';

  @override
  String get failedToInitializeCamera => 'カメラの初期化に失敗しました：';

  @override
  String get analysisFailed => '分析に失敗しました：';

  @override
  String get analyzingPleaseWait => '分析中です。お待ちください...';

  @override
  String get positionTheLabelWithinTheFrame => '成分表示にカメラを向けてください';

  @override
  String get createAccount => 'アカウント作成';

  @override
  String get signUpToGetStarted => 'サインアップして始めましょう';

  @override
  String get fullName => 'フルネーム';

  @override
  String get pleaseEnterYourName => 'お名前を入力してください';

  @override
  String get email => 'メールアドレス';

  @override
  String get pleaseEnterYourEmail => 'メールアドレスを入力してください';

  @override
  String get pleaseEnterAValidEmail => '有効なメールアドレスを入力してください';

  @override
  String get password => 'パスワード';

  @override
  String get pleaseEnterYourPassword => 'パスワードを入力してください';

  @override
  String get passwordMustBeAtLeast6Characters => 'パスワードは6文字以上である必要があります';

  @override
  String get signUp => 'サインアップ';

  @override
  String get orContinueWith => 'または次で続行';

  @override
  String get google => 'Google';

  @override
  String get apple => 'Apple';

  @override
  String get alreadyHaveAnAccount => 'すでにアカウントをお持ちですか？ ';

  @override
  String get signIn => 'サインイン';

  @override
  String get selectYourSkinTypeDescription => '肌タイプを選択してください';

  @override
  String get normal => '普通肌';

  @override
  String get normalSkinDescription => 'バランスが取れている、脂性でも乾燥でもない';

  @override
  String get dry => '乾燥肌';

  @override
  String get drySkinDescription => 'つっぱる、粉を吹く、ざらつく';

  @override
  String get oily => '脂性肌';

  @override
  String get oilySkinDescription => 'テカリやすい、毛穴が大きい、ニキビができやすい';

  @override
  String get combination => '混合肌';

  @override
  String get combinationSkinDescription => 'Tゾーンが脂性、頬が乾燥';

  @override
  String get sensitive => '敏感肌';

  @override
  String get sensitiveSkinDescription => '刺激を受けやすい、赤みが出やすい';

  @override
  String get selectSkinType => '肌タイプを選択';

  @override
  String get restore => '復元';

  @override
  String get restorePurchases => '購入を復元';

  @override
  String get subscriptionRestored => 'サブスクリプションが正常に復元されました！';

  @override
  String get noPurchasesToRestore => '復元する購入がありません';

  @override
  String get goPremium => 'プレミアムにアップグレード';

  @override
  String get unlockExclusiveFeatures => '限定機能をアンロックして、肌分析を最大限に活用しましょう。';

  @override
  String get unlimitedProductScans => '無制限の製品スキャン';

  @override
  String get advancedAIIngredientAnalysis => '高度なAI成分分析';

  @override
  String get fullScanAndSearchHistory => '完全なスキャンと検索履歴';

  @override
  String get adFreeExperience => '100%広告なし';

  @override
  String get yearly => '年間';

  @override
  String savePercentage(int percentage) {
    return '$percentage%お得';
  }

  @override
  String get monthly => '月間';

  @override
  String get perMonth => '/ 月';

  @override
  String get startFreeTrial => '無料トライアルを開始';

  @override
  String trialDescription(String planName) {
    return '7日間の無料トライアル、その後$planNameで請求されます。いつでもキャンセル可能です。';
  }

  @override
  String get home => 'ホーム';

  @override
  String get scan => 'スキャナー';

  @override
  String get aiChatNav => 'コンサルタント';

  @override
  String get profileNav => 'プロフィール';

  @override
  String get doYouEnjoyOurApp => 'このアプリを楽しんでいますか？';

  @override
  String get notReally => 'いいえ';

  @override
  String get yesItsGreat => '好きです';

  @override
  String get rateOurApp => 'アプリを評価';

  @override
  String get bestRatingWeCanGet => '最高の評価をいただけると嬉しいです';

  @override
  String get rateOnGooglePlay => 'Google Playで評価';

  @override
  String get rate => '評価';

  @override
  String get whatCanBeImproved => '改善できることは？';

  @override
  String get wereSorryYouDidntHaveAGreatExperience => 'ご満足いただけず申し訳ございません。何が問題だったかお聞かせください。';

  @override
  String get yourFeedback => 'フィードバック...';

  @override
  String get sendFeedback => 'フィードバックを送信';

  @override
  String get thankYouForYourFeedback => 'フィードバックをありがとうございます！';

  @override
  String get discussWithAI => 'AIと相談';

  @override
  String get enterYourEmail => 'メールアドレスを入力';

  @override
  String get enterYourPassword => 'パスワードを入力';

  @override
  String get aiDisclaimer => 'AIの応答には不正確な情報が含まれる場合があります。重要な情報は必ず確認してください。';

  @override
  String get applicationThemes => 'アプリケーションテーマ';

  @override
  String get highestRating => '最高評価';

  @override
  String get selectYourAgeDescription => '年齢を選択してください';

  @override
  String get ageRange18_25 => '18-25歳';

  @override
  String get ageRange26_35 => '26-35歳';

  @override
  String get ageRange36_45 => '36-45歳';

  @override
  String get ageRange46_55 => '46-55歳';

  @override
  String get ageRange56Plus => '56歳以上';

  @override
  String get ageRange18_25Description => '若い肌、予防ケア';

  @override
  String get ageRange26_35Description => '最初のエイジングサイン';

  @override
  String get ageRange36_45Description => 'アンチエイジングケア';

  @override
  String get ageRange46_55Description => '集中ケア';

  @override
  String get ageRange56PlusDescription => '専門ケア';

  @override
  String get userName => 'お名前';

  @override
  String get yourName => 'Your Name';

  @override
  String get tryFreeAndSubscribe => '無料で試して登録';

  @override
  String get personalAIConsultant => 'パーソナルAIコンサルタント24時間365日';

  @override
  String get subscribe => '登録';

  @override
  String get themes => 'テーマ';

  @override
  String get selectPreferredTheme => 'お好みのテーマを選択';

  @override
  String get naturalTheme => 'ナチュラル';

  @override
  String get darkTheme => 'ダーク';

  @override
  String get darkNatural => 'ダークナチュラル';

  @override
  String get oceanTheme => 'オーシャン';

  @override
  String get forestTheme => 'フォレスト';

  @override
  String get sunsetTheme => 'サンセット';

  @override
  String get naturalThemeDescription => 'エコフレンドリーな色のナチュラルテーマ';

  @override
  String get darkThemeDescription => '目に優しいダークテーマ';

  @override
  String get oceanThemeDescription => '爽やかなオーシャンテーマ';

  @override
  String get forestThemeDescription => '自然なフォレストテーマ';

  @override
  String get sunsetThemeDescription => '温かみのあるサンセットテーマ';

  @override
  String get sunnyTheme => 'サニー';

  @override
  String get sunnyThemeDescription => '明るく陽気なイエローテーマ';

  @override
  String get vibrantTheme => 'ビブラント';

  @override
  String get vibrantThemeDescription => '鮮やかなピンクとパープルのテーマ';

  @override
  String get scanAnalysis => 'スキャン分析';

  @override
  String get ingredients => '成分';

  @override
  String get frontLabelType => 'フロントラベル';

  @override
  String get ingredientsType => '成分';

  @override
  String get analyzeButton => '分析';

  @override
  String get aiBotSettings => 'AI設定';

  @override
  String get botName => 'ボット名';

  @override
  String get enterBotName => 'ボット名を入力';

  @override
  String get pleaseEnterBotName => 'ボット名を入力してください';

  @override
  String get botDescription => 'ボット説明';

  @override
  String get selectAvatar => 'アバターを選択';

  @override
  String get defaultBotName => 'ACS';

  @override
  String defaultBotDescription(String name) {
    return 'こんにちは！私は$name（AI化粧品スキャナー）です。化粧品の成分を理解するお手伝いをします。美容学とスキンケアに関する豊富な知識があります。どんな質問にも喜んでお答えします。';
  }

  @override
  String get settingsSaved => '設定が正常に保存されました';

  @override
  String get failedToSaveSettings => '設定の保存に失敗しました';

  @override
  String get resetToDefault => 'デフォルトにリセット';

  @override
  String get resetSettings => '設定をリセット';

  @override
  String get resetSettingsConfirmation => 'すべての設定をデフォルト値にリセットしてもよろしいですか？';

  @override
  String get settingsResetSuccessfully => '設定が正常にリセットされました';

  @override
  String get failedToResetSettings => '設定のリセットに失敗しました';

  @override
  String get unsavedChanges => '未保存の変更';

  @override
  String get unsavedChangesMessage => '未保存の変更があります。本当に離れますか？';

  @override
  String get stay => '残る';

  @override
  String get leave => '離れる';

  @override
  String get errorLoadingSettings => '設定の読み込みエラー';

  @override
  String get retry => '再試行';

  @override
  String get customPrompt => '特別なリクエスト';

  @override
  String get customPromptDescription => 'AIアシスタントへのパーソナライズされた指示を追加';

  @override
  String get customPromptPlaceholder => '特別なリクエストを入力...';

  @override
  String get enableCustomPrompt => '特別なリクエストを有効にする';

  @override
  String get defaultCustomPrompt => '褒めてください。';

  @override
  String get close => '閉じる';

  @override
  String get scanningHintTitle => 'スキャン方法';

  @override
  String get scanLimitReached => 'スキャン制限に達しました';

  @override
  String get scanLimitReachedMessage => '今週の無料スキャン5回をすべて使い切りました。無制限スキャンにはプレミアムにアップグレードしてください！';

  @override
  String get messageLimitReached => '1日のメッセージ制限に達しました';

  @override
  String get messageLimitReachedMessage => '本日5件のメッセージを送信しました。無制限チャットにはプレミアムにアップグレードしてください！';

  @override
  String get historyLimitReached => '履歴アクセス制限';

  @override
  String get historyLimitReachedMessage => '完全なスキャン履歴にアクセスするにはプレミアムにアップグレードしてください！';

  @override
  String get upgradeToPremium => 'プレミアムにアップグレード';

  @override
  String get upgradeToView => '表示するにはアップグレード';

  @override
  String get upgradeToChat => 'チャットするにはアップグレード';

  @override
  String get premiumFeature => 'プレミアム機能';

  @override
  String get freePlanUsage => '無料プラン使用状況';

  @override
  String get scansThisWeek => '今週のスキャン';

  @override
  String get messagesToday => '今日のメッセージ';

  @override
  String get limitsReached => '制限に達しました';

  @override
  String get remainingScans => '残りのスキャン';

  @override
  String get remainingMessages => '残りのメッセージ';

  @override
  String get usageLimitsBadge => '無料版の制限';

  @override
  String get unlockUnlimitedAccess => '無制限アクセスをアンロック';

  @override
  String get upgradeToPremiumDescription => 'プレミアムで無制限のスキャン、メッセージ、完全なスキャン履歴へのアクセスを取得！';

  @override
  String get premiumBenefits => 'プレミアム特典';

  @override
  String get subscriptionBenefitsTitle => 'プレミアム機能のロック解除';

  @override
  String get subscriptionBenefitsDescription => 'プレミアムにアップグレードして、すべての機能への無制限アクセスを取得';

  @override
  String get getSubscription => 'プレミアムを取得';

  @override
  String get unlimitedAiChatMessages => '無制限のAIチャットメッセージ';

  @override
  String get fullAccessToScanHistory => 'スキャン履歴への完全アクセス';

  @override
  String get prioritySupport => '優先サポート';

  @override
  String get learnMore => '詳細';

  @override
  String get upgradeNow => '今すぐアップグレード';

  @override
  String get maybeLater => '後で';

  @override
  String get scanHistoryLimit => '履歴には最新のスキャンのみ表示されます';

  @override
  String get upgradeForUnlimitedScans => '無制限スキャンにアップグレード！';

  @override
  String get upgradeForUnlimitedChat => '無制限チャットにアップグレード！';

  @override
  String get slowInternetConnection => 'インターネット接続が遅い';

  @override
  String get slowInternetMessage => '非常に遅いインターネット接続では、少しお待ちいただく必要があります...まだ画像を分析中です。';

  @override
  String get revolutionaryAI => '革新的なAI';

  @override
  String get revolutionaryAIDesc => '世界で最もスマートなAIの1つ';

  @override
  String get unlimitedScans => '無制限スキャン';

  @override
  String get unlimitedScansDesc => '制限なく化粧品を探索';

  @override
  String get unlimitedChats => '無制限チャット';

  @override
  String get unlimitedChatsDesc => '24時間365日のパーソナルAIコンサルタント';

  @override
  String get fullHistory => '完全な履歴';

  @override
  String get fullHistoryDesc => '無制限のスキャン履歴';

  @override
  String get rememberContext => 'コンテキストを記憶';

  @override
  String get rememberContextDesc => 'AIが以前のメッセージを記憶';

  @override
  String get allIngredientsInfo => 'すべての成分情報';

  @override
  String get allIngredientsInfoDesc => 'すべての詳細を学ぶ';

  @override
  String get noAds => '100%広告なし';

  @override
  String get noAdsDesc => '時間を大切にする方のために';

  @override
  String get multiLanguage => 'ほぼすべての言語を理解';

  @override
  String get multiLanguageDesc => '強化された翻訳機能';

  @override
  String get paywallTitle => 'AIで化粧品の秘密をアンロック';

  @override
  String paywallDescription(String price) {
    return '3日間無料でプレミアムサブスクリプションを取得し、その後週$priceでご利用いただけます。いつでもキャンセル可能です。';
  }

  @override
  String get whatsIncluded => '含まれるもの';

  @override
  String get basicPlan => 'ベーシック';

  @override
  String get premiumPlan => 'プレミアム';

  @override
  String get botGreeting1 => 'こんにちは！今日はどのようなお手伝いができますか？';

  @override
  String get botGreeting2 => 'こんにちは！何かご用ですか？';

  @override
  String get botGreeting3 => 'ようこそ！化粧品分析のお手伝いをする準備ができています。';

  @override
  String get botGreeting4 => 'お会いできて嬉しいです！何かお役に立てることはありますか？';

  @override
  String get botGreeting5 => 'ようこそ！一緒に化粧品の成分を探ってみましょう。';

  @override
  String get botGreeting6 => 'こんにちは！化粧品に関するご質問にお答えする準備ができています。';

  @override
  String get botGreeting7 => 'こんにちは！あなたのパーソナル美容アシスタントです。';

  @override
  String get botGreeting8 => 'こんにちは！化粧品の成分を理解するお手伝いをします。';

  @override
  String get botGreeting9 => 'こんにちは！一緒に化粧品をより安全にしましょう。';

  @override
  String get botGreeting10 => 'ようこそ！化粧品に関する知識を共有する準備ができています。';

  @override
  String get botGreeting11 => 'こんにちは！あなたに最適な化粧品ソリューションを見つけるお手伝いをします。';

  @override
  String get botGreeting12 => 'こんにちは！化粧品の安全性エキスパートがサービスを提供します。';

  @override
  String get botGreeting13 => 'こんにちは！一緒にあなたにぴったりの化粧品を選びましょう。';

  @override
  String get botGreeting14 => 'ようこそ！成分分析のお手伝いをする準備ができています。';

  @override
  String get botGreeting15 => 'こんにちは！化粧品の成分を理解するお手伝いをします。';

  @override
  String get botGreeting16 => 'ようこそ！美容の世界でのあなたのガイドがお手伝いする準備ができています。';

  @override
  String get copiedToClipboard => 'クリップボードにコピーしました';

  @override
  String get tryFree => '無料で試す';

  @override
  String get cameraNotReady => 'カメラの準備ができていない/権限がありません';

  @override
  String get cameraPermissionInstructions => 'アプリ設定：\nAI化粧品スキャナー > 権限 > カメラ > 許可';

  @override
  String get openSettingsAndGrantAccess => '設定を開いてカメラアクセスを許可してください';

  @override
  String get retryCamera => '再試行';

  @override
  String get errorServiceOverloaded => 'サービスが一時的に混雑しています。しばらくしてからもう一度お試しください。';

  @override
  String get errorRateLimitExceeded => 'リクエストが多すぎます。少し待ってからもう一度お試しください。';

  @override
  String get errorTimeout => 'リクエストがタイムアウトしました。インターネット接続を確認してもう一度お試しください。';

  @override
  String get errorNetwork => 'ネットワークエラー。インターネット接続を確認してください。';

  @override
  String get errorAuthentication => '認証エラー。アプリを再起動してください。';

  @override
  String get errorInvalidResponse => '無効な応答を受信しました。もう一度お試しください。';

  @override
  String get errorServer => 'サーバーエラー。後でもう一度お試しください。';

  @override
  String get customThemes => 'カスタムテーマ';

  @override
  String get createCustomTheme => 'カスタムテーマを作成';

  @override
  String get basedOn => 'ベース';

  @override
  String get lightMode => 'ライト';

  @override
  String get generateWithAI => 'AIで生成';

  @override
  String get resetToBaseTheme => 'ベーステーマにリセット';

  @override
  String colorsResetTo(Object themeName) {
    return '色が$themeNameにリセットされました';
  }

  @override
  String get aiGenerationComingSoon => 'AIテーマ生成は第5イテレーションで登場予定！';

  @override
  String get onboardingGreeting => 'ようこそ！回答の質を向上させるため、プロフィールを設定しましょう';

  @override
  String get letsGo => '始めましょう';

  @override
  String get next => '次へ';

  @override
  String get finish => '完了';

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
  String get customThemeInDevelopment => 'カスタムテーマ機能は開発中です';

  @override
  String get customThemeComingSoon => '今後のアップデートで登場予定';

  @override
  String get dailyMessageLimitReached => '制限に達しました';

  @override
  String get dailyMessageLimitReachedMessage => '本日5件のメッセージを送信しました。無制限チャットにはプレミアムにアップグレードしてください！';

  @override
  String get upgradeToPremiumForUnlimitedChat => '無制限チャットにはプレミアムにアップグレード';

  @override
  String get messagesLeftToday => '今日の残りメッセージ';

  @override
  String get designYourOwnTheme => '独自のテーマをデザイン';

  @override
  String get darkOcean => 'ダークオーシャン';

  @override
  String get darkForest => 'ダークフォレスト';

  @override
  String get darkSunset => 'ダークサンセット';

  @override
  String get darkVibrant => 'ダークビブラント';

  @override
  String get darkOceanThemeDescription => 'シアンアクセントのダークオーシャンテーマ';

  @override
  String get darkForestThemeDescription => 'ライムグリーンアクセントのダークフォレストテーマ';

  @override
  String get darkSunsetThemeDescription => 'オレンジアクセントのダークサンセットテーマ';

  @override
  String get darkVibrantThemeDescription => 'ピンクとパープルアクセントのダークビブラントテーマ';

  @override
  String get customTheme => 'カスタムテーマ';

  @override
  String get edit => '編集';

  @override
  String get deleteTheme => 'テーマを削除';

  @override
  String deleteThemeConfirmation(String themeName) {
    return '「$themeName」を削除してもよろしいですか？';
  }

  @override
  String get pollTitle => '何が足りない？';

  @override
  String get pollCardTitle => 'アプリに何が足りない？';

  @override
  String get pollDescription => '見たいオプションに投票';

  @override
  String get submitVote => '投票';

  @override
  String get submitting => '送信中...';

  @override
  String get voteSubmittedSuccess => '投票が正常に送信されました！';

  @override
  String votesRemaining(int count) {
    return '残り$count票';
  }

  @override
  String get votes => '票';

  @override
  String get addYourOption => '改善を提案';

  @override
  String get enterYourOption => 'オプションを入力...';

  @override
  String get add => '追加';

  @override
  String get filterTopVoted => '人気';

  @override
  String get filterNewest => '新着';

  @override
  String get filterMyOption => 'マイチョイス';

  @override
  String get thankYouForVoting => '投票ありがとうございます！';

  @override
  String get votingComplete => '投票が記録されました';

  @override
  String get requestFeatureDevelopment => 'カスタム機能開発をリクエスト';

  @override
  String get requestFeatureDescription => '特定の機能が必要ですか？お客様のビジネスニーズに合わせたカスタム開発について、お問い合わせください。';

  @override
  String get pollHelpTitle => '投票方法';

  @override
  String get pollHelpDescription => '• オプションをタップして選択\n• もう一度タップして選択解除\n• 好きなだけ選択可能\n• 「投票」ボタンをクリックして投票を送信\n• 必要なものがない場合は、独自のオプションを追加';

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
