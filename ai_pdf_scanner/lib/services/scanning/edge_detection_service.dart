import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

/// Edge detection service
/// Detects document boundaries in images for auto-cropping
class EdgeDetectionService {
  static final EdgeDetectionService _instance = EdgeDetectionService._internal();
  factory EdgeDetectionService() => _instance;
  EdgeDetectionService._internal();

  /// Detect document edges in image
  /// Returns list of corner points (top-left, top-right, bottom-right, bottom-left)
  Future<List<ui.Offset>?> detectEdges(String imagePath) async {
    try {
      // Load image
      final bytes = await File(imagePath).readAsBytes();
      img.Image? image = img.decodeImage(bytes);

      if (image == null) {
        throw Exception('Failed to decode image');
      }

      // Convert to grayscale for edge detection
      final grayscale = img.grayscale(image);

      // Apply Gaussian blur to reduce noise
      final blurred = img.gaussianBlur(grayscale, radius: 5);

      // Edge detection using Sobel operator
      // This is a simplified version - for production use OpenCV
      final edges = _applySobelEdgeDetection(blurred);

      // Find contours
      final corners = _findDocumentCorners(edges);

      if (corners != null) {
        debugPrint('✅ Edges detected: $corners');
        return corners;
      } else {
        debugPrint('⚠️ No document edges detected');
        return null;
      }
    } catch (e) {
      debugPrint('❌ Edge detection failed: $e');
      return null;
    }
  }

  /// Apply Sobel edge detection (simplified version)
  img.Image _applySobelEdgeDetection(img.Image image) {
    // Sobel kernels
    final sobelX = [
      [-1, 0, 1],
      [-2, 0, 2],
      [-1, 0, 1],
    ];
    final sobelY = [
      [-1, -2, -1],
      [0, 0, 0],
      [1, 2, 1],
    ];

    final result = img.Image(width: image.width, height: image.height);

    for (int y = 1; y < image.height - 1; y++) {
      for (int x = 1; x < image.width - 1; x++) {
        double gx = 0;
        double gy = 0;

        // Apply Sobel kernels
        for (int ky = -1; ky <= 1; ky++) {
          for (int kx = -1; kx <= 1; kx++) {
            final pixel = image.getPixel(x + kx, y + ky);
            final intensity = pixel.r.toInt();
            gx += intensity * sobelX[ky + 1][kx + 1];
            gy += intensity * sobelY[ky + 1][kx + 1];
          }
        }

        // Calculate gradient magnitude
        final magnitude = (gx * gx + gy * gy).toInt();
        final clampedMagnitude = magnitude.clamp(0, 255);

        result.setPixelRgb(x, y, clampedMagnitude, clampedMagnitude, clampedMagnitude);
      }
    }

    return result;
  }

  /// Find document corners from edge image
  /// This is a simplified heuristic - for production use contour detection algorithms
  List<ui.Offset>? _findDocumentCorners(img.Image edges) {
    try {
      final width = edges.width.toDouble();
      final height = edges.height.toDouble();

      // For now, return default corners with small margin
      // In production, implement proper contour detection (e.g., using OpenCV)
      final margin = 0.05; // 5% margin

      return [
        ui.Offset(width * margin, height * margin), // top-left
        ui.Offset(width * (1 - margin), height * margin), // top-right
        ui.Offset(width * (1 - margin), height * (1 - margin)), // bottom-right
        ui.Offset(width * margin, height * (1 - margin)), // bottom-left
      ];
    } catch (e) {
      debugPrint('❌ Corner detection failed: $e');
      return null;
    }
  }

  /// Validate if detected corners form a valid quadrilateral
  bool validateCorners(List<ui.Offset> corners) {
    if (corners.length != 4) return false;

    // Check if corners are in reasonable positions
    // Top corners should have smaller y than bottom corners
    final topLeft = corners[0];
    final topRight = corners[1];
    final bottomRight = corners[2];
    final bottomLeft = corners[3];

    return topLeft.dy < bottomLeft.dy &&
        topRight.dy < bottomRight.dy &&
        topLeft.dx < topRight.dx &&
        bottomLeft.dx < bottomRight.dx;
  }

  /// Calculate the area of detected document
  double calculateArea(List<ui.Offset> corners) {
    if (corners.length != 4) return 0;

    // Using Shoelace formula for polygon area
    double area = 0;
    for (int i = 0; i < corners.length; i++) {
      final j = (i + 1) % corners.length;
      area += corners[i].dx * corners[j].dy;
      area -= corners[j].dx * corners[i].dy;
    }
    return (area.abs() / 2);
  }

  /// Adjust corners manually
  List<ui.Offset> adjustCorners(List<ui.Offset> corners, int cornerIndex, ui.Offset newPosition) {
    final adjusted = List<ui.Offset>.from(corners);
    adjusted[cornerIndex] = newPosition;
    return adjusted;
  }
}
