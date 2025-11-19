import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:syncfusion_flutter_pdf/pdf.dart';

/// PDF merger service
/// Combines multiple PDF files into one
class PdfMergerService {
  static final PdfMergerService _instance = PdfMergerService._internal();
  factory PdfMergerService() => _instance;
  PdfMergerService._internal();

  /// Merge multiple PDFs into one
  Future<String> mergePdfs(
    List<String> pdfPaths, {
    String? outputFileName,
  }) async {
    try {
      debugPrint('🔗 Merging ${pdfPaths.length} PDFs...');

      if (pdfPaths.isEmpty) {
        throw Exception('No PDFs to merge');
      }

      if (pdfPaths.length == 1) {
        debugPrint('⚠️ Only one PDF provided, returning original');
        return pdfPaths.first;
      }

      // Create new PDF document for merging
      final PdfDocument mergedDocument = PdfDocument();

      // Load and merge each PDF
      for (int i = 0; i < pdfPaths.length; i++) {
        debugPrint('   Adding PDF ${i + 1}/${pdfPaths.length}...');

        // Load source PDF
        final pdfBytes = await File(pdfPaths[i]).readAsBytes();
        final PdfDocument sourceDocument = PdfDocument(inputBytes: pdfBytes);

        // Import all pages from source PDF
        mergedDocument.importPages(sourceDocument, 0, sourceDocument.pages.count - 1);

        // Dispose source document
        sourceDocument.dispose();
      }

      // Save merged PDF
      final outputPath = await _getOutputPath(outputFileName ?? 'merged');
      final List<int> savedBytes = await mergedDocument.save();
      mergedDocument.dispose();

      await File(outputPath).writeAsBytes(savedBytes);

      debugPrint('✅ PDFs merged: $outputPath');
      return outputPath;
    } catch (e) {
      debugPrint('❌ PDF merge failed: $e');
      rethrow;
    }
  }

  /// Merge specific pages from multiple PDFs
  Future<String> mergePages(
    Map<String, List<int>> pdfPagesMap, {
    String? outputFileName,
  }) async {
    try {
      debugPrint('🔗 Merging specific pages from ${pdfPagesMap.length} PDFs...');

      final PdfDocument mergedDocument = PdfDocument();

      // For each PDF and its pages
      for (final entry in pdfPagesMap.entries) {
        final pdfPath = entry.key;
        final pageNumbers = entry.value;

        debugPrint('   Adding ${pageNumbers.length} pages from ${path.basename(pdfPath)}...');

        // Load source PDF
        final pdfBytes = await File(pdfPath).readAsBytes();
        final PdfDocument sourceDocument = PdfDocument(inputBytes: pdfBytes);

        // Import specific pages (convert to 0-based index)
        for (final pageNum in pageNumbers) {
          final pageIndex = pageNum - 1; // Convert to 0-based
          if (pageIndex >= 0 && pageIndex < sourceDocument.pages.count) {
            mergedDocument.importPages(sourceDocument, pageIndex, pageIndex);
          }
        }

        sourceDocument.dispose();
      }

      // Save merged PDF
      final outputPath = await _getOutputPath(outputFileName ?? 'merged_pages');
      final List<int> savedBytes = await mergedDocument.save();
      mergedDocument.dispose();

      await File(outputPath).writeAsBytes(savedBytes);

      debugPrint('✅ Pages merged: $outputPath');
      return outputPath;
    } catch (e) {
      debugPrint('❌ Page merge failed: $e');
      rethrow;
    }
  }

  /// Append one PDF to another
  Future<String> appendPdf(
    String basePdfPath,
    String appendPdfPath,
  ) async {
    try {
      debugPrint('➕ Appending PDF to base PDF...');

      return await mergePdfs([basePdfPath, appendPdfPath]);
    } catch (e) {
      debugPrint('❌ PDF append failed: $e');
      rethrow;
    }
  }

  /// Insert PDF pages at specific position
  Future<String> insertPdf(
    String basePdfPath,
    String insertPdfPath, {
    required int atPage,
  }) async {
    try {
      debugPrint('📥 Inserting PDF at page $atPage...');

      // Load base PDF
      final basePdfBytes = await File(basePdfPath).readAsBytes();
      final PdfDocument baseDocument = PdfDocument(inputBytes: basePdfBytes);

      // Load insert PDF
      final insertPdfBytes = await File(insertPdfPath).readAsBytes();
      final PdfDocument insertDocument = PdfDocument(inputBytes: insertPdfBytes);

      // Create output document
      final PdfDocument outputDocument = PdfDocument();

      // Copy pages before insertion point
      if (atPage > 1) {
        outputDocument.importPages(baseDocument, 0, atPage - 2);
      }

      // Insert the new PDF
      outputDocument.importPages(insertDocument, 0, insertDocument.pages.count - 1);

      // Copy remaining pages from base
      if (atPage - 1 < baseDocument.pages.count) {
        outputDocument.importPages(baseDocument, atPage - 1, baseDocument.pages.count - 1);
      }

      // Save output PDF
      final outputPath = await _getOutputPath('inserted');
      final List<int> savedBytes = await outputDocument.save();

      // Dispose documents
      baseDocument.dispose();
      insertDocument.dispose();
      outputDocument.dispose();

      await File(outputPath).writeAsBytes(savedBytes);

      debugPrint('✅ PDF inserted: $outputPath');
      return outputPath;
    } catch (e) {
      debugPrint('❌ PDF insertion failed: $e');
      rethrow;
    }
  }

  /// Helper method to generate output path
  Future<String> _getOutputPath(String baseName) async {
    final appDir = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fileName = '${baseName}_$timestamp.pdf';
    return path.join(appDir.path, fileName);
  }
}
