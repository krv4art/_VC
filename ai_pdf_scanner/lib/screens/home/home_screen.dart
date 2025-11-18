import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../navigation/route_names.dart';
import '../../theme/app_colors.dart';
import '../../constants/app_dimensions.dart';

/// Home screen - Main dashboard of the app
/// Shows quick actions and recent documents
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>() ?? ProfessionalColors();

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI PDF Scanner'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push(RouteNames.settings),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.space16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome section
              Text(
                'Welcome!',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: AppDimensions.space8),
              Text(
                'What would you like to do today?',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: colors.onBackground.withOpacity(0.7),
                    ),
              ),
              const SizedBox(height: AppDimensions.space32),

              // Quick actions grid
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: AppDimensions.space16,
                  mainAxisSpacing: AppDimensions.space16,
                  children: [
                    _QuickActionCard(
                      icon: Icons.document_scanner,
                      title: 'Scan Document',
                      subtitle: 'Use camera to scan',
                      color: colors.primary,
                      onTap: () => context.push(RouteNames.scanner),
                    ),
                    _QuickActionCard(
                      icon: Icons.folder,
                      title: 'My Documents',
                      subtitle: 'View all PDFs',
                      color: colors.success,
                      onTap: () => context.push(RouteNames.library),
                    ),
                    _QuickActionCard(
                      icon: Icons.transform,
                      title: 'Convert',
                      subtitle: 'Image/Office to PDF',
                      color: colors.warning,
                      onTap: () => context.push(RouteNames.converter),
                    ),
                    _QuickActionCard(
                      icon: Icons.construction,
                      title: 'Tools',
                      subtitle: 'Merge, split, compress',
                      color: colors.info,
                      onTap: () => context.push(RouteNames.tools),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Quick action card widget
class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radius16),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.space16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(AppDimensions.space16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radius12),
                ),
                child: Icon(icon, size: 32, color: color),
              ),
              const SizedBox(height: AppDimensions.space12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.space4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.color
                          ?.withOpacity(0.6),
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
