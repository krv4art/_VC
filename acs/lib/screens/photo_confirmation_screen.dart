import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../l10n/app_localizations.dart';
import '../theme/theme_extensions_v2.dart';
import '../constants/app_dimensions.dart';
import '../models/scan_image.dart';

class PhotoConfirmationScreen extends StatefulWidget {
  final XFile photo;
  final VoidCallback onRetake;
  final Function(ImageType type) onConfirm;
  final ImageType? suggestedType;

  const PhotoConfirmationScreen({
    super.key,
    required this.photo,
    required this.onRetake,
    required this.onConfirm,
    this.suggestedType,
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
  late ImageType _selectedType;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.suggestedType ?? ImageType.ingredients;
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

  Widget _buildTypeOption({
    required String label,
    required ImageType type,
    required IconData icon,
  }) {
    final isSelected = _selectedType == type;
    return GestureDetector(
      onTap: () => setState(() => _selectedType = type),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white.withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Colors.white
                : Colors.white.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 28,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
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

                  // Type selector
                  FadeTransition(
                    opacity: _buttonFadeAnimation,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Что на этом фото?',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _buildTypeOption(
                                  label: 'Главная этикетка',
                                  type: ImageType.frontLabel,
                                  icon: Icons.label_outline,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildTypeOption(
                                  label: 'Состав',
                                  type: ImageType.ingredients,
                                  icon: Icons.list_alt,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

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
                              onTap: () => widget.onConfirm(_selectedType),
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
