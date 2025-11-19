import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/cover_letter_provider.dart';
import '../theme/app_theme.dart';
import '../services/cover_letter_pdf_service.dart';

class CoverLetterPreviewScreen extends StatelessWidget {
  const CoverLetterPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final coverLetterProvider = context.watch<CoverLetterProvider>();

    if (!coverLetterProvider.hasCurrentCoverLetter) {
      return Scaffold(
        appBar: AppBar(title: const Text('Preview')),
        body: const Center(
          child: Text('No cover letter to preview'),
        ),
      );
    }

    final coverLetter = coverLetterProvider.currentCoverLetter!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cover Letter Preview'),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () => _exportPdf(context, coverLetter),
            tooltip: 'Export PDF',
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _sharePdf(context, coverLetter),
            tooltip: 'Share',
          ),
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () => _printPdf(context, coverLetter),
            tooltip: 'Print',
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[300],
        child: Center(
          child: Container(
            width: 800,
            constraints: const BoxConstraints(maxHeight: 1200),
            margin: const EdgeInsets.all(AppTheme.space16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [AppTheme.strongShadow],
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(72),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sender information
                  _buildSenderInfo(coverLetter, theme),
                  const SizedBox(height: 24),

                  // Date
                  Text(
                    DateFormat('MMMM d, yyyy').format(coverLetter.date),
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),

                  // Recipient information
                  _buildRecipientInfo(coverLetter, theme),
                  const SizedBox(height: 24),

                  // Salutation
                  Text(
                    '${coverLetter.salutation},',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),

                  // Body
                  Text(
                    coverLetter.body,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      height: 1.6,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 24),

                  // Closing
                  Text(
                    '${coverLetter.closing},',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 48),

                  // Signature
                  Text(
                    coverLetter.senderName,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSenderInfo(dynamic coverLetter, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          coverLetter.senderName,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        if (coverLetter.senderAddress != null && coverLetter.senderAddress!.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            coverLetter.senderAddress!,
            style: theme.textTheme.bodySmall,
          ),
        ],
        const SizedBox(height: 4),
        Text(
          coverLetter.senderEmail,
          style: theme.textTheme.bodySmall,
        ),
        if (coverLetter.senderPhone != null && coverLetter.senderPhone!.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(
            coverLetter.senderPhone!,
            style: theme.textTheme.bodySmall,
          ),
        ],
      ],
    );
  }

  Widget _buildRecipientInfo(dynamic coverLetter, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          coverLetter.recipientName,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        if (coverLetter.recipientTitle != null && coverLetter.recipientTitle!.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(
            coverLetter.recipientTitle!,
            style: theme.textTheme.bodySmall,
          ),
        ],
        const SizedBox(height: 2),
        Text(
          coverLetter.companyName,
          style: theme.textTheme.bodySmall,
        ),
        if (coverLetter.companyAddress != null && coverLetter.companyAddress!.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(
            coverLetter.companyAddress!,
            style: theme.textTheme.bodySmall,
          ),
        ],
      ],
    );
  }

  Future<void> _exportPdf(BuildContext context, dynamic coverLetter) async {
    // Show filename customization dialog
    final controller = TextEditingController(
      text: '${coverLetter.companyName.replaceAll(' ', '_')}_Cover_Letter',
    );

    final filename = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export PDF'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Filename',
            suffixText: '.pdf',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Export'),
          ),
        ],
      ),
    );

    if (filename == null || !context.mounted) return;

    try {
      final pdfService = CoverLetterPdfService();
      final filePath = await pdfService.savePdf(coverLetter, filename: filename);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('PDF saved to: $filePath'),
            action: SnackBarAction(
              label: 'OK',
              onPressed: () {},
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error exporting PDF: $e')),
        );
      }
    }
  }

  Future<void> _sharePdf(BuildContext context, dynamic coverLetter) async {
    try {
      final pdfService = CoverLetterPdfService();
      await pdfService.sharePdf(coverLetter);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sharing PDF: $e')),
        );
      }
    }
  }

  Future<void> _printPdf(BuildContext context, dynamic coverLetter) async {
    try {
      final pdfService = CoverLetterPdfService();
      await pdfService.printPdf(coverLetter);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error printing PDF: $e')),
        );
      }
    }
  }
}
