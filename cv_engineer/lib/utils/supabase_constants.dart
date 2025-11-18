/// Supabase configuration constants
class SupabaseConfig {
  SupabaseConfig._();

  // Production Supabase URL and keys
  static const String prodSupabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: '',
  );

  static const String prodSupabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: '',
  );

  // Development Supabase URL and keys
  static const String devSupabaseUrl = String.fromEnvironment(
    'DEV_SUPABASE_URL',
    defaultValue: '',
  );

  static const String devSupabaseAnonKey = String.fromEnvironment(
    'DEV_SUPABASE_ANON_KEY',
    defaultValue: '',
  );

  // Runtime configuration (can be set from .env or config files)
  static String supabaseUrl = '';
  static String supabaseAnonKey = '';
}
