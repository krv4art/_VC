// services/qr_code_service.dart
// Service for generating QR codes for resumes

import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:cv_engineer/models/resume.dart';
import 'package:cv_engineer/models/social_links.dart';

class QRCodeService {
  /// Generate vCard format QR code data from resume
  static String generateVCard(Resume resume) {
    final buffer = StringBuffer();

    buffer.writeln('BEGIN:VCARD');
    buffer.writeln('VERSION:3.0');

    // Name
    buffer.writeln('FN:${resume.personalInfo.fullName}');

    // Email
    if (resume.personalInfo.email.isNotEmpty) {
      buffer.writeln('EMAIL:${resume.personalInfo.email}');
    }

    // Phone
    if (resume.personalInfo.phone.isNotEmpty) {
      buffer.writeln('TEL:${resume.personalInfo.phone}');
    }

    // LinkedIn URL
    final linkedInLink = resume.socialLinks.firstWhere(
      (link) => link.platform == SocialPlatform.linkedin,
      orElse: () => SocialLink(
        id: '',
        platform: SocialPlatform.linkedin,
        url: '',
      ),
    );

    if (linkedInLink.url.isNotEmpty) {
      buffer.writeln('URL;type=LinkedIn:${linkedInLink.url}');
    }

    // Portfolio/Website
    final portfolioLink = resume.socialLinks.firstWhere(
      (link) => link.platform == SocialPlatform.portfolio || link.platform == SocialPlatform.website,
      orElse: () => SocialLink(
        id: '',
        platform: SocialPlatform.website,
        url: '',
      ),
    );

    if (portfolioLink.url.isNotEmpty) {
      buffer.writeln('URL:${portfolioLink.url}');
    }

    // GitHub
    final githubLink = resume.socialLinks.firstWhere(
      (link) => link.platform == SocialPlatform.github,
      orElse: () => SocialLink(
        id: '',
        platform: SocialPlatform.github,
        url: '',
      ),
    );

    if (githubLink.url.isNotEmpty) {
      buffer.writeln('URL;type=GitHub:${githubLink.url}');
    }

    buffer.writeln('END:VCARD');

    return buffer.toString();
  }

  /// Generate contact card URL
  static String generateContactUrl(Resume resume) {
    final params = <String>[];

    // Name
    params.add('name=${Uri.encodeComponent(resume.personalInfo.fullName)}');

    // Email
    if (resume.personalInfo.email.isNotEmpty) {
      params.add('email=${Uri.encodeComponent(resume.personalInfo.email)}');
    }

    // Phone
    if (resume.personalInfo.phone.isNotEmpty) {
      params.add('phone=${Uri.encodeComponent(resume.personalInfo.phone)}');
    }

    return 'https://contact.card/?${params.join('&')}';
  }

  /// Build QR Code widget
  static Widget buildQRCodeWidget({
    required String data,
    double size = 200,
    Color? foregroundColor,
    Color? backgroundColor,
    bool addLogo = false,
  }) {
    return QrImageView(
      data: data,
      version: QrVersions.auto,
      size: size,
      backgroundColor: backgroundColor ?? Colors.white,
      foregroundColor: foregroundColor ?? Colors.black,
      padding: const EdgeInsets.all(16),
      embeddedImage: addLogo ? const AssetImage('assets/images/logo.png') : null,
      embeddedImageStyle: addLogo
          ? const QrEmbeddedImageStyle(
              size: Size(40, 40),
            )
          : null,
    );
  }

  /// Capture QR Code as image
  static Future<ui.Image?> captureQRCode(GlobalKey key) async {
    try {
      final boundary = key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return null;

      final image = await boundary.toImage(pixelRatio: 3.0);
      return image;
    } catch (e) {
      debugPrint('Error capturing QR code: $e');
      return null;
    }
  }
}
