import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// Universal spacing widget for consistent layout
class AppSpacer extends StatelessWidget {
  final double? width;
  final double? height;

  const AppSpacer._({
    super.key,
    this.width,
    this.height,
  });

  // Vertical spacers
  const AppSpacer.v4({super.key}) : width = null, height = AppTheme.space4;
  const AppSpacer.v8({super.key}) : width = null, height = AppTheme.space8;
  const AppSpacer.v12({super.key}) : width = null, height = AppTheme.space12;
  const AppSpacer.v16({super.key}) : width = null, height = AppTheme.space16;
  const AppSpacer.v20({super.key}) : width = null, height = AppTheme.space20;
  const AppSpacer.v24({super.key}) : width = null, height = AppTheme.space24;
  const AppSpacer.v32({super.key}) : width = null, height = AppTheme.space32;
  const AppSpacer.v48({super.key}) : width = null, height = AppTheme.space48;

  // Horizontal spacers
  const AppSpacer.h4({super.key}) : width = AppTheme.space4, height = null;
  const AppSpacer.h8({super.key}) : width = AppTheme.space8, height = null;
  const AppSpacer.h12({super.key}) : width = AppTheme.space12, height = null;
  const AppSpacer.h16({super.key}) : width = AppTheme.space16, height = null;
  const AppSpacer.h20({super.key}) : width = AppTheme.space20, height = null;
  const AppSpacer.h24({super.key}) : width = AppTheme.space24, height = null;
  const AppSpacer.h32({super.key}) : width = AppTheme.space32, height = null;

  // Custom spacer
  const AppSpacer.custom({super.key, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
    );
  }
}
