import 'package:flutter/material.dart';

/// Service for managing scanning screen animations
class ScanningAnimationController {
  final TickerProvider vsync;

  ScanningAnimationController({required this.vsync});
  late AnimationController animationController;
  late AnimationController breathingController;

  // Animation instances
  late Animation<double> frameScaleAnimation;
  late Animation<double> frameFadeAnimation;
  late Animation<double> cornerDrawAnimation;
  late Animation<double> textFadeAnimation;
  late Animation<Offset> textSlideAnimation;
  late Animation<double> galleryButtonAnimation;
  late Animation<Offset> galleryButtonSlideAnimation;
  late Animation<double> cameraButtonAnimation;
  late Animation<Offset> cameraButtonSlideAnimation;
  late Animation<double> breathingAnimation;

  /// Initialize all animations
  void initializeAnimations() {
    // Main animation controller - 800ms total duration
    animationController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 800),
    );

    // Breathing animation controller - repeating pulse effect
    breathingController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 2000),
    );

    _setupAnimations();
  }

  void _setupAnimations() {
    // Frame scale animation (0ms - 500ms)
    frameScaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.0, 0.625, curve: Curves.easeOutCubic),
      ),
    );

    // Frame fade animation (0ms - 500ms)
    frameFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.0, 0.625, curve: Curves.easeOut),
      ),
    );

    // Corner draw animation (0ms - 600ms)
    cornerDrawAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.0, 0.75, curve: Curves.easeInOut),
      ),
    );

    // Text fade animation (200ms - 600ms)
    textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.25, 0.75, curve: Curves.easeOut),
      ),
    );

    // Text slide animation (200ms - 600ms)
    textSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: animationController,
            curve: const Interval(0.25, 0.75, curve: Curves.easeOut),
          ),
        );

    // Gallery button fade (300ms - 650ms)
    galleryButtonAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.375, 0.8125, curve: Curves.easeOut),
      ),
    );

    // Gallery button slide (300ms - 650ms)
    galleryButtonSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 1.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: animationController,
            curve: const Interval(0.375, 0.8125, curve: Curves.easeOutBack),
          ),
        );

    // Camera button fade (400ms - 750ms)
    cameraButtonAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.5, 0.9375, curve: Curves.easeOut),
      ),
    );

    // Camera button slide (400ms - 750ms)
    cameraButtonSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 1.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: animationController,
            curve: const Interval(0.5, 0.9375, curve: Curves.easeOutBack),
          ),
        );

    // Breathing animation
    breathingAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: breathingController, curve: Curves.easeInOut),
    );
  }

  /// Start entrance animations and begin breathing
  Future<void> startAnimations() async {
    await animationController.forward();
    breathingController.repeat(reverse: true);
  }

  /// Dispose all animation controllers
  void dispose() {
    animationController.dispose();
    breathingController.dispose();
  }

  /// Get current breathing scale value
  double get breathingScale => breathingAnimation.value;

  /// Get current frame scale value
  double get frameScale => frameScaleAnimation.value;

  /// Get current frame fade value
  double get frameFade => frameFadeAnimation.value;

  /// Get current corner draw progress
  double get cornerProgress => cornerDrawAnimation.value;

  /// Get current text fade value
  double get textFade => textFadeAnimation.value;

  /// Get current text slide offset
  Offset get textSlide => textSlideAnimation.value;

  /// Get current gallery button fade value
  double get galleryButtonFade => galleryButtonAnimation.value;

  /// Get current gallery button slide offset
  Offset get galleryButtonSlide => galleryButtonSlideAnimation.value;

  /// Get current camera button fade value
  double get cameraButtonFade => cameraButtonAnimation.value;

  /// Get current camera button slide offset
  Offset get cameraButtonSlide => cameraButtonSlideAnimation.value;
}
