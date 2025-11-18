import 'package:flutter/material.dart';
import '../../constants/app_dimensions.dart';

/// Scanner screen - Camera-based document scanning
/// Provides controls for capturing and processing documents
class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Document'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.document_scanner,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: AppDimensions.space16),
            Text(
              'Camera Scanner',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppDimensions.space8),
            Text(
              'Camera functionality will be implemented here',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.color
                        ?.withOpacity(0.6),
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.space32),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Implement camera capture
              },
              icon: const Icon(Icons.camera_alt),
              label: const Text('Capture Document'),
            ),
          ],
        ),
      ),
    );
  }
}
