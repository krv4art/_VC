import 'dart:io';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

/// Service for picking images from camera or gallery
class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  /// Pick image from camera
  Future<File?> pickFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      print('Error picking image from camera: $e');
      return null;
    }
  }

  /// Pick image from gallery
  Future<File?> pickFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      print('Error picking image from gallery: $e');
      return null;
    }
  }

  /// Convert image to base64 string
  Future<String> imageToBase64(File image) async {
    try {
      final bytes = await image.readAsBytes();
      return base64Encode(bytes);
    } catch (e) {
      print('Error converting image to base64: $e');
      rethrow;
    }
  }

  /// Get image bytes for web platform
  Future<Uint8List?> getImageBytes(XFile image) async {
    try {
      return await image.readAsBytes();
    } catch (e) {
      print('Error reading image bytes: $e');
      return null;
    }
  }

  /// Pick and convert image to base64 from camera
  Future<String?> pickAndConvertFromCamera() async {
    final image = await pickFromCamera();
    if (image != null) {
      return await imageToBase64(image);
    }
    return null;
  }

  /// Pick and convert image to base64 from gallery
  Future<String?> pickAndConvertFromGallery() async {
    final image = await pickFromGallery();
    if (image != null) {
      return await imageToBase64(image);
    }
    return null;
  }
}
