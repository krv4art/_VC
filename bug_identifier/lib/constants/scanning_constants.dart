import 'package:flutter/material.dart';

/// Constants for scanning screen animations and UI
class ScanningConstants {
  ScanningConstants._();

  // Animation durations
  static const Duration mainAnimationDuration = Duration(milliseconds: 800);
  static const Duration breathingAnimationDuration = Duration(
    milliseconds: 2000,
  );
  static const Duration focusIndicatorDuration = Duration(milliseconds: 300);
  static const Duration slowInternetTimerDuration = Duration(seconds: 7);

  // Animation intervals (0.0 to 1.0)
  static const double frameScaleIntervalStart = 0.0;
  static const double frameScaleIntervalEnd = 0.625;
  static const double frameFadeIntervalStart = 0.0;
  static const double frameFadeIntervalEnd = 0.625;
  static const double cornerDrawIntervalStart = 0.0;
  static const double cornerDrawIntervalEnd = 0.75;
  static const double textFadeIntervalStart = 0.25;
  static const double textFadeIntervalEnd = 0.75;
  static const double textSlideIntervalStart = 0.25;
  static const double textSlideIntervalEnd = 0.75;
  static const double galleryButtonFadeIntervalStart = 0.375;
  static const double galleryButtonFadeIntervalEnd = 0.8125;
  static const double galleryButtonSlideIntervalStart = 0.375;
  static const double galleryButtonSlideIntervalEnd = 0.8125;
  static const double cameraButtonFadeIntervalStart = 0.5;
  static const double cameraButtonFadeIntervalEnd = 0.9375;
  static const double cameraButtonSlideIntervalStart = 0.5;
  static const double cameraButtonSlideIntervalEnd = 0.9375;

  // Animation curves
  static const Curve frameScaleCurve = Curves.easeOutCubic;
  static const Curve frameFadeCurve = Curves.easeOut;
  static const Curve cornerDrawCurve = Curves.easeInOut;
  static const Curve textFadeCurve = Curves.easeOut;
  static const Curve textSlideCurve = Curves.easeOut;
  static const Curve galleryButtonFadeCurve = Curves.easeOut;
  static const Curve galleryButtonSlideCurve = Curves.easeOutBack;
  static const Curve cameraButtonFadeCurve = Curves.easeOut;
  static const Curve cameraButtonSlideCurve = Curves.easeOutBack;
  static const Curve breathingCurve = Curves.easeInOut;

  // Animation values
  static const double frameScaleBegin = 0.8;
  static const double frameScaleEnd = 1.0;
  static const double frameFadeBegin = 0.0;
  static const double frameFadeEnd = 1.0;
  static const double cornerDrawBegin = 0.0;
  static const double cornerDrawEnd = 1.0;
  static const double textFadeBegin = 0.0;
  static const double textFadeEnd = 1.0;
  static const double textSlideBegin = 0.3;
  static const double textSlideEnd = 0.0;
  static const Offset textSlideBeginOffset = Offset(0, 0.3);
  static const Offset textSlideEndOffset = Offset.zero;
  static const double galleryButtonFadeBegin = 0.0;
  static const double galleryButtonFadeEnd = 1.0;
  static const double galleryButtonSlideBegin = 1.5;
  static const double galleryButtonSlideEnd = 0.0;
  static const Offset galleryButtonSlideBeginOffset = Offset(0, 1.5);
  static const Offset galleryButtonSlideEndOffset = Offset.zero;
  static const double cameraButtonFadeBegin = 0.0;
  static const double cameraButtonFadeEnd = 1.0;
  static const double cameraButtonSlideBegin = 1.5;
  static const double cameraButtonSlideEnd = 0.0;
  static const Offset cameraButtonSlideBeginOffset = Offset(0, 1.5);
  static const Offset cameraButtonSlideEndOffset = Offset.zero;
  static const double breathingScaleBegin = 1.0;
  static const double breathingScaleEnd = 1.08;
  static const double focusIndicatorScaleBegin = 1.5;
  static const double focusIndicatorScaleEnd = 1.0;

  // UI dimensions
  static const double frameWidthFactor = 0.8;
  static const double frameHeightFactor = 0.5;
  static const double cornerLength = 40.0;
  static const double cornerWidth = 4.0;
  static const double focusIndicatorSize = 80.0;
  static const double focusIndicatorBorderWidth = 2.0;
  static const double focusIndicatorBorderRadius = 40.0;
}
