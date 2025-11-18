import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';
import '../models/user_profile.dart';
import '../models/interest.dart';

/// Service for transforming boring problems into interest-based versions
/// Example: "5 kg of potatoes" → "5 kg of diamond ore in Minecraft"
class ProblemTransformerService {
  final SupabaseClient _supabase;
  final Map<String, String> _transformCache = {};

  ProblemTransformerService({required SupabaseClient supabase})
      : _supabase = supabase;

  /// Transform a problem to match user's interests
  Future<TransformedProblem> transformProblem({
    required String originalProblem,
    required String originalAnswer,
    required List<Interest> userInterests,
    String? preferredLanguage,
  }) async {
    try {
      // Check cache first
      final cacheKey = _getCacheKey(originalProblem, userInterests);
      if (_transformCache.containsKey(cacheKey)) {
        return TransformedProblem(
          original: originalProblem,
          transformed: _transformCache[cacheKey]!,
          originalAnswer: originalAnswer,
          transformedAnswer: originalAnswer, // Answer stays the same
          appliedInterest: userInterests.first.name,
        );
      }

      // Build transformation prompt
      final interestsText = userInterests.map((i) => i.name).join(', ');
      final prompt = _buildTransformationPrompt(
        originalProblem,
        originalAnswer,
        interestsText,
        preferredLanguage ?? 'en',
      );

      // Call AI to transform
      final response = await _supabase.functions.invoke(
        'ai-tutor',
        body: {
          'messages': [
            {'role': 'system', 'content': 'You are a creative problem transformer.'},
            {'role': 'user', 'content': prompt},
          ],
          'mode': 'transform',
        },
      );

      final data = response.data;
      final transformedText = data['message'] as String? ?? originalProblem;

      // Cache the result
      _transformCache[cacheKey] = transformedText;

      return TransformedProblem(
        original: originalProblem,
        transformed: transformedText,
        originalAnswer: originalAnswer,
        transformedAnswer: originalAnswer,
        appliedInterest: userInterests.first.name,
      );
    } catch (e) {
      debugPrint('Error transforming problem: $e');

      // Fallback to local transformation
      return _localTransform(
        originalProblem,
        originalAnswer,
        userInterests,
      );
    }
  }

  /// Build AI prompt for transformation
  String _buildTransformationPrompt(
    String problem,
    String answer,
    String interests,
    String language,
  ) {
    if (language == 'ru') {
      return '''
Преобразуй эту математическую задачу, используя интересы пользователя: $interests

ОРИГИНАЛЬНАЯ ЗАДАЧА:
$problem

ПРАВИЛА:
1. Сохрани все числа и математическую логику
2. Замени объекты и контекст на элементы из мира интересов
3. Сделай задачу увлекательной и релевантной интересам
4. Используй терминологию из этих интересов
5. Ответ должен остаться тем же: $answer

ПРИМЕРЫ ПРЕОБРАЗОВАНИЙ:
- "5 кг картошки" → "5 кг алмазной руды" (для Minecraft)
- "100 км пути" → "100 блоков в Эндере" (для Minecraft)
- "10 литров воды" → "10 зелий лечения" (для Gaming)
- "3 часа работы" → "3 часа прокачки персонажа" (для Gaming)

Верни ТОЛЬКО преобразованную задачу, без объяснений.
''';
    } else {
      return '''
Transform this math problem using the user's interests: $interests

ORIGINAL PROBLEM:
$problem

RULES:
1. Keep all numbers and mathematical logic
2. Replace objects and context with elements from the interest world
3. Make it engaging and relevant to the interests
4. Use terminology from these interests
5. The answer must remain the same: $answer

TRANSFORMATION EXAMPLES:
- "5 kg of potatoes" → "5 kg of diamond ore" (for Minecraft)
- "100 km distance" → "100 blocks in the End" (for Minecraft)
- "10 liters of water" → "10 healing potions" (for Gaming)
- "3 hours of work" → "3 hours of character leveling" (for Gaming)

Return ONLY the transformed problem, no explanations.
''';
    }
  }

  /// Local transformation (fallback when API fails)
  TransformedProblem _localTransform(
    String problem,
    String answer,
    List<Interest> interests,
  ) {
    String transformed = problem;
    final interest = interests.isNotEmpty ? interests.first : null;

    if (interest != null) {
      // Simple keyword replacements based on interest
      final replacements = _getReplacementMap(interest.name);

      replacements.forEach((original, replacement) {
        transformed = transformed.replaceAll(
          RegExp(original, caseSensitive: false),
          replacement,
        );
      });
    }

    return TransformedProblem(
      original: problem,
      transformed: transformed,
      originalAnswer: answer,
      transformedAnswer: answer,
      appliedInterest: interest?.name ?? 'none',
    );
  }

  /// Get replacement keywords for each interest
  Map<String, String> _getReplacementMap(String interestName) {
    final maps = {
      'Gaming': {
        'apples': 'health potions',
        'potatoes': 'mana potions',
        'kilometers': 'levels',
        'meters': 'tiles',
        'hours': 'game sessions',
        'people': 'players',
        'money': 'gold coins',
        'cars': 'vehicles',
      },
      'Minecraft': {
        'apples': 'golden apples',
        'potatoes': 'diamond ore',
        'wheat': 'wheat blocks',
        'kilometers': 'chunks',
        'meters': 'blocks',
        'liters': 'buckets',
        'grams': 'items',
        'kilograms': 'stacks',
      },
      'Sports': {
        'apples': 'footballs',
        'potatoes': 'basketballs',
        'kilometers': 'laps',
        'meters': 'yards',
        'hours': 'training sessions',
        'people': 'athletes',
      },
      'Music': {
        'apples': 'notes',
        'potatoes': 'chords',
        'kilometers': 'songs',
        'meters': 'beats',
        'hours': 'practice sessions',
        'people': 'musicians',
      },
      'Art': {
        'apples': 'paintbrushes',
        'potatoes': 'canvases',
        'kilometers': 'artworks',
        'meters': 'strokes',
        'hours': 'painting sessions',
        'people': 'artists',
      },
      'Science': {
        'apples': 'molecules',
        'potatoes': 'atoms',
        'kilometers': 'light-years',
        'meters': 'wavelengths',
        'hours': 'experiments',
        'people': 'scientists',
      },
      'Coding': {
        'apples': 'functions',
        'potatoes': 'variables',
        'kilometers': 'lines of code',
        'meters': 'characters',
        'hours': 'coding sessions',
        'people': 'developers',
      },
      'Reading': {
        'apples': 'chapters',
        'potatoes': 'books',
        'kilometers': 'pages',
        'meters': 'paragraphs',
        'hours': 'reading sessions',
        'people': 'readers',
      },
    };

    return maps[interestName] ?? {};
  }

  /// Generate cache key
  String _getCacheKey(String problem, List<Interest> interests) {
    final interestNames = interests.map((i) => i.name).join('_');
    return '${problem.hashCode}_$interestNames';
  }

  /// Clear cache
  void clearCache() {
    _transformCache.clear();
  }
}

/// Transformed problem result
class TransformedProblem {
  final String original;
  final String transformed;
  final String originalAnswer;
  final String transformedAnswer;
  final String appliedInterest;

  TransformedProblem({
    required this.original,
    required this.transformed,
    required this.originalAnswer,
    required this.transformedAnswer,
    required this.appliedInterest,
  });

  bool get isTransformed => original != transformed;

  Map<String, dynamic> toJson() => {
        'original': original,
        'transformed': transformed,
        'originalAnswer': originalAnswer,
        'transformedAnswer': transformedAnswer,
        'appliedInterest': appliedInterest,
      };

  factory TransformedProblem.fromJson(Map<String, dynamic> json) {
    return TransformedProblem(
      original: json['original'] as String,
      transformed: json['transformed'] as String,
      originalAnswer: json['originalAnswer'] as String,
      transformedAnswer: json['transformedAnswer'] as String,
      appliedInterest: json['appliedInterest'] as String,
    );
  }
}
