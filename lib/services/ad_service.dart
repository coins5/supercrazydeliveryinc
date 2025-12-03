import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  static final AdService instance = AdService._internal();

  factory AdService() {
    return instance;
  }

  AdService._internal();

  RewardedAd? _rewardedAd;
  int _numRewardedLoadAttempts = 0;
  final int maxFailedLoadAttempts = 3;

  // Test Ad Unit IDs
  final String _androidRewardedAdUnitId =
      'ca-app-pub-3940256099942544/5224354917';
  final String _iosRewardedAdUnitId = 'ca-app-pub-3940256099942544/1712485313';

  String get _rewardedAdUnitId {
    if (Platform.isAndroid) {
      return _androidRewardedAdUnitId;
    } else if (Platform.isIOS) {
      return _iosRewardedAdUnitId;
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  Future<void> initialize() async {
    await MobileAds.instance.initialize();
    _loadRewardedAd();
  }

  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: _rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          if (kDebugMode) {
            print('$ad loaded.');
          }
          _rewardedAd = ad;
          _numRewardedLoadAttempts = 0;
        },
        onAdFailedToLoad: (LoadAdError error) {
          if (kDebugMode) {
            print('RewardedAd failed to load: $error');
          }
          _rewardedAd = null;
          _numRewardedLoadAttempts += 1;
          if (_numRewardedLoadAttempts < maxFailedLoadAttempts) {
            _loadRewardedAd();
          }
        },
      ),
    );
  }

  void showRewardedAd({
    required Function onUserEarnedReward,
    Function? onAdFailedToShow,
  }) {
    if (_rewardedAd == null) {
      if (kDebugMode) {
        print('Warning: Attempted to show ad before it was loaded.');
      }
      // Try to load again for next time
      _loadRewardedAd();

      // Optional: Call failure callback or just return
      if (onAdFailedToShow != null) {
        onAdFailedToShow();
      }
      return;
    }

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) {
        if (kDebugMode) {
          print('$ad onAdShowedFullScreenContent.');
        }
      },
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        if (kDebugMode) {
          print('$ad onAdDismissedFullScreenContent.');
        }
        ad.dispose();
        _loadRewardedAd(); // Load the next one
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        if (kDebugMode) {
          print('$ad onAdFailedToShowFullScreenContent: $error');
        }
        ad.dispose();
        _loadRewardedAd();
        if (onAdFailedToShow != null) {
          onAdFailedToShow();
        }
      },
    );

    _rewardedAd!.setImmersiveMode(true);
    _rewardedAd!.show(
      onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        if (kDebugMode) {
          print(
            '$ad with reward $RewardItem(${reward.amount}, ${reward.type})',
          );
        }
        onUserEarnedReward();
      },
    );
    _rewardedAd = null;
  }
}
