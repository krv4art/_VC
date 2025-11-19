import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for app security features (biometric auth, auto-delete)
class SecurityService {
  static final SecurityService _instance = SecurityService._internal();
  factory SecurityService() => _instance;
  SecurityService._internal();

  final LocalAuthentication _localAuth = LocalAuthentication();

  // SharedPreferences keys
  static const String _keyBiometricEnabled = 'biometric_enabled';
  static const String _keyAutoDeleteEnabled = 'auto_delete_enabled';
  static const String _keyAutoDeleteDays = 'auto_delete_days';
  static const String _keyRequireAuthOnLaunch = 'require_auth_on_launch';
  static const String _keyRequireAuthForGallery = 'require_auth_for_gallery';

  /// Check if device supports biometric authentication
  Future<bool> isBiometricAvailable() async {
    try {
      return await _localAuth.canCheckBiometrics;
    } catch (e) {
      debugPrint('Error checking biometric availability: $e');
      return false;
    }
  }

  /// Get available biometric types
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (e) {
      debugPrint('Error getting available biometrics: $e');
      return [];
    }
  }

  /// Authenticate with biometrics
  Future<bool> authenticateWithBiometrics({
    String localizedReason = 'Authenticate to access your photos',
    bool useErrorDialogs = true,
    bool stickyAuth = false,
  }) async {
    try {
      final isAvailable = await isBiometricAvailable();
      if (!isAvailable) {
        debugPrint('Biometric authentication not available');
        return false;
      }

      return await _localAuth.authenticate(
        localizedReason: localizedReason,
        options: AuthenticationOptions(
          useErrorDialogs: useErrorDialogs,
          stickyAuth: stickyAuth,
          biometricOnly: false,
        ),
      );
    } on PlatformException catch (e) {
      debugPrint('Biometric authentication error: $e');
      return false;
    }
  }

  /// Enable/disable biometric authentication
  Future<bool> setBiometricEnabled(bool enabled) async {
    try {
      if (enabled) {
        // Verify biometric works before enabling
        final canAuth = await isBiometricAvailable();
        if (!canAuth) {
          debugPrint('Cannot enable biometric: not available');
          return false;
        }

        // Test authentication
        final authSuccess = await authenticateWithBiometrics(
          localizedReason: 'Verify your identity to enable biometric lock',
        );

        if (!authSuccess) {
          debugPrint('Authentication failed, not enabling biometric');
          return false;
        }
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyBiometricEnabled, enabled);

      debugPrint('Biometric authentication ${enabled ? 'enabled' : 'disabled'}');
      return true;
    } catch (e) {
      debugPrint('Error setting biometric enabled: $e');
      return false;
    }
  }

  /// Check if biometric is enabled
  Future<bool> isBiometricEnabled() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_keyBiometricEnabled) ?? false;
    } catch (e) {
      debugPrint('Error checking if biometric enabled: $e');
      return false;
    }
  }

  /// Set require authentication on app launch
  Future<void> setRequireAuthOnLaunch(bool required) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyRequireAuthOnLaunch, required);
    } catch (e) {
      debugPrint('Error setting require auth on launch: $e');
    }
  }

  /// Check if authentication is required on launch
  Future<bool> isAuthRequiredOnLaunch() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_keyRequireAuthOnLaunch) ?? false;
    } catch (e) {
      debugPrint('Error checking auth required on launch: $e');
      return false;
    }
  }

  /// Set require authentication for gallery
  Future<void> setRequireAuthForGallery(bool required) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyRequireAuthForGallery, required);
    } catch (e) {
      debugPrint('Error setting require auth for gallery: $e');
    }
  }

  /// Check if authentication is required for gallery
  Future<bool> isAuthRequiredForGallery() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_keyRequireAuthForGallery) ?? false;
    } catch (e) {
      debugPrint('Error checking auth required for gallery: $e');
      return false;
    }
  }

  /// Enable/disable auto-delete old photos
  Future<void> setAutoDeleteEnabled(bool enabled, {int days = 30}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyAutoDeleteEnabled, enabled);
      if (enabled) {
        await prefs.setInt(_keyAutoDeleteDays, days);
      }
      debugPrint('Auto-delete ${enabled ? 'enabled' : 'disabled'} (${days} days)');
    } catch (e) {
      debugPrint('Error setting auto-delete: $e');
    }
  }

  /// Check if auto-delete is enabled
  Future<bool> isAutoDeleteEnabled() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_keyAutoDeleteEnabled) ?? false;
    } catch (e) {
      debugPrint('Error checking auto-delete enabled: $e');
      return false;
    }
  }

  /// Get auto-delete days
  Future<int> getAutoDeleteDays() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_keyAutoDeleteDays) ?? 30;
    } catch (e) {
      debugPrint('Error getting auto-delete days: $e');
      return 30;
    }
  }

  /// Get security settings summary
  Future<Map<String, dynamic>> getSecuritySettings() async {
    return {
      'biometric_available': await isBiometricAvailable(),
      'biometric_enabled': await isBiometricEnabled(),
      'available_biometrics': await getAvailableBiometrics(),
      'auth_required_on_launch': await isAuthRequiredOnLaunch(),
      'auth_required_for_gallery': await isAuthRequiredForGallery(),
      'auto_delete_enabled': await isAutoDeleteEnabled(),
      'auto_delete_days': await getAutoDeleteDays(),
    };
  }

  /// Get biometric type name for display
  String getBiometricTypeName(BiometricType type) {
    switch (type) {
      case BiometricType.face:
        return 'Face ID';
      case BiometricType.fingerprint:
        return 'Fingerprint';
      case BiometricType.iris:
        return 'Iris';
      case BiometricType.weak:
        return 'PIN/Pattern';
      case BiometricType.strong:
        return 'Strong Biometric';
    }
  }

  /// Get available biometrics display text
  Future<String> getAvailableBiometricsText() async {
    final biometrics = await getAvailableBiometrics();
    if (biometrics.isEmpty) return 'None';

    return biometrics.map((b) => getBiometricTypeName(b)).join(', ');
  }

  /// Stop sensors (for security when app goes to background)
  Future<void> stopAuthentication() async {
    try {
      await _localAuth.stopAuthentication();
    } catch (e) {
      debugPrint('Error stopping authentication: $e');
    }
  }

  /// Check if should authenticate (based on settings)
  Future<bool> shouldAuthenticateOnLaunch() async {
    final biometricEnabled = await isBiometricEnabled();
    final authRequired = await isAuthRequiredOnLaunch();
    return biometricEnabled && authRequired;
  }

  /// Check if should authenticate for gallery
  Future<bool> shouldAuthenticateForGallery() async {
    final biometricEnabled = await isBiometricEnabled();
    final authRequired = await isAuthRequiredForGallery();
    return biometricEnabled && authRequired;
  }

  /// Authenticate with custom message
  Future<bool> authenticateForGallery() async {
    return await authenticateWithBiometrics(
      localizedReason: 'Authenticate to view your photo gallery',
      useErrorDialogs: true,
      stickyAuth: true,
    );
  }

  /// Authenticate for app launch
  Future<bool> authenticateForLaunch() async {
    return await authenticateWithBiometrics(
      localizedReason: 'Authenticate to open AI Photo Studio',
      useErrorDialogs: true,
      stickyAuth: true,
    );
  }

  /// Reset all security settings
  Future<void> resetSecuritySettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyBiometricEnabled);
      await prefs.remove(_keyAutoDeleteEnabled);
      await prefs.remove(_keyAutoDeleteDays);
      await prefs.remove(_keyRequireAuthOnLaunch);
      await prefs.remove(_keyRequireAuthForGallery);

      debugPrint('Security settings reset');
    } catch (e) {
      debugPrint('Error resetting security settings: $e');
    }
  }
}
