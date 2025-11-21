import 'dart:io';
import 'package:flutter/material.dart';
import '../../models/scan_image.dart';

/// Минималистичный виджет выбора типа фотографии для сканирования
class PhotoTypeSelector extends StatelessWidget {
  final ImageType? selectedType;
  final ScanImage? frontLabelImage;
  final ScanImage? ingredientsImage;
  final Function(ImageType) onTypeSelected;
  final Function(ImageType)? onRemoveImage;

  const PhotoTypeSelector({
    super.key,
    required this.selectedType,
    this.frontLabelImage,
    this.ingredientsImage,
    required this.onTypeSelected,
    this.onRemoveImage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: _buildTypeCard(
              context: context,
              type: ImageType.frontLabel,
              label: 'Главная',
              icon: Icons.label_outline,
              image: frontLabelImage,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildTypeCard(
              context: context,
              type: ImageType.ingredients,
              label: 'Состав',
              icon: Icons.list_alt,
              image: ingredientsImage,
            ),
          ),
        ],
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
            height: 70,
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.black.withOpacity(0.7)
                  : Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? Colors.white
                    : Colors.white.withOpacity(0.3),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: hasImage
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(11),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.file(
                          File(image.imagePath),
                          fit: BoxFit.cover,
                        ),
                        // Полупрозрачный оверлей для лучшей читаемости текста
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
                        // Текст поверх изображения
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
          // Кнопка удаления
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
