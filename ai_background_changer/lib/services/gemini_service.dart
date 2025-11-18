import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/chat_message.dart';

class GeminiService {
  final bool useProxy;
  final SupabaseClient? _supabaseClient;

  final List<ChatMessage> _history = [];

  GeminiService({this.useProxy = true, SupabaseClient? supabaseClient})
      : _supabaseClient = supabaseClient {
    if (useProxy && _supabaseClient == null) {
      throw ArgumentError(
        'SupabaseClient must be provided when useProxy is true.',
      );
    }
  }

  /// Send message with chat history
  Future<String> sendMessageWithHistory(
    String message, {
    String languageCode = 'en',
    String? systemPrompt,
  }) async {
    debugPrint(
      'Sending message to Gemini: $message (language: $languageCode, useProxy: $useProxy)',
    );

    return await _sendMessageWithProxy(
      message,
      languageCode: languageCode,
      systemPrompt: systemPrompt,
    );
  }

  void clearHistory() {
    _history.clear();
    debugPrint('Chat history cleared');
  }

  String _getLanguageInstruction(String languageCode) {
    return 'IMPORTANT: Provide the entire response in ${languageCode.toUpperCase()} language.';
  }

  /// Generate background prompt based on user description
  Future<String> generateBackgroundPrompt(
    String userDescription, {
    String languageCode = 'en',
  }) async {
    if (!useProxy || _supabaseClient == null) {
      throw Exception(
        'This function requires proxy mode with a Supabase client.',
      );
    }

    final functionUrl =
        'https://yerbryysrnaraqmbhqdm.supabase.co/functions/v1/gemini-proxy';

    final prompt = '''Generate a detailed prompt for AI image generation based on this description: "$userDescription"

Requirements:
- Create a professional, detailed prompt optimized for AI image generation
- Include lighting, atmosphere, quality descriptors
- Keep it concise but descriptive
- Focus on background elements only
- Return ONLY the generated prompt, nothing else

Generate the prompt now:''';

    try {
      final httpResponse = await http.post(
        Uri.parse(functionUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'prompt': prompt, 'history': []}),
      );

      if (httpResponse.statusCode != 200) {
        final errorData = jsonDecode(httpResponse.body);
        final error = errorData['error'] ?? 'Unknown error';
        throw Exception('Error calling Supabase function: $error');
      }

      final responseData = jsonDecode(httpResponse.body);
      final responseText =
          responseData['text'] as String? ?? 'Failed to generate prompt.';

      return responseText.trim();
    } catch (e) {
      debugPrint('Exception during prompt generation: $e');
      rethrow;
    }
  }

  Future<String> _sendMessageWithProxy(
    String message, {
    String languageCode = 'en',
    String? systemPrompt,
  }) async {
    if (_supabaseClient == null) {
      return 'Error: Supabase client not initialized.';
    }

    try {
      // Add system prompt and language instruction to the first message if history is empty
      if (_history.isEmpty) {
        final promptToUse = systemPrompt ??
            'You are a helpful AI assistant specializing in image background replacement and photo editing.';

        _history.add(
          ChatMessage(
            id: '0',
            dialogueId: '0',
            role: 'user',
            content: promptToUse,
            timestamp: DateTime.now(),
          ),
        );
        _history.add(
          ChatMessage(
            id: '1',
            dialogueId: '0',
            role: 'model',
            content: 'Understood. I will follow these guidelines.',
            timestamp: DateTime.now(),
          ),
        );

        // Add language instruction
        final languageInstruction = _getLanguageInstruction(languageCode);
        _history.add(
          ChatMessage(
            id: '2',
            dialogueId: '0',
            role: 'user',
            content: languageInstruction,
            timestamp: DateTime.now(),
          ),
        );
        _history.add(
          ChatMessage(
            id: '3',
            dialogueId: '0',
            role: 'model',
            content: 'Understood. I will respond in the requested language.',
            timestamp: DateTime.now(),
          ),
        );
      }

      _history.add(
        ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          dialogueId: '0',
          role: 'user',
          content: message,
          timestamp: DateTime.now(),
        ),
      );

      final apiHistory = _history.map((msg) {
        return {
          'role': msg.role,
          'parts': [
            {'text': msg.content},
          ],
        };
      }).toList();

      final functionUrl =
          'https://yerbryysrnaraqmbhqdm.supabase.co/functions/v1/gemini-proxy';

      debugPrint('=== GEMINI DEBUG: Sending request to $functionUrl ===');
      debugPrint('=== GEMINI DEBUG: Message: $message ===');

      final httpResponse = await http.post(
        Uri.parse(functionUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'prompt': message, 'history': apiHistory}),
      );

      debugPrint(
        '=== GEMINI DEBUG: Response status: ${httpResponse.statusCode} ===',
      );

      if (httpResponse.statusCode != 200) {
        _history.removeLast();
        final errorData = jsonDecode(httpResponse.body);
        final error = errorData['error'] ?? 'Unknown error';
        debugPrint(
          'Error calling Supabase function: $error (Status: ${httpResponse.statusCode})',
        );
        throw Exception('Error calling Supabase function: $error');
      }

      final responseData = jsonDecode(httpResponse.body);
      final responseText =
          responseData['text'] as String? ?? 'Failed to get response.';

      _history.add(
        ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          dialogueId: '0',
          role: 'model',
          content: responseText,
          timestamp: DateTime.now(),
        ),
      );

      return responseText;
    } catch (e) {
      if (_history.isNotEmpty) {
        _history.removeLast();
      }
      debugPrint('Exception calling Supabase function: $e');
      rethrow;
    }
  }
}
