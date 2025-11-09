import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// Processing overlay with hints and jokes during analysis
class ProcessingOverlay extends StatefulWidget {
  final List<String> hints;

  const ProcessingOverlay({
    super.key,
    this.hints = const [
      'Analyzing plant features...',
      'Comparing with database...',
      'Identifying species...',
      'Gathering care information...',
    ],
  });

  @override
  State<ProcessingOverlay> createState() => _ProcessingOverlayState();
}

class _ProcessingOverlayState extends State<ProcessingOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _currentHintIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..addListener(() {
        if (_controller.value == 1.0) {
          setState(() {
            _currentHintIndex = (_currentHintIndex + 1) % widget.hints.length;
          });
          _controller.reset();
          _controller.forward();
        }
      });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.8),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated plant icon
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(seconds: 2),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: 0.8 + (value * 0.2),
                  child: Icon(
                    Icons.eco,
                    size: 80,
                    color: Colors.green.withOpacity(0.5 + (value * 0.5)),
                  ),
                );
              },
            ),
            const SizedBox(height: AppTheme.space32),

            // Loading indicator
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            ),
            const SizedBox(height: AppTheme.space24),

            // Hint text with animation
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: Padding(
                key: ValueKey<int>(_currentHintIndex),
                padding: const EdgeInsets.symmetric(horizontal: AppTheme.space32),
                child: Text(
                  widget.hints[_currentHintIndex],
                  style: AppTheme.body.copyWith(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
