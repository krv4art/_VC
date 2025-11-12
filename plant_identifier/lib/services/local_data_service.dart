import 'package:shared_preferences/shared_preferences.dart';

/// Service for managing local data and preferences
class LocalDataService {
  static final LocalDataService instance = LocalDataService._internal();

  factory LocalDataService() {
    return instance;
  }

  LocalDataService._internal();

  /// Get disclaimer status
  Future<bool> getDisclaimerStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('disclaimer_dismissed') ?? false;
  }

  /// Set disclaimer status
  Future<void> setDisclaimerStatus(bool dismissed) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('disclaimer_dismissed', dismissed);
  }
}
