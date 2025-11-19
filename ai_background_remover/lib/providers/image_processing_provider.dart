import 'dart:io';
import 'package:flutter/material.dart';
import '../models/processed_image.dart';
import '../models/processing_options.dart';
import '../services/image_processing_service.dart';
import '../services/database_service.dart';

class ImageProcessingProvider extends ChangeNotifier {
  final ImageProcessingService _imageProcessingService = ImageProcessingService();
  final DatabaseService _databaseService = DatabaseService();

  List<ProcessedImage> _history = [];
  bool _isProcessing = false;
  double _progress = 0.0;
  String? _error;
  File? _selectedImage;
  File? _processedImage;

  List<ProcessedImage> get history => _history;
  bool get isProcessing => _isProcessing;
  double get progress => _progress;
  String? get error => _error;
  File? get selectedImage => _selectedImage;
  File? get processedImage => _processedImage;

  Future<void> loadHistory() async {
    _history = await _databaseService.getProcessedImages();
    notifyListeners();
  }

  void setSelectedImage(File? image) {
    _selectedImage = image;
    _processedImage = null;
    _error = null;
    notifyListeners();
  }

  Future<void> processImage(ProcessingOptions options) async {
    if (_selectedImage == null) return;

    _isProcessing = true;
    _progress = 0.0;
    _error = null;
    notifyListeners();

    try {
      // Simulate progress updates
      for (int i = 0; i <= 100; i += 10) {
        await Future.delayed(const Duration(milliseconds: 200));
        _progress = i / 100;
        notifyListeners();
      }

      final result = await _imageProcessingService.removeBackground(
        _selectedImage!,
        options,
      );

      _processedImage = result;

      // Save to database
      final processedImage = ProcessedImage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        originalPath: _selectedImage!.path,
        processedPath: result.path,
        processingMode: options.mode,
        createdAt: DateTime.now(),
        metadata: options.toMap(),
      );

      await _databaseService.saveProcessedImage(processedImage);
      await loadHistory();

      _isProcessing = false;
      _progress = 1.0;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isProcessing = false;
      notifyListeners();
    }
  }

  Future<void> deleteFromHistory(String id) async {
    await _databaseService.deleteProcessedImage(id);
    await loadHistory();
  }

  Future<void> deleteAllHistory() async {
    await _databaseService.deleteAllProcessedImages();
    await loadHistory();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void reset() {
    _selectedImage = null;
    _processedImage = null;
    _error = null;
    _progress = 0.0;
    _isProcessing = false;
    notifyListeners();
  }
}
