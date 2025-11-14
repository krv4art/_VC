import 'dart:io';
import 'package:flutter/material.dart';
import '../../theme/theme_extensions.dart';
import '../../constants/app_dimensions.dart';
import '../../widgets/common/app_spacer.dart';
import '../../l10n/app_localizations.dart';
import '../../services/image_picker_service.dart';
import 'image_attachment.dart';

/// Callback when message is submitted (now includes optional image)
typedef OnMessageSubmitted = Future<void> Function(String text, File? image);

/// Callback when image is selected
typedef OnImageSelected = void Function(File? image);

/// A reusable animated input field widget for chat
class ChatInputField extends StatefulWidget {
  final TextEditingController controller;
  final Animation<double> animation;
  final OnMessageSubmitted onSubmitted;
  final OnImageSelected? onImageSelected;

  const ChatInputField({
    Key? key,
    required this.controller,
    required this.animation,
    required this.onSubmitted,
    this.onImageSelected,
  }) : super(key: key);

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  final ImagePickerService _imagePickerService = ImagePickerService();
  File? _selectedImage;

  /// Show image source selection dialog
  Future<void> _showImageSourceDialog() async {
    final l10n = AppLocalizations.of(context)!;

    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.photo_camera, color: context.colors.primary),
                title: Text(l10n.camera ?? 'Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromCamera();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library, color: context.colors.primary),
                title: Text(l10n.gallery ?? 'Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromGallery();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// Pick image from camera
  Future<void> _pickImageFromCamera() async {
    final image = await _imagePickerService.pickFromCamera();
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
      widget.onImageSelected?.call(image);
    }
  }

  /// Pick image from gallery
  Future<void> _pickImageFromGallery() async {
    final image = await _imagePickerService.pickFromGallery();
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
      widget.onImageSelected?.call(image);
    }
  }

  /// Remove selected image
  void _removeImage() {
    setState(() {
      _selectedImage = null;
    });
    widget.onImageSelected?.call(null);
  }

  /// Handle send button press
  Future<void> _handleSend() async {
    final text = widget.controller.text;
    if (text.trim().isEmpty && _selectedImage == null) return;

    // Send message with image
    await widget.onSubmitted(text, _selectedImage);

    // Clear image after sending
    setState(() {
      _selectedImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AnimatedBuilder(
      animation: widget.animation,
      builder: (context, child) {
        return SlideTransition(
          position:
              Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
                  .animate(
                    CurvedAnimation(
                      parent: widget.animation,
                      curve: Curves.easeOutCubic,
                    ),
                  ),
          child: FadeTransition(
            opacity: widget.animation,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: context.colors.surface,
                    border: Border(
                      top: BorderSide(
                        color: context.colors.onSecondary.withValues(
                          alpha: 0.1,
                        ),
                        width: 1,
                      ),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.space4,
                    vertical: AppDimensions.space4,
                  ),
                  child: Column(
                    children: [
                      // Image preview (if selected)
                      if (_selectedImage != null)
                        Padding(
                          padding: EdgeInsets.only(
                            left: AppDimensions.space8,
                            right: AppDimensions.space8,
                            bottom: AppDimensions.space8,
                          ),
                          child: ImageAttachment(
                            image: _selectedImage!,
                            onRemove: _removeImage,
                            height: 80,
                            width: 80,
                          ),
                        ),
                      // Input row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Attachment button
                          IconButton(
                            onPressed: _showImageSourceDialog,
                            icon: Icon(
                              Icons.attach_file,
                              color: context.colors.onSecondary.withValues(
                                alpha: 0.7,
                              ),
                              size: AppDimensions.iconMedium,
                            ),
                            padding: EdgeInsets.all(AppDimensions.space8),
                            constraints: const BoxConstraints(),
                            splashRadius: AppDimensions.iconMedium,
                          ),
                          AppSpacer.h4(),
                          // Text field
                          Expanded(
                            child: TextField(
                              controller: widget.controller,
                              style: TextStyle(
                                color: context.colors.onBackground,
                                fontSize: AppDimensions.iconSmall,
                              ),
                              decoration: InputDecoration(
                                hintText: l10n.writeAMessage,
                                hintStyle: TextStyle(
                                  color: context.colors.onSecondary.withValues(
                                    alpha: 0.6,
                                  ),
                                ),
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: AppDimensions.space8,
                                  vertical: AppDimensions.space4,
                                ),
                                filled: false,
                              ),
                              maxLines: null,
                              textInputAction: TextInputAction.send,
                              onSubmitted: (text) => _handleSend(),
                            ),
                          ),
                          AppSpacer.h4(),
                          // Send button
                          IconButton(
                            onPressed: _handleSend,
                            icon: Icon(
                              Icons.send_rounded,
                              color: context.colors.primary,
                              size: AppDimensions.iconMedium,
                            ),
                            padding: EdgeInsets.all(AppDimensions.space8),
                            constraints: const BoxConstraints(),
                            splashRadius: AppDimensions.iconMedium,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
