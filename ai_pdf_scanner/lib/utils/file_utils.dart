import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import '../exceptions/app_exception.dart';

/// Utility class for file operations
class FileUtils {
  FileUtils._();

  /// Get app documents directory
  static Future<Directory> getDocumentsDirectory() async {
    try {
      return await getApplicationDocumentsDirectory();
    } catch (e) {
      throw StorageException(
        'Failed to get documents directory',
        originalError: e,
      );
    }
  }

  /// Get app cache directory
  static Future<Directory> getCacheDirectory() async {
    try {
      return await getTemporaryDirectory();
    } catch (e) {
      throw StorageException(
        'Failed to get cache directory',
        originalError: e,
      );
    }
  }

  /// Create a unique filename with timestamp
  static String generateUniqueFilename({
    required String prefix,
    required String extension,
  }) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return '${prefix}_$timestamp.$extension';
  }

  /// Get file size in bytes
  static Future<int> getFileSize(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        throw StorageException('File not found: $filePath');
      }
      return await file.length();
    } catch (e) {
      if (e is StorageException) rethrow;
      throw StorageException(
        'Failed to get file size',
        originalError: e,
      );
    }
  }

  /// Get file size in MB
  static Future<double> getFileSizeMB(String filePath) async {
    final bytes = await getFileSize(filePath);
    return bytes / (1024 * 1024);
  }

  /// Format file size to human-readable string
  static String formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }

  /// Check if file exists
  static Future<bool> fileExists(String filePath) async {
    try {
      return await File(filePath).exists();
    } catch (e) {
      return false;
    }
  }

  /// Delete file
  static Future<void> deleteFile(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      throw StorageException(
        'Failed to delete file',
        originalError: e,
      );
    }
  }

  /// Copy file
  static Future<String> copyFile(String sourcePath, String destinationPath) async {
    try {
      final sourceFile = File(sourcePath);
      if (!await sourceFile.exists()) {
        throw StorageException('Source file not found: $sourcePath');
      }

      final destFile = await sourceFile.copy(destinationPath);
      return destFile.path;
    } catch (e) {
      if (e is StorageException) rethrow;
      throw StorageException(
        'Failed to copy file',
        originalError: e,
      );
    }
  }

  /// Move file
  static Future<String> moveFile(String sourcePath, String destinationPath) async {
    try {
      final sourceFile = File(sourcePath);
      if (!await sourceFile.exists()) {
        throw StorageException('Source file not found: $sourcePath');
      }

      final destFile = await sourceFile.rename(destinationPath);
      return destFile.path;
    } catch (e) {
      if (e is StorageException) rethrow;
      throw StorageException(
        'Failed to move file',
        originalError: e,
      );
    }
  }

  /// Read file as bytes
  static Future<Uint8List> readFileAsBytes(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        throw StorageException('File not found: $filePath');
      }
      return await file.readAsBytes();
    } catch (e) {
      if (e is StorageException) rethrow;
      throw StorageException(
        'Failed to read file',
        originalError: e,
      );
    }
  }

  /// Write bytes to file
  static Future<String> writeBytesToFile(
    Uint8List bytes,
    String filePath,
  ) async {
    try {
      final file = File(filePath);
      await file.create(recursive: true);
      await file.writeAsBytes(bytes);
      return file.path;
    } catch (e) {
      throw StorageException(
        'Failed to write file',
        originalError: e,
      );
    }
  }

  /// Get file extension
  static String getFileExtension(String filePath) {
    return path.extension(filePath).toLowerCase().replaceFirst('.', '');
  }

  /// Get filename without extension
  static String getFilenameWithoutExtension(String filePath) {
    return path.basenameWithoutExtension(filePath);
  }

  /// Get filename with extension
  static String getFilename(String filePath) {
    return path.basename(filePath);
  }

  /// Get directory path
  static String getDirectoryPath(String filePath) {
    return path.dirname(filePath);
  }

  /// Create directory if not exists
  static Future<Directory> createDirectory(String dirPath) async {
    try {
      final dir = Directory(dirPath);
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }
      return dir;
    } catch (e) {
      throw StorageException(
        'Failed to create directory',
        originalError: e,
      );
    }
  }

  /// List files in directory
  static Future<List<File>> listFilesInDirectory(
    String dirPath, {
    List<String>? extensions,
  }) async {
    try {
      final dir = Directory(dirPath);
      if (!await dir.exists()) {
        return [];
      }

      final entities = await dir.list().toList();
      final files = entities.whereType<File>().toList();

      if (extensions != null && extensions.isNotEmpty) {
        return files.where((file) {
          final ext = getFileExtension(file.path);
          return extensions.contains(ext);
        }).toList();
      }

      return files;
    } catch (e) {
      throw StorageException(
        'Failed to list files',
        originalError: e,
      );
    }
  }

  /// Clean cache directory
  static Future<void> cleanCache() async {
    try {
      final cacheDir = await getCacheDirectory();
      if (await cacheDir.exists()) {
        await cacheDir.delete(recursive: true);
        await cacheDir.create();
      }
    } catch (e) {
      throw StorageException(
        'Failed to clean cache',
        originalError: e,
      );
    }
  }

  /// Get total size of directory
  static Future<int> getDirectorySize(String dirPath) async {
    try {
      final dir = Directory(dirPath);
      if (!await dir.exists()) {
        return 0;
      }

      int totalSize = 0;
      await for (final entity in dir.list(recursive: true)) {
        if (entity is File) {
          totalSize += await entity.length();
        }
      }
      return totalSize;
    } catch (e) {
      throw StorageException(
        'Failed to calculate directory size',
        originalError: e,
      );
    }
  }

  /// Validate filename (remove invalid characters)
  static String sanitizeFilename(String filename) {
    // Remove invalid characters for filesystem
    return filename
        .replaceAll(RegExp(r'[<>:"/\\|?*]'), '_')
        .replaceAll(RegExp(r'\s+'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .trim();
  }

  /// Check if file is a PDF
  static bool isPDF(String filePath) {
    return getFileExtension(filePath) == 'pdf';
  }

  /// Check if file is an image
  static bool isImage(String filePath) {
    final ext = getFileExtension(filePath);
    return ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'].contains(ext);
  }

  /// Check if file is a supported document
  static bool isDocument(String filePath) {
    final ext = getFileExtension(filePath);
    return ['pdf', 'doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx', 'txt'].contains(ext);
  }
}
