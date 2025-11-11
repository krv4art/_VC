import 'package:flutter/material.dart';
import '../../../constants/app_dimensions.dart';
import '../../../theme/theme_extensions_v2.dart';
import '../../../widgets/common/app_spacer.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/animated/animated_button.dart' as btn;
import 'scanning_frame_painter.dart';

/// Overlay widget for camera scanning interface with animations
class CameraScanOverlay extends StatelessWidget {
  final AnimationController animationController;
  final AnimationController breathingController;
  final bool isProcessing;
  final bool showSlowInternetMessage;
  final VoidCallback onCameraTap;
  final VoidCallback onGalleryTap;
  final VoidCallback onFlashlightTap;
  final bool isFlashlightOn;

  const CameraScanOverlay({
    super.key,
    required this.animationController,
    required this.breathingController,
    required this.isProcessing,
    required this.showSlowInternetMessage,
    required this.onCameraTap,
    required this.onGalleryTap,
    required this.onFlashlightTap,
    required this.isFlashlightOn,
  });

  // Animation getters
  double get _frameScale => Tween<double>(begin: 0.8, end: 1.0).evaluate(
    CurvedAnimation(
      parent: animationController,
      curve: const Interval(0.0, 0.625, curve: Curves.easeOutCubic),
    ),
  );

  double get _frameFade => Tween<double>(begin: 0.0, end: 1.0).evaluate(
    CurvedAnimation(
      parent: animationController,
      curve: const Interval(0.0, 0.625, curve: Curves.easeOut),
    ),
  );

  double get _cornerDraw => Tween<double>(begin: 0.0, end: 1.0).evaluate(
    CurvedAnimation(
      parent: animationController,
      curve: const Interval(0.0, 0.75, curve: Curves.easeInOut),
    ),
  );

  double get _breathingScale => Tween<double>(begin: 1.0, end: 1.08).evaluate(
    CurvedAnimation(parent: breathingController, curve: Curves.easeInOut),
  );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        Expanded(
          child: IgnorePointer(
            ignoring: true,
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: Listenable.merge([
                  animationController,
                  breathingController,
                ]),
                builder: (context, child) {
                  return Stack(
                    children: [
                      // Scanning frame with scale and fade animations
                      Center(
                        child: Opacity(
                          opacity: _frameFade,
                          child: Transform.scale(
                            scale: _frameScale,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: MediaQuery.of(context).size.height * 0.5,
                              child: CustomPaint(
                                painter: ScanningFramePainter(
                                  color: context.colors.primary,
                                  progress: _cornerDraw,
                                  breathingScale: _breathingScale,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Instruction text - hidden during processing
                      if (!isProcessing)
                        Center(
                          child: FadeTransition(
                            opacity: animationController,
                            child: SlideTransition(
                              position: _textSlideAnimation,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top:
                                      AppDimensions.space48 +
                                      AppDimensions.space8 +
                                      AppDimensions.space4,
                                ),
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: Text(
                                    l10n.positionTheLabelWithinTheFrame,
                                    style: TextStyle(
                                      color: Colors.white.withValues(
                                        alpha: 0.9,
                                      ),
                                      fontSize: AppDimensions.space16,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
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
        ),
        Padding(
          padding: EdgeInsets.only(bottom: AppDimensions.space48 + 2.0),
          child: AnimatedBuilder(
            animation: animationController,
            builder: (context, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Gallery button on the left with animation
                  FadeTransition(
                    opacity: animationController,
                    child: SlideTransition(
                      position: _galleryButtonSlideAnimation,
                      child: GestureDetector(
                        onTap: onGalleryTap,
                        child: Container(
                          height: AppDimensions.space48 + AppDimensions.space8,
                          width: AppDimensions.space48 + AppDimensions.space8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.3),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.7),
                              width: AppDimensions.space4 / 2,
                            ),
                          ),
                          child: Icon(
                            Icons.photo_library,
                            color: Colors.white,
                            size:
                                AppDimensions.iconLarge + AppDimensions.space4,
                          ),
                        ),
                      ),
                    ),
                  ),
                  AppSpacer.h32(),
                  // Camera button in the center with animation
                  FadeTransition(
                    opacity: animationController,
                    child: SlideTransition(
                      position: _cameraButtonSlideAnimation,
                      child: btn.AnimatedButton(
                        buttonType: btn.ButtonType.elevated,
                        animationStyle: btn.AnimationStyle.scale,
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        borderRadius: BorderRadius.circular(
                          AppDimensions.space40,
                        ),
                        padding: const EdgeInsets.all(0),
                        onPressed: onCameraTap,
                        child: Container(
                          height:
                              AppDimensions.space64 +
                              AppDimensions.space8 +
                              AppDimensions.space4,
                          width:
                              AppDimensions.space64 +
                              AppDimensions.space8 +
                              AppDimensions.space4,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.transparent,
                            border: Border.all(
                              color: Colors.white,
                              width:
                                  AppDimensions.space4 +
                                  AppDimensions.space4 / 2,
                            ),
                          ),
                          child: Center(
                            child: Container(
                              height:
                                  AppDimensions.space48 +
                                  AppDimensions.space8 +
                                  AppDimensions.space4,
                              width:
                                  AppDimensions.space48 +
                                  AppDimensions.space8 +
                                  AppDimensions.space4,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  AppSpacer.h32(),
                  // Flashlight button on the right with animation
                  FadeTransition(
                    opacity: animationController,
                    child: SlideTransition(
                      position: _flashlightButtonSlideAnimation,
                      child: GestureDetector(
                        onTap: onFlashlightTap,
                        child: Container(
                          height: AppDimensions.space48 + AppDimensions.space8,
                          width: AppDimensions.space48 + AppDimensions.space8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isFlashlightOn
                                ? Colors.white.withValues(alpha: 0.9)
                                : Colors.white.withValues(alpha: 0.3),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.7),
                              width: AppDimensions.space4 / 2,
                            ),
                          ),
                          child: Icon(
                            isFlashlightOn
                                ? Icons.flashlight_on
                                : Icons.flashlight_off,
                            color: isFlashlightOn ? Colors.black : Colors.white,
                            size:
                                AppDimensions.iconLarge + AppDimensions.space4,
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
      ],
    );
  }

  // Animation helpers
  Animation<Offset> get _textSlideAnimation =>
      Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
        CurvedAnimation(
          parent: animationController,
          curve: const Interval(0.25, 0.75, curve: Curves.easeOut),
        ),
      );

  Animation<Offset> get _galleryButtonSlideAnimation =>
      Tween<Offset>(begin: const Offset(0, 1.5), end: Offset.zero).animate(
        CurvedAnimation(
          parent: animationController,
          curve: const Interval(0.375, 0.8125, curve: Curves.easeOutBack),
        ),
      );

  Animation<Offset> get _cameraButtonSlideAnimation =>
      Tween<Offset>(begin: const Offset(0, 1.5), end: Offset.zero).animate(
        CurvedAnimation(
          parent: animationController,
          curve: const Interval(0.5, 0.9375, curve: Curves.easeOutBack),
        ),
      );

  Animation<Offset> get _flashlightButtonSlideAnimation =>
      Tween<Offset>(begin: const Offset(0, 1.5), end: Offset.zero).animate(
        CurvedAnimation(
          parent: animationController,
          curve: const Interval(0.375, 0.8125, curve: Curves.easeOutBack),
        ),
      );
}
