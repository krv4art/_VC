import 'package:flutter/material.dart';
import '../../theme/theme_extensions_v2.dart';
import '../../constants/app_dimensions.dart';
import '../../widgets/common/app_spacer.dart';
import '../../widgets/animated/animated_card.dart';

/// Тип баннера для определения стиля
enum BannerType { info, warning, success }

/// Универсальный баннер для чата, следующий дизайн-системе приложения
/// Использует цвета активной темы и константы размеров
class ChatBanner extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onActionPressed;
  final BannerType bannerType;

  const ChatBanner({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onActionPressed,
    this.bannerType = BannerType.info,
  });

  @override
  Widget build(BuildContext context) {
    final accentColor = _getAccentColor(context);

    return AnimatedCard(
      elevation: 1,
      margin: EdgeInsets.symmetric(
        horizontal: AppDimensions.space4,
        vertical: AppDimensions.space4,
      ),
      child: Container(
        padding: EdgeInsets.all(AppDimensions.space12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: AppDimensions.iconSmall, color: accentColor),
            AppSpacer.h12(),
            Flexible(
              child: subtitle != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: AppDimensions.radius12,
                            fontWeight: FontWeight.w600,
                            color: context.colors.onSurface,
                          ),
                        ),
                        AppSpacer.v4(),
                        Text(
                          subtitle!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: AppDimensions.radius12,
                            color: context.colors.onSurface.withValues(
                              alpha: 0.7,
                            ),
                          ),
                        ),
                      ],
                    )
                  : Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: AppDimensions.radius12,
                        fontWeight: FontWeight.w600,
                        color: context.colors.onSurface,
                      ),
                    ),
            ),
            if (actionLabel != null && onActionPressed != null) ...[
              AppSpacer.h8(),
              ElevatedButton(
                onPressed: onActionPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colors.success,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.space12,
                    vertical: AppDimensions.space8,
                  ),
                  minimumSize: Size.zero,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radius8),
                  ),
                ),
                child: Text(
                  actionLabel!,
                  style: TextStyle(
                    fontSize: AppDimensions.radius12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Получить цвет акцента из темы в зависимости от типа баннера
  Color _getAccentColor(BuildContext context) {
    switch (bannerType) {
      case BannerType.warning:
        return context.colors.warning;
      case BannerType.success:
        return context.colors.success;
      case BannerType.info:
        return context.colors.primary;
    }
  }
}
