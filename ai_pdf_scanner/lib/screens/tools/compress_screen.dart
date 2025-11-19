import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../../constants/app_dimensions.dart';
import '../../providers/tools_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/loading_overlay.dart';
import '../../widgets/common/error_dialog.dart';
import '../../utils/file_utils.dart';
import 'dart:io';

/// Compress Screen for PDF compression
class CompressScreen extends StatefulWidget {
  const CompressScreen({super.key});

  @override
  State<CompressScreen> createState() => _CompressScreenState();
}

class _CompressScreenState extends State<CompressScreen> {
  String? _selectedFilePath;
  int? _originalSize;
  int? _compressedSize;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compress PDF'),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: AppDimensions.space8),
                            Text(
                              'About Compression',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: AppDimensions.space12),
                        Text(
                          'Reduce your PDF file size by optimizing images and removing unnecessary data. Choose a compression level based on your needs.',
                          style: Theme.of(context).textTheme.bodyMedium,
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

                // Compression level
                if (_selectedFilePath != null) ...[
                  const SizedBox(height: AppDimensions.space24),
                  _buildCompressionLevelSelector(toolsProvider),
                ],

                // Size comparison
                if (_compressedSize != null) ...[
                  const SizedBox(height: AppDimensions.space24),
                  _buildSizeComparison(),
                ],

                // Compress button
                if (_selectedFilePath != null) ...[
                  const SizedBox(height: AppDimensions.space32),
                  CustomButton(
                    text: _compressedSize != null
                        ? 'Compress Again'
                        : 'Compress PDF',
                    icon: Icons.compress,
                    onPressed: () => _compressPDF(toolsProvider),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    FileUtils.getFilename(_selectedFilePath!),
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (_originalSize != null) ...[
                    const SizedBox(height: AppDimensions.space4),
                    Text(
                      'Size: ${FileUtils.formatFileSize(_originalSize!)}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                setState(() {
                  _selectedFilePath = null;
                  _originalSize = null;
                  _compressedSize = null;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompressionLevelSelector(ToolsProvider provider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Compression Level',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppDimensions.space16),
            ...CompressionLevel.values.map((level) {
              return RadioListTile<CompressionLevel>(
                title: Text(level.label),
                subtitle: Text(level.description),
                value: level,
                groupValue: provider.compressionLevel,
                onChanged: (value) {
                  if (value != null) {
                    provider.setCompressionLevel(value);
                  }
                },
                contentPadding: EdgeInsets.zero,
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSizeComparison() {
    final reduction =
        ((_originalSize! - _compressedSize!) / _originalSize! * 100).toInt();

    return Card(
      color: Colors.green.shade50,
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.space16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green.shade700),
                const SizedBox(width: AppDimensions.space8),
                Text(
                  'Compression Successful!',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.green.shade700,
                      ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.space16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSizeInfo(
                  'Original',
                  FileUtils.formatFileSize(_originalSize!),
                ),
                Icon(Icons.arrow_forward, color: Colors.green.shade700),
                _buildSizeInfo(
                  'Compressed',
                  FileUtils.formatFileSize(_compressedSize!),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.space12),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.space12,
                vertical: AppDimensions.space8,
              ),
              decoration: BoxDecoration(
                color: Colors.green.shade700,
                borderRadius: BorderRadius.circular(AppDimensions.radius8),
              ),
              child: Text(
                'Saved $reduction% (${FileUtils.formatFileSize(_originalSize! - _compressedSize!)})',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSizeInfo(String label, String size) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: AppDimensions.space4),
        Text(
          size,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  Future<void> _selectFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.single.path != null) {
        final filePath = result.files.single.path!;
        final fileSize = await FileUtils.getFileSize(filePath);

        setState(() {
          _selectedFilePath = filePath;
          _originalSize = fileSize;
          _compressedSize = null;
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

  Future<void> _compressPDF(ToolsProvider provider) async {
    if (_selectedFilePath == null) return;

    try {
      final outputPath = await provider.compressPDF(
        pdfPath: _selectedFilePath!,
      );

      if (outputPath != null) {
        final compressedSize = await FileUtils.getFileSize(outputPath);

        setState(() {
          _compressedSize = compressedSize;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('PDF compressed successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ErrorDialog.show(
          context,
          title: 'Compression Failed',
          message: e.toString(),
        );
      }
    }
  }
}
