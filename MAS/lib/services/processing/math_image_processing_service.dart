import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import '../../models/math_solution.dart';
import '../../models/validation_result.dart';
import '../../models/training_session.dart';
import '../math_ai_service.dart';

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

  MathImageProcessingService(this._mathAIService);

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

      // Convert to base64
      final Uint8List imageBytes = await imageFile.readAsBytes();
      final String base64Image = base64Encode(imageBytes);

      // Call AI service to solve
      final MathSolution solution = await _mathAIService.solveProblem(
        base64Image,
        languageCode: languageCode,
      );

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
      final Uint8List imageBytes = await imageFile.readAsBytes();
      final String base64Image = base64Encode(imageBytes);

      final ValidationResult validation =
          await _mathAIService.checkUserSolution(
        base64Image,
        languageCode: languageCode,
      );

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
      final Uint8List imageBytes = await imageFile.readAsBytes();
      final String base64Image = base64Encode(imageBytes);

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
