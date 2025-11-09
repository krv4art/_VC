import 'package:flutter/material.dart';
import 'package:acs/theme/app_theme.dart';
import 'package:acs/theme/theme_extensions_v2.dart';
import 'animated/animated_card.dart';
import '../constants/app_dimensions.dart';
import '../widgets/common/app_spacer.dart';

/// Переиспользуемая карточка для экранов выбора (возраст, тип кожи, аллергии и т.д.)
class SelectionCard extends StatelessWidget {
  /// Иконка элемента
  final IconData icon;

  /// Выбран ли элемент
  final bool isSelected;

  /// Обработчик нажатия
  final VoidCallback onTap;

  /// Заголовок элемента
  final String title;

  /// Описание элемента (опционально)
  final String? subtitle;

  const SelectionCard({
    super.key,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedCard(
      elevation: 0,
      borderRadius: BorderRadius.circular(AppDimensions.radius16),
      backgroundColor: Colors.transparent,
      margin: EdgeInsets.only(bottom: AppDimensions.space12),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            gradient: isSelected ? context.colors.primaryGradient : null,
            color: isSelected ? null : context.colors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radius16),
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
          padding: EdgeInsets.all(AppDimensions.space16),
          child: Row(
            children: [
              Container(
                width: AppDimensions.iconLarge + AppDimensions.space16,
                height: AppDimensions.iconLarge + AppDimensions.space16,
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withValues(alpha: 0.2)
                      : context.colors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(
                    AppDimensions.radius12,
                  ),
                ),
                child: Icon(
                  icon,
                  color: isSelected
                      ? (context.colors.isDark
                            ? const Color(0xFF1A1A1A) // Very dark gray for dark theme
                            : Colors.white) // White for light theme
                      : context.colors.onBackground,
                  size: AppDimensions.iconMedium,
                ),
              ),
              AppSpacer.h12(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTheme.h4.copyWith(
                        color: isSelected
                            ? (context.colors.isDark
                                  ? const Color(0xFF1A1A1A) // Very dark gray for dark theme
                                  : Colors.white) // White for light theme
                            : context.colors.onBackground,
                      ),
                    ),
                    if (subtitle != null) ...[
                      AppSpacer.v4(),
                      Text(
                        subtitle!,
                        style: AppTheme.bodySmall.copyWith(
                          color: isSelected
                              ? (context.colors.isDark
                                    ? const Color(0xFF1A1A1A) // Very dark gray for dark theme
                                          .withValues(alpha: 0.9)
                                    : Colors.white.withValues(alpha: 0.9))
                              : context.colors.onBackground.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
