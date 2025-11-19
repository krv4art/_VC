import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:syncfusion_flutter_pdf/pdf.dart';

/// PDF compressor service
/// Reduces PDF file size while maintaining quality
class PdfCompressorService {
  static final PdfCompressorService _instance = PdfCompressorService._internal();
  factory PdfCompressorService() => _instance;
  PdfCompressorService._internal();

  /// Compress PDF with specified quality level
  Future<String> compressPdf(
    String pdfPath, {
    CompressionLevel level = CompressionLevel.medium,
  }) async {
    try {
      final originalSize = await File(pdfPath).length();
      debugPrint('🗜️ Compressing PDF (${_formatSize(originalSize)})...');
      debugPrint('   Compression level: ${level.name}');

      final outputPath = await _getOutputPath(pdfPath, '_compressed');

      // Load existing PDF
      final pdfFile = File(pdfPath);
      final pdfBytes = await pdfFile.readAsBytes();
      final PdfDocument document = PdfDocument(inputBytes: pdfBytes);

      // Configure compression options based on level
      final compressionOptions = PdfCompressionOptions();
      compressionOptions.compressImages = true;
      compressionOptions.optimizeFont = true;
      compressionOptions.optimizePageContents = true;
      compressionOptions.removeMetadata = level == CompressionLevel.maximum;

      // Set image quality based on compression level
      compressionOptions.imageQuality = level.imageQuality;

      // Apply compression
      document.compressionOptions = compressionOptions;
      document.compress();

      // Save compressed PDF
      final List<int> savedBytes = await document.save();
      document.dispose();

      await File(outputPath).writeAsBytes(savedBytes);

      final compressedSize = await File(outputPath).length();
      final reduction = ((1 - compressedSize / originalSize) * 100).toStringAsFixed(1);

      debugPrint('✅ PDF compressed: $outputPath');
      debugPrint('   Original: ${_formatSize(originalSize)}');
      debugPrint('   Compressed: ${_formatSize(compressedSize)}');
      debugPrint('   Reduction: $reduction%');

      return outputPath;
    } catch (e) {
      debugPrint('❌ PDF compression failed: $e');
      rethrow;
    }
  }

  /// Compress PDF to target file size (in bytes)
  Future<String> compressToSize(
    String pdfPath, {
    required int targetSizeBytes,
  }) async {
    try {
      final originalSize = await File(pdfPath).length();
      debugPrint('🗜️ Compressing PDF to target size: ${_formatSize(targetSizeBytes)}...');
      debugPrint('   Original size: ${_formatSize(originalSize)}');

      if (originalSize <= targetSizeBytes) {
        debugPrint('⚠️ PDF already smaller than target size');
        return pdfPath;
      }

      // Calculate required compression ratio
      final compressionRatio = targetSizeBytes / originalSize;
      debugPrint('   Required compression: ${(compressionRatio * 100).toStringAsFixed(1)}%');

      // Determine compression level based on ratio
      CompressionLevel level;
      if (compressionRatio > 0.8) {
        level = CompressionLevel.low;
      } else if (compressionRatio > 0.6) {
        level = CompressionLevel.medium;
      } else if (compressionRatio > 0.4) {
        level = CompressionLevel.high;
      } else {
        level = CompressionLevel.maximum;
      }

      return await compressPdf(pdfPath, level: level);
    } catch (e) {
      debugPrint('❌ PDF compression to size failed: $e');
      rethrow;
    }
  }

  /// Optimize PDF for web (faster loading)
  Future<String> optimizeForWeb(String pdfPath) async {
    try {
      debugPrint('🌐 Optimizing PDF for web...');

      final outputPath = await _getOutputPath(pdfPath, '_web');

      // Load PDF
      final pdfBytes = await File(pdfPath).readAsBytes();
      final PdfDocument document = PdfDocument(inputBytes: pdfBytes);

      // Optimize for web viewing
      final compressionOptions = PdfCompressionOptions();
      compressionOptions.compressImages = true;
      compressionOptions.optimizeFont = true;
      compressionOptions.optimizePageContents = true;
      compressionOptions.removeMetadata = true;
      compressionOptions.imageQuality = 70; // Medium quality for web

      document.compressionOptions = compressionOptions;
      document.compress();

      // Save optimized PDF
      final savedBytes = await document.save();
      document.dispose();
      await File(outputPath).writeAsBytes(savedBytes);

      debugPrint('✅ PDF optimized for web: $outputPath');
      return outputPath;
    } catch (e) {
      debugPrint('❌ PDF web optimization failed: $e');
      rethrow;
    }
  }

  /// Remove metadata from PDF
  Future<String> removeMetadata(String pdfPath) async {
    try {
      debugPrint('🧹 Removing metadata from PDF...');

      final outputPath = await _getOutputPath(pdfPath, '_clean');

      // Load PDF
      final pdfBytes = await File(pdfPath).readAsBytes();
      final PdfDocument document = PdfDocument(inputBytes: pdfBytes);

      // Remove metadata
      document.documentInformation.title = '';
      document.documentInformation.author = '';
      document.documentInformation.subject = '';
      document.documentInformation.keywords = '';
      document.documentInformation.creator = '';
      document.documentInformation.producer = '';

      // Save PDF without metadata
      final savedBytes = await document.save();
      document.dispose();
      await File(outputPath).writeAsBytes(savedBytes);

      debugPrint('✅ Metadata removed: $outputPath');
      return outputPath;
    } catch (e) {
      debugPrint('❌ Metadata removal failed: $e');
      rethrow;
    }
  }

  /// Optimize images in PDF
  Future<String> optimizeImages(
    String pdfPath, {
    int imageQuality = 70,
  }) async {
    try {
      debugPrint('🖼️ Optimizing images in PDF (quality: $imageQuality)...');

      final outputPath = await _getOutputPath(pdfPath, '_optimized');

      // Load PDF
      final pdfBytes = await File(pdfPath).readAsBytes();
      final PdfDocument document = PdfDocument(inputBytes: pdfBytes);

      // Configure image compression
      final compressionOptions = PdfCompressionOptions();
      compressionOptions.compressImages = true;
      compressionOptions.imageQuality = imageQuality;
      compressionOptions.optimizeFont = false; // Only optimize images
      compressionOptions.optimizePageContents = false;

      document.compressionOptions = compressionOptions;
      document.compress();

      // Save optimized PDF
      final savedBytes = await document.save();
      document.dispose();
      await File(outputPath).writeAsBytes(savedBytes);

      debugPrint('✅ Images optimized: $outputPath');
      return outputPath;
    } catch (e) {
      debugPrint('❌ Image optimization failed: $e');
      rethrow;
    }
  }

  /// Helper method to format file size
  String _formatSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }

  /// Helper method to generate output path
  Future<String> _getOutputPath(String originalPath, String suffix) async {
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = path.basenameWithoutExtension(originalPath);
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final newFileName = '$fileName$suffix\_$timestamp.pdf';
    return path.join(appDir.path, newFileName);
  }
}

/// PDF compression levels
enum CompressionLevel {
  low,
  medium,
  high,
  maximum,
}

extension CompressionLevelExtension on CompressionLevel {
  /// Get image quality for this compression level
  int get imageQuality {
    switch (this) {
      case CompressionLevel.low:
        return 85;
      case CompressionLevel.medium:
        return 70;
      case CompressionLevel.high:
        return 55;
      case CompressionLevel.maximum:
        return 40;
    }
  }

  /// Get display name
  String get displayName {
    switch (this) {
      case CompressionLevel.low:
        return 'Low (Best Quality)';
      case CompressionLevel.medium:
        return 'Medium (Recommended)';
      case CompressionLevel.high:
        return 'High';
      case CompressionLevel.maximum:
        return 'Maximum (Smallest Size)';
    }
  }
}
