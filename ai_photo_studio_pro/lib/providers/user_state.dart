import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserState with ChangeNotifier {
  String? _skinType;
  String? _name;
  String? _email;
  bool _isPremium = false;
  String? _photoBase64;
  String? _ageRange;

  // Флаги для отслеживания конфигурации настроек
  bool _ageConfigured = false;
  bool _skinTypeConfigured = false;
  bool _onboardingCompleted = false;

  // Флаг для предотвращения автоматической загрузки данных после очистки
  bool _preventAutoLoad = false;

  String? get skinType => _skinType;
  String? get name => _name;
  String? get email => _email;
  bool get isPremium => _isPremium;
  String? get photoBase64 => _photoBase64;
  String? get ageRange => _ageRange;
  bool get ageConfigured => _ageConfigured;
  bool get skinTypeConfigured => _skinTypeConfigured;
  bool get onboardingCompleted => _onboardingCompleted;

  UserState() {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    debugPrint('UserState._loadPreferences() вызван');

    // Проверяем флаг, предотвращающий автоматическую загрузку после очистки
    if (_preventAutoLoad) {
      debugPrint('Автозагрузка предотвращена флагом _preventAutoLoad');
      return;
    }

    final prefs = await SharedPreferences.getInstance();

    _skinType = prefs.getString('skinType');
    _name = prefs.getString('name');
    _email = prefs.getString('email');
    _isPremium = prefs.getBool('isPremium') ?? false;
    _photoBase64 = prefs.getString('photoBase64');
    _ageRange = prefs.getString('ageRange');

    // Загружаем флаги конфигурации настроек
    _ageConfigured = prefs.getBool('ageConfigured') ?? false;
    _skinTypeConfigured = prefs.getBool('skinTypeConfigured') ?? false;
    _onboardingCompleted = prefs.getBool('onboardingCompleted') ?? false;

    debugPrint(
      'Загружены данные из SharedPreferences: name=$_name, skinType=$_skinType, ageRange=$_ageRange, photoBase64=${_photoBase64 != null ? "не null" : "null"}',
    );
    debugPrint('notifyListeners() вызван в _loadPreferences');

    notifyListeners();
  }

  Future<void> setSkinType(String? skinType) async {
    _skinType = skinType;
    final prefs = await SharedPreferences.getInstance();
    if (skinType != null) {
      await prefs.setString('skinType', skinType);
    } else {
      await prefs.remove('skinType');
    }
    // Устанавливаем флаг конфигурации типа кожи всегда
    _skinTypeConfigured = true;
    await prefs.setBool('skinTypeConfigured', true);
    notifyListeners();
  }

  Future<void> updateSkinType(String? skinType) async {
    await setSkinType(skinType);
  }

  Future<void> updateUserInfo(String? name, String? email) async {
    _name = name;
    _email = email;
    final prefs = await SharedPreferences.getInstance();
    if (name != null) {
      await prefs.setString('name', name);
    } else {
      await prefs.remove('name');
    }
    if (email != null) {
      await prefs.setString('email', email);
    } else {
      await prefs.remove('email');
    }
    notifyListeners();
  }

  Future<void> updatePremiumStatus(bool isPremium) async {
    _isPremium = isPremium;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isPremium', isPremium);
    notifyListeners();
  }

  Future<void> updatePhotoBase64(String? photoBase64) async {
    _photoBase64 = photoBase64;
    final prefs = await SharedPreferences.getInstance();
    if (photoBase64 != null) {
      await prefs.setString('photoBase64', photoBase64);
    } else {
      await prefs.remove('photoBase64');
    }
    notifyListeners();
  }

  Future<void> setAgeRange(String? ageRange) async {
    _ageRange = ageRange;
    final prefs = await SharedPreferences.getInstance();
    if (ageRange != null) {
      await prefs.setString('ageRange', ageRange);
    } else {
      await prefs.remove('ageRange');
    }
    // Устанавливаем флаг конфигурации возраста всегда
    _ageConfigured = true;
    await prefs.setBool('ageConfigured', true);
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    _onboardingCompleted = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboardingCompleted', true);
    notifyListeners();
  }

  Future<void> clearAllData({bool preservePremium = false}) async {
    debugPrint(
      'UserState.clearAllData() вызван, preservePremium=$preservePremium',
    );
    debugPrint(
      'До очистки: name=$_name, skinType=$_skinType, photoBase64=${_photoBase64 != null ? "не null" : "null"}',
    );

    _skinType = null;
    _name = null;
    _email = null;
    if (!preservePremium) {
      _isPremium = false;
    }
    _photoBase64 = null;
    _ageRange = null;

    // Сбрасываем флаги конфигурации настроек
    _ageConfigured = false;
    _skinTypeConfigured = false;
    _onboardingCompleted = false;

    // Устанавливаем флаг, чтобы предотвратить автозагрузку данных
    _preventAutoLoad = true;

    debugPrint(
      'После очистки состояния: name=$_name, skinType=$_skinType, ageRange=$_ageRange, photoBase64=${_photoBase64 != null ? "не null" : "null"}',
    );
    debugPrint('Флаг _preventAutoLoad установлен в true');

    final prefs = await SharedPreferences.getInstance();

    // Сохраняем счётчики использования перед очисткой
    final weeklyScansCount = prefs.getInt('weekly_scans_count');
    final weeklyScansResetDate = prefs.getString('weekly_scans_reset_date');
    final dailyMessagesCount = prefs.getInt('daily_messages_count');
    final dailyMessagesResetDate = prefs.getString('daily_messages_reset_date');

    await prefs.remove('skinType');
    await prefs.remove('name');
    await prefs.remove('email');
    if (!preservePremium) {
      await prefs.remove('isPremium');
    }
    await prefs.remove('photoBase64');
    await prefs.remove('ageRange');

    // Удаляем флаги конфигурации настроек
    await prefs.remove('ageConfigured');
    await prefs.remove('skinTypeConfigured');
    await prefs.remove('onboardingCompleted');

    // Восстанавливаем счётчики использования
    if (weeklyScansCount != null) {
      await prefs.setInt('weekly_scans_count', weeklyScansCount);
    }
    if (weeklyScansResetDate != null) {
      await prefs.setString('weekly_scans_reset_date', weeklyScansResetDate);
    }
    if (dailyMessagesCount != null) {
      await prefs.setInt('daily_messages_count', dailyMessagesCount);
    }
    if (dailyMessagesResetDate != null) {
      await prefs.setString(
        'daily_messages_reset_date',
        dailyMessagesResetDate,
      );
    }

    debugPrint(
      'Данные удалены из SharedPreferences с сохранением счётчиков использования',
    );
    debugPrint('notifyListeners() вызван в clearAllData');

    notifyListeners();
  }

  /// Метод для сброса состояния пользователя (псевдоним для clearAllData)
  Future<void> resetUserState() async {
    await clearAllData();
  }

  /// Метод для немедленной очистки состояния без сохранения в SharedPreferences
  void clearStateImmediately({bool preservePremium = false}) {
    debugPrint(
      'UserState.clearStateImmediately() вызван, preservePremium=$preservePremium',
    );
    debugPrint(
      'До очистки: name=$_name, skinType=$_skinType, photoBase64=${_photoBase64 != null ? "не null" : "null"}',
    );

    _skinType = null;
    _name = null;
    _email = null;
    if (!preservePremium) {
      _isPremium = false;
    }
    _photoBase64 = null;
    _ageRange = null;

    // Сбрасываем флаги конфигурации настроек
    _ageConfigured = false;
    _skinTypeConfigured = false;

    // Устанавливаем флаг, чтобы предотвратить автозагрузку данных
    _preventAutoLoad = true;

    debugPrint(
      'После очистки: name=$_name, skinType=$_skinType, ageRange=$_ageRange, photoBase64=${_photoBase64 != null ? "не null" : "null"}',
    );
    debugPrint('Флаг _preventAutoLoad установлен в true');
    debugPrint('notifyListeners() вызван в UserState');

    notifyListeners();
  }

  /// Метод для разрешения автоматической загрузки данных
  void enableAutoLoad() {
    debugPrint('UserState.enableAutoLoad() вызван');
    _preventAutoLoad = false;
    debugPrint('Флаг _preventAutoLoad сброшен в false');
  }
}
