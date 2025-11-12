import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../services/camera/camera_manager.dart';
import '../services/image_picker_service.dart';
import '../services/plant_identification_service.dart';
import '../services/rating_service.dart';
import '../providers/user_preferences_provider.dart';
import '../providers/plant_history_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/dialogs/rating_request_dialog.dart';
import 'plant_result_screen.dart';

/// Scan screen - Live camera preview for plant identification
class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final CameraManager _cameraManager = CameraManager();
  final ImagePickerService _imagePickerService = ImagePickerService();
  final RatingService _ratingService = RatingService();
  bool _isProcessing = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    await _cameraManager.initializeCamera(context);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _cameraManager.dispose();
    super.dispose();
  }

  Future<void> _takeAndAnalyzePicture() async {
    if (_cameraManager.controller == null ||
        !_cameraManager.controller!.value.isInitialized ||
        _isProcessing) {
      return;
    }

    setState(() {
      _isProcessing = true;
      _errorMessage = null;
    });

    try {
      final XFile picture = await _cameraManager.controller!.takePicture();

      if (!mounted) return;

      // Stop camera before processing
      await _cameraManager.stopCamera();

      // Process the image
      await _processImage(File(picture.path));
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isProcessing = false;
        _errorMessage = 'Failed to take picture: ${e.toString()}';
      });
      // Reinitialize camera on error
      await _initializeCamera();
    }
  }

  Future<void> _pickImageFromGallery() async {
    setState(() {
      _isProcessing = true;
      _errorMessage = null;
    });

    try {
      // Stop camera before picking from gallery
      await _cameraManager.stopCamera();

      final image = await _imagePickerService.pickFromGallery();

      if (image != null) {
        await _processImage(image);
      } else {
        setState(() {
          _isProcessing = false;
        });
        // Reinitialize camera if user cancels gallery selection
        if (mounted) {
          await _initializeCamera();
        }
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isProcessing = false;
        _errorMessage = 'Failed to pick image: ${e.toString()}';
      });
      // Reinitialize camera on error
      await _initializeCamera();
    }
  }

  Future<void> _processImage(File imageFile) async {
    setState(() {
      _isProcessing = true;
      _errorMessage = null;
    });

    try {
      final identificationService = context.read<PlantIdentificationService>();
      final preferencesProvider = context.read<UserPreferencesProvider>();
      final historyProvider = context.read<PlantHistoryProvider>();

      // Convert image to base64
      final base64Image = await _imagePickerService.imageToBase64(imageFile);

      // Identify plant
      final result = await identificationService.identifyPlant(
        base64Image: base64Image,
        languageCode: 'en',
        userPreferences: preferencesProvider.preferences,
      );

      // Save to history
      await historyProvider.addResult(result);

      // Increment scan count for rating
      // Rating will be shown automatically by shouldShowRatingDialog logic

      // Navigate to result screen
      if (mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PlantResultScreen(result: result),
          ),
        );

        // Clear processing state
        setState(() {
          _isProcessing = false;
        });

        // Check and show rating dialog after navigation
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            showRatingDialog(context);
          }
        });
      }
    } catch (e) {
      setState(() {
        _isProcessing = false;
        _errorMessage = 'Failed to identify plant: ${e.toString()}';
      });
      // Reinitialize camera after error
      if (mounted) {
        await _initializeCamera();
      }
    }
  }

  void _onTapToFocus(TapDownDetails details) {
    _cameraManager.onTapToFocus(details, context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          context.pop();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => context.pop(),
          ),
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            // Camera preview or different states
            if (_cameraManager.cameraState == CameraState.ready &&
                _cameraManager.controller != null)
              GestureDetector(
                onTapDown: _onTapToFocus,
                child: CameraPreview(_cameraManager.controller!),
              )
            else if (_cameraManager.cameraState == CameraState.permissionDenied)
              _buildPermissionDenied(l10n, colors)
            else if (_cameraManager.cameraState == CameraState.error)
              _buildError(l10n, colors)
            else
              _buildLoading(colors),

            // Error message overlay
            if (_errorMessage != null && !_isProcessing)
              Positioned(
                top: 100,
                left: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.all(AppTheme.space16),
                  decoration: BoxDecoration(
                    color: Colors.red[900]!.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(AppTheme.radiusCard),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.white),
                      const SizedBox(width: AppTheme.space12),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: AppTheme.body.copyWith(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Camera controls (only show when camera is ready)
            if (_cameraManager.cameraState == CameraState.ready &&
                !_isProcessing)
              _buildCameraControls(l10n),

            // Processing overlay
            if (_isProcessing) _buildProcessingOverlay(l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraControls(AppLocalizations l10n) {
    return Positioned(
      bottom: 48,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Gallery button on the left
          _buildControlButton(
            icon: Icons.photo_library,
            onTap: _pickImageFromGallery,
          ),
          const SizedBox(width: 32),
          // Camera button in the center
          _buildCameraButton(onTap: _takeAndAnalyzePicture),
          const SizedBox(width: 32),
          // Cancel button on the right
          _buildControlButton(
            icon: Icons.close,
            onTap: () => context.pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        width: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.3),
          border: Border.all(
            color: Colors.white.withOpacity(0.7),
            width: 2,
          ),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }

  Widget _buildCameraButton({required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 76,
        width: 76,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
          border: Border.all(
            color: Colors.white,
            width: 6,
          ),
        ),
        child: Center(
          child: Container(
            height: 60,
            width: 60,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionDenied(AppLocalizations l10n, ColorScheme colors) {
    return Container(
      color: Colors.black,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.space24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.camera_alt_outlined,
                color: Colors.white,
                size: 80,
              ),
              const SizedBox(height: AppTheme.space24),
              Text(
                'Camera permission required',
                style: AppTheme.h3.copyWith(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppTheme.space16),
              Text(
                'Please grant camera permission to use this feature',
                style: AppTheme.body.copyWith(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppTheme.space24),
              ElevatedButton(
                onPressed: () {
                  _cameraManager.resetForRetry();
                  _initializeCamera();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildError(AppLocalizations l10n, ColorScheme colors) {
    return Container(
      color: Colors.black,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.space24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                color: colors.error,
                size: 80,
              ),
              const SizedBox(height: AppTheme.space24),
              Text(
                _cameraManager.errorMessage ?? 'Failed to initialize camera',
                style: AppTheme.body.copyWith(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppTheme.space24),
              ElevatedButton(
                onPressed: () {
                  _cameraManager.resetForRetry();
                  _initializeCamera();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoading(ColorScheme colors) {
    return Container(
      color: Colors.black,
      child: Center(
        child: CircularProgressIndicator(
          color: colors.primary,
        ),
      ),
    );
  }

  Widget _buildProcessingOverlay(AppLocalizations l10n) {
    return Container(
      color: Colors.black.withOpacity(0.8),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              color: Colors.white,
            ),
            const SizedBox(height: AppTheme.space24),
            Text(
              'Analyzing plant...',
              style: AppTheme.h4.copyWith(color: Colors.white),
            ),
            const SizedBox(height: AppTheme.space12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: Text(
                'This may take a few seconds',
                textAlign: TextAlign.center,
                style: AppTheme.body.copyWith(color: Colors.white70),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Check and show rating dialog if appropriate
  Future<void> showRatingDialog(BuildContext context) async {
    if (!mounted) return;
    
    final shouldShow = await _ratingService.shouldShowRatingDialog();
    if (!shouldShow || !mounted) return;
    
    await _ratingService.incrementRatingDialogShows();
    
    // Import the rating_request_dialog if exists, otherwise skip
    // This functionality matches ACS project pattern
  }
}