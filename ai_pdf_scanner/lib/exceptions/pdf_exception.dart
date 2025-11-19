import 'app_exception.dart';

/// Base exception for PDF-related errors
abstract class PDFException extends AppException {
  PDFException(
    super.message, {
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

/// Exception for PDF generation errors
class PDFGenerationException extends PDFException {
  PDFGenerationException(
    super.message, {
    super.code,
    super.originalError,
    super.stackTrace,
  });

  @override
  String get userMessage => 'Failed to create PDF: $message';
}

/// Exception for PDF loading errors
class PDFLoadException extends PDFException {
  final String? filePath;

  PDFLoadException(
    super.message, {
    this.filePath,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  @override
  String get userMessage => 'Failed to load PDF file';
}

/// Exception for PDF corruption
class PDFCorruptException extends PDFException {
  PDFCorruptException(
    super.message, {
    super.code,
    super.originalError,
    super.stackTrace,
  });

  @override
  String get userMessage => 'PDF file is corrupted or invalid';
}

/// Exception for PDF password protection
class PDFPasswordException extends PDFException {
  final bool isWrongPassword;

  PDFPasswordException(
    super.message, {
    this.isWrongPassword = false,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  @override
  String get userMessage =>
      isWrongPassword ? 'Incorrect password' : 'PDF is password protected';
}

/// Exception for PDF merge errors
class PDFMergeException extends PDFException {
  final int? failedFileIndex;

  PDFMergeException(
    super.message, {
    this.failedFileIndex,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  @override
  String get userMessage => 'Failed to merge PDF files';
}

/// Exception for PDF split errors
class PDFSplitException extends PDFException {
  PDFSplitException(
    super.message, {
    super.code,
    super.originalError,
    super.stackTrace,
  });

  @override
  String get userMessage => 'Failed to split PDF';
}

/// Exception for PDF compression errors
class PDFCompressionException extends PDFException {
  PDFCompressionException(
    super.message, {
    super.code,
    super.originalError,
    super.stackTrace,
  });

  @override
  String get userMessage => 'Failed to compress PDF';
}

/// Exception for PDF editing errors
class PDFEditException extends PDFException {
  final String? operation;

  PDFEditException(
    super.message, {
    this.operation,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  @override
  String get userMessage =>
      'Failed to edit PDF${operation != null ? ' ($operation)' : ''}';
}

/// Exception for PDF conversion errors
class PDFConversionException extends PDFException {
  final String? sourceFormat;
  final String? targetFormat;

  PDFConversionException(
    super.message, {
    this.sourceFormat,
    this.targetFormat,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  @override
  String get userMessage {
    if (sourceFormat != null && targetFormat != null) {
      return 'Failed to convert $sourceFormat to $targetFormat';
    }
    return 'Failed to convert file';
  }
}

/// Exception for unsupported PDF features
class PDFUnsupportedFeatureException extends PDFException {
  final String feature;

  PDFUnsupportedFeatureException(
    this.feature, {
    super.code,
    super.originalError,
    super.stackTrace,
  }) : super('Unsupported PDF feature: $feature');

  @override
  String get userMessage => 'Feature not supported: $feature';

  @override
  bool get shouldReport => false;
}

/// Exception for PDF size limits
class PDFSizeLimitException extends PDFException {
  final int? maxSizeMB;
  final int? actualSizeMB;

  PDFSizeLimitException(
    super.message, {
    this.maxSizeMB,
    this.actualSizeMB,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  @override
  String get userMessage {
    if (maxSizeMB != null && actualSizeMB != null) {
      return 'File too large (${actualSizeMB}MB). Maximum size is ${maxSizeMB}MB';
    }
    return 'File size exceeds maximum limit';
  }

  @override
  bool get shouldReport => false;
}

/// Exception for PDF page errors
class PDFPageException extends PDFException {
  final int? pageNumber;

  PDFPageException(
    super.message, {
    this.pageNumber,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  @override
  String get userMessage =>
      'Page error${pageNumber != null ? ' (page $pageNumber)' : ''}: $message';
}
