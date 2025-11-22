import 'dart:io';
import 'package:flutter/material.dart';
import '../../models/scan_image.dart';
import '../../l10n/app_localizations.dart';

/// Виджет выбора типа фотографии для сканирования с кнопкой анализа
class PhotoTypeSelector extends StatelessWidget {
  final ImageType? selectedType;
  final ScanImage? frontLabelImage;
  final ScanImage? ingredientsImage;
  final Function(ImageType) onTypeSelected;
  final Function(ImageType)? onRemoveImage;
  final VoidCallback? onAnalyze;

  const PhotoTypeSelector({
    super.key,
    required this.selectedType,
    this.frontLabelImage,
    this.ingredientsImage,
    required this.onTypeSelected,
    this.onRemoveImage,
    this.onAnalyze,
  });

  bool get _hasAnyImage => frontLabelImage != null || ingredientsImage != null;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // 1. Главная
          Expanded(
            child: _buildTypeCard(
              context: context,
              type: ImageType.frontLabel,
              label: l10n.frontLabelType,
              icon: Icons.label_outline,
              image: frontLabelImage,
            ),
          ),

          const SizedBox(width: 12),

          // 2. Состав
          Expanded(
            child: _buildTypeCard(
              context: context,
              type: ImageType.ingredients,
              label: l10n.ingredientsType,
              icon: Icons.list_alt,
              image: ingredientsImage,
            ),
          ),

          const SizedBox(width: 12),

          // 3. Кнопка Анализ
          Expanded(
            child: _buildAnalyzeButton(context),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyzeButton(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isEnabled = _hasAnyImage;

    return GestureDetector(
      onTap: isEnabled ? onAnalyze : null,
      child: Container(
        width: double.infinity,
        height: 80,
        decoration: BoxDecoration(
          color: isEnabled
              ? Colors.green.withOpacity(0.8)
              : Colors.grey.withOpacity(0.4),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isEnabled
                ? Colors.white
                : Colors.white.withOpacity(0.2),
            width: 1.5,
          ),
          boxShadow: isEnabled
              ? [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.play_arrow_rounded,
              color: isEnabled ? Colors.white : Colors.white.withOpacity(0.5),
              size: 32,
            ),
            const SizedBox(height: 4),
            Text(
              l10n.analyzeButton,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isEnabled ? Colors.white : Colors.white.withOpacity(0.5),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeCard({
    required BuildContext context,
    required ImageType type,
    required String label,
    required IconData icon,
    ScanImage? image,
  }) {
    final isSelected = selectedType == type;
    final hasImage = image != null;

    return GestureDetector(
      onTap: () => onTypeSelected(type),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 80,
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.black.withOpacity(0.8)
                  : Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? Colors.white
                    : Colors.white.withOpacity(0.4),
                width: isSelected ? 2.5 : 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: hasImage
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.file(
                          File(image.imagePath),
                          fit: BoxFit.cover,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.3),
                                Colors.black.withOpacity(0.5),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 8,
                          left: 0,
                          right: 0,
                          child: Text(
                            label,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              shadows: [
                                Shadow(
                                  color: Colors.black,
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        icon,
                        color: Colors.white,
                        size: 28,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        label,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
          ),
          if (hasImage && onRemoveImage != null)
            Positioned(
              top: 4,
              right: 4,
              child: GestureDetector(
                onTap: () => onRemoveImage!(type),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.8),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
