import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:permission_handler/permission_handler.dart';

/// Service for handling photo upload and management
class ImageService {
  final ImagePicker _picker = ImagePicker();

  /// Pick image from gallery
  Future<String?> pickImageFromGallery() async {
    try {
      // Request permission
      if (!kIsWeb && Platform.isAndroid) {
        final status = await Permission.photos.request();
        if (!status.isGranted) {
          debugPrint('Photo permission denied');
          return null;
        }
      }

      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image == null) return null;

      // Compress and save image
      return await _processAndSaveImage(image);
    } catch (e) {
      debugPrint('Error picking image: $e');
      return null;
    }
  }

  /// Take photo with camera
  Future<String?> takePhoto() async {
    try {
      // Request permission
      if (!kIsWeb && Platform.isAndroid) {
        final status = await Permission.camera.request();
        if (!status.isGranted) {
          debugPrint('Camera permission denied');
          return null;
        }
      }

      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image == null) return null;

      // Compress and save image
      return await _processAndSaveImage(image);
    } catch (e) {
      debugPrint('Error taking photo: $e');
      return null;
    }
  }

  /// Process and save image
  Future<String?> _processAndSaveImage(XFile image) async {
    try {
      // Get app directory
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final targetPath = '${directory.path}/profile_photo_$timestamp.jpg';

      // Compress image
      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        image.path,
        targetPath,
        quality: 85,
        minWidth: 400,
        minHeight: 400,
      );

      if (compressedFile == null) {
        debugPrint('Failed to compress image');
        return null;
      }

      return compressedFile.path;
    } catch (e) {
      debugPrint('Error processing image: $e');
      return null;
    }
  }

  /// Delete image file
  Future<bool> deleteImage(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error deleting image: $e');
      return false;
    }
  }

  /// Show image source selection dialog
  Future<String?> showImageSourceDialog(BuildContext context) async {
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Photo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () async {
                Navigator.pop(context);
                final path = await pickImageFromGallery();
                if (context.mounted && path != null) {
                  Navigator.pop(context, path);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () async {
                Navigator.pop(context);
                final path = await takePhoto();
                if (context.mounted && path != null) {
                  Navigator.pop(context, path);
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
