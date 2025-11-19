import 'dart:io';
import 'dart:isolate';
import 'package:flutter/foundation.dart';
import '../models/processing_options.dart';
import 'ai_background_removal_service.dart';
import 'image_processing_service.dart';

/// Service for batch processing multiple images
class BatchProcessingService {
  final ImageProcessingService _imageService = ImageProcessingService();
  final AIBackgroundRemovalService _aiService = AIBackgroundRemovalService();

  /// Process multiple images in batch
  Future<List<BatchProcessingResult>> processBatch(
    List<File> images,
    ProcessingOptions options, {
    Function(int current, int total)? onProgress,
  }) async {
    final results = <BatchProcessingResult>[];

    for (int i = 0; i < images.length; i++) {
      try {
        onProgress?.call(i + 1, images.length);

        final result = await _processSingleImage(images[i], options);

        results.add(BatchProcessingResult(
          originalFile: images[i],
          processedFile: result,
          success: true,
        ));
      } catch (e) {
        results.add(BatchProcessingResult(
          originalFile: images[i],
          success: false,
          error: e.toString(),
        ));
      }
    }

    return results;
  }

  /// Process images in parallel using isolates for better performance
  Future<List<BatchProcessingResult>> processBatchParallel(
    List<File> images,
    ProcessingOptions options, {
    int maxConcurrent = 3,
    Function(int current, int total)? onProgress,
  }) async {
    final results = <BatchProcessingResult>[];
    int completed = 0;

    // Process in chunks
    for (int i = 0; i < images.length; i += maxConcurrent) {
      final chunk = images.skip(i).take(maxConcurrent).toList();

      final chunkResults = await Future.wait(
        chunk.map((image) => _processSingleImageSafe(image, options)),
      );

      results.addAll(chunkResults);
      completed += chunk.length;
      onProgress?.call(completed, images.length);
    }

    return results;
  }

  /// Process single image with error handling
  Future<BatchProcessingResult> _processSingleImageSafe(
    File image,
    ProcessingOptions options,
  ) async {
    try {
      final result = await _processSingleImage(image, options);
      return BatchProcessingResult(
        originalFile: image,
        processedFile: result,
        success: true,
      );
    } catch (e) {
      return BatchProcessingResult(
        originalFile: image,
        success: false,
        error: e.toString(),
      );
    }
  }

  /// Process a single image
  Future<File> _processSingleImage(
    File image,
    ProcessingOptions options,
  ) async {
    return await _imageService.removeBackground(image, options);
  }

  /// Save all processed images to gallery
  Future<Map<String, dynamic>> saveAllToGallery(
    List<BatchProcessingResult> results,
  ) async {
    int successCount = 0;
    int failedCount = 0;

    for (final result in results) {
      if (result.success && result.processedFile != null) {
        try {
          await _imageService.saveToGallery(result.processedFile!);
          successCount++;
        } catch (e) {
          failedCount++;
        }
      }
    }

    return {
      'success': successCount,
      'failed': failedCount,
      'total': results.length,
    };
  }

  /// Get processing statistics
  Map<String, dynamic> getStatistics(List<BatchProcessingResult> results) {
    final successful = results.where((r) => r.success).length;
    final failed = results.where((r) => !r.success).length;

    return {
      'total': results.length,
      'successful': successful,
      'failed': failed,
      'successRate': results.isNotEmpty ? successful / results.length : 0.0,
    };
  }
}

/// Result of a single batch processing operation
class BatchProcessingResult {
  final File originalFile;
  final File? processedFile;
  final bool success;
  final String? error;
  final DateTime timestamp;

  BatchProcessingResult({
    required this.originalFile,
    this.processedFile,
    required this.success,
    this.error,
  }) : timestamp = DateTime.now();

  String get fileName => originalFile.path.split('/').last;

  Map<String, dynamic> toMap() {
    return {
      'originalPath': originalFile.path,
      'processedPath': processedFile?.path,
      'success': success,
      'error': error,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
