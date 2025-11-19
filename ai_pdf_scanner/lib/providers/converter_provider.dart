import 'package:flutter/foundation.dart';
import '../services/pdf/pdf_generator_service.dart';
import '../exceptions/pdf_exception.dart';
import '../utils/file_utils.dart';

/// Provider for managing file conversion operations
class ConverterProvider with ChangeNotifier {
  final PDFGeneratorService _generatorService = PDFGeneratorService();

  // Conversion state
  bool _isConverting = false;
  bool get isConverting => _isConverting;

  // Current operation
  String? _currentOperation;
  String? get currentOperation => _currentOperation;

  // Progress (0.0 to 1.0)
  double? _progress;
  double? get progress => _progress;

  // Input files
  List<String> _inputFiles = [];
  List<String> get inputFiles => _inputFiles;

  // Output file path
  String? _outputFilePath;
  String? get outputFilePath => _outputFilePath;

  // Conversion settings
  ConversionQuality _quality = ConversionQuality.high;
  ConversionQuality get quality => _quality;

  int _dpi = 300;
  int get dpi => _dpi;

  bool _maintainAspectRatio = true;
  bool get maintainAspectRatio => _maintainAspectRatio;

  // Error message
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// Add input file
  void addInputFile(String filePath) {
    _inputFiles.add(filePath);
    notifyListeners();
  }

  /// Add multiple input files
  void addInputFiles(List<String> filePaths) {
    _inputFiles.addAll(filePaths);
    notifyListeners();
  }

  /// Remove input file
  void removeInputFile(String filePath) {
    _inputFiles.remove(filePath);
    notifyListeners();
  }

  /// Clear input files
  void clearInputFiles() {
    _inputFiles.clear();
    notifyListeners();
  }

  /// Set conversion quality
  void setQuality(ConversionQuality newQuality) {
    _quality = newQuality;
    notifyListeners();
  }

  /// Set DPI
  void setDPI(int newDPI) {
    _dpi = newDPI;
    notifyListeners();
  }

  /// Toggle maintain aspect ratio
  void toggleMaintainAspectRatio() {
    _maintainAspectRatio = !_maintainAspectRatio;
    notifyListeners();
  }

  /// Convert images to PDF
  Future<String?> imagesToPDF({
    List<String>? imagePaths,
    String? outputFileName,
  }) async {
    final paths = imagePaths ?? _inputFiles;

    if (paths.isEmpty) {
      throw ValidationException('No images selected for conversion');
    }

    _isConverting = true;
    _currentOperation = 'Converting images to PDF...';
    _errorMessage = null;
    _progress = 0.0;
    notifyListeners();

    try {
      // Create PDF from images
      final pdfPath = await _generatorService.createPDFFromImages(
        imagePaths: paths,
        outputFileName: outputFileName,
      );

      _outputFilePath = pdfPath;
      _isConverting = false;
      _currentOperation = null;
      _progress = 1.0;
      notifyListeners();

      return pdfPath;
    } catch (e) {
      _errorMessage = 'Failed to convert images to PDF';
      _isConverting = false;
      _currentOperation = null;
      _progress = null;
      notifyListeners();

      throw PDFConversionException(
        'Failed to convert images to PDF',
        sourceFormat: 'images',
        targetFormat: 'pdf',
        originalError: e,
      );
    }
  }

  /// Convert PDF to images
  Future<List<String>?> pdfToImages({
    required String pdfPath,
    String? outputDir,
  }) async {
    _isConverting = true;
    _currentOperation = 'Converting PDF to images...';
    _errorMessage = null;
    _progress = 0.0;
    notifyListeners();

    try {
      // TODO: Implement PDF to images conversion
      // This requires extracting each page as an image

      final imagePaths = <String>[];

      _isConverting = false;
      _currentOperation = null;
      _progress = 1.0;
      notifyListeners();

      return imagePaths;
    } catch (e) {
      _errorMessage = 'Failed to convert PDF to images';
      _isConverting = false;
      _currentOperation = null;
      _progress = null;
      notifyListeners();

      throw PDFConversionException(
        'Failed to convert PDF to images',
        sourceFormat: 'pdf',
        targetFormat: 'images',
        originalError: e,
      );
    }
  }

  /// Convert Office document to PDF
  Future<String?> officeToPDF({
    required String filePath,
    String? outputFileName,
  }) async {
    _isConverting = true;
    _currentOperation = 'Converting document to PDF...';
    _errorMessage = null;
    _progress = 0.0;
    notifyListeners();

    try {
      // TODO: Implement Office to PDF conversion
      // This may require platform-specific implementations or cloud services

      final fileExt = FileUtils.getFileExtension(filePath);

      // Placeholder implementation
      throw PDFUnsupportedFeatureException(
        'Office to PDF conversion not yet implemented',
      );
    } catch (e) {
      _errorMessage = 'Failed to convert document to PDF';
      _isConverting = false;
      _currentOperation = null;
      _progress = null;
      notifyListeners();

      if (e is PDFUnsupportedFeatureException) rethrow;

      throw PDFConversionException(
        'Failed to convert document to PDF',
        sourceFormat: 'office',
        targetFormat: 'pdf',
        originalError: e,
      );
    }
  }

  /// Update conversion progress
  void updateProgress(double value) {
    _progress = value.clamp(0.0, 1.0);
    notifyListeners();
  }

  /// Reset provider
  void reset() {
    _isConverting = false;
    _currentOperation = null;
    _progress = null;
    _inputFiles = [];
    _outputFilePath = null;
    _quality = ConversionQuality.high;
    _dpi = 300;
    _maintainAspectRatio = true;
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    reset();
    super.dispose();
  }
}

/// Conversion quality levels
enum ConversionQuality {
  low,
  medium,
  high,
  print,
}

/// Extension to get quality settings
extension ConversionQualityExtension on ConversionQuality {
  int get imageQuality {
    switch (this) {
      case ConversionQuality.low:
        return 60;
      case ConversionQuality.medium:
        return 80;
      case ConversionQuality.high:
        return 90;
      case ConversionQuality.print:
        return 95;
    }
  }

  int get dpi {
    switch (this) {
      case ConversionQuality.low:
        return 150;
      case ConversionQuality.medium:
        return 200;
      case ConversionQuality.high:
        return 300;
      case ConversionQuality.print:
        return 600;
    }
  }

  String get label {
    switch (this) {
      case ConversionQuality.low:
        return 'Low (Small file)';
      case ConversionQuality.medium:
        return 'Medium (Balanced)';
      case ConversionQuality.high:
        return 'High (Recommended)';
      case ConversionQuality.print:
        return 'Print Quality';
    }
  }
}

import '../exceptions/app_exception.dart';
