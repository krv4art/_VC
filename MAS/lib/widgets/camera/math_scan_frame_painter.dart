import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Custom painter for drawing mathematical grid and symbols on scanning frame
class MathScanFramePainter extends CustomPainter {
  final Color color;
  final double animationValue; // 0.0 to 1.0
  final double pulseValue; // 1.0 to 1.15 for pulse effect

  MathScanFramePainter({
    required this.color,
    this.animationValue = 1.0,
    this.pulseValue = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw frame border with rounded corners
    final borderPaint = Paint()
      ..color = color.withOpacity(0.6 * animationValue)
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    final borderRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(24),
    );

    canvas.drawRRect(borderRect, borderPaint);

    // Draw corner accent lines (smaller than ACS corners)
    final cornerPaint = Paint()
      ..color = color.withOpacity(animationValue)
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final cornerLength = 30.0 * animationValue * pulseValue;

    // Top-left
    canvas.drawLine(
      const Offset(0, 24),
      Offset(0, 24 + cornerLength),
      cornerPaint,
    );
    canvas.drawLine(
      const Offset(24, 0),
      Offset(24 + cornerLength, 0),
      cornerPaint,
    );

    // Top-right
    canvas.drawLine(
      Offset(size.width - 24, 0),
      Offset(size.width - 24 - cornerLength, 0),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(size.width, 24),
      Offset(size.width, 24 + cornerLength),
      cornerPaint,
    );

    // Bottom-left
    canvas.drawLine(
      Offset(0, size.height - 24),
      Offset(0, size.height - 24 - cornerLength),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(24, size.height),
      Offset(24 + cornerLength, size.height),
      cornerPaint,
    );

    // Bottom-right
    canvas.drawLine(
      Offset(size.width - 24, size.height),
      Offset(size.width - 24 - cornerLength, size.height),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(size.width, size.height - 24),
      Offset(size.width, size.height - 24 - cornerLength),
      cornerPaint,
    );

    // Draw subtle grid lines (math paper style)
    final gridPaint = Paint()
      ..color = color.withOpacity(0.15 * animationValue)
      ..strokeWidth = 1.0;

    // Horizontal lines
    for (int i = 1; i < 5; i++) {
      final y = size.height * i / 5;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        gridPaint,
      );
    }

    // Vertical lines
    for (int i = 1; i < 4; i++) {
      final x = size.width * i / 4;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        gridPaint,
      );
    }

    // Draw mathematical symbols in corners (animated)
    if (animationValue > 0.5) {
      final symbolOpacity = (animationValue - 0.5) * 2;
      final textPainter = TextPainter(
        textDirection: TextDirection.ltr,
      );

      final symbols = ['∑', '∫', '√', '÷'];
      final positions = [
        Offset(size.width * 0.15, size.height * 0.15),
        Offset(size.width * 0.85, size.height * 0.15),
        Offset(size.width * 0.15, size.height * 0.85),
        Offset(size.width * 0.85, size.height * 0.85),
      ];

      for (int i = 0; i < symbols.length; i++) {
        textPainter.text = TextSpan(
          text: symbols[i],
          style: TextStyle(
            color: color.withOpacity(0.3 * symbolOpacity),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(
            positions[i].dx - textPainter.width / 2,
            positions[i].dy - textPainter.height / 2,
          ),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant MathScanFramePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.pulseValue != pulseValue;
  }
}
