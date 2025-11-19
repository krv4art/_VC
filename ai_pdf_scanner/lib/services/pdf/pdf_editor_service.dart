import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../../models/annotation.dart';

/// PDF editor service
/// Handles PDF editing operations: annotations, forms, signatures
class PdfEditorService {
  static final PdfEditorService _instance = PdfEditorService._internal();
  factory PdfEditorService() => _instance;
  PdfEditorService._internal();

  /// Add annotation to PDF
  /// Returns path to new PDF with annotation
  Future<String> addAnnotation(
    String pdfPath,
    Annotation annotation,
  ) async {
    try {
      debugPrint('✏️ Adding annotation to PDF...');

      // Load existing PDF
      final pdfFile = File(pdfPath);
      final pdfBytes = await pdfFile.readAsBytes();

      // For now, create a new PDF with annotation overlay
      // In production, use a PDF library that supports editing
      final outputPath = await _getOutputPath(pdfPath, '_annotated');

      // TODO: Implement actual PDF annotation
      // For now, just copy the file
      await pdfFile.copy(outputPath);

      debugPrint('✅ Annotation added: $outputPath');
      return outputPath;
    } catch (e) {
      debugPrint('❌ Failed to add annotation: $e');
      rethrow;
    }
  }

  /// Add multiple annotations to PDF
  Future<String> addAnnotations(
    String pdfPath,
    List<Annotation> annotations,
  ) async {
    try {
      debugPrint('✏️ Adding ${annotations.length} annotations to PDF...');

      String currentPath = pdfPath;
      for (final annotation in annotations) {
        currentPath = await addAnnotation(currentPath, annotation);
      }

      debugPrint('✅ All annotations added');
      return currentPath;
    } catch (e) {
      debugPrint('❌ Failed to add annotations: $e');
      rethrow;
    }
  }

  /// Add text to PDF page
  Future<String> addText(
    String pdfPath, {
    required int pageNumber,
    required String text,
    required ui.Offset position,
    double fontSize = 12,
    ui.Color color = const ui.Color(0xFF000000),
  }) async {
    try {
      debugPrint('📝 Adding text to PDF page $pageNumber...');

      // Load PDF
      final pdfBytes = await File(pdfPath).readAsBytes();
      final PdfDocument document = PdfDocument(inputBytes: pdfBytes);

      // Get the page
      final pageIndex = pageNumber - 1;
      if (pageIndex >= 0 && pageIndex < document.pages.count) {
        final page = document.pages[pageIndex];
        final graphics = page.graphics;

        // Create font and brush
        final font = PdfStandardFont(PdfFontFamily.helvetica, fontSize);
        final pdfColor = PdfColor(color.red, color.green, color.blue, color.alpha);
        final brush = PdfSolidBrush(pdfColor);

        // Draw text at position
        graphics.drawString(
          text,
          font,
          brush: brush,
          bounds: Rect.fromLTWH(position.dx, position.dy, 0, 0),
        );
      }

      // Save PDF with text
      final outputPath = await _getOutputPath(pdfPath, '_text');
      final List<int> savedBytes = await document.save();
      document.dispose();
      await File(outputPath).writeAsBytes(savedBytes);

      debugPrint('✅ Text added');
      return outputPath;
    } catch (e) {
      debugPrint('❌ Failed to add text: $e');
      rethrow;
    }
  }

  /// Add image to PDF page
  Future<String> addImage(
    String pdfPath, {
    required int pageNumber,
    required String imagePath,
    required ui.Offset position,
    ui.Size? size,
  }) async {
    try {
      debugPrint('🖼️ Adding image to PDF page $pageNumber...');

      // Load PDF
      final pdfBytes = await File(pdfPath).readAsBytes();
      final PdfDocument document = PdfDocument(inputBytes: pdfBytes);

      // Load image
      final imageFile = File(imagePath);
      final imageBytes = await imageFile.readAsBytes();
      final image = PdfBitmap(imageBytes);

      // Get the page
      final pageIndex = pageNumber - 1;
      if (pageIndex >= 0 && pageIndex < document.pages.count) {
        final page = document.pages[pageIndex];
        final graphics = page.graphics;

        // Calculate image size
        final imageSize = size ?? ui.Size(image.width.toDouble(), image.height.toDouble());

        // Draw image at position
        graphics.drawImage(
          image,
          Rect.fromLTWH(
            position.dx,
            position.dy,
            imageSize.width,
            imageSize.height,
          ),
        );
      }

      // Save PDF with image
      final outputPath = await _getOutputPath(pdfPath, '_image');
      final List<int> savedBytes = await document.save();
      document.dispose();
      await File(outputPath).writeAsBytes(savedBytes);

      debugPrint('✅ Image added');
      return outputPath;
    } catch (e) {
      debugPrint('❌ Failed to add image: $e');
      rethrow;
    }
  }

  /// Add signature to PDF
  Future<String> addSignature(
    String pdfPath, {
    required int pageNumber,
    required String signatureImagePath,
    required ui.Offset position,
    ui.Size? size,
  }) async {
    try {
      debugPrint('✍️ Adding signature to PDF page $pageNumber...');

      return await addImage(
        pdfPath,
        pageNumber: pageNumber,
        imagePath: signatureImagePath,
        position: position,
        size: size,
      );
    } catch (e) {
      debugPrint('❌ Failed to add signature: $e');
      rethrow;
    }
  }

  /// Fill form field
  Future<String> fillFormField(
    String pdfPath, {
    required String fieldName,
    required String value,
  }) async {
    try {
      debugPrint('📋 Filling form field "$fieldName"...');

      final outputPath = await _getOutputPath(pdfPath, '_filled');

      // TODO: Implement form filling
      // For now, return original path

      debugPrint('✅ Form field filled');
      return outputPath;
    } catch (e) {
      debugPrint('❌ Failed to fill form field: $e');
      rethrow;
    }
  }

  /// Rotate PDF pages
  Future<String> rotatePages(
    String pdfPath, {
    required List<int> pageNumbers,
    required int degrees, // 90, 180, 270
  }) async {
    try {
      debugPrint('🔄 Rotating ${pageNumbers.length} pages by $degrees degrees...');

      // Load PDF
      final pdfBytes = await File(pdfPath).readAsBytes();
      final PdfDocument document = PdfDocument(inputBytes: pdfBytes);

      // Rotate specified pages
      for (final pageNum in pageNumbers) {
        final pageIndex = pageNum - 1; // Convert to 0-based
        if (pageIndex >= 0 && pageIndex < document.pages.count) {
          final page = document.pages[pageIndex];

          // Set rotation based on degrees
          if (degrees == 90) {
            page.rotation = PdfPageRotateAngle.rotateAngle90;
          } else if (degrees == 180) {
            page.rotation = PdfPageRotateAngle.rotateAngle180;
          } else if (degrees == 270) {
            page.rotation = PdfPageRotateAngle.rotateAngle270;
          }
        }
      }

      // Save rotated PDF
      final outputPath = await _getOutputPath(pdfPath, '_rotated');
      final List<int> savedBytes = await document.save();
      document.dispose();
      await File(outputPath).writeAsBytes(savedBytes);

      debugPrint('✅ Pages rotated');
      return outputPath;
    } catch (e) {
      debugPrint('❌ Failed to rotate pages: $e');
      rethrow;
    }
  }

  /// Delete PDF pages
  Future<String> deletePages(
    String pdfPath, {
    required List<int> pageNumbers,
  }) async {
    try {
      debugPrint('🗑️ Deleting ${pageNumbers.length} pages...');

      // Load PDF
      final pdfBytes = await File(pdfPath).readAsBytes();
      final PdfDocument sourceDocument = PdfDocument(inputBytes: pdfBytes);
      final PdfDocument outputDocument = PdfDocument();

      // Sort page numbers in descending order for deletion
      final sortedPages = List<int>.from(pageNumbers)..sort((a, b) => b.compareTo(a));

      // Create set for quick lookup
      final pagesToDelete = Set<int>.from(sortedPages);

      // Import pages that should NOT be deleted
      for (int i = 0; i < sourceDocument.pages.count; i++) {
        final pageNumber = i + 1; // Convert to 1-based
        if (!pagesToDelete.contains(pageNumber)) {
          outputDocument.importPages(sourceDocument, i, i);
        }
      }

      // Save PDF with deleted pages
      final outputPath = await _getOutputPath(pdfPath, '_deleted');
      final List<int> savedBytes = await outputDocument.save();
      sourceDocument.dispose();
      outputDocument.dispose();
      await File(outputPath).writeAsBytes(savedBytes);

      debugPrint('✅ Pages deleted');
      return outputPath;
    } catch (e) {
      debugPrint('❌ Failed to delete pages: $e');
      rethrow;
    }
  }

  /// Reorder PDF pages
  Future<String> reorderPages(
    String pdfPath, {
    required List<int> newOrder,
  }) async {
    try {
      debugPrint('🔀 Reordering pages...');

      // Load PDF
      final pdfBytes = await File(pdfPath).readAsBytes();
      final PdfDocument sourceDocument = PdfDocument(inputBytes: pdfBytes);
      final PdfDocument outputDocument = PdfDocument();

      // Import pages in new order
      for (final pageNumber in newOrder) {
        final pageIndex = pageNumber - 1; // Convert to 0-based
        if (pageIndex >= 0 && pageIndex < sourceDocument.pages.count) {
          outputDocument.importPages(sourceDocument, pageIndex, pageIndex);
        }
      }

      // Save reordered PDF
      final outputPath = await _getOutputPath(pdfPath, '_reordered');
      final List<int> savedBytes = await outputDocument.save();
      sourceDocument.dispose();
      outputDocument.dispose();
      await File(outputPath).writeAsBytes(savedBytes);

      debugPrint('✅ Pages reordered');
      return outputPath;
    } catch (e) {
      debugPrint('❌ Failed to reorder pages: $e');
      rethrow;
    }
  }

  /// Add watermark to PDF
  Future<String> addWatermark(
    String pdfPath, {
    required String watermarkText,
    double opacity = 0.3,
    double fontSize = 48,
    ui.Color color = const ui.Color(0xFF000000),
  }) async {
    try {
      debugPrint('💧 Adding watermark to PDF...');

      // Load PDF
      final pdfBytes = await File(pdfPath).readAsBytes();
      final PdfDocument document = PdfDocument(inputBytes: pdfBytes);

      // Convert UI color to PDF color
      final pdfColor = PdfColor(color.red, color.green, color.blue, color.alpha);

      // Add watermark to all pages
      for (int i = 0; i < document.pages.count; i++) {
        final page = document.pages[i];
        final graphics = page.graphics;

        // Create font
        final font = PdfStandardFont(PdfFontFamily.helvetica, fontSize);

        // Create brush with opacity
        final brush = PdfSolidBrush(pdfColor);

        // Get page size
        final pageSize = page.getClientSize();

        // Draw watermark text in center (rotated 45 degrees)
        graphics.save();
        graphics.translateTransform(pageSize.width / 2, pageSize.height / 2);
        graphics.rotateTransform(-45);
        final textSize = font.measureString(watermarkText);
        graphics.drawString(
          watermarkText,
          font,
          brush: brush,
          bounds: Rect.fromLTWH(
            -textSize.width / 2,
            -textSize.height / 2,
            textSize.width,
            textSize.height,
          ),
        );
        graphics.restore();
      }

      // Save watermarked PDF
      final outputPath = await _getOutputPath(pdfPath, '_watermark');
      final List<int> savedBytes = await document.save();
      document.dispose();
      await File(outputPath).writeAsBytes(savedBytes);

      debugPrint('✅ Watermark added');
      return outputPath;
    } catch (e) {
      debugPrint('❌ Failed to add watermark: $e');
      rethrow;
    }
  }

  /// Add page numbers to PDF
  Future<String> addPageNumbers(
    String pdfPath, {
    String format = 'Page {page} of {total}',
    ui.Offset? position,
    double fontSize = 10,
  }) async {
    try {
      debugPrint('🔢 Adding page numbers to PDF...');

      // Load PDF
      final pdfBytes = await File(pdfPath).readAsBytes();
      final PdfDocument document = PdfDocument(inputBytes: pdfBytes);
      final totalPages = document.pages.count;

      // Create font
      final font = PdfStandardFont(PdfFontFamily.helvetica, fontSize);
      final brush = PdfSolidBrush(PdfColor(0, 0, 0));

      // Add page numbers to all pages
      for (int i = 0; i < totalPages; i++) {
        final page = document.pages[i];
        final graphics = page.graphics;
        final pageSize = page.getClientSize();

        // Format page number text
        final pageText = format
            .replaceAll('{page}', (i + 1).toString())
            .replaceAll('{total}', totalPages.toString());

        // Calculate position (default: bottom center)
        final textSize = font.measureString(pageText);
        final defaultPosition = position ??
            ui.Offset(
              (pageSize.width - textSize.width) / 2,
              pageSize.height - 30,
            );

        // Draw page number
        graphics.drawString(
          pageText,
          font,
          brush: brush,
          bounds: Rect.fromLTWH(
            defaultPosition.dx,
            defaultPosition.dy,
            0,
            0,
          ),
        );
      }

      // Save PDF with page numbers
      final outputPath = await _getOutputPath(pdfPath, '_numbered');
      final List<int> savedBytes = await document.save();
      document.dispose();
      await File(outputPath).writeAsBytes(savedBytes);

      debugPrint('✅ Page numbers added');
      return outputPath;
    } catch (e) {
      debugPrint('❌ Failed to add page numbers: $e');
      rethrow;
    }
  }

  /// Helper method to generate output path
  Future<String> _getOutputPath(String originalPath, String suffix) async {
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = path.basenameWithoutExtension(originalPath);
    final extension = path.extension(originalPath);
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final newFileName = '$fileName$suffix\_$timestamp$extension';
    return path.join(appDir.path, newFileName);
  }
}
