import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

/// Service for managing local file storage
class StorageService {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<Directory> get _imageDirectory async {
    final localPath = await _localPath;
    final imageDir = Directory(path.join(localPath, 'plant_images'));

    if (!await imageDir.exists()) {
      await imageDir.create(recursive: true);
    }

    return imageDir;
  }

  /// Save image to local storage
  Future<String> saveImage(File image, String filename) async {
    try {
      final dir = await _imageDirectory;
      final filePath = path.join(dir.path, filename);
      final savedImage = await image.copy(filePath);
      return savedImage.path;
    } catch (e) {
      print('Error saving image: $e');
      rethrow;
    }
  }

  /// Load image from local storage
  Future<File?> loadImage(String filename) async {
    try {
      final dir = await _imageDirectory;
      final filePath = path.join(dir.path, filename);
      final file = File(filePath);

      if (await file.exists()) {
        return file;
      }
      return null;
    } catch (e) {
      print('Error loading image: $e');
      return null;
    }
  }

  /// Delete image from local storage
  Future<bool> deleteImage(String filename) async {
    try {
      final dir = await _imageDirectory;
      final filePath = path.join(dir.path, filename);
      final file = File(filePath);

      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      print('Error deleting image: $e');
      return false;
    }
  }

  /// Get all saved images
  Future<List<File>> getAllImages() async {
    try {
      final dir = await _imageDirectory;
      final List<FileSystemEntity> entities = await dir.list().toList();

      return entities
          .where((entity) => entity is File)
          .map((entity) => entity as File)
          .toList();
    } catch (e) {
      print('Error getting all images: $e');
      return [];
    }
  }

  /// Clear all images
  Future<void> clearAllImages() async {
    try {
      final dir = await _imageDirectory;
      if (await dir.exists()) {
        await dir.delete(recursive: true);
        await dir.create(recursive: true);
      }
    } catch (e) {
      print('Error clearing images: $e');
      rethrow;
    }
  }

  /// Get cache size in bytes
  Future<int> getCacheSize() async {
    try {
      final images = await getAllImages();
      int totalSize = 0;

      for (final image in images) {
        final stat = await image.stat();
        totalSize += stat.size;
      }

      return totalSize;
    } catch (e) {
      print('Error getting cache size: $e');
      return 0;
    }
  }
}
