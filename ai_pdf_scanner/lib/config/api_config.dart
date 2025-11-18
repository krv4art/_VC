/// API configuration for the application
/// Contains URLs and keys for external services
class ApiConfig {
  // Private constructor to prevent instantiation
  ApiConfig._();

  // ==================== SUPABASE ====================

  /// Supabase project URL
  /// This should ideally be loaded from environment variables
  static const String supabaseUrl = 'https://yerbryysrnaraqmbhqdm.supabase.co';

  /// Supabase anonymous key
  /// This should ideally be loaded from environment variables
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InllcmJyeXlzcm5hcmFxbWJocWRtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTUwNjY4MTIsImV4cCI6MjA3MDY0MjgxMn0.jqAChRZ2f19chNlbl3PiAxydWkpnZSQhhEd6iLMiUyk';

  // ==================== AI API ====================

  /// Supabase Edge Function endpoint for AI processing
  /// We use Supabase Edge Functions as a proxy to Gemini API for security
  static const String aiEndpoint = '$supabaseUrl/functions/v1/ai-process';

  // ==================== STORAGE ====================

  /// Supabase storage bucket for PDF files
  static const String pdfStorageBucket = 'pdf-documents';

  /// Supabase storage bucket for thumbnails
  static const String thumbnailStorageBucket = 'pdf-thumbnails';
}
