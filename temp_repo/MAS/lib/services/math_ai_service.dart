import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/math_expression.dart';
import '../models/math_solution.dart';
import '../models/solution_step.dart';
import '../models/validation_result.dart';
import '../models/training_session.dart';
import '../exceptions/api_exceptions.dart';

/// Сервис для работы с математическим AI (Gemini)
class MathAIService {
  final SupabaseClient _supabaseClient;

  MathAIService({required SupabaseClient supabaseClient})
      : _supabaseClient = supabaseClient;

  /// Решить задачу с пошаговым объяснением
  Future<MathSolution> solveProblem(
    String base64Image, {
    String languageCode = 'en',
  }) async {
    debugPrint('🔢 Solving math problem...');

    final prompt = _buildSolveProblemPrompt(languageCode);
    final functionUrl =
        'https://yerbryysrnaraqmbhqdm.supabase.co/functions/v1/gemini-vision-proxy';

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

      // Извлекаем JSON из ответа
      String jsonString = _extractJson(contentText);

      final solutionJson = jsonDecode(jsonString) as Map<String, dynamic>;
      return MathSolution.fromJson(solutionJson);
    } catch (e) {
      debugPrint('❌ Error solving problem: $e');
      rethrow;
    }
  }

  /// Проверить решение пользователя
  Future<ValidationResult> checkUserSolution(
    String base64Image, {
    String languageCode = 'en',
  }) async {
    debugPrint('✅ Checking user solution...');

    final prompt = _buildCheckSolutionPrompt(languageCode);
    final functionUrl =
        'https://yerbryysrnaraqmbhqdm.supabase.co/functions/v1/gemini-vision-proxy';

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

      String jsonString = _extractJson(contentText);

      final validationJson = jsonDecode(jsonString) as Map<String, dynamic>;
      return ValidationResult.fromJson(validationJson);
    } catch (e) {
      debugPrint('❌ Error checking solution: $e');
      rethrow;
    }
  }

  /// Генерировать похожие задачи для тренировки
  Future<List<SimilarProblem>> generateSimilarProblems(
    String base64Image, {
    int count = 5,
    String languageCode = 'en',
  }) async {
    debugPrint('💪 Generating $count similar problems...');

    final prompt = _buildGenerateProblemsPrompt(count, languageCode);
    final functionUrl =
        'https://yerbryysrnaraqmbhqdm.supabase.co/functions/v1/gemini-vision-proxy';

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

      String jsonString = _extractJson(contentText);

      final problemsJson = jsonDecode(jsonString) as Map<String, dynamic>;
      final problemsList = problemsJson['problems'] as List<dynamic>;

      return problemsList
          .map((e) => SimilarProblem.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('❌ Error generating problems: $e');
      rethrow;
    }
  }

  /// Извлечь JSON из ответа (убрать markdown и лишний текст)
  String _extractJson(String contentText) {
    String jsonString = contentText.trim();

    // Удаляем markdown code blocks
    jsonString = jsonString
        .replaceAll('```json', '')
        .replaceAll('```', '')
        .trim();

    // Ищем первый { и последний }
    final firstBrace = jsonString.indexOf('{');
    final lastBrace = jsonString.lastIndexOf('}');

    if (firstBrace != -1 && lastBrace != -1 && lastBrace > firstBrace) {
      jsonString = jsonString.substring(firstBrace, lastBrace + 1);
    }

    return jsonString;
  }

  /// Промпт для решения задачи
  String _buildSolveProblemPrompt(String languageCode) {
    final language = _getLanguageName(languageCode);

    return '''
You are an expert math tutor. Analyze the mathematical problem in the image and provide a step-by-step solution.

IMPORTANT: Respond ONLY with valid JSON. No additional text before or after.

Return JSON in this exact format:
{
  "problem": {
    "raw_text": "The problem text",
    "latex_formula": "LaTeX formula",
    "type": "equation"
  },
  "steps": [
    {
      "step_number": 1,
      "description": "What we do in this step",
      "formula": "LaTeX formula for this step",
      "explanation": "Why we do this step"
    }
  ],
  "final_answer": "The final answer",
  "difficulty": "medium",
  "explanation": "Overall explanation",
  "tips": "Common mistakes to avoid"
}

LANGUAGE: All text must be in $language.

Problem types: equation, inequality, expression, system, derivative, integral, limit, geometry, wordProblem
Difficulty levels: easy, medium, hard
''';
  }

  /// Промпт для проверки решения
  String _buildCheckSolutionPrompt(String languageCode) {
    final language = _getLanguageName(languageCode);

    return '''
You are a math teacher checking a student's handwritten solution. Analyze each step carefully.

IMPORTANT: Respond ONLY with valid JSON. No additional text.

Return JSON in this exact format:
{
  "is_correct": true,
  "step_validations": [
    {
      "step_number": 1,
      "is_correct": true,
      "error_type": null,
      "hint": null
    },
    {
      "step_number": 2,
      "is_correct": false,
      "error_type": "arithmetic",
      "hint": "Check your multiplication"
    }
  ],
  "hints": ["General hint 1", "General hint 2"],
  "accuracy": 75.0,
  "final_verdict": "Good work! Review step 2."
}

LANGUAGE: All text must be in $language.

Error types: arithmetic, logical, missingStep, wrongMethod, signError, algebraic, unknown
''';
  }

  /// Промпт для генерации похожих задач
  String _buildGenerateProblemsPrompt(int count, String languageCode) {
    final language = _getLanguageName(languageCode);

    return '''
You are a math teacher. Generate $count similar problems based on the example in the image.

IMPORTANT: Respond ONLY with valid JSON. No additional text.

Return JSON in this exact format:
{
  "problems": [
    {
      "problem": {
        "raw_text": "Problem text",
        "latex_formula": "LaTeX formula",
        "type": "equation"
      },
      "difficulty": "medium",
      "answer_options": ["A) 1", "B) 2", "C) 3", "D) 4"],
      "correct_answer": "B) 2",
      "explanation": "Brief explanation"
    }
  ]
}

LANGUAGE: All text must be in $language.

Make problems slightly different but using the same concept.
Provide 4 answer options (A, B, C, D) for each problem.
''';
  }

  /// Получить название языка
  String _getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'uk':
        return 'Ukrainian';
      case 'ru':
        return 'Russian';
      case 'en':
        return 'English';
      default:
        return 'English';
    }
  }

  /// Парсинг ошибок API
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
