import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/analysis_result.dart';
import '../models/bug_analysis.dart'; // NEW: Insect models
import '../models/chat_message.dart';
import '../config/prompts_manager.dart';
import '../exceptions/api_exceptions.dart';

class GeminiService {
  final bool useProxy;
  final SupabaseClient? _supabaseClient;

  //static const String _apiKey = 'AIzaSyBhFq-8l7Xu__B9YORp7FGANhYPmjSqqDQ';

  final List<ChatMessage> _history = [];

  GeminiService({this.useProxy = true, SupabaseClient? supabaseClient})
    : _supabaseClient = supabaseClient {
    if (useProxy && _supabaseClient == null) {
      throw ArgumentError(
        'SupabaseClient must be provided when useProxy is true.',
      );
    }
  }

  Future<String> sendMessageWithHistory(
    String message, {
    String languageCode = 'en',
    String? systemPrompt,
    String? userProfileContext,
    String? customPrompt,
    bool isCustomPromptEnabled = false,
  }) async {
    debugPrint(
      'Sending message to Gemini: $message (language: $languageCode, useProxy: $useProxy)',
    );
    // Всегда используем прокси-метод, так как прямой API больше не доступен
    debugPrint('=== Using PROXY mode ===');
    return await _sendMessageWithProxy(
      message,
      languageCode: languageCode,
      systemPrompt: systemPrompt,
      userProfileContext: userProfileContext,
      customPrompt: customPrompt,
      isCustomPromptEnabled: isCustomPromptEnabled,
    );
  }

  void clearHistory() {
    _history.clear();
    debugPrint('История чата сброшена');
  }

  String _getLanguageInstruction(String languageCode) {
    // Используем промпты из конфигурации
    final instruction = PromptsManager.getLanguageInstruction(languageCode);
    return instruction ??
        'IMPORTANT: Provide the entire response in ENGLISH. All descriptions, warnings, and recommendations should be in English.';
  }

  /// Analyze insect image and return BugAnalysis
  Future<BugAnalysis> analyzeBugImage(
    String base64Image,
    String prompt, {
    String languageCode = 'en',
  }) async {
    if (!useProxy || _supabaseClient == null) {
      throw Exception(
        'This function requires proxy mode with a Supabase client.',
      );
    }

    final functionUrl =
        'https://yerbryysrnaraqmbhqdm.supabase.co/functions/v1/gemini-vision-proxy';

    // Add language instruction to the prompt
    final languageInstruction = _getLanguageInstruction(languageCode);
    final fullPrompt = '$prompt\n\n$languageInstruction';

    final requestBody = {
      'contents': [
        {
          'parts': [
            {
              'inline_data': {'mime_type': 'image/png', 'data': base64Image},
            },
            {'text': fullPrompt},
          ],
        },
      ],
    };

    try {
      final httpResponse = await http.post(
        Uri.parse(functionUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (httpResponse.statusCode != 200) {
        final errorBody = jsonDecode(httpResponse.body);
        final errorMessage = errorBody['error'] ?? httpResponse.reasonPhrase;

        // Parse error and throw appropriate custom exception
        throw _parseApiError(errorMessage, httpResponse.statusCode);
      }

      final responseData = jsonDecode(httpResponse.body);
      final contentText =
          responseData['candidates'][0]['content']['parts'][0]['text']
              as String;

      debugPrint('=== GEMINI VISION DEBUG (INSECT): Raw response text ===');
      debugPrint(contentText);

      // Extract JSON from response
      String jsonString = contentText.trim();

      // Remove markdown code blocks if present
      jsonString = jsonString
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();

      // Find first { and last } to extract only JSON
      final firstBrace = jsonString.indexOf('{');
      final lastBrace = jsonString.lastIndexOf('}');

      if (firstBrace != -1 && lastBrace != -1 && lastBrace > firstBrace) {
        jsonString = jsonString.substring(firstBrace, lastBrace + 1);
      }

      debugPrint('=== GEMINI VISION DEBUG (INSECT): Extracted JSON ===');
      debugPrint(jsonString);

      final analysisJson = jsonDecode(jsonString) as Map<String, dynamic>;

      return BugAnalysis.fromJson(analysisJson);
    } catch (e) {
      debugPrint('Exception during insect image analysis: $e');
      rethrow;
    }
  }

  /// Analyze cosmetic image (LEGACY - for cosmetics)
  Future<AnalysisResult> analyzeImage(
    String base64Image,
    String prompt, {
    String languageCode = 'en',
  }) async {
    if (!useProxy || _supabaseClient == null) {
      throw Exception(
        'This function requires proxy mode with a Supabase client.',
      );
    }

    final functionUrl =
        'https://yerbryysrnaraqmbhqdm.supabase.co/functions/v1/gemini-vision-proxy';

    // Add language instruction to the prompt
    final languageInstruction = _getLanguageInstruction(languageCode);
    final fullPrompt = '$prompt\n\n$languageInstruction';

    final requestBody = {
      'contents': [
        {
          'parts': [
            {
              'inline_data': {'mime_type': 'image/png', 'data': base64Image},
            },
            {'text': fullPrompt},
          ],
        },
      ],
    };

    try {
      final httpResponse = await http.post(
        Uri.parse(functionUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (httpResponse.statusCode != 200) {
        final errorBody = jsonDecode(httpResponse.body);
        final errorMessage = errorBody['error'] ?? httpResponse.reasonPhrase;

        // Parse error and throw appropriate custom exception
        throw _parseApiError(errorMessage, httpResponse.statusCode);
      }

      final responseData = jsonDecode(httpResponse.body);
      final contentText =
          responseData['candidates'][0]['content']['parts'][0]['text']
              as String;

      debugPrint('=== GEMINI VISION DEBUG: Raw response text ===');
      debugPrint(contentText);

      // Улучшенное извлечение JSON
      String jsonString = contentText.trim();

      // Удаляем markdown code blocks если есть
      jsonString = jsonString
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();

      // Ищем первый { и последний } чтобы извлечь только JSON
      final firstBrace = jsonString.indexOf('{');
      final lastBrace = jsonString.lastIndexOf('}');

      if (firstBrace != -1 && lastBrace != -1 && lastBrace > firstBrace) {
        jsonString = jsonString.substring(firstBrace, lastBrace + 1);
      }

      debugPrint('=== GEMINI VISION DEBUG: Extracted JSON ===');
      debugPrint(jsonString);

      final analysisJson = jsonDecode(jsonString) as Map<String, dynamic>;

      return AnalysisResult.fromJson(analysisJson);
    } catch (e) {
      debugPrint('Exception during image analysis: $e');
      rethrow;
    }
  }

  Future<String> _sendMessageWithProxy(
    String message, {
    String languageCode = 'en',
    String? systemPrompt,
    String? userProfileContext,
    String? customPrompt,
    bool isCustomPromptEnabled = false,
  }) async {
    if (_supabaseClient == null) {
      return 'Ошибка: Supabase клиент не инициализирован.';
    }

    try {
      // Add system prompt and language instruction to the first message if history is empty
      if (_history.isEmpty) {
        // Add system prompt (use provided one or default)
        final promptToUse =
            systemPrompt ??
            PromptsManager.getChatSystemPromptWithCustom(
              type: 'default',
              customPrompt: customPrompt,
              includeCustom: isCustomPromptEnabled,
            ) ??
            'You are a helpful AI assistant specializing in cosmetics and skincare.';
        _history.add(
          ChatMessage(dialogueId: 0, text: promptToUse, isUser: true),
        );
        _history.add(
          ChatMessage(
            dialogueId: 0,
            text: 'Understood. I will follow these guidelines.',
            isUser: false,
          ),
        );

        // Add language instruction
        final languageInstruction = _getLanguageInstruction(languageCode);
        _history.add(
          ChatMessage(dialogueId: 0, text: languageInstruction, isUser: true),
        );
        _history.add(
          ChatMessage(
            dialogueId: 0,
            text: 'Understood. I will respond in the requested language.',
            isUser: false,
          ),
        );

        // Add user profile context if provided
        if (userProfileContext != null && userProfileContext.isNotEmpty) {
          _history.add(
            ChatMessage(dialogueId: 0, text: userProfileContext, isUser: true),
          );
          _history.add(
            ChatMessage(
              dialogueId: 0,
              text:
                  'Understood. I have noted your profile information and will take it into account in my responses.',
              isUser: false,
            ),
          );
        }
      }

      _history.add(ChatMessage(dialogueId: 0, text: message, isUser: true));

      final apiHistory = _history.map((msg) {
        return {
          'role': msg.isUser ? 'user' : 'model',
          'parts': [
            {'text': msg.text},
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
        final error = errorData['error'] ?? 'Неизвестная ошибка';
        debugPrint(
          'Ошибка вызова функции Supabase: $error (Status: ${httpResponse.statusCode})',
        );

        // Parse error and throw appropriate custom exception
        throw _parseApiError(error, httpResponse.statusCode);
      }

      final responseData = jsonDecode(httpResponse.body);
      final responseText =
          responseData['text'] as String? ?? 'Не удалось получить ответ.';

      _history.add(
        ChatMessage(dialogueId: 0, text: responseText, isUser: false),
      );

      return responseText;
    } catch (e) {
      _history.removeLast();
      debugPrint('Исключение при вызове функции Supabase: $e');

      // Rethrow if it's already a custom exception
      if (e is ApiException) {
        rethrow;
      }

      // Otherwise throw a network exception
      throw NetworkException(technicalDetails: e.toString());
    }
  }

  /// Parses API error messages and returns appropriate custom exceptions
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
