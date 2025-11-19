// widgets/features_menu.dart
// Menu widget for accessing new advanced features

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FeaturesMenu extends StatelessWidget {
  const FeaturesMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.apps),
      tooltip: 'Advanced Features',
      onSelected: (value) {
        context.push(value);
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: '/ats-checker',
          child: ListTile(
            leading: Icon(Icons.analytics, color: Colors.blue),
            title: Text('ATS Checker'),
            subtitle: Text('Optimize for job applications'),
          ),
        ),
        const PopupMenuItem(
          value: '/analytics',
          child: ListTile(
            leading: Icon(Icons.assessment, color: Colors.green),
            title: Text('Resume Analytics'),
            subtitle: Text('Quality score & insights'),
          ),
        ),
        const PopupMenuItem(
          value: '/social-links',
          child: ListTile(
            leading: Icon(Icons.link, color: Colors.purple),
            title: Text('Social Links'),
            subtitle: Text('Add professional profiles'),
          ),
        ),
        const PopupMenuItem(
          value: '/cover-letter',
          child: ListTile(
            leading: Icon(Icons.article, color: Colors.orange),
            title: Text('Cover Letter'),
            subtitle: Text('AI-powered generator'),
          ),
        ),
        const PopupMenuItem(
          value: '/job-tracker',
          child: ListTile(
            leading: Icon(Icons.work, color: Colors.teal),
            title: Text('Job Tracker'),
            subtitle: Text('Manage applications'),
          ),
        ),
        const PopupMenuItem(
          value: '/versions',
          child: ListTile(
            leading: Icon(Icons.layers, color: Colors.indigo),
            title: Text('Resume Versions'),
            subtitle: Text('Manage multiple resumes'),
          ),
        ),
      ],
    );
  }
}

// Grid-based features launcher
class FeaturesGrid extends StatelessWidget {
  const FeaturesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: [
        _buildFeatureCard(
          context,
          'ATS Checker',
          'Optimize for applicant tracking systems',
          Icons.analytics,
          Colors.blue,
          '/ats-checker',
        ),
        _buildFeatureCard(
          context,
          'Analytics',
          'Resume quality score & insights',
          Icons.assessment,
          Colors.green,
          '/analytics',
        ),
        _buildFeatureCard(
          context,
          'Cover Letter',
          'AI-powered letter generator',
          Icons.article,
          Colors.orange,
          '/cover-letter',
        ),
        _buildFeatureCard(
          context,
          'Job Tracker',
          'Track your applications',
          Icons.work,
          Colors.teal,
          '/job-tracker',
        ),
        _buildFeatureCard(
          context,
          'Social Links',
          'Professional profiles',
          Icons.link,
          Colors.purple,
          '/social-links',
        ),
        _buildFeatureCard(
          context,
          'Versions',
          'Multiple resume versions',
          Icons.layers,
          Colors.indigo,
          '/versions',
        ),
      ],
    );
  }

  Widget _buildFeatureCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    String route,
  ) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () => context.push(route),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Bottom sheet features launcher
class FeaturesBottomSheet extends StatelessWidget {
  const FeaturesBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const FeaturesBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.auto_awesome, color: theme.colorScheme.primary),
                  const SizedBox(width: 12),
                  Text(
                    'Advanced Features',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildFeatureItem(
                    context,
                    'ATS Checker',
                    'Analyze compatibility with applicant tracking systems',
                    Icons.analytics,
                    Colors.blue,
                    '/ats-checker',
                  ),
                  _buildFeatureItem(
                    context,
                    'Resume Analytics',
                    'Get quality score and improvement insights',
                    Icons.assessment,
                    Colors.green,
                    '/analytics',
                  ),
                  _buildFeatureItem(
                    context,
                    'Cover Letter Generator',
                    'Create AI-powered cover letters',
                    Icons.article,
                    Colors.orange,
                    '/cover-letter',
                  ),
                  _buildFeatureItem(
                    context,
                    'Job Application Tracker',
                    'Manage job search with Kanban board',
                    Icons.work,
                    Colors.teal,
                    '/job-tracker',
                  ),
                  _buildFeatureItem(
                    context,
                    'Social Links',
                    'Add LinkedIn, GitHub, Portfolio links',
                    Icons.link,
                    Colors.purple,
                    '/social-links',
                  ),
                  _buildFeatureItem(
                    context,
                    'Resume Versions',
                    'Create and manage multiple versions',
                    Icons.layers,
                    Colors.indigo,
                    '/versions',
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFeatureItem(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color color,
    String route,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(description),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.of(context).pop();
          context.push(route);
        },
      ),
    );
  }
}
