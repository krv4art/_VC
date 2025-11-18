import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'camera_service.dart';
import 'image_processor_service.dart';
import 'edge_detection_service.dart';
import '../../models/pdf_document.dart';
import '../../config/app_config.dart';

/// Scan orchestrator service
/// Orchestrates the complete document scanning workflow
/// Similar to ACS's image_analysis_service orchestration pattern
class ScanOrchestratorService {
  static final ScanOrchestratorService _instance = ScanOrchestratorService._internal();
  factory ScanOrchestratorService() => _instance;
  ScanOrchestratorService._internal();

  final _cameraService = CameraService();
  final _imageProcessor = ImageProcessorService();
  final _edgeDetection = EdgeDetectionService();
  final _uuid = const Uuid();

  /// Current scan session
  ScanSession? _currentSession;

  ScanSession? get currentSession => _currentSession;

  /// Start a new scan session
  Future<ScanSession> startScanSession() async {
    try {
      _currentSession = ScanSession(
        id: _uuid.v4(),
        startTime: DateTime.now(),
        pages: [],
      );

      debugPrint('✅ Scan session started: ${_currentSession!.id}');
      return _currentSession!;
    } catch (e) {
      debugPrint('❌ Failed to start scan session: $e');
      rethrow;
    }
  }

  /// Capture a page in the current scan session
  Future<ScannedPage> capturePage({
    bool autoEnhance = true,
    bool autoDetectEdges = true,
  }) async {
    if (_currentSession == null) {
      throw Exception('No active scan session. Call startScanSession() first.');
    }

    try {
      // 1. Capture image from camera
      debugPrint('📸 Capturing image...');
      final imagePath = await _cameraService.captureImage();

      // 2. Detect edges (if enabled)
      List<ui.Offset>? edges;
      if (autoDetectEdges) {
        debugPrint('🔍 Detecting edges...');
        edges = await _edgeDetection.detectEdges(imagePath);
      }

      // 3. Enhance image (if enabled)
      String processedPath = imagePath;
      if (autoEnhance) {
        debugPrint('✨ Enhancing image...');
        processedPath = await _imageProcessor.enhanceImage(imagePath);
      }

      // 4. Generate thumbnail
      debugPrint('🖼️ Generating thumbnail...');
      final thumbnailPath = await _imageProcessor.generateThumbnail(processedPath);

      // 5. Create scanned page
      final page = ScannedPage(
        id: _uuid.v4(),
        originalPath: imagePath,
        processedPath: processedPath,
        thumbnailPath: thumbnailPath,
        detectedEdges: edges,
        captureTime: DateTime.now(),
        pageNumber: _currentSession!.pages.length + 1,
      );

      // 6. Add to session
      _currentSession!.pages.add(page);

      debugPrint('✅ Page captured: ${page.pageNumber}/${_currentSession!.pages.length}');
      return page;
    } catch (e) {
      debugPrint('❌ Failed to capture page: $e');
      rethrow;
    }
  }

  /// Process a page (apply corrections, crop, etc.)
  Future<ScannedPage> processPage(
    ScannedPage page, {
    List<ui.Offset>? customEdges,
    bool applyPerspectiveCorrection = true,
    bool convertToGrayscale = false,
  }) async {
    try {
      String processedPath = page.processedPath;

      // Apply custom edges if provided
      if (customEdges != null && customEdges.length == 4) {
        debugPrint('✂️ Applying perspective correction...');
        processedPath = await _imageProcessor.applyPerspectiveCorrection(
          processedPath,
          customEdges,
        );
      }

      // Convert to grayscale if requested
      if (convertToGrayscale) {
        debugPrint('🎨 Converting to grayscale...');
        processedPath = await _imageProcessor.convertToGrayscale(processedPath);
      }

      // Update page
      final updatedPage = page.copyWith(
        processedPath: processedPath,
        detectedEdges: customEdges ?? page.detectedEdges,
      );

      // Update in session
      final index = _currentSession!.pages.indexWhere((p) => p.id == page.id);
      if (index != -1) {
        _currentSession!.pages[index] = updatedPage;
      }

      debugPrint('✅ Page processed');
      return updatedPage;
    } catch (e) {
      debugPrint('❌ Failed to process page: $e');
      rethrow;
    }
  }

  /// Delete a page from current session
  Future<void> deletePage(String pageId) async {
    if (_currentSession == null) {
      throw Exception('No active scan session');
    }

    try {
      final page = _currentSession!.pages.firstWhere((p) => p.id == pageId);

      // Delete files
      await File(page.originalPath).delete();
      await File(page.processedPath).delete();
      await File(page.thumbnailPath).delete();

      // Remove from session
      _currentSession!.pages.removeWhere((p) => p.id == pageId);

      // Renumber pages
      for (int i = 0; i < _currentSession!.pages.length; i++) {
        _currentSession!.pages[i] = _currentSession!.pages[i].copyWith(
          pageNumber: i + 1,
        );
      }

      debugPrint('✅ Page deleted: $pageId');
    } catch (e) {
      debugPrint('❌ Failed to delete page: $e');
      rethrow;
    }
  }

  /// Finalize scan session and prepare for PDF generation
  Future<ScanSession> finalizeScanSession() async {
    if (_currentSession == null) {
      throw Exception('No active scan session');
    }

    if (_currentSession!.pages.isEmpty) {
      throw Exception('Cannot finalize empty scan session');
    }

    try {
      _currentSession!.endTime = DateTime.now();
      final session = _currentSession!;
      _currentSession = null;

      debugPrint('✅ Scan session finalized: ${session.pages.length} pages');
      return session;
    } catch (e) {
      debugPrint('❌ Failed to finalize scan session: $e');
      rethrow;
    }
  }

  /// Cancel current scan session
  Future<void> cancelScanSession() async {
    if (_currentSession == null) return;

    try {
      // Delete all captured files
      for (final page in _currentSession!.pages) {
        await File(page.originalPath).delete().catchError((_) {});
        await File(page.processedPath).delete().catchError((_) {});
        await File(page.thumbnailPath).delete().catchError((_) {});
      }

      _currentSession = null;
      debugPrint('✅ Scan session cancelled');
    } catch (e) {
      debugPrint('❌ Failed to cancel scan session: $e');
      rethrow;
    }
  }

  /// Reorder pages in current session
  void reorderPages(int oldIndex, int newIndex) {
    if (_currentSession == null) return;

    final pages = _currentSession!.pages;
    if (oldIndex < 0 || oldIndex >= pages.length ||
        newIndex < 0 || newIndex >= pages.length) {
      return;
    }

    final page = pages.removeAt(oldIndex);
    pages.insert(newIndex, page);

    // Renumber pages
    for (int i = 0; i < pages.length; i++) {
      pages[i] = pages[i].copyWith(pageNumber: i + 1);
    }

    debugPrint('✅ Pages reordered');
  }
}

/// Represents a scanning session
class ScanSession {
  final String id;
  final DateTime startTime;
  DateTime? endTime;
  final List<ScannedPage> pages;

  ScanSession({
    required this.id,
    required this.startTime,
    this.endTime,
    required this.pages,
  });

  Duration get duration {
    final end = endTime ?? DateTime.now();
    return end.difference(startTime);
  }
}

/// Represents a scanned page
class ScannedPage {
  final String id;
  final String originalPath;
  final String processedPath;
  final String thumbnailPath;
  final List<ui.Offset>? detectedEdges;
  final DateTime captureTime;
  final int pageNumber;

  const ScannedPage({
    required this.id,
    required this.originalPath,
    required this.processedPath,
    required this.thumbnailPath,
    this.detectedEdges,
    required this.captureTime,
    required this.pageNumber,
  });

  ScannedPage copyWith({
    String? id,
    String? originalPath,
    String? processedPath,
    String? thumbnailPath,
    List<ui.Offset>? detectedEdges,
    DateTime? captureTime,
    int? pageNumber,
  }) {
    return ScannedPage(
      id: id ?? this.id,
      originalPath: originalPath ?? this.originalPath,
      processedPath: processedPath ?? this.processedPath,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      detectedEdges: detectedEdges ?? this.detectedEdges,
      captureTime: captureTime ?? this.captureTime,
      pageNumber: pageNumber ?? this.pageNumber,
    );
  }
}
