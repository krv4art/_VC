import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';

enum CameraState { initializing, ready, permissionDenied, error }

/// Service for managing camera initialization and permissions
class CameraManager {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  CameraState _cameraState = CameraState.initializing;
  String? _errorMessage;

  /// Get current camera state
  CameraState get cameraState => _cameraState;

  /// Get current camera controller
  CameraController? get controller => _controller;

  /// Get error message
  String? get errorMessage => _errorMessage;

  /// Initialize camera with permission check
  Future<void> initializeCamera(BuildContext context) async {
    try {
      // Check camera permission first
      final cameraStatus = await Permission.camera.status;

      if (cameraStatus.isDenied || cameraStatus.isPermanentlyDenied) {
        // Request permission if denied
        final result = await Permission.camera.request();

        if (result.isDenied || result.isPermanentlyDenied) {
          // Permission denied
          _cameraState = CameraState.permissionDenied;
          return;
        }
      }

      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
        _controller = CameraController(
          _cameras![0],
          ResolutionPreset.high,
          enableAudio: false,
        );
        await _controller!.initialize();

        // Turn off flash on initialization
        await _controller!.setFlashMode(FlashMode.off);

        _cameraState = CameraState.ready;
      } else {
        _cameraState = CameraState.error;
        _errorMessage = 'No cameras found on this device';
      }
    } catch (e) {
      _cameraState = CameraState.error;
      _errorMessage = 'Failed to initialize camera: ${e.toString()}';
    }
  }

  /// Handle tap to focus
  Future<void> onTapToFocus(
    TapDownDetails details,
    BuildContext context,
  ) async {
    if (_controller == null || !_controller!.value.isInitialized) {
      return;
    }

    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset localPosition = renderBox.globalToLocal(
      details.globalPosition,
    );
    final Size size = renderBox.size;

    // Convert tap coordinates to camera coordinates (0.0 - 1.0)
    final double x = localPosition.dx / size.width;
    final double y = localPosition.dy / size.height;

    try {
      // Set focus point
      await _controller!.setFocusPoint(Offset(x, y));
      await _controller!.setExposurePoint(Offset(x, y));
    } catch (e) {
      debugPrint('Error setting focus: $e');
    }
  }

  /// Stop camera completely
  Future<void> stopCamera() async {
    if (_controller != null && _controller!.value.isInitialized) {
      try {
        await _controller!.dispose();
        _controller = null;
        _cameraState = CameraState.initializing;
      } catch (e) {
        debugPrint('Error stopping camera: $e');
        _controller = null;
        _cameraState = CameraState.initializing;
      }
    }
  }

  /// Pause camera preview
  Future<void> pausePreview() async {
    try {
      if (_controller != null && _controller!.value.isInitialized) {
        await _controller!.pausePreview();
      }
    } catch (e) {
      debugPrint('Error pausing camera preview: $e');
    }
  }

  /// Dispose camera resources
  void dispose() {
    _controller?.dispose();
  }

  /// Reset camera state for retry
  void resetForRetry() {
    _cameraState = CameraState.initializing;
    _errorMessage = null;
  }
}
