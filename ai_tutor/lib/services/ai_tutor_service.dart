import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';

import '../models/chat_message.dart';
import '../models/user_profile.dart';
import '../models/subject.dart';

/// AI Tutor Service for personalized learning
class AITutorService {
  final SupabaseClient _supabase;
  static const String _functionName = 'ai-tutor';

  AITutorService({required SupabaseClient supabase}) : _supabase = supabase;

  /// Send message to AI tutor with personalization
  Future<String> sendMessage({
    required String message,
    required UserProfile userProfile,
    required Subject subject,
    List<Map<String, String>>? chatHistory,
    TutorMode mode = TutorMode.explain,
  }) async {
    try {
      // Build system prompt with personalization
      final systemPrompt = _buildSystemPrompt(
        userProfile: userProfile,
        subject: subject,
        mode: mode,
      );

      // Prepare messages
      final messages = [
        {'role': 'system', 'content': systemPrompt},
        if (chatHistory != null) ...chatHistory,
        {'role': 'user', 'content': message},
      ];

      // Call Supabase Edge Function
      final response = await _supabase.functions.invoke(
        _functionName,
        body: {
          'messages': messages,
          'user_profile': userProfile.toJson(),
          'subject': subject.id,
          'mode': mode.name,
        },
      );

      if (response.data != null && response.data['response'] != null) {
        return response.data['response'] as String;
      }

      throw Exception('Invalid response from AI service');
    } catch (e) {
      debugPrint('Error in AI Tutor service: $e');
      return _getFallbackResponse(mode);
    }
  }

  /// Generate personalized practice problem
  Future<String> generatePracticeProblem({
    required UserProfile userProfile,
    required Subject subject,
    required String topic,
    required int difficulty,
  }) async {
    try {
      final personalizationContext = userProfile.getPersonalizationContext();
      final interests = userProfile.interests
          .map((i) => i.name)
          .join(', ');

      final prompt = '''
Generate a $subject practice problem about $topic (difficulty: $difficulty/10).

$personalizationContext

Requirements:
- Use examples from these interests: $interests
- Make it engaging and relatable
- Include context from user's interests
- Difficulty level: $difficulty/10
- Subject: ${subject.name}
- Topic: $topic

Provide:
1. The problem statement (with personalized context)
2. Step-by-step hints (don't give the answer directly)
3. What concept this practices
''';

      final response = await sendMessage(
        message: prompt,
        userProfile: userProfile,
        subject: subject,
        mode: TutorMode.practice,
      );

      return response;
    } catch (e) {
      debugPrint('Error generating practice problem: $e');
      return 'Failed to generate practice problem. Please try again.';
    }
  }

  /// Get hint for a problem
  Future<String> getHint({
    required String problem,
    required UserProfile userProfile,
    required Subject subject,
  }) async {
    try {
      final prompt = '''
User is stuck on this problem:
$problem

Provide a helpful hint without giving away the full solution.
Use the Socratic method - ask guiding questions.
''';

      final response = await sendMessage(
        message: prompt,
        userProfile: userProfile,
        subject: subject,
        mode: TutorMode.hint,
      );

      return response;
    } catch (e) {
      debugPrint('Error getting hint: $e');
      return 'Try breaking the problem into smaller steps. What do you know so far?';
    }
  }

  /// Check solution and provide feedback
  Future<String> checkSolution({
    required String problem,
    required String userSolution,
    required UserProfile userProfile,
    required Subject subject,
  }) async {
    try {
      final prompt = '''
Problem:
$problem

User's solution:
$userSolution

Check if the solution is correct. Provide:
1. Whether it's correct or not
2. If wrong, where the mistake is (don't solve it for them)
3. Encouragement
4. A guiding question to help them find the right approach
''';

      final response = await sendMessage(
        message: prompt,
        userProfile: userProfile,
        subject: subject,
        mode: TutorMode.checkSolution,
      );

      return response;
    } catch (e) {
      debugPrint('Error checking solution: $e');
      return 'Unable to check solution. Please try again.';
    }
  }

  /// Build system prompt with personalization
  String _buildSystemPrompt({
    required UserProfile userProfile,
    required Subject subject,
    required TutorMode mode,
  }) {
    final theme = userProfile.culturalTheme;
    final interests = userProfile.interests.map((i) => i.name).join(', ');
    final keywords = userProfile.interests
        .expand((i) => i.keywords)
        .take(15)
        .join(', ');

    String roleDescription;
    switch (mode) {
      case TutorMode.explain:
        roleDescription = 'You explain concepts clearly and patiently';
      case TutorMode.practice:
        roleDescription = 'You create engaging practice problems';
      case TutorMode.hint:
        roleDescription = 'You give helpful hints using the Socratic method';
      case TutorMode.checkSolution:
        roleDescription = 'You check solutions and provide constructive feedback';
    }

    String toneInstructions;
    switch (theme.dialogStyle) {
      case DialogStyle.casual:
        toneInstructions = 'Be friendly, casual, and approachable. Use simple language.';
      case DialogStyle.formal:
        toneInstructions = 'Be polite, professional, and clear. Use proper academic language.';
      case DialogStyle.respectful:
        toneInstructions = 'Be very respectful and encouraging. Show patience and understanding.';
      case DialogStyle.enthusiastic:
        toneInstructions = 'Be energetic, motivating, and positive! Make learning fun!';
    }

    return '''
You are an AI tutor for ${subject.name}. $roleDescription.

PERSONALIZATION:
- Student's interests: $interests
- Cultural theme: ${theme.name} - ${theme.description}
- Learning style: ${userProfile.learningStyle.displayName}
- Dialog style: ${theme.dialogStyle.name}

INSTRUCTIONS:
1. $toneInstructions
2. Use examples and contexts from these interests: $interests
3. Naturally incorporate these keywords when relevant: $keywords
4. Use cultural references from: ${theme.culturalKeywords.join(', ')}
5. Match the ${theme.dialogStyle.name} dialog style
6. Never just give answers - guide the student to understand
7. Use the Socratic method - ask questions to lead them to the answer
8. Provide encouragement and celebrate progress
9. If they're struggling, break things down into smaller steps
10. Make abstract concepts concrete using their interests

LEARNING STYLE: ${userProfile.learningStyle.displayName}
${_getLearningStyleInstructions(userProfile.learningStyle)}

Remember: The goal is understanding, not just answers. Make it engaging and personalized!
''';
  }

  /// Get learning style specific instructions
  String _getLearningStyleInstructions(LearningStyle style) {
    switch (style) {
      case LearningStyle.visual:
        return '- Use visual descriptions, diagrams, and graphical representations\n- Describe visual patterns and relationships';
      case LearningStyle.practical:
        return '- Provide many concrete examples\n- Focus on practice and application\n- Give exercises to try';
      case LearningStyle.theoretical:
        return '- Provide detailed explanations\n- Explain the "why" behind concepts\n- Connect to broader theory';
      case LearningStyle.balanced:
        return '- Mix theory with examples\n- Balance explanation with practice\n- Vary your teaching approach';
      case LearningStyle.quick:
        return '- Be concise and to the point\n- Summarize key points\n- Provide quick examples';
    }
  }

  /// Fallback response when AI service fails
  String _getFallbackResponse(TutorMode mode) {
    switch (mode) {
      case TutorMode.explain:
        return "I'm having trouble connecting right now. Could you rephrase your question?";
      case TutorMode.practice:
        return "I can't generate a practice problem at the moment. Please try again.";
      case TutorMode.hint:
        return "Try breaking down the problem step by step. What information do you have?";
      case TutorMode.checkSolution:
        return "I can't check your solution right now. Could you walk me through your steps?";
    }
  }
}

/// Tutor modes
enum TutorMode {
  explain, // Explain concepts
  practice, // Generate practice problems
  hint, // Give hints
  checkSolution, // Check user's solution
}
