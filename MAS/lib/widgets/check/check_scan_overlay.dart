import 'package:flutter/material.dart';
import '../../constants/app_dimensions.dart';
import '../common/app_spacer.dart';

/// Overlay for CHECK mode camera scanning with green theme
class CheckScanOverlay extends StatelessWidget {
  final AnimationController entranceController;
  final AnimationController pulseController;
  final bool isProcessing;
  final VoidCallback onCameraTap;
  final VoidCallback onGalleryTap;
  final VoidCallback onFlashlightTap;
  final bool isFlashlightOn;

  const CheckScanOverlay({
    super.key,
    required this.entranceController,
    required this.pulseController,
    required this.isProcessing,
    required this.onCameraTap,
    required this.onGalleryTap,
    required this.onFlashlightTap,
    required this.isFlashlightOn,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: IgnorePointer(
            ignoring: true,
            child: AnimatedBuilder(
              animation: Listenable.merge([entranceController, pulseController]),
              builder: (context, child) {
                final fadeValue = Tween<double>(begin: 0.0, end: 1.0).evaluate(
                  CurvedAnimation(
                    parent: entranceController,
                    curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
                  ),
                );

                final pulseValue = Tween<double>(begin: 1.0, end: 1.05).evaluate(
                  CurvedAnimation(
                    parent: pulseController,
                    curve: Curves.easeInOut,
                  ),
                );

                return Stack(
                  children: [
                    // Scanning frame with checkmark pattern
                    Center(
                      child: Opacity(
                        opacity: fadeValue,
                        child: Transform.scale(
                          scale: pulseValue,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.85,
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: CustomPaint(
                              painter: _CheckFramePainter(
                                color: Colors.green.shade400,
                                animationValue: fadeValue,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Instruction text
                    if (!isProcessing)
                      Center(
                        child: FadeTransition(
                          opacity: CurvedAnimation(
                            parent: entranceController,
                            curve: const Interval(0.3, 0.8, curve: Curves.easeOut),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.5 * 0.5 + 60,
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.fact_check_outlined,
                                    color: Colors.green.shade400,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 12),
                                  const Text(
                                    'Снимите ваше решение',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ),

        // Bottom control buttons
        Padding(
          padding: const EdgeInsets.only(bottom: 50),
          child: AnimatedBuilder(
            animation: entranceController,
            builder: (context, child) {
              final buttonFade = CurvedAnimation(
                parent: entranceController,
                curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
              );

              final buttonSlide = Tween<Offset>(
                begin: const Offset(0, 1.0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent: entranceController,
                  curve: const Interval(0.4, 1.0, curve: Curves.easeOutCubic),
                ),
              );

              return FadeTransition(
                opacity: buttonFade,
                child: SlideTransition(
                  position: buttonSlide,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _CircleButton(
                        icon: Icons.photo_library,
                        onTap: onGalleryTap,
                        size: 56,
                      ),
                      AppSpacer.h32(),

                      // Camera button with green gradient
                      _GreenCameraButton(onTap: onCameraTap),
                      AppSpacer.h32(),

                      _CircleButton(
                        icon: isFlashlightOn
                            ? Icons.flashlight_on
                            : Icons.flashlight_off,
                        onTap: onFlashlightTap,
                        size: 56,
                        isActive: isFlashlightOn,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Custom painter for check mode frame with checkmark corners
class _CheckFramePainter extends CustomPainter {
  final Color color;
  final double animationValue;

  _CheckFramePainter({
    required this.color,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final borderPaint = Paint()
      ..color = color.withOpacity(0.6 * animationValue)
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    final borderRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(24),
    );

    canvas.drawRRect(borderRect, borderPaint);

    // Corner accents
    final cornerPaint = Paint()
      ..color = color.withOpacity(animationValue)
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final cornerLength = 30.0 * animationValue;

    // Draw corners (same as math frame)
    _drawCorners(canvas, size, cornerPaint, cornerLength);

    // Draw checkmark symbols in corners
    if (animationValue > 0.5) {
      final symbolOpacity = (animationValue - 0.5) * 2;
      _drawCheckmarks(canvas, size, color, symbolOpacity);
    }
  }

  void _drawCorners(Canvas canvas, Size size, Paint paint, double length) {
    // Top-left
    canvas.drawLine(const Offset(0, 24), Offset(0, 24 + length), paint);
    canvas.drawLine(const Offset(24, 0), Offset(24 + length, 0), paint);

    // Top-right
    canvas.drawLine(
      Offset(size.width - 24, 0),
      Offset(size.width - 24 - length, 0),
      paint,
    );
    canvas.drawLine(
      Offset(size.width, 24),
      Offset(size.width, 24 + length),
      paint,
    );

    // Bottom-left
    canvas.drawLine(
      Offset(0, size.height - 24),
      Offset(0, size.height - 24 - length),
      paint,
    );
    canvas.drawLine(
      Offset(24, size.height),
      Offset(24 + length, size.height),
      paint,
    );

    // Bottom-right
    canvas.drawLine(
      Offset(size.width - 24, size.height),
      Offset(size.width - 24 - length, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(size.width, size.height - 24),
      Offset(size.width, size.height - 24 - length),
      paint,
    );
  }

  void _drawCheckmarks(Canvas canvas, Size size, Color color, double opacity) {
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    final positions = [
      Offset(size.width * 0.15, size.height * 0.15),
      Offset(size.width * 0.85, size.height * 0.15),
      Offset(size.width * 0.15, size.height * 0.85),
      Offset(size.width * 0.85, size.height * 0.85),
    ];

    for (final pos in positions) {
      textPainter.text = TextSpan(
        text: '✓',
        style: TextStyle(
          color: color.withOpacity(0.3 * opacity),
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          pos.dx - textPainter.width / 2,
          pos.dy - textPainter.height / 2,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CheckFramePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

/// Simple circle button
class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final double size;
  final bool isActive;

  const _CircleButton({
    required this.icon,
    required this.onTap,
    required this.size,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isActive
              ? Colors.white.withOpacity(0.9)
              : Colors.white.withOpacity(0.25),
          border: Border.all(
            color: Colors.white.withOpacity(0.6),
            width: 2,
          ),
        ),
        child: Icon(
          icon,
          color: isActive ? Colors.green.shade600 : Colors.white,
          size: 28,
        ),
      ),
    );
  }
}

/// Green gradient camera button
class _GreenCameraButton extends StatelessWidget {
  final VoidCallback onTap;

  const _GreenCameraButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              Colors.green.shade400,
              Colors.green.shade600,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.green.shade400.withOpacity(0.4),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
          border: Border.all(
            color: Colors.white,
            width: 4,
          ),
        ),
        child: const Icon(
          Icons.camera_alt,
          color: Colors.white,
          size: 36,
        ),
      ),
    );
  }
}
