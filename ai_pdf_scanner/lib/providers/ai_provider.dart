import 'package:flutter/foundation.dart';
import '../services/ai/gemini_service.dart';
import '../services/ai/ocr_service.dart';
import '../exceptions/ai_exception.dart';

/// Provider for managing AI processing state
class AIProvider with ChangeNotifier {
  final GeminiService _geminiService = GeminiService();
  final OCRService _ocrService = OCRService();

  // Processing state
  bool _isProcessing = false;
  bool get isProcessing => _isProcessing;

  // Current operation
  String? _currentOperation;
  String? get currentOperation => _currentOperation;

  // Progress (0.0 to 1.0)
  double? _progress;
  double? get progress => _progress;

  // Last result
  Map<String, dynamic>? _lastResult;
  Map<String, dynamic>? get lastResult => _lastResult;

  // Error message
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // AI features enabled
  bool _ocrEnabled = true;
  bool get ocrEnabled => _ocrEnabled;

  bool _classificationEnabled = true;
  bool get classificationEnabled => _classificationEnabled;

  bool _autoEnhanceEnabled = true;
  bool get autoEnhanceEnabled => _autoEnhanceEnabled;

  /// Perform OCR on image
  Future<String?> performOCR(String imagePath) async {
    _isProcessing = true;
    _currentOperation = 'Extracting text...';
    _errorMessage = null;
    _progress = null;
    notifyListeners();

    try {
      final ocrResult = await _ocrService.extractText(imagePath);

      _lastResult = ocrResult.toJson();
      _isProcessing = false;
      _currentOperation = null;
      notifyListeners();

      return ocrResult.text;
    } catch (e) {
      _errorMessage = 'OCR failed';
      _isProcessing = false;
      _currentOperation = null;
      notifyListeners();

      throw OCRException(
        'Failed to extract text from image',
        imageId: imagePath,
        originalError: e,
      );
    }
  }

  /// Classify document type
  Future<Map<String, dynamic>?> classifyDocument(String imagePath) async {
    _isProcessing = true;
    _currentOperation = 'Classifying document...';
    _errorMessage = null;
    _progress = null;
    notifyListeners();

    try {
      final classification = await _geminiService.classifyDocument(imagePath);

      final result = classification.toJson();
      _lastResult = result;
      _isProcessing = false;
      _currentOperation = null;
      notifyListeners();

      return result;
    } catch (e) {
      _errorMessage = 'Classification failed';
      _isProcessing = false;
      _currentOperation = null;
      notifyListeners();

      throw AIClassificationException(
        'Failed to classify document',
        originalError: e,
      );
    }
  }

  /// Extract key information from document
  Future<Map<String, dynamic>?> extractKeyInfo(String imagePath) async {
    _isProcessing = true;
    _currentOperation = 'Extracting information...';
    _errorMessage = null;
    _progress = null;
    notifyListeners();

    try {
      final result = await _geminiService.extractKeyInformation(imagePath);

      _lastResult = result;
      _isProcessing = false;
      _currentOperation = null;
      notifyListeners();

      return result;
    } catch (e) {
      _errorMessage = 'Information extraction failed';
      _isProcessing = false;
      _currentOperation = null;
      notifyListeners();

      throw AIException(
        'Failed to extract key information',
        originalError: e,
      );
    }
  }

  /// Summarize document
  Future<String?> summarizeDocument(String imagePath) async {
    _isProcessing = true;
    _currentOperation = 'Summarizing document...';
    _errorMessage = null;
    _progress = null;
    notifyListeners();

    try {
      final summary = await _geminiService.generateSummary(imagePath);

      _lastResult = {'summary': summary};
      _isProcessing = false;
      _currentOperation = null;
      notifyListeners();

      return summary;
    } catch (e) {
      _errorMessage = 'Summarization failed';
      _isProcessing = false;
      _currentOperation = null;
      notifyListeners();

      throw AIException(
        'Failed to summarize document',
        originalError: e,
      );
    }
  }

  /// Detect sensitive information
  Future<Map<String, dynamic>?> detectSensitiveInfo(String imagePath) async {
    _isProcessing = true;
    _currentOperation = 'Scanning for sensitive information...';
    _errorMessage = null;
    _progress = null;
    notifyListeners();

    try {
      final sensitiveInfo = await _geminiService.detectSensitiveInfo(imagePath);

      final result = {'sensitive_info': sensitiveInfo};
      _lastResult = result;
      _isProcessing = false;
      _currentOperation = null;
      notifyListeners();

      return result;
    } catch (e) {
      _errorMessage = 'Privacy scan failed';
      _isProcessing = false;
      _currentOperation = null;
      notifyListeners();

      throw AIException(
        'Failed to detect sensitive information',
        originalError: e,
      );
    }
  }

  /// Suggest filename based on content
  Future<String?> suggestFilename(String imagePath) async {
    _isProcessing = true;
    _currentOperation = 'Suggesting filename...';
    _errorMessage = null;
    _progress = null;
    notifyListeners();

    try {
      final filename = await _geminiService.generateFileName(imagePath);

      _lastResult = {'filename': filename};
      _isProcessing = false;
      _currentOperation = null;
      notifyListeners();

      return filename;
    } catch (e) {
      _errorMessage = 'Filename suggestion failed';
      _isProcessing = false;
      _currentOperation = null;
      notifyListeners();

      throw AIException(
        'Failed to suggest filename',
        originalError: e,
      );
    }
  }

  /// Assess document quality
  Future<Map<String, dynamic>?> assessQuality(String imagePath) async {
    _isProcessing = true;
    _currentOperation = 'Assessing document quality...';
    _errorMessage = null;
    _progress = null;
    notifyListeners();

    try {
      final result = await _geminiService.analyzeImage(
        imagePath,
        'Assess the quality of this document scan',
      );

      _lastResult = result;
      _isProcessing = false;
      _currentOperation = null;
      notifyListeners();

      return result;
    } catch (e) {
      _errorMessage = 'Quality assessment failed';
      _isProcessing = false;
      _currentOperation = null;
      notifyListeners();

      throw AIException(
        'Failed to assess document quality',
        originalError: e,
      );
    }
  }

  /// Toggle OCR
  void toggleOCR(bool enabled) {
    _ocrEnabled = enabled;
    notifyListeners();
  }

  /// Toggle classification
  void toggleClassification(bool enabled) {
    _classificationEnabled = enabled;
    notifyListeners();
  }

  /// Toggle auto enhance
  void toggleAutoEnhance(bool enabled) {
    _autoEnhanceEnabled = enabled;
    notifyListeners();
  }

  /// Update progress
  void updateProgress(double value) {
    _progress = value.clamp(0.0, 1.0);
    notifyListeners();
  }

  /// Clear last result
  void clearLastResult() {
    _lastResult = null;
    _errorMessage = null;
    notifyListeners();
  }

  /// Reset provider
  void reset() {
    _isProcessing = false;
    _currentOperation = null;
    _progress = null;
    _lastResult = null;
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    reset();
    super.dispose();
  }
}
