import 'package:flutter/material.dart';
import '../../../constants/app_dimensions.dart';
import '../../../widgets/animated/animated_card.dart';
import '../../../theme/theme_extensions_v2.dart';

/// Widget that displays focus indicator at tap position
class FocusIndicator extends StatelessWidget {
  final Offset position;

  const FocusIndicator({
    super.key,
    required this.position,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx - AppDimensions.space40,
      top: position.dy - AppDimensions.space40,
      child: IgnorePointer(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 1.5, end: 1.0),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutBack,
          builder: (context, scale, child) {
            return AnimatedCard(
              elevation: 0,
              backgroundColor: Colors.transparent,
              borderRadius: BorderRadius.circular(AppDimensions.space40),
              child: Transform.scale(
                scale: scale,
                child: Container(
                  width: AppDimensions.space64 + AppDimensions.space16,
                  height: AppDimensions.space64 + AppDimensions.space16,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: context.colors.primary,
                      width: AppDimensions.space4 / 2,
                    ),
                    borderRadius: BorderRadius.circular(AppDimensions.space40),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
