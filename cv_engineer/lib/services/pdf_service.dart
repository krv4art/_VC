import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import '../models/resume.dart';

/// Service for generating PDF from resume
class PdfService {
  /// Generate PDF document from resume
  Future<pw.Document> generatePdf(Resume resume) async {
    final pdf = pw.Document();

    // Load fonts
    final regular = await PdfGoogleFonts.robotoRegular();
    final bold = await PdfGoogleFonts.robotoBold();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(resume.marginSize),
        build: (context) => [
          // Header - Personal Info
          _buildHeader(resume, bold, regular),
          pw.SizedBox(height: 20),

          // Profile Summary
          if (resume.personalInfo.profileSummary != null &&
              resume.personalInfo.profileSummary!.isNotEmpty) ...[
            _buildSectionTitle('Professional Summary', bold),
            pw.SizedBox(height: 8),
            pw.Text(
              resume.personalInfo.profileSummary!,
              style: pw.TextStyle(fontSize: resume.fontSize),
            ),
            pw.SizedBox(height: 20),
          ],

          // Experience
          if (resume.experiences.isNotEmpty) ...[
            _buildSectionTitle('Experience', bold),
            pw.SizedBox(height: 8),
            ...resume.experiences.map((exp) => _buildExperience(exp, bold, regular, resume.fontSize)),
          ],

          // Education
          if (resume.educations.isNotEmpty) ...[
            _buildSectionTitle('Education', bold),
            pw.SizedBox(height: 8),
            ...resume.educations.map((edu) => _buildEducation(edu, bold, regular, resume.fontSize)),
          ],

          // Skills
          if (resume.skills.isNotEmpty) ...[
            _buildSectionTitle('Skills', bold),
            pw.SizedBox(height: 8),
            _buildSkills(resume, regular),
          ],

          // Languages
          if (resume.languages.isNotEmpty) ...[
            pw.SizedBox(height: 12),
            _buildSectionTitle('Languages', bold),
            pw.SizedBox(height: 8),
            _buildLanguages(resume, regular),
          ],
        ],
      ),
    );

    return pdf;
  }

  pw.Widget _buildHeader(Resume resume, pw.Font bold, pw.Font regular) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          resume.personalInfo.fullName,
          style: pw.TextStyle(
            font: bold,
            fontSize: 24,
            color: PdfColors.blue800,
          ),
        ),
        pw.SizedBox(height: 8),
        pw.Row(
          children: [
            if (resume.personalInfo.email.isNotEmpty) ...[
              pw.Icon(const pw.IconData(0xe0be), size: 12),
              pw.SizedBox(width: 4),
              pw.Text(
                resume.personalInfo.email,
                style: pw.TextStyle(font: regular, fontSize: 11),
              ),
              pw.SizedBox(width: 16),
            ],
            if (resume.personalInfo.phone.isNotEmpty) ...[
              pw.Icon(const pw.IconData(0xe0cd), size: 12),
              pw.SizedBox(width: 4),
              pw.Text(
                resume.personalInfo.phone,
                style: pw.TextStyle(font: regular, fontSize: 11),
              ),
            ],
          ],
        ),
        if (resume.personalInfo.address != null ||
            resume.personalInfo.city != null) ...[
          pw.SizedBox(height: 4),
          pw.Text(
            [
              resume.personalInfo.address,
              resume.personalInfo.city,
              resume.personalInfo.country,
            ].where((s) => s != null && s.isNotEmpty).join(', '),
            style: pw.TextStyle(font: regular, fontSize: 11),
          ),
        ],
        if (resume.personalInfo.linkedin != null ||
            resume.personalInfo.github != null) ...[
          pw.SizedBox(height: 4),
          pw.Row(
            children: [
              if (resume.personalInfo.linkedin != null) ...[
                pw.Text(
                  'LinkedIn: ${resume.personalInfo.linkedin}',
                  style: pw.TextStyle(font: regular, fontSize: 10),
                ),
                pw.SizedBox(width: 12),
              ],
              if (resume.personalInfo.github != null) ...[
                pw.Text(
                  'GitHub: ${resume.personalInfo.github}',
                  style: pw.TextStyle(font: regular, fontSize: 10),
                ),
              ],
            ],
          ),
        ],
        pw.Divider(),
      ],
    );
  }

  pw.Widget _buildSectionTitle(String title, pw.Font bold) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title,
          style: pw.TextStyle(
            font: bold,
            fontSize: 16,
            color: PdfColors.blue800,
          ),
        ),
        pw.Container(
          width: 50,
          height: 2,
          color: PdfColors.blue800,
        ),
      ],
    );
  }

  pw.Widget _buildExperience(dynamic exp, pw.Font bold, pw.Font regular, double fontSize) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 12),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            exp.jobTitle,
            style: pw.TextStyle(font: bold, fontSize: fontSize + 2),
          ),
          pw.Text(
            '${exp.company} • ${exp.getDuration()}',
            style: pw.TextStyle(font: regular, fontSize: fontSize - 1, color: PdfColors.grey700),
          ),
          if (exp.location != null) ...[
            pw.SizedBox(height: 2),
            pw.Text(
              exp.location!,
              style: pw.TextStyle(font: regular, fontSize: fontSize - 1, color: PdfColors.grey600),
            ),
          ],
          if (exp.description != null && exp.description!.isNotEmpty) ...[
            pw.SizedBox(height: 4),
            pw.Text(
              exp.description!,
              style: pw.TextStyle(font: regular, fontSize: fontSize),
            ),
          ],
          if (exp.responsibilities.isNotEmpty) ...[
            pw.SizedBox(height: 4),
            ...exp.responsibilities.map((resp) => pw.Padding(
                  padding: const pw.EdgeInsets.only(left: 12, top: 2),
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('•  ', style: pw.TextStyle(font: bold)),
                      pw.Expanded(
                        child: pw.Text(
                          resp,
                          style: pw.TextStyle(font: regular, fontSize: fontSize - 1),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ],
      ),
    );
  }

  pw.Widget _buildEducation(dynamic edu, pw.Font bold, pw.Font regular, double fontSize) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 12),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            edu.degree,
            style: pw.TextStyle(font: bold, fontSize: fontSize + 2),
          ),
          pw.Text(
            edu.institution,
            style: pw.TextStyle(font: regular, fontSize: fontSize, color: PdfColors.grey700),
          ),
          if (edu.gpa != null) ...[
            pw.SizedBox(height: 2),
            pw.Text(
              'GPA: ${edu.gpa}',
              style: pw.TextStyle(font: regular, fontSize: fontSize - 1),
            ),
          ],
          if (edu.achievements.isNotEmpty) ...[
            pw.SizedBox(height: 4),
            ...edu.achievements.map((achievement) => pw.Padding(
                  padding: const pw.EdgeInsets.only(left: 12, top: 2),
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('•  ', style: pw.TextStyle(font: bold)),
                      pw.Expanded(
                        child: pw.Text(
                          achievement,
                          style: pw.TextStyle(font: regular, fontSize: fontSize - 1),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ],
      ),
    );
  }

  pw.Widget _buildSkills(Resume resume, pw.Font regular) {
    // Group skills by category
    final Map<String, List<String>> groupedSkills = {};
    for (var skill in resume.skills) {
      groupedSkills.putIfAbsent(skill.category, () => []).add(skill.name);
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: groupedSkills.entries.map((entry) {
        return pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 6),
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.SizedBox(
                width: 120,
                child: pw.Text(
                  '${entry.key}:',
                  style: pw.TextStyle(font: regular, fontSize: resume.fontSize, fontWeight: pw.FontWeight.bold),
                ),
              ),
              pw.Expanded(
                child: pw.Text(
                  entry.value.join(', '),
                  style: pw.TextStyle(font: regular, fontSize: resume.fontSize),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  pw.Widget _buildLanguages(Resume resume, pw.Font regular) {
    return pw.Wrap(
      spacing: 12,
      runSpacing: 4,
      children: resume.languages.map((lang) {
        return pw.Text(
          '${lang.name} (${lang.proficiency.shortName})',
          style: pw.TextStyle(font: regular, fontSize: resume.fontSize),
        );
      }).toList(),
    );
  }

  /// Save PDF to file and return the file path
  Future<String> savePdf(Resume resume, {String? filename}) async {
    final pdf = await generatePdf(resume);
    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File(
      '${dir.path}/${filename ?? 'resume_${DateTime.now().millisecondsSinceEpoch}'}.pdf',
    );

    await file.writeAsBytes(bytes);
    return file.path;
  }

  /// Share PDF using system share dialog
  Future<void> sharePdf(Resume resume) async {
    final pdf = await generatePdf(resume);
    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: '${resume.personalInfo.fullName.replaceAll(' ', '_')}_resume.pdf',
    );
  }

  /// Print PDF
  Future<void> printPdf(Resume resume) async {
    final pdf = await generatePdf(resume);
    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }
}
