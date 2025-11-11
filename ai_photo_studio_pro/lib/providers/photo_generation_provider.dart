import 'package:flutter/foundation.dart';
import '../models/generated_photo.dart';
import '../models/generation_job.dart';
import '../models/style_model.dart';
import '../services/replicate_service.dart';
import '../services/database_service.dart';
import 'dart:async';

/// Provider for managing photo generation workflow
class PhotoGenerationProvider extends ChangeNotifier {
  final ReplicateService _replicateService;
  final DatabaseService _databaseService;

  // Current generation state
  GenerationJob? _currentJob;
  GeneratedPhoto? _currentPhoto;
  bool _isGenerating = false;
  double _progress = 0.0;
  String? _errorMessage;

  // Photo history
  List<GeneratedPhoto> _generatedPhotos = [];

  PhotoGenerationProvider({
    required ReplicateService replicateService,
    required DatabaseService databaseService,
  }) : _replicateService = replicateService,
       _databaseService = databaseService {
    _loadGeneratedPhotos();
  }

  // Getters
  GenerationJob? get currentJob => _currentJob;
  GeneratedPhoto? get currentPhoto => _currentPhoto;
  bool get isGenerating => _isGenerating;
  double get progress => _progress;
  String? get errorMessage => _errorMessage;
  List<GeneratedPhoto> get generatedPhotos => _generatedPhotos;

  /// Load generated photos from database
  Future<void> _loadGeneratedPhotos() async {
    try {
      _generatedPhotos = (await _databaseService.getAllGeneratedPhotos())
          .cast<GeneratedPhoto>();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading generated photos: $e');
    }
  }

  /// Generate headshot from photo path and style
  Future<void> generateHeadshot({
    required String imagePath,
    required StyleModel style,
    String quality = 'medium',
  }) async {
    if (_isGenerating) {
      debugPrint('Generation already in progress');
      return;
    }

    try {
      _isGenerating = true;
      _progress = 0.0;
      _errorMessage = null;
      notifyListeners();

      // Create photo record in database
      final photo = GeneratedPhoto(
        originalPath: imagePath,
        styleId: style.id,
        createdAt: DateTime.now(),
        status: GenerationStatus.pending,
        metadata: {'style_name': style.name, 'quality': quality},
      );

      final photoId = await _databaseService.insertGeneratedPhoto(photo);
      _currentPhoto = photo.copyWith(id: photoId);

      _progress = 0.1;
      notifyListeners();

      // Start generation job
      final job = await _replicateService.generateHeadshot(
        imagePath: imagePath,
        stylePrompt: style.promptTemplate ?? _buildPrompt(style),
        quality: quality,
      );

      _currentJob = job.copyWith(photoId: photoId, styleId: style.id);

      await _databaseService.insertGenerationJob(_currentJob!);

      _progress = 0.3;
      notifyListeners();

      // Poll for completion
      await _pollJobStatus();
    } catch (e) {
      _errorMessage = e.toString();
      _isGenerating = false;
      debugPrint('Error generating headshot: $e');
      notifyListeners();
    }
  }

  /// Poll generation job status
  Future<void> _pollJobStatus() async {
    const maxAttempts = 60; // 60 * 5 seconds = 5 minutes max
    int attempts = 0;

    while (attempts < maxAttempts && _currentJob != null) {
      try {
        await Future.delayed(const Duration(seconds: 5));

        final updatedJob = await _replicateService.checkJobStatus(
          _currentJob!.id,
        );

        _currentJob = updatedJob;
        await _databaseService.updateGenerationJob(updatedJob);

        // Update progress
        if (updatedJob.status == JobStatus.processing) {
          _progress = 0.3 + (attempts / maxAttempts) * 0.6;
        }

        notifyListeners();

        // Check if finished
        if (updatedJob.isFinished) {
          if (updatedJob.status == JobStatus.completed) {
            await _onGenerationComplete(updatedJob);
          } else {
            await _onGenerationFailed(updatedJob);
          }
          break;
        }

        attempts++;
      } catch (e) {
        debugPrint('Error polling job status: $e');
        attempts++;
      }
    }

    if (attempts >= maxAttempts) {
      _errorMessage = 'Generation timeout';
      _isGenerating = false;
      notifyListeners();
    }
  }

  /// Handle successful generation
  Future<void> _onGenerationComplete(GenerationJob job) async {
    try {
      if (_currentPhoto != null && job.resultUrl != null) {
        // Download and save generated image
        final savedPath = await _downloadGeneratedImage(job.resultUrl!);

        final updatedPhoto = _currentPhoto!.copyWith(
          generatedPath: savedPath,
          status: GenerationStatus.completed,
          metadata: {
            ..._currentPhoto!.metadata,
            'generation_time': job.duration?.inSeconds,
          },
        );

        await _databaseService.updateGeneratedPhoto(updatedPhoto);
        _currentPhoto = updatedPhoto;

        _generatedPhotos.insert(0, updatedPhoto);
        _progress = 1.0;
      }
    } catch (e) {
      debugPrint('Error completing generation: $e');
      _errorMessage = e.toString();
    } finally {
      _isGenerating = false;
      notifyListeners();
    }
  }

  /// Handle failed generation
  Future<void> _onGenerationFailed(GenerationJob job) async {
    _errorMessage = job.errorMessage ?? 'Generation failed';

    if (_currentPhoto != null) {
      final updatedPhoto = _currentPhoto!.copyWith(
        status: GenerationStatus.failed,
        metadata: {..._currentPhoto!.metadata, 'error': _errorMessage},
      );

      await _databaseService.updateGeneratedPhoto(updatedPhoto);
      _currentPhoto = updatedPhoto;
    }

    _isGenerating = false;
    notifyListeners();
  }

  /// Download generated image and save locally
  Future<String> _downloadGeneratedImage(String url) async {
    // TODO: Implement image download and local storage
    // For now, return the URL
    return url;
  }

  /// Build prompt from style
  String _buildPrompt(StyleModel style) {
    return 'professional ${style.name} headshot, high quality, studio lighting';
  }

  /// Cancel current generation
  Future<void> cancelGeneration() async {
    if (_currentJob != null && _currentJob!.isRunning) {
      try {
        await _replicateService.cancelJob(_currentJob!.id);
        _isGenerating = false;
        _currentJob = null;
        notifyListeners();
      } catch (e) {
        debugPrint('Error cancelling generation: $e');
      }
    }
  }

  /// Delete generated photo
  Future<void> deletePhoto(int photoId) async {
    try {
      await _databaseService.deleteGeneratedPhoto(photoId);
      _generatedPhotos.removeWhere((photo) => photo.id == photoId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting photo: $e');
    }
  }

  /// Reload all photos
  Future<void> refreshPhotos() async {
    await _loadGeneratedPhotos();
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    // Cancel any ongoing generation
    if (_isGenerating && _currentJob != null) {
      cancelGeneration();
    }
    super.dispose();
  }
}
