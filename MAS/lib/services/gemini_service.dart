import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/chat_message.dart';
import '../exceptions/api_exceptions.dart';

/// Service for Gemini AI chat conversations (text-only)
///
/// This service handles text-based chat conversations with the AI assistant
/// for math-related questions and discussions. For image-based problem solving,
/// use MathAIService instead.
class GeminiService {
  final SupabaseClient _supabaseClient;
  final List<ChatMessage> _history = [];

  GeminiService({required SupabaseClient supabaseClient})
      : _supabaseClient = supabaseClient;

  /// Send a message with conversation history
  Future<String> sendMessageWithHistory(
    String message, {
    String languageCode = 'en',
    String? userContext,
  }) async {
    debugPrint('💬 Sending message to Gemini chat: $message (language: $languageCode)');

    try {
      // Initialize history with system prompt on first message
      if (_history.isEmpty) {
        _initializeHistory(languageCode, userContext);
      }

      // Add user message to history
      _history.add(ChatMessage(dialogueId: 0, text: message, isUser: true));

      // Build API history in Gemini format
      final apiHistory = _history.map((msg) {
        return {
          'role': msg.isUser ? 'user' : 'model',
          'parts': [
            {'text': msg.text},
          ],
        };
      }).toList();

      // Call Supabase Edge Function (Gemini proxy)
      final functionUrl =
          'https://yerbryysrnaraqmbhqdm.supabase.co/functions/v1/gemini-proxy';

      debugPrint('🔗 Calling Gemini proxy at $functionUrl');

      final httpResponse = await http.post(
        Uri.parse(functionUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'prompt': message, 'history': apiHistory}),
      );

      if (httpResponse.statusCode != 200) {
        // Remove user message from history on error
        _history.removeLast();
        final errorData = jsonDecode(httpResponse.body);
        final error = errorData['error'] ?? 'Unknown error';
        debugPrint('❌ Gemini proxy error: $error (Status: ${httpResponse.statusCode})');
        throw _parseApiError(error, httpResponse.statusCode);
      }

      final responseData = jsonDecode(httpResponse.body);
      final responseText =
          responseData['text'] as String? ?? 'Failed to get response.';

      // Add bot response to history
      _history.add(
        ChatMessage(dialogueId: 0, text: responseText, isUser: false),
      );

      debugPrint('✅ Received response from Gemini (${responseText.length} chars)');
      return responseText;
    } catch (e) {
      // Remove user message from history on error
      if (_history.isNotEmpty && _history.last.isUser) {
        _history.removeLast();
      }
      debugPrint('❌ Exception in Gemini service: $e');

      // Rethrow if it's already a custom exception
      if (e is ApiException) {
        rethrow;
      }

      // Otherwise throw a network exception
      throw NetworkException(technicalDetails: e.toString());
    }
  }

  /// Initialize conversation history with system prompt
  void _initializeHistory(String languageCode, String? userContext) {
    // Add system prompt for math assistant
    final systemPrompt = _buildSystemPrompt(languageCode);
    _history.add(ChatMessage(dialogueId: 0, text: systemPrompt, isUser: true));
    _history.add(
      ChatMessage(
        dialogueId: 0,
        text: 'Understood. I will follow these guidelines as a math assistant.',
        isUser: false,
      ),
    );

    // Add language instruction
    final languageInstruction = _getLanguageInstruction(languageCode);
    _history.add(ChatMessage(dialogueId: 0, text: languageInstruction, isUser: true));
    _history.add(
      ChatMessage(
        dialogueId: 0,
        text: 'Understood. I will respond in the requested language.',
        isUser: false,
      ),
    );

    // Add user context if provided
    if (userContext != null && userContext.isNotEmpty) {
      _history.add(ChatMessage(dialogueId: 0, text: userContext, isUser: true));
      _history.add(
        ChatMessage(
          dialogueId: 0,
          text: 'Understood. I have noted your information and will personalize my responses.',
          isUser: false,
        ),
      );
    }

    debugPrint('📝 Initialized chat history with system prompt (language: $languageCode)');
  }

  /// Build system prompt for math assistant
  String _buildSystemPrompt(String languageCode) {
    return '''You are an expert mathematics tutor and AI assistant specializing in helping students understand and solve math problems.

Your role:
- Explain mathematical concepts clearly and step-by-step
- Help students understand the reasoning behind solutions
- Provide examples and analogies when helpful
- Be encouraging and patient
- Ask clarifying questions when needed
- Guide students to discover solutions themselves when appropriate

Guidelines:
- Use clear mathematical notation when needed
- Break down complex problems into manageable steps
- Explain the "why" behind each step, not just the "how"
- Adapt your explanations to the student's level
- Encourage critical thinking and problem-solving skills
- Be friendly and supportive

Topics you can help with:
- Arithmetic and basic math
- Algebra (equations, polynomials, functions)
- Geometry (shapes, angles, area, volume)
- Trigonometry
- Calculus (derivatives, integrals, limits)
- Statistics and probability
- Word problems and real-world applications
- Math concepts and theory

Always strive to make math accessible, understandable, and even enjoyable!''';
  }

  /// Get language instruction based on language code
  String _getLanguageInstruction(String languageCode) {
    switch (languageCode) {
      case 'ru':
        return 'ВАЖНО: Предоставь весь ответ на РУССКОМ языке. Все объяснения и описания должны быть на русском.';
      case 'uk':
        return 'ВАЖЛИВО: Надай всю відповідь УКРАЇНСЬКОЮ мовою. Всі пояснення та описи повинні бути українською.';
      case 'es':
        return 'IMPORTANTE: Proporciona toda la respuesta en ESPAÑOL. Todas las explicaciones y descripciones deben estar en español.';
      case 'fr':
        return 'IMPORTANT : Fournissez toute la réponse en FRANÇAIS. Toutes les explications et descriptions doivent être en français.';
      case 'de':
        return 'WICHTIG: Geben Sie die gesamte Antwort auf DEUTSCH. Alle Erklärungen und Beschreibungen müssen auf Deutsch sein.';
      case 'it':
        return 'IMPORTANTE: Fornisci l\'intera risposta in ITALIANO. Tutte le spiegazioni e descrizioni devono essere in italiano.';
      case 'pt':
        return 'IMPORTANTE: Forneça toda a resposta em PORTUGUÊS. Todas as explicações e descrições devem estar em português.';
      case 'zh':
        return '重要：请用中文提供完整回复。所有解释和描述都应使用中文。';
      case 'ja':
        return '重要: すべての回答を日本語で提供してください。すべての説明と記述は日本語である必要があります。';
      case 'ko':
        return '중요: 전체 응답을 한국어로 제공하십시오. 모든 설명과 설명은 한국어여야 합니다.';
      case 'ar':
        return 'مهم: قدم الإجابة كاملة بالعربية. يجب أن تكون جميع التفسيرات والأوصاف بالعربية.';
      case 'hi':
        return 'महत्वपूर्ण: पूरा उत्तर हिंदी में प्रदान करें। सभी स्पष्टीकरण और विवरण हिंदी में होने चाहिए।';
      default:
        return 'IMPORTANT: Provide the entire response in ENGLISH. All explanations and descriptions should be in English.';
    }
  }

  /// Clear conversation history (start new chat)
  void clearHistory() {
    _history.clear();
    debugPrint('🗑️ Chat history cleared');
  }

  /// Get current history length
  int get historyLength => _history.length;

  /// Parse API error messages and return appropriate custom exceptions
  ApiException _parseApiError(String errorMessage, int statusCode) {
    final errorLower = errorMessage.toLowerCase();

    // Check for overload/capacity errors
    if (errorLower.contains('overload') ||
        errorLower.contains('capacity') ||
        errorLower.contains('too many requests') ||
        errorLower.contains('resource exhausted')) {
      return ServiceOverloadedException(technicalDetails: errorMessage);
    }

    // Check for rate limit errors
    if (errorLower.contains('rate limit') ||
        errorLower.contains('quota') ||
        statusCode == 429) {
      return RateLimitException(technicalDetails: errorMessage);
    }

    // Check for authentication errors
    if (errorLower.contains('authentication') ||
        errorLower.contains('unauthorized') ||
        errorLower.contains('forbidden') ||
        statusCode == 401 ||
        statusCode == 403) {
      return AuthenticationException(technicalDetails: errorMessage);
    }

    // Check for timeout errors
    if (errorLower.contains('timeout') ||
        errorLower.contains('deadline exceeded')) {
      return TimeoutException(technicalDetails: errorMessage);
    }

    // Check for invalid response
    if (errorLower.contains('invalid') ||
        errorLower.contains('malformed') ||
        errorLower.contains('parse error')) {
      return InvalidResponseException(technicalDetails: errorMessage);
    }

    // Default to server exception
    return ServerException(technicalDetails: errorMessage);
  }
}
