/// Model for AR fish measurements
class FishMeasurement {
  final String id;
  final String fishIdentificationId;
  final double length; // cm
  final double? estimatedWeight; // kg
  final String? weightEstimationMethod; // "ar", "manual", "scale"
  final MeasurementMethod method;
  final double confidence; // 0.0 to 1.0
  final String? imagePath;
  final DateTime measuredAt;
  final bool meetsRegulation;
  final String? regulationId;

  FishMeasurement({
    required this.id,
    required this.fishIdentificationId,
    required this.length,
    this.estimatedWeight,
    this.weightEstimationMethod,
    required this.method,
    required this.confidence,
    this.imagePath,
    required this.measuredAt,
    this.meetsRegulation = false,
    this.regulationId,
  });

  factory FishMeasurement.fromJson(Map<String, dynamic> json) {
    return FishMeasurement(
      id: json['id'] as String,
      fishIdentificationId: json['fish_identification_id'] as String,
      length: (json['length'] as num).toDouble(),
      estimatedWeight: (json['estimated_weight'] as num?)?.toDouble(),
      weightEstimationMethod: json['weight_estimation_method'] as String?,
      method: MeasurementMethod.values.firstWhere(
        (e) => e.toString() == 'MeasurementMethod.${json['method']}',
      ),
      confidence: (json['confidence'] as num).toDouble(),
      imagePath: json['image_path'] as String?,
      measuredAt: DateTime.parse(json['measured_at'] as String),
      meetsRegulation: json['meets_regulation'] as bool? ?? false,
      regulationId: json['regulation_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fish_identification_id': fishIdentificationId,
      'length': length,
      'estimated_weight': estimatedWeight,
      'weight_estimation_method': weightEstimationMethod,
      'method': method.toString().split('.').last,
      'confidence': confidence,
      'image_path': imagePath,
      'measured_at': measuredAt.toIso8601String(),
      'meets_regulation': meetsRegulation,
      'regulation_id': regulationId,
    };
  }

  /// Get length in inches
  double get lengthInInches => length / 2.54;

  /// Get weight in pounds
  double? get weightInPounds => estimatedWeight != null ? estimatedWeight! * 2.20462 : null;

  /// Check if measurement is reliable
  bool get isReliable => confidence >= 0.7;
}

enum MeasurementMethod {
  arCamera, // AR-based measurement
  manual, // Manual input
  ruler, // Photo with ruler
  tape, // Physical measuring tape
}

/// AR measurement session data
class ARMeasurementSession {
  final String id;
  final DateTime startedAt;
  final DateTime? completedAt;
  final List<ARMeasurementPoint> points;
  final double? calculatedLength;
  final double confidence;
  final String? errorMessage;

  ARMeasurementSession({
    required this.id,
    required this.startedAt,
    this.completedAt,
    this.points = const [],
    this.calculatedLength,
    this.confidence = 0.0,
    this.errorMessage,
  });

  bool get isComplete => completedAt != null && calculatedLength != null;

  Duration get duration {
    final end = completedAt ?? DateTime.now();
    return end.difference(startedAt);
  }
}

/// AR measurement point
class ARMeasurementPoint {
  final double x;
  final double y;
  final double z;
  final DateTime timestamp;

  ARMeasurementPoint({
    required this.x,
    required this.y,
    required this.z,
    required this.timestamp,
  });

  factory ARMeasurementPoint.fromJson(Map<String, dynamic> json) {
    return ARMeasurementPoint(
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      z: (json['z'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'x': x,
      'y': y,
      'z': z,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
