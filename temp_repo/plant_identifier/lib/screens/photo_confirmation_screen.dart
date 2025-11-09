import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';

/// Photo confirmation screen before analysis
class PhotoConfirmationScreen extends StatelessWidget {
  final File imageFile;
  final VoidCallback onConfirm;
  final VoidCallback onRetake;

  const PhotoConfirmationScreen({
    super.key,
    required this.imageFile,
    required this.onConfirm,
    required this.onRetake,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Confirm Photo',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          // Image preview
          Expanded(
            child: Center(
              child: Image.file(
                imageFile,
                fit: BoxFit.contain,
              ),
            ),
          ),

          // Action buttons
          Container(
            padding: const EdgeInsets.all(AppTheme.space24),
            color: Colors.black,
            child: SafeArea(
              child: Row(
                children: [
                  // Retake button
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onRetake,
                      icon: const Icon(Icons.refresh, color: Colors.white),
                      label: const Text(
                        'Retake',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppTheme.space16,
                        ),
                        side: const BorderSide(color: Colors.white),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppTheme.radiusCard),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppTheme.space16),

                  // Analyze button
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: onConfirm,
                      icon: const Icon(Icons.check),
                      label: const Text('Analyze Plant'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppTheme.space16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppTheme.radiusCard),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
