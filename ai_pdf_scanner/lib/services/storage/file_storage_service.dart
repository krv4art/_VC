import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:share_plus/share_plus.dart';
import '../../config/app_config.dart';

/// File storage service
/// Manages file system operations for documents
class FileStorageService {
  static final FileStorageService _instance = FileStorageService._internal();
  factory FileStorageService() => _instance;
  FileStorageService._internal();

  /// Get documents directory
  Future<Directory> getDocumentsDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final docsDir = Directory(path.join(appDir.path, AppConfig.localPdfPath));

    if (!await docsDir.exists()) {
      await docsDir.create(recursive: true);
    }

    return docsDir;
  }

  /// Get thumbnails directory
  Future<Directory> getThumbnailsDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final thumbsDir = Directory(path.join(appDir.path, AppConfig.localThumbnailPath));

    if (!await thumbsDir.exists()) {
      await thumbsDir.create(recursive: true);
    }

    return thumbsDir;
  }

  /// Save file to documents directory
  Future<String> saveFile(
    File sourceFile, {
    String? customFileName,
  }) async {
    try {
      final docsDir = await getDocumentsDirectory();
      final fileName = customFileName ?? path.basename(sourceFile.path);
      final targetPath = path.join(docsDir.path, fileName);

      // Copy file to documents directory
      final savedFile = await sourceFile.copy(targetPath);

      debugPrint('✅ File saved: $targetPath');
      return savedFile.path;
    } catch (e) {
      debugPrint('❌ Failed to save file: $e');
      rethrow;
    }
  }

  /// Move file to documents directory
  Future<String> moveFile(
    String sourcePath, {
    String? customFileName,
  }) async {
    try {
      final sourceFile = File(sourcePath);
      final docsDir = await getDocumentsDirectory();
      final fileName = customFileName ?? path.basename(sourcePath);
      final targetPath = path.join(docsDir.path, fileName);

      // Move file
      final movedFile = await sourceFile.rename(targetPath);

      debugPrint('✅ File moved: $targetPath');
      return movedFile.path;
    } catch (e) {
      debugPrint('❌ Failed to move file: $e');
      rethrow;
    }
  }

  /// Delete file
  Future<void> deleteFile(String filePath) async {
    try {
      final file = File(filePath);

      if (await file.exists()) {
        await file.delete();
        debugPrint('✅ File deleted: $filePath');
      } else {
        debugPrint('⚠️ File not found: $filePath');
      }
    } catch (e) {
      debugPrint('❌ Failed to delete file: $e');
      rethrow;
    }
  }

  /// Delete multiple files
  Future<void> deleteFiles(List<String> filePaths) async {
    for (final filePath in filePaths) {
      await deleteFile(filePath);
    }
  }

  /// Get file size
  Future<int> getFileSize(String filePath) async {
    try {
      final file = File(filePath);
      return await file.length();
    } catch (e) {
      debugPrint('❌ Failed to get file size: $e');
      return 0;
    }
  }

  /// Check if file exists
  Future<bool> fileExists(String filePath) async {
    try {
      final file = File(filePath);
      return await file.exists();
    } catch (e) {
      debugPrint('❌ Failed to check file existence: $e');
      return false;
    }
  }

  /// Copy file
  Future<String> copyFile(
    String sourcePath, {
    String? customFileName,
  }) async {
    try {
      final sourceFile = File(sourcePath);
      final docsDir = await getDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = customFileName ??
          '${path.basenameWithoutExtension(sourcePath)}_copy_$timestamp${path.extension(sourcePath)}';
      final targetPath = path.join(docsDir.path, fileName);

      final copiedFile = await sourceFile.copy(targetPath);

      debugPrint('✅ File copied: $targetPath');
      return copiedFile.path;
    } catch (e) {
      debugPrint('❌ Failed to copy file: $e');
      rethrow;
    }
  }

  /// Share file
  Future<void> shareFile(
    String filePath, {
    String? subject,
    String? text,
  }) async {
    try {
      final file = File(filePath);

      if (!await file.exists()) {
        throw Exception('File not found: $filePath');
      }

      await Share.shareXFiles(
        [XFile(filePath)],
        subject: subject,
        text: text,
      );

      debugPrint('✅ File shared: $filePath');
    } catch (e) {
      debugPrint('❌ Failed to share file: $e');
      rethrow;
    }
  }

  /// Share multiple files
  Future<void> shareFiles(
    List<String> filePaths, {
    String? subject,
    String? text,
  }) async {
    try {
      final xFiles = filePaths.map((path) => XFile(path)).toList();

      await Share.shareXFiles(
        xFiles,
        subject: subject,
        text: text,
      );

      debugPrint('✅ ${filePaths.length} files shared');
    } catch (e) {
      debugPrint('❌ Failed to share files: $e');
      rethrow;
    }
  }

  /// Get all files in documents directory
  Future<List<FileSystemEntity>> getAllFiles() async {
    try {
      final docsDir = await getDocumentsDirectory();
      return docsDir.listSync();
    } catch (e) {
      debugPrint('❌ Failed to list files: $e');
      return [];
    }
  }

  /// Get total storage used
  Future<int> getTotalStorageUsed() async {
    try {
      int totalSize = 0;
      final files = await getAllFiles();

      for (final file in files) {
        if (file is File) {
          totalSize += await file.length();
        }
      }

      return totalSize;
    } catch (e) {
      debugPrint('❌ Failed to calculate storage: $e');
      return 0;
    }
  }

  /// Clean up old files
  Future<int> cleanupOldFiles({
    int olderThanDays = 30,
  }) async {
    try {
      int deletedCount = 0;
      final files = await getAllFiles();
      final cutoffDate = DateTime.now().subtract(Duration(days: olderThanDays));

      for (final file in files) {
        if (file is File) {
          final stat = await file.stat();
          if (stat.modified.isBefore(cutoffDate)) {
            await file.delete();
            deletedCount++;
          }
        }
      }

      debugPrint('✅ Cleaned up $deletedCount old files');
      return deletedCount;
    } catch (e) {
      debugPrint('❌ Failed to cleanup files: $e');
      return 0;
    }
  }

  /// Format file size to human-readable string
  String formatFileSize(int bytes) {
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

  /// Get file extension
  String getFileExtension(String filePath) {
    return path.extension(filePath).toLowerCase();
  }

  /// Is PDF file
  bool isPdfFile(String filePath) {
    return getFileExtension(filePath) == '.pdf';
  }

  /// Is image file
  bool isImageFile(String filePath) {
    final ext = getFileExtension(filePath);
    return ['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp'].contains(ext);
  }
}
