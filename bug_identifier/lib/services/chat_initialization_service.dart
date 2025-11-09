import 'package:flutter/foundation.dart';
import '../models/chat_message.dart';
import '../models/scan_result.dart';
import '../models/analysis_result.dart';
import 'local_data_service.dart';

/// Service for initializing and loading chat data
class ChatInitializationService {
  /// Load all messages for a dialogue
  static Future<List<ChatMessage>> loadMessagesForDialogue(int dialogueId) async {
    debugPrint(
      '=== CHAT DEBUG: Loading messages for dialogue ID: $dialogueId ===',
    );
    try {
      final messagesData =
          await LocalDataService.instance.getMessagesForDialogue(dialogueId);
      debugPrint('=== CHAT DEBUG: Loaded ${messagesData.length} messages ===');
      return messagesData;
    } catch (e) {
      debugPrint('=== CHAT DEBUG: Error loading messages: $e ===');
      return [];
    }
  }

  /// Load scan result linked to a dialogue
  static Future<ScanResult?> loadScanResultForDialogue(int dialogueId) async {
    debugPrint('=== SCAN CARD DEBUG: Loading scan result for dialogue $dialogueId ===');

    if (dialogueId <= 0) {
      debugPrint('=== SCAN CARD DEBUG: Invalid dialogue ID, returning null ===');
      return null;
    }

    try {
      debugPrint(
        '=== SCAN CARD DEBUG: Calling getScanResultForDialogue($dialogueId) ===',
      );
      final scanResult = await LocalDataService.instance
          .getScanResultForDialogue(dialogueId);

      debugPrint(
        '=== SCAN CARD DEBUG: scanResult = ${scanResult != null ? "found" : "null"} ===',
      );

      return scanResult;
    } catch (e) {
      debugPrint(
        '=== SCAN CARD DEBUG: Error loading linked scan result: $e ===',
      );
      return null;
    }
  }

  /// Load scan result directly by ID
  static Future<ScanResult?> loadScanResultById(int scanResultId) async {
    debugPrint(
      '=== SCAN CARD DEBUG: Loading scan result by ID: $scanResultId ===',
    );

    try {
      final db = await LocalDataService.instance.database;
      final scanResults = await db.query(
        'scan_results',
        where: 'id = ?',
        whereArgs: [scanResultId],
      );

      if (scanResults.isNotEmpty) {
        debugPrint('=== SCAN CARD DEBUG: Scan result found by ID ===');
        return ScanResult.fromMap(scanResults.first);
      } else {
        debugPrint(
          '=== SCAN CARD DEBUG: No scan result found with ID: $scanResultId ===',
        );
        return null;
      }
    } catch (e) {
      debugPrint(
        '=== SCAN CARD DEBUG: Error loading scan result by ID: $e ===',
      );
      return null;
    }
  }

  /// Process scan result and extract analysis data
  static AnalysisResult? processScanResult(ScanResult scanResult) {
    debugPrint('=== SCAN CARD DEBUG: Processing scan result... ===');

    try {
      final analysisData = scanResult.analysisResult;

      final ingredients = List<String>.from(analysisData['ingredients'] ?? []);

      // Process high risk ingredients
      final highRiskData = analysisData['high_risk_ingredients'];
      final highRisk = highRiskData != null
          ? (highRiskData is List
                ? highRiskData
                      .map((item) => IngredientInfo.fromDynamic(item))
                      .toList()
                : <IngredientInfo>[])
          : <IngredientInfo>[];

      // Process moderate risk ingredients
      final moderateRiskData = analysisData['moderate_risk_ingredients'];
      final moderateRisk = moderateRiskData != null
          ? (moderateRiskData is List
                ? moderateRiskData
                      .map((item) => IngredientInfo.fromDynamic(item))
                      .toList()
                : <IngredientInfo>[])
          : <IngredientInfo>[];

      // Process low risk ingredients
      final lowRiskData = analysisData['low_risk_ingredients'];
      final lowRisk = lowRiskData != null
          ? (lowRiskData is List
                ? lowRiskData
                      .map((item) => IngredientInfo.fromDynamic(item))
                      .toList()
                : <IngredientInfo>[])
          : <IngredientInfo>[];

      final warnings =
          List<String>.from(analysisData['personalized_warnings'] ?? []);

      final analysisResult = AnalysisResult.fromJson({
        ...analysisData,
        'ingredients': ingredients,
        'high_risk_ingredients': highRisk,
        'moderate_risk_ingredients': moderateRisk,
        'low_risk_ingredients': lowRisk,
        'personalized_warnings': warnings,
      });

      debugPrint(
        '=== SCAN CARD DEBUG: Analysis result created successfully ===',
      );
      debugPrint(
        '=== SCAN CARD DEBUG: Ingredients count: ${analysisResult.ingredients.length} ===',
      );
      debugPrint(
        '=== SCAN CARD DEBUG: Safety score: ${analysisResult.overallSafetyScore} ===',
      );

      return analysisResult;
    } catch (e) {
      debugPrint('=== SCAN CARD DEBUG: Error processing scan result: $e ===');
      return null;
    }
  }

  /// Create a new dialogue in the database
  static Future<int> createDialogue(String title, {int? scanResultId}) async {
    debugPrint('=== CHAT DEBUG: Creating new dialogue with title: "$title" ===');
    debugPrint('=== CHAT DEBUG: scanResultId to pass: $scanResultId ===');

    try {
      final newDialogueId = await LocalDataService.instance.createDialogue(
        title,
        scanResultId: scanResultId,
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
