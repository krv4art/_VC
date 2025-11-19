import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:ai_background_remover/services/image_processing_service.dart';
import 'package:ai_background_remover/models/processing_options.dart';

void main() {
  group('ImageProcessingService', () {
    late ImageProcessingService service;

    setUp(() {
      service = ImageProcessingService();
    });

    test('should create service instance', () {
      expect(service, isNotNull);
      expect(service, isA<ImageProcessingService>());
    });

    // Note: These tests would require actual image files to run
    // In production, you would create test fixtures
    test('should have removeBackground method', () {
      expect(service.removeBackground, isA<Function>());
    });

    test('should have applyFilter method', () {
      expect(service.applyFilter, isA<Function>());
    });

    test('should have saveToGallery method', () {
      expect(service.saveToGallery, isA<Function>());
    });
  });

  group('ProcessingOptions', () {
    test('should create processing options with default values', () {
      final options = ProcessingOptions(mode: 'Remove Background');

      expect(options.mode, equals('Remove Background'));
      expect(options.outputFormat, equals('PNG'));
      expect(options.autoEnhance, isTrue);
      expect(options.quality, equals(95));
    });

    test('should create processing options with custom values', () {
      final options = ProcessingOptions(
        mode: 'Auto Enhance',
        outputFormat: 'JPG',
        quality: 80,
        autoEnhance: false,
      );

      expect(options.mode, equals('Auto Enhance'));
      expect(options.outputFormat, equals('JPG'));
      expect(options.quality, equals(80));
      expect(options.autoEnhance, isFalse);
    });

    test('should copy with new values', () {
      final original = ProcessingOptions(mode: 'Remove Background');
      final copied = original.copyWith(quality: 90, outputFormat: 'JPG');

      expect(copied.mode, equals('Remove Background'));
      expect(copied.quality, equals(90));
      expect(copied.outputFormat, equals('JPG'));
      expect(copied.autoEnhance, equals(original.autoEnhance));
    });

    test('should convert to map', () {
      final options = ProcessingOptions(
        mode: 'Remove Background',
        quality: 95,
      );

      final map = options.toMap();

      expect(map['mode'], equals('Remove Background'));
      expect(map['outputFormat'], equals('PNG'));
      expect(map['quality'], equals(95));
      expect(map['autoEnhance'], isTrue);
    });
  });
}
