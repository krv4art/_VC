class SupabaseConfig {
  static const String url = 'https://yerbryysrnaraqmbhqdm.supabase.co';
  static const String anonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InllcmJyeXlzcm5hcmFxbWJocWRtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTUwNjY4MTIsImV4cCI6MjA3MDY0MjgxMn0.jqAChRZ2f19chNlbl3PiAxydWkpnZSQhhEd6iLMiUyk';

  // Aliases for compatibility
  static String get supabaseUrl => url;
  static String get devSupabaseUrl => url;
  static String get prodSupabaseUrl => url;
  static String get supabaseAnonKey => anonKey;
  static String get devSupabaseAnonKey => anonKey;
  static String get prodSupabaseAnonKey => anonKey;
}
