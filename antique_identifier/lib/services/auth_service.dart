import 'dart:developer' as developer;
import 'package:supabase_flutter/supabase_flutter.dart';

/// Сервис аутентификации через Supabase
class AuthService {
  final SupabaseClient _client = Supabase.instance.client;

  /// Текущий пользователь
  User? get currentUser => _client.auth.currentUser;

  /// Проверка авторизации
  bool get isAuthenticated => currentUser != null;

  /// Получить ID пользователя
  String? get userId => currentUser?.id;

  /// Получить email пользователя
  String? get userEmail => currentUser?.email;

  /// Поток состояния аутентификации
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  /// Регистрация с email и паролем
  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      developer.log('Signing up with email: $email', name: 'AuthService');

      final response = await _client.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user != null) {
        developer.log('Sign up successful', name: 'AuthService');
      }

      return response;
    } catch (e) {
      developer.log('Sign up error: $e', name: 'AuthService');
      rethrow;
    }
  }

  /// Вход с email и паролем
  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      developer.log('Signing in with email: $email', name: 'AuthService');

      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        developer.log('Sign in successful', name: 'AuthService');
      }

      return response;
    } catch (e) {
      developer.log('Sign in error: $e', name: 'AuthService');
      rethrow;
    }
  }

  /// Вход через Google
  Future<bool> signInWithGoogle() async {
    try {
      developer.log('Signing in with Google', name: 'AuthService');

      final response = await _client.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'io.supabase.flutterquickstart://login-callback/',
      );

      developer.log('Google sign in initiated', name: 'AuthService');
      return response;
    } catch (e) {
      developer.log('Google sign in error: $e', name: 'AuthService');
      return false;
    }
  }

  /// Вход через Apple
  Future<bool> signInWithApple() async {
    try {
      developer.log('Signing in with Apple', name: 'AuthService');

      final response = await _client.auth.signInWithOAuth(
        OAuthProvider.apple,
        redirectTo: 'io.supabase.flutterquickstart://login-callback/',
      );

      developer.log('Apple sign in initiated', name: 'AuthService');
      return response;
    } catch (e) {
      developer.log('Apple sign in error: $e', name: 'AuthService');
      return false;
    }
  }

  /// Анонимный вход
  Future<AuthResponse> signInAnonymously() async {
    try {
      developer.log('Signing in anonymously', name: 'AuthService');

      final response = await _client.auth.signInAnonymously();

      if (response.user != null) {
        developer.log('Anonymous sign in successful', name: 'AuthService');
      }

      return response;
    } catch (e) {
      developer.log('Anonymous sign in error: $e', name: 'AuthService');
      rethrow;
    }
  }

  /// Выход
  Future<void> signOut() async {
    try {
      developer.log('Signing out', name: 'AuthService');
      await _client.auth.signOut();
      developer.log('Sign out successful', name: 'AuthService');
    } catch (e) {
      developer.log('Sign out error: $e', name: 'AuthService');
      rethrow;
    }
  }

  /// Сброс пароля
  Future<void> resetPassword(String email) async {
    try {
      developer.log('Resetting password for: $email', name: 'AuthService');

      await _client.auth.resetPasswordForEmail(email);

      developer.log('Password reset email sent', name: 'AuthService');
    } catch (e) {
      developer.log('Password reset error: $e', name: 'AuthService');
      rethrow;
    }
  }

  /// Обновление email
  Future<UserResponse> updateEmail(String newEmail) async {
    try {
      developer.log('Updating email to: $newEmail', name: 'AuthService');

      final response = await _client.auth.updateUser(
        UserAttributes(email: newEmail),
      );

      developer.log('Email updated successfully', name: 'AuthService');
      return response;
    } catch (e) {
      developer.log('Email update error: $e', name: 'AuthService');
      rethrow;
    }
  }

  /// Обновление пароля
  Future<UserResponse> updatePassword(String newPassword) async {
    try {
      developer.log('Updating password', name: 'AuthService');

      final response = await _client.auth.updateUser(
        UserAttributes(password: newPassword),
      );

      developer.log('Password updated successfully', name: 'AuthService');
      return response;
    } catch (e) {
      developer.log('Password update error: $e', name: 'AuthService');
      rethrow;
    }
  }

  /// Удаление аккаунта
  Future<void> deleteAccount() async {
    try {
      developer.log('Deleting account', name: 'AuthService');

      // Note: Supabase doesn't have a direct delete user method for clients
      // This would typically be handled by a server-side function
      // For now, we'll just sign out
      await signOut();

      developer.log('Account deletion requested', name: 'AuthService');
    } catch (e) {
      developer.log('Account deletion error: $e', name: 'AuthService');
      rethrow;
    }
  }

  /// Получение сессии
  Session? get currentSession => _client.auth.currentSession;

  /// Обновление сессии
  Future<AuthResponse> refreshSession() async {
    try {
      developer.log('Refreshing session', name: 'AuthService');

      final response = await _client.auth.refreshSession();

      developer.log('Session refreshed', name: 'AuthService');
      return response;
    } catch (e) {
      developer.log('Session refresh error: $e', name: 'AuthService');
      rethrow;
    }
  }
}
