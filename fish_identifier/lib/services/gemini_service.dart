import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/fish_identification.dart';
import '../models/chat_message.dart';
import '../config/fish_prompts_manager.dart';
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

  /// Identify fish from image
  Future<FishIdentification> identifyFish(
    String base64Image, {
    String languageCode = 'en',
    String? location,
    double? latitude,
    double? longitude,
  }) async {
    if (!useProxy || _supabaseClient == null) {
      throw Exception(
        'This function requires proxy mode with a Supabase client.',
      );
    }

    final functionUrl =
        'https://yerbryysrnaraqmbhqdm.supabase.co/functions/v1/gemini-vision-proxy';

    final prompt = FishPromptsManager.getIdentificationPrompt(languageCode);

    final requestBody = {
      'contents': [
        {
          'parts': [
            {
              'inline_data': {'mime_type': 'image/png', 'data': base64Image},
            },
            {'text': prompt},
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
        throw _parseApiError(errorMessage, httpResponse.statusCode);
      }

      final responseData = jsonDecode(httpResponse.body);
      final contentText =
          responseData['candidates'][0]['content']['parts'][0]['text']
              as String;

      debugPrint('=== FISH ID DEBUG: Raw response text ===');
      debugPrint(contentText);

      // Extract JSON from response
      String jsonString = contentText.trim();
      jsonString = jsonString
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();

      final firstBrace = jsonString.indexOf('{');
      final lastBrace = jsonString.lastIndexOf('}');

      if (firstBrace != -1 && lastBrace != -1 && lastBrace > firstBrace) {
        jsonString = jsonString.substring(firstBrace, lastBrace + 1);
      }

      debugPrint('=== FISH ID DEBUG: Extracted JSON ===');
      debugPrint(jsonString);

      final fishJson = jsonDecode(jsonString) as Map<String, dynamic>;

      // Check if it's actually a fish
      if (fishJson['is_fish'] == false) {
        throw InvalidResponseException(
          technicalDetails: FishPromptsManager.getNotFishMessage(languageCode),
        );
      }

      // Create FishIdentification from JSON
      return FishIdentification(
        imagePath: '', // Will be set by caller
        fishName: fishJson['fish_name'] as String? ?? 'Unknown Fish',
        scientificName: fishJson['scientific_name'] as String? ?? '',
        habitat: fishJson['habitat'] as String? ?? '',
        diet: fishJson['diet'] as String? ?? '',
        funFacts: (fishJson['fun_facts'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            [],
        confidenceScore:
            (fishJson['confidence_score'] as num?)?.toDouble() ?? 0.0,
        identifyDate: DateTime.now(),
        location: location,
        latitude: latitude,
        longitude: longitude,
        edibility: fishJson['edibility'] as String?,
        cookingTips: fishJson['cooking_tips'] as String?,
        fishingTips: fishJson['fishing_tips'] as String?,
        conservationStatus: fishJson['conservation_status'] as String?,
      );
    } catch (e) {
      debugPrint('Exception during fish identification: $e');
      rethrow;
    }
  }

  /// Send message with chat history for fish-related questions
  Future<String> sendMessageWithHistory(
    String message, {
    String languageCode = 'en',
    String? fishContext,
  }) async {
    debugPrint(
      'Sending message to Fish AI: $message (language: $languageCode)',
    );

    if (_supabaseClient == null) {
      return 'Error: Supabase client not initialized.';
    }

    try {
      // Initialize chat with system prompt if history is empty
      if (_history.isEmpty) {
        final systemPrompt = FishPromptsManager.getChatSystemPrompt(
          languageCode,
          fishContext: fishContext,
        );
        _history.add(
          ChatMessage(dialogueId: 0, text: systemPrompt, isUser: true),
        );
        _history.add(
          ChatMessage(
            dialogueId: 0,
            text: 'Understood. I will help with fish-related questions!',
            isUser: false,
          ),
        );
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

      debugPrint('=== FISH CHAT DEBUG: Sending request ===');

      final httpResponse = await http.post(
        Uri.parse(functionUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'prompt': message, 'history': apiHistory}),
      );

      debugPrint(
        '=== FISH CHAT DEBUG: Response status: ${httpResponse.statusCode} ===',
      );

      if (httpResponse.statusCode != 200) {
        _history.removeLast();
        final errorData = jsonDecode(httpResponse.body);
        final error = errorData['error'] ?? 'Unknown error';
        throw _parseApiError(error, httpResponse.statusCode);
      }

      final responseData = jsonDecode(httpResponse.body);
      final responseText =
          responseData['text'] as String? ?? 'Unable to get response.';

      _history.add(
        ChatMessage(dialogueId: 0, text: responseText, isUser: false),
      );

      return responseText;
    } catch (e) {
      _history.removeLast();
      debugPrint('Exception in fish chat: $e');

      if (e is ApiException) {
        rethrow;
      }

      throw NetworkException(technicalDetails: e.toString());
    }
  }

  void clearHistory() {
    _history.clear();
    debugPrint('Chat history cleared');
  }

  /// Parses API error messages and returns appropriate custom exceptions
  ApiException _parseApiError(String errorMessage, int statusCode) {
    final errorLower = errorMessage.toLowerCase();

    if (errorLower.contains('overload') ||
        errorLower.contains('capacity') ||
        errorLower.contains('too many requests') ||
        errorLower.contains('resource exhausted')) {
      return ServiceOverloadedException(technicalDetails: errorMessage);
    }

    if (errorLower.contains('rate limit') ||
        errorLower.contains('quota') ||
        statusCode == 429) {
      return RateLimitException(technicalDetails: errorMessage);
    }

    if (errorLower.contains('authentication') ||
        errorLower.contains('unauthorized') ||
        errorLower.contains('forbidden') ||
        statusCode == 401 ||
        statusCode == 403) {
      return AuthenticationException(technicalDetails: errorMessage);
    }

    if (errorLower.contains('timeout') ||
        errorLower.contains('deadline exceeded')) {
      return TimeoutException(technicalDetails: errorMessage);
    }

    if (errorLower.contains('invalid') ||
        errorLower.contains('malformed') ||
        errorLower.contains('parse error')) {
      return InvalidResponseException(technicalDetails: errorMessage);
    }

    return ServerException(technicalDetails: errorMessage);
  }
}
