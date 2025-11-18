import 'dart:ui';

/// Represents an annotation on a PDF page
class Annotation {
  final String id;
  final String documentId;
  final int pageNumber;
  final AnnotationType type;
  final String? content; // Text content for notes
  final AnnotationPosition position;
  final Color color;
  final DateTime createdAt;

  const Annotation({
    required this.id,
    required this.documentId,
    required this.pageNumber,
    required this.type,
    this.content,
    required this.position,
    required this.color,
    required this.createdAt,
  });

  /// Create from database map
  factory Annotation.fromMap(Map<String, dynamic> map) {
    return Annotation(
      id: map['id'] as String,
      documentId: map['document_id'] as String,
      pageNumber: map['page_number'] as int,
      type: AnnotationType.fromString(map['type'] as String),
      content: map['content'] as String?,
      position: AnnotationPosition.fromJson(map['position'] as String),
      color: Color(int.parse(map['color'] as String, radix: 16)),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
    );
  }

  /// Convert to database map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'document_id': documentId,
      'page_number': pageNumber,
      'type': type.toString(),
      'content': content,
      'position': position.toJson(),
      'color': color.value.toRadixString(16),
      'created_at': createdAt.millisecondsSinceEpoch,
    };
  }

  @override
  String toString() {
    return 'Annotation{id: $id, type: $type, page: $pageNumber}';
  }
}

/// Types of annotations
enum AnnotationType {
  highlight,
  note,
  drawing,
  signature,
  ;

  @override
  String toString() {
    switch (this) {
      case AnnotationType.highlight:
        return 'highlight';
      case AnnotationType.note:
        return 'note';
      case AnnotationType.drawing:
        return 'drawing';
      case AnnotationType.signature:
        return 'signature';
    }
  }

  static AnnotationType fromString(String value) {
    switch (value) {
      case 'highlight':
        return AnnotationType.highlight;
      case 'note':
        return AnnotationType.note;
      case 'drawing':
        return AnnotationType.drawing;
      case 'signature':
        return AnnotationType.signature;
      default:
        return AnnotationType.note;
    }
  }
}

/// Position and dimensions of an annotation on a page
class AnnotationPosition {
  final double x;
  final double y;
  final double width;
  final double height;

  const AnnotationPosition({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });

  /// Create from JSON string
  factory AnnotationPosition.fromJson(String json) {
    final parts = json.split(',');
    return AnnotationPosition(
      x: double.parse(parts[0]),
      y: double.parse(parts[1]),
      width: double.parse(parts[2]),
      height: double.parse(parts[3]),
    );
  }

  /// Convert to JSON string
  String toJson() {
    return '$x,$y,$width,$height';
  }
}
