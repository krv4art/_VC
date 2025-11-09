import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../theme/theme_extensions_v2.dart';
import '../../constants/app_dimensions.dart';
import '../../widgets/common/app_spacer.dart';

class ChatOptionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const ChatOptionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: AppDimensions.space16, vertical: AppDimensions.radius12),
        decoration: BoxDecoration(
          gradient: isSelected ? context.colors.primaryGradient : null,
          color: isSelected ? null : context.colors.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusStandard),
          border: Border.all(
            color: isSelected
                ? context.colors.primary
                : context.colors.onBackground.withValues(alpha: 0.2),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [AppTheme.getColoredShadow(context.colors.shadowColor)]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : context.colors.onBackground,
              size: AppDimensions.space24 + AppDimensions.space4,
            ),
            AppSpacer.h12(),
            Expanded(
              child: Text(
                label,
                textAlign: TextAlign.left,
                style: AppTheme.bodySmall.copyWith(
                  color: isSelected
                      ? Colors.white
                      : context.colors.onBackground,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
