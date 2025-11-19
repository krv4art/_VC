import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../constants/app_dimensions.dart';

/// Tools Screen - Main tools menu
class ToolsScreen extends StatelessWidget {
  const ToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Tools'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.space16),
        children: [
          // Header
          Text(
            'PDF Tools',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: AppDimensions.space8),
          Text(
            'Powerful tools to manage your PDFs',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.color
                      ?.withOpacity(0.6),
                ),
          ),
          const SizedBox(height: AppDimensions.space24),

          // Compress
          _buildToolCard(
            context,
            title: 'Compress',
            subtitle: 'Reduce PDF file size',
            icon: Icons.compress,
            color: Colors.blue,
            onTap: () => context.push('/tools/compress'),
          ),

          // Merge
          _buildToolCard(
            context,
            title: 'Merge',
            subtitle: 'Combine multiple PDFs',
            icon: Icons.merge,
            color: Colors.green,
            onTap: () => context.push('/tools/merge'),
          ),

          // Split
          _buildToolCard(
            context,
            title: 'Split',
            subtitle: 'Separate PDF pages',
            icon: Icons.call_split,
            color: Colors.orange,
            onTap: () => context.push('/tools/split'),
          ),

          // Rotate
          _buildToolCard(
            context,
            title: 'Rotate',
            subtitle: 'Rotate PDF pages',
            icon: Icons.rotate_right,
            color: Colors.purple,
            onTap: () => context.push('/tools/rotate'),
          ),

          // Watermark
          _buildToolCard(
            context,
            title: 'Watermark',
            subtitle: 'Add text or image watermark',
            icon: Icons.water_drop,
            color: Colors.cyan,
            onTap: () => context.push('/tools/watermark'),
          ),

          // Protect
          _buildToolCard(
            context,
            title: 'Protect',
            subtitle: 'Add password protection',
            icon: Icons.lock,
            color: Colors.red,
            onTap: () => context.push('/tools/protect'),
          ),
        ],
      ),
    );
  }

  Widget _buildToolCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppDimensions.space12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radius12),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.space16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppDimensions.space12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radius12),
                ),
                child: Icon(icon, size: 28, color: color),
              ),
              const SizedBox(width: AppDimensions.space16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium,
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
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
