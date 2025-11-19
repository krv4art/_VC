import 'dart:io';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';

/// Service for sharing photos to social media and other platforms
class SocialSharingService {
  /// Share a photo file with optional text
  Future<bool> sharePhoto({
    required String photoPath,
    String? text,
    String? subject,
    Rect? sharePositionOrigin,
  }) async {
    try {
      final file = File(photoPath);
      if (!await file.exists()) {
        debugPrint('Photo file does not exist: $photoPath');
        return false;
      }

      final xFile = XFile(photoPath);
      final result = await Share.shareXFiles(
        [xFile],
        text: text ?? 'Check out my AI-generated photo from AI Photo Studio Pro! 📸✨',
        subject: subject,
        sharePositionOrigin: sharePositionOrigin,
      );

      return result.status == ShareResultStatus.success;
    } catch (e) {
      debugPrint('Error sharing photo: $e');
      return false;
    }
  }

  /// Share multiple photos at once
  Future<bool> shareMultiplePhotos({
    required List<String> photoPaths,
    String? text,
    String? subject,
    Rect? sharePositionOrigin,
  }) async {
    try {
      final existingFiles = <XFile>[];

      for (final path in photoPaths) {
        final file = File(path);
        if (await file.exists()) {
          existingFiles.add(XFile(path));
        }
      }

      if (existingFiles.isEmpty) {
        debugPrint('No valid photo files to share');
        return false;
      }

      final result = await Share.shareXFiles(
        existingFiles,
        text: text ?? 'Check out my AI-generated photos from AI Photo Studio Pro! 📸✨',
        subject: subject,
        sharePositionOrigin: sharePositionOrigin,
      );

      return result.status == ShareResultStatus.success;
    } catch (e) {
      debugPrint('Error sharing multiple photos: $e');
      return false;
    }
  }

  /// Share with platform-specific text for Instagram
  Future<bool> shareToInstagram(String photoPath) async {
    return sharePhoto(
      photoPath: photoPath,
      text: '✨ Created with AI Photo Studio Pro\n#AIPhoto #AIHeadshot #ProfessionalPhoto',
    );
  }

  /// Share with platform-specific text for Facebook
  Future<bool> shareToFacebook(String photoPath) async {
    return sharePhoto(
      photoPath: photoPath,
      text: 'Just created this amazing AI headshot with AI Photo Studio Pro! 🎨📸',
    );
  }

  /// Share with platform-specific text for VK
  Future<bool> shareToVK(String photoPath) async {
    return sharePhoto(
      photoPath: photoPath,
      text: 'Мой AI-портрет от AI Photo Studio Pro! 📸✨',
    );
  }

  /// Share with platform-specific text for Telegram
  Future<bool> shareToTelegram(String photoPath) async {
    return sharePhoto(
      photoPath: photoPath,
      text: 'Check out my AI photo! Made with AI Photo Studio Pro 📸',
    );
  }

  /// Share text only (for app links, referrals, etc.)
  Future<bool> shareText({
    required String text,
    String? subject,
    Rect? sharePositionOrigin,
  }) async {
    try {
      final result = await Share.share(
        text,
        subject: subject,
        sharePositionOrigin: sharePositionOrigin,
      );

      return result.status == ShareResultStatus.success;
    } catch (e) {
      debugPrint('Error sharing text: $e');
      return false;
    }
  }

  /// Share app link for referrals
  Future<bool> shareAppLink({
    String? referralCode,
    Rect? sharePositionOrigin,
  }) async {
    final link = referralCode != null
        ? 'https://aiphotostudio.pro/invite/$referralCode'
        : 'https://aiphotostudio.pro';

    final text = '''
🎨 Try AI Photo Studio Pro - Create stunning AI headshots!

Download now and get started for free:
$link

#AIPhoto #AIHeadshot #PhotoStudio
''';

    return shareText(
      text: text,
      subject: 'Try AI Photo Studio Pro!',
      sharePositionOrigin: sharePositionOrigin,
    );
  }

  /// Get share position origin from context (for iOS specifically)
  Rect? getSharePositionOrigin(BuildContext context) {
    final box = context.findRenderObject() as RenderBox?;
    if (box != null) {
      return box.localToGlobal(Offset.zero) & box.size;
    }
    return null;
  }
}
