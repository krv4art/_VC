import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/resume_provider.dart';
import '../theme/app_theme.dart';

class TemplateSelectionScreen extends StatelessWidget {
  const TemplateSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final resumeProvider = context.watch<ResumeProvider>();

    final templates = [
      {
        'id': 'professional',
        'name': 'Professional',
        'description': 'Clean and modern design for corporate roles',
        'icon': Icons.business_center,
      },
      {
        'id': 'creative',
        'name': 'Creative',
        'description': 'Bold design for creative professionals',
        'icon': Icons.palette,
      },
      {
        'id': 'modern',
        'name': 'Modern',
        'description': 'Contemporary style with fresh colors',
        'icon': Icons.auto_awesome,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Template'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppTheme.space16),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: AppTheme.space16,
            mainAxisSpacing: AppTheme.space16,
            childAspectRatio: 0.75,
          ),
          itemCount: templates.length,
          itemBuilder: (context, index) {
            final template = templates[index];
            final isSelected = resumeProvider.currentResume?.templateId == template['id'];

            return Card(
              elevation: isSelected ? 8 : 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusCard),
                side: isSelected
                    ? BorderSide(color: theme.colorScheme.primary, width: 2)
                    : BorderSide.none,
              ),
              child: InkWell(
                onTap: () async {
                  await resumeProvider.updateTemplate(template['id'] as String);
                  if (context.mounted) {
                    context.go('/editor');
                  }
                },
                borderRadius: BorderRadius.circular(AppTheme.radiusCard),
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.space16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        template['icon'] as IconData,
                        size: 64,
                        color: isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                      const SizedBox(height: AppTheme.space16),
                      Text(
                        template['name'] as String,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: isSelected ? theme.colorScheme.primary : null,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppTheme.space8),
                      Text(
                        template['description'] as String,
                        style: theme.textTheme.bodySmall,
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (isSelected) ...[
                        const SizedBox(height: AppTheme.space8),
                        Icon(
                          Icons.check_circle,
                          color: theme.colorScheme.primary,
                          size: 24,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
