class SupabaseConfig {
  // Development environment
  static const String devSupabaseUrl = 'https://your-dev-project.supabase.co';
  static const String devSupabaseAnonKey = 'your-dev-anon-key';

  // Production environment
  static const String prodSupabaseUrl = 'https://your-prod-project.supabase.co';
  static const String prodSupabaseAnonKey = 'your-prod-anon-key';

  // Runtime configuration (can be overridden)
  static String supabaseUrl = '';
  static String supabaseAnonKey = '';

  // Edge Functions
  static const String backgroundRemovalFunction = 'background-removal';
  static const String backgroundGenerationFunction = 'background-generation';
  static const String chatFunction = 'chat-completion';
}
