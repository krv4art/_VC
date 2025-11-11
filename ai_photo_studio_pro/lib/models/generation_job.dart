import 'generated_photo.dart';
import 'style_model.dart';

/// Model for tracking AI generation jobs
class GenerationJob {
  final String id; // Unique job ID (UUID or Replicate ID)
  final int photoId; // Reference to GeneratedPhoto
  final String styleId; // Reference to StyleModel
  final JobStatus status;
  final DateTime createdAt;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final String? resultUrl; // URL to generated image
  final String? errorMessage; // Error message if failed
  final Map<String, dynamic> metadata; // Additional job data

  GenerationJob({
    required this.id,
    required this.photoId,
    required this.styleId,
    required this.status,
    required this.createdAt,
    this.startedAt,
    this.completedAt,
    this.resultUrl,
    this.errorMessage,
    this.metadata = const {},
  });

  /// Create from database map
  factory GenerationJob.fromMap(Map<String, dynamic> map) {
    return GenerationJob(
      id: map['id'] as String,
      photoId: map['photo_id'] as int,
      styleId: map['style_id'] as String,
      status: JobStatus.values.firstWhere(
        (e) => e.toString() == 'JobStatus.${map['status']}',
        orElse: () => JobStatus.pending,
      ),
      createdAt: DateTime.parse(map['created_at'] as String),
      startedAt: map['started_at'] != null
          ? DateTime.parse(map['started_at'] as String)
          : null,
      completedAt: map['completed_at'] != null
          ? DateTime.parse(map['completed_at'] as String)
          : null,
      resultUrl: map['result_url'] as String?,
      errorMessage: map['error_message'] as String?,
      metadata: map['metadata'] != null
          ? Map<String, dynamic>.from(map['metadata'] as Map)
          : {},
    );
  }

  /// Convert to database map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'photo_id': photoId,
      'style_id': styleId,
      'status': status.toString().split('.').last,
      'created_at': createdAt.toIso8601String(),
      'started_at': startedAt?.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
      'result_url': resultUrl,
      'error_message': errorMessage,
      'metadata': metadata,
    };
  }

  /// Create copy with updated fields
  GenerationJob copyWith({
    String? id,
    int? photoId,
    String? styleId,
    JobStatus? status,
    DateTime? createdAt,
    DateTime? startedAt,
    DateTime? completedAt,
    String? resultUrl,
    String? errorMessage,
    Map<String, dynamic>? metadata,
  }) {
    return GenerationJob(
      id: id ?? this.id,
      photoId: photoId ?? this.photoId,
      styleId: styleId ?? this.styleId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      resultUrl: resultUrl ?? this.resultUrl,
      errorMessage: errorMessage ?? this.errorMessage,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Check if job is in final state
  bool get isFinished => status == JobStatus.completed || status == JobStatus.failed;

  /// Check if job is still running
  bool get isRunning => status == JobStatus.processing || status == JobStatus.pending;

  /// Get duration of job if completed
  Duration? get duration {
    if (startedAt != null && completedAt != null) {
      return completedAt!.difference(startedAt!);
    }
    return null;
  }

  @override
  String toString() {
    return 'GenerationJob(id: $id, photoId: $photoId, status: $status)';
  }
}

/// Status of generation job
enum JobStatus {
  pending,    // Waiting to start
  processing, // Being processed by AI
  completed,  // Successfully completed
  failed,     // Failed with error
  cancelled,  // Cancelled by user
}
