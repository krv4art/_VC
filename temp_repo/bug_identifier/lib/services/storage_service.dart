import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class StorageService {
  Future<String> saveImage(File imageFile) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final fileName = 'scan_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedPath = p.join(directory.path, fileName);

      await imageFile.copy(savedPath);
      return savedPath;
    } catch (e) {
      debugPrint('Error saving image: $e');
      rethrow;
    }
  }

  Future<void> deleteImage(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      debugPrint('Error deleting image: $e');
    }
  }

  Future<List<String>> getAllImages() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final files = directory
          .listSync()
          .where(
            (item) => item.path.endsWith('.jpg') || item.path.endsWith('.png'),
          )
          .map((item) => item.path)
          .toList();
      return files;
    } catch (e) {
      debugPrint('Error getting images: $e');
      return [];
    }
  }

  /// Очищает все изображения из локального хранилища
  Future<void> clearAllImages() async {
    debugPrint('StorageService.clearAllImages() вызван');
    try {
      final images = await getAllImages();
      debugPrint('Найдено ${images.length} изображений для удаления');

      for (final imagePath in images) {
        debugPrint('Удаление изображения: $imagePath');
        await deleteImage(imagePath);
      }
      debugPrint('Удалено ${images.length} изображений');
    } catch (e) {
      debugPrint('Ошибка при очистке изображений: $e');
    }
  }
}
