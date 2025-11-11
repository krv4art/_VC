import 'dart:io';
import 'package:flutter/material.dart';
import '../models/analysis_result.dart';
import '../theme/app_theme.dart';
import '../theme/theme_extensions_v2.dart';
import '../l10n/app_localizations.dart';
import 'animated/animated_card.dart';
import '../constants/app_dimensions.dart';
import '../widgets/common/app_spacer.dart';

/// Компактная карточка с информацией об анализе для отображения в чате
class ScanAnalysisCard extends StatelessWidget {
  final String imagePath;
  final AnalysisResult analysisResult;
  final VoidCallback onTap;

  const ScanAnalysisCard({
    super.key,
    required this.imagePath,
    required this.analysisResult,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Определяем цвет на основе оценки безопасности
    final scoreColor = analysisResult.overallSafetyScore >= 7
        ? context.colors.success
        : analysisResult.overallSafetyScore >= 4
        ? context.colors.warning
        : context.colors.error;

    return AnimatedCard(
      elevation: 2,
      margin: EdgeInsets.symmetric(
        horizontal: AppDimensions.space16,
        vertical: AppDimensions.space8,
      ),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radius24),
          border: Border.all(
            color: context.colors.primary.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        padding: EdgeInsets.all(AppDimensions.space12),
        child: Row(
          children: [
            // Миниатюра изображения
            ClipRRect(
              borderRadius: BorderRadius.circular(AppTheme.radiusStandard),
              child: Image.file(
                File(imagePath),
                width: AppDimensions.avatarLarge,
                height: AppDimensions.avatarLarge,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: AppDimensions.avatarMedium,
                    height: AppDimensions.avatarMedium,
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radius12,
                      ),
                    ),
                    child: Icon(
                      Icons.image_not_supported,
                      color: Colors.grey,
                      size: AppDimensions.iconMedium,
                    ),
                  );
                },
              ),
            ),
            AppSpacer.h12(),

            // Информация об анализе
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Иконка и заголовок
                  Row(
                    children: [
                      Icon(
                        Icons.science_outlined,
                        size: AppDimensions.iconMedium,
                        color: context.colors.primary,
                      ),
                      AppSpacer.h4(),
                      Expanded(
                        child: Text(
                          l10n.scanAnalysis,
                          style: AppTheme.bodyLarge.copyWith(
                            fontWeight: FontWeight.w600,
                            color: context.colors.onBackground,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppDimensions.space4 + 2.0),

                  // Оценка безопасности
                  Row(
                    children: [
                      Icon(
                        Icons.shield_outlined,
                        size: AppDimensions.iconSmall - 2,
                        color: scoreColor,
                      ),
                      AppSpacer.h4(),
                      Text(
                        '${analysisResult.overallSafetyScore.toStringAsFixed(1)}/10',
                        style: AppTheme.caption.copyWith(
                          color: scoreColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      AppSpacer.h12(),
                      Text(
                        '${analysisResult.ingredients.length} ${l10n.ingredients}',
                        style: AppTheme.caption.copyWith(
                          color: context.colors.onSecondary,
                        ),
                      ),
                    ],
                  ),

                  // Предупреждения о высоком риске (если есть)
                  if (analysisResult.highRiskIngredients.isNotEmpty) ...[
                    SizedBox(height: AppDimensions.space4 + 2.0),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppDimensions.space8,
                        vertical: AppDimensions.space4,
                      ),
                      decoration: BoxDecoration(
                        color: context.colors.error.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radius8,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            size: AppDimensions.iconSmall,
                            color: context.colors.error,
                          ),
                          AppSpacer.h4(),
                          Text(
                            '${analysisResult.highRiskIngredients.length} ${l10n.highRisk.toLowerCase()}',
                            style: AppTheme.caption.copyWith(
                              fontSize: AppDimensions.space8 + 2.0,
                              color: context.colors.error,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Иконка перехода
            Icon(
              Icons.chevron_right,
              color: context.colors.onSecondary,
              size: AppDimensions.iconMedium,
            ),
          ],
        ),
      ),
    );
  }
}
