import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/cover_letter_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/animated_card.dart';

class CoverLetterListScreen extends StatelessWidget {
  const CoverLetterListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final coverLetterProvider = context.watch<CoverLetterProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cover Letters'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await coverLetterProvider.createNewCoverLetter();
              if (context.mounted) {
                context.push('/cover-letter-editor');
              }
            },
            tooltip: 'Create New Cover Letter',
          ),
        ],
      ),
      body: coverLetterProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : coverLetterProvider.savedCoverLetters.isEmpty
              ? _buildEmptyState(context, theme, coverLetterProvider)
              : _buildCoverLetterList(context, theme, coverLetterProvider),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    ThemeData theme,
    CoverLetterProvider provider,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.space32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.mail_outline,
              size: 100,
              color: theme.colorScheme.primary.withOpacity(0.3),
            ),
            const SizedBox(height: AppTheme.space24),
            Text(
              'No Cover Letters Yet',
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.space8),
            Text(
              'Create your first cover letter to get started',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.space32),
            FilledButton.icon(
              onPressed: () async {
                await provider.createNewCoverLetter();
                if (context.mounted) {
                  context.push('/cover-letter-editor');
                }
              },
              icon: const Icon(Icons.add),
              label: const Text('Create Cover Letter'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoverLetterList(
    BuildContext context,
    ThemeData theme,
    CoverLetterProvider provider,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppTheme.space16),
      itemCount: provider.savedCoverLetters.length,
      itemBuilder: (context, index) {
        final coverLetter = provider.savedCoverLetters[index];
        final isCurrent = provider.currentCoverLetter?.id == coverLetter.id;

        return AnimatedListItem(
          index: index,
          child: AnimatedCard(
            onTap: () async {
              await provider.loadCoverLetter(coverLetter.id);
              if (context.mounted) {
                context.push('/cover-letter-editor');
              }
            },
            elevation: isCurrent ? 4 : 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            coverLetter.displayTitle,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: isCurrent ? FontWeight.bold : null,
                            ),
                          ),
                          const SizedBox(height: AppTheme.space4),
                          Text(
                            'To: ${coverLetter.recipientName.isEmpty ? "Unknown" : coverLetter.recipientName}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                          Text(
                            'Company: ${coverLetter.companyName}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuButton<String>(
                      onSelected: (value) async {
                        switch (value) {
                          case 'edit':
                            await provider.loadCoverLetter(coverLetter.id);
                            if (context.mounted) {
                              context.push('/cover-letter-editor');
                            }
                            break;
                          case 'duplicate':
                            await provider.duplicateCoverLetter(coverLetter.id);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Cover letter duplicated'),
                                ),
                              );
                            }
                            break;
                          case 'delete':
                            final confirmed = await _showDeleteConfirmation(context);
                            if (confirmed == true) {
                              await provider.deleteCoverLetter(coverLetter.id);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Cover letter deleted'),
                                  ),
                                );
                              }
                            }
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
                              Icon(Icons.copy),
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
                const SizedBox(height: AppTheme.space12),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                    const SizedBox(width: AppTheme.space4),
                    Text(
                      _formatDate(coverLetter.updatedAt),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.5),
                      ),
                    ),
                    const SizedBox(width: AppTheme.space16),
                    Icon(
                      Icons.check_circle,
                      size: 14,
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                    const SizedBox(width: AppTheme.space4),
                    Text(
                      '${coverLetter.completenessPercentage.toStringAsFixed(0)}% complete',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
                if (isCurrent) ...[
                  const SizedBox(height: AppTheme.space12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                    ),
                    child: const Text(
                      'Current',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Future<bool?> _showDeleteConfirmation(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.orange),
            SizedBox(width: 8),
            Text('Delete Cover Letter?'),
          ],
        ),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM d, yyyy').format(date);
  }
}
