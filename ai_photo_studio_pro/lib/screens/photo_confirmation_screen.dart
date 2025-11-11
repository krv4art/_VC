import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../l10n/app_localizations.dart';
import '../theme/theme_extensions_v2.dart';
import '../constants/app_dimensions.dart';

class PhotoConfirmationScreen extends StatefulWidget {
  final XFile photo;
  final VoidCallback onRetake;
  final VoidCallback onConfirm;

  const PhotoConfirmationScreen({
    super.key,
    required this.photo,
    required this.onRetake,
    required this.onConfirm,
  });

  @override
  State<PhotoConfirmationScreen> createState() =>
      _PhotoConfirmationScreenState();
}

class _PhotoConfirmationScreenState extends State<PhotoConfirmationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _buttonFadeAnimation;
  late Animation<Offset> _buttonSlideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _animationController.forward();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    // Image fade animation
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    // Image slide animation
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
          ),
        );

    // Buttons fade animation
    _buttonFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 0.8, curve: Curves.easeOut),
      ),
    );

    // Buttons slide animation
    _buttonSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 1.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.3, 0.8, curve: Curves.easeOutBack),
          ),
        );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: widget.onRetake,
        ),
        title: null,
      ),
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Stack(
            fit: StackFit.expand,
            children: [
              // Photo preview
              FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Image.file(File(widget.photo.path), fit: BoxFit.cover),
                ),
              ),

              // Buttons container
              Column(
                children: [
                  // Add space for app bar
                  const SizedBox(height: kToolbarHeight),
                  const Expanded(child: SizedBox()), // Push buttons to bottom
                  // Buttons
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: AppDimensions.buttonLarge + AppDimensions.space4,
                    ),
                    child: FadeTransition(
                      opacity: _buttonFadeAnimation,
                      child: SlideTransition(
                        position: _buttonSlideAnimation,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Retake button (cross icon)
                            GestureDetector(
                              onTap: widget.onRetake,
                              child: Container(
                                height:
                                    AppDimensions.buttonLarge +
                                    AppDimensions.space8,
                                width:
                                    AppDimensions.buttonLarge +
                                    AppDimensions.space8,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withValues(alpha: 0.3),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.7),
                                    width: 2,
                                  ),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: AppDimensions.iconLarge,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: AppDimensions.space40),
                            // Confirm button (checkmark icon)
                            GestureDetector(
                              onTap: widget.onConfirm,
                              child: Container(
                                height:
                                    AppDimensions.space64 +
                                    AppDimensions.radius12,
                                width:
                                    AppDimensions.space64 +
                                    AppDimensions.radius12,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: context.colors.primary,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 5,
                                  ),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size:
                                        AppDimensions.space40 +
                                        AppDimensions.space4,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width:
                                  AppDimensions.space64 + AppDimensions.space32,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
