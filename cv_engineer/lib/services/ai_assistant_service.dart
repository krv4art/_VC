import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';

/// AI Assistant service for improving resume content
class AiAssistantService {
  final SupabaseClient? _supabase;
  final bool _useProxy;

  AiAssistantService({
    SupabaseClient? supabaseClient,
    bool useProxy = true,
  })  : _supabase = supabaseClient,
        _useProxy = useProxy;

  /// Improve job description or responsibility text
  Future<String> improveText(String text, {String? context}) async {
    if (_supabase == null || !_useProxy) {
      // Fallback: basic text improvements without AI
      return _basicTextImprovement(text);
    }

    try {
      final response = await _supabase!.functions.invoke(
        'ai-assistant',
        body: {
          'action': 'improve_text',
          'text': text,
          'context': context ?? 'resume',
        },
      );

      if (response.data != null && response.data['improved_text'] != null) {
        return response.data['improved_text'] as String;
      }

      return _basicTextImprovement(text);
    } catch (e) {
      debugPrint('AI Assistant error: $e');
      return _basicTextImprovement(text);
    }
  }

  /// Generate professional summary based on experience and skills
  Future<String> generateSummary({
    required List<String> experiences,
    required List<String> skills,
    String? targetRole,
  }) async {
    if (_supabase == null || !_useProxy) {
      return _basicSummaryGeneration(experiences, skills);
    }

    try {
      final response = await _supabase!.functions.invoke(
        'ai-assistant',
        body: {
          'action': 'generate_summary',
          'experiences': experiences,
          'skills': skills,
          'target_role': targetRole,
        },
      );

      if (response.data != null && response.data['summary'] != null) {
        return response.data['summary'] as String;
      }

      return _basicSummaryGeneration(experiences, skills);
    } catch (e) {
      debugPrint('AI Assistant error: $e');
      return _basicSummaryGeneration(experiences, skills);
    }
  }

  /// Suggest skills based on job title
  Future<List<String>> suggestSkills(String jobTitle) async {
    if (_supabase == null || !_useProxy) {
      return _basicSkillsSuggestion(jobTitle);
    }

    try {
      final response = await _supabase!.functions.invoke(
        'ai-assistant',
        body: {
          'action': 'suggest_skills',
          'job_title': jobTitle,
        },
      );

      if (response.data != null && response.data['skills'] != null) {
        return List<String>.from(response.data['skills']);
      }

      return _basicSkillsSuggestion(jobTitle);
    } catch (e) {
      debugPrint('AI Assistant error: $e');
      return _basicSkillsSuggestion(jobTitle);
    }
  }

  /// Fix grammar and spelling
  Future<String> fixGrammar(String text) async {
    if (_supabase == null || !_useProxy) {
      return _basicGrammarFix(text);
    }

    try {
      final response = await _supabase!.functions.invoke(
        'ai-assistant',
        body: {
          'action': 'fix_grammar',
          'text': text,
        },
      );

      if (response.data != null && response.data['corrected_text'] != null) {
        return response.data['corrected_text'] as String;
      }

      return _basicGrammarFix(text);
    } catch (e) {
      debugPrint('AI Assistant error: $e');
      return _basicGrammarFix(text);
    }
  }

  /// Make text more professional and concise
  Future<String> makeProfessional(String text) async {
    if (_supabase == null || !_useProxy) {
      return _basicProfessionalImprovement(text);
    }

    try {
      final response = await _supabase!.functions.invoke(
        'ai-assistant',
        body: {
          'action': 'make_professional',
          'text': text,
        },
      );

      if (response.data != null && response.data['professional_text'] != null) {
        return response.data['professional_text'] as String;
      }

      return _basicProfessionalImprovement(text);
    } catch (e) {
      debugPrint('AI Assistant error: $e');
      return _basicProfessionalImprovement(text);
    }
  }

  // ==================== FALLBACK METHODS ====================

  String _basicTextImprovement(String text) {
    // Basic improvements without AI
    var improved = text.trim();

    // Ensure first letter is capitalized
    if (improved.isNotEmpty) {
      improved = improved[0].toUpperCase() + improved.substring(1);
    }

    // Ensure ends with period if it's a sentence
    if (improved.isNotEmpty &&
        !improved.endsWith('.') &&
        !improved.endsWith('!') &&
        !improved.endsWith('?')) {
      improved += '.';
    }

    return improved;
  }

  String _basicSummaryGeneration(List<String> experiences, List<String> skills) {
    // Basic summary template
    final experienceCount = experiences.length;
    final topSkills = skills.take(5).join(', ');

    return 'Professional with $experienceCount years of experience. '
        'Skilled in $topSkills. '
        'Proven track record of delivering results and driving business growth.';
  }

  List<String> _basicSkillsSuggestion(String jobTitle) {
    // Basic skill suggestions based on common job titles
    final lowerTitle = jobTitle.toLowerCase();

    if (lowerTitle.contains('software') || lowerTitle.contains('developer')) {
      return [
        'Problem Solving',
        'Git',
        'Agile Methodologies',
        'Testing',
        'Code Review',
      ];
    } else if (lowerTitle.contains('designer')) {
      return [
        'Adobe Creative Suite',
        'Figma',
        'UI/UX Design',
        'Prototyping',
        'User Research',
      ];
    } else if (lowerTitle.contains('manager')) {
      return [
        'Leadership',
        'Project Management',
        'Team Building',
        'Strategic Planning',
        'Communication',
      ];
    }

    return [
      'Communication',
      'Problem Solving',
      'Teamwork',
      'Time Management',
      'Adaptability',
    ];
  }

  String _basicGrammarFix(String text) {
    // Very basic grammar fixes
    var fixed = text.trim();

    // Ensure proper capitalization after periods
    fixed = fixed.replaceAllMapped(
      RegExp(r'\.\s+([a-z])'),
      (match) => '. ${match.group(1)!.toUpperCase()}',
    );

    return fixed;
  }

  String _basicProfessionalImprovement(String text) {
    // Make text more professional by removing casual language
    var professional = text;

    // Replace casual words with professional equivalents
    final replacements = {
      'got': 'achieved',
      'did': 'performed',
      'made': 'developed',
      'helped': 'assisted',
      'worked on': 'contributed to',
      'really': '',
      'very': '',
      'quite': '',
    };

    replacements.forEach((casual, formal) {
      professional = professional.replaceAll(casual, formal);
    });

    return professional.trim();
  }
}
