import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../constants/app_dimensions.dart';
import '../common/app_spacer.dart';
import 'math_scan_frame_painter.dart';

/// Overlay widget for math scanning camera interface
class MathScanOverlay extends StatelessWidget {
  final AnimationController entranceController;
  final AnimationController pulseController;
  final bool isProcessing;
  final VoidCallback onCameraTap;
  final VoidCallback onGalleryTap;
  final VoidCallback onFlashlightTap;
  final bool isFlashlightOn;

  const MathScanOverlay({
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

                final scaleValue = Tween<double>(begin: 0.85, end: 1.0).evaluate(
                  CurvedAnimation(
                    parent: entranceController,
                    curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
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
                    // Scanning frame with animations
                    Center(
                      child: Opacity(
                        opacity: fadeValue,
                        child: Transform.scale(
                          scale: scaleValue,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.85,
                            height: MediaQuery.of(context).size.height * 0.45,
                            child: CustomPaint(
                              painter: MathScanFramePainter(
                                color: AppTheme.primaryPurple,
                                animationValue: fadeValue,
                                pulseValue: pulseValue,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Instruction text - shown when not processing
                    if (!isProcessing)
                      Center(
                        child: FadeTransition(
                          opacity: CurvedAnimation(
                            parent: entranceController,
                            curve: const Interval(0.3, 0.8, curve: Curves.easeOut),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.45 * 0.5 + 60,
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
                                    Icons.calculate_outlined,
                                    color: AppTheme.primaryPurple,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 12),
                                  const Text(
                                    'Наведите камеру на задачу',
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
                      // Gallery button
                      _CircleButton(
                        icon: Icons.photo_library,
                        onTap: onGalleryTap,
                        size: 56,
                      ),
                      AppSpacer.h32(),

                      // Camera button (larger, with gradient)
                      _GradientCameraButton(
                        onTap: onCameraTap,
                      ),
                      AppSpacer.h32(),

                      // Flashlight button
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

/// Simple circle button for gallery and flashlight
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
          color: isActive ? AppTheme.primaryPurple : Colors.white,
          size: 28,
        ),
      ),
    );
  }
}

/// Large gradient camera button in the center
class _GradientCameraButton extends StatelessWidget {
  final VoidCallback onTap;

  const _GradientCameraButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: AppTheme.primaryGradient,
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryPurple.withOpacity(0.4),
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
