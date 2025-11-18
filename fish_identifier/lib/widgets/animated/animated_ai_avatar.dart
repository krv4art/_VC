import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Animated AI avatar widget with molecular structure design
///
/// Features three animation states:
/// - Idle: Gentle pulsation (breathing effect)
/// - Thinking: Fast rotation with shimmer effect
/// - Speaking: Wave animation from center to edges
class AnimatedAiAvatar extends StatefulWidget {
  final double size;
  final AvatarAnimationState state;
  final Color? primaryColor;
  final Color? secondaryColor;

  const AnimatedAiAvatar({
    super.key,
    this.size = 48.0,
    this.state = AvatarAnimationState.idle,
    this.primaryColor,
    this.secondaryColor,
  });

  @override
  State<AnimatedAiAvatar> createState() => _AnimatedAiAvatarState();
}

class _AnimatedAiAvatarState extends State<AnimatedAiAvatar>
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
        return const Duration(milliseconds: 2500); // Calm breathing - 2.5s
      case AvatarAnimationState.thinking:
        return const Duration(milliseconds: 2000); // Moderate rotation - 2s
      case AvatarAnimationState.speaking:
        return const Duration(milliseconds: 2000); // Moderate fade wave - 2s
    }
  }

  @override
  void didUpdateWidget(AnimatedAiAvatar oldWidget) {
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
            painter: _MolecularAvatarPainter(
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

/// Custom painter for molecular structure avatar
class _MolecularAvatarPainter extends CustomPainter {
  final double animationValue;
  final AvatarAnimationState state;
  final Color primaryColor;
  final Color secondaryColor;

  _MolecularAvatarPainter({
    required this.animationValue,
    required this.state,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw molecular structure
    _drawMolecularStructure(canvas, center, radius);

    // Draw center node (pulsating)
    _drawCenterNode(canvas, center, radius);
  }

  void _drawMolecularStructure(Canvas canvas, Offset center, double radius) {
    final nodeRadius = radius * 0.618; // Distance of nodes from center (golden ratio)
    final nodeCount = 7; // Flower structure with 7 petals

    // Base rotation: 180 degrees for idle/speaking, animated for thinking
    double rotation = math.pi; // 180 degrees offset for idle
    if (state == AvatarAnimationState.thinking) {
      rotation = animationValue * 2 * math.pi;
    }

    for (int i = 0; i < nodeCount; i++) {
      final angle = (2 * math.pi / nodeCount) * i + rotation;
      final nodeOffset = Offset(
        center.dx + nodeRadius * math.cos(angle),
        center.dy + nodeRadius * math.sin(angle),
      );

      // Draw outer node (petal)
      _drawOuterNode(canvas, center, nodeOffset, radius, angle, i);
    }
  }

  void _drawOuterNode(
    Canvas canvas,
    Offset center,
    Offset position,
    double baseRadius,
    double angle,
    int index,
  ) {
    double petalSize = baseRadius * 0.12;
    double opacity = 1.0;
    double petalScale = 1.0;

    if (state == AvatarAnimationState.speaking) {
      // Speaking: Sequential fade in/out
      final delay = index / 7.0;
      final wave = math.sin((animationValue - delay) * 2 * math.pi);

      opacity = 0.3 + (wave * 0.5 + 0.5) * 0.7;
      petalScale = 0.9 + (wave * 0.5 + 0.5) * 0.2;
    } else if (state == AvatarAnimationState.thinking) {
      // Thinking: Flower rotates, petals stay same size
      opacity = 1.0;
      petalScale = 1.0;
    } else {
      // Idle: Gentle breathing
      final breath = math.sin(animationValue * 2 * math.pi);
      petalScale = 1.0 + breath * 0.1;
      opacity = 0.85 + breath * 0.15;
    }

    // Draw drop-shaped petal
    _drawDropPetal(
      canvas,
      center,
      position,
      petalSize * petalScale,
      primaryColor,
      secondaryColor,
      opacity,
      angle,
    );

    // Add glow effect
    final glowPaint = Paint()
      ..color = primaryColor.withOpacity(opacity * 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    canvas.drawCircle(position, petalSize * petalScale * 2.0, glowPaint);
  }

  void _drawDropPetal(
    Canvas canvas,
    Offset center,
    Offset petalEnd,
    double size,
    Color primary,
    Color secondary,
    double opacity,
    double angle,
  ) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);

    final distance = (petalEnd - center).distance;
    final path = Path();

    final width = size * 2.0;
    final height = distance;

    path.moveTo(0, 0);
    path.quadraticBezierTo(width * 0.6, height * 0.3, width * 0.5, height * 0.65);
    path.lineTo(0, height);
    path.lineTo(-width * 0.5, height * 0.65);
    path.quadraticBezierTo(-width * 0.6, height * 0.3, 0, 0);
    path.close();

    final gradient = RadialGradient(
      center: Alignment.center,
      radius: 1.0,
      colors: [
        primary.withOpacity(opacity),
        secondary.withOpacity(opacity * 0.8),
      ],
    );

    final paint = Paint()
      ..shader = gradient.createShader(
        Rect.fromLTWH(-width * 0.6, 0, width * 1.2, height),
      )
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);

    final strokePaint = Paint()
      ..color = primary.withOpacity(opacity * 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size * 0.08;

    canvas.drawPath(path, strokePaint);
    canvas.restore();
  }

  void _drawCenterNode(Canvas canvas, Offset center, double baseRadius) {
    double centerSize = baseRadius * 0.28;
    double glowIntensity = 1.0;

    // Pulsation effect for all states
    if (state == AvatarAnimationState.idle) {
      centerSize *= (1.0 + 0.364 * math.sin(animationValue * 2 * math.pi));
      glowIntensity = 0.8 + 0.2 * math.sin(animationValue * 2 * math.pi);
    } else if (state == AvatarAnimationState.thinking) {
      centerSize *= (1.0 + 0.145 * math.sin(animationValue * 4 * math.pi));
      glowIntensity = 0.6 + 0.4 * math.sin(animationValue * 4 * math.pi);
    } else if (state == AvatarAnimationState.speaking) {
      centerSize *= (1.0 + 0.109 * math.sin(animationValue * 3 * math.pi));
      glowIntensity = 0.7 + 0.3 * math.sin(animationValue * 3 * math.pi);
    }

    final gradient = RadialGradient(
      colors: [
        primaryColor.withOpacity(glowIntensity),
        primaryColor.withOpacity(glowIntensity * 0.8),
        secondaryColor.withOpacity(glowIntensity * 0.6),
      ],
      stops: const [0.0, 0.5, 1.0],
    );

    final paint = Paint()
      ..shader = gradient.createShader(
        Rect.fromCircle(center: center, radius: centerSize),
      );

    canvas.drawCircle(center, centerSize, paint);

    // Add outer glow
    final glowPaint = Paint()
      ..color = primaryColor.withOpacity(glowIntensity * 0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);

    canvas.drawCircle(center, centerSize * 1.8, glowPaint);

    // Add inner bright core
    final corePaint = Paint()
      ..color = Colors.white.withOpacity(glowIntensity * 0.6);

    canvas.drawCircle(center, centerSize * 0.3, corePaint);
  }

  @override
  bool shouldRepaint(_MolecularAvatarPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
           oldDelegate.state != state;
  }
}

/// Animation states for the AI avatar
enum AvatarAnimationState {
  /// Gentle pulsation - bot is waiting/idle
  idle,

  /// Fast rotation and shimmer - bot is processing/thinking
  thinking,

  /// Wave animation - bot is responding/speaking
  speaking,
}
