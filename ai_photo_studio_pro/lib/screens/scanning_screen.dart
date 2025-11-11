import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../providers/ai_bot_provider.dart';
import '../l10n/app_localizations.dart';
import '../theme/theme_extensions_v2.dart';
import '../constants/app_dimensions.dart';
import '../widgets/common/app_spacer.dart';
import '../widgets/camera/camera_scan_overlay.dart';
import '../widgets/camera/camera_permission_denied.dart';
import '../widgets/camera/focus_indicator.dart';
import '../widgets/scanning/joke_bubble_widget.dart';
import '../widgets/scanning/processing_overlay.dart';
import '../widgets/dialogs/scanning_hint_dialog.dart';
import '../services/camera/camera_manager.dart';
import '../services/scanning/image_analysis_service.dart';
import '../services/scanning/scanning_animation_controller.dart';
import 'photo_confirmation_screen.dart';

class ScanningScreen extends StatefulWidget {
  const ScanningScreen({super.key});

  @override
  State<ScanningScreen> createState() => _ScanningScreenState();
}

class _ScanningScreenState extends State<ScanningScreen>
    with TickerProviderStateMixin {
  final CameraManager _cameraManager = CameraManager();
  late ScanningAnimationController _animationController;

  bool _isProcessing = false;
  bool _showSlowInternetMessage = false;
  Offset? _focusPoint;
  Timer? _focusTimer;
  bool _isFlashlightOn = false;

  // Joke bubble state
  String? _jokeText;
  String? _jokeBotName;
  bool _isJokeBubbleVisible = false;

  @override
  void initState() {
    super.initState();
    _animationController = ScanningAnimationController(vsync: this);
    _animationController.initializeAnimations();
    _animationController.startAnimations();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    await _cameraManager.initializeCamera(context);
    if (mounted) {
      setState(() {
        // Синхронизируем состояние фонарика с камерой
        _isFlashlightOn =
            _cameraManager.controller?.value.flashMode == FlashMode.torch;
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _cameraManager.dispose();
    _focusTimer?.cancel();
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
      _showSlowInternetMessage = false;
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

              // Даём UI время на один фрейм, чтобы завершить закрытие PhotoConfirmationScreen
              // и подготовиться к показу ProcessingOverlay
              await Future.delayed(Duration.zero);

              if (mounted) {
                _processImage(picture);
              }
            },
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      _showError('${l10n.analysisFailed} ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  Future<void> _processImage(XFile imageFile) async {
    setState(() {
      _isProcessing = true;
      _showSlowInternetMessage = false;
    });

    final analysisService = const ImageAnalysisService();

    final result = await analysisService.processImage(
      imageFile,
      context: context,
      showSlowInternetMessage: false,
      onSlowInternetMessage: () {
        if (mounted) {
          setState(() {
            _showSlowInternetMessage = true;
          });
        }
      },
    );

    if (mounted) {
      if (result.shouldShowJoke && result.jokeText != null) {
        setState(() {
          _isProcessing = false;
          _showSlowInternetMessage = false;
        });
        _showJokeBubble(result.jokeText!);
        // Reinitialize camera after showing joke
        await _initializeCamera();
      } else if (result.analysisResult != null && result.imagePath != null) {
        // Полностью останавливаем камеру перед навигацией
        await _cameraManager.stopCamera();

        // Не скрываем диалог перед навигацией - пусть остаётся видимым пока меняется экран
        // Используем go чтобы заменить весь стек навигации и убедиться что
        // экран подтверждения фото не останется в стеке при возврате
        if (mounted) {
          context.go(
            '/analysis',
            extra: {
              'result': result.analysisResult,
              'imagePath': result.imagePath,
              'source': 'scanning',
            },
          );
        }
      } else {
        setState(() {
          _isProcessing = false;
          _showSlowInternetMessage = false;
        });
        // Reinitialize camera on error
        await _initializeCamera();
      }
    }
  }

  Future<void> _pickImageFromGallery() async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    // Сохраняем локализацию перед асинхронными операциями
    final l10n = AppLocalizations.of(context)!;

    try {
      // Stop camera before picking from gallery
      await _cameraManager.stopCamera();

      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

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
      _showError('${l10n.analysisFailed} ${e.toString()}');
      setState(() {
        _isProcessing = false;
      });
      // Reinitialize camera on error
      if (mounted) {
        await _initializeCamera();
      }
    }
  }

  Future<void> _onTapToFocus(TapDownDetails details) async {
    // Показываем индикатор фокусировки МГНОВЕННО для instant feedback
    if (mounted) {
      final RenderBox renderBox = context.findRenderObject() as RenderBox;
      final Offset localPosition = renderBox.globalToLocal(
        details.globalPosition,
      );

      setState(() {
        _focusPoint = localPosition;
      });

      // Скрываем индикатор через 2 секунды
      _focusTimer?.cancel();
      _focusTimer = Timer(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _focusPoint = null;
          });
        }
      });
    }

    // Запускаем фокусировку камеры параллельно (без блокировки UI)
    _cameraManager.onTapToFocus(details, context);
  }

  Future<void> _toggleFlashlight() async {
    try {
      await _cameraManager.toggleFlashlight();

      // Обновляем состояние UI после успешного выполнения
      if (mounted) {
        setState(() {
          _isFlashlightOn =
              _cameraManager.controller?.value.flashMode == FlashMode.torch;
        });
      }
    } catch (e) {
      debugPrint('Error toggling flashlight in UI: $e');
    }
  }

  void _showJokeBubble(String jokeText) {
    final botProvider = context.read<AiBotProvider>();
    final botName = botProvider.botName;

    setState(() {
      _jokeText = jokeText;
      _jokeBotName = botName;
      _isJokeBubbleVisible = true;
    });
  }

  void _hideJokeBubble() async {
    setState(() {
      _isJokeBubbleVisible = false;
      _jokeText = null;
      _jokeBotName = null;
    });
    // Reinitialize camera after hiding joke bubble
    if (mounted) {
      await _initializeCamera();
    }
  }

  void _showHintDialog() {
    ScanningHintDialog.show(context);
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: context.colors.error,
          duration: const Duration(seconds: 10),
          action: SnackBarAction(
            label: '',
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
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
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => context.go('/home'),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.question_mark, color: Colors.white),
              onPressed: _showHintDialog,
            ),
          ],
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

            // UI Overlay (only show when camera is ready)
            if (_cameraManager.cameraState == CameraState.ready)
              CameraScanOverlay(
                animationController: _animationController.animationController,
                breathingController: _animationController.breathingController,
                isProcessing: _isProcessing,
                showSlowInternetMessage: _showSlowInternetMessage,
                onCameraTap: _takeAndAnalyzePicture,
                onGalleryTap: _pickImageFromGallery,
                onFlashlightTap: _toggleFlashlight,
                isFlashlightOn: _isFlashlightOn,
              ),

            // Индикатор фокусировки
            if (_focusPoint != null) FocusIndicator(position: _focusPoint!),

            // Пузырь с шуткой
            if (_isJokeBubbleVisible &&
                _jokeText != null &&
                _jokeBotName != null)
              JokeBubbleWidget(
                jokeText: _jokeText!,
                botName: _jokeBotName!,
                onDismiss: _hideJokeBubble,
              ),

            // Processing overlay
            if (_isProcessing)
              ProcessingOverlay(
                showSlowInternetMessage: _showSlowInternetMessage,
              ),
          ],
        ),
      ),
    );
  }
}
