import 'dart:io';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
import '../models/analysis_result.dart';
import 'dart:developer' as developer;

/// Сервис для экспорта результатов анализа в PDF
class PdfExportService {
  /// Генерирует PDF отчет для результата анализа
  Future<Uint8List> generatePdfReport({
    required AnalysisResult analysis,
    String? imagePath,
    Uint8List? imageBytes,
  }) async {
    try {
      developer.log('Generating PDF report for: ${analysis.itemName}', name: 'PdfExportService');

      final pdf = pw.Document();

      // Load image if provided
      pw.ImageProvider? image;
      if (imageBytes != null) {
        image = pw.MemoryImage(imageBytes);
      } else if (imagePath != null && imagePath.startsWith('http')) {
        try {
          final response = await http.get(Uri.parse(imagePath));
          if (response.statusCode == 200) {
            image = pw.MemoryImage(response.bodyBytes);
          }
        } catch (e) {
          developer.log('Failed to load image: $e', name: 'PdfExportService');
        }
      } else if (imagePath != null) {
        try {
          final file = File(imagePath);
          if (await file.exists()) {
            image = pw.MemoryImage(await file.readAsBytes());
          }
        } catch (e) {
          developer.log('Failed to load local image: $e', name: 'PdfExportService');
        }
      }

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (context) => [
            _buildHeader(analysis),
            pw.SizedBox(height: 20),
            if (image != null) ...[
              _buildImage(image),
              pw.SizedBox(height: 20),
            ],
            _buildItemInfo(analysis),
            pw.SizedBox(height: 20),
            if (analysis.priceEstimate != null) ...[
              _buildPriceEstimate(analysis.priceEstimate!),
              pw.SizedBox(height: 20),
            ],
            _buildMaterialsSection(analysis.materials),
            pw.SizedBox(height: 20),
            _buildHistoricalContext(analysis),
            pw.SizedBox(height: 20),
            if (analysis.authenticityNotes != null) ...[
              _buildAuthenticity(analysis.authenticityNotes!),
              pw.SizedBox(height: 20),
            ],
            if (analysis.warnings.isNotEmpty) ...[
              _buildWarnings(analysis.warnings),
              pw.SizedBox(height: 20),
            ],
            _buildFooter(),
          ],
        ),
      );

      developer.log('PDF generated successfully', name: 'PdfExportService');
      return pdf.save();
    } catch (e, stackTrace) {
      developer.log(
        'Error generating PDF: $e',
        name: 'PdfExportService',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  pw.Widget _buildHeader(AnalysisResult analysis) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Antique Identification Report',
          style: pw.TextStyle(
            fontSize: 24,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.amber700,
          ),
        ),
        pw.SizedBox(height: 8),
        pw.Text(
          analysis.itemName,
          style: pw.TextStyle(
            fontSize: 20,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        if (analysis.category != null)
          pw.Text(
            'Category: ${analysis.category}',
            style: const pw.TextStyle(
              fontSize: 14,
              color: PdfColors.grey700,
            ),
          ),
        pw.Divider(thickness: 2, color: PdfColors.amber700),
      ],
    );
  }

  pw.Widget _buildImage(pw.ImageProvider image) {
    return pw.Center(
      child: pw.Container(
        constraints: const pw.BoxConstraints(
          maxHeight: 300,
          maxWidth: 400,
        ),
        child: pw.Image(image, fit: pw.BoxFit.contain),
      ),
    );
  }

  pw.Widget _buildItemInfo(AnalysisResult analysis) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Description',
          style: pw.TextStyle(
            fontSize: 16,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.amber800,
          ),
        ),
        pw.SizedBox(height: 8),
        pw.Text(
          analysis.description,
          style: const pw.TextStyle(fontSize: 12),
        ),
        if (analysis.estimatedPeriod != null || analysis.estimatedOrigin != null) ...[
          pw.SizedBox(height: 12),
          pw.Row(
            children: [
              if (analysis.estimatedPeriod != null)
                pw.Expanded(
                  child: _buildInfoBox('Period', analysis.estimatedPeriod!),
                ),
              if (analysis.estimatedOrigin != null) ...[
                pw.SizedBox(width: 12),
                pw.Expanded(
                  child: _buildInfoBox('Origin', analysis.estimatedOrigin!),
                ),
              ],
            ],
          ),
        ],
      ],
    );
  }

  pw.Widget _buildInfoBox(String label, String value) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: PdfColors.amber50,
        borderRadius: pw.BorderRadius.circular(8),
        border: pw.Border.all(color: PdfColors.amber200),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: 10,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.amber800,
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            value,
            style: const pw.TextStyle(fontSize: 11),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildPriceEstimate(analysis_priceEstimate) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: PdfColors.green50,
        borderRadius: pw.BorderRadius.circular(12),
        border: pw.Border.all(color: PdfColors.green300, width: 2),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Price Estimate',
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.green800,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            analysis_priceEstimate.getFormattedRange(),
            style: pw.TextStyle(
              fontSize: 20,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.green900,
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            'Confidence: ${analysis_priceEstimate.confidence.toUpperCase()}',
            style: const pw.TextStyle(
              fontSize: 11,
              color: PdfColors.grey700,
            ),
          ),
          pw.Text(
            'Based on: ${analysis_priceEstimate.basedOn}',
            style: const pw.TextStyle(
              fontSize: 10,
              color: PdfColors.grey600,
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildMaterialsSection(List materials) {
    if (materials.isEmpty) return pw.SizedBox();

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Materials',
          style: pw.TextStyle(
            fontSize: 16,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.amber800,
          ),
        ),
        pw.SizedBox(height: 8),
        ...materials.map((material) => pw.Container(
          margin: const pw.EdgeInsets.only(bottom: 8),
          padding: const pw.EdgeInsets.all(10),
          decoration: pw.BoxDecoration(
            color: PdfColors.grey100,
            borderRadius: pw.BorderRadius.circular(6),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                material.name,
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              if (material.description.isNotEmpty)
                pw.Text(
                  material.description,
                  style: const pw.TextStyle(fontSize: 10),
                ),
              if (material.era != null)
                pw.Text(
                  'Era: ${material.era}',
                  style: const pw.TextStyle(
                    fontSize: 9,
                    color: PdfColors.grey700,
                  ),
                ),
            ],
          ),
        )),
      ],
    );
  }

  pw.Widget _buildHistoricalContext(AnalysisResult analysis) {
    if (analysis.historicalContext.isEmpty) return pw.SizedBox();

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Historical Context',
          style: pw.TextStyle(
            fontSize: 16,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.amber800,
          ),
        ),
        pw.SizedBox(height: 8),
        pw.Container(
          padding: const pw.EdgeInsets.all(12),
          decoration: pw.BoxDecoration(
            color: PdfColors.blue50,
            borderRadius: pw.BorderRadius.circular(8),
            border: pw.Border.all(color: PdfColors.blue200),
          ),
          child: pw.Text(
            analysis.historicalContext,
            style: const pw.TextStyle(fontSize: 11),
            textAlign: pw.TextAlign.justify,
          ),
        ),
      ],
    );
  }

  pw.Widget _buildAuthenticity(String notes) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Authenticity Notes',
          style: pw.TextStyle(
            fontSize: 16,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.amber800,
          ),
        ),
        pw.SizedBox(height: 8),
        pw.Container(
          padding: const pw.EdgeInsets.all(12),
          decoration: pw.BoxDecoration(
            color: PdfColors.purple50,
            borderRadius: pw.BorderRadius.circular(8),
            border: pw.Border.all(color: PdfColors.purple200),
          ),
          child: pw.Text(
            notes,
            style: const pw.TextStyle(fontSize: 11),
          ),
        ),
      ],
    );
  }

  pw.Widget _buildWarnings(List<String> warnings) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: PdfColors.orange50,
        borderRadius: pw.BorderRadius.circular(8),
        border: pw.Border.all(color: PdfColors.orange300),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            children: [
              pw.Icon(
                const pw.IconData(0xe002), // Warning icon
                color: PdfColors.orange700,
                size: 16,
              ),
              pw.SizedBox(width: 8),
              pw.Text(
                'Important Disclaimers',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.orange800,
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 8),
          ...warnings.map((warning) => pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 4),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('• ', style: const pw.TextStyle(fontSize: 10)),
                pw.Expanded(
                  child: pw.Text(
                    warning,
                    style: const pw.TextStyle(fontSize: 10),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  pw.Widget _buildFooter() {
    final now = DateTime.now();
    final formattedDate = '${now.day}.${now.month}.${now.year}';

    return pw.Column(
      children: [
        pw.Divider(color: PdfColors.grey400),
        pw.SizedBox(height: 8),
        pw.Text(
          'Generated by Antique Identifier App on $formattedDate',
          style: const pw.TextStyle(
            fontSize: 9,
            color: PdfColors.grey600,
          ),
        ),
        pw.Text(
          'This report is for informational purposes only. Professional appraisal recommended for valuable items.',
          style: const pw.TextStyle(
            fontSize: 8,
            color: PdfColors.grey500,
          ),
          textAlign: pw.TextAlign.center,
        ),
      ],
    );
  }

  /// Сохраняет PDF и возвращает путь к файлу
  Future<String> savePdfToFile(Uint8List pdfBytes, String fileName) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$fileName.pdf');
      await file.writeAsBytes(pdfBytes);
      developer.log('PDF saved to: ${file.path}', name: 'PdfExportService');
      return file.path;
    } catch (e) {
      developer.log('Error saving PDF: $e', name: 'PdfExportService');
      rethrow;
    }
  }

  /// Делится PDF через системный диалог
  Future<void> sharePdf(Uint8List pdfBytes, String fileName) async {
    try {
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/$fileName.pdf');
      await file.writeAsBytes(pdfBytes);

      await Share.shareXFiles(
        [XFile(file.path)],
        subject: 'Antique Analysis Report: $fileName',
      );

      developer.log('PDF shared successfully', name: 'PdfExportService');
    } catch (e) {
      developer.log('Error sharing PDF: $e', name: 'PdfExportService');
      rethrow;
    }
  }

  /// Печатает PDF
  Future<void> printPdf(Uint8List pdfBytes) async {
    try {
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdfBytes,
      );
      developer.log('PDF sent to printer', name: 'PdfExportService');
    } catch (e) {
      developer.log('Error printing PDF: $e', name: 'PdfExportService');
      rethrow;
    }
  }

  /// Предпросмотр PDF перед сохранением
  Future<void> previewPdf(Uint8List pdfBytes, String title) async {
    try {
      await Printing.sharePdf(
        bytes: pdfBytes,
        filename: '$title.pdf',
      );
      developer.log('PDF preview opened', name: 'PdfExportService');
    } catch (e) {
      developer.log('Error previewing PDF: $e', name: 'PdfExportService');
      rethrow;
    }
  }
}
