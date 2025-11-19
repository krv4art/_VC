import 'dart:async';
import 'package:flutter/material.dart';
import '../models/generated_photo.dart';
import '../models/generation_job.dart';

/// Service for batch processing multiple photos
class BatchProcessingService {
  final List<BatchJob> _activeJobs = [];
  final StreamController<BatchProcessingUpdate> _updateController =
      StreamController<BatchProcessingUpdate>.broadcast();

  Stream<BatchProcessingUpdate> get updates => _updateController.stream;

  /// Start batch photo generation
  Future<String> startBatchGeneration({
    required List<String> photoPaths,
    required List<String> styleIds,
    required Future<GenerationJob?> Function(String photoPath, String styleId) generateFunction,
    void Function(int current, int total)? onProgress,
  }) async {
    final batchId = DateTime.now().millisecondsSinceEpoch.toString();
    final total = photoPaths.length * styleIds.length;

    final job = BatchJob(
      id: batchId,
      type: BatchJobType.generation,
      total: total,
      completed: 0,
      failed: 0,
      status: BatchJobStatus.running,
      startedAt: DateTime.now(),
    );

    _activeJobs.add(job);
    _updateController.add(BatchProcessingUpdate(
      batchId: batchId,
      current: 0,
      total: total,
      status: BatchJobStatus.running,
    ));

    int current = 0;

    try {
      for (final photoPath in photoPaths) {
        for (final styleId in styleIds) {
          if (job.status == BatchJobStatus.cancelled) {
            break;
          }

          try {
            final result = await generateFunction(photoPath, styleId);

            if (result != null) {
              job.completed++;
              job.results.add(result);
            } else {
              job.failed++;
            }
          } catch (e) {
            debugPrint('Error generating photo in batch: $e');
            job.failed++;
          }

          current++;
          onProgress?.call(current, total);

          _updateController.add(BatchProcessingUpdate(
            batchId: batchId,
            current: current,
            total: total,
            status: job.status,
            completed: job.completed,
            failed: job.failed,
          ));

          // Small delay to prevent overwhelming the API
          await Future.delayed(const Duration(milliseconds: 500));
        }
      }

      job.status = BatchJobStatus.completed;
      job.completedAt = DateTime.now();
    } catch (e) {
      debugPrint('Batch generation error: $e');
      job.status = BatchJobStatus.failed;
      job.error = e.toString();
    }

    _updateController.add(BatchProcessingUpdate(
      batchId: batchId,
      current: total,
      total: total,
      status: job.status,
      completed: job.completed,
      failed: job.failed,
    ));

    return batchId;
  }

  /// Start batch photo editing
  Future<String> startBatchEditing({
    required List<String> photoPaths,
    required Future<String?> Function(String photoPath) editFunction,
    void Function(int current, int total)? onProgress,
  }) async {
    final batchId = DateTime.now().millisecondsSinceEpoch.toString();
    final total = photoPaths.length;

    final job = BatchJob(
      id: batchId,
      type: BatchJobType.editing,
      total: total,
      completed: 0,
      failed: 0,
      status: BatchJobStatus.running,
      startedAt: DateTime.now(),
    );

    _activeJobs.add(job);

    for (int i = 0; i < photoPaths.length; i++) {
      if (job.status == BatchJobStatus.cancelled) break;

      try {
        final result = await editFunction(photoPaths[i]);

        if (result != null) {
          job.completed++;
          job.editedPaths.add(result);
        } else {
          job.failed++;
        }
      } catch (e) {
        debugPrint('Error editing photo in batch: $e');
        job.failed++;
      }

      onProgress?.call(i + 1, total);

      _updateController.add(BatchProcessingUpdate(
        batchId: batchId,
        current: i + 1,
        total: total,
        status: job.status,
        completed: job.completed,
        failed: job.failed,
      ));
    }

    job.status = BatchJobStatus.completed;
    job.completedAt = DateTime.now();

    return batchId;
  }

  /// Start batch upload to cloud
  Future<String> startBatchUpload({
    required List<String> photoPaths,
    required Future<String?> Function(String photoPath) uploadFunction,
    void Function(int current, int total)? onProgress,
  }) async {
    final batchId = DateTime.now().millisecondsSinceEpoch.toString();
    final total = photoPaths.length;

    final job = BatchJob(
      id: batchId,
      type: BatchJobType.upload,
      total: total,
      completed: 0,
      failed: 0,
      status: BatchJobStatus.running,
      startedAt: DateTime.now(),
    );

    _activeJobs.add(job);

    for (int i = 0; i < photoPaths.length; i++) {
      if (job.status == BatchJobStatus.cancelled) break;

      try {
        final url = await uploadFunction(photoPaths[i]);

        if (url != null) {
          job.completed++;
          job.uploadedUrls.add(url);
        } else {
          job.failed++;
        }
      } catch (e) {
        debugPrint('Error uploading photo in batch: $e');
        job.failed++;
      }

      onProgress?.call(i + 1, total);

      _updateController.add(BatchProcessingUpdate(
        batchId: batchId,
        current: i + 1,
        total: total,
        status: job.status,
        completed: job.completed,
        failed: job.failed,
      ));
    }

    job.status = BatchJobStatus.completed;
    job.completedAt = DateTime.now();

    return batchId;
  }

  /// Start batch download from cloud
  Future<String> startBatchDownload({
    required List<String> remoteUrls,
    required Future<String?> Function(String url) downloadFunction,
    void Function(int current, int total)? onProgress,
  }) async {
    final batchId = DateTime.now().millisecondsSinceEpoch.toString();
    final total = remoteUrls.length;

    final job = BatchJob(
      id: batchId,
      type: BatchJobType.download,
      total: total,
      completed: 0,
      failed: 0,
      status: BatchJobStatus.running,
      startedAt: DateTime.now(),
    );

    _activeJobs.add(job);

    for (int i = 0; i < remoteUrls.length; i++) {
      if (job.status == BatchJobStatus.cancelled) break;

      try {
        final path = await downloadFunction(remoteUrls[i]);

        if (path != null) {
          job.completed++;
          job.downloadedPaths.add(path);
        } else {
          job.failed++;
        }
      } catch (e) {
        debugPrint('Error downloading photo in batch: $e');
        job.failed++;
      }

      onProgress?.call(i + 1, total);

      _updateController.add(BatchProcessingUpdate(
        batchId: batchId,
        current: i + 1,
        total: total,
        status: job.status,
        completed: job.completed,
        failed: job.failed,
      ));
    }

    job.status = BatchJobStatus.completed;
    job.completedAt = DateTime.now();

    return batchId;
  }

  /// Get batch job status
  BatchJob? getBatchJob(String batchId) {
    try {
      return _activeJobs.firstWhere((job) => job.id == batchId);
    } catch (e) {
      return null;
    }
  }

  /// Cancel batch job
  void cancelBatchJob(String batchId) {
    final job = getBatchJob(batchId);
    if (job != null) {
      job.status = BatchJobStatus.cancelled;
      job.completedAt = DateTime.now();

      _updateController.add(BatchProcessingUpdate(
        batchId: batchId,
        current: job.completed,
        total: job.total,
        status: BatchJobStatus.cancelled,
        completed: job.completed,
        failed: job.failed,
      ));
    }
  }

  /// Get all active jobs
  List<BatchJob> getActiveJobs() {
    return _activeJobs
        .where((job) =>
            job.status == BatchJobStatus.running ||
            job.status == BatchJobStatus.pending)
        .toList();
  }

  /// Get completed jobs
  List<BatchJob> getCompletedJobs() {
    return _activeJobs
        .where((job) => job.status == BatchJobStatus.completed)
        .toList();
  }

  /// Clear completed jobs
  void clearCompletedJobs() {
    _activeJobs.removeWhere((job) => job.status == BatchJobStatus.completed);
  }

  /// Dispose
  void dispose() {
    _updateController.close();
  }
}

/// Batch job model
class BatchJob {
  final String id;
  final BatchJobType type;
  final int total;
  int completed;
  int failed;
  BatchJobStatus status;
  final DateTime startedAt;
  DateTime? completedAt;
  String? error;

  // Results
  final List<GenerationJob> results = [];
  final List<String> editedPaths = [];
  final List<String> uploadedUrls = [];
  final List<String> downloadedPaths = [];

  BatchJob({
    required this.id,
    required this.type,
    required this.total,
    required this.completed,
    required this.failed,
    required this.status,
    required this.startedAt,
    this.completedAt,
    this.error,
  });

  double get progress => total > 0 ? completed / total : 0.0;

  Duration? get duration {
    if (completedAt != null) {
      return completedAt!.difference(startedAt);
    } else {
      return DateTime.now().difference(startedAt);
    }
  }
}

/// Batch job types
enum BatchJobType {
  generation,
  editing,
  upload,
  download,
}

/// Batch job status
enum BatchJobStatus {
  pending,
  running,
  completed,
  failed,
  cancelled,
}

/// Batch processing update event
class BatchProcessingUpdate {
  final String batchId;
  final int current;
  final int total;
  final BatchJobStatus status;
  final int? completed;
  final int? failed;

  BatchProcessingUpdate({
    required this.batchId,
    required this.current,
    required this.total,
    required this.status,
    this.completed,
    this.failed,
  });

  double get progress => total > 0 ? current / total : 0.0;
}
