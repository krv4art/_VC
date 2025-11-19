import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_service.dart';
import 'dart:async';

enum AuthStatus {
  initial,
  authenticated,
  unauthenticated,
  loading,
}

class AuthProvider with ChangeNotifier {
  final AuthService _authService;
  AuthStatus _status = AuthStatus.initial;
  User? _user;
  String? _errorMessage;
  StreamSubscription<AuthState>? _authSubscription;

  AuthProvider({required AuthService authService})
      : _authService = authService {
    _initialize();
  }

  AuthStatus get status => _status;
  User? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get isAnonymous => _user?.isAnonymous ?? false;
  bool get isFullyAuthenticated => isAuthenticated && !isAnonymous;
  String? get userId => _user?.id;

  void _initialize() async {
    // Check initial auth state
    _user = _authService.currentUser;
    _status = _user != null ? AuthStatus.authenticated : AuthStatus.unauthenticated;

    // If no user, sign in anonymously for background authentication
    if (_user == null) {
      try {
        await signInAnonymously();
      } catch (e) {
        // Silent fail - app can work without auth
        debugPrint('Background anonymous sign-in failed: $e');
      }
    }

    // Listen to auth changes
    _authSubscription = _authService.authStateChanges.listen((event) {
      _user = event.session?.user;
      _status = _user != null ? AuthStatus.authenticated : AuthStatus.unauthenticated;
      notifyListeners();
    });

    notifyListeners();
  }

  /// Sign up with email and password
  Future<bool> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      _status = AuthStatus.loading;
      _errorMessage = null;
      notifyListeners();

      final response = await _authService.signUp(
        email: email,
        password: password,
        fullName: fullName,
      );

      if (response.user != null) {
        _user = response.user;
        _status = AuthStatus.authenticated;
        notifyListeners();
        return true;
      } else {
        _status = AuthStatus.unauthenticated;
        _errorMessage = 'Sign up failed';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      _errorMessage = _parseError(e);
      notifyListeners();
      return false;
    }
  }

  /// Sign in with email and password
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    try {
      _status = AuthStatus.loading;
      _errorMessage = null;
      notifyListeners();

      final response = await _authService.signIn(
        email: email,
        password: password,
      );

      if (response.user != null) {
        _user = response.user;
        _status = AuthStatus.authenticated;
        notifyListeners();
        return true;
      } else {
        _status = AuthStatus.unauthenticated;
        _errorMessage = 'Sign in failed';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      _errorMessage = _parseError(e);
      notifyListeners();
      return false;
    }
  }

  /// Sign in with Google
  Future<bool> signInWithGoogle() async {
    try {
      _status = AuthStatus.loading;
      _errorMessage = null;
      notifyListeners();

      final success = await _authService.signInWithGoogle();

      if (!success) {
        _status = AuthStatus.unauthenticated;
        _errorMessage = 'Google sign in cancelled';
        notifyListeners();
      }

      return success;
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      _errorMessage = _parseError(e);
      notifyListeners();
      return false;
    }
  }

  /// Sign in with Apple
  Future<bool> signInWithApple() async {
    try {
      _status = AuthStatus.loading;
      _errorMessage = null;
      notifyListeners();

      final success = await _authService.signInWithApple();

      if (!success) {
        _status = AuthStatus.unauthenticated;
        _errorMessage = 'Apple sign in cancelled';
        notifyListeners();
      }

      return success;
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      _errorMessage = _parseError(e);
      notifyListeners();
      return false;
    }
  }

  /// Sign in anonymously
  Future<bool> signInAnonymously() async {
    try {
      _status = AuthStatus.loading;
      _errorMessage = null;
      notifyListeners();

      final response = await _authService.signInAnonymously();

      if (response.user != null) {
        _user = response.user;
        _status = AuthStatus.authenticated;
        notifyListeners();
        return true;
      } else {
        _status = AuthStatus.unauthenticated;
        _errorMessage = 'Anonymous sign in failed';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      _errorMessage = _parseError(e);
      notifyListeners();
      return false;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await _authService.signOut();
      _user = null;
      _status = AuthStatus.unauthenticated;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = _parseError(e);
      notifyListeners();
    }
  }

  /// Reset password
  Future<bool> resetPassword(String email) async {
    try {
      _errorMessage = null;
      notifyListeners();

      await _authService.resetPassword(email);
      return true;
    } catch (e) {
      _errorMessage = _parseError(e);
      notifyListeners();
      return false;
    }
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Update password
  Future<bool> updatePassword(String newPassword) async {
    try {
      _errorMessage = null;
      notifyListeners();

      final response = await _authService.updatePassword(newPassword);
      return response.user != null;
    } catch (e) {
      _errorMessage = _parseError(e);
      notifyListeners();
      return false;
    }
  }

  /// Delete account
  Future<bool> deleteAccount() async {
    try {
      _errorMessage = null;
      notifyListeners();

      await _authService.deleteAccount();
      return true;
    } catch (e) {
      _errorMessage = _parseError(e);
      notifyListeners();
      return false;
    }
  }

  /// Parse error message
  String _parseError(dynamic error) {
    if (error is AuthException) {
      return error.message;
    }
    return error.toString();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}
