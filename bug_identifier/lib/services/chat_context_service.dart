import '../providers/user_state.dart';
import '../models/analysis_result.dart';

class ChatContextService {
  static String generateUserProfileContext(UserState userState) {
    final parts = <String>[];

    if (userState.name != null && userState.name!.isNotEmpty) {
      parts.add('Name: ${userState.name}');
    }

    if (userState.ageRange != null && userState.ageRange!.isNotEmpty) {
      parts.add('Age range: ${userState.ageRange}');
    }

    if (userState.skinType != null && userState.skinType!.isNotEmpty) {
      parts.add('Skin type: ${userState.skinType}');
    }

    if (userState.allergies.isNotEmpty) {
      parts.add('Allergies: ${userState.allergies.join(', ')}');
    }

    if (parts.isEmpty) {
      return '';
    }

    return 'User profile information:\n${parts.join('\n')}\n\nPlease take this information into account when providing cosmetic and skincare advice.';
  }

  static String generateScanContext(Map<String, dynamic> analysisData) {
    final parts = <String>[];

    if (analysisData.containsKey('ingredients')) {
      final ingredients = analysisData['ingredients'] as List<dynamic>;
      if (ingredients.isNotEmpty) {
        parts.add('Ingredients analyzed: ${ingredients.join(', ')}');
      }
    }

    if (analysisData.containsKey('safetyScore')) {
      parts.add('Safety score: ${analysisData['safetyScore']}');
    }

    if (analysisData.containsKey('warnings')) {
      final warnings = analysisData['warnings'] as List<dynamic>;
      if (warnings.isNotEmpty) {
        parts.add('Warnings: ${warnings.join(', ')}');
      }
    }

    if (parts.isEmpty) {
      return '';
    }

    return 'Based on the recent cosmetic product scan:\n${parts.join('\n')}\n\nPlease provide advice related to this analysis.';
  }

  static String generateFullContext(UserState userState, AnalysisResult analysisResult) {
    final parts = <String>[];

    // User profile
    final profileContext = generateUserProfileContext(userState);
    if (profileContext.isNotEmpty) {
      parts.add(profileContext);
    }

    // Analysis results
    if (analysisResult.ingredients.isNotEmpty) {
      parts.add('\nRecent scan analysis:');
      parts.add('Ingredients: ${analysisResult.ingredients.join(', ')}');
      parts.add('Safety score: ${analysisResult.overallSafetyScore}/10');

      if (analysisResult.personalizedWarnings.isNotEmpty) {
        parts.add('Warnings: ${analysisResult.personalizedWarnings.join('; ')}');
      }
    }

    return parts.join('\n');
  }
}
