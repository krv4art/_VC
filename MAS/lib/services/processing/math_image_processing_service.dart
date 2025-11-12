import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:image/image.dart' as img;

import '../../models/math_solution.dart';
import '../../models/validation_result.dart';
import '../../models/training_session.dart';
import '../math_ai_service.dart';
import '../database/local_database_service.dart';

/// Result of math image processing with status
class MathProcessingResult {
  final bool success;
  final MathSolution? solution;
  final ValidationResult? validation;
  final List<SimilarProblem>? similarProblems;
  final String? imagePath;
  final String? errorMessage;

  const MathProcessingResult({
    required this.success,
    this.solution,
    this.validation,
    this.similarProblems,
    this.imagePath,
    this.errorMessage,
  });

  factory MathProcessingResult.success({
    MathSolution? solution,
    ValidationResult? validation,
    List<SimilarProblem>? similarProblems,
    String? imagePath,
  }) {
    return MathProcessingResult(
      success: true,
      solution: solution,
      validation: validation,
      similarProblems: similarProblems,
      imagePath: imagePath,
    );
  }

  factory MathProcessingResult.error(String message) {
    return MathProcessingResult(
      success: false,
      errorMessage: message,
    );
  }
}

/// Processing mode for different math operations
enum MathProcessingMode {
  solve, // Solve the problem
  check, // Check user's solution
  training, // Generate similar problems
}

/// Service for processing mathematical images
class MathImageProcessingService {
  final MathAIService _mathAIService;
  final LocalDatabaseService _dbService;

  MathImageProcessingService(this._mathAIService)
      : _dbService = LocalDatabaseService.instance;

  /// Process image in SOLVE mode - analyze and solve the problem
  Future<MathProcessingResult> solveProblem(
    XFile imageFile, {
    String languageCode = 'ru',
    VoidCallback? onSlowNetwork,
  }) async {
    // Start slow network timer (7 seconds)
    Timer? slowNetworkTimer;
    if (onSlowNetwork != null) {
      slowNetworkTimer = Timer(const Duration(seconds: 7), onSlowNetwork);
    }

    try {
      // Save image locally
      final String savedImagePath = await _saveImage(imageFile);

      // Read and compress image
      final Uint8List originalBytes = await imageFile.readAsBytes();
      final Uint8List compressedBytes = await _compressImage(originalBytes);

      // Check cache first
      final MathSolution? cachedSolution = await _dbService.getCachedSolution(compressedBytes);
      if (cachedSolution != null) {
        slowNetworkTimer?.cancel();
        debugPrint('💰 Using cached solution - API call saved!');
        return MathProcessingResult.success(
          solution: cachedSolution,
          imagePath: savedImagePath,
        );
      }

      // Convert to base64
      final String base64Image = base64Encode(compressedBytes);

      // Call AI service to solve
      final MathSolution solution = await _mathAIService.solveProblem(
        base64Image,
        languageCode: languageCode,
      );

      // Cache the result
      await _dbService.cacheSolution(compressedBytes, solution);

      slowNetworkTimer?.cancel();

      return MathProcessingResult.success(
        solution: solution,
        imagePath: savedImagePath,
      );
    } catch (e) {
      slowNetworkTimer?.cancel();
      return MathProcessingResult.error(
        'Не удалось решить задачу: ${e.toString()}',
      );
    }
  }

  /// Process image in CHECK mode - validate user's solution
  Future<MathProcessingResult> checkSolution(
    XFile imageFile, {
    String languageCode = 'ru',
    VoidCallback? onSlowNetwork,
  }) async {
    Timer? slowNetworkTimer;
    if (onSlowNetwork != null) {
      slowNetworkTimer = Timer(const Duration(seconds: 7), onSlowNetwork);
    }

    try {
      final String savedImagePath = await _saveImage(imageFile);

      // Read and compress image
      final Uint8List originalBytes = await imageFile.readAsBytes();
      final Uint8List compressedBytes = await _compressImage(originalBytes);

      // Check cache first
      final ValidationResult? cachedValidation = await _dbService.getCachedValidation(compressedBytes);
      if (cachedValidation != null) {
        slowNetworkTimer?.cancel();
        debugPrint('💰 Using cached validation - API call saved!');
        return MathProcessingResult.success(
          validation: cachedValidation,
          imagePath: savedImagePath,
        );
      }

      // Convert to base64
      final String base64Image = base64Encode(compressedBytes);

      final ValidationResult validation =
          await _mathAIService.checkUserSolution(
        base64Image,
        languageCode: languageCode,
      );

      // Cache the result
      await _dbService.cacheValidation(compressedBytes, validation);

      slowNetworkTimer?.cancel();

      return MathProcessingResult.success(
        validation: validation,
        imagePath: savedImagePath,
      );
    } catch (e) {
      slowNetworkTimer?.cancel();
      return MathProcessingResult.error(
        'Не удалось проверить решение: ${e.toString()}',
      );
    }
  }

  /// Process image in TRAINING mode - generate similar problems
  Future<MathProcessingResult> generateTrainingProblems(
    XFile imageFile, {
    int count = 5,
    String languageCode = 'ru',
    VoidCallback? onSlowNetwork,
  }) async {
    Timer? slowNetworkTimer;
    if (onSlowNetwork != null) {
      slowNetworkTimer = Timer(const Duration(seconds: 7), onSlowNetwork);
    }

    try {
      final String savedImagePath = await _saveImage(imageFile);

      // Read and compress image
      final Uint8List originalBytes = await imageFile.readAsBytes();
      final Uint8List compressedBytes = await _compressImage(originalBytes);

      // Convert to base64
      final String base64Image = base64Encode(compressedBytes);

      final List<SimilarProblem> similarProblems =
          await _mathAIService.generateSimilarProblems(
        base64Image,
        count: count,
        languageCode: languageCode,
      );

      slowNetworkTimer?.cancel();

      return MathProcessingResult.success(
        similarProblems: similarProblems,
        imagePath: savedImagePath,
      );
    } catch (e) {
      slowNetworkTimer?.cancel();
      return MathProcessingResult.error(
        'Не удалось создать тренировочные задачи: ${e.toString()}',
      );
    }
  }

  /// Universal processing method that routes to correct mode
  Future<MathProcessingResult> processImage(
    XFile imageFile, {
    required MathProcessingMode mode,
    String languageCode = 'ru',
    int trainingCount = 5,
    VoidCallback? onSlowNetwork,
  }) async {
    switch (mode) {
      case MathProcessingMode.solve:
        return solveProblem(
          imageFile,
          languageCode: languageCode,
          onSlowNetwork: onSlowNetwork,
        );

      case MathProcessingMode.check:
        return checkSolution(
          imageFile,
          languageCode: languageCode,
          onSlowNetwork: onSlowNetwork,
        );

      case MathProcessingMode.training:
        return generateTrainingProblems(
          imageFile,
          count: trainingCount,
          languageCode: languageCode,
          onSlowNetwork: onSlowNetwork,
        );
    }
  }

  /// Compress image before sending to API
  ///
  /// Reduces image size by:
  /// - Resizing to max 1920px on longest side
  /// - Converting to JPEG format
  /// - Applying 85% quality compression
  ///
  /// Expected savings: 60-80% file size reduction
  Future<Uint8List> _compressImage(Uint8List originalBytes) async {
    try {
      // Decode the image
      img.Image? image = img.decodeImage(originalBytes);

      if (image == null) {
        debugPrint('⚠️ Failed to decode image, using original');
        return originalBytes;
      }

      final originalSize = originalBytes.length / (1024 * 1024); // MB
      debugPrint('📸 Original image size: ${originalSize.toStringAsFixed(2)} MB');
      debugPrint('📐 Original dimensions: ${image.width}x${image.height}');

      // Resize if image is too large (keep aspect ratio)
      const int maxDimension = 1920;
      if (image.width > maxDimension || image.height > maxDimension) {
        if (image.width > image.height) {
          image = img.copyResize(image, width: maxDimension);
        } else {
          image = img.copyResize(image, height: maxDimension);
        }
        debugPrint('📏 Resized to: ${image.width}x${image.height}');
      }

      // Convert to JPEG with 85% quality
      final compressedBytes = img.encodeJpg(image, quality: 85);

      final compressedSize = compressedBytes.length / (1024 * 1024); // MB
      final savingsPercent = ((originalSize - compressedSize) / originalSize * 100).round();

      debugPrint('✅ Compressed size: ${compressedSize.toStringAsFixed(2)} MB');
      debugPrint('💰 Savings: $savingsPercent% (-${(originalSize - compressedSize).toStringAsFixed(2)} MB)');

      return Uint8List.fromList(compressedBytes);
    } catch (e) {
      debugPrint('❌ Compression error: $e. Using original image.');
      return originalBytes;
    }
  }

  /// Save image to app documents directory
  Future<String> _saveImage(XFile imageFile) async {
    final Directory appDir = await getApplicationDocumentsDirectory();
    final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final String extension = p.extension(imageFile.path);
    final String fileName = 'math_$timestamp$extension';
    final String savedPath = p.join(appDir.path, fileName);

    await imageFile.saveTo(savedPath);
    return savedPath;
  }

  /// Delete saved image file
  Future<void> deleteImage(String imagePath) async {
    try {
      final File imageFile = File(imagePath);
      if (await imageFile.exists()) {
        await imageFile.delete();
      }
    } catch (e) {
      debugPrint('Error deleting image: $e');
    }
  }

  /// Get file size in MB
  Future<double> getImageSize(String imagePath) async {
    try {
      final File imageFile = File(imagePath);
      if (await imageFile.exists()) {
        final int bytes = await imageFile.length();
        return bytes / (1024 * 1024); // Convert to MB
      }
    } catch (e) {
      debugPrint('Error getting image size: $e');
    }
    return 0;
  }
}
