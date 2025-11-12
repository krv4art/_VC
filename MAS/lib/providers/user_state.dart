import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// User state provider for Math AI Solver
///
/// Manages user profile data including:
/// - User name
/// - Premium status
/// - Usage preferences
///
/// Persists data in SharedPreferences for offline access
class UserState with ChangeNotifier {
  String? _name;
  String? _email;
  bool _isPremium = false;

  // Флаг для предотвращения автоматической загрузки данных после очистки
  bool _preventAutoLoad = false;

  String? get name => _name;
  String? get email => _email;
  bool get isPremium => _isPremium;

  UserState() {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    debugPrint('UserState._loadPreferences() called');

    // Проверяем флаг, предотвращающий автоматическую загрузку после очистки
    if (_preventAutoLoad) {
      debugPrint('Auto-load prevented by _preventAutoLoad flag');
      return;
    }

    final prefs = await SharedPreferences.getInstance();

    _name = prefs.getString('user_name');
    _email = prefs.getString('user_email');
    _isPremium = prefs.getBool('user_isPremium') ?? false;

    debugPrint(
      'Loaded user data from SharedPreferences: name=$_name, email=$_email, isPremium=$_isPremium',
    );

    notifyListeners();
  }

  /// Update user name
  Future<void> updateName(String? name) async {
    _name = name;
    final prefs = await SharedPreferences.getInstance();
    if (name != null) {
      await prefs.setString('user_name', name);
      debugPrint('User name updated: $name');
    } else {
      await prefs.remove('user_name');
      debugPrint('User name removed');
    }
    notifyListeners();
  }

  /// Update user email
  Future<void> updateEmail(String? email) async {
    _email = email;
    final prefs = await SharedPreferences.getInstance();
    if (email != null) {
      await prefs.setString('user_email', email);
      debugPrint('User email updated: $email');
    } else {
      await prefs.remove('user_email');
      debugPrint('User email removed');
    }
    notifyListeners();
  }

  /// Update user info (name and email together)
  Future<void> updateUserInfo(String? name, String? email) async {
    _name = name;
    _email = email;
    final prefs = await SharedPreferences.getInstance();

    if (name != null) {
      await prefs.setString('user_name', name);
    } else {
      await prefs.remove('user_name');
    }

    if (email != null) {
      await prefs.setString('user_email', email);
    } else {
      await prefs.remove('user_email');
    }

    debugPrint('User info updated: name=$name, email=$email');
    notifyListeners();
  }

  /// Update premium status
  Future<void> updatePremiumStatus(bool isPremium) async {
    _isPremium = isPremium;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('user_isPremium', isPremium);
    debugPrint('Premium status updated: $isPremium');
    notifyListeners();
  }

  /// Clear all user data
  Future<void> clearAllData({bool preservePremium = false}) async {
    debugPrint('UserState.clearAllData() called, preservePremium=$preservePremium');
    debugPrint('Before clear: name=$_name, email=$_email, isPremium=$_isPremium');

    _name = null;
    _email = null;
    if (!preservePremium) {
      _isPremium = false;
    }

    // Устанавливаем флаг, чтобы предотвратить автозагрузку данных
    _preventAutoLoad = true;

    debugPrint('After state clear: name=$_name, email=$_email, isPremium=$_isPremium');
    debugPrint('_preventAutoLoad flag set to true');

    final prefs = await SharedPreferences.getInstance();

    // Сохраняем счётчики использования перед очисткой
    final dailySolutionsCount = prefs.getInt('daily_solutions_count');
    final dailySolutionsResetDate = prefs.getString('daily_solutions_reset_date');
    final dailyMessagesCount = prefs.getInt('daily_messages_count');
    final dailyMessagesResetDate = prefs.getString('daily_messages_reset_date');
    final dailyChecksCount = prefs.getInt('daily_checks_count');
    final dailyChecksResetDate = prefs.getString('daily_checks_reset_date');

    await prefs.remove('user_name');
    await prefs.remove('user_email');
    if (!preservePremium) {
      await prefs.remove('user_isPremium');
    }

    // Восстанавливаем счётчики использования
    if (dailySolutionsCount != null) {
      await prefs.setInt('daily_solutions_count', dailySolutionsCount);
    }
    if (dailySolutionsResetDate != null) {
      await prefs.setString('daily_solutions_reset_date', dailySolutionsResetDate);
    }
    if (dailyMessagesCount != null) {
      await prefs.setInt('daily_messages_count', dailyMessagesCount);
    }
    if (dailyMessagesResetDate != null) {
      await prefs.setString('daily_messages_reset_date', dailyMessagesResetDate);
    }
    if (dailyChecksCount != null) {
      await prefs.setInt('daily_checks_count', dailyChecksCount);
    }
    if (dailyChecksResetDate != null) {
      await prefs.setString('daily_checks_reset_date', dailyChecksResetDate);
    }

    debugPrint('Data cleared from SharedPreferences with usage counters preserved');
    notifyListeners();
  }

  /// Reset user state (alias for clearAllData)
  Future<void> resetUserState() async {
    await clearAllData();
  }

  /// Clear state immediately without saving to SharedPreferences
  void clearStateImmediately({bool preservePremium = false}) {
    debugPrint('UserState.clearStateImmediately() called, preservePremium=$preservePremium');
    debugPrint('Before clear: name=$_name, email=$_email, isPremium=$_isPremium');

    _name = null;
    _email = null;
    if (!preservePremium) {
      _isPremium = false;
    }

    // Устанавливаем флаг, чтобы предотвратить автозагрузку данных
    _preventAutoLoad = true;

    debugPrint('After clear: name=$_name, email=$_email, isPremium=$_isPremium');
    debugPrint('_preventAutoLoad flag set to true');
    notifyListeners();
  }

  /// Enable auto-loading of data
  void enableAutoLoad() {
    debugPrint('UserState.enableAutoLoad() called');
    _preventAutoLoad = false;
    debugPrint('_preventAutoLoad flag reset to false');
  }
}
