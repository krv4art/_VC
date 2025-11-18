import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/background_result.dart';
import '../models/background_style.dart';
import '../services/background_processing_service.dart';
import '../services/image_compression_service.dart';
import '../services/local_data_service.dart';
import '../services/gemini_service.dart';

/// Provider for managing background processing state
class BackgroundProvider with ChangeNotifier {
  final BackgroundProcessingService _processingService;
  final GeminiService _geminiService;
  final Uuid _uuid = const Uuid();

  BackgroundResult? _currentResult;
  List<BackgroundResult> _history = [];
  bool _isProcessing = false;
  String? _errorMessage;
  double _progress = 0.0;

  BackgroundProvider(this._processingService, this._geminiService) {
    _loadHistory();
  }

  // Getters
  BackgroundResult? get currentResult => _currentResult;
  List<BackgroundResult> get history => _history;
  bool get isProcessing => _isProcessing;
  String? get errorMessage => _errorMessage;
  double get progress => _progress;

  /// Load history from database
  Future<void> _loadHistory() async {
    try {
      _history = await LocalDataService.getAllResults();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading history: $e');
    }
  }

  /// Process image with background removal and replacement
  Future<void> processImage({
    required String imagePath,
    BackgroundStyle? style,
    String? customPrompt,
  }) async {
    _isProcessing = true;
    _errorMessage = null;
    _progress = 0.0;
    notifyListeners();

    try {
      // Create initial result
      final result = BackgroundResult(
        id: _uuid.v4(),
        originalImagePath: imagePath,
        timestamp: DateTime.now(),
        styleId: style?.id,
        styleName: style?.name,
        styleDescription: style?.description,
        userPrompt: customPrompt,
        status: ProcessingStatus.pending,
      );

      _currentResult = result;
      await LocalDataService.saveResult(result);
      notifyListeners();

      // Step 1: Compress image
      _progress = 0.1;
      notifyListeners();

      final compressedPath = await ImageCompressionService.compressForProcessing(imagePath);

      // Step 2: Remove background
      _progress = 0.3;
      _currentResult = result.copyWith(status: ProcessingStatus.removingBackground);
      notifyListeners();

      final removedBgPath = await _processingService.removeBackground(compressedPath);

      _currentResult = result.copyWith(removedBgImagePath: removedBgPath);
      await LocalDataService.updateResult(_currentResult!);

      // Step 3: Generate background prompt if using custom prompt
      _progress = 0.5;
      notifyListeners();

      String? finalPrompt;
      if (customPrompt != null && customPrompt.isNotEmpty) {
        finalPrompt = await _geminiService.generateBackgroundPrompt(customPrompt);
      } else if (style != null) {
        finalPrompt = style.prompt;
      }

      // Step 4: Generate new background
      _progress = 0.7;
      _currentResult = result.copyWith(status: ProcessingStatus.generatingBackground);
      notifyListeners();

      final processedPath = await _processingService.generateBackground(
        removedBgImagePath: removedBgPath,
        prompt: finalPrompt,
      );

      // Step 5: Complete
      _progress = 1.0;
      _currentResult = result.copyWith(
        processedImagePath: processedPath,
        status: ProcessingStatus.completed,
      );
      await LocalDataService.updateResult(_currentResult!);

      _history.insert(0, _currentResult!);
      _isProcessing = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error processing image: $e');
      _errorMessage = e.toString();
      _isProcessing = false;

      if (_currentResult != null) {
        _currentResult = _currentResult!.copyWith(
          status: ProcessingStatus.error,
          errorMessage: e.toString(),
        );
        await LocalDataService.updateResult(_currentResult!);
      }

      notifyListeners();
    }
  }

  /// Toggle favorite status
  Future<void> toggleFavorite(String resultId) async {
    try {
      final result = await LocalDataService.getResultById(resultId);
      if (result != null) {
        final updated = result.copyWith(isFavorite: !result.isFavorite);
        await LocalDataService.updateResult(updated);

        // Update in history
        final index = _history.indexWhere((r) => r.id == resultId);
        if (index != -1) {
          _history[index] = updated;
        }

        // Update current result if it's the same
        if (_currentResult?.id == resultId) {
          _currentResult = updated;
        }

        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error toggling favorite: $e');
    }
  }

  /// Delete result
  Future<void> deleteResult(String resultId) async {
    try {
      await LocalDataService.deleteResult(resultId);
      _history.removeWhere((r) => r.id == resultId);

      if (_currentResult?.id == resultId) {
        _currentResult = null;
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting result: $e');
    }
  }

  /// Set current result
  void setCurrentResult(BackgroundResult result) {
    _currentResult = result;
    notifyListeners();
  }

  /// Clear current result
  void clearCurrentResult() {
    _currentResult = null;
    _errorMessage = null;
    _progress = 0.0;
    notifyListeners();
  }

  /// Refresh history
  Future<void> refreshHistory() async {
    await _loadHistory();
  }
}
