import 'dart:io';
import 'package:flutter/material.dart';
import '../../constants/app_dimensions.dart';

/// Widget for previewing scanned images before PDF generation
class ScanPreviewWidget extends StatelessWidget {
  final List<String> imagePaths;
  final Function(int index)? onRemove;
  final Function(int oldIndex, int newIndex)? onReorder;
  final VoidCallback? onAddMore;

  const ScanPreviewWidget({
    super.key,
    required this.imagePaths,
    this.onRemove,
    this.onReorder,
    this.onAddMore,
  });

  @override
  Widget build(BuildContext context) {
    if (imagePaths.isEmpty) {
      return const Center(
        child: Text('No scans yet'),
      );
    }

    return Column(
      children: [
        // Header with count
        Padding(
          padding: const EdgeInsets.all(AppDimensions.space16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${imagePaths.length} ${imagePaths.length == 1 ? 'page' : 'pages'}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              if (onAddMore != null)
                TextButton.icon(
                  onPressed: onAddMore,
                  icon: const Icon(Icons.add_a_photo),
                  label: const Text('Add more'),
                ),
            ],
          ),
        ),

        // Grid of previews
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(AppDimensions.space16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: AppDimensions.space12,
              mainAxisSpacing: AppDimensions.space12,
              childAspectRatio: 0.7,
            ),
            itemCount: imagePaths.length,
            itemBuilder: (context, index) {
              return _buildPreviewCard(context, index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPreviewCard(BuildContext context, int index) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Image
          Image.file(
            File(imagePaths[index]),
            fit: BoxFit.cover,
          ),

          // Gradient overlay
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(AppDimensions.space8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.6),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Page number
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.space8,
                      vertical: AppDimensions.space4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppDimensions.radius8),
                    ),
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),

                  // Remove button
                  if (onRemove != null)
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => onRemove!(index),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
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
