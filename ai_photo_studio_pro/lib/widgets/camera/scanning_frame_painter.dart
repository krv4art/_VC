import 'package:flutter/material.dart';
import '../../../constants/app_dimensions.dart';

/// Custom painter for drawing corner brackets on scanning frame
class ScanningFramePainter extends CustomPainter {
  final Color color;
  final double progress; // Animation progress 0.0 to 1.0
  final double breathingScale; // Breathing effect scale

  ScanningFramePainter({
    required this.color,
    this.progress = 1.0,
    this.breathingScale = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const cornerWidth = AppDimensions.space4;

    final paint = Paint()
      ..color = color.withValues(alpha: progress)
      ..strokeWidth = cornerWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final animatedLength = AppDimensions.space40 * progress * breathingScale;

    // Top-left corner
    canvas.drawLine(Offset(0, animatedLength), Offset(0, 0), paint);
    canvas.drawLine(Offset(0, 0), Offset(animatedLength, 0), paint);

    // Top-right corner
    canvas.drawLine(
      Offset(size.width - animatedLength, 0),
      Offset(size.width, 0),
      paint,
    );
    canvas.drawLine(
      Offset(size.width, 0),
      Offset(size.width, animatedLength),
      paint,
    );

    // Bottom-left corner
    canvas.drawLine(
      Offset(0, size.height - animatedLength),
      Offset(0, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(0, size.height),
      Offset(animatedLength, size.height),
      paint,
    );

    // Bottom-right corner
    canvas.drawLine(
      Offset(size.width - animatedLength, size.height),
      Offset(size.width, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(size.width, size.height - animatedLength),
      Offset(size.width, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant ScanningFramePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.breathingScale != breathingScale;
  }
}
