// services/export_helper.dart
// Unified export service for PDF and DOCX formats

import 'dart:io';
import 'package:cv_engineer/models/resume.dart';
import 'package:cv_engineer/services/pdf_service.dart';
import 'package:cv_engineer/services/docx_export_service.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

enum ExportFormat {
  pdf,
  docx,
}

extension ExportFormatExtension on ExportFormat {
  String get displayName {
    switch (this) {
      case ExportFormat.pdf:
        return 'PDF';
      case ExportFormat.docx:
        return 'Word (DOCX)';
    }
  }

  String get fileExtension {
    switch (this) {
      case ExportFormat.pdf:
        return 'pdf';
      case ExportFormat.docx:
        return 'docx';
    }
  }

  IconData get icon {
    switch (this) {
      case ExportFormat.pdf:
        return Icons.picture_as_pdf;
      case ExportFormat.docx:
        return Icons.article;
    }
  }

  String get description {
    switch (this) {
      case ExportFormat.pdf:
        return 'Best for viewing and printing';
      case ExportFormat.docx:
        return 'Best for editing and ATS compatibility';
    }
  }
}

class ExportHelper {
  static final PdfService _pdfService = PdfService();

  /// Show export format selection dialog
  static Future<ExportFormat?> showExportDialog(BuildContext context) async {
    return showDialog<ExportFormat>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.file_download),
            SizedBox(width: 12),
            Text('Export Resume'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ExportFormat.values.map((format) {
            return _ExportFormatTile(
              format: format,
              onTap: () => Navigator.of(context).pop(format),
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  /// Export resume in the specified format
  static Future<File> exportResume(
    Resume resume,
    ExportFormat format, {
    String? filename,
  }) async {
    switch (format) {
      case ExportFormat.pdf:
        return await _exportPdf(resume, filename: filename);
      case ExportFormat.docx:
        return await DocxExportService.exportToDocx(resume, fileName: filename);
    }
  }

  /// Save and export resume with format selection
  static Future<String?> saveWithDialog(
    BuildContext context,
    Resume resume,
  ) async {
    final format = await showExportDialog(context);
    if (format == null) return null;

    try {
      final filename = _generateFilename(resume, format);
      final file = await exportResume(resume, format, filename: filename);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${format.displayName} saved successfully'),
            action: SnackBarAction(
              label: 'View',
              onPressed: () => _openFile(file),
            ),
          ),
        );
      }

      return file.path;
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error exporting: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return null;
    }
  }

  /// Share resume with format selection
  static Future<void> shareWithDialog(
    BuildContext context,
    Resume resume,
  ) async {
    final format = await showExportDialog(context);
    if (format == null) return;

    try {
      final filename = _generateFilename(resume, format);
      final file = await exportResume(resume, format, filename: filename);

      await Share.shareXFiles(
        [XFile(file.path)],
        subject: 'My Resume - ${resume.personalInfo.fullName}',
        text: 'Here is my resume in ${format.displayName} format.',
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error sharing: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Quick export to PDF (legacy support)
  static Future<String> savePdf(Resume resume, {String? filename}) async {
    final file = await _exportPdf(resume, filename: filename);
    return file.path;
  }

  /// Quick export to DOCX
  static Future<String> saveDocx(Resume resume, {String? filename}) async {
    final file = await DocxExportService.exportToDocx(resume, fileName: filename);
    return file.path;
  }

  /// Share PDF (legacy support)
  static Future<void> sharePdf(Resume resume) async {
    await _pdfService.sharePdf(resume);
  }

  /// Print resume (PDF only)
  static Future<void> printResume(Resume resume) async {
    await _pdfService.printPdf(resume);
  }

  // Private helper methods

  static Future<File> _exportPdf(Resume resume, {String? filename}) async {
    final path = await _pdfService.savePdf(resume, filename: filename);
    return File(path);
  }

  static String _generateFilename(Resume resume, ExportFormat format) {
    final name = resume.personalInfo.fullName.isNotEmpty
        ? resume.personalInfo.fullName.replaceAll(RegExp(r'[^\w\s-]'), '').replaceAll(' ', '_')
        : 'resume';

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return '${name}_$timestamp.${format.fileExtension}';
  }

  static Future<void> _openFile(File file) async {
    // TODO: Implement file opening with open_file package
    // For now, the file is saved and user can access it via system file manager
  }

  /// Get resume directory
  static Future<Directory> getResumeDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final resumeDir = Directory('${appDir.path}/resumes');

    if (!await resumeDir.exists()) {
      await resumeDir.create(recursive: true);
    }

    return resumeDir;
  }

  /// List all exported resumes
  static Future<List<File>> listExportedResumes() async {
    final dir = await getResumeDirectory();
    final files = dir.listSync().whereType<File>().toList();

    // Filter for PDF and DOCX files
    return files.where((file) {
      final ext = file.path.split('.').last.toLowerCase();
      return ext == 'pdf' || ext == 'docx';
    }).toList();
  }

  /// Delete exported file
  static Future<void> deleteExportedFile(File file) async {
    if (await file.exists()) {
      await file.delete();
    }
  }
}

/// Widget for export format selection tile
class _ExportFormatTile extends StatelessWidget {
  final ExportFormat format;
  final VoidCallback onTap;

  const _ExportFormatTile({
    required this.format,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Icon(
            format.icon,
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),
        title: Text(
          format.displayName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(format.description),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
