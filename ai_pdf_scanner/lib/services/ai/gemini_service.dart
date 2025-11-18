import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../config/api_config.dart';

/// Gemini AI service
/// Handles AI operations via Supabase Edge Functions (secure proxy to Gemini API)
/// Similar to ACS's gemini_service.dart pattern
class GeminiService {
  static final GeminiService _instance = GeminiService._internal();
  factory GeminiService() => _instance;
  GeminiService._internal();

  final _supabase = Supabase.instance.client;

  /// Analyze image with AI
  /// Returns structured analysis based on prompt
  Future<Map<String, dynamic>> analyzeImage({
    required String imagePath,
    required String prompt,
    double temperature = 0.4,
  }) async {
    try {
      // Read image file
      final imageBytes = await File(imagePath).readAsBytes();
      final base64Image = base64Encode(imageBytes);

      // Call Supabase Edge Function
      final response = await _supabase.functions.invoke(
        'ai-process',
        body: {
          'type': 'analyze_image',
          'image': base64Image,
          'prompt': prompt,
          'temperature': temperature,
        },
      );

      if (response.status != 200) {
        throw Exception('AI analysis failed: ${response.status}');
      }

      final result = response.data as Map<String, dynamic>;
      debugPrint('✅ AI analysis completed');
      return result;
    } catch (e) {
      debugPrint('❌ AI analysis failed: $e');
      rethrow;
    }
  }

  /// OCR - Extract text from image
  Future<String> extractText(String imagePath) async {
    try {
      final result = await analyzeImage(
        imagePath: imagePath,
        prompt: '''Extract all visible text from this document image.
Return only the extracted text, preserving the original formatting and structure.
If there is no text, return an empty string.''',
      );

      return result['text'] ?? '';
    } catch (e) {
      debugPrint('❌ Text extraction failed: $e');
      return '';
    }
  }

  /// Classify document type
  Future<DocumentClassification> classifyDocument(String imagePath) async {
    try {
      final result = await analyzeImage(
        imagePath: imagePath,
        prompt: '''Analyze this document image and classify it.
Return a JSON with the following structure:
{
  "type": "invoice|receipt|id_card|passport|letter|contract|form|other",
  "confidence": 0.0-1.0,
  "description": "brief description"
}''',
      );

      return DocumentClassification.fromJson(result);
    } catch (e) {
      debugPrint('❌ Document classification failed: $e');
      return DocumentClassification(
        type: 'other',
        confidence: 0.0,
        description: 'Classification failed',
      );
    }
  }

  /// Extract key information from document
  Future<Map<String, dynamic>> extractKeyInformation(String imagePath) async {
    try {
      final result = await analyzeImage(
        imagePath: imagePath,
        prompt: '''Analyze this document and extract key information.
Look for: dates, amounts, names, addresses, phone numbers, emails, etc.
Return a JSON with extracted information.''',
      );

      return result['extracted_info'] ?? {};
    } catch (e) {
      debugPrint('❌ Key information extraction failed: $e');
      return {};
    }
  }

  /// Generate document summary
  Future<String> generateSummary(String imagePath) async {
    try {
      final result = await analyzeImage(
        imagePath: imagePath,
        prompt: '''Analyze this document and provide a concise summary.
Include the main purpose, key points, and important details.
Keep the summary under 200 words.''',
      );

      return result['summary'] ?? '';
    } catch (e) {
      debugPrint('❌ Summary generation failed: $e');
      return '';
    }
  }

  /// Detect sensitive information (for privacy warning)
  Future<List<String>> detectSensitiveInfo(String imagePath) async {
    try {
      final result = await analyzeImage(
        imagePath: imagePath,
        prompt: '''Analyze this document for sensitive information.
Identify any: SSN, credit card numbers, passwords, personal IDs, medical info, etc.
Return a JSON array of detected sensitive information types.
Example: ["SSN", "Credit Card", "Medical Info"]''',
      );

      final sensitiveInfo = result['sensitive_info'] as List?;
      return sensitiveInfo?.cast<String>() ?? [];
    } catch (e) {
      debugPrint('❌ Sensitive info detection failed: $e');
      return [];
    }
  }

  /// Generate smart file name based on content
  Future<String> generateFileName(String imagePath) async {
    try {
      final result = await analyzeImage(
        imagePath: imagePath,
        prompt: '''Analyze this document and suggest a descriptive file name.
The file name should be concise, descriptive, and use lowercase with underscores.
Include document type and key identifier (date, name, etc.).
Return only the file name without extension.
Example: "invoice_acme_corp_2024_01_15"''',
      );

      return result['file_name'] ?? 'document_${DateTime.now().millisecondsSinceEpoch}';
    } catch (e) {
      debugPrint('❌ File name generation failed: $e');
      return 'document_${DateTime.now().millisecondsSinceEpoch}';
    }
  }

  /// Translate text
  Future<String> translateText(String text, String targetLanguage) async {
    try {
      final response = await _supabase.functions.invoke(
        'ai-process',
        body: {
          'type': 'translate',
          'text': text,
          'target_language': targetLanguage,
        },
      );

      if (response.status != 200) {
        throw Exception('Translation failed: ${response.status}');
      }

      final result = response.data as Map<String, dynamic>;
      return result['translated_text'] ?? text;
    } catch (e) {
      debugPrint('❌ Translation failed: $e');
      return text;
    }
  }
}

/// Document classification result
class DocumentClassification {
  final String type;
  final double confidence;
  final String description;

  DocumentClassification({
    required this.type,
    required this.confidence,
    required this.description,
  });

  factory DocumentClassification.fromJson(Map<String, dynamic> json) {
    return DocumentClassification(
      type: json['type'] ?? 'other',
      confidence: (json['confidence'] ?? 0.0).toDouble(),
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'confidence': confidence,
      'description': description,
    };
  }
}
