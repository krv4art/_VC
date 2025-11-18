import 'package:flutter/foundation.dart';

/// Represents a PDF document in the app
class PdfDocument {
  final String id;
  final String title;
  final String filePath;
  final String? thumbnailPath;
  final DocumentType documentType;
  final int pageCount;
  final int fileSize; // in bytes
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isFavorite;
  final List<String> tags;
  final Map<String, dynamic>? aiMetadata; // AI analysis results

  const PdfDocument({
    required this.id,
    required this.title,
    required this.filePath,
    this.thumbnailPath,
    required this.documentType,
    this.pageCount = 1,
    required this.fileSize,
    required this.createdAt,
    required this.updatedAt,
    this.isFavorite = false,
    this.tags = const [],
    this.aiMetadata,
  });

  /// Create from database map
  factory PdfDocument.fromMap(Map<String, dynamic> map) {
    return PdfDocument(
      id: map['id'] as String,
      title: map['title'] as String,
      filePath: map['file_path'] as String,
      thumbnailPath: map['thumbnail_path'] as String?,
      documentType: DocumentType.fromString(map['document_type'] as String),
      pageCount: map['page_count'] as int? ?? 1,
      fileSize: map['file_size'] as int,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updated_at'] as int),
      isFavorite: (map['is_favorite'] as int) == 1,
      tags: (map['tags'] as String?)?.split(',').where((t) => t.isNotEmpty).toList() ?? [],
      aiMetadata: map['ai_metadata'] != null
          ? Map<String, dynamic>.from(map['ai_metadata'] as Map)
          : null,
    );
  }

  /// Convert to database map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'file_path': filePath,
      'thumbnail_path': thumbnailPath,
      'document_type': documentType.toString(),
      'page_count': pageCount,
      'file_size': fileSize,
      'created_at': createdAt.millisecondsSinceEpoch,
      'updated_at': updatedAt.millisecondsSinceEpoch,
      'is_favorite': isFavorite ? 1 : 0,
      'tags': tags.join(','),
      'ai_metadata': aiMetadata,
    };
  }

  /// Copy with modifications
  PdfDocument copyWith({
    String? id,
    String? title,
    String? filePath,
    String? thumbnailPath,
    DocumentType? documentType,
    int? pageCount,
    int? fileSize,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isFavorite,
    List<String>? tags,
    Map<String, dynamic>? aiMetadata,
  }) {
    return PdfDocument(
      id: id ?? this.id,
      title: title ?? this.title,
      filePath: filePath ?? this.filePath,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      documentType: documentType ?? this.documentType,
      pageCount: pageCount ?? this.pageCount,
      fileSize: fileSize ?? this.fileSize,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isFavorite: isFavorite ?? this.isFavorite,
      tags: tags ?? this.tags,
      aiMetadata: aiMetadata ?? this.aiMetadata,
    );
  }

  /// Get human-readable file size
  String get fileSizeFormatted {
    if (fileSize < 1024) {
      return '$fileSize B';
    } else if (fileSize < 1024 * 1024) {
      return '${(fileSize / 1024).toStringAsFixed(1)} KB';
    } else if (fileSize < 1024 * 1024 * 1024) {
      return '${(fileSize / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(fileSize / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PdfDocument && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'PdfDocument{id: $id, title: $title, type: $documentType, pages: $pageCount}';
  }
}

/// Types of documents in the app
enum DocumentType {
  scanned, // Created from camera scan
  converted, // Converted from other format
  imported, // Imported from file system
  ;

  @override
  String toString() {
    switch (this) {
      case DocumentType.scanned:
        return 'scanned';
      case DocumentType.converted:
        return 'converted';
      case DocumentType.imported:
        return 'imported';
    }
  }

  static DocumentType fromString(String value) {
    switch (value) {
      case 'scanned':
        return DocumentType.scanned;
      case 'converted':
        return DocumentType.converted;
      case 'imported':
        return DocumentType.imported;
      default:
        return DocumentType.imported;
    }
  }

  /// Get icon name for the document type
  String get iconName {
    switch (this) {
      case DocumentType.scanned:
        return 'scan';
      case DocumentType.converted:
        return 'transform';
      case DocumentType.imported:
        return 'upload';
    }
  }
}
