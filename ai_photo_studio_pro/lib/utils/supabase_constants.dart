class SupabaseConfig {
  static const String url = 'https://yerbryysrnaraqmbhqdm.supabase.co';
  static const String anonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InllcmJyeXlzcm5hcmFxbWJocWRtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mjg0NzQ3MTUsImV4cCI6MjA0NDA1MDcxNX0.w2NvNgIUzDEcv1WMt0vumw_-Tqm_1QJU-OHCz6fGCfY';

  // Aliases for compatibility
  static String get supabaseUrl => url;
  static String get devSupabaseUrl => url;
  static String get prodSupabaseUrl => url;
  static String get supabaseAnonKey => anonKey;
  static String get devSupabaseAnonKey => anonKey;
  static String get prodSupabaseAnonKey => anonKey;
}