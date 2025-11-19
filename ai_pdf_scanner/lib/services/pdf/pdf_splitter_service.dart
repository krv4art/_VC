import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:syncfusion_flutter_pdf/pdf.dart';

/// PDF splitter service
/// Splits PDF into multiple files or extracts specific pages
class PdfSplitterService {
  static final PdfSplitterService _instance = PdfSplitterService._internal();
  factory PdfSplitterService() => _instance;
  PdfSplitterService._internal();

  /// Split PDF into individual pages
  Future<List<String>> splitIntoPages(String pdfPath) async {
    try {
      debugPrint('✂️ Splitting PDF into individual pages...');

      final outputPaths = <String>[];

      // Load source PDF
      final pdfBytes = await File(pdfPath).readAsBytes();
      final PdfDocument sourceDocument = PdfDocument(inputBytes: pdfBytes);
      final totalPages = sourceDocument.pages.count;

      // Split each page into a separate PDF
      for (int i = 0; i < totalPages; i++) {
        // Create new PDF for this page
        final PdfDocument pageDocument = PdfDocument();
        pageDocument.importPages(sourceDocument, i, i);

        // Save page PDF
        final outputPath = await _getOutputPath('page_${i + 1}');
        final List<int> savedBytes = await pageDocument.save();
        pageDocument.dispose();

        await File(outputPath).writeAsBytes(savedBytes);
        outputPaths.add(outputPath);
      }

      sourceDocument.dispose();

      debugPrint('✅ PDF split into ${outputPaths.length} pages');
      return outputPaths;
    } catch (e) {
      debugPrint('❌ PDF split failed: $e');
      rethrow;
    }
  }

  /// Split PDF by page ranges
  /// Example: ranges = [[1,5], [6,10], [11,15]]
  Future<List<String>> splitByRanges(
    String pdfPath,
    List<List<int>> ranges,
  ) async {
    try {
      debugPrint('✂️ Splitting PDF into ${ranges.length} parts...');

      final outputPaths = <String>[];

      for (int i = 0; i < ranges.length; i++) {
        final range = ranges[i];
        final startPage = range[0];
        final endPage = range[1];

        debugPrint('   Creating part ${i + 1}: pages $startPage-$endPage');

        final outputPath = await _extractPages(
          pdfPath,
          startPage: startPage,
          endPage: endPage,
          suffix: 'part_${i + 1}',
        );

        outputPaths.add(outputPath);
      }

      debugPrint('✅ PDF split into ${outputPaths.length} parts');
      return outputPaths;
    } catch (e) {
      debugPrint('❌ PDF split by ranges failed: $e');
      rethrow;
    }
  }

  /// Split PDF every N pages
  Future<List<String>> splitEveryNPages(
    String pdfPath,
    int pagesPerFile,
  ) async {
    try {
      debugPrint('✂️ Splitting PDF every $pagesPerFile pages...');

      // TODO: Get total page count
      final totalPages = await _getPageCount(pdfPath);

      final ranges = <List<int>>[];
      for (int i = 1; i <= totalPages; i += pagesPerFile) {
        final endPage = (i + pagesPerFile - 1).clamp(1, totalPages);
        ranges.add([i, endPage]);
      }

      return await splitByRanges(pdfPath, ranges);
    } catch (e) {
      debugPrint('❌ PDF split every N pages failed: $e');
      rethrow;
    }
  }

  /// Extract specific pages from PDF
  Future<String> extractPages(
    String pdfPath, {
    required List<int> pageNumbers,
    String? outputFileName,
  }) async {
    try {
      debugPrint('📄 Extracting ${pageNumbers.length} pages from PDF...');

      // Sort page numbers
      final sortedPages = List<int>.from(pageNumbers)..sort();

      // Load source PDF
      final pdfBytes = await File(pdfPath).readAsBytes();
      final PdfDocument sourceDocument = PdfDocument(inputBytes: pdfBytes);
      final PdfDocument outputDocument = PdfDocument();

      // Extract specified pages
      for (final pageNum in sortedPages) {
        final pageIndex = pageNum - 1; // Convert to 0-based
        if (pageIndex >= 0 && pageIndex < sourceDocument.pages.count) {
          outputDocument.importPages(sourceDocument, pageIndex, pageIndex);
        }
      }

      // Save extracted pages
      final outputPath = await _getOutputPath(
        outputFileName ?? 'extracted_${sortedPages.first}_${sortedPages.last}',
      );
      final List<int> savedBytes = await outputDocument.save();
      sourceDocument.dispose();
      outputDocument.dispose();

      await File(outputPath).writeAsBytes(savedBytes);

      debugPrint('✅ Pages extracted: $outputPath');
      return outputPath;
    } catch (e) {
      debugPrint('❌ Page extraction failed: $e');
      rethrow;
    }
  }

  /// Extract pages by range
  Future<String> _extractPages(
    String pdfPath, {
    required int startPage,
    required int endPage,
    String? suffix,
  }) async {
    try {
      final fileName = path.basenameWithoutExtension(pdfPath);
      // Load source PDF
      final pdfBytes = await File(pdfPath).readAsBytes();
      final PdfDocument sourceDocument = PdfDocument(inputBytes: pdfBytes);
      final PdfDocument outputDocument = PdfDocument();

      // Extract page range (convert to 0-based)
      final startIndex = startPage - 1;
      final endIndex = endPage - 1;

      if (startIndex >= 0 && endIndex < sourceDocument.pages.count) {
        outputDocument.importPages(sourceDocument, startIndex, endIndex);
      }

      // Save extracted pages
      final outputPath = await _getOutputPath(
        '$fileName\_${suffix ?? 'extracted'}',
      );
      final List<int> savedBytes = await outputDocument.save();
      sourceDocument.dispose();
      outputDocument.dispose();

      await File(outputPath).writeAsBytes(savedBytes);

      return outputPath;
    } catch (e) {
      debugPrint('❌ Page extraction failed: $e');
      rethrow;
    }
  }

  /// Get PDF page count
  Future<int> _getPageCount(String pdfPath) async {
    try {
      final pdfBytes = await File(pdfPath).readAsBytes();
      final PdfDocument document = PdfDocument(inputBytes: pdfBytes);
      final pageCount = document.pages.count;
      document.dispose();
      return pageCount;
    } catch (e) {
      debugPrint('❌ Failed to get page count: $e');
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
