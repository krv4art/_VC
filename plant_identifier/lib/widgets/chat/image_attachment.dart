import 'dart:io';
import 'package:flutter/material.dart';
import '../../theme/theme_extensions.dart';
import '../../constants/app_dimensions.dart';

/// Callback when remove button is tapped
typedef OnRemoveCallback = void Function();

/// A reusable widget that displays an image preview with a remove button
/// Perfect for showing selected images before sending in a chat
class ImageAttachment extends StatelessWidget {
  final File image;
  final OnRemoveCallback onRemove;
  final double height;
  final double? width;

  const ImageAttachment({
    Key? key,
    required this.image,
    required this.onRemove,
    this.height = 100,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: EdgeInsets.only(
        right: AppDimensions.space8,
        bottom: AppDimensions.space8,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.radius12),
        border: Border.all(
          color: context.colors.onSecondary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          // Image preview
          ClipRRect(
            borderRadius: BorderRadius.circular(AppDimensions.radius12),
            child: Image.file(
              image,
              height: height,
              width: width,
              fit: BoxFit.cover,
            ),
          ),
          // Remove button
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                padding: EdgeInsets.all(AppDimensions.space4),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: AppDimensions.iconSmall,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
