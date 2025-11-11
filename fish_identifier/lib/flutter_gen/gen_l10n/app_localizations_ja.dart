// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appName => '魚の識別';

  @override
  String get appTagline => 'AI搭載の魚認識';

  @override
  String get tabCamera => 'カメラ';

  @override
  String get tabHistory => '履歴';

  @override
  String get tabCollection => 'コレクション';

  @override
  String get tabChat => 'チャット';

  @override
  String get tabSettings => '設定';

  @override
  String get cameraTitle => '魚を識別';

  @override
  String get cameraHint => '写真を撮るかギャラリーから選択';

  @override
  String get takePhoto => '写真を撮る';

  @override
  String get selectFromGallery => 'ギャラリーから選択';

  @override
  String get identifyingFish => '魚を識別中...';

  @override
  String get fishName => '魚の名前';

  @override
  String get scientificName => '学名';

  @override
  String get habitat => '生息地';

  @override
  String get diet => '食性';

  @override
  String get funFacts => '豆知識';

  @override
  String get confidence => '信頼度';

  @override
  String get edibility => '食用';

  @override
  String get cookingTips => '調理のコツ';

  @override
  String get fishingTips => '釣りのコツ';

  @override
  String get conservationStatus => '保全状況';

  @override
  String get edible => '食用可';

  @override
  String get notRecommended => '推奨しません';

  @override
  String get toxic => '有毒';

  @override
  String get addToCollection => 'コレクションに追加';

  @override
  String get chatAboutFish => 'この魚について質問';

  @override
  String get shareResult => '結果を共有';

  @override
  String get deleteResult => '削除';

  @override
  String get collectionTitle => 'マイコレクション';

  @override
  String get collectionEmpty => 'まだコレクションに魚がいません';

  @override
  String get collectionHint => '魚を識別してコレクションを作りましょう！';

  @override
  String get totalCatches => '総釣果';

  @override
  String get favoriteFish => 'お気に入りの魚';

  @override
  String get addNotes => 'メモを追加';

  @override
  String get catchDetails => '釣果の詳細';

  @override
  String get location => '場所';

  @override
  String get date => '日付';

  @override
  String get weight => '重さ';

  @override
  String get length => '長さ';

  @override
  String get baitUsed => '使用した餌';

  @override
  String get weatherConditions => '天気';

  @override
  String get chatTitle => '釣りAIアシスタント';

  @override
  String get chatHint => '魚、釣り、料理について何でも聞いてください！';

  @override
  String get chatPlaceholder => '質問を入力...';

  @override
  String get chatSend => '送信';

  @override
  String get chatSampleQuestions => '質問例';

  @override
  String get chatClear => 'チャットをクリア';

  @override
  String get historyTitle => '識別履歴';

  @override
  String get historyEmpty => 'まだ識別がありません';

  @override
  String get historyHint => '識別した魚がここに表示されます';

  @override
  String get settingsTitle => '設定';

  @override
  String get settingsLanguage => '言語';

  @override
  String get settingsTheme => 'テーマ';

  @override
  String get settingsThemeOcean => 'オーシャンブルー';

  @override
  String get settingsThemeDeep => '深海';

  @override
  String get settingsThemeTropical => 'トロピカルウォーター';

  @override
  String get settingsThemeKhaki => 'カーキカモフラージュ';

  @override
  String get settingsDarkMode => 'ダークモード';

  @override
  String get settingsAbout => 'アプリについて';

  @override
  String get settingsClearData => '全データを削除';

  @override
  String get settingsRate => 'アプリを評価';

  @override
  String get settingsShare => 'アプリを共有';

  @override
  String get settingsFeedback => 'フィードバックを送信';

  @override
  String get confirmClearData => '全データを削除しますか？';

  @override
  String get confirmClearDataMessage => 'すべての識別、コレクションアイテム、チャット履歴が削除されます。この操作は元に戻せません。';

  @override
  String get confirm => '確認';

  @override
  String get cancel => 'キャンセル';

  @override
  String get errorTitle => 'エラー';

  @override
  String get errorNetwork => 'ネットワークエラー。接続を確認してください。';

  @override
  String get errorServiceOverloaded => 'サービスが一時的に過負荷です。しばらくしてから再試行してください。';

  @override
  String get errorRateLimit => 'リクエストが多すぎます。少しお待ちください。';

  @override
  String get errorInvalidResponse => 'レスポンスを処理できませんでした。もう一度お試しください。';

  @override
  String get errorNotFish => 'これは魚ではないようです。別の画像をお試しください。';

  @override
  String get errorGeneral => '問題が発生しました。もう一度お試しください。';

  @override
  String get retry => '再試行';

  @override
  String get close => '閉じる';

  @override
  String get save => '保存';

  @override
  String get delete => '削除';

  @override
  String get edit => '編集';

  @override
  String get done => '完了';

  @override
  String get yes => 'はい';

  @override
  String get no => 'いいえ';

  @override
  String get feedback => 'フィードバック';

  @override
  String catchNumber(Object number) {
    return '釣果 #$number';
  }

  @override
  String get shareComingSoon => '共有機能は近日公開！';

  @override
  String get dataCleared => 'データが正常に削除されました';

  @override
  String get openingAppStore => 'アプリストアを開いています...';

  @override
  String get ratingTitle => 'Fish Identifierを楽しんでいますか？';

  @override
  String get ratingMessage => 'あなたのフィードバックがアプリの改善に役立ちます！';

  @override
  String get rateNow => '今すぐ評価';

  @override
  String get maybeLater => '後で';

  @override
  String get noThanks => '結構です';

  @override
  String get surveyTitle => '改善にご協力ください！';

  @override
  String get surveyQuestion => '次に追加してほしい機能は？';

  @override
  String get surveyOption1 => '釣果を共有するソーシャルフィード';

  @override
  String get surveyOption2 => '釣りスポットのおすすめ';

  @override
  String get surveyOption3 => '天気に基づく予測';

  @override
  String get surveyOption4 => 'レシピデータベース';

  @override
  String get surveySubmit => '送信';

  @override
  String get surveyThankYou => 'フィードバックありがとうございます！';

  @override
  String get premiumTitle => 'プレミアムにアップグレード';

  @override
  String get premiumFeature1 => '無制限の識別';

  @override
  String get premiumFeature2 => '無制限のAIチャット';

  @override
  String get premiumFeature3 => 'GPS位置追跡';

  @override
  String get premiumFeature4 => '詳細な統計';

  @override
  String get premiumFeature5 => 'クラウドバックアップ';

  @override
  String get premiumFeature6 => '広告なし';

  @override
  String get premiumPrice => '月額\$4.99または年額\$29.99';

  @override
  String get premiumUpgrade => '今すぐアップグレード';

  @override
  String get premiumRestore => '購入を復元';
}
