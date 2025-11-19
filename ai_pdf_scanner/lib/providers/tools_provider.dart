import 'package:flutter/foundation.dart';
import '../services/pdf/pdf_compressor_service.dart';
import '../services/pdf/pdf_merger_service.dart';
import '../services/pdf/pdf_splitter_service.dart';
import '../exceptions/pdf_exception.dart';

/// Provider for managing PDF tools operations
class ToolsProvider with ChangeNotifier {
  final PDFCompressorService _compressorService = PDFCompressorService();
  final PDFMergerService _mergerService = PDFMergerService();
  final PDFSplitterService _splitterService = PDFSplitterService();

  // Processing state
  bool _isProcessing = false;
  bool get isProcessing => _isProcessing;

  // Current operation
  String? _currentOperation;
  String? get currentOperation => _currentOperation;

  // Progress (0.0 to 1.0)
  double? _progress;
  double? get progress => _progress;

  // Output file path
  String? _outputFilePath;
  String? get outputFilePath => _outputFilePath;

  // Error message
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Compression settings
  CompressionLevel _compressionLevel = CompressionLevel.medium;
  CompressionLevel get compressionLevel => _compressionLevel;

  /// Set compression level
  void setCompressionLevel(CompressionLevel level) {
    _compressionLevel = level;
    notifyListeners();
  }

  /// Compress PDF
  Future<String?> compressPDF({
    required String pdfPath,
    CompressionLevel? level,
  }) async {
    _isProcessing = true;
    _currentOperation = 'Compressing PDF...';
    _errorMessage = null;
    _progress = 0.0;
    notifyListeners();

    try {
      final compressionQuality = (level ?? _compressionLevel).quality;

      final compressedPath = await _compressorService.compressPDF(
        pdfPath,
        quality: compressionQuality,
      );

      _outputFilePath = compressedPath;
      _isProcessing = false;
      _currentOperation = null;
      _progress = 1.0;
      notifyListeners();

      return compressedPath;
    } catch (e) {
      _errorMessage = 'Failed to compress PDF';
      _isProcessing = false;
      _currentOperation = null;
      _progress = null;
      notifyListeners();

      throw PDFCompressionException(
        'Failed to compress PDF',
        originalError: e,
      );
    }
  }

  /// Merge PDFs
  Future<String?> mergePDFs({
    required List<String> pdfPaths,
    String? outputFileName,
  }) async {
    if (pdfPaths.isEmpty) {
      throw ValidationException('No PDFs selected for merging');
    }

    _isProcessing = true;
    _currentOperation = 'Merging PDFs...';
    _errorMessage = null;
    _progress = 0.0;
    notifyListeners();

    try {
      final mergedPath = await _mergerService.mergePDFs(
        pdfPaths,
        outputFileName: outputFileName,
      );

      _outputFilePath = mergedPath;
      _isProcessing = false;
      _currentOperation = null;
      _progress = 1.0;
      notifyListeners();

      return mergedPath;
    } catch (e) {
      _errorMessage = 'Failed to merge PDFs';
      _isProcessing = false;
      _currentOperation = null;
      _progress = null;
      notifyListeners();

      throw PDFMergeException(
        'Failed to merge PDFs',
        originalError: e,
      );
    }
  }

  /// Split PDF into single pages
  Future<List<String>?> splitPDFPages({
    required String pdfPath,
  }) async {
    _isProcessing = true;
    _currentOperation = 'Splitting PDF...';
    _errorMessage = null;
    _progress = 0.0;
    notifyListeners();

    try {
      final splitPaths = await _splitterService.splitIntoPages(pdfPath);

      _isProcessing = false;
      _currentOperation = null;
      _progress = 1.0;
      notifyListeners();

      return splitPaths;
    } catch (e) {
      _errorMessage = 'Failed to split PDF';
      _isProcessing = false;
      _currentOperation = null;
      _progress = null;
      notifyListeners();

      throw PDFSplitException(
        'Failed to split PDF',
        originalError: e,
      );
    }
  }

  /// Split PDF by page ranges
  Future<List<String>?> splitPDFRanges({
    required String pdfPath,
    required List<Map<String, int>> ranges, // [{start: 1, end: 5}, ...]
  }) async {
    _isProcessing = true;
    _currentOperation = 'Splitting PDF...';
    _errorMessage = null;
    _progress = 0.0;
    notifyListeners();

    try {
      final splitPaths = await _splitterService.splitByRanges(
        pdfPath,
        ranges: ranges,
      );

      _isProcessing = false;
      _currentOperation = null;
      _progress = 1.0;
      notifyListeners();

      return splitPaths;
    } catch (e) {
      _errorMessage = 'Failed to split PDF';
      _isProcessing = false;
      _currentOperation = null;
      _progress = null;
      notifyListeners();

      throw PDFSplitException(
        'Failed to split PDF by ranges',
        originalError: e,
      );
    }
  }

  /// Extract specific pages
  Future<String?> extractPages({
    required String pdfPath,
    required List<int> pageNumbers,
    String? outputFileName,
  }) async {
    if (pageNumbers.isEmpty) {
      throw ValidationException('No pages selected for extraction');
    }

    _isProcessing = true;
    _currentOperation = 'Extracting pages...';
    _errorMessage = null;
    _progress = 0.0;
    notifyListeners();

    try {
      final extractedPath = await _splitterService.extractPages(
        pdfPath,
        pageNumbers: pageNumbers,
        outputFileName: outputFileName,
      );

      _outputFilePath = extractedPath;
      _isProcessing = false;
      _currentOperation = null;
      _progress = 1.0;
      notifyListeners();

      return extractedPath;
    } catch (e) {
      _errorMessage = 'Failed to extract pages';
      _isProcessing = false;
      _currentOperation = null;
      _progress = null;
      notifyListeners();

      throw PDFException(
        'Failed to extract pages',
        originalError: e,
      );
    }
  }

  /// Optimize PDF for web
  Future<String?> optimizeForWeb({
    required String pdfPath,
  }) async {
    _isProcessing = true;
    _currentOperation = 'Optimizing for web...';
    _errorMessage = null;
    _progress = 0.0;
    notifyListeners();

    try {
      final optimizedPath = await _compressorService.optimizeForWeb(pdfPath);

      _outputFilePath = optimizedPath;
      _isProcessing = false;
      _currentOperation = null;
      _progress = 1.0;
      notifyListeners();

      return optimizedPath;
    } catch (e) {
      _errorMessage = 'Failed to optimize PDF';
      _isProcessing = false;
      _currentOperation = null;
      _progress = null;
      notifyListeners();

      throw PDFException(
        'Failed to optimize PDF for web',
        originalError: e,
      );
    }
  }

  /// Update progress
  void updateProgress(double value) {
    _progress = value.clamp(0.0, 1.0);
    notifyListeners();
  }

  /// Reset provider
  void reset() {
    _isProcessing = false;
    _currentOperation = null;
    _progress = null;
    _outputFilePath = null;
    _compressionLevel = CompressionLevel.medium;
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    reset();
    super.dispose();
  }
}

/// Compression levels
enum CompressionLevel {
  light,
  medium,
  strong,
  maximum,
}

/// Extension to get compression quality
extension CompressionLevelExtension on CompressionLevel {
  int get quality {
    switch (this) {
      case CompressionLevel.light:
        return 85;
      case CompressionLevel.medium:
        return 70;
      case CompressionLevel.strong:
        return 55;
      case CompressionLevel.maximum:
        return 40;
    }
  }

  String get label {
    switch (this) {
      case CompressionLevel.light:
        return 'Light (Best quality)';
      case CompressionLevel.medium:
        return 'Medium (Balanced)';
      case CompressionLevel.strong:
        return 'Strong (Smaller file)';
      case CompressionLevel.maximum:
        return 'Maximum (Smallest)';
    }
  }

  String get description {
    switch (this) {
      case CompressionLevel.light:
        return 'Minimal compression, best quality';
      case CompressionLevel.medium:
        return 'Balanced quality and size';
      case CompressionLevel.strong:
        return 'High compression, good quality';
      case CompressionLevel.maximum:
        return 'Maximum compression, lower quality';
    }
  }
}

import '../exceptions/app_exception.dart';
