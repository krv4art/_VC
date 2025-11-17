import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Animated math avatar widget
///
/// Features three animation states:
/// - Idle: Gentle rotation of math symbols
/// - Thinking: Fast calculation with rotating symbols
/// - Speaking: Symbols orbiting and pulsing
class AnimatedMathAvatar extends StatefulWidget {
  final double size;
  final AvatarAnimationState state;
  final Color? primaryColor;
  final Color? secondaryColor;

  const AnimatedMathAvatar({
    super.key,
    this.size = 48.0,
    this.state = AvatarAnimationState.idle,
    this.primaryColor,
    this.secondaryColor,
  });

  @override
  State<AnimatedMathAvatar> createState() => _AnimatedMathAvatarState();
}

class _AnimatedMathAvatarState extends State<AnimatedMathAvatar>
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
        return const Duration(milliseconds: 3000); // Calm rotation
      case AvatarAnimationState.thinking:
        return const Duration(milliseconds: 1200); // Fast calculation
      case AvatarAnimationState.speaking:
        return const Duration(milliseconds: 2000); // Orbiting symbols
    }
  }

  @override
  void didUpdateWidget(AnimatedMathAvatar oldWidget) {
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
            painter: _MathAvatarPainter(
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

/// Custom painter for math avatar
class _MathAvatarPainter extends CustomPainter {
  final double animationValue;
  final AvatarAnimationState state;
  final Color primaryColor;
  final Color secondaryColor;

  // Math symbols to display
  static const symbols = ['+', '−', '×', '÷', '=', 'π', '∑', '∫'];

  _MathAvatarPainter({
    required this.animationValue,
    required this.state,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Calculate animations based on state
    double rotation = 0;
    double orbitRadius = 0;
    double symbolScale = 1.0;
    double centerPulse = 1.0;

    if (state == AvatarAnimationState.idle) {
      // Gentle rotation
      rotation = animationValue * 2 * math.pi;
      orbitRadius = size.width * 0.3;
      symbolScale = 1.0 + math.sin(animationValue * 2 * math.pi) * 0.1;
      centerPulse = 1.0 + math.sin(animationValue * 2 * math.pi) * 0.1;
    } else if (state == AvatarAnimationState.thinking) {
      // Fast calculation
      rotation = animationValue * 4 * math.pi;
      orbitRadius = size.width * 0.35;
      symbolScale = 1.0 + math.sin(animationValue * 8 * math.pi) * 0.2;
      centerPulse = 1.0 + math.sin(animationValue * 4 * math.pi) * 0.15;
    } else if (state == AvatarAnimationState.speaking) {
      // Orbiting with pulsing
      rotation = animationValue * 2 * math.pi;
      orbitRadius = size.width * 0.32 * (1.0 + math.sin(animationValue * 3 * math.pi) * 0.1);
      symbolScale = 1.0 + math.sin(animationValue * 3 * math.pi) * 0.15;
      centerPulse = 1.0 + math.sin(animationValue * 3 * math.pi) * 0.2;
    }

    canvas.save();
    canvas.translate(center.dx, center.dy);

    // Draw center circle (calculator/brain)
    _drawCenter(canvas, size, centerPulse);

    // Draw orbiting symbols
    _drawSymbols(canvas, size, rotation, orbitRadius, symbolScale);

    canvas.restore();
  }

  void _drawCenter(Canvas canvas, Size size, double pulse) {
    final radius = size.width * 0.2 * pulse;

    // Gradient background
    final gradient = RadialGradient(
      colors: [
        primaryColor,
        secondaryColor,
      ],
    );

    final paint = Paint()
      ..shader = gradient.createShader(
        Rect.fromCircle(center: Offset.zero, radius: radius),
      )
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset.zero, radius, paint);

    // Outline
    final outlinePaint = Paint()
      ..color = primaryColor.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawCircle(Offset.zero, radius, outlinePaint);

    // Draw equals sign in center
    final textPainter = TextPainter(
      text: TextSpan(
        text: '=',
        style: TextStyle(
          color: Colors.white,
          fontSize: size.width * 0.2,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(-textPainter.width / 2, -textPainter.height / 2),
    );
  }

  void _drawSymbols(Canvas canvas, Size size, double rotation, double radius, double scale) {
    // Draw 4 main math symbols orbiting
    final mainSymbols = ['+', '−', '×', '÷'];

    for (int i = 0; i < mainSymbols.length; i++) {
      final angle = (2 * math.pi / mainSymbols.length) * i + rotation;
      final position = Offset(
        math.cos(angle) * radius,
        math.sin(angle) * radius,
      );

      _drawSymbol(canvas, size, mainSymbols[i], position, scale, i);
    }

    // Draw additional symbols if speaking
    if (state == AvatarAnimationState.speaking) {
      final extraSymbols = ['π', '∑'];
      for (int i = 0; i < extraSymbols.length; i++) {
        final angle = (2 * math.pi / extraSymbols.length) * i + rotation + math.pi / 4;
        final extraRadius = radius * 0.6;
        final position = Offset(
          math.cos(angle) * extraRadius,
          math.sin(angle) * extraRadius,
        );

        _drawSymbol(canvas, size, extraSymbols[i], position, scale * 0.8, i + 4);
      }
    }
  }

  void _drawSymbol(Canvas canvas, Size size, String symbol, Offset position, double scale, int index) {
    // Calculate opacity based on state
    double opacity = 1.0;
    if (state == AvatarAnimationState.speaking) {
      // Fade in/out effect
      final delay = index * 0.2;
      opacity = 0.5 + (math.sin((animationValue - delay) * 2 * math.pi) * 0.5 + 0.5) * 0.5;
    }

    // Symbol background circle
    final bgPaint = Paint()
      ..color = secondaryColor.withOpacity(opacity * 0.3)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(position, size.width * 0.12 * scale, bgPaint);

    // Symbol outline
    final outlinePaint = Paint()
      ..color = primaryColor.withOpacity(opacity * 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawCircle(position, size.width * 0.12 * scale, outlinePaint);

    // Draw symbol text
    final textPainter = TextPainter(
      text: TextSpan(
        text: symbol,
        style: TextStyle(
          color: primaryColor.withOpacity(opacity),
          fontSize: size.width * 0.15 * scale,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        position.dx - textPainter.width / 2,
        position.dy - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(_MathAvatarPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
           oldDelegate.state != state;
  }
}

/// Animation states for the avatar
enum AvatarAnimationState {
  /// Gentle rotation - bot is waiting/idle
  idle,

  /// Fast calculation - bot is processing/thinking
  thinking,

  /// Orbiting symbols - bot is responding/speaking
  speaking,
}
