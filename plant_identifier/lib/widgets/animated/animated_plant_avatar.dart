import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Animated plant avatar widget
///
/// Features three animation states:
/// - Idle: Gentle leaf swaying (breathing)
/// - Thinking: Active growth with leaf rotation
/// - Speaking: Blooming flower animation
class AnimatedPlantAvatar extends StatefulWidget {
  final double size;
  final AvatarAnimationState state;
  final Color? primaryColor;
  final Color? secondaryColor;

  const AnimatedPlantAvatar({
    super.key,
    this.size = 48.0,
    this.state = AvatarAnimationState.idle,
    this.primaryColor,
    this.secondaryColor,
  });

  @override
  State<AnimatedPlantAvatar> createState() => _AnimatedPlantAvatarState();
}

class _AnimatedPlantAvatarState extends State<AnimatedPlantAvatar>
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
        return const Duration(milliseconds: 3000); // Calm swaying
      case AvatarAnimationState.thinking:
        return const Duration(milliseconds: 2000); // Active growth
      case AvatarAnimationState.speaking:
        return const Duration(milliseconds: 2500); // Blooming
    }
  }

  @override
  void didUpdateWidget(AnimatedPlantAvatar oldWidget) {
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
            painter: _PlantAvatarPainter(
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

/// Custom painter for plant avatar
class _PlantAvatarPainter extends CustomPainter {
  final double animationValue;
  final AvatarAnimationState state;
  final Color primaryColor;
  final Color secondaryColor;

  _PlantAvatarPainter({
    required this.animationValue,
    required this.state,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Calculate animations based on state
    double leafAngle = 0;
    double stemBend = 0;
    double flowerScale = 0;
    double leafScale = 1.0;

    if (state == AvatarAnimationState.idle) {
      // Gentle swaying
      leafAngle = math.sin(animationValue * 2 * math.pi) * 0.15;
      stemBend = math.sin(animationValue * 2 * math.pi) * 0.05;
      leafScale = 1.0 + math.sin(animationValue * 2 * math.pi) * 0.05;
    } else if (state == AvatarAnimationState.thinking) {
      // Active growth - leaves rotating
      leafAngle = animationValue * 2 * math.pi;
      stemBend = math.sin(animationValue * 4 * math.pi) * 0.1;
      leafScale = 1.0 + math.sin(animationValue * 4 * math.pi) * 0.15;
    } else if (state == AvatarAnimationState.speaking) {
      // Blooming flower
      leafAngle = math.sin(animationValue * 2 * math.pi) * 0.1;
      stemBend = math.sin(animationValue * 2 * math.pi) * 0.03;
      flowerScale = (math.sin(animationValue * 2 * math.pi) * 0.5 + 0.5);
      leafScale = 1.0;
    }

    canvas.save();
    canvas.translate(center.dx, center.dy);

    // Draw stem
    _drawStem(canvas, size, stemBend);

    // Draw leaves
    _drawLeaves(canvas, size, leafAngle, leafScale);

    // Draw flower (only in speaking state or small in idle)
    if (state == AvatarAnimationState.speaking || state == AvatarAnimationState.idle) {
      final scale = state == AvatarAnimationState.speaking ? flowerScale : 0.5;
      _drawFlower(canvas, size, scale);
    }

    canvas.restore();
  }

  void _drawStem(Canvas canvas, Size size, double bend) {
    final stemHeight = size.height * 0.6;
    final stemPath = Path();

    // Draw curved stem
    stemPath.moveTo(0, size.height * 0.3);
    stemPath.quadraticBezierTo(
      bend * size.width * 0.2,
      size.height * 0.1,
      bend * size.width * 0.3,
      -stemHeight * 0.3,
    );

    final stemPaint = Paint()
      ..color = primaryColor.withOpacity(0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.08
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(stemPath, stemPaint);
  }

  void _drawLeaves(Canvas canvas, Size size, double angle, double scale) {
    // Draw 4 leaves around the stem
    for (int i = 0; i < 4; i++) {
      final leafAngle = (math.pi / 2) * i + angle;
      final distance = size.width * 0.25;

      canvas.save();
      canvas.rotate(leafAngle);

      _drawLeaf(canvas, size, distance, scale);

      canvas.restore();
    }
  }

  void _drawLeaf(Canvas canvas, Size size, double distance, double scale) {
    final leafPath = Path();

    final leafWidth = size.width * 0.2 * scale;
    final leafHeight = size.height * 0.3 * scale;

    // Leaf shape (teardrop/almond)
    leafPath.moveTo(distance, 0);
    leafPath.quadraticBezierTo(
      distance + leafWidth,
      -leafHeight * 0.3,
      distance + leafWidth * 0.5,
      -leafHeight,
    );
    leafPath.quadraticBezierTo(
      distance,
      -leafHeight * 0.7,
      distance,
      0,
    );

    // Leaf gradient
    final gradient = RadialGradient(
      center: const Alignment(0.3, 0.3),
      radius: 1.0,
      colors: [
        primaryColor,
        secondaryColor,
      ],
    );

    final leafPaint = Paint()
      ..shader = gradient.createShader(
        Rect.fromLTWH(distance, -leafHeight, leafWidth * 0.5, leafHeight),
      )
      ..style = PaintingStyle.fill;

    canvas.drawPath(leafPath, leafPaint);

    // Leaf outline
    final outlinePaint = Paint()
      ..color = primaryColor.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawPath(leafPath, outlinePaint);

    // Leaf vein
    final veinPaint = Paint()
      ..color = primaryColor.withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    final veinPath = Path();
    veinPath.moveTo(distance, 0);
    veinPath.lineTo(distance + leafWidth * 0.5, -leafHeight);

    canvas.drawPath(veinPath, veinPaint);
  }

  void _drawFlower(Canvas canvas, Size size, double scale) {
    final flowerCenter = Offset(0, -size.height * 0.35);
    final petalCount = 5;
    final petalRadius = size.width * 0.15 * scale;

    // Draw petals
    for (int i = 0; i < petalCount; i++) {
      final angle = (2 * math.pi / petalCount) * i;
      final petalOffset = Offset(
        flowerCenter.dx + math.cos(angle) * petalRadius * 0.5,
        flowerCenter.dy + math.sin(angle) * petalRadius * 0.5,
      );

      // Petal (oval)
      final petalPaint = Paint()
        ..color = secondaryColor.withOpacity(0.8)
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(petalOffset.dx, petalOffset.dy);
      canvas.rotate(angle);

      canvas.drawOval(
        Rect.fromCenter(
          center: Offset.zero,
          width: petalRadius * 0.8,
          height: petalRadius * 1.5,
        ),
        petalPaint,
      );

      canvas.restore();
    }

    // Flower center
    final centerPaint = Paint()
      ..color = primaryColor.withOpacity(0.9)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(flowerCenter, petalRadius * 0.3 * scale, centerPaint);

    // Flower center highlight
    final highlightPaint = Paint()
      ..color = Colors.yellow.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      flowerCenter.translate(-petalRadius * 0.1, -petalRadius * 0.1),
      petalRadius * 0.15 * scale,
      highlightPaint,
    );
  }

  @override
  bool shouldRepaint(_PlantAvatarPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
           oldDelegate.state != state;
  }
}

/// Animation states for the avatar
enum AvatarAnimationState {
  /// Gentle swaying - bot is waiting/idle
  idle,

  /// Active growth - bot is processing/thinking
  thinking,

  /// Blooming flower - bot is responding/speaking
  speaking,
}
