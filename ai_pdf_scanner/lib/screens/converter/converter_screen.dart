import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import '../../constants/app_dimensions.dart';
import '../../providers/converter_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/loading_overlay.dart';
import '../../widgets/common/error_dialog.dart';
import 'dart:io';

/// Converter Screen for file conversions
class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key});

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  final ImagePicker _imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Convert'),
      ),
      body: Consumer<ConverterProvider>(
        builder: (context, converterProvider, child) {
          return LoadingOverlay(
            isLoading: converterProvider.isConverting,
            message: converterProvider.currentOperation,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimensions.space16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Title
                  Text(
                    'Convert Files',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: AppDimensions.space8),
                  Text(
                    'Choose a conversion type below',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.color
                              ?.withOpacity(0.6),
                        ),
                  ),
                  const SizedBox(height: AppDimensions.space32),

                  // Images to PDF Card
                  _buildConversionCard(
                    context,
                    title: 'Images to PDF',
                    subtitle: 'Convert JPG, PNG images to PDF',
                    icon: Icons.photo_library,
                    color: Colors.blue,
                    onTap: () => _handleImagesToPDF(converterProvider),
                  ),
                  const SizedBox(height: AppDimensions.space16),

                  // PDF to Images Card
                  _buildConversionCard(
                    context,
                    title: 'PDF to Images',
                    subtitle: 'Extract pages as JPG images',
                    icon: Icons.image,
                    color: Colors.green,
                    onTap: () => _handlePDFToImages(converterProvider),
                  ),
                  const SizedBox(height: AppDimensions.space16),

                  // Office to PDF Card
                  _buildConversionCard(
                    context,
                    title: 'Office to PDF',
                    subtitle: 'Convert Word, Excel, PowerPoint to PDF',
                    icon: Icons.description,
                    color: Colors.orange,
                    onTap: () => _handleOfficeToPDF(converterProvider),
                  ),

                  // Selected files display
                  if (converterProvider.inputFiles.isNotEmpty) ...[
                    const SizedBox(height: AppDimensions.space32),
                    _buildSelectedFiles(converterProvider),
                  ],

                  // Conversion settings
                  if (converterProvider.inputFiles.isNotEmpty) ...[
                    const SizedBox(height: AppDimensions.space24),
                    _buildConversionSettings(converterProvider),
                  ],

                  // Convert button
                  if (converterProvider.inputFiles.isNotEmpty) ...[
                    const SizedBox(height: AppDimensions.space24),
                    CustomButton(
                      text: 'Convert to PDF',
                      icon: Icons.transform,
                      onPressed: () => _performConversion(converterProvider),
                      isLoading: converterProvider.isConverting,
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildConversionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radius12),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.space16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppDimensions.space16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radius12),
                ),
                child: Icon(icon, size: 32, color: color),
              ),
              const SizedBox(width: AppDimensions.space16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppDimensions.space4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.color
                                ?.withOpacity(0.6),
                          ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedFiles(ConverterProvider provider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Selected Files (${provider.inputFiles.length})',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                TextButton(
                  onPressed: () => provider.clearInputFiles(),
                  child: const Text('Clear all'),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.space12),
            ...provider.inputFiles.map((filePath) {
              final fileName = filePath.split('/').last;
              return ListTile(
                leading: const Icon(Icons.insert_drive_file),
                title: Text(fileName),
                trailing: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => provider.removeInputFile(filePath),
                ),
                contentPadding: EdgeInsets.zero,
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildConversionSettings(ConverterProvider provider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Settings',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppDimensions.space16),

            // Quality setting
            DropdownButtonFormField<ConversionQuality>(
              value: provider.quality,
              decoration: const InputDecoration(
                labelText: 'Quality',
                border: OutlineInputBorder(),
              ),
              items: ConversionQuality.values.map((quality) {
                return DropdownMenuItem(
                  value: quality,
                  child: Text(quality.label),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  provider.setQuality(value);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleImagesToPDF(ConverterProvider provider) async {
    try {
      final List<XFile> images = await _imagePicker.pickMultiImage();
      if (images.isNotEmpty) {
        provider.clearInputFiles();
        provider.addInputFiles(images.map((img) => img.path).toList());
      }
    } catch (e) {
      if (mounted) {
        ErrorDialog.show(
          context,
          title: 'Error',
          message: 'Failed to select images',
        );
      }
    }
  }

  Future<void> _handlePDFToImages(ConverterProvider provider) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.single.path != null) {
        provider.clearInputFiles();
        provider.addInputFile(result.files.single.path!);

        // Show conversion dialog
        if (mounted) {
          _showPDFToImagesDialog(provider, result.files.single.path!);
        }
      }
    } catch (e) {
      if (mounted) {
        ErrorDialog.show(
          context,
          title: 'Error',
          message: 'Failed to select PDF file',
        );
      }
    }
  }

  Future<void> _handleOfficeToPDF(ConverterProvider provider) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx'],
      );

      if (result != null && result.files.single.path != null) {
        provider.clearInputFiles();
        provider.addInputFile(result.files.single.path!);
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

  void _showPDFToImagesDialog(ConverterProvider provider, String pdfPath) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Convert PDF to Images'),
        content: const Text(
          'This feature is not yet implemented. Coming soon!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _performConversion(ConverterProvider provider) async {
    try {
      final outputPath = await provider.imagesToPDF();

      if (mounted && outputPath != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('PDF created successfully!'),
            action: SnackBarAction(
              label: 'View',
              onPressed: () {
                context.push('/library');
              },
            ),
          ),
        );

        provider.clearInputFiles();
      }
    } catch (e) {
      if (mounted) {
        ErrorDialog.show(
          context,
          title: 'Conversion Failed',
          message: e.toString(),
        );
      }
    }
  }
}
