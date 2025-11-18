import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

/// Camera service for document capture
/// Handles camera initialization, image capture, and camera lifecycle
class CameraService {
  static final CameraService _instance = CameraService._internal();
  factory CameraService() => _instance;
  CameraService._internal();

  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isInitialized = false;

  CameraController? get controller => _controller;
  bool get isInitialized => _isInitialized;

  /// Initialize camera service
  Future<void> initialize() async {
    try {
      // Get available cameras
      _cameras = await availableCameras();

      if (_cameras == null || _cameras!.isEmpty) {
        throw CameraException('NO_CAMERAS', 'No cameras found on device');
      }

      // Use back camera by default (better for document scanning)
      final camera = _cameras!.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => _cameras!.first,
      );

      // Initialize controller
      _controller = CameraController(
        camera,
        ResolutionPreset.high, // High quality for documents
        enableAudio: false, // No audio needed for document scanning
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await _controller!.initialize();
      _isInitialized = true;

      debugPrint('✅ Camera service initialized');
    } catch (e) {
      debugPrint('❌ Camera initialization failed: $e');
      _isInitialized = false;
      rethrow;
    }
  }

  /// Capture an image and return the file path
  Future<String> captureImage() async {
    if (!_isInitialized || _controller == null) {
      throw CameraException('NOT_INITIALIZED', 'Camera not initialized');
    }

    try {
      // Capture image
      final XFile image = await _controller!.takePicture();

      // Get temporary directory
      final Directory tempDir = await getTemporaryDirectory();
      final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final String fileName = 'scan_$timestamp.jpg';
      final String filePath = path.join(tempDir.path, fileName);

      // Copy to permanent location
      final File savedFile = await File(image.path).copy(filePath);

      debugPrint('✅ Image captured: $filePath');
      return savedFile.path;
    } catch (e) {
      debugPrint('❌ Image capture failed: $e');
      rethrow;
    }
  }

  /// Switch between front and back camera
  Future<void> switchCamera() async {
    if (_cameras == null || _cameras!.length < 2) {
      throw CameraException('NO_SWITCH', 'Only one camera available');
    }

    try {
      // Get current camera direction
      final currentDirection = _controller?.description.lensDirection;

      // Find opposite camera
      final newCamera = _cameras!.firstWhere(
        (camera) => camera.lensDirection != currentDirection,
        orElse: () => _cameras!.first,
      );

      // Dispose current controller
      await _controller?.dispose();

      // Initialize new controller
      _controller = CameraController(
        newCamera,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await _controller!.initialize();
      debugPrint('✅ Camera switched');
    } catch (e) {
      debugPrint('❌ Camera switch failed: $e');
      rethrow;
    }
  }

  /// Set flash mode
  Future<void> setFlashMode(FlashMode mode) async {
    if (!_isInitialized || _controller == null) {
      throw CameraException('NOT_INITIALIZED', 'Camera not initialized');
    }

    try {
      await _controller!.setFlashMode(mode);
      debugPrint('✅ Flash mode set to: $mode');
    } catch (e) {
      debugPrint('❌ Flash mode change failed: $e');
      rethrow;
    }
  }

  /// Set zoom level (0.0 - 1.0)
  Future<void> setZoomLevel(double zoom) async {
    if (!_isInitialized || _controller == null) {
      throw CameraException('NOT_INITIALIZED', 'Camera not initialized');
    }

    try {
      final maxZoom = await _controller!.getMaxZoomLevel();
      final minZoom = await _controller!.getMinZoomLevel();
      final targetZoom = minZoom + (maxZoom - minZoom) * zoom;
      await _controller!.setZoomLevel(targetZoom);
    } catch (e) {
      debugPrint('❌ Zoom level change failed: $e');
      rethrow;
    }
  }

  /// Dispose camera resources
  Future<void> dispose() async {
    await _controller?.dispose();
    _controller = null;
    _isInitialized = false;
    debugPrint('✅ Camera service disposed');
  }
}
