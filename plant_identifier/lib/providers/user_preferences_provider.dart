import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_preferences.dart';

/// Provider for managing user preferences
class UserPreferencesProvider extends ChangeNotifier {
  static const String _preferencesKey = 'user_preferences';

  UserPreferences _preferences = UserPreferences(
    id: 'default',
    experience: GardeningExperience.beginner,
  );

  UserPreferences get preferences => _preferences;

  UserPreferencesProvider() {
    _loadPreferences();
  }

  /// Load preferences from storage
  Future<void> _loadPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_preferencesKey);

      if (jsonString != null) {
        final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
        _preferences = UserPreferences.fromJson(jsonMap);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading preferences: $e');
    }
  }

  /// Public method to load preferences (for splash screen)
  Future<void> loadPreferences() async {
    await _loadPreferences();
  }

  /// Save preferences to storage
  Future<void> _savePreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = json.encode(_preferences.toJson());
      await prefs.setString(_preferencesKey, jsonString);
    } catch (e) {
      debugPrint('Error saving preferences: $e');
    }
  }

  /// Update user preferences
  Future<void> updatePreferences(UserPreferences newPreferences) async {
    _preferences = newPreferences;
    notifyListeners();
    await _savePreferences();
  }

  /// Update location
  Future<void> updateLocation(String location) async {
    _preferences = _preferences.copyWith(location: location);
    notifyListeners();
    await _savePreferences();
  }

  /// Update climate
  Future<void> updateClimate(String climate) async {
    _preferences = _preferences.copyWith(climate: climate);
    notifyListeners();
    await _savePreferences();
  }

  /// Update garden type
  Future<void> updateGardenType(String gardenType) async {
    _preferences = _preferences.copyWith(gardenType: gardenType);
    notifyListeners();
    await _savePreferences();
  }

  /// Update experience level
  Future<void> updateExperience(GardeningExperience experience) async {
    _preferences = _preferences.copyWith(experience: experience);
    notifyListeners();
    await _savePreferences();
  }

  /// Toggle interest
  Future<void> toggleInterest(PlantInterest interest) async {
    final currentInterests = List<PlantInterest>.from(_preferences.interests);

    if (currentInterests.contains(interest)) {
      currentInterests.remove(interest);
    } else {
      currentInterests.add(interest);
    }

    _preferences = _preferences.copyWith(interests: currentInterests);
    notifyListeners();
    await _savePreferences();
  }

  /// Toggle toxic warnings
  Future<void> toggleToxicWarnings(bool value) async {
    _preferences = _preferences.copyWith(showToxicWarnings: value);
    notifyListeners();
    await _savePreferences();
  }

  /// Toggle watering reminders
  Future<void> toggleWateringReminders(bool value) async {
    _preferences = _preferences.copyWith(wateringReminders: value);
    notifyListeners();
    await _savePreferences();
  }

  /// Toggle care reminders
  Future<void> toggleCareReminders(bool value) async {
    _preferences = _preferences.copyWith(careReminders: value);
    notifyListeners();
    await _savePreferences();
  }

  /// Update temperature
  Future<void> updateTemperature(double temperature) async {
    _preferences = _preferences.copyWith(temperature: temperature);
    notifyListeners();
    await _savePreferences();
  }

  /// Update humidity
  Future<void> updateHumidity(double humidity) async {
    _preferences = _preferences.copyWith(humidity: humidity);
    notifyListeners();
    await _savePreferences();
  }

  /// Update environmental conditions (temperature and humidity together)
  Future<void> updateEnvironmentalConditions({
    double? temperature,
    double? humidity,
  }) async {
    _preferences = _preferences.copyWith(
      temperature: temperature ?? _preferences.temperature,
      humidity: humidity ?? _preferences.humidity,
    );
    notifyListeners();
    await _savePreferences();
  }

  /// Complete onboarding
  Future<void> completeOnboarding() async {
    _preferences = _preferences.copyWith(onboardingCompleted: true);
    notifyListeners();
    await _savePreferences();
  }
}
