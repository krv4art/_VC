import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/analysis_result.dart';
import '../models/dialogue.dart';
import '../models/chat_message.dart';

/// Сервис для работы с Supabase (облачное хранилище и БД)
class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();

  late final SupabaseClient _client;

  factory SupabaseService() {
    return _instance;
  }

  SupabaseService._internal();

  /// Инициализация Supabase клиента
  Future<void> initialize() async {
    try {
      const String supabaseUrl =
          'https://yerbryysrnaraqmbhqdm.supabase.co';
      const String supabaseAnonKey =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InllcmJyeXlzcm5hcmFxbWJoeWRtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzA3MTI4NDIsImV4cCI6MjA0NjI4ODg0Mn0.5bVHgn_8DpP6TQ-H6n4Y-dHzDBZ9FYl3t_c8j8M7g0c';

      await Supabase.initialize(
        url: supabaseUrl,
        anonKey: supabaseAnonKey,
      );

      _client = Supabase.instance.client;
      debugPrint('✓ Supabase initialized successfully');
    } catch (e) {
      debugPrint('Error initializing Supabase: $e');
      rethrow;
    }
  }

  SupabaseClient get client => _client;

  /// Сохраняет результат анализа в Supabase
  Future<String> saveAnalysisResult(AnalysisResult result) async {
    try {
      final Map<String, dynamic> data = {
        'item_name': result.itemName,
        'category': result.category,
        'description': result.description,
        'materials': result.materials.map((m) => m.toJson()).toList(),
        'historical_context': result.historicalContext,
        'estimated_period': result.estimatedPeriod,
        'estimated_origin': result.estimatedOrigin,
        'price_estimate': result.priceEstimate?.toJson(),
        'warnings': result.warnings,
        'authenticity_notes': result.authenticityNotes,
        'similar_items': result.similarItems,
        'ai_summary': result.aiSummary,
        'is_antique': result.isAntique,
        'created_at': DateTime.now().toIso8601String(),
      };

      final response = await _client
          .from('antique_analyses')
          .insert(data)
          .select()
          .single();

      return response['id'] as String? ?? '';
    } catch (e) {
      debugPrint('Error saving analysis result: $e');
      rethrow;
    }
  }

  /// Получает результат анализа по ID
  Future<AnalysisResult?> getAnalysisResult(String resultId) async {
    try {
      final response = await _client
          .from('antique_analyses')
          .select()
          .eq('id', resultId)
          .single();

      return AnalysisResult.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      debugPrint('Error fetching analysis result: $e');
      return null;
    }
  }

  /// Создает новый диалог
  Future<int?> createDialogue(
    String title, {
    String? antiqueImagePath,
    String? analysisResultId,
  }) async {
    try {
      final response = await _client
          .from('dialogues')
          .insert({
            'title': title,
            'antique_image_path': antiqueImagePath,
            'analysis_result_id': analysisResultId,
            'created_at': DateTime.now().toIso8601String(),
          })
          .select()
          .single();

      return response['id'] as int?;
    } catch (e) {
      debugPrint('Error creating dialogue: $e');
      rethrow;
    }
  }

  /// Получает все диалоги
  Future<List<Dialogue>> getAllDialogues() async {
    try {
      final response = await _client
          .from('dialogues')
          .select()
          .order('created_at', ascending: false);

      return (response as List<dynamic>)
          .map((d) => Dialogue.fromJson(d as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Error fetching dialogues: $e');
      return [];
    }
  }

  /// Получает диалог по ID
  Future<Dialogue?> getDialogue(int dialogueId) async {
    try {
      final response = await _client
          .from('dialogues')
          .select()
          .eq('id', dialogueId)
          .single();

      return Dialogue.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      debugPrint('Error fetching dialogue: $e');
      return null;
    }
  }

  /// Сохраняет сообщение чата
  Future<void> saveMessage(ChatMessage message) async {
    try {
      await _client.from('chat_messages').insert(message.toJson());
    } catch (e) {
      debugPrint('Error saving chat message: $e');
      rethrow;
    }
  }

  /// Получает сообщения диалога
  Future<List<ChatMessage>> getMessages(int dialogueId) async {
    try {
      final response = await _client
          .from('chat_messages')
          .select()
          .eq('dialogue_id', dialogueId)
          .order('timestamp', ascending: true);

      return (response as List<dynamic>)
          .map((m) => ChatMessage.fromJson(m as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Error fetching messages: $e');
      return [];
    }
  }

  /// Загружает изображение в Supabase Storage
  Future<String> uploadImage(
    List<int> imageBytes,
    String fileName,
  ) async {
    try {
      final String path = 'antiques/$fileName';

      await _client.storage
          .from('antique_photos')
          .uploadBinary(
            path,
            imageBytes,
            fileOptions: const FileOptions(upsert: true),
          );

      final String publicUrl = _client.storage
          .from('antique_photos')
          .getPublicUrl(path);

      return publicUrl;
    } catch (e) {
      debugPrint('Error uploading image: $e');
      rethrow;
    }
  }

  /// Удаляет диалог и связанные сообщения
  Future<void> deleteDialogue(int dialogueId) async {
    try {
      // Удаляем сообщения
      await _client
          .from('chat_messages')
          .delete()
          .eq('dialogue_id', dialogueId);

      // Удаляем диалог
      await _client.from('dialogues').delete().eq('id', dialogueId);
    } catch (e) {
      debugPrint('Error deleting dialogue: $e');
      rethrow;
    }
  }
}
