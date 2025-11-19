import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import '../models/cover_letter.dart';
import 'package:intl/intl.dart';

/// Service for generating PDF from cover letter
class CoverLetterPdfService {
  /// Generate PDF document from cover letter
  Future<pw.Document> generatePdf(CoverLetter coverLetter) async {
    final pdf = pw.Document();

    // Load fonts
    final regular = await PdfGoogleFonts.robotoRegular();
    final bold = await PdfGoogleFonts.robotoBold();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(72),
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Sender information
            _buildSenderInfo(coverLetter, regular, bold),
            pw.SizedBox(height: 24),

            // Date
            pw.Text(
              DateFormat('MMMM d, yyyy').format(coverLetter.date),
              style: pw.TextStyle(font: regular, fontSize: 11),
            ),
            pw.SizedBox(height: 24),

            // Recipient information
            _buildRecipientInfo(coverLetter, regular, bold),
            pw.SizedBox(height: 24),

            // Salutation
            pw.Text(
              '${coverLetter.salutation},',
              style: pw.TextStyle(font: regular, fontSize: 11),
            ),
            pw.SizedBox(height: 16),

            // Body
            pw.Text(
              coverLetter.body,
              style: pw.TextStyle(font: regular, fontSize: 11, height: 1.6),
              textAlign: pw.TextAlign.justify,
            ),
            pw.SizedBox(height: 24),

            // Closing
            pw.Text(
              '${coverLetter.closing},',
              style: pw.TextStyle(font: regular, fontSize: 11),
            ),
            pw.SizedBox(height: 48),

            // Signature
            pw.Text(
              coverLetter.senderName,
              style: pw.TextStyle(font: bold, fontSize: 11),
            ),
          ],
        ),
      ),
    );

    return pdf;
  }

  pw.Widget _buildSenderInfo(CoverLetter coverLetter, pw.Font regular, pw.Font bold) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          coverLetter.senderName,
          style: pw.TextStyle(font: bold, fontSize: 12),
        ),
        if (coverLetter.senderAddress != null && coverLetter.senderAddress!.isNotEmpty) ...[
          pw.SizedBox(height: 4),
          pw.Text(
            coverLetter.senderAddress!,
            style: pw.TextStyle(font: regular, fontSize: 10),
          ),
        ],
        pw.SizedBox(height: 4),
        pw.Text(
          coverLetter.senderEmail,
          style: pw.TextStyle(font: regular, fontSize: 10),
        ),
        if (coverLetter.senderPhone != null && coverLetter.senderPhone!.isNotEmpty) ...[
          pw.SizedBox(height: 2),
          pw.Text(
            coverLetter.senderPhone!,
            style: pw.TextStyle(font: regular, fontSize: 10),
          ),
        ],
      ],
    );
  }

  pw.Widget _buildRecipientInfo(CoverLetter coverLetter, pw.Font regular, pw.Font bold) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          coverLetter.recipientName,
          style: pw.TextStyle(font: bold, fontSize: 11),
        ),
        if (coverLetter.recipientTitle != null && coverLetter.recipientTitle!.isNotEmpty) ...[
          pw.SizedBox(height: 2),
          pw.Text(
            coverLetter.recipientTitle!,
            style: pw.TextStyle(font: regular, fontSize: 10),
          ),
        ],
        pw.SizedBox(height: 2),
        pw.Text(
          coverLetter.companyName,
          style: pw.TextStyle(font: regular, fontSize: 10),
        ),
        if (coverLetter.companyAddress != null && coverLetter.companyAddress!.isNotEmpty) ...[
          pw.SizedBox(height: 2),
          pw.Text(
            coverLetter.companyAddress!,
            style: pw.TextStyle(font: regular, fontSize: 10),
          ),
        ],
      ],
    );
  }

  /// Save PDF to file and return the file path
  Future<String> savePdf(CoverLetter coverLetter, {String? filename}) async {
    final pdf = await generatePdf(coverLetter);
    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    final defaultFilename = '${coverLetter.companyName.replaceAll(' ', '_')}_Cover_Letter';
    final file = File(
      '${dir.path}/${filename ?? defaultFilename}_${DateTime.now().millisecondsSinceEpoch}.pdf',
    );

    await file.writeAsBytes(bytes);
    return file.path;
  }

  /// Share PDF using system share dialog
  Future<void> sharePdf(CoverLetter coverLetter) async {
    final pdf = await generatePdf(coverLetter);
    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: '${coverLetter.companyName.replaceAll(' ', '_')}_Cover_Letter.pdf',
    );
  }

  /// Print PDF
  Future<void> printPdf(CoverLetter coverLetter) async {
    final pdf = await generatePdf(coverLetter);
    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }
}
