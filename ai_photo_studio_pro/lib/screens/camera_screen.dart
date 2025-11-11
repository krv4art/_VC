import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../l10n/app_localizations.dart';
import '../theme/theme_extensions_v2.dart';
import '../constants/app_dimensions.dart';
import '../widgets/common/app_spacer.dart';
import '../widgets/camera/camera_permission_denied.dart';
import '../widgets/camera/focus_indicator.dart';
import '../services/camera/camera_manager.dart';
import 'photo_confirmation_screen.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with TickerProviderStateMixin {
  final CameraManager _cameraManager = CameraManager();

  bool _isProcessing = false;
  Offset? _focusPoint;
  Timer? _focusTimer;
  bool _isFlashlightOn = false;
  bool _isFrontCamera = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    await _cameraManager.initializeCamera(context);
    if (mounted) {
      setState(() {
        _isFlashlightOn =
            _cameraManager.controller?.value.flashMode == FlashMode.torch;
      });
    }
  }

  @override
  void dispose() {
    _cameraManager.dispose();
    _focusTimer?.cancel();
    super.dispose();
  }

  Future<void> _takePicture() async {
    if (_cameraManager.controller == null ||
        !_cameraManager.controller!.value.isInitialized ||
        _isProcessing) {
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      final XFile picture = await _cameraManager.controller!.takePicture();

      if (!mounted) return;

      // Stop camera before navigating to confirmation screen
      await _cameraManager.stopCamera();

      // Show photo confirmation screen
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PhotoConfirmationScreen(
            photo: picture,
            onRetake: () async {
              Navigator.of(context).pop();
              // Reinitialize camera when returning from confirmation screen
              if (mounted) {
                await _initializeCamera();
              }
            },
            onConfirm: () async {
              Navigator.of(context).pop();

              if (mounted) {
                // TODO: Navigate to style selection screen with photo path
                // For now, just go back to home
                context.go('/home');
              }
            },
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      _showError('${l10n.error}: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  Future<void> _pickImageFromGallery() async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      await _cameraManager.stopCamera();

      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image != null && mounted) {
        // TODO: Navigate to style selection screen with photo path
        // For now, just go back to home
        context.go('/home');
      } else {
        setState(() {
          _isProcessing = false;
        });
        if (mounted) {
          await _initializeCamera();
        }
      }
    } catch (e) {
      final l10n = AppLocalizations.of(context)!;
      _showError('${l10n.error}: ${e.toString()}');
      setState(() {
        _isProcessing = false;
      });
      if (mounted) {
        await _initializeCamera();
      }
    }
  }

  Future<void> _onTapToFocus(TapDownDetails details) async {
    if (mounted) {
      final RenderBox renderBox = context.findRenderObject() as RenderBox;
      final Offset localPosition = renderBox.globalToLocal(
        details.globalPosition,
      );

      setState(() {
        _focusPoint = localPosition;
      });

      _focusTimer?.cancel();
      _focusTimer = Timer(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _focusPoint = null;
          });
        }
      });
    }

    _cameraManager.onTapToFocus(details, context);
  }

  Future<void> _toggleFlashlight() async {
    try {
      await _cameraManager.toggleFlashlight();

      if (mounted) {
        setState(() {
          _isFlashlightOn =
              _cameraManager.controller?.value.flashMode == FlashMode.torch;
        });
      }
    } catch (e) {
      debugPrint('Error toggling flashlight: $e');
    }
  }

  Future<void> _toggleCamera() async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
      _isFrontCamera = !_isFrontCamera;
    });

    try {
      await _cameraManager.stopCamera();
      await _initializeCamera();
    } catch (e) {
      debugPrint('Error toggling camera: $e');
      final l10n = AppLocalizations.of(context)!;
      _showError('${l10n.error}: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: context.colors.error,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          context.go('/home');
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
            onPressed: () => context.go('/home'),
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
              CameraPermissionDenied(
                onRetry: () {
                  _cameraManager.resetForRetry();
                  _initializeCamera();
                },
              )
            else if (_cameraManager.cameraState == CameraState.error)
              Container(
                color: Colors.black,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: context.colors.error,
                        size: AppDimensions.iconXLarge + AppDimensions.space16,
                      ),
                      AppSpacer.v16(),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppDimensions.space24,
                        ),
                        child: Text(
                          _cameraManager.errorMessage ??
                              l10n.failedToInitializeCamera,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: AppDimensions.space16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Container(
                color: Colors.black,
                child: Center(
                  child: CircularProgressIndicator(
                    color: context.colors.primary,
                  ),
                ),
              ),

            // UI Overlay
            if (_cameraManager.cameraState == CameraState.ready)
              _buildCameraOverlay(l10n),

            // Focus indicator
            if (_focusPoint != null) FocusIndicator(position: _focusPoint!),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraOverlay(AppLocalizations l10n) {
    return Column(
      children: [
        // Top controls
        SafeArea(
          child: Padding(
            padding: EdgeInsets.all(AppDimensions.space16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Camera toggle button
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(
                      _isFrontCamera ? Icons.camera_rear : Icons.camera_front,
                      color: Colors.white,
                      size: AppDimensions.iconLarge,
                    ),
                    onPressed: _isProcessing ? null : _toggleCamera,
                  ),
                ),
                AppSpacer.h12(),
                // Flashlight button (only for back camera)
                if (!_isFrontCamera)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        _isFlashlightOn ? Icons.flash_on : Icons.flash_off,
                        color: Colors.white,
                        size: AppDimensions.iconLarge,
                      ),
                      onPressed: _isProcessing ? null : _toggleFlashlight,
                    ),
                  ),
              ],
            ),
          ),
        ),

        const Spacer(),

        // Bottom controls
        SafeArea(
          child: Padding(
            padding: EdgeInsets.all(AppDimensions.space24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Gallery button
                GestureDetector(
                  onTap: _isProcessing ? null : _pickImageFromGallery,
                  child: Container(
                    width: AppDimensions.buttonLarge,
                    height: AppDimensions.buttonLarge,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radius12,
                      ),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.5),
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.photo_library_outlined,
                      color: Colors.white,
                      size: AppDimensions.iconLarge,
                    ),
                  ),
                ),

                // Capture button
                GestureDetector(
                  onTap: _isProcessing ? null : _takePicture,
                  child: Container(
                    width: AppDimensions.space64 + AppDimensions.space16,
                    height: AppDimensions.space64 + AppDimensions.space16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(AppDimensions.space4),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),

                // Placeholder for symmetry
                SizedBox(
                  width: AppDimensions.buttonLarge,
                  height: AppDimensions.buttonLarge,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
