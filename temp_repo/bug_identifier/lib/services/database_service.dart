import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._internal();

  factory DatabaseService() {
    return instance;
  }

  DatabaseService._internal();

  final SupabaseClient _client = Supabase.instance.client;

  // Dialogues
  Future<List<Map<String, dynamic>>> getAllDialogues() async {
    try {
      final response = await _client
          .from('dialogues')
          .select()
          .order('created_at', ascending: false);
      return List<Map<String, dynamic>>.from(response as List);
    } catch (e) {
      debugPrint('Error fetching dialogues: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> createDialogue(
    String title, {
    String? scanImagePath,
  }) async {
    try {
      final response = await _client
          .from('dialogues')
          .insert({
            'title': title,
            'created_at': DateTime.now().toIso8601String(),
            'scan_image_path': scanImagePath,
          })
          .select()
          .single();
      return response;
    } catch (e) {
      debugPrint('Error creating dialogue: $e');
      return null;
    }
  }

  Future<void> deleteDialogue(int id) async {
    try {
      await _client.from('dialogues').delete().eq('id', id);
    } catch (e) {
      debugPrint('Error deleting dialogue: $e');
    }
  }

  // Messages
  Future<List<Map<String, dynamic>>> getMessagesForDialogue(
    int dialogueId,
  ) async {
    try {
      final response = await _client
          .from('messages')
          .select()
          .eq('dialogueId', dialogueId)
          .order('timestamp', ascending: true);
      return List<Map<String, dynamic>>.from(response as List);
    } catch (e) {
      debugPrint('Error fetching messages: $e');
      return [];
    }
  }

  Future<void> createMessage(Map<String, dynamic> messageData) async {
    try {
      await _client.from('messages').insert(messageData);
    } catch (e) {
      debugPrint('Error creating message: $e');
    }
  }

  Future<void> addMessage(int dialogueId, String text, bool isUser) async {
    try {
      await _client.from('messages').insert({
        'dialogueId': dialogueId,
        'text': text,
        'isUser': isUser,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      debugPrint('Error adding message: $e');
    }
  }
}
