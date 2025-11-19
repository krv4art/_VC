import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/resume_provider.dart';
import '../theme/app_theme.dart';
import '../services/pdf_service.dart';
import '../services/export_helper.dart';
import '../widgets/templates/template_factory.dart';

class PreviewScreen extends StatefulWidget {
  const PreviewScreen({super.key});

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  String _selectedTemplateId = 'professional';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final resumeProvider = context.watch<ResumeProvider>();

    if (!resumeProvider.hasCurrentResume) {
      return Scaffold(
        appBar: AppBar(title: const Text('Preview')),
        body: const Center(
          child: Text('No resume to preview'),
        ),
      );
    }

    final resume = resumeProvider.currentResume!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resume Preview'),
        actions: [
          // Template selector
          PopupMenuButton<String>(
            icon: const Icon(Icons.palette),
            tooltip: 'Change Template',
            onSelected: (String templateId) {
              setState(() {
                _selectedTemplateId = templateId;
              });
            },
            itemBuilder: (context) {
              return TemplateFactory.getAllTemplates().map((template) {
                return PopupMenuItem<String>(
                  value: template.id,
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: template.primaryColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(template.name),
                    ],
                  ),
                );
              }).toList();
            },
          ),
          IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: () => _exportResume(context, resume),
            tooltip: 'Export',
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareResume(context, resume),
            tooltip: 'Share',
          ),
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () => _printPdf(context, resume),
            tooltip: 'Print',
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[300],
        child: Center(
          child: Container(
            width: 800,
            constraints: const BoxConstraints(maxHeight: 1000),
            margin: const EdgeInsets.all(AppTheme.space16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [AppTheme.strongShadow],
            ),
            child: TemplateFactory.createTemplate(_selectedTemplateId, resume),
          ),
        ),
      ),
    );
  }

  Future<void> _exportResume(BuildContext context, dynamic resume) async {
    await ExportHelper.saveWithDialog(context, resume);
  }

  Future<void> _shareResume(BuildContext context, dynamic resume) async {
    await ExportHelper.shareWithDialog(context, resume);
  }

  Future<void> _printPdf(BuildContext context, dynamic resume) async {
    try {
      await ExportHelper.printResume(resume);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error printing: $e')),
        );
      }
    }
  }
}
