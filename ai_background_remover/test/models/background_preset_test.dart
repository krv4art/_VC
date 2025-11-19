import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:ai_background_remover/models/background_preset.dart';

void main() {
  group('BackgroundPreset', () {
    test('should create solid color preset', () {
      const preset = BackgroundPreset(
        id: 'test_white',
        name: 'White',
        type: BackgroundType.solid,
        color: Colors.white,
      );

      expect(preset.id, equals('test_white'));
      expect(preset.name, equals('White'));
      expect(preset.type, equals(BackgroundType.solid));
      expect(preset.color, equals(Colors.white));
      expect(preset.isPremium, isFalse);
    });

    test('should create gradient preset', () {
      const preset = BackgroundPreset(
        id: 'test_gradient',
        name: 'Sunset',
        type: BackgroundType.gradient,
        gradientColors: [Colors.red, Colors.orange],
        gradientType: GradientType.linear,
      );

      expect(preset.type, equals(BackgroundType.gradient));
      expect(preset.gradientColors?.length, equals(2));
      expect(preset.gradientType, equals(GradientType.linear));
    });

    test('should create premium preset', () {
      const preset = BackgroundPreset(
        id: 'premium_test',
        name: 'Premium Background',
        type: BackgroundType.solid,
        color: Colors.blue,
        isPremium: true,
      );

      expect(preset.isPremium, isTrue);
    });

    test('should copy with new values', () {
      const original = BackgroundPreset(
        id: 'test',
        name: 'Test',
        type: BackgroundType.solid,
        color: Colors.white,
      );

      final copied = original.copyWith(
        name: 'New Name',
        isPremium: true,
      );

      expect(copied.id, equals('test'));
      expect(copied.name, equals('New Name'));
      expect(copied.type, equals(BackgroundType.solid));
      expect(copied.isPremium, isTrue);
    });
  });

  group('BackgroundPresets', () {
    test('should have predefined presets', () {
      expect(BackgroundPresets.allPresets, isNotEmpty);
      expect(BackgroundPresets.allPresets.length, greaterThan(10));
    });

    test('should have transparent preset', () {
      expect(BackgroundPresets.transparent.id, equals('transparent'));
      expect(BackgroundPresets.transparent.type, equals(BackgroundType.transparent));
    });

    test('should have solid color presets', () {
      expect(BackgroundPresets.white.type, equals(BackgroundType.solid));
      expect(BackgroundPresets.black.type, equals(BackgroundType.solid));
      expect(BackgroundPresets.blue.type, equals(BackgroundType.solid));
    });

    test('should have gradient presets', () {
      expect(BackgroundPresets.sunsetGradient.type, equals(BackgroundType.gradient));
      expect(BackgroundPresets.oceanGradient.type, equals(BackgroundType.gradient));
      expect(BackgroundPresets.sunsetGradient.gradientColors, isNotNull);
      expect(BackgroundPresets.sunsetGradient.gradientColors!.length, equals(2));
    });

    test('should filter by category', () {
      final solidColors = BackgroundPresets.getByCategory(BackgroundCategory.solid);
      expect(solidColors, isNotEmpty);

      final gradients = BackgroundPresets.getByCategory(BackgroundCategory.gradient);
      expect(gradients, isNotEmpty);
    });

    test('should filter free presets', () {
      final freePresets = BackgroundPresets.getFreePresets();
      expect(freePresets, isNotEmpty);
      expect(freePresets.every((p) => !p.isPremium), isTrue);
    });

    test('should filter premium presets', () {
      final premiumPresets = BackgroundPresets.getPremiumPresets();
      expect(premiumPresets.every((p) => p.isPremium), isTrue);
    });

    test('should get preset by ID', () {
      final preset = BackgroundPresets.getById('white');
      expect(preset, isNotNull);
      expect(preset?.id, equals('white'));

      final nonExistent = BackgroundPresets.getById('non_existent');
      expect(nonExistent, isNull);
    });
  });

  group('BackgroundType', () {
    test('should have all types defined', () {
      expect(BackgroundType.values.length, equals(5));
      expect(BackgroundType.values, contains(BackgroundType.solid));
      expect(BackgroundType.values, contains(BackgroundType.gradient));
      expect(BackgroundType.values, contains(BackgroundType.image));
      expect(BackgroundType.values, contains(BackgroundType.transparent));
      expect(BackgroundType.values, contains(BackgroundType.blur));
    });
  });

  group('GradientType', () {
    test('should have all gradient types', () {
      expect(GradientType.values.length, equals(3));
      expect(GradientType.values, contains(GradientType.linear));
      expect(GradientType.values, contains(GradientType.radial));
      expect(GradientType.values, contains(GradientType.sweep));
    });
  });
}
