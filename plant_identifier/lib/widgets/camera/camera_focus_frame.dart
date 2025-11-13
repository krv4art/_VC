import 'package:flutter/material.dart';

/// Camera focus frame widget that displays a viewfinder-like rounded rectangle
/// with plant/mushroom icons in corners. Uses IgnorePointer to not interfere
/// with tap-to-focus functionality.
class CameraFocusFrame extends StatelessWidget {
  const CameraFocusFrame({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Center(
        child: CustomPaint(
          painter: CameraFramePainter(),
          size: Size.infinite,
        ),
      ),
    );
  }
}

/// Custom painter for drawing the camera frame and corner icons
class CameraFramePainter extends CustomPainter {
  static const double frameWidthRatio = 0.8; // 80% of screen width
  static const double frameHeightRatio = 0.5; // 50% of screen height
  static const double cornerRadius = 20.0;
  static const double strokeWidth = 3.0;
  static const double cornerIconSize = 30.0;
  static const double cornerIconOpacity = 0.6;

  @override
  void paint(Canvas canvas, Size size) {
    final frameWidth = size.width * frameWidthRatio;
    final frameHeight = size.height * frameHeightRatio;
    final frameLeft = (size.width - frameWidth) / 2;
    final frameTop = (size.height - frameHeight) / 2;

    // Draw rounded rectangle frame
    _drawFrame(canvas, frameLeft, frameTop, frameWidth, frameHeight);

    // Draw corner icons
    _drawCornerIcons(
      canvas,
      frameLeft,
      frameTop,
      frameWidth,
      frameHeight,
    );
  }

  void _drawFrame(Canvas canvas, double left, double top, double width, double height) {
    final rect = Rect.fromLTWH(left, top, width, height);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(cornerRadius));

    // Draw the frame stroke
    canvas.drawRRect(
      rrect,
      Paint()
        ..color = Colors.white.withOpacity(0.7)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );

    // Draw corner brackets for a more pronounced viewfinder effect
    _drawCornerBrackets(canvas, left, top, width, height);
  }

  void _drawCornerBrackets(Canvas canvas, double left, double top, double width, double height) {
    const bracketLength = 40.0;
    const bracketWidth = 3.0;

    final paint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..strokeWidth = bracketWidth
      ..strokeCap = StrokeCap.round;

    // Top-left bracket
    canvas.drawLine(Offset(left, top + bracketLength), Offset(left, top), paint);
    canvas.drawLine(Offset(left, top), Offset(left + bracketLength, top), paint);

    // Top-right bracket
    canvas.drawLine(
        Offset(left + width - bracketLength, top), Offset(left + width, top), paint);
    canvas.drawLine(Offset(left + width, top), Offset(left + width, top + bracketLength), paint);

    // Bottom-left bracket
    canvas.drawLine(Offset(left, top + height - bracketLength), Offset(left, top + height), paint);
    canvas.drawLine(
        Offset(left, top + height), Offset(left + bracketLength, top + height), paint);

    // Bottom-right bracket
    canvas.drawLine(
        Offset(left + width, top + height - bracketLength), Offset(left + width, top + height), paint);
    canvas.drawLine(Offset(left + width - bracketLength, top + height), Offset(left + width, top + height), paint);
  }

  void _drawCornerIcons(
    Canvas canvas,
    double left,
    double top,
    double width,
    double height,
  ) {
    const icons = [
      ('🌱', 'top-left'),      // Seedling
      ('🍄', 'top-right'),     // Mushroom
      ('🌿', 'bottom-left'),   // Leaves
      ('🌸', 'bottom-right'),  // Flower
    ];

    const textStyle = TextStyle(
      fontSize: cornerIconSize,
      fontFamily: 'Noto Color Emoji',
    );

    for (final (emoji, position) in icons) {
      late Offset offset;

      switch (position) {
        case 'top-left':
          offset = Offset(left + 15, top + 15);
        case 'top-right':
          offset = Offset(left + width - 30, top + 15);
        case 'bottom-left':
          offset = Offset(left + 15, top + height - 30);
        case 'bottom-right':
          offset = Offset(left + width - 30, top + height - 30);
      }

      // Draw semi-transparent emoji
      _drawEmoji(canvas, emoji, offset, textStyle);
    }
  }

  void _drawEmoji(Canvas canvas, String emoji, Offset offset, TextStyle style) {
    final textPainter = TextPainter(
      text: TextSpan(text: emoji, style: style),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    // Apply opacity by drawing with a semi-transparent paint
    final paint = Paint()..color = Colors.white.withOpacity(cornerIconOpacity);

    canvas.saveLayer(null, paint);
    textPainter.paint(canvas, offset);
    canvas.restore();
  }

  @override
  bool shouldRepaint(CameraFramePainter oldDelegate) => false;
}
