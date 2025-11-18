import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

class PremiumProvider extends ChangeNotifier {
  static const String _premiumKey = 'is_premium';
  static const String _processCountKey = 'process_count';

  bool _isPremium = false;
  int _processCount = 0;

  PremiumProvider() {
    _loadPremiumStatus();
  }

  bool get isPremium => _isPremium;
  int get processCount => _processCount;
  int get remainingFreeProcesses {
    if (_isPremium) return -1; // unlimited
    return (AppConstants.freeProcessingLimit - _processCount).clamp(0, AppConstants.freeProcessingLimit);
  }

  bool get canProcess {
    return _isPremium || _processCount < AppConstants.freeProcessingLimit;
  }

  Future<void> _loadPremiumStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isPremium = prefs.getBool(_premiumKey) ?? false;
    _processCount = prefs.getInt(_processCountKey) ?? 0;
    notifyListeners();
  }

  Future<void> incrementProcessCount() async {
    if (!_isPremium) {
      _processCount++;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_processCountKey, _processCount);
      notifyListeners();
    }
  }

  Future<void> setPremium(bool premium) async {
    _isPremium = premium;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_premiumKey, premium);
    notifyListeners();
  }

  Future<void> resetProcessCount() async {
    _processCount = 0;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_processCountKey, 0);
    notifyListeners();
  }
}
