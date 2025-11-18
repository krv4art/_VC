import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:camera/camera.dart';
import '../services/scanning/camera_service.dart';
import '../services/scanning/scan_orchestrator_service.dart';

/// Provider for scanning state management
/// Manages camera state, scan session, and scanning operations
class ScanProvider with ChangeNotifier {
  final _cameraService = CameraService();
  final _orchestrator = ScanOrchestratorService();

  // Camera state
  bool _isCameraInitialized = false;
  bool _isCapturing = false;
  FlashMode _flashMode = FlashMode.off;
  double _zoomLevel = 0.0;

  // Scan session state
  ScanSession? _currentSession;
  bool _isProcessing = false;
  String? _error;

  // Getters
  bool get isCameraInitialized => _isCameraInitialized;
  bool get isCapturing => _isCapturing;
  FlashMode get flashMode => _flashMode;
  double get zoomLevel => _zoomLevel;
  ScanSession? get currentSession => _currentSession;
  bool get isProcessing => _isProcessing;
  String? get error => _error;
  CameraController? get cameraController => _cameraService.controller;

  /// Initialize camera
  Future<void> initializeCamera() async {
    try {
      _error = null;
      notifyListeners();

      await _cameraService.initialize();
      _isCameraInitialized = true;
      notifyListeners();

      debugPrint('✅ Camera initialized via provider');
    } catch (e) {
      _error = 'Failed to initialize camera: $e';
      _isCameraInitialized = false;
      notifyListeners();
      debugPrint('❌ Camera initialization failed: $e');
    }
  }

  /// Start a new scan session
  Future<void> startScanSession() async {
    try {
      _error = null;
      _currentSession = await _orchestrator.startScanSession();
      notifyListeners();
      debugPrint('✅ Scan session started');
    } catch (e) {
      _error = 'Failed to start scan session: $e';
      notifyListeners();
      debugPrint('❌ Failed to start scan session: $e');
    }
  }

  /// Capture a page
  Future<void> capturePage({
    bool autoEnhance = true,
    bool autoDetectEdges = true,
  }) async {
    if (_isCapturing || _currentSession == null) return;

    try {
      _isCapturing = true;
      _error = null;
      notifyListeners();

      final page = await _orchestrator.capturePage(
        autoEnhance: autoEnhance,
        autoDetectEdges: autoDetectEdges,
      );

      _currentSession = _orchestrator.currentSession;
      _isCapturing = false;
      notifyListeners();

      debugPrint('✅ Page captured: ${page.pageNumber}');
    } catch (e) {
      _error = 'Failed to capture page: $e';
      _isCapturing = false;
      notifyListeners();
      debugPrint('❌ Failed to capture page: $e');
    }
  }

  /// Process a page with custom edges
  Future<void> processPage(
    ScannedPage page, {
    List<ui.Offset>? customEdges,
    bool applyPerspectiveCorrection = true,
    bool convertToGrayscale = false,
  }) async {
    if (_isProcessing) return;

    try {
      _isProcessing = true;
      _error = null;
      notifyListeners();

      await _orchestrator.processPage(
        page,
        customEdges: customEdges,
        applyPerspectiveCorrection: applyPerspectiveCorrection,
        convertToGrayscale: convertToGrayscale,
      );

      _currentSession = _orchestrator.currentSession;
      _isProcessing = false;
      notifyListeners();

      debugPrint('✅ Page processed');
    } catch (e) {
      _error = 'Failed to process page: $e';
      _isProcessing = false;
      notifyListeners();
      debugPrint('❌ Failed to process page: $e');
    }
  }

  /// Delete a page
  Future<void> deletePage(String pageId) async {
    try {
      _error = null;
      await _orchestrator.deletePage(pageId);
      _currentSession = _orchestrator.currentSession;
      notifyListeners();
      debugPrint('✅ Page deleted');
    } catch (e) {
      _error = 'Failed to delete page: $e';
      notifyListeners();
      debugPrint('❌ Failed to delete page: $e');
    }
  }

  /// Reorder pages
  void reorderPages(int oldIndex, int newIndex) {
    _orchestrator.reorderPages(oldIndex, newIndex);
    _currentSession = _orchestrator.currentSession;
    notifyListeners();
  }

  /// Finalize scan session
  Future<ScanSession?> finalizeScanSession() async {
    try {
      _error = null;
      final session = await _orchestrator.finalizeScanSession();
      _currentSession = null;
      notifyListeners();
      debugPrint('✅ Scan session finalized');
      return session;
    } catch (e) {
      _error = 'Failed to finalize scan session: $e';
      notifyListeners();
      debugPrint('❌ Failed to finalize scan session: $e');
      return null;
    }
  }

  /// Cancel scan session
  Future<void> cancelScanSession() async {
    try {
      _error = null;
      await _orchestrator.cancelScanSession();
      _currentSession = null;
      notifyListeners();
      debugPrint('✅ Scan session cancelled');
    } catch (e) {
      _error = 'Failed to cancel scan session: $e';
      notifyListeners();
      debugPrint('❌ Failed to cancel scan session: $e');
    }
  }

  /// Toggle flash
  Future<void> toggleFlash() async {
    try {
      final newMode = _flashMode == FlashMode.off ? FlashMode.torch : FlashMode.off;
      await _cameraService.setFlashMode(newMode);
      _flashMode = newMode;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to toggle flash: $e';
      notifyListeners();
    }
  }

  /// Set zoom level (0.0 to 1.0)
  Future<void> setZoom(double level) async {
    try {
      await _cameraService.setZoomLevel(level);
      _zoomLevel = level;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to set zoom: $e';
      notifyListeners();
    }
  }

  /// Switch camera (front/back)
  Future<void> switchCamera() async {
    try {
      _error = null;
      await _cameraService.switchCamera();
      notifyListeners();
    } catch (e) {
      _error = 'Failed to switch camera: $e';
      notifyListeners();
    }
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Dispose resources
  @override
  void dispose() {
    _cameraService.dispose();
    super.dispose();
  }
}
