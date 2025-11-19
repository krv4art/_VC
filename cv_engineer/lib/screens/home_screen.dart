import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/resume_provider.dart';
import '../theme/app_theme.dart';
import '../l10n/app_localizations.dart';
import '../widgets/animated_card.dart';
import '../utils/demo_data.dart';
import '../utils/time_utils.dart';
import '../services/rating_service.dart';
import '../widgets/rating_request_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _checkAndShowRatingDialog();
  }

  Future<void> _checkAndShowRatingDialog() async {
    // Wait a bit to let the screen build
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final shouldShow = await RatingService().shouldShowRatingDialog();

    if (shouldShow && mounted) {
      await RatingService().incrementRatingDialogShows();

      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => const RatingRequestDialog(),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final resumeProvider = context.watch<ResumeProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appName),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'demo') {
                _showDemoDialog(context, resumeProvider);
              } else if (value == 'settings') {
                context.push('/settings');
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'demo',
                child: Row(
                  children: [
                    Icon(Icons.dashboard_customize),
                    SizedBox(width: 12),
                    Text('Load Demo Resume'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings),
                    SizedBox(width: 12),
                    Text('Settings'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: resumeProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.space16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome section
                  Container(
                    padding: const EdgeInsets.all(AppTheme.space24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.primary,
                          theme.colorScheme.primary.withValues(alpha: 0.7),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(AppTheme.radiusCard),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Create Your Professional Resume',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: AppTheme.space8),
                        Text(
                          'Stand out with a beautifully designed resume',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppTheme.space24),

                  // Quick actions - Row 1
                  Row(
                    children: [
                      Expanded(
                        child: _QuickActionCard(
                          icon: Icons.add_circle,
                          title: 'New Resume',
                          onTap: () async {
                            await resumeProvider.createNewResume();
                            if (context.mounted) {
                              context.push('/templates');
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: AppTheme.space16),
                      Expanded(
                        child: _QuickActionCard(
                          icon: Icons.folder_outlined,
                          title: 'My Resumes',
                          onTap: () => context.push('/resumes'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.space16),

                  // Quick actions - Row 2
                  Row(
                    children: [
                      Expanded(
                        child: _QuickActionCard(
                          icon: Icons.mail_outline,
                          title: 'Cover Letters',
                          onTap: () => context.push('/cover-letters'),
                        ),
                      ),
                      const SizedBox(width: AppTheme.space16),
                      Expanded(
                        child: _QuickActionCard(
                          icon: Icons.help_outline,
                          title: 'Interview Prep',
                          onTap: () => context.push('/interview-questions'),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppTheme.space32),

                  // Current resume section
                  if (resumeProvider.hasCurrentResume) ...[
                    AnimatedListItem(
                      index: 0,
                      child: Text(
                        'Current Resume',
                        style: theme.textTheme.headlineSmall,
                      ),
                    ),
                    const SizedBox(height: AppTheme.space16),
                    AnimatedListItem(
                      index: 1,
                      child: _CurrentResumeCard(
                        resumeProvider: resumeProvider,
                      ),
                    ),
                  ] else ...[
                    Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.description_outlined,
                            size: 80,
                            color: theme.colorScheme.primary.withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: AppTheme.space16),
                          Text(
                            'No resume yet',
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                          const SizedBox(height: AppTheme.space8),
                          Text(
                            'Create your first resume to get started',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: AppTheme.space32),

                  // Features section
                  Text(
                    'Features',
                    style: theme.textTheme.headlineSmall,
                  ),
                  const SizedBox(height: AppTheme.space16),
                  _FeatureCard(
                    icon: Icons.palette,
                    title: 'Professional Templates',
                    description: 'Choose from recruiter-designed templates',
                  ),
                  const SizedBox(height: AppTheme.space12),
                  _FeatureCard(
                    icon: Icons.auto_awesome,
                    title: 'AI Assistant',
                    description: 'Get AI-powered content suggestions',
                  ),
                  const SizedBox(height: AppTheme.space12),
                  _FeatureCard(
                    icon: Icons.picture_as_pdf,
                    title: 'PDF Export',
                    description: 'Download and share your resume easily',
                  ),
                ],
              ),
            ),
    );
  }

  void _showDemoDialog(BuildContext context, ResumeProvider resumeProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Load Demo Resume'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choose a demo resume to load:',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            ...DemoData.getDemoResumeNames().asMap().entries.map((entry) {
              return ListTile(
                leading: CircleAvatar(
                  child: Text('${entry.key + 1}'),
                ),
                title: Text(entry.value),
                onTap: () async {
                  Navigator.pop(context);
                  await resumeProvider.loadDemoResume(entry.key);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Loaded ${entry.value} demo resume'),
                        action: SnackBarAction(
                          label: 'View',
                          onPressed: () => context.push('/preview'),
                        ),
                      ),
                    );
                  }
                },
              );
            }),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.space20),
          child: Column(
            children: [
              Icon(icon, size: 48, color: theme.colorScheme.primary),
              const SizedBox(height: AppTheme.space8),
              Text(
                title,
                style: theme.textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CurrentResumeCard extends StatelessWidget {
  final ResumeProvider resumeProvider;

  const _CurrentResumeCard({required this.resumeProvider});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final resume = resumeProvider.currentResume!;
    final completeness = resume.completenessPercentage;

    return AnimatedCard(
      onTap: () => context.push('/editor'),
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
                      resume.personalInfo.fullName.isNotEmpty
                          ? resume.personalInfo.fullName
                          : 'Untitled Resume',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: AppTheme.space4),
                    Text(
                      'Last updated: ${TimeUtils.formatLastEdited(resume.updatedAt)}',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.visibility),
                onPressed: () => context.push('/preview'),
                tooltip: 'Preview',
              ),
            ],
          ),
          const SizedBox(height: AppTheme.space16),
          Text(
            'Completeness: ${completeness.toStringAsFixed(0)}%',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: AppTheme.space8),
          AnimatedProgressIndicator(
            value: completeness / 100,
            color: theme.colorScheme.primary,
            backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.2),
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.space16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppTheme.space12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              ),
              child: Icon(icon, color: theme.colorScheme.primary),
            ),
            const SizedBox(width: AppTheme.space16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.titleMedium),
                  Text(description, style: theme.textTheme.bodySmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
