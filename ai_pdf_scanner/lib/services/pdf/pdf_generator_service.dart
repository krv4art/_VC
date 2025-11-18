import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:uuid/uuid.dart';
import '../../models/pdf_document.dart';
import '../scanning/scan_orchestrator_service.dart';
import '../../config/app_config.dart';

/// PDF generator service
/// Creates PDF documents from scanned images
class PdfGeneratorService {
  static final PdfGeneratorService _instance = PdfGeneratorService._internal();
  factory PdfGeneratorService() => _instance;
  PdfGeneratorService._internal();

  final _uuid = const Uuid();

  /// Generate PDF from scan session
  Future<PdfDocument> generateFromScanSession(
    ScanSession session, {
    String? title,
    PdfQuality quality = PdfQuality.high,
    bool addMetadata = true,
  }) async {
    try {
      debugPrint('📄 Generating PDF from scan session...');
      debugPrint('   Pages: ${session.pages.length}');

      // Create PDF document
      final pdf = pw.Document();

      // Add pages to PDF
      for (final scannedPage in session.pages) {
        await _addPageToPdf(pdf, scannedPage, quality);
      }

      // Get output path
      final outputPath = await _getOutputPath(title);

      // Save PDF file
      final file = File(outputPath);
      await file.writeAsBytes(await pdf.save());

      // Generate thumbnail (first page)
      final thumbnailPath = await _generatePdfThumbnail(session.pages.first);

      // Create PdfDocument model
      final pdfDocument = PdfDocument(
        id: _uuid.v4(),
        title: title ?? 'Scanned Document ${DateTime.now().toString().split(' ')[0]}',
        filePath: outputPath,
        thumbnailPath: thumbnailPath,
        documentType: DocumentType.scanned,
        pageCount: session.pages.length,
        fileSize: await file.length(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isFavorite: false,
        tags: [],
        aiMetadata: addMetadata ? {
          'scan_session_id': session.id,
          'scan_duration_seconds': session.duration.inSeconds,
        } : null,
      );

      debugPrint('✅ PDF generated: ${pdfDocument.filePath}');
      debugPrint('   File size: ${pdfDocument.fileSizeFormatted}');

      return pdfDocument;
    } catch (e) {
      debugPrint('❌ PDF generation failed: $e');
      rethrow;
    }
  }

  /// Generate PDF from image files
  Future<PdfDocument> generateFromImages(
    List<String> imagePaths, {
    String? title,
    PdfQuality quality = PdfQuality.high,
  }) async {
    try {
      debugPrint('📄 Generating PDF from ${imagePaths.length} images...');

      // Create PDF document
      final pdf = pw.Document();

      // Add images to PDF
      for (final imagePath in imagePaths) {
        await _addImageToPdf(pdf, imagePath, quality);
      }

      // Get output path
      final outputPath = await _getOutputPath(title);

      // Save PDF file
      final file = File(outputPath);
      await file.writeAsBytes(await pdf.save());

      // Generate thumbnail
      final thumbnailPath = await _generateImageThumbnail(imagePaths.first);

      // Create PdfDocument model
      final pdfDocument = PdfDocument(
        id: _uuid.v4(),
        title: title ?? 'Document ${DateTime.now().toString().split(' ')[0]}',
        filePath: outputPath,
        thumbnailPath: thumbnailPath,
        documentType: DocumentType.converted,
        pageCount: imagePaths.length,
        fileSize: await file.length(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isFavorite: false,
        tags: [],
      );

      debugPrint('✅ PDF generated: ${pdfDocument.filePath}');
      return pdfDocument;
    } catch (e) {
      debugPrint('❌ PDF generation failed: $e');
      rethrow;
    }
  }

  /// Add scanned page to PDF
  Future<void> _addPageToPdf(
    pw.Document pdf,
    ScannedPage scannedPage,
    PdfQuality quality,
  ) async {
    try {
      // Read image file
      final imageFile = File(scannedPage.processedPath);
      final imageBytes = await imageFile.readAsBytes();
      final image = pw.MemoryImage(imageBytes);

      // Add page with image
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Image(image, fit: pw.BoxFit.contain),
            );
          },
        ),
      );
    } catch (e) {
      debugPrint('❌ Failed to add page ${scannedPage.pageNumber} to PDF: $e');
      rethrow;
    }
  }

  /// Add image to PDF
  Future<void> _addImageToPdf(
    pw.Document pdf,
    String imagePath,
    PdfQuality quality,
  ) async {
    try {
      // Read image file
      final imageFile = File(imagePath);
      final imageBytes = await imageFile.readAsBytes();
      final image = pw.MemoryImage(imageBytes);

      // Add page with image
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Image(image, fit: pw.BoxFit.contain),
            );
          },
        ),
      );
    } catch (e) {
      debugPrint('❌ Failed to add image to PDF: $e');
      rethrow;
    }
  }

  /// Get output path for PDF file
  Future<String> _getOutputPath(String? title) async {
    final appDir = await getApplicationDocumentsDirectory();
    final pdfDir = Directory(path.join(appDir.path, AppConfig.localPdfPath));

    // Create directory if it doesn't exist
    if (!await pdfDir.exists()) {
      await pdfDir.create(recursive: true);
    }

    // Generate filename
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final sanitizedTitle = title?.replaceAll(RegExp(r'[^\w\s-]'), '_') ?? 'document';
    final filename = '${sanitizedTitle}_$timestamp.pdf';

    return path.join(pdfDir.path, filename);
  }

  /// Generate thumbnail from scanned page
  Future<String> _generatePdfThumbnail(ScannedPage page) async {
    // For now, just copy the existing thumbnail
    // In production, you might want to generate a new one from the PDF
    return page.thumbnailPath;
  }

  /// Generate thumbnail from image
  Future<String> _generateImageThumbnail(String imagePath) async {
    // For now, just return the image path
    // In production, generate a proper thumbnail
    return imagePath;
  }

  /// Create empty PDF document
  Future<String> createEmptyPdf(String title) async {
    try {
      final pdf = pw.Document();

      // Add empty page
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Text(
                title,
                style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
              ),
            );
          },
        ),
      );

      final outputPath = await _getOutputPath(title);
      final file = File(outputPath);
      await file.writeAsBytes(await pdf.save());

      debugPrint('✅ Empty PDF created: $outputPath');
      return outputPath;
    } catch (e) {
      debugPrint('❌ Failed to create empty PDF: $e');
      rethrow;
    }
  }
}

/// PDF quality levels
enum PdfQuality {
  low,
  medium,
  high,
  maximum,
}

extension PdfQualityExtension on PdfQuality {
  /// Get compression quality (0-100)
  int get compressionQuality {
    switch (this) {
      case PdfQuality.low:
        return 40;
      case PdfQuality.medium:
        return 60;
      case PdfQuality.high:
        return 80;
      case PdfQuality.maximum:
        return 95;
    }
  }

  /// Get display name
  String get displayName {
    switch (this) {
      case PdfQuality.low:
        return 'Low (Smallest Size)';
      case PdfQuality.medium:
        return 'Medium';
      case PdfQuality.high:
        return 'High (Recommended)';
      case PdfQuality.maximum:
        return 'Maximum (Best Quality)';
    }
  }
}
