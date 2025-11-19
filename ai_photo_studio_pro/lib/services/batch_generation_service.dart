import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/batch_generation_request.dart';
import '../models/generated_photo.dart';
import '../services/replicate_service.dart';
import '../services/local_photo_database_service.dart';
import '../services/ai_retouch_service.dart';
import '../services/background_removal_service.dart';
import 'dart:convert';

/// Service for batch photo generation
class BatchGenerationService {
  final ReplicateService replicateService;
  final LocalPhotoDatabase databaseService;
  final AIRetouchService retouchService;
  final BackgroundRemovalService backgroundService;
  final SupabaseClient supabaseClient;

  BatchGenerationService({
    required this.replicateService,
    required this.databaseService,
    required this.retouchService,
    required this.backgroundService,
    required this.supabaseClient,
  });

  /// Start a batch generation job
  Future<BatchGenerationJob> startBatchGeneration(
    BatchGenerationRequest request,
  ) async {
    try {
      // Create job in database
      final jobId = _generateJobId();
      final job = BatchGenerationJob(
        id: jobId,
        request: request,
        status: BatchJobStatus.pending,
        totalPhotos: request.totalGenerations,
        createdAt: DateTime.now(),
      );

      // Save job to Supabase
      await _saveJobToDatabase(job);

      // Start processing in background
      _processJobAsync(job);

      return job;
    } catch (e) {
      debugPrint('Error starting batch generation: $e');
      rethrow;
    }
  }

  /// Process batch job asynchronously
  Future<void> _processJobAsync(BatchGenerationJob job) async {
    try {
      // Update job status to processing
      await _updateJobStatus(job.id, BatchJobStatus.processing);

      final generatedPhotoIds = <String>[];
      int completedCount = 0;
      int failedCount = 0;

      // Process each input image
      for (final imagePath in job.request.imagePaths) {
        // Generate multiple variations for each input image
        for (int i = 0; i < job.request.numberOfVariations; i++) {
          try {
            // 1. Generate headshot
            final generationJob = await replicateService.generateHeadshot(
              imagePath: imagePath,
              stylePrompt: job.request.customPrompt ??
                  'professional headshot in ${job.request.styleId} style',
              quality: job.request.highResolution ? 'high' : 'medium',
            );

            // Wait for generation to complete
            final completedJob = await _waitForGeneration(generationJob.id);

            if (completedJob.outputUrl == null) {
              failedCount++;
              continue;
            }

            String finalUrl = completedJob.outputUrl!;

            // 2. Apply retouch if requested
            if (job.request.retouchSettings != null) {
              finalUrl = await retouchService.applyRetouch(
                imagePath: finalUrl,
                settings: job.request.retouchSettings!,
              );
            }

            // 3. Apply background changes if requested
            if (job.request.backgroundSettings != null) {
              finalUrl = await backgroundService.replaceBackground(
                imagePath: finalUrl,
                settings: job.request.backgroundSettings!,
              );
            }

            // 4. Save to database
            final photo = GeneratedPhoto(
              id: 0, // Will be auto-incremented
              photoUrl: finalUrl,
              originalPhotoUrl: imagePath,
              styleId: job.request.styleId,
              createdAt: DateTime.now(),
              uploadedToCloud: true,
            );

            final photoId = await databaseService.saveGeneratedPhoto(photo);
            generatedPhotoIds.add(photoId.toString());
            completedCount++;

            // Update progress
            await _updateJobProgress(
              job.id,
              completedCount,
              failedCount,
              generatedPhotoIds,
            );
          } catch (e) {
            debugPrint('Error generating variation: $e');
            failedCount++;
          }
        }
      }

      // Mark job as completed
      await _updateJobStatus(
        job.id,
        failedCount == job.totalPhotos
            ? BatchJobStatus.failed
            : BatchJobStatus.completed,
      );
    } catch (e) {
      debugPrint('Error processing batch job: $e');
      await _updateJobStatus(job.id, BatchJobStatus.failed, error: e.toString());
    }
  }

  /// Wait for generation job to complete
  Future<dynamic> _waitForGeneration(String jobId) async {
    const maxAttempts = 120; // 10 minutes
    const pollInterval = Duration(seconds: 5);

    for (int i = 0; i < maxAttempts; i++) {
      await Future.delayed(pollInterval);

      final job = await replicateService.checkJobStatus(jobId);

      if (job.status == JobStatus.completed || job.status == JobStatus.failed) {
        return job;
      }
    }

    throw Exception('Generation job timed out');
  }

  /// Get job status
  Future<BatchGenerationJob> getJobStatus(String jobId) async {
    final response = await supabaseClient
        .from('batch_generation_jobs')
        .select()
        .eq('id', jobId)
        .single();

    return BatchGenerationJob.fromMap(response);
  }

  /// Get all jobs for a user
  Future<List<BatchGenerationJob>> getUserJobs(String userId) async {
    final response = await supabaseClient
        .from('batch_generation_jobs')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (response as List).map((e) => BatchGenerationJob.fromMap(e)).toList();
  }

  /// Cancel a batch job
  Future<void> cancelJob(String jobId) async {
    await _updateJobStatus(jobId, BatchJobStatus.cancelled);
  }

  /// Save job to database
  Future<void> _saveJobToDatabase(BatchGenerationJob job) async {
    await supabaseClient.from('batch_generation_jobs').insert({
      'id': job.id,
      'user_id': job.request.userId,
      'request': jsonEncode(job.request.toMap()),
      'status': job.status.toString().split('.').last,
      'total_photos': job.totalPhotos,
      'completed_photos': job.completedPhotos,
      'failed_photos': job.failedPhotos,
      'generated_photo_ids': job.generatedPhotoIds,
      'created_at': job.createdAt.toIso8601String(),
    });
  }

  /// Update job status
  Future<void> _updateJobStatus(
    String jobId,
    BatchJobStatus status, {
    String? error,
  }) async {
    await supabaseClient.from('batch_generation_jobs').update({
      'status': status.toString().split('.').last,
      if (error != null) 'error': error,
      if (status == BatchJobStatus.processing) 'started_at': DateTime.now().toIso8601String(),
      if (status == BatchJobStatus.completed || status == BatchJobStatus.failed)
        'completed_at': DateTime.now().toIso8601String(),
    }).eq('id', jobId);
  }

  /// Update job progress
  Future<void> _updateJobProgress(
    String jobId,
    int completed,
    int failed,
    List<String> photoIds,
  ) async {
    await supabaseClient.from('batch_generation_jobs').update({
      'completed_photos': completed,
      'failed_photos': failed,
      'generated_photo_ids': photoIds,
    }).eq('id', jobId);
  }

  /// Generate unique job ID
  String _generateJobId() {
    return 'batch_${DateTime.now().millisecondsSinceEpoch}_${(1000 + (9999 - 1000) * (DateTime.now().microsecond / 1000000)).round()}';
  }
}
