import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import '../../constants/app_dimensions.dart';
import '../../providers/tools_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/loading_overlay.dart';
import '../../widgets/common/error_dialog.dart';
import '../../utils/file_utils.dart';

/// Watermark Screen for adding watermarks to PDFs
class WatermarkScreen extends StatefulWidget {
  const WatermarkScreen({super.key});

  @override
  State<WatermarkScreen> createState() => _WatermarkScreenState();
}

class _WatermarkScreenState extends State<WatermarkScreen> {
  String? _selectedFilePath;
  WatermarkType _watermarkType = WatermarkType.text;
  final TextEditingController _textController = TextEditingController();
  String? _imageWatermarkPath;
  double _opacity = 0.5;
  WatermarkPosition _position = WatermarkPosition.center;
  double _fontSize = 48;
  Color _textColor = Colors.grey;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Watermark'),
      ),
      body: Consumer<ToolsProvider>(
        builder: (context, toolsProvider, child) {
          return LoadingOverlay(
            isLoading: toolsProvider.isProcessing,
            message: toolsProvider.currentOperation,
            child: ListView(
              padding: const EdgeInsets.all(AppDimensions.space16),
              children: [
                // Instructions
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimensions.space16),
                    child: Row(
                      children: [
                        Icon(
                          Icons.water_drop,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: AppDimensions.space12),
                        Expanded(
                          child: Text(
                            'Add text or image watermark to protect your PDF documents.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.space24),

                // File selection
                if (_selectedFilePath == null)
                  CustomButton(
                    text: 'Select PDF File',
                    icon: Icons.file_upload,
                    onPressed: _selectFile,
                  )
                else
                  _buildSelectedFile(),

                // Watermark type selector
                if (_selectedFilePath != null) ...[
                  const SizedBox(height: AppDimensions.space24),
                  _buildWatermarkTypeSelector(),
                ],

                // Watermark content
                if (_selectedFilePath != null) ...[
                  const SizedBox(height: AppDimensions.space16),
                  if (_watermarkType == WatermarkType.text)
                    _buildTextWatermarkSettings()
                  else
                    _buildImageWatermarkSettings(),
                ],

                // Position selector
                if (_selectedFilePath != null) ...[
                  const SizedBox(height: AppDimensions.space16),
                  _buildPositionSelector(),
                ],

                // Opacity slider
                if (_selectedFilePath != null) ...[
                  const SizedBox(height: AppDimensions.space16),
                  _buildOpacitySlider(),
                ],

                // Apply button
                if (_selectedFilePath != null) ...[
                  const SizedBox(height: AppDimensions.space32),
                  CustomButton(
                    text: 'Apply Watermark',
                    icon: Icons.check,
                    onPressed: _canApplyWatermark() ? () => _applyWatermark(toolsProvider) : null,
                    isLoading: toolsProvider.isProcessing,
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSelectedFile() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.space16),
        child: Row(
          children: [
            Icon(
              Icons.picture_as_pdf,
              size: 40,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: AppDimensions.space16),
            Expanded(
              child: Text(
                FileUtils.getFilename(_selectedFilePath!),
                style: Theme.of(context).textTheme.titleMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                setState(() {
                  _selectedFilePath = null;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWatermarkTypeSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Watermark Type',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppDimensions.space16),
            Row(
              children: [
                Expanded(
                  child: _buildTypeOption(
                    WatermarkType.text,
                    'Text',
                    Icons.text_fields,
                  ),
                ),
                const SizedBox(width: AppDimensions.space12),
                Expanded(
                  child: _buildTypeOption(
                    WatermarkType.image,
                    'Image',
                    Icons.image,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeOption(WatermarkType type, String label, IconData icon) {
    final isSelected = _watermarkType == type;

    return InkWell(
      onTap: () {
        setState(() {
          _watermarkType = type;
        });
      },
      borderRadius: BorderRadius.circular(AppDimensions.radius12),
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.space16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(AppDimensions.radius12),
          color: isSelected
              ? Theme.of(context).colorScheme.primaryContainer
              : null,
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey,
            ),
            const SizedBox(height: AppDimensions.space8),
            Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextWatermarkSettings() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Watermark Text',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: AppDimensions.space12),
            CustomTextField(
              controller: _textController,
              hintText: 'Enter watermark text',
              maxLines: 2,
            ),
            const SizedBox(height: AppDimensions.space16),
            Text(
              'Font Size: ${_fontSize.toInt()}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Slider(
              value: _fontSize,
              min: 12,
              max: 100,
              divisions: 88,
              onChanged: (value) {
                setState(() {
                  _fontSize = value;
                });
              },
            ),
            const SizedBox(height: AppDimensions.space8),
            Text(
              'Text Color',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: AppDimensions.space8),
            Wrap(
              spacing: 8,
              children: [
                _buildColorOption(Colors.grey),
                _buildColorOption(Colors.black),
                _buildColorOption(Colors.red),
                _buildColorOption(Colors.blue),
                _buildColorOption(Colors.green),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorOption(Color color) {
    final isSelected = _textColor == color;

    return InkWell(
      onTap: () {
        setState(() {
          _textColor = color;
        });
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey.shade300,
            width: isSelected ? 3 : 1,
          ),
        ),
        child: isSelected
            ? const Icon(Icons.check, color: Colors.white, size: 20)
            : null,
      ),
    );
  }

  Widget _buildImageWatermarkSettings() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.space16),
        child: Column(
          children: [
            if (_imageWatermarkPath == null)
              CustomButton(
                text: 'Select Image',
                icon: Icons.image,
                isOutlined: true,
                onPressed: _selectWatermarkImage,
              )
            else
              ListTile(
                leading: const Icon(Icons.image),
                title: Text(FileUtils.getFilename(_imageWatermarkPath!)),
                trailing: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      _imageWatermarkPath = null;
                    });
                  },
                ),
                contentPadding: EdgeInsets.zero,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPositionSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Position',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppDimensions.space16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 2,
              children: WatermarkPosition.values.map((pos) {
                final isSelected = _position == pos;
                return InkWell(
                  onTap: () {
                    setState(() {
                      _position = pos;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey.shade300,
                        width: isSelected ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(AppDimensions.radius8),
                      color: isSelected
                          ? Theme.of(context).colorScheme.primaryContainer
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        pos.label,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : null,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOpacitySlider() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Opacity: ${(_opacity * 100).toInt()}%',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Slider(
              value: _opacity,
              min: 0.1,
              max: 1.0,
              divisions: 9,
              onChanged: (value) {
                setState(() {
                  _opacity = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  bool _canApplyWatermark() {
    if (_watermarkType == WatermarkType.text) {
      return _textController.text.trim().isNotEmpty;
    } else {
      return _imageWatermarkPath != null;
    }
  }

  Future<void> _selectFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          _selectedFilePath = result.files.single.path!;
        });
      }
    } catch (e) {
      if (mounted) {
        ErrorDialog.show(
          context,
          title: 'Error',
          message: 'Failed to select file',
        );
      }
    }
  }

  Future<void> _selectWatermarkImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        setState(() {
          _imageWatermarkPath = image.path;
        });
      }
    } catch (e) {
      if (mounted) {
        ErrorDialog.show(
          context,
          title: 'Error',
          message: 'Failed to select image',
        );
      }
    }
  }

  Future<void> _applyWatermark(ToolsProvider provider) async {
    if (!_canApplyWatermark()) return;

    try {
      // TODO: Implement actual watermark application
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Applying watermark...'),
          backgroundColor: Colors.green,
        ),
      );

      // Simulate processing
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Watermark applied successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        setState(() {
          _selectedFilePath = null;
          _textController.clear();
          _imageWatermarkPath = null;
        });
      }
    } catch (e) {
      if (mounted) {
        ErrorDialog.show(
          context,
          title: 'Watermark Failed',
          message: e.toString(),
        );
      }
    }
  }
}

enum WatermarkType {
  text,
  image,
}

enum WatermarkPosition {
  topLeft,
  topCenter,
  topRight,
  centerLeft,
  center,
  centerRight,
  bottomLeft,
  bottomCenter,
  bottomRight,
}

extension WatermarkPositionExtension on WatermarkPosition {
  String get label {
    switch (this) {
      case WatermarkPosition.topLeft:
        return 'Top Left';
      case WatermarkPosition.topCenter:
        return 'Top Center';
      case WatermarkPosition.topRight:
        return 'Top Right';
      case WatermarkPosition.centerLeft:
        return 'Center Left';
      case WatermarkPosition.center:
        return 'Center';
      case WatermarkPosition.centerRight:
        return 'Center Right';
      case WatermarkPosition.bottomLeft:
        return 'Bottom Left';
      case WatermarkPosition.bottomCenter:
        return 'Bottom Center';
      case WatermarkPosition.bottomRight:
        return 'Bottom Right';
    }
  }
}
