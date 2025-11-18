import 'package:flutter/material.dart';
import '../../constants/app_dimensions.dart';

/// Reusable spacing widgets to maintain consistent spacing
class AppSpacer {
  // Horizontal spacers
  static Widget h4() => const SizedBox(width: AppDimensions.space4);
  static Widget h8() => const SizedBox(width: AppDimensions.space8);
  static Widget h12() => const SizedBox(width: AppDimensions.space12);
  static Widget h16() => const SizedBox(width: AppDimensions.space16);
  static Widget h24() => const SizedBox(width: AppDimensions.space24);
  static Widget h32() => const SizedBox(width: AppDimensions.space32);

  // Vertical spacers
  static Widget v4() => const SizedBox(height: AppDimensions.space4);
  static Widget v8() => const SizedBox(height: AppDimensions.space8);
  static Widget v12() => const SizedBox(height: AppDimensions.space12);
  static Widget v16() => const SizedBox(height: AppDimensions.space16);
  static Widget v24() => const SizedBox(height: AppDimensions.space24);
  static Widget v32() => const SizedBox(height: AppDimensions.space32);
}
