import 'retouch_settings.dart';
import 'background_settings.dart';

/// Model for batch photo generation request
class BatchGenerationRequest {
  final List<String> imagePaths; // Multiple input images
  final String styleId;
  final String? customPrompt;
  final RetouchSettings? retouchSettings;
  final BackgroundSettings? backgroundSettings;
  final int numberOfVariations; // How many variations per photo
  final bool highResolution; // 4K upscaling
  final String userId;
  final DateTime createdAt;

  BatchGenerationRequest({
    required this.imagePaths,
    required this.styleId,
    this.customPrompt,
    this.retouchSettings,
    this.backgroundSettings,
    this.numberOfVariations = 5,
    this.highResolution = false,
    required this.userId,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  int get totalGenerations => imagePaths.length * numberOfVariations;

  factory BatchGenerationRequest.fromMap(Map<String, dynamic> map) {
    return BatchGenerationRequest(
      imagePaths: List<String>.from(map['image_paths'] as List),
      styleId: map['style_id'] as String,
      customPrompt: map['custom_prompt'] as String?,
      retouchSettings: map['retouch_settings'] != null
          ? RetouchSettings.fromMap(map['retouch_settings'] as Map<String, dynamic>)
          : null,
      backgroundSettings: map['background_settings'] != null
          ? BackgroundSettings.fromMap(map['background_settings'] as Map<String, dynamic>)
          : null,
      numberOfVariations: map['number_of_variations'] as int? ?? 5,
      highResolution: map['high_resolution'] as bool? ?? false,
      userId: map['user_id'] as String,
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'image_paths': imagePaths,
      'style_id': styleId,
      'custom_prompt': customPrompt,
      'retouch_settings': retouchSettings?.toMap(),
      'background_settings': backgroundSettings?.toMap(),
      'number_of_variations': numberOfVariations,
      'high_resolution': highResolution,
      'user_id': userId,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

/// Model for batch generation job
class BatchGenerationJob {
  final String id;
  final BatchGenerationRequest request;
  final BatchJobStatus status;
  final int totalPhotos;
  final int completedPhotos;
  final int failedPhotos;
  final List<String> generatedPhotoIds;
  final DateTime createdAt;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final String? error;

  BatchGenerationJob({
    required this.id,
    required this.request,
    required this.status,
    required this.totalPhotos,
    this.completedPhotos = 0,
    this.failedPhotos = 0,
    this.generatedPhotoIds = const [],
    required this.createdAt,
    this.startedAt,
    this.completedAt,
    this.error,
  });

  double get progress => totalPhotos > 0 ? completedPhotos / totalPhotos : 0.0;

  bool get isComplete => status == BatchJobStatus.completed || status == BatchJobStatus.failed;

  factory BatchGenerationJob.fromMap(Map<String, dynamic> map) {
    return BatchGenerationJob(
      id: map['id'] as String,
      request: BatchGenerationRequest.fromMap(map['request'] as Map<String, dynamic>),
      status: BatchJobStatus.values.firstWhere(
        (e) => e.toString() == 'BatchJobStatus.${map['status']}',
        orElse: () => BatchJobStatus.pending,
      ),
      totalPhotos: map['total_photos'] as int,
      completedPhotos: map['completed_photos'] as int? ?? 0,
      failedPhotos: map['failed_photos'] as int? ?? 0,
      generatedPhotoIds: map['generated_photo_ids'] != null
          ? List<String>.from(map['generated_photo_ids'] as List)
          : [],
      createdAt: DateTime.parse(map['created_at'] as String),
      startedAt: map['started_at'] != null ? DateTime.parse(map['started_at'] as String) : null,
      completedAt: map['completed_at'] != null ? DateTime.parse(map['completed_at'] as String) : null,
      error: map['error'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'request': request.toMap(),
      'status': status.toString().split('.').last,
      'total_photos': totalPhotos,
      'completed_photos': completedPhotos,
      'failed_photos': failedPhotos,
      'generated_photo_ids': generatedPhotoIds,
      'created_at': createdAt.toIso8601String(),
      'started_at': startedAt?.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
      'error': error,
    };
  }

  BatchGenerationJob copyWith({
    String? id,
    BatchGenerationRequest? request,
    BatchJobStatus? status,
    int? totalPhotos,
    int? completedPhotos,
    int? failedPhotos,
    List<String>? generatedPhotoIds,
    DateTime? createdAt,
    DateTime? startedAt,
    DateTime? completedAt,
    String? error,
  }) {
    return BatchGenerationJob(
      id: id ?? this.id,
      request: request ?? this.request,
      status: status ?? this.status,
      totalPhotos: totalPhotos ?? this.totalPhotos,
      completedPhotos: completedPhotos ?? this.completedPhotos,
      failedPhotos: failedPhotos ?? this.failedPhotos,
      generatedPhotoIds: generatedPhotoIds ?? this.generatedPhotoIds,
      createdAt: createdAt ?? this.createdAt,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      error: error ?? this.error,
    );
  }
}

enum BatchJobStatus {
  pending,
  processing,
  completed,
  failed,
  cancelled,
}
