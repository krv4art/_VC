// services/cover_letter_export_service.dart
// Service for exporting cover letters to PDF and DOCX formats

import 'dart:io';
import 'package:cv_engineer/models/cover_letter.dart';
import 'package:cv_engineer/models/resume.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:archive/archive.dart';

class CoverLetterExportService {
  /// Export cover letter to PDF
  static Future<File> exportToPdf(
    CoverLetter coverLetter,
    Resume resume, {
    String? fileName,
  }) async {
    final pdf = await _generatePdf(coverLetter, resume);
    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File(
      '${dir.path}/${fileName ?? _generateFileName(coverLetter, 'pdf')}',
    );

    await file.writeAsBytes(bytes);
    return file;
  }

  /// Export cover letter to DOCX
  static Future<File> exportToDocx(
    CoverLetter coverLetter,
    Resume resume, {
    String? fileName,
  }) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(
      '${dir.path}/${fileName ?? _generateFileName(coverLetter, 'docx')}',
    );

    // Create DOCX content
    final docxBytes = _createDocxFile(coverLetter, resume);
    await file.writeAsBytes(docxBytes);

    return file;
  }

  /// Share cover letter PDF
  static Future<void> sharePdf(CoverLetter coverLetter, Resume resume) async {
    final pdf = await _generatePdf(coverLetter, resume);
    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: _generateFileName(coverLetter, 'pdf'),
    );
  }

  /// Print cover letter
  static Future<void> print(CoverLetter coverLetter, Resume resume) async {
    final pdf = await _generatePdf(coverLetter, resume);
    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }

  // Private helper methods

  static Future<pw.Document> _generatePdf(
    CoverLetter coverLetter,
    Resume resume,
  ) async {
    final pdf = pw.Document();
    final regular = await PdfGoogleFonts.robotoRegular();
    final bold = await PdfGoogleFonts.robotoBold();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(72), // 1 inch margins
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Header - Personal Info
            pw.Text(
              resume.personalInfo.fullName,
              style: pw.TextStyle(font: bold, fontSize: 16),
            ),
            pw.SizedBox(height: 4),
            if (resume.personalInfo.email.isNotEmpty)
              pw.Text(
                resume.personalInfo.email,
                style: pw.TextStyle(font: regular, fontSize: 10),
              ),
            if (resume.personalInfo.phone.isNotEmpty)
              pw.Text(
                resume.personalInfo.phone,
                style: pw.TextStyle(font: regular, fontSize: 10),
              ),
            if (resume.personalInfo.address != null &&
                resume.personalInfo.address!.isNotEmpty)
              pw.Text(
                [
                  resume.personalInfo.address,
                  resume.personalInfo.city,
                  resume.personalInfo.country,
                ].where((s) => s != null && s.isNotEmpty).join(', '),
                style: pw.TextStyle(font: regular, fontSize: 10),
              ),

            pw.SizedBox(height: 24),

            // Date
            pw.Text(
              _formatDate(DateTime.now()),
              style: pw.TextStyle(font: regular, fontSize: 10),
            ),

            pw.SizedBox(height: 16),

            // Recipient
            if (coverLetter.hiringManagerName.isNotEmpty)
              pw.Text(
                coverLetter.hiringManagerName,
                style: pw.TextStyle(font: regular, fontSize: 10),
              ),
            pw.Text(
              coverLetter.companyName,
              style: pw.TextStyle(font: regular, fontSize: 10),
            ),

            pw.SizedBox(height: 16),

            // Salutation
            pw.Text(
              coverLetter.hiringManagerName.isNotEmpty
                  ? 'Dear ${coverLetter.hiringManagerName},'
                  : 'Dear Hiring Manager,',
              style: pw.TextStyle(font: regular, fontSize: 11),
            ),

            pw.SizedBox(height: 12),

            // Content
            pw.Text(
              coverLetter.content,
              style: pw.TextStyle(
                font: regular,
                fontSize: 11,
                lineSpacing: 1.5,
              ),
              textAlign: pw.TextAlign.justify,
            ),

            pw.SizedBox(height: 16),

            // Closing
            pw.Text(
              'Sincerely,',
              style: pw.TextStyle(font: regular, fontSize: 11),
            ),
            pw.SizedBox(height: 32),
            pw.Text(
              resume.personalInfo.fullName,
              style: pw.TextStyle(font: regular, fontSize: 11),
            ),
          ],
        ),
      ),
    );

    return pdf;
  }

  static List<int> _createDocxFile(CoverLetter coverLetter, Resume resume) {
    // Create document.xml content
    final content = '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
  <w:body>
    <!-- Header - Personal Info -->
    <w:p>
      <w:pPr><w:jc w:val="left"/></w:pPr>
      <w:r><w:rPr><w:b/><w:sz w:val="28"/></w:rPr><w:t>${_escapeXml(resume.personalInfo.fullName)}</w:t></w:r>
    </w:p>
    ${resume.personalInfo.email.isNotEmpty ? '<w:p><w:r><w:t>${_escapeXml(resume.personalInfo.email)}</w:t></w:r></w:p>' : ''}
    ${resume.personalInfo.phone.isNotEmpty ? '<w:p><w:r><w:t>${_escapeXml(resume.personalInfo.phone)}</w:t></w:r></w:p>' : ''}
    ${_buildAddressXml(resume)}

    <!-- Spacing -->
    <w:p><w:r><w:t></w:t></w:r></w:p>

    <!-- Date -->
    <w:p>
      <w:r><w:t>${_formatDate(DateTime.now())}</w:t></w:r>
    </w:p>

    <w:p><w:r><w:t></w:t></w:r></w:p>

    <!-- Recipient -->
    ${coverLetter.hiringManagerName.isNotEmpty ? '<w:p><w:r><w:t>${_escapeXml(coverLetter.hiringManagerName)}</w:t></w:r></w:p>' : ''}
    <w:p>
      <w:r><w:t>${_escapeXml(coverLetter.companyName)}</w:t></w:r>
    </w:p>

    <w:p><w:r><w:t></w:t></w:r></w:p>

    <!-- Salutation -->
    <w:p>
      <w:r><w:t>${coverLetter.hiringManagerName.isNotEmpty ? 'Dear ${_escapeXml(coverLetter.hiringManagerName)},' : 'Dear Hiring Manager,'}</w:t></w:r>
    </w:p>

    <w:p><w:r><w:t></w:t></w:r></w:p>

    <!-- Content (split by paragraphs) -->
    ${_buildContentParagraphs(coverLetter.content)}

    <w:p><w:r><w:t></w:t></w:r></w:p>

    <!-- Closing -->
    <w:p>
      <w:r><w:t>Sincerely,</w:t></w:r>
    </w:p>

    <w:p><w:r><w:t></w:t></w:r></w:p>
    <w:p><w:r><w:t></w:t></w:r></w:p>

    <w:p>
      <w:r><w:t>${_escapeXml(resume.personalInfo.fullName)}</w:t></w:r>
    </w:p>
  </w:body>
</w:document>''';

    // Create the DOCX package structure
    final archive = Archive();

    // [Content_Types].xml
    archive.addFile(ArchiveFile(
      '[Content_Types].xml',
      '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
  <Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
  <Default Extension="xml" ContentType="application/xml"/>
  <Override PartName="/word/document.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml"/>
</Types>'''.codeUnits,
    ));

    // _rels/.rels
    archive.addFile(ArchiveFile(
      '_rels/.rels',
      '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="word/document.xml"/>
</Relationships>'''.codeUnits,
    ));

    // word/document.xml
    archive.addFile(ArchiveFile('word/document.xml', content.codeUnits));

    // word/_rels/document.xml.rels
    archive.addFile(ArchiveFile(
      'word/_rels/document.xml.rels',
      '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
</Relationships>'''.codeUnits,
    ));

    // Encode as ZIP
    final zipEncoder = ZipEncoder();
    return zipEncoder.encode(archive)!;
  }

  static String _buildAddressXml(Resume resume) {
    final parts = [
      resume.personalInfo.address,
      resume.personalInfo.city,
      resume.personalInfo.country,
    ].where((s) => s != null && s.isNotEmpty).toList();

    if (parts.isEmpty) return '';

    return '<w:p><w:r><w:t>${_escapeXml(parts.join(', '))}</w:t></w:r></w:p>';
  }

  static String _buildContentParagraphs(String content) {
    final paragraphs = content.split('\n\n');
    return paragraphs
        .map((p) => '<w:p><w:pPr><w:jc w:val="both"/></w:pPr><w:r><w:t>${_escapeXml(p.trim())}</w:t></w:r></w:p>')
        .join('\n    ');
  }

  static String _escapeXml(String text) {
    return text
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&apos;');
  }

  static String _formatDate(DateTime date) {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];

    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  static String _generateFileName(CoverLetter coverLetter, String extension) {
    final company = coverLetter.companyName
        .replaceAll(RegExp(r'[^\w\s-]'), '')
        .replaceAll(' ', '_');
    final position = coverLetter.position
        .replaceAll(RegExp(r'[^\w\s-]'), '')
        .replaceAll(' ', '_');

    return 'cover_letter_${company}_${position}_${DateTime.now().millisecondsSinceEpoch}.$extension';
  }
}
