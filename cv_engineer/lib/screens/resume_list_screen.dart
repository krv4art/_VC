import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../providers/resume_provider.dart';
import '../theme/app_theme.dart';
import '../l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class ResumeListScreen extends StatelessWidget {
  const ResumeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final resumeProvider = context.watch<ResumeProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Resumes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await resumeProvider.createNewResume();
              if (context.mounted) {
                context.push('/templates');
              }
            },
            tooltip: 'Create New Resume',
          ),
        ],
      ),
      body: resumeProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : resumeProvider.savedResumes.isEmpty
              ? _buildEmptyState(context, resumeProvider)
              : _buildResumeList(context, resumeProvider),
    );
  }

  Widget _buildEmptyState(BuildContext context, ResumeProvider provider) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.space32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.description_outlined,
              size: 100,
              color: theme.colorScheme.primary.withOpacity(0.3),
            ),
            const SizedBox(height: AppTheme.space24),
            Text(
              'No Resumes Yet',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppTheme.space8),
            Text(
              'Create your first professional resume',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.space32),
            FilledButton.icon(
              onPressed: () async {
                await provider.createNewResume();
                if (context.mounted) {
                  context.push('/templates');
                }
              },
              icon: const Icon(Icons.add),
              label: const Text('Create New Resume'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResumeList(BuildContext context, ResumeProvider provider) {
    final theme = Theme.of(context);
    final resumes = provider.savedResumes;
    final currentResumeId = provider.currentResume?.id;

    return ListView.builder(
      padding: const EdgeInsets.all(AppTheme.space16),
      itemCount: resumes.length,
      itemBuilder: (context, index) {
        final resume = resumes[index];
        final isCurrentResume = resume.id == currentResumeId;

        return Card(
          margin: const EdgeInsets.only(bottom: AppTheme.space16),
          elevation: isCurrentResume ? 4 : 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusCard),
            side: isCurrentResume
                ? BorderSide(
                    color: theme.colorScheme.primary,
                    width: 2,
                  )
                : BorderSide.none,
          ),
          child: InkWell(
            onTap: () async {
              await provider.loadResume(resume.id);
              if (context.mounted) {
                context.pop();
              }
            },
            borderRadius: BorderRadius.circular(AppTheme.radiusCard),
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.space16),
              child: Row(
                children: [
                  // Template icon/preview
                  Container(
                    width: 60,
                    height: 80,
                    decoration: BoxDecoration(
                      color: _getTemplateColor(resume.templateId).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                      border: Border.all(
                        color: _getTemplateColor(resume.templateId),
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.description,
                        color: _getTemplateColor(resume.templateId),
                        size: 32,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppTheme.space16),

                  // Resume info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                resume.personalInfo.fullName.isNotEmpty
                                    ? resume.personalInfo.fullName
                                    : 'Untitled Resume',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (isCurrentResume)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary,
                                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                                ),
                                child: Text(
                                  'ACTIVE',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getTemplateName(resume.templateId),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: _getTemplateColor(resume.templateId),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Updated: ${_formatDate(resume.updatedAt)}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: [
                            _buildInfoChip(
                              icon: Icons.work,
                              label: '${resume.experiences.length}',
                              color: Colors.blue,
                            ),
                            _buildInfoChip(
                              icon: Icons.school,
                              label: '${resume.educations.length}',
                              color: Colors.green,
                            ),
                            _buildInfoChip(
                              icon: Icons.stars,
                              label: '${resume.skills.length}',
                              color: Colors.orange,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Actions menu
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    onSelected: (value) async {
                      switch (value) {
                        case 'edit':
                          await provider.loadResume(resume.id);
                          if (context.mounted) {
                            context.push('/builder');
                          }
                          break;
                        case 'duplicate':
                          await _duplicateResume(context, provider, resume);
                          break;
                        case 'delete':
                          await _confirmDelete(context, provider, resume);
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit),
                            SizedBox(width: 12),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'duplicate',
                        child: Row(
                          children: [
                            Icon(Icons.content_copy),
                            SizedBox(width: 12),
                            Text('Duplicate'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red),
                            SizedBox(width: 12),
                            Text('Delete', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Color _getTemplateColor(String templateId) {
    switch (templateId) {
      case 'professional':
        return const Color(0xFF1976D2);
      case 'creative':
        return const Color(0xFF9C27B0);
      case 'modern':
        return const Color(0xFF009688);
      default:
        return Colors.grey;
    }
  }

  String _getTemplateName(String templateId) {
    switch (templateId) {
      case 'professional':
        return 'Professional Template';
      case 'creative':
        return 'Creative Template';
      case 'modern':
        return 'Modern Template';
      default:
        return 'Unknown Template';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return DateFormat('MMM d, yyyy').format(date);
    }
  }

  Future<void> _duplicateResume(
    BuildContext context,
    ResumeProvider provider,
    dynamic resume,
  ) async {
    // Create a copy of the resume with new ID
    final newResume = resume.copyWith(
      id: const Uuid().v4(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // Save the duplicated resume
    await provider.createNewResume(templateId: resume.templateId);
    await provider.updatePersonalInfo(resume.personalInfo);

    // Copy all sections
    for (var exp in resume.experiences) {
      await provider.addExperience(exp);
    }
    for (var edu in resume.educations) {
      await provider.addEducation(edu);
    }
    for (var skill in resume.skills) {
      await provider.addSkill(skill);
    }
    for (var lang in resume.languages) {
      await provider.addLanguage(lang);
    }
    for (var section in resume.customSections) {
      await provider.addCustomSection(section);
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Resume duplicated successfully')),
      );
    }
  }

  Future<void> _confirmDelete(
    BuildContext context,
    ResumeProvider provider,
    dynamic resume,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Resume'),
        content: Text(
          'Are you sure you want to delete "${resume.personalInfo.fullName.isNotEmpty ? resume.personalInfo.fullName : 'Untitled Resume'}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await provider.deleteResume(resume.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Resume deleted')),
        );
      }
    }
  }
}
