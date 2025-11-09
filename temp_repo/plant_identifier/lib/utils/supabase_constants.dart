import 'package:flutter/foundation.dart';

/// Supabase configuration constants
class SupabaseConfig {
  // Production Supabase credentials (from environment variables)
  static String supabaseUrl = const String.fromEnvironment('SUPABASE_URL');
  static String supabaseAnonKey =
      const String.fromEnvironment('SUPABASE_ANON_KEY');

  // Development credentials (fallback)
  static const String devSupabaseUrl =
      'https://yerbryysrnaraqmbhqdm.supabase.co';
  static const String devSupabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inllcmyemloc3JuYXJhcW1iaHFkbSIsInJvbGUiOiJhbm9uIiwiaWF0IjoxNzMwMzg2NjczLCJleHAiOjIwNDU5NjI2NzN9.example';

  // Production credentials (fallback)
  static const String prodSupabaseUrl =
      'https://yerbryysrnaraqmbhqdm.supabase.co';
  static const String prodSupabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inllcmyemloc3JuYXJhcW1iaHFkbSIsInJvbGUiOiJhbm9uIiwiaWF0IjoxNzMwMzg2NjczLCJleHAiOjIwNDU5NjI2NzN9.example';

  /// Get appropriate Supabase URL based on environment
  static String getSupabaseUrl() {
    if (supabaseUrl.isNotEmpty) return supabaseUrl;
    return kDebugMode ? devSupabaseUrl : prodSupabaseUrl;
  }

  /// Get appropriate Supabase anon key based on environment
  static String getSupabaseAnonKey() {
    if (supabaseAnonKey.isNotEmpty) return supabaseAnonKey;
    return kDebugMode ? devSupabaseAnonKey : prodSupabaseAnonKey;
  }
}
