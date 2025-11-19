import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Service for managing ads (AdMob)
class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;
  BannerAd? _bannerAd;

  bool _isInitialized = false;
  bool _isInterstitialAdReady = false;
  bool _isRewardedAdReady = false;

  /// Test Ad Unit IDs (replace with real ones in production)
  String get _bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111'; // Test ID
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716'; // Test ID
    }
    throw UnsupportedError('Unsupported platform');
  }

  String get _interstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/1033173712'; // Test ID
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/4411468910'; // Test ID
    }
    throw UnsupportedError('Unsupported platform');
  }

  String get _rewardedAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/5224354917'; // Test ID
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/1712485313'; // Test ID
    }
    throw UnsupportedError('Unsupported platform');
  }

  /// Initialize Mobile Ads SDK
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await MobileAds.instance.initialize();
      _isInitialized = true;
      debugPrint('AdMob initialized successfully');

      // Pre-load interstitial ad
      _loadInterstitialAd();
      _loadRewardedAd();
    } catch (e) {
      debugPrint('Failed to initialize AdMob: $e');
    }
  }

  /// Create banner ad
  BannerAd? createBannerAd() {
    if (!_isInitialized) return null;

    _bannerAd = BannerAd(
      adUnitId: _bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint('Banner ad loaded');
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('Banner ad failed to load: $error');
          ad.dispose();
        },
      ),
    );

    _bannerAd?.load();
    return _bannerAd;
  }

  /// Load interstitial ad
  void _loadInterstitialAd() {
    if (!_isInitialized) return;

    InterstitialAd.load(
      adUnitId: _interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialAdReady = true;
          debugPrint('Interstitial ad loaded');

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _isInterstitialAdReady = false;
              _loadInterstitialAd(); // Load next ad
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              debugPrint('Interstitial ad failed to show: $error');
              ad.dispose();
              _isInterstitialAdReady = false;
              _loadInterstitialAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          debugPrint('Interstitial ad failed to load: $error');
          _isInterstitialAdReady = false;
          // Retry after delay
          Future.delayed(const Duration(seconds: 60), _loadInterstitialAd);
        },
      ),
    );
  }

  /// Show interstitial ad
  Future<bool> showInterstitialAd() async {
    if (!_isInitialized || !_isInterstitialAdReady || _interstitialAd == null) {
      debugPrint('Interstitial ad not ready');
      return false;
    }

    try {
      await _interstitialAd!.show();
      _isInterstitialAdReady = false;
      return true;
    } catch (e) {
      debugPrint('Failed to show interstitial ad: $e');
      return false;
    }
  }

  /// Load rewarded ad
  void _loadRewardedAd() {
    if (!_isInitialized) return;

    RewardedAd.load(
      adUnitId: _rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isRewardedAdReady = true;
          debugPrint('Rewarded ad loaded');

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _isRewardedAdReady = false;
              _loadRewardedAd(); // Load next ad
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              debugPrint('Rewarded ad failed to show: $error');
              ad.dispose();
              _isRewardedAdReady = false;
              _loadRewardedAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          debugPrint('Rewarded ad failed to load: $error');
          _isRewardedAdReady = false;
          // Retry after delay
          Future.delayed(const Duration(seconds: 60), _loadRewardedAd);
        },
      ),
    );
  }

  /// Show rewarded ad
  Future<bool> showRewardedAd({
    required Function(int amount) onRewarded,
  }) async {
    if (!_isInitialized || !_isRewardedAdReady || _rewardedAd == null) {
      debugPrint('Rewarded ad not ready');
      return false;
    }

    bool rewarded = false;

    try {
      await _rewardedAd!.show(
        onUserEarnedReward: (ad, reward) {
          debugPrint('User earned reward: ${reward.amount} ${reward.type}');
          onRewarded(reward.amount.toInt());
          rewarded = true;
        },
      );
      _isRewardedAdReady = false;
      return rewarded;
    } catch (e) {
      debugPrint('Failed to show rewarded ad: $e');
      return false;
    }
  }

  /// Check if rewarded ad is ready
  bool get isRewardedAdReady => _isRewardedAdReady;

  /// Check if interstitial ad is ready
  bool get isInterstitialAdReady => _isInterstitialAdReady;

  /// Dispose all ads
  void dispose() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
  }
}
