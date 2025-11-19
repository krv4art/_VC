import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;

/// Service for saving photos to device gallery
class GallerySaverService {
  /// Request necessary permissions for saving to gallery
  Future<bool> requestPermissions() async {
    if (Platform.isAndroid) {
      // For Android 13+ (API 33+), we need different permissions
      final androidInfo = await _getAndroidVersion();
      if (androidInfo >= 33) {
        // Android 13+ doesn't need storage permission for gallery
        return true;
      } else {
        // Android 12 and below need storage permission
        final status = await Permission.storage.request();
        return status.isGranted;
      }
    } else if (Platform.isIOS) {
      final status = await Permission.photos.request();
      return status.isGranted;
    }
    return true;
  }

  /// Get Android SDK version
  Future<int> _getAndroidVersion() async {
    if (!Platform.isAndroid) return 0;
    try {
      // This is a simplified version - in production you'd use device_info_plus
      return 33; // Assume modern Android for now
    } catch (e) {
      return 29; // Default to Android 10
    }
  }

  /// Save image file to gallery
  Future<bool> saveToGallery({
    required String filePath,
    String? albumName,
    bool showNotification = true,
  }) async {
    try {
      // Check if file exists
      final file = File(filePath);
      if (!await file.exists()) {
        debugPrint('File does not exist: $filePath');
        return false;
      }

      // Request permissions
      final hasPermission = await requestPermissions();
      if (!hasPermission) {
        debugPrint('Gallery permission denied');
        return false;
      }

      // Save to gallery
      final result = await ImageGallerySaver.saveFile(
        filePath,
        name: _generateFileName(filePath),
        isReturnPathOfIOS: true,
      );

      if (result != null && result['isSuccess'] == true) {
        debugPrint('Photo saved to gallery successfully');
        return true;
      } else {
        debugPrint('Failed to save photo to gallery: $result');
        return false;
      }
    } catch (e) {
      debugPrint('Error saving to gallery: $e');
      return false;
    }
  }

  /// Save image bytes to gallery
  Future<bool> saveImageBytes({
    required List<int> bytes,
    required String fileName,
    int quality = 100,
    String? albumName,
  }) async {
    try {
      // Request permissions
      final hasPermission = await requestPermissions();
      if (!hasPermission) {
        debugPrint('Gallery permission denied');
        return false;
      }

      // Save to gallery
      final result = await ImageGallerySaver.saveImage(
        bytes,
        quality: quality,
        name: fileName,
      );

      if (result != null && result['isSuccess'] == true) {
        debugPrint('Image bytes saved to gallery successfully');
        return true;
      } else {
        debugPrint('Failed to save image bytes to gallery: $result');
        return false;
      }
    } catch (e) {
      debugPrint('Error saving image bytes to gallery: $e');
      return false;
    }
  }

  /// Save multiple photos to gallery
  Future<Map<String, bool>> saveMultipleToGallery({
    required List<String> filePaths,
    String? albumName,
  }) async {
    final results = <String, bool>{};

    for (final filePath in filePaths) {
      final success = await saveToGallery(
        filePath: filePath,
        albumName: albumName,
      );
      results[filePath] = success;
    }

    return results;
  }

  /// Generate unique file name for saved photo
  String _generateFileName(String filePath) {
    final extension = path.extension(filePath);
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'AI_Photo_Studio_$timestamp$extension';
  }

  /// Check if we have gallery permissions
  Future<bool> hasGalleryPermission() async {
    if (Platform.isAndroid) {
      final androidInfo = await _getAndroidVersion();
      if (androidInfo >= 33) {
        return true; // Android 13+ doesn't need storage permission
      }
      return await Permission.storage.isGranted;
    } else if (Platform.isIOS) {
      return await Permission.photos.isGranted;
    }
    return true;
  }

  /// Open app settings if permission is permanently denied
  Future<void> openAppSettings() async {
    await openAppSettings();
  }
}
