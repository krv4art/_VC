import 'dart:io';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as path;

/// Service for cloud backup and sync using Supabase Storage
class CloudBackupService {
  final SupabaseClient _supabase = Supabase.instance.client;
  static const String _bucketName = 'user-photos';
  static const String _originalsBucket = 'original-photos';
  static const String _generatedBucket = 'generated-photos';

  /// Initialize storage buckets (call this once on first use)
  Future<bool> initializeBuckets() async {
    try {
      // Check if buckets exist, create if they don't
      final buckets = await _supabase.storage.listBuckets();
      final bucketNames = buckets.map((b) => b.name).toList();

      if (!bucketNames.contains(_bucketName)) {
        await _supabase.storage.createBucket(
          _bucketName,
          const BucketOptions(public: false),
        );
      }

      if (!bucketNames.contains(_originalsBucket)) {
        await _supabase.storage.createBucket(
          _originalsBucket,
          const BucketOptions(public: false),
        );
      }

      if (!bucketNames.contains(_generatedBucket)) {
        await _supabase.storage.createBucket(
          _generatedBucket,
          const BucketOptions(public: false),
        );
      }

      return true;
    } catch (e) {
      debugPrint('Error initializing buckets: $e');
      return false;
    }
  }

  /// Upload photo to cloud storage
  Future<String?> uploadPhoto({
    required String localPath,
    required String userId,
    bool isOriginal = false,
    Map<String, String>? metadata,
  }) async {
    try {
      final file = File(localPath);
      if (!await file.exists()) {
        debugPrint('File does not exist: $localPath');
        return null;
      }

      final fileName = path.basename(localPath);
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final bucket = isOriginal ? _originalsBucket : _generatedBucket;
      final remotePath = '$userId/$timestamp-$fileName';

      // Upload file
      final uploadPath = await _supabase.storage
          .from(bucket)
          .upload(remotePath, file);

      // Get public URL
      final publicUrl = _supabase.storage.from(bucket).getPublicUrl(uploadPath);

      debugPrint('Photo uploaded successfully: $publicUrl');
      return publicUrl;
    } catch (e) {
      debugPrint('Error uploading photo: $e');
      return null;
    }
  }

  /// Upload multiple photos
  Future<List<String>> uploadMultiplePhotos({
    required List<String> localPaths,
    required String userId,
    bool isOriginal = false,
    void Function(int current, int total)? onProgress,
  }) async {
    final uploadedUrls = <String>[];

    for (int i = 0; i < localPaths.length; i++) {
      onProgress?.call(i + 1, localPaths.length);

      final url = await uploadPhoto(
        localPath: localPaths[i],
        userId: userId,
        isOriginal: isOriginal,
      );

      if (url != null) {
        uploadedUrls.add(url);
      }
    }

    return uploadedUrls;
  }

  /// Download photo from cloud storage
  Future<String?> downloadPhoto({
    required String remotePath,
    required String localPath,
    String bucket = _generatedBucket,
  }) async {
    try {
      final bytes = await _supabase.storage.from(bucket).download(remotePath);

      final file = File(localPath);
      await file.writeAsBytes(bytes);

      debugPrint('Photo downloaded successfully: $localPath');
      return localPath;
    } catch (e) {
      debugPrint('Error downloading photo: $e');
      return null;
    }
  }

  /// List all photos for a user
  Future<List<FileObject>> listUserPhotos({
    required String userId,
    bool isOriginal = false,
  }) async {
    try {
      final bucket = isOriginal ? _originalsBucket : _generatedBucket;
      final files = await _supabase.storage.from(bucket).list(path: userId);

      return files;
    } catch (e) {
      debugPrint('Error listing user photos: $e');
      return [];
    }
  }

  /// Delete photo from cloud storage
  Future<bool> deletePhoto({
    required String remotePath,
    String bucket = _generatedBucket,
  }) async {
    try {
      await _supabase.storage.from(bucket).remove([remotePath]);
      debugPrint('Photo deleted successfully: $remotePath');
      return true;
    } catch (e) {
      debugPrint('Error deleting photo: $e');
      return false;
    }
  }

  /// Delete multiple photos
  Future<bool> deleteMultiplePhotos({
    required List<String> remotePaths,
    String bucket = _generatedBucket,
  }) async {
    try {
      await _supabase.storage.from(bucket).remove(remotePaths);
      debugPrint('Photos deleted successfully: ${remotePaths.length} files');
      return true;
    } catch (e) {
      debugPrint('Error deleting multiple photos: $e');
      return false;
    }
  }

  /// Get download URL for a photo
  Future<String?> getPhotoUrl({
    required String remotePath,
    String bucket = _generatedBucket,
    int expiresIn = 3600, // 1 hour
  }) async {
    try {
      final url = await _supabase.storage
          .from(bucket)
          .createSignedUrl(remotePath, expiresIn);

      return url;
    } catch (e) {
      debugPrint('Error getting photo URL: $e');
      return null;
    }
  }

  /// Sync local photos to cloud
  Future<Map<String, dynamic>> syncToCloud({
    required List<String> localPaths,
    required String userId,
    void Function(int current, int total)? onProgress,
  }) async {
    int uploaded = 0;
    int failed = 0;
    final uploadedUrls = <String>[];

    for (int i = 0; i < localPaths.length; i++) {
      onProgress?.call(i + 1, localPaths.length);

      final url = await uploadPhoto(
        localPath: localPaths[i],
        userId: userId,
      );

      if (url != null) {
        uploaded++;
        uploadedUrls.add(url);
      } else {
        failed++;
      }
    }

    return {
      'uploaded': uploaded,
      'failed': failed,
      'urls': uploadedUrls,
    };
  }

  /// Get storage usage for user
  Future<int> getStorageUsage({required String userId}) async {
    try {
      final generatedFiles = await listUserPhotos(userId: userId, isOriginal: false);
      final originalFiles = await listUserPhotos(userId: userId, isOriginal: true);

      int totalSize = 0;
      for (final file in [...generatedFiles, ...originalFiles]) {
        totalSize += file.metadata?['size'] as int? ?? 0;
      }

      return totalSize;
    } catch (e) {
      debugPrint('Error getting storage usage: $e');
      return 0;
    }
  }

  /// Clear all user photos from cloud
  Future<bool> clearUserStorage({required String userId}) async {
    try {
      // Delete from generated bucket
      final generatedFiles = await listUserPhotos(userId: userId, isOriginal: false);
      if (generatedFiles.isNotEmpty) {
        final generatedPaths = generatedFiles.map((f) => '$userId/${f.name}').toList();
        await deleteMultiplePhotos(remotePaths: generatedPaths, bucket: _generatedBucket);
      }

      // Delete from originals bucket
      final originalFiles = await listUserPhotos(userId: userId, isOriginal: true);
      if (originalFiles.isNotEmpty) {
        final originalPaths = originalFiles.map((f) => '$userId/${f.name}').toList();
        await deleteMultiplePhotos(remotePaths: originalPaths, bucket: _originalsBucket);
      }

      debugPrint('User storage cleared successfully');
      return true;
    } catch (e) {
      debugPrint('Error clearing user storage: $e');
      return false;
    }
  }

  /// Check if photo exists in cloud
  Future<bool> photoExists({
    required String remotePath,
    String bucket = _generatedBucket,
  }) async {
    try {
      final files = await _supabase.storage.from(bucket).list();
      return files.any((f) => f.name == remotePath);
    } catch (e) {
      debugPrint('Error checking photo existence: $e');
      return false;
    }
  }

  /// Format storage size for display
  String formatStorageSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(2)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }
}
