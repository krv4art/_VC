import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Animated bug avatar widget
///
/// Features three animation states:
/// - Idle: Gentle antennae movement with slight wing vibration
/// - Thinking: Active wing flapping (flying)
/// - Speaking: Active antennae movement with medium wing activity
class AnimatedBugAvatar extends StatefulWidget {
  final double size;
  final AvatarAnimationState state;
  final Color? primaryColor;
  final Color? secondaryColor;

  const AnimatedBugAvatar({
    super.key,
    this.size = 48.0,
    this.state = AvatarAnimationState.idle,
    this.primaryColor,
    this.secondaryColor,
  });

  @override
  State<AnimatedBugAvatar> createState() => _AnimatedBugAvatarState();
}

class _AnimatedBugAvatarState extends State<AnimatedBugAvatar>
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
        return const Duration(milliseconds: 2500); // Calm movement
      case AvatarAnimationState.thinking:
        return const Duration(milliseconds: 800); // Fast wing flapping
      case AvatarAnimationState.speaking:
        return const Duration(milliseconds: 1500); // Active antennae
    }
  }

  @override
  void didUpdateWidget(AnimatedBugAvatar oldWidget) {
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
            painter: _BugAvatarPainter(
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

/// Custom painter for bug avatar
class _BugAvatarPainter extends CustomPainter {
  final double animationValue;
  final AvatarAnimationState state;
  final Color primaryColor;
  final Color secondaryColor;

  _BugAvatarPainter({
    required this.animationValue,
    required this.state,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Calculate animations based on state
    double wingAngle = 0;
    double antennaeAngle = 0;
    double legOffset = 0;

    if (state == AvatarAnimationState.idle) {
      // Gentle movement
      wingAngle = math.sin(animationValue * 2 * math.pi) * 0.1;
      antennaeAngle = math.sin(animationValue * 2 * math.pi) * 0.2;
      legOffset = math.sin(animationValue * 2 * math.pi) * 1;
    } else if (state == AvatarAnimationState.thinking) {
      // Fast wing flapping (flying)
      wingAngle = math.sin(animationValue * 4 * math.pi) * 0.8;
      antennaeAngle = math.sin(animationValue * 4 * math.pi) * 0.3;
      legOffset = math.sin(animationValue * 4 * math.pi) * 2;
    } else if (state == AvatarAnimationState.speaking) {
      // Active antennae movement
      wingAngle = math.sin(animationValue * 3 * math.pi) * 0.3;
      antennaeAngle = math.sin(animationValue * 3 * math.pi) * 0.5;
      legOffset = math.sin(animationValue * 3 * math.pi) * 1.5;
    }

    canvas.save();
    canvas.translate(center.dx, center.dy);

    // Draw wings (behind body)
    _drawWings(canvas, size, wingAngle);

    // Draw body
    _drawBody(canvas, size);

    // Draw head
    _drawHead(canvas, size);

    // Draw antennae
    _drawAntennae(canvas, size, antennaeAngle);

    // Draw legs
    _drawLegs(canvas, size, legOffset);

    // Draw eyes
    _drawEyes(canvas, size);

    canvas.restore();
  }

  void _drawWings(Canvas canvas, Size size, double angle) {
    final wingLength = size.width * 0.35;
    final wingWidth = size.width * 0.25;

    // Left wing
    canvas.save();
    canvas.rotate(-math.pi / 4 + angle);

    final leftWingPath = Path();
    leftWingPath.addOval(Rect.fromCenter(
      center: Offset(-wingLength / 2, 0),
      width: wingLength,
      height: wingWidth,
    ));

    final wingGradient = RadialGradient(
      colors: [
        secondaryColor.withOpacity(0.3),
        secondaryColor.withOpacity(0.1),
      ],
    );

    final wingPaint = Paint()
      ..shader = wingGradient.createShader(
        Rect.fromCenter(
          center: Offset(-wingLength / 2, 0),
          width: wingLength,
          height: wingWidth,
        ),
      )
      ..style = PaintingStyle.fill;

    canvas.drawPath(leftWingPath, wingPaint);

    final wingOutlinePaint = Paint()
      ..color = primaryColor.withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawPath(leftWingPath, wingOutlinePaint);

    canvas.restore();

    // Right wing
    canvas.save();
    canvas.rotate(math.pi / 4 - angle);

    final rightWingPath = Path();
    rightWingPath.addOval(Rect.fromCenter(
      center: Offset(wingLength / 2, 0),
      width: wingLength,
      height: wingWidth,
    ));

    canvas.drawPath(rightWingPath, wingPaint);
    canvas.drawPath(rightWingPath, wingOutlinePaint);

    canvas.restore();
  }

  void _drawBody(Canvas canvas, Size size) {
    final bodyWidth = size.width * 0.4;
    final bodyHeight = size.height * 0.5;

    final bodyRect = Rect.fromCenter(
      center: Offset(0, size.height * 0.05),
      width: bodyWidth,
      height: bodyHeight,
    );

    final gradient = RadialGradient(
      colors: [
        primaryColor,
        primaryColor.withOpacity(0.7),
        secondaryColor,
      ],
      stops: const [0.0, 0.5, 1.0],
    );

    final paint = Paint()
      ..shader = gradient.createShader(bodyRect)
      ..style = PaintingStyle.fill;

    canvas.drawOval(bodyRect, paint);

    // Body outline
    final outlinePaint = Paint()
      ..color = primaryColor.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawOval(bodyRect, outlinePaint);

    // Body segments (stripes)
    for (int i = 1; i <= 2; i++) {
      final segmentY = size.height * 0.05 - bodyHeight / 2 + (bodyHeight / 3) * i;
      final segmentPaint = Paint()
        ..color = Colors.black.withOpacity(0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;

      canvas.drawArc(
        Rect.fromCenter(
          center: Offset(0, segmentY),
          width: bodyWidth * 0.9,
          height: bodyHeight / 10,
        ),
        0,
        math.pi,
        false,
        segmentPaint,
      );
    }
  }

  void _drawHead(Canvas canvas, Size size) {
    final headRadius = size.width * 0.2;
    final headCenter = Offset(0, -size.height * 0.22);

    final gradient = RadialGradient(
      colors: [
        primaryColor,
        secondaryColor,
      ],
    );

    final paint = Paint()
      ..shader = gradient.createShader(
        Rect.fromCircle(center: headCenter, radius: headRadius),
      )
      ..style = PaintingStyle.fill;

    canvas.drawCircle(headCenter, headRadius, paint);

    final outlinePaint = Paint()
      ..color = primaryColor.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawCircle(headCenter, headRadius, outlinePaint);
  }

  void _drawAntennae(Canvas canvas, Size size, double angle) {
    final antennaeLength = size.width * 0.3;
    final headCenter = Offset(0, -size.height * 0.22);

    final antennaPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    // Left antenna
    canvas.save();
    canvas.translate(headCenter.dx - size.width * 0.08, headCenter.dy);
    canvas.rotate(-math.pi / 6 + angle);

    final leftPath = Path();
    leftPath.moveTo(0, 0);
    leftPath.quadraticBezierTo(
      -antennaeLength * 0.5,
      -antennaeLength * 0.3,
      -antennaeLength,
      -antennaeLength * 0.7,
    );

    canvas.drawPath(leftPath, antennaPaint);

    // Antenna tip
    final tipPaint = Paint()
      ..color = secondaryColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(-antennaeLength, -antennaeLength * 0.7), 2.5, tipPaint);

    canvas.restore();

    // Right antenna
    canvas.save();
    canvas.translate(headCenter.dx + size.width * 0.08, headCenter.dy);
    canvas.rotate(math.pi / 6 - angle);

    final rightPath = Path();
    rightPath.moveTo(0, 0);
    rightPath.quadraticBezierTo(
      antennaeLength * 0.5,
      -antennaeLength * 0.3,
      antennaeLength,
      -antennaeLength * 0.7,
    );

    canvas.drawPath(rightPath, antennaPaint);
    canvas.drawCircle(Offset(antennaeLength, -antennaeLength * 0.7), 2.5, tipPaint);

    canvas.restore();
  }

  void _drawLegs(Canvas canvas, Size size, double offset) {
    final legLength = size.width * 0.25;
    final bodyY = size.height * 0.05;

    final legPaint = Paint()
      ..color = primaryColor.withOpacity(0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    // Draw 3 pairs of legs (6 total)
    for (int i = 0; i < 3; i++) {
      final legY = bodyY - size.height * 0.15 + (size.height * 0.15) * i;

      // Left leg
      final leftLegPath = Path();
      leftLegPath.moveTo(-size.width * 0.15, legY);
      leftLegPath.quadraticBezierTo(
        -size.width * 0.25,
        legY + legLength * 0.5 + offset,
        -size.width * 0.35,
        legY + legLength,
      );

      canvas.drawPath(leftLegPath, legPaint);

      // Right leg
      final rightLegPath = Path();
      rightLegPath.moveTo(size.width * 0.15, legY);
      rightLegPath.quadraticBezierTo(
        size.width * 0.25,
        legY + legLength * 0.5 + offset,
        size.width * 0.35,
        legY + legLength,
      );

      canvas.drawPath(rightLegPath, legPaint);
    }
  }

  void _drawEyes(Canvas canvas, Size size) {
    final headCenter = Offset(0, -size.height * 0.22);
    final eyeRadius = size.width * 0.05;

    // Left eye
    final leftEyeCenter = headCenter.translate(-size.width * 0.08, 0);

    // White part
    final whitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(leftEyeCenter, eyeRadius, whitePaint);

    // Pupil
    final pupilPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    canvas.drawCircle(leftEyeCenter, eyeRadius * 0.6, pupilPaint);

    // Right eye
    final rightEyeCenter = headCenter.translate(size.width * 0.08, 0);
    canvas.drawCircle(rightEyeCenter, eyeRadius, whitePaint);
    canvas.drawCircle(rightEyeCenter, eyeRadius * 0.6, pupilPaint);
  }

  @override
  bool shouldRepaint(_BugAvatarPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
           oldDelegate.state != state;
  }
}

/// Animation states for the avatar
enum AvatarAnimationState {
  /// Gentle movement - bot is waiting/idle
  idle,

  /// Active wing flapping - bot is processing/thinking
  thinking,

  /// Active antennae - bot is responding/speaking
  speaking,
}
