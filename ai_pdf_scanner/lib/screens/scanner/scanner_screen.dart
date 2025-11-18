import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../constants/app_dimensions.dart';
import 'scanner_camera_screen.dart';

/// Scanner screen - Entry point for document scanning
/// Shows scanning options and launches camera
class ScannerScreen extends StatelessWidget {
  const ScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Document'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppDimensions.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Text(
              'Choose Scan Method',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: AppDimensions.space8),
            Text(
              'Select how you want to scan your document',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.color
                        ?.withOpacity(0.6),
                  ),
            ),
            const SizedBox(height: AppDimensions.space32),

            // Camera scan option
            _ScanOptionCard(
              icon: Icons.camera_alt,
              title: 'Camera Scan',
              subtitle: 'Use camera to scan documents',
              color: Theme.of(context).colorScheme.primary,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ScannerCameraScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: AppDimensions.space16),

            // Import from gallery option
            _ScanOptionCard(
              icon: Icons.photo_library,
              title: 'Import from Gallery',
              subtitle: 'Select images from your photo library',
              color: Theme.of(context).colorScheme.secondary,
              onTap: () {
                // TODO: Implement gallery import
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Gallery import coming soon!')),
                );
              },
            ),

            const SizedBox(height: AppDimensions.space16),

            // Import from files option
            _ScanOptionCard(
              icon: Icons.folder_open,
              title: 'Import from Files',
              subtitle: 'Select PDF or image files',
              color: Colors.orange,
              onTap: () {
                // TODO: Implement file import
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('File import coming soon!')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Scan option card widget
class _ScanOptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ScanOptionCard({
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
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppDimensions.space16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radius12),
                ),
                child: Icon(icon, size: 32, color: color),
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
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
