import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

import '../models/practice_problem.dart';
import '../models/user_profile.dart';

/// Service for generating and managing practice problems
class PracticeService {
  final SupabaseClient _supabase;

  PracticeService({required SupabaseClient supabase}) : _supabase = supabase;

  /// Generate personalized practice problems
  Future<List<PracticeProblem>> generateProblems({
    required String subjectId,
    required String topic,
    required int difficulty,
    required UserProfile userProfile,
    int count = 5,
  }) async {
    try {
      final interests = userProfile.selectedInterests;
      final culturalTheme = userProfile.culturalThemeId;
      final learningStyle = userProfile.learningStyle.name;

      final response = await _supabase.functions.invoke(
        'generate-practice',
        body: {
          'subject': subjectId,
          'topic': topic,
          'difficulty': difficulty,
          'interests': interests,
          'cultural_theme': culturalTheme,
          'learning_style': learningStyle,
          'count': count,
        },
      );

      if (response.data != null && response.data['problems'] != null) {
        final problemsData = response.data['problems'] as List;
        return problemsData
            .map((p) => PracticeProblem.fromJson({
                  ...p,
                  'subject_id': subjectId,
                  'topic': topic,
                }))
            .toList();
      }

      throw Exception('No problems generated');
    } catch (e) {
      debugPrint('Error generating problems: $e');
      // Return fallback problems
      return _getFallbackProblems(subjectId, topic, difficulty);
    }
  }

  /// Get fallback problems when AI fails
  List<PracticeProblem> _getFallbackProblems(
    String subjectId,
    String topic,
    int difficulty,
  ) {
    return [
      PracticeProblem(
        subjectId: subjectId,
        topic: topic,
        difficulty: difficulty,
        problem: 'Practice problem will be generated soon. Please try again.',
        answer: 'N/A',
        hints: ['Please try generating problems again'],
      ),
    ];
  }

  /// Check user's answer
  Future<Map<String, dynamic>> checkAnswer({
    required PracticeProblem problem,
    required String userAnswer,
  }) async {
    try {
      // Simple comparison for now
      final isCorrect = userAnswer.trim().toLowerCase() ==
          problem.answer.trim().toLowerCase();

      return {
        'is_correct': isCorrect,
        'correct_answer': problem.answer,
        'feedback': isCorrect
            ? '🎉 Correct! Great job!'
            : 'Not quite. The correct answer is: ${problem.answer}',
      };
    } catch (e) {
      debugPrint('Error checking answer: $e');
      return {
        'is_correct': false,
        'correct_answer': problem.answer,
        'feedback': 'Error checking answer. Please try again.',
      };
    }
  }

  /// Save problem attempt
  Future<void> saveProblemAttempt(ProblemAttempt attempt) async {
    try {
      await _supabase.from('problem_attempts').insert(attempt.toJson());
    } catch (e) {
      debugPrint('Error saving attempt: $e');
    }
  }
}
