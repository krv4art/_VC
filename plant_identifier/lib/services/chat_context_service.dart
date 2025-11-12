import '../models/user_preferences.dart';
import '../models/plant_result.dart';

class ChatContextService {
  static String generateUserProfileContext(UserPreferences userPreferences) {
    final parts = <String>[];

    if (userPreferences.location != null && userPreferences.location!.isNotEmpty) {
      parts.add('Location: ${userPreferences.location}');
    }

    if (userPreferences.climate != null && userPreferences.climate!.isNotEmpty) {
      parts.add('Climate: ${userPreferences.climate}');
    }

    if (userPreferences.gardenType != null && userPreferences.gardenType!.isNotEmpty) {
      parts.add('Garden type: ${userPreferences.gardenType}');
    }

    parts.add('Experience level: ${userPreferences.experience.toString().split('.').last}');

    if (userPreferences.interests.isNotEmpty) {
      final interestsStr = userPreferences.interests
          .map((i) => i.toString().split('.').last)
          .join(', ');
      parts.add('Interests: $interestsStr');
    }

    if (userPreferences.lowMaintenancePreference) {
      parts.add('Prefers low-maintenance plants');
    }

    if (userPreferences.showToxicWarnings) {
      parts.add('Important: Show warnings for toxic plants');
    }

    if (parts.isEmpty) {
      return '';
    }

    return 'User profile information:\n${parts.join('\n')}\n\nPlease take this information into account when providing plant identification and care advice.';
  }

  static String generatePlantContext(PlantResult plantResult) {
    final parts = <String>[];

    parts.add('Recently identified plant: ${plantResult.plantName} (${plantResult.scientificName})');

    if (plantResult.type != PlantType.unknown) {
      parts.add('Type: ${plantResult.type.toString().split('.').last}');
    }

    if (plantResult.isToxic) {
      parts.add('WARNING: This plant is toxic');
    }

    if (plantResult.isEdible) {
      parts.add('Note: This plant is edible');
    }

    if (plantResult.usesAndBenefits.isNotEmpty) {
      parts.add('Uses: ${plantResult.usesAndBenefits.join(', ')}');
    }

    if (parts.isEmpty) {
      return '';
    }

    return 'Based on the recent plant identification:\n${parts.join('\n')}\n\nPlease provide advice related to this plant.';
  }

  static String generateFullContext(
    UserPreferences userPreferences,
    PlantResult plantResult,
  ) {
    final parts = <String>[];

    // User profile
    final profileContext = generateUserProfileContext(userPreferences);
    if (profileContext.isNotEmpty) {
      parts.add(profileContext);
    }

    // Plant identification results
    parts.add('\nRecent plant identification:');
    parts.add('Plant: ${plantResult.plantName} (${plantResult.scientificName})');
    parts.add('Confidence: ${(plantResult.confidence * 100).toStringAsFixed(1)}%');

    if (plantResult.isToxic) {
      parts.add('⚠️ WARNING: This plant is toxic!');
    }

    if (plantResult.isEdible) {
      parts.add('✓ This plant is edible');
    }

    if (plantResult.careInfo != null) {
      parts.add('\nCare requirements:');
      parts.add('- Watering: ${plantResult.careInfo!.wateringFrequency}');
      parts.add('- Sunlight: ${plantResult.careInfo!.sunlightRequirement}');
      parts.add('- Soil: ${plantResult.careInfo!.soilType}');
    }

    return parts.join('\n');
  }
}
