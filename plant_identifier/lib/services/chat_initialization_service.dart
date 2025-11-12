import 'package:flutter/foundation.dart';
import '../models/chat_message.dart';
import '../models/plant_result.dart';
import 'database_service.dart';

/// Service for initializing and loading chat data
class ChatInitializationService {
  /// Load all messages for a dialogue
  static Future<List<ChatMessage>> loadMessagesForDialogue(int dialogueId) async {
    debugPrint(
      '=== CHAT DEBUG: Loading messages for dialogue ID: $dialogueId ===',
    );
    try {
      final messagesData =
          await DatabaseService().getMessagesForDialogue(dialogueId);
      debugPrint('=== CHAT DEBUG: Loaded ${messagesData.length} messages ===');
      return messagesData;
    } catch (e) {
      debugPrint('=== CHAT DEBUG: Error loading messages: $e ===');
      return [];
    }
  }

  /// Load plant result linked to a dialogue
  static Future<PlantResult?> loadPlantResultForDialogue(int dialogueId) async {
    debugPrint('=== PLANT CARD DEBUG: Loading plant result for dialogue $dialogueId ===');

    if (dialogueId <= 0) {
      debugPrint('=== PLANT CARD DEBUG: Invalid dialogue ID, returning null ===');
      return null;
    }

    try {
      debugPrint(
        '=== PLANT CARD DEBUG: Calling getPlantResultForDialogue($dialogueId) ===',
      );
      final plantResult = await DatabaseService()
          .getPlantResultForDialogue(dialogueId);

      debugPrint(
        '=== PLANT CARD DEBUG: plantResult = ${plantResult != null ? "found" : "null"} ===',
      );

      return plantResult;
    } catch (e) {
      debugPrint(
        '=== PLANT CARD DEBUG: Error loading linked plant result: $e ===',
      );
      return null;
    }
  }

  /// Load plant result directly by ID
  static Future<PlantResult?> loadPlantResultById(String plantResultId) async {
    debugPrint(
      '=== PLANT CARD DEBUG: Loading plant result by ID: $plantResultId ===',
    );

    try {
      final db = await DatabaseService().database;
      final plantResults = await db.query(
        'plant_results',
        where: 'id = ?',
        whereArgs: [plantResultId],
      );

      if (plantResults.isNotEmpty) {
        debugPrint('=== PLANT CARD DEBUG: Plant result found by ID ===');
        // Parse the plant result manually
        final map = plantResults.first;
        return PlantResult.fromJson({
          'id': map['id'],
          'plantName': map['plantName'],
          'scientificName': map['scientificName'],
          'description': map['description'],
          'type': map['type'],
          'imageUrl': map['imageUrl'],
          'identifiedAt': map['identifiedAt'],
          'careInfo': map['careInfo'],
          'commonNames': map['commonNames'],
          'family': map['family'],
          'origin': map['origin'],
          'isToxic': map['isToxic'] == 1,
          'isEdible': map['isEdible'] == 1,
          'usesAndBenefits': map['usesAndBenefits'],
          'confidence': map['confidence'],
        });
      } else {
        debugPrint(
          '=== PLANT CARD DEBUG: No plant result found with ID: $plantResultId ===',
        );
        return null;
      }
    } catch (e) {
      debugPrint(
        '=== PLANT CARD DEBUG: Error loading plant result by ID: $e ===',
      );
      return null;
    }
  }

  /// Process plant result for chat context
  static PlantResult? processPlantResult(PlantResult plantResult) {
    debugPrint('=== PLANT CARD DEBUG: Processing plant result... ===');

    try {
      debugPrint(
        '=== PLANT CARD DEBUG: Plant result processed successfully ===',
      );
      debugPrint(
        '=== PLANT CARD DEBUG: Plant name: ${plantResult.plantName} ===',
      );
      debugPrint(
        '=== PLANT CARD DEBUG: Confidence: ${plantResult.confidence} ===',
      );

      return plantResult;
    } catch (e) {
      debugPrint('=== PLANT CARD DEBUG: Error processing plant result: $e ===');
      return null;
    }
  }

  /// Create a new dialogue in the database
  static Future<int> createDialogue(String title, {String? plantResultId}) async {
    debugPrint('=== CHAT DEBUG: Creating new dialogue with title: "$title" ===');
    debugPrint('=== CHAT DEBUG: plantResultId to pass: $plantResultId ===');

    try {
      final newDialogueId = await DatabaseService().createDialogue(
        title,
        identificationResultId: plantResultId,
      );
      debugPrint('=== CHAT DEBUG: Created dialogue with ID: $newDialogueId ===');
      return newDialogueId;
    } catch (e) {
      debugPrint('Error creating dialogue: $e');
      // Use temporary ID on error
      final tempId = DateTime.now().millisecondsSinceEpoch;
      debugPrint('=== CHAT DEBUG: Using temporary dialogue ID: $tempId ===');
      return tempId;
    }
  }
}
