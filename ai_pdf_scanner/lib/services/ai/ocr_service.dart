import 'package:flutter/foundation.dart';
import 'gemini_service.dart';

/// OCR service
/// Handles Optical Character Recognition using AI
/// Wrapper around GeminiService for OCR-specific operations
class OCRService {
  static final OCRService _instance = OCRService._internal();
  factory OCRService() => _instance;
  OCRService._internal();

  final _geminiService = GeminiService();

  /// Extract text from image
  Future<OCRResult> extractText(String imagePath) async {
    try {
      final startTime = DateTime.now();

      // Extract text using Gemini
      final text = await _geminiService.extractText(imagePath);

      final endTime = DateTime.now();
      final processingTime = endTime.difference(startTime);

      // Calculate confidence based on text length and quality
      final confidence = _calculateConfidence(text);

      debugPrint('✅ OCR completed in ${processingTime.inMilliseconds}ms');
      debugPrint('   Text length: ${text.length} characters');
      debugPrint('   Confidence: ${(confidence * 100).toStringAsFixed(1)}%');

      return OCRResult(
        text: text,
        confidence: confidence,
        processingTime: processingTime,
        language: _detectLanguage(text),
      );
    } catch (e) {
      debugPrint('❌ OCR failed: $e');
      return OCRResult(
        text: '',
        confidence: 0.0,
        processingTime: Duration.zero,
        language: 'unknown',
        error: e.toString(),
      );
    }
  }

  /// Extract structured data from document
  Future<Map<String, dynamic>> extractStructuredData(String imagePath) async {
    try {
      final data = await _geminiService.extractKeyInformation(imagePath);
      debugPrint('✅ Structured data extracted');
      return data;
    } catch (e) {
      debugPrint('❌ Structured data extraction failed: $e');
      return {};
    }
  }

  /// Extract text with layout preservation
  Future<String> extractTextWithLayout(String imagePath) async {
    try {
      final result = await _geminiService.analyzeImage(
        imagePath: imagePath,
        prompt: '''Extract all text from this document while preserving the original layout.
Maintain spacing, indentation, and line breaks as they appear in the document.
Return only the extracted text with preserved formatting.''',
      );

      return result['text'] ?? '';
    } catch (e) {
      debugPrint('❌ Layout-preserved text extraction failed: $e');
      return '';
    }
  }

  /// Extract tables from document
  Future<List<List<String>>> extractTables(String imagePath) async {
    try {
      final result = await _geminiService.analyzeImage(
        imagePath: imagePath,
        prompt: '''Extract all tables from this document.
Return them as a JSON array of arrays (rows and columns).
Example: [["Header1", "Header2"], ["Cell1", "Cell2"]]''',
      );

      final tables = result['tables'] as List?;
      if (tables == null) return [];

      return tables.map((table) {
        final rows = table as List;
        return rows.map((row) {
          final cells = row as List;
          return cells.map((cell) => cell.toString()).toList();
        }).toList();
      }).toList();
    } catch (e) {
      debugPrint('❌ Table extraction failed: $e');
      return [];
    }
  }

  /// Search for specific text pattern
  Future<List<String>> searchPattern(String imagePath, String pattern) async {
    try {
      final text = await extractText(imagePath);
      final regex = RegExp(pattern, multiLine: true);
      final matches = regex.allMatches(text.text);
      return matches.map((m) => m.group(0) ?? '').toList();
    } catch (e) {
      debugPrint('❌ Pattern search failed: $e');
      return [];
    }
  }

  /// Calculate confidence score based on text quality
  double _calculateConfidence(String text) {
    if (text.isEmpty) return 0.0;

    double confidence = 0.5; // Base confidence

    // Increase confidence for longer text
    if (text.length > 100) confidence += 0.1;
    if (text.length > 500) confidence += 0.1;

    // Increase confidence for proper capitalization
    final hasProperCase = RegExp(r'[A-Z][a-z]+').hasMatch(text);
    if (hasProperCase) confidence += 0.1;

    // Increase confidence for punctuation
    final hasPunctuation = RegExp(r'[.,;:!?]').hasMatch(text);
    if (hasPunctuation) confidence += 0.1;

    // Decrease confidence for too many special characters
    final specialCharCount = RegExp(r'[^a-zA-Z0-9\s.,;:!?-]').allMatches(text).length;
    if (specialCharCount > text.length * 0.1) {
      confidence -= 0.2;
    }

    return confidence.clamp(0.0, 1.0);
  }

  /// Detect language (simple heuristic)
  String _detectLanguage(String text) {
    if (text.isEmpty) return 'unknown';

    // Check for Cyrillic characters (Russian)
    if (RegExp(r'[А-Яа-яЁё]').hasMatch(text)) {
      return 'ru';
    }

    // Default to English
    return 'en';
  }
}

/// OCR result with metadata
class OCRResult {
  final String text;
  final double confidence;
  final Duration processingTime;
  final String language;
  final String? error;

  OCRResult({
    required this.text,
    required this.confidence,
    required this.processingTime,
    required this.language,
    this.error,
  });

  bool get isSuccess => error == null && text.isNotEmpty;

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'confidence': confidence,
      'processing_time_ms': processingTime.inMilliseconds,
      'language': language,
      'error': error,
    };
  }
}
