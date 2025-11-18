import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Animated fish avatar widget
///
/// Features three animation states:
/// - Idle: Gentle tail and fins movement (swimming in place)
/// - Thinking: Active swimming with fast tail movement
/// - Speaking: Mouth opening/closing with bubbles
class AnimatedFishAvatar extends StatefulWidget {
  final double size;
  final AvatarAnimationState state;
  final Color? primaryColor;
  final Color? secondaryColor;

  const AnimatedFishAvatar({
    super.key,
    this.size = 48.0,
    this.state = AvatarAnimationState.idle,
    this.primaryColor,
    this.secondaryColor,
  });

  @override
  State<AnimatedFishAvatar> createState() => _AnimatedFishAvatarState();
}

class _AnimatedFishAvatarState extends State<AnimatedFishAvatar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _setupAnimation();
  }

  void _setupAnimation() {
    final duration = _getDurationForState(widget.state);

    _controller = AnimationController(
      vsync: this,
      duration: duration,
    )..repeat();

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  Duration _getDurationForState(AvatarAnimationState state) {
    switch (state) {
      case AvatarAnimationState.idle:
        return const Duration(milliseconds: 2500); // Calm swimming
      case AvatarAnimationState.thinking:
        return const Duration(milliseconds: 1500); // Active swimming
      case AvatarAnimationState.speaking:
        return const Duration(milliseconds: 2000); // Speaking with bubbles
    }
  }

  @override
  void didUpdateWidget(AnimatedFishAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state != widget.state) {
      _controller.stop();
      _controller.duration = _getDurationForState(widget.state);
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = widget.primaryColor ?? Theme.of(context).primaryColor;
    final secondary = widget.secondaryColor ?? Theme.of(context).colorScheme.secondary;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return CustomPaint(
            painter: _FishAvatarPainter(
              animationValue: _animation.value,
              state: widget.state,
              primaryColor: primary,
              secondaryColor: secondary,
            ),
          );
        },
      ),
    );
  }
}

/// Custom painter for fish avatar
class _FishAvatarPainter extends CustomPainter {
  final double animationValue;
  final AvatarAnimationState state;
  final Color primaryColor;
  final Color secondaryColor;

  _FishAvatarPainter({
    required this.animationValue,
    required this.state,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final fishLength = size.width * 0.8;
    final fishHeight = size.height * 0.5;

    // Calculate animations based on state
    double tailAngle = 0;
    double finOffset = 0;
    double mouthOpen = 0;
    double bodyTilt = 0;

    if (state == AvatarAnimationState.idle) {
      // Gentle swimming
      tailAngle = math.sin(animationValue * 2 * math.pi) * 0.3;
      finOffset = math.sin(animationValue * 2 * math.pi) * 2;
      bodyTilt = math.sin(animationValue * 2 * math.pi) * 0.05;
    } else if (state == AvatarAnimationState.thinking) {
      // Active swimming with rotation
      tailAngle = math.sin(animationValue * 4 * math.pi) * 0.5;
      finOffset = math.sin(animationValue * 4 * math.pi) * 3;
      bodyTilt = animationValue * 2 * math.pi; // Full rotation
    } else if (state == AvatarAnimationState.speaking) {
      // Speaking with mouth animation
      tailAngle = math.sin(animationValue * 2 * math.pi) * 0.2;
      finOffset = math.sin(animationValue * 2 * math.pi) * 1.5;
      mouthOpen = (math.sin(animationValue * 4 * math.pi) * 0.5 + 0.5) * 0.3;
    }

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(bodyTilt);

    // Draw fish body
    _drawBody(canvas, fishLength, fishHeight);

    // Draw tail
    _drawTail(canvas, fishLength, fishHeight, tailAngle);

    // Draw fins
    _drawFins(canvas, fishLength, fishHeight, finOffset);

    // Draw eye
    _drawEye(canvas, fishLength, fishHeight);

    // Draw mouth
    _drawMouth(canvas, fishLength, fishHeight, mouthOpen);

    canvas.restore();

    // Draw bubbles (only in speaking state)
    if (state == AvatarAnimationState.speaking) {
      _drawBubbles(canvas, center, size);
    }
  }

  void _drawBody(Canvas canvas, double length, double height) {
    final bodyPath = Path();

    // Fish body (ellipse)
    final bodyRect = Rect.fromCenter(
      center: Offset.zero,
      width: length * 0.6,
      height: height,
    );

    bodyPath.addOval(bodyRect);

    // Gradient for depth
    final gradient = RadialGradient(
      center: const Alignment(-0.3, -0.3),
      radius: 1.0,
      colors: [
        primaryColor,
        secondaryColor,
      ],
    );

    final paint = Paint()
      ..shader = gradient.createShader(bodyRect)
      ..style = PaintingStyle.fill;

    canvas.drawPath(bodyPath, paint);

    // Body outline
    final outlinePaint = Paint()
      ..color = primaryColor.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawPath(bodyPath, outlinePaint);
  }

  void _drawTail(Canvas canvas, double length, double height, double angle) {
    canvas.save();
    canvas.translate(-length * 0.3, 0);
    canvas.rotate(angle);

    final tailPath = Path();
    tailPath.moveTo(0, 0);
    tailPath.lineTo(-length * 0.25, -height * 0.4);
    tailPath.lineTo(-length * 0.2, 0);
    tailPath.lineTo(-length * 0.25, height * 0.4);
    tailPath.close();

    final paint = Paint()
      ..color = primaryColor.withOpacity(0.8)
      ..style = PaintingStyle.fill;

    canvas.drawPath(tailPath, paint);

    final outlinePaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawPath(tailPath, outlinePaint);

    canvas.restore();
  }

  void _drawFins(Canvas canvas, double length, double height, double offset) {
    // Top fin
    final topFinPath = Path();
    topFinPath.moveTo(length * 0.05, -height * 0.5);
    topFinPath.lineTo(length * 0.15, -height * 0.7 - offset);
    topFinPath.lineTo(length * 0.1, -height * 0.5);
    topFinPath.close();

    // Bottom fin
    final bottomFinPath = Path();
    bottomFinPath.moveTo(length * 0.05, height * 0.5);
    bottomFinPath.lineTo(length * 0.15, height * 0.7 + offset);
    bottomFinPath.lineTo(length * 0.1, height * 0.5);
    bottomFinPath.close();

    final paint = Paint()
      ..color = secondaryColor.withOpacity(0.7)
      ..style = PaintingStyle.fill;

    canvas.drawPath(topFinPath, paint);
    canvas.drawPath(bottomFinPath, paint);

    final outlinePaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawPath(topFinPath, outlinePaint);
    canvas.drawPath(bottomFinPath, outlinePaint);
  }

  void _drawEye(Canvas canvas, double length, double height) {
    final eyeCenter = Offset(length * 0.15, -height * 0.15);

    // White part
    final whitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(eyeCenter, height * 0.12, whitePaint);

    // Pupil
    final pupilPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    canvas.drawCircle(eyeCenter, height * 0.07, pupilPaint);

    // Highlight
    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      eyeCenter.translate(-height * 0.03, -height * 0.03),
      height * 0.03,
      highlightPaint,
    );
  }

  void _drawMouth(Canvas canvas, double length, double height, double openAmount) {
    final mouthPath = Path();

    // Mouth arc
    final mouthRect = Rect.fromCenter(
      center: Offset(length * 0.28, height * 0.1),
      width: length * 0.15,
      height: height * 0.2 + openAmount * height * 0.3,
    );

    mouthPath.addArc(mouthRect, -math.pi * 0.3, math.pi * 0.6);

    final paint = Paint()
      ..color = Colors.black.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(mouthPath, paint);
  }

  void _drawBubbles(Canvas canvas, Offset center, Size size) {
    // Draw 3 bubbles at different positions based on animation
    for (int i = 0; i < 3; i++) {
      final delay = i * 0.33;
      final progress = (animationValue - delay) % 1.0;

      // Bubble rises from mouth
      final bubbleX = center.dx + size.width * 0.35;
      final bubbleY = center.dy - progress * size.height * 0.8;
      final bubbleSize = (3.0 + i.toDouble()) * (1.0 - progress * 0.3);

      final opacity = (1.0 - progress).clamp(0.0, 1.0);

      // Bubble
      final bubblePaint = Paint()
        ..color = Colors.white.withOpacity(opacity * 0.4)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(bubbleX, bubbleY), bubbleSize, bubblePaint);

      // Bubble outline
      final outlinePaint = Paint()
        ..color = Colors.white.withOpacity(opacity * 0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;

      canvas.drawCircle(Offset(bubbleX, bubbleY), bubbleSize, outlinePaint);

      // Bubble highlight
      final highlightPaint = Paint()
        ..color = Colors.white.withOpacity(opacity * 0.8)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(bubbleX - bubbleSize * 0.3, bubbleY - bubbleSize * 0.3),
        bubbleSize * 0.3,
        highlightPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_FishAvatarPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
           oldDelegate.state != state;
  }
}

/// Animation states for the avatar
enum AvatarAnimationState {
  /// Gentle swimming - bot is waiting/idle
  idle,

  /// Active swimming - bot is processing/thinking
  thinking,

  /// Speaking with bubbles - bot is responding/speaking
  speaking,
}
