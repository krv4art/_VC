import '../config/app_config.dart';

/// Supabase configuration constants
class SupabaseConfig {
  /// Get appropriate Supabase URL based on environment
  static String getSupabaseUrl() {
    return AppConfig().getSupabaseUrl();
  }

  /// Get appropriate Supabase anon key based on environment
  static String getSupabaseAnonKey() {
    return AppConfig().getSupabaseAnonKey();
  }
}
