import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../constants/app_dimensions.dart';

/// Animated AI avatar widget with molecular structure design
///
/// Features three animation states:
/// - Idle: Gentle pulsation (breathing effect)
/// - Thinking: Fast rotation with shimmer effect
/// - Speaking: Wave animation from center to edges
class AnimatedAiAvatar extends StatefulWidget {
  final double size;
  final AvatarAnimationState state;
  final AppColors? colors; // Optional colors from theme

  const AnimatedAiAvatar({
    super.key,
    this.size = AppDimensions.avatarLarge,
    this.state = AvatarAnimationState.idle,
    this.colors,
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
        return const Duration(milliseconds: 3500); // Calm breathing - 3.5s
      case AvatarAnimationState.thinking:
        return const Duration(milliseconds: 3000); // Slower rotation - 3s
      case AvatarAnimationState.speaking:
        return const Duration(milliseconds: 2500); // Moderate fade wave - 2.5s
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
    // Get colors from widget or from theme context
    final colors = widget.colors;

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
              colors: colors,
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
  final AppColors? colors;

  _MolecularAvatarPainter({
    required this.animationValue,
    required this.state,
    this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw background circle with gradient
    _drawBackgroundGradient(canvas, center, radius);

    // Draw molecular structure
    _drawMolecularStructure(canvas, center, radius);

    // Draw center node (pulsating)
    _drawCenterNode(canvas, center, radius);
  }

  void _drawBackgroundGradient(Canvas canvas, Offset center, double radius) {
    // Background gradient removed for transparent appearance
    // Only molecular structure and center node will be visible
  }

  void _drawMolecularStructure(Canvas canvas, Offset center, double radius) {
    final nodeRadius = radius * 0.618; // Distance of nodes from center (golden ratio for balance)
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

      // Draw outer node (petal) - no connection lines
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
    double petalSize = baseRadius * 0.12; // Larger petal size for better visibility
    double opacity = 1.0;
    double petalScale = 1.0;

    if (state == AvatarAnimationState.speaking) {
      // Speaking: Sequential fade in/out - each petal fades individually in sequence
      final delay = index / 7.0; // Stagger animation for each petal (7 petals total)
      final wave = math.sin((animationValue - delay) * 2 * math.pi);

      // Fade from 0.2 to 1.0 opacity
      opacity = 0.3 + (wave * 0.5 + 0.5) * 0.7;

      // Slight scale pulse with fade
      petalScale = 0.9 + (wave * 0.5 + 0.5) * 0.2;
    } else if (state == AvatarAnimationState.thinking) {
      // Thinking: Flower rotates, petals stay same size
      opacity = 1.0;
      petalScale = 1.0;
    } else {
      // Idle: Gentle breathing (all petals breathe together)
      final breath = math.sin(animationValue * 2 * math.pi);
      petalScale = 1.0 + breath * 0.1;
      opacity = 0.85 + breath * 0.15;
    }

    final primary = colors?.primary ?? const Color(0xFFFF69B4);
    final secondary = colors?.secondary ?? const Color(0xFFDA70D6);

    // Draw drop-shaped petal (directed towards center, rotated by angle)
    _drawDropPetal(canvas, center, position, petalSize * petalScale, primary, secondary, opacity, angle);

    // Add glow effect
    final glowPaint = Paint()
      ..color = primary.withValues(alpha: opacity * 0.3)
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
    // Save canvas to apply rotation
    canvas.save();

    // Move to center for rotation
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);

    // Distance from center to petal end
    final distance = (petalEnd - center).distance;

    // Create path for drop/teardrop shape pointing OUTWARD (tip away from center)
    final path = Path();

    // Drop dimensions - sized to fit the radius
    final width = size * 2.0;
    final height = distance;

    // Bulbous part at origin (rounded bulb at center)
    path.moveTo(0, 0);

    // Right arc from center bulb
    path.quadraticBezierTo(
      width * 0.6,
      height * 0.3,
      width * 0.5,
      height * 0.65,
    );

    // Right side - converging to sharp tip at the end
    path.lineTo(0, height);

    // Left side - from tip back to bulb
    path.lineTo(-width * 0.5, height * 0.65);

    // Left arc back to center bulb
    path.quadraticBezierTo(
      -width * 0.6,
      height * 0.3,
      0,
      0,
    );
    path.close();

    // Fill with gradient for depth
    final gradient = RadialGradient(
      center: Alignment.center,
      radius: 1.0,
      colors: [
        primary.withValues(alpha: opacity),
        secondary.withValues(alpha: opacity * 0.8),
      ],
    );

    final paint = Paint()
      ..shader = gradient.createShader(
        Rect.fromLTWH(-width * 0.6, 0, width * 1.2, height),
      )
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);

    // Add outline for definition
    final strokePaint = Paint()
      ..color = primary.withValues(alpha: opacity * 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size * 0.08;

    canvas.drawPath(path, strokePaint);

    // Restore canvas
    canvas.restore();
  }

  void _drawCenterNode(Canvas canvas, Offset center, double baseRadius) {
    // Maximum pulsation should reach 0.618 * nodeRadius (golden ratio)
    // nodeRadius = baseRadius * 0.618, so max = 0.618 * 0.618 * baseRadius ≈ 0.382 * baseRadius
    // With pulsation factor of 0.364, base should be: 0.382 / (1.0 + 0.364) ≈ 0.28
    double centerSize = baseRadius * 0.28;
    double glowIntensity = 1.0;

    // Pulsation effect for all states
    if (state == AvatarAnimationState.idle) {
      // Gentle breathing with proportional pulsation (0.618 scaled)
      centerSize *= (1.0 + 0.364 * math.sin(animationValue * 2 * math.pi));
      glowIntensity = 0.8 + 0.2 * math.sin(animationValue * 2 * math.pi);
    } else if (state == AvatarAnimationState.thinking) {
      // Fast pulsation (proportionally scaled)
      centerSize *= (1.0 + 0.145 * math.sin(animationValue * 4 * math.pi));
      glowIntensity = 0.6 + 0.4 * math.sin(animationValue * 4 * math.pi);
    } else if (state == AvatarAnimationState.speaking) {
      // Strong pulsation (proportionally scaled)
      centerSize *= (1.0 + 0.109 * math.sin(animationValue * 3 * math.pi));
      glowIntensity = 0.7 + 0.3 * math.sin(animationValue * 3 * math.pi);
    }

    // Draw center node with gradient
    final primary = colors?.primary ?? const Color(0xFFFF69B4);
    final primaryDark = colors?.primaryDark ?? const Color(0xFF8E24AA);
    final secondary = colors?.secondary ?? const Color(0xFFDA70D6);

    final gradient = RadialGradient(
      colors: [
        primaryDark.withValues(alpha: glowIntensity),
        primary.withValues(alpha: glowIntensity * 0.8),
        secondary.withValues(alpha: glowIntensity * 0.6),
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
      ..color = primaryDark.withValues(alpha: glowIntensity * 0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);

    canvas.drawCircle(center, centerSize * 1.8, glowPaint);

    // Add inner bright core
    final corePaint = Paint()
      ..color = Colors.white.withValues(alpha: glowIntensity * 0.6);

    canvas.drawCircle(center, centerSize * 0.3, corePaint);
  }

  @override
  bool shouldRepaint(_MolecularAvatarPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
           oldDelegate.state != state ||
           oldDelegate.colors != colors;
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
