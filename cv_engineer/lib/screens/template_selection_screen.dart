import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/resume_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/templates/template_factory.dart';

class TemplateSelectionScreen extends StatelessWidget {
  const TemplateSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final resumeProvider = context.watch<ResumeProvider>();
    final templates = TemplateFactory.getAllTemplates();

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
            final isSelected = resumeProvider.currentResume?.templateId == template.id;

            return Card(
              elevation: isSelected ? 8 : 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusCard),
                side: isSelected
                    ? BorderSide(color: template.primaryColor, width: 2)
                    : BorderSide.none,
              ),
              child: InkWell(
                onTap: () async {
                  await resumeProvider.updateTemplate(template.id);
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
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: template.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                        ),
                        child: Icon(
                          _getTemplateIcon(template.id),
                          size: 48,
                          color: template.primaryColor,
                        ),
                      ),
                      const SizedBox(height: AppTheme.space16),
                      Text(
                        template.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: isSelected ? template.primaryColor : null,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppTheme.space8),
                      Text(
                        template.description,
                        style: theme.textTheme.bodySmall,
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (isSelected) ...[
                        const SizedBox(height: AppTheme.space12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: template.primaryColor,
                            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                          ),
                          child: const Text(
                            'Selected',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
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

  IconData _getTemplateIcon(String templateId) {
    switch (templateId) {
      case 'professional':
        return Icons.business_center;
      case 'creative':
        return Icons.palette;
      case 'modern':
        return Icons.auto_awesome;
      case 'minimalist':
        return Icons.remove_circle_outline;
      case 'executive':
        return Icons.workspace_premium;
      case 'academic':
        return Icons.school;
      default:
        return Icons.description;
    }
  }
}
