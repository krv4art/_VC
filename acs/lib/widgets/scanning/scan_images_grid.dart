import 'dart:io';
import 'package:flutter/material.dart';
import '../../models/scan_image.dart';
import '../../l10n/app_localizations.dart';

/// Виджет для отображения и управления несколькими фотографиями в сканировании
class ScanImagesGrid extends StatelessWidget {
  /// Список загруженных изображений
  final List<ScanImage> images;

  /// Callback при добавлении нового фото
  final Function(ImageType type) onAddImage;

  /// Callback при удалении фото
  final Function(int index) onRemoveImage;

  const ScanImagesGrid({
    super.key,
    required this.images,
    required this.onAddImage,
    required this.onRemoveImage,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final frontLabel = images
        .where((img) => img.type == ImageType.frontLabel)
        .firstOrNull;
    final ingredientImages = images
        .where((img) => img.type == ImageType.ingredients)
        .toList()
      ..sort((a, b) => a.order.compareTo(b.order));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Главная этикетка
          _buildImageSlot(
            context: context,
            label: l10n.frontLabelType,
            image: frontLabel,
            type: ImageType.frontLabel,
            onAdd: () => onAddImage(ImageType.frontLabel),
            onRemove: frontLabel != null
                ? () {
                    final index = images.indexOf(frontLabel);
                    if (index != -1) onRemoveImage(index);
                  }
                : null,
          ),
          const SizedBox(height: 12),

          // Состав ингредиентов
          _buildImageSlot(
            context: context,
            label: '${l10n.ingredientsType} ${ingredientImages.length + 1}',
            image: ingredientImages.lastOrNull,
            type: ImageType.ingredients,
            onAdd: () => onAddImage(ImageType.ingredients),
            onRemove: ingredientImages.isNotEmpty
                ? () {
                    final lastIngredient = ingredientImages.last;
                    final index = images.indexOf(lastIngredient);
                    if (index != -1) onRemoveImage(index);
                  }
                : null,
          ),

          // Дополнительные фото состава (если есть несколько)
          if (ingredientImages.length > 1) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ingredientImages
                  .take(ingredientImages.length - 1)
                  .map((img) {
                final index = images.indexOf(img);
                return _buildSmallThumbnail(
                  context: context,
                  image: img,
                  onRemove: () => onRemoveImage(index),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildImageSlot({
    required BuildContext context,
    required String label,
    required ScanImage? image,
    required ImageType type,
    required VoidCallback onAdd,
    required VoidCallback? onRemove,
  }) {
    final hasImage = image != null;

    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Миниатюра или кнопка добавления
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
            child: hasImage
                ? Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          bottomLeft: Radius.circular(12),
                        ),
                        child: Image.file(
                          File(image.imagePath),
                          fit: BoxFit.cover,
                        ),
                      ),
                      // Кнопка удаления
                      if (onRemove != null)
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: onRemove,
                            child: Container(
                              width: 24,
                              height: 24,
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
                  )
                : Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onAdd,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.add_photo_alternate_outlined,
                          color: Colors.white.withOpacity(0.6),
                          size: 32,
                        ),
                      ),
                    ),
                  ),
          ),

          // Информация
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    hasImage
                        ? 'Нажмите ✕ чтобы удалить'
                        : 'Нажмите + чтобы добавить',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallThumbnail({
    required BuildContext context,
    required ScanImage image,
    required VoidCallback onRemove,
  }) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              File(image.imagePath),
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 2,
            right: 2,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
