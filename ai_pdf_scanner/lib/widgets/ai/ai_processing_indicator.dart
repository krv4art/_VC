import 'package:flutter/material.dart';
import '../../constants/app_dimensions.dart';

/// Widget to show AI processing state with animated indicator
class AIProcessingIndicator extends StatefulWidget {
  final String message;
  final bool isProcessing;
  final double? progress; // 0.0 to 1.0, null for indeterminate

  const AIProcessingIndicator({
    super.key,
    required this.message,
    this.isProcessing = true,
    this.progress,
  });

  @override
  State<AIProcessingIndicator> createState() => _AIProcessingIndicatorState();
}

class _AIProcessingIndicatorState extends State<AIProcessingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.space16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppDimensions.radius12),
      ),
      child: Row(
        children: [
          // Animated icon
          if (widget.isProcessing)
            RotationTransition(
              turns: _controller,
              child: Icon(
                Icons.autorenew,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
            )
          else
            Icon(
              Icons.check_circle,
              color: Theme.of(context).colorScheme.primary,
              size: 24,
            ),

          const SizedBox(width: AppDimensions.space12),

          // Message and progress
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.message,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                if (widget.progress != null) ...[
                  const SizedBox(height: AppDimensions.space8),
                  LinearProgressIndicator(
                    value: widget.progress,
                    backgroundColor:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
