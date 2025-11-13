import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/chat_message.dart';
import '../config/prompts_manager.dart';
import '../exceptions/api_exceptions.dart';

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

  Future<String> sendMessageWithHistory(
    String message, {
    String languageCode = 'en',
    String? systemPrompt,
    String? userProfileContext,
    String? customPrompt,
    bool isCustomPromptEnabled = false,
    String? imageBase64,
  }) async {
    debugPrint(
      'Sending message to Gemini: $message (language: $languageCode, useProxy: $useProxy, hasImage: ${imageBase64 != null})',
    );
    // Always use proxy method
    debugPrint('=== Using PROXY mode ===');
    return await _sendMessageWithProxy(
      message,
      languageCode: languageCode,
      systemPrompt: systemPrompt,
      userProfileContext: userProfileContext,
      customPrompt: customPrompt,
      isCustomPromptEnabled: isCustomPromptEnabled,
      imageBase64: imageBase64,
    );
  }

  void clearHistory() {
    _history.clear();
    debugPrint('Chat history cleared');
  }

  String _getLanguageInstruction(String languageCode) {
    final instruction = PromptsManager.getLanguageInstruction(languageCode);
    return instruction ??
        'IMPORTANT: Provide the entire response in ENGLISH. All descriptions, advice, and recommendations should be in English.';
  }

  Future<String> _sendMessageWithProxy(
    String message, {
    String languageCode = 'en',
    String? systemPrompt,
    String? userProfileContext,
    String? customPrompt,
    bool isCustomPromptEnabled = false,
    String? imageBase64,
  }) async {
    if (_supabaseClient == null) {
      return 'Error: Supabase client not initialized.';
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
            'You are a helpful AI assistant specializing in plant identification and care.';
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

      // Prepare the request body
      final requestBody = <String, dynamic>{
        'prompt': message,
        'history': apiHistory,
      };

      // Add image data if provided
      if (imageBase64 != null && imageBase64.isNotEmpty) {
        requestBody['image'] = imageBase64;
        debugPrint('=== GEMINI DEBUG: Including image in request ===');
      }

      final functionUrl =
          'https://yerbryysrnaraqmbhqdm.supabase.co/functions/v1/gemini-proxy';

      debugPrint('=== GEMINI DEBUG: Sending request to $functionUrl ===');
      debugPrint('=== GEMINI DEBUG: Message: $message ===');

      final httpResponse = await http.post(
        Uri.parse(functionUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
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

        // Parse error and throw appropriate custom exception
        throw _parseApiError(error, httpResponse.statusCode);
      }

      final responseData = jsonDecode(httpResponse.body);
      final responseText =
          responseData['text'] as String? ?? 'Failed to get response.';

      _history.add(
        ChatMessage(dialogueId: 0, text: responseText, isUser: false),
      );

      return responseText;
    } catch (e) {
      _history.removeLast();
      debugPrint('Exception when calling Supabase function: $e');

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
