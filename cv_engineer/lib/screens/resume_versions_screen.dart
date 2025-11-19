// screens/resume_versions_screen.dart
// Manage multiple resume versions

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cv_engineer/models/resume.dart';
import 'package:cv_engineer/providers/resume_provider.dart';

class ResumeVersionsScreen extends StatefulWidget {
  const ResumeVersionsScreen({super.key});

  @override
  State<ResumeVersionsScreen> createState() => _ResumeVersionsScreenState();
}

class _ResumeVersionsScreenState extends State<ResumeVersionsScreen> {
  void _duplicateResume(Resume resume) {
    final provider = context.read<ResumeProvider>();

    // Create duplicate with new ID and timestamp
    final duplicate = resume.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // Update personal info to indicate it's a copy
    final newPersonalInfo = duplicate.personalInfo.copyWith(
      fullName: '${duplicate.personalInfo.fullName} (Copy)',
    );

    final finalResume = duplicate.copyWith(personalInfo: newPersonalInfo);

    // TODO: Add to provider's resume list
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Resume duplicated successfully')),
    );
  }

  void _deleteResume(Resume resume) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Resume'),
        content: const Text('Are you sure you want to delete this resume version?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Delete from provider
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Resume deleted')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _renameResume(Resume resume) {
    final controller = TextEditingController(text: resume.personalInfo.fullName);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename Resume'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Resume Name',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Update resume name in provider
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Resume renamed')),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _switchTemplate(Resume resume) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Template'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Professional'),
              leading: const Icon(Icons.business, color: Colors.blue),
              onTap: () {
                final updated = resume.copyWith(
                  templateId: 'professional',
                  updatedAt: DateTime.now(),
                );
                context.read<ResumeProvider>().updateResume(updated);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: const Text('Creative'),
              leading: const Icon(Icons.palette, color: Colors.purple),
              onTap: () {
                final updated = resume.copyWith(
                  templateId: 'creative',
                  updatedAt: DateTime.now(),
                );
                context.read<ResumeProvider>().updateResume(updated);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: const Text('Modern'),
              leading: const Icon(Icons.auto_awesome, color: Colors.teal),
              onTap: () {
                final updated = resume.copyWith(
                  templateId: 'modern',
                  updatedAt: DateTime.now(),
                );
                context.read<ResumeProvider>().updateResume(updated);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final resumeProvider = context.watch<ResumeProvider>();
    final currentResume = resumeProvider.currentResume;

    // TODO: Get all resume versions from provider
    final versions = currentResume != null ? [currentResume] : <Resume>[];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resume Versions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => _showHelpDialog(context),
          ),
        ],
      ),
      body: versions.isEmpty
          ? _buildEmptyState(theme)
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: versions.length,
              itemBuilder: (context, index) {
                final resume = versions[index];
                return _buildResumeCard(resume, theme);
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Create new blank resume
          final newResume = Resume.empty();
          // TODO: Add to provider
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('New resume created')),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('New Resume'),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.description_outlined,
            size: 80,
            color: theme.colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            'No resume versions',
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first resume to get started',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResumeCard(Resume resume, ThemeData theme) {
    final isCurrentVersion = true; // TODO: Check if this is current

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: _getTemplateColor(resume.templateId),
          child: const Icon(Icons.description, color: Colors.white),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                resume.personalInfo.fullName.isEmpty
                    ? 'Untitled Resume'
                    : resume.personalInfo.fullName,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (isCurrentVersion)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'ACTIVE',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade900,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('Template: ${_getTemplateName(resume.templateId)}'),
            Text('Updated: ${_formatDate(resume.updatedAt)}'),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildStat('${resume.experiences.length}', 'Jobs'),
                const SizedBox(width: 16),
                _buildStat('${resume.educations.length}', 'Education'),
                const SizedBox(width: 16),
                _buildStat('${resume.skills.length}', 'Skills'),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'duplicate':
                _duplicateResume(resume);
                break;
              case 'rename':
                _renameResume(resume);
                break;
              case 'template':
                _switchTemplate(resume);
                break;
              case 'delete':
                _deleteResume(resume);
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'duplicate',
              child: Row(
                children: [
                  Icon(Icons.copy),
                  SizedBox(width: 8),
                  Text('Duplicate'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'rename',
              child: Row(
                children: [
                  Icon(Icons.edit),
                  SizedBox(width: 8),
                  Text('Rename'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'template',
              child: Row(
                children: [
                  Icon(Icons.palette),
                  SizedBox(width: 8),
                  Text('Change Template'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Delete', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
        onTap: () {
          // Load this resume version
          context.read<ResumeProvider>().updateResume(resume);
          Navigator.of(context).pop();
        },
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Color _getTemplateColor(String templateId) {
    switch (templateId) {
      case 'professional':
        return Colors.blue;
      case 'creative':
        return Colors.purple;
      case 'modern':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  String _getTemplateName(String templateId) {
    switch (templateId) {
      case 'professional':
        return 'Professional';
      case 'creative':
        return 'Creative';
      case 'modern':
        return 'Modern';
      default:
        return 'Unknown';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Resume Versions'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Manage multiple versions of your resume:'),
              SizedBox(height: 12),
              Text('• Create versions for different jobs'),
              Text('• Duplicate and customize quickly'),
              Text('• Switch between templates easily'),
              Text('• Track what works best'),
              SizedBox(height: 12),
              Text('Tips:'),
              Text('✓ Name versions by job/company'),
              Text('✓ Keep a master version'),
              Text('✓ Tailor each for specific roles'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}
