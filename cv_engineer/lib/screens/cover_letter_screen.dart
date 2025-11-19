// screens/cover_letter_screen.dart
// Screen for generating and managing cover letters

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cv_engineer/models/cover_letter.dart';
import 'package:cv_engineer/providers/resume_provider.dart';
import 'package:cv_engineer/services/cover_letter_service.dart';
import 'package:cv_engineer/services/cover_letter_export_service.dart';
import 'package:share_plus/share_plus.dart';

class CoverLetterGeneratorScreen extends StatefulWidget {
  const CoverLetterGeneratorScreen({super.key});

  @override
  State<CoverLetterGeneratorScreen> createState() => _CoverLetterGeneratorScreenState();
}

class _CoverLetterGeneratorScreenState extends State<CoverLetterGeneratorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _companyNameController = TextEditingController();
  final _positionController = TextEditingController();
  final _hiringManagerController = TextEditingController();
  final _jobDescriptionController = TextEditingController();

  CoverLetterTemplate _selectedTemplate = CoverLetterTemplate.professional;
  bool _isGenerating = false;

  @override
  void dispose() {
    _companyNameController.dispose();
    _positionController.dispose();
    _hiringManagerController.dispose();
    _jobDescriptionController.dispose();
    super.dispose();
  }

  Future<void> _generateCoverLetter() async {
    if (!_formKey.currentState!.validate()) return;

    final resumeProvider = context.read<ResumeProvider>();
    final currentResume = resumeProvider.currentResume;

    if (currentResume == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No resume loaded')),
        );
      }
      return;
    }

    setState(() {
      _isGenerating = true;
    });

    try {
      final coverLetter = await CoverLetterService.generateCoverLetter(
        resume: currentResume,
        companyName: _companyNameController.text,
        position: _positionController.text,
        hiringManagerName: _hiringManagerController.text,
        jobDescription: _jobDescriptionController.text,
        template: _selectedTemplate,
      );

      if (mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CoverLetterEditorScreen(coverLetter: coverLetter),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Generation failed: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGenerating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cover Letter Generator'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header card
              Card(
                color: theme.colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.article,
                        size: 48,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'AI-Powered Cover Letter',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Generate a professional cover letter tailored to your job application',
                        style: theme.textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Company Name
              TextFormField(
                controller: _companyNameController,
                decoration: const InputDecoration(
                  labelText: 'Company Name *',
                  hintText: 'e.g., Google',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.business),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Company name is required';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Position
              TextFormField(
                controller: _positionController,
                decoration: const InputDecoration(
                  labelText: 'Position *',
                  hintText: 'e.g., Senior Software Engineer',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.work),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Position is required';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Hiring Manager (optional)
              TextFormField(
                controller: _hiringManagerController,
                decoration: const InputDecoration(
                  labelText: 'Hiring Manager Name (Optional)',
                  hintText: 'e.g., John Smith',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),

              const SizedBox(height: 16),

              // Job Description (optional)
              TextFormField(
                controller: _jobDescriptionController,
                decoration: const InputDecoration(
                  labelText: 'Job Description (Optional)',
                  hintText: 'Paste job description for better results...',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 8,
              ),

              const SizedBox(height: 24),

              // Template selection
              Text(
                'Select Template',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: CoverLetterTemplate.values.map((template) {
                  final isSelected = _selectedTemplate == template;
                  return ChoiceChip(
                    label: Text(template.displayName),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedTemplate = template;
                      });
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),

              // Generate button
              ElevatedButton.icon(
                onPressed: _isGenerating ? null : _generateCoverLetter,
                icon: _isGenerating
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.auto_awesome),
                label: Text(
                  _isGenerating ? 'Generating...' : 'Generate Cover Letter',
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),

              const SizedBox(height: 16),

              // Tips
              Card(
                color: Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.lightbulb_outline, color: Colors.blue.shade700),
                          const SizedBox(width: 8),
                          Text(
                            'Tips',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text('• Include job description for better tailoring'),
                      const Text('• Mention hiring manager name if available'),
                      const Text('• Review and customize generated content'),
                      const Text('• Match template style to company culture'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Editor Screen
class CoverLetterEditorScreen extends StatefulWidget {
  final CoverLetter coverLetter;

  const CoverLetterEditorScreen({
    super.key,
    required this.coverLetter,
  });

  @override
  State<CoverLetterEditorScreen> createState() => _CoverLetterEditorScreenState();
}

class _CoverLetterEditorScreenState extends State<CoverLetterEditorScreen> {
  late TextEditingController _contentController;
  late CoverLetter _currentCoverLetter;

  @override
  void initState() {
    super.initState();
    _currentCoverLetter = widget.coverLetter;
    _contentController = TextEditingController(text: _currentCoverLetter.content);
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  void _saveCoverLetter() {
    final updatedCoverLetter = _currentCoverLetter.copyWith(
      content: _contentController.text,
      updatedAt: DateTime.now(),
    );

    // TODO: Save to database/provider
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cover letter saved')),
    );

    Navigator.of(context).pop();
  }

  void _exportCoverLetter(BuildContext context) async {
    final resumeProvider = context.read<ResumeProvider>();
    if (!resumeProvider.hasCurrentResume) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Resume not found')),
      );
      return;
    }

    final resume = resumeProvider.currentResume!;

    // Show format selection dialog
    final format = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Format'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.picture_as_pdf),
              title: const Text('PDF'),
              subtitle: const Text('Best for viewing and printing'),
              onTap: () => Navigator.pop(context, 'pdf'),
            ),
            ListTile(
              leading: const Icon(Icons.article),
              title: const Text('Word (DOCX)'),
              subtitle: const Text('Best for editing'),
              onTap: () => Navigator.pop(context, 'docx'),
            ),
          ],
        ),
      ),
    );

    if (format == null) return;

    try {
      final updatedCoverLetter = _currentCoverLetter.copyWith(
        content: _contentController.text,
      );

      if (format == 'pdf') {
        final file = await CoverLetterExportService.exportToPdf(
          updatedCoverLetter,
          resume,
        );
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('PDF exported successfully'),
              action: SnackBarAction(
                label: 'Share',
                onPressed: () async {
                  await Share.shareXFiles([XFile(file.path)]);
                },
              ),
            ),
          );
        }
      } else {
        final file = await CoverLetterExportService.exportToDocx(
          updatedCoverLetter,
          resume,
        );
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('DOCX exported successfully'),
              action: SnackBarAction(
                label: 'Share',
                onPressed: () async {
                  await Share.shareXFiles([XFile(file.path)]);
                },
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export failed: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Cover Letter'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => _exportCoverLetter(context),
            tooltip: 'Export',
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () async {
              final resumeProvider = context.read<ResumeProvider>();
              if (!resumeProvider.hasCurrentResume) return;

              final updatedCoverLetter = _currentCoverLetter.copyWith(
                content: _contentController.text,
              );

              await CoverLetterExportService.sharePdf(
                updatedCoverLetter,
                resumeProvider.currentResume!,
              );
            },
            tooltip: 'Share PDF',
          ),
        ],
      ),
      body: Column(
        children: [
          // Header info
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: theme.colorScheme.surfaceContainerHighest,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _currentCoverLetter.position,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _currentCoverLetter.companyName,
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  'Template: ${_currentCoverLetter.template.displayName}',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),

          // Editor
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _contentController,
                decoration: const InputDecoration(
                  hintText: 'Edit your cover letter content...',
                  border: OutlineInputBorder(),
                ),
                maxLines: null,
                style: theme.textTheme.bodyLarge,
              ),
            ),
          ),

          // Actions
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _saveCoverLetter,
                    icon: const Icon(Icons.save),
                    label: const Text('Save'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
