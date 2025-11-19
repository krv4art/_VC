import 'package:flutter/material.dart';

class ProcessingOptions {
  final String mode;
  final String outputFormat;
  final Color? backgroundColor;
  final String? backgroundImagePath;
  final bool autoEnhance;
  final int quality;
  final bool? isPremium;

  ProcessingOptions({
    required this.mode,
    this.outputFormat = 'PNG',
    this.backgroundColor,
    this.backgroundImagePath,
    this.autoEnhance = true,
    this.quality = 95,
    this.isPremium,
  });

  ProcessingOptions copyWith({
    String? mode,
    String? outputFormat,
    Color? backgroundColor,
    String? backgroundImagePath,
    bool? autoEnhance,
    int? quality,
    bool? isPremium,
  }) {
    return ProcessingOptions(
      mode: mode ?? this.mode,
      outputFormat: outputFormat ?? this.outputFormat,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      backgroundImagePath: backgroundImagePath ?? this.backgroundImagePath,
      autoEnhance: autoEnhance ?? this.autoEnhance,
      quality: quality ?? this.quality,
      isPremium: isPremium ?? this.isPremium,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'mode': mode,
      'outputFormat': outputFormat,
      'backgroundColor': backgroundColor?.value,
      'backgroundImagePath': backgroundImagePath,
      'autoEnhance': autoEnhance,
      'quality': quality,
      'isPremium': isPremium,
    };
  }
}
