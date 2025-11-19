import 'package:flutter/foundation.dart';
import '../models/retouch_settings.dart';
import '../models/background_settings.dart';
import '../models/batch_generation_request.dart';
import '../services/ai_retouch_service.dart';
import '../services/background_removal_service.dart';
import '../services/batch_generation_service.dart';
import '../services/image_upscaling_service.dart';
import '../services/ai_image_expansion_service.dart';
import '../services/ai_outfit_change_service.dart';

/// Provider for managing enhanced photo editing features
class EnhancedPhotoProvider with ChangeNotifier {
  final AIRetouchService retouchService;
  final BackgroundRemovalService backgroundService;
  final BatchGenerationService batchService;
  final ImageUpscalingService upscalingService;
  final AIImageExpansionService expansionService;
  final AIOutfitChangeService outfitService;

  EnhancedPhotoProvider({
    required this.retouchService,
    required this.backgroundService,
    required this.batchService,
    required this.upscalingService,
    required this.expansionService,
    required this.outfitService,
  });

  // State
  bool _isProcessing = false;
  double _progress = 0.0;
  String? _currentTask;
  String? _error;
  String? _resultUrl;

  // Current batch job
  BatchGenerationJob? _currentBatchJob;

  // Getters
  bool get isProcessing => _isProcessing;
  double get progress => _progress;
  String? get currentTask => _currentTask;
  String? get error => _error;
  String? get resultUrl => _resultUrl;
  BatchGenerationJob? get currentBatchJob => _currentBatchJob;

  /// Apply AI retouch to photo
  Future<String> applyRetouch({
    required String imagePath,
    required RetouchSettings settings,
  }) async {
    _setProcessing(true, 'Applying AI retouch...');
    _error = null;

    try {
      final result = await retouchService.applyRetouch(
        imagePath: imagePath,
        settings: settings,
      );

      _resultUrl = result;
      _setProcessing(false);
      return result;
    } catch (e) {
      _error = e.toString();
      _setProcessing(false);
      rethrow;
    }
  }

  /// Remove background from photo
  Future<String> removeBackground(String imagePath) async {
    _setProcessing(true, 'Removing background...');
    _error = null;

    try {
      final result = await backgroundService.removeBackground(imagePath);
      _resultUrl = result;
      _setProcessing(false);
      return result;
    } catch (e) {
      _error = e.toString();
      _setProcessing(false);
      rethrow;
    }
  }

  /// Replace background
  Future<String> replaceBackground({
    required String imagePath,
    required BackgroundSettings settings,
  }) async {
    _setProcessing(true, 'Replacing background...');
    _error = null;

    try {
      final result = await backgroundService.replaceBackground(
        imagePath: imagePath,
        settings: settings,
      );

      _resultUrl = result;
      _setProcessing(false);
      return result;
    } catch (e) {
      _error = e.toString();
      _setProcessing(false);
      rethrow;
    }
  }

  /// Upscale image to 4K
  Future<String> upscaleTo4K(String imagePath) async {
    _setProcessing(true, 'Upscaling to 4K...');
    _error = null;

    try {
      final result = await upscalingService.upscaleTo4K(imagePath);
      _resultUrl = result;
      _setProcessing(false);
      return result;
    } catch (e) {
      _error = e.toString();
      _setProcessing(false);
      rethrow;
    }
  }

  /// Expand image to different aspect ratio
  Future<String> expandImage({
    required String imagePath,
    required AspectRatio targetRatio,
  }) async {
    _setProcessing(true, 'Expanding image...');
    _error = null;

    try {
      final result = await expansionService.expandImage(
        imagePath: imagePath,
        targetRatio: targetRatio,
      );

      _resultUrl = result;
      _setProcessing(false);
      return result;
    } catch (e) {
      _error = e.toString();
      _setProcessing(false);
      rethrow;
    }
  }

  /// Change outfit on photo
  Future<String> changeOutfit({
    required String imagePath,
    required OutfitType outfitType,
  }) async {
    _setProcessing(true, 'Changing outfit...');
    _error = null;

    try {
      final result = await outfitService.changeOutfit(
        imagePath: imagePath,
        outfitType: outfitType,
      );

      _resultUrl = result;
      _setProcessing(false);
      return result;
    } catch (e) {
      _error = e.toString();
      _setProcessing(false);
      rethrow;
    }
  }

  /// Start batch generation
  Future<BatchGenerationJob> startBatchGeneration(
    BatchGenerationRequest request,
  ) async {
    _setProcessing(true, 'Starting batch generation...');
    _error = null;

    try {
      final job = await batchService.startBatchGeneration(request);
      _currentBatchJob = job;
      _setProcessing(false);

      // Start monitoring job progress
      _monitorBatchJob(job.id);

      return job;
    } catch (e) {
      _error = e.toString();
      _setProcessing(false);
      rethrow;
    }
  }

  /// Monitor batch job progress
  Future<void> _monitorBatchJob(String jobId) async {
    while (_currentBatchJob != null && !_currentBatchJob!.isComplete) {
      await Future.delayed(const Duration(seconds: 5));

      try {
        final updatedJob = await batchService.getJobStatus(jobId);
        _currentBatchJob = updatedJob;
        _progress = updatedJob.progress;
        _currentTask = 'Processing ${updatedJob.completedPhotos}/${updatedJob.totalPhotos} photos';
        notifyListeners();

        if (updatedJob.isComplete) {
          _setProcessing(false);
          break;
        }
      } catch (e) {
        debugPrint('Error monitoring batch job: $e');
      }
    }
  }

  /// Get batch job status
  Future<BatchGenerationJob> getBatchJobStatus(String jobId) async {
    return await batchService.getJobStatus(jobId);
  }

  /// Cancel current batch job
  Future<void> cancelCurrentBatchJob() async {
    if (_currentBatchJob != null) {
      await batchService.cancelJob(_currentBatchJob!.id);
      _currentBatchJob = null;
      _setProcessing(false);
    }
  }

  /// Clear current result
  void clearResult() {
    _resultUrl = null;
    _error = null;
    notifyListeners();
  }

  /// Reset state
  void reset() {
    _isProcessing = false;
    _progress = 0.0;
    _currentTask = null;
    _error = null;
    _resultUrl = null;
    _currentBatchJob = null;
    notifyListeners();
  }

  void _setProcessing(bool processing, [String? task]) {
    _isProcessing = processing;
    _currentTask = task;
    _progress = processing ? 0.0 : 1.0;
    notifyListeners();
  }
}
