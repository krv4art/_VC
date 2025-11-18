import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/chat_message.dart';

/// Сервис для обслуживания чатов с ИИ о антиквариате
class ChatService {
  static const String _supabaseUrl =
      'https://yerbryysrnaraqmbhqdm.supabase.co/functions/v1/gemini-proxy';

  final List<ChatMessage> _history = [];

  /// Отправляет сообщение и получает ответ от ИИ
  Future<String> sendMessage(
    String message, {
    required String languageCode,
    String? antiqueContext,
  }) async {
    try {
      // Добавляем пользовательское сообщение в историю
      final userMessage = ChatMessage(
        dialogueId: 0, // Будет установлен позже
        text: message,
        isUser: true,
        timestamp: DateTime.now(),
      );
      _history.add(userMessage);

      // Строим контекст для ИИ
      final systemPrompt = _buildSystemPrompt(languageCode, antiqueContext);

      // Конвертируем историю для API
      final apiHistory = _history.map((msg) {
        return {
          'role': msg.isUser ? 'user' : 'model',
          'parts': [
            {'text': msg.text},
          ],
        };
      }).toList();

      debugPrint('Sending message to Gemini: $message');

      final Map<String, dynamic> requestBody = {
        'contents': [
          {
            'role': 'user',
            'parts': [
              {
                'text': message,
              },
            ],
          },
        ],
        'systemInstruction': {
          'parts': [
            {'text': systemPrompt},
          ],
        },
      };

      final http.Response response = await http.post(
        Uri.parse(_supabaseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw TimeoutException(
          'Chat request took too long. Please try again.',
        ),
      );

      if (response.statusCode != 200) {
        debugPrint('API error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to get response: ${response.statusCode}');
      }

      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final String? aiResponse = responseData['candidates']?[0]?['content']
          ?['parts']?[0]?['text'] as String?;

      if (aiResponse == null) {
        throw Exception('No response text from Gemini');
      }

      // Добавляем ответ ИИ в историю
      final aiMessage = ChatMessage(
        dialogueId: 0,
        text: aiResponse,
        isUser: false,
        timestamp: DateTime.now(),
      );
      _history.add(aiMessage);

      return aiResponse;
    } catch (e) {
      debugPrint('Error in chat service: $e');
      rethrow;
    }
  }

  /// Очищает историю чата
  void clearHistory() {
    _history.clear();
    debugPrint('Chat history cleared');
  }

  /// Получает историю чата
  List<ChatMessage> getHistory() => List.unmodifiable(_history);

  /// Строит системный промпт для ИИ
  String _buildSystemPrompt(String languageCode, String? antiqueContext) {
    String systemPrompt = '''You are a knowledgeable expert on antiques, collectibles, and historical artifacts.
Your role is to help users understand the value, history, and characteristics of antique items they own.

IMPORTANT GUIDELINES:
1. Always provide factual, well-researched information
2. Be honest about uncertainty - if you're not sure about something, say so
3. Recommend professional appraisals for significant items
4. Consider condition, rarity, and provenance in your assessments
5. Discuss market trends and demand for similar items
6. Help identify materials, manufacturing techniques, and design periods
7. Explain care and preservation tips for antiques
8. Discuss authenticity concerns and how to spot reproductions

When discussing prices:
- Always give ranges, not exact prices
- Acknowledge that values vary by location and current market
- Reference comparable sales when possible
- Note that professional appraisal may change your assessment

Respond helpfully to questions about:
- History and provenance of items
- Materials and construction methods
- Design periods and styles
- Estimated values and market trends
- Condition assessment and restoration advice
- Preservation and care tips
- How to find similar items or comparable sales

LANGUAGE: $languageCode
CRITICAL: Provide ALL responses ONLY in $languageCode language.''';

    if (antiqueContext != null && antiqueContext.isNotEmpty) {
      systemPrompt +=
          '\n\nCONTEXT: The user just analyzed an antique item:\n$antiqueContext\n\nBe ready to answer follow-up questions about this specific item.';
    }

    systemPrompt += _getLanguageSpecificInstructions(languageCode);

    return systemPrompt;
  }

  String _getLanguageSpecificInstructions(String languageCode) {
    final instructions = {
      'ru':
          '\n\nОТВЕЧАЙ ТОЛЬКО НА РУССКОМ ЯЗЫКЕ! Используй русские термины антиквариата.',
      'uk':
          '\n\nВІДПОВІДАЙ ЛИШЕ УКРАЇНСЬКОЮ МОВОЮ! Використовуй українські терміни антикваріату.',
      'es':
          '\n\n¡RESPONDE SOLO EN ESPAÑOL! Usa términos españoles para antigüedades.',
      'de': '\n\nANTWORTE NUR AUF DEUTSCH! Verwende deutsche Antikuitäten-Begriffe.',
      'fr':
          '\n\nRÉPONDEZ UNIQUEMENT EN FRANÇAIS! Utilisez les termes français des antiquités.',
      'it':
          '\n\nRISPONDI SOLO IN ITALIANO! Utilizza i termini italiani per i cimeli.',
      'en': '',
    };

    return instructions[languageCode] ?? '';
  }
}

class TimeoutException implements Exception {
  final String message;
  TimeoutException(this.message);

  @override
  String toString() => message;
}
