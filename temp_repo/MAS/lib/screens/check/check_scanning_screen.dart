import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../theme/app_theme.dart';
import '../../services/camera/camera_manager.dart';
import '../../widgets/camera/camera_permission_denied.dart';
import '../../widgets/camera/focus_indicator.dart';
import '../../widgets/scanning/math_processing_overlay.dart';
import '../../widgets/check/check_scan_overlay.dart';
import '../solve/photo_confirmation_screen.dart';

/// Screen for scanning handwritten solutions for validation
class CheckScanningScreen extends StatefulWidget {
  const CheckScanningScreen({super.key});

  @override
  State<CheckScanningScreen> createState() => _CheckScanningScreenState();
}

class _CheckScanningScreenState extends State<CheckScanningScreen>
    with TickerProviderStateMixin {
  final CameraManager _cameraManager = CameraManager();

  late AnimationController _entranceController;
  late AnimationController _pulseController;

  bool _isProcessing = false;
  bool _showSlowNetworkWarning = false;
  Offset? _focusPoint;
  Timer? _focusTimer;
  Timer? _slowNetworkTimer;
  bool _isFlashlightOn = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeCamera();
  }

  void _setupAnimations() {
    _entranceController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _entranceController.forward();
    _pulseController.repeat(reverse: true);
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
    _entranceController.dispose();
    _pulseController.dispose();
    _cameraManager.dispose();
    _focusTimer?.cancel();
    _slowNetworkTimer?.cancel();
    super.dispose();
  }

  Future<void> _takeAndAnalyzePicture() async {
    if (_cameraManager.controller == null ||
        !_cameraManager.controller!.value.isInitialized ||
        _isProcessing) {
      return;
    }

    try {
      final XFile picture = await _cameraManager.controller!.takePicture();

      if (!mounted) return;

      await _cameraManager.stopCamera();

      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PhotoConfirmationScreen(
            photoFile: picture,
            onRetake: () async {
              Navigator.of(context).pop();
              if (mounted) {
                await _initializeCamera();
              }
            },
            onConfirm: () async {
              Navigator.of(context).pop();
              await Future.delayed(Duration.zero);
              if (mounted) {
                _processImage(picture);
              }
            },
          ),
        ),
      );
    } catch (e) {
      _showError('Не удалось сделать фото: ${e.toString()}');
    }
  }

  Future<void> _processImage(XFile imageFile) async {
    setState(() {
      _isProcessing = true;
      _showSlowNetworkWarning = false;
    });

    _slowNetworkTimer?.cancel();
    _slowNetworkTimer = Timer(const Duration(seconds: 5), () {
      if (mounted && _isProcessing) {
        setState(() {
          _showSlowNetworkWarning = true;
        });
      }
    });

    try {
      // TODO: Integrate with MathImageProcessingService in CHECK mode
      await Future.delayed(const Duration(seconds: 3));

      _slowNetworkTimer?.cancel();

      if (!mounted) return;

      setState(() {
        _isProcessing = false;
        _showSlowNetworkWarning = false;
      });

      _showError('Проверка завершена! (ValidationResultsScreen будет создан)');
      await _initializeCamera();
    } catch (e) {
      _slowNetworkTimer?.cancel();

      if (!mounted) return;

      setState(() {
        _isProcessing = false;
        _showSlowNetworkWarning = false;
      });

      _showError('Ошибка проверки: ${e.toString()}');
      await _initializeCamera();
    }
  }

  Future<void> _pickImageFromGallery() async {
    if (_isProcessing) return;

    try {
      await _cameraManager.stopCamera();

      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        await _processImage(image);
      } else {
        if (mounted) {
          await _initializeCamera();
        }
      }
    } catch (e) {
      _showError('Ошибка выбора изображения: ${e.toString()}');
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

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red.shade700,
          duration: const Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          context.go('/');
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
            onPressed: () => context.go('/'),
          ),
          title: const Text(
            'Перевірити рішення',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
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
                        color: Colors.red.shade400,
                        size: 80,
                      ),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          _cameraManager.errorMessage ??
                              'Не удалось инициализировать камеру',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
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
                    color: Colors.green.shade400,
                  ),
                ),
              ),

            if (_cameraManager.cameraState == CameraState.ready)
              CheckScanOverlay(
                entranceController: _entranceController,
                pulseController: _pulseController,
                isProcessing: _isProcessing,
                onCameraTap: _takeAndAnalyzePicture,
                onGalleryTap: _pickImageFromGallery,
                onFlashlightTap: _toggleFlashlight,
                isFlashlightOn: _isFlashlightOn,
              ),

            if (_focusPoint != null) FocusIndicator(position: _focusPoint!),

            if (_isProcessing)
              MathProcessingOverlay(
                showNetworkWarning: _showSlowNetworkWarning,
                customMessage: 'Проверяю решение...',
              ),
          ],
        ),
      ),
    );
  }
}
