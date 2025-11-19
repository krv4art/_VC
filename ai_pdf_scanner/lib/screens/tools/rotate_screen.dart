import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:path/path.dart' as path;
import '../../constants/app_dimensions.dart';
import '../../providers/tools_provider.dart';
import '../../services/pdf/pdf_editor_service.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/loading_overlay.dart';
import '../../widgets/common/error_dialog.dart';
import '../../utils/file_utils.dart';

/// Rotate Screen for rotating PDF pages
class RotateScreen extends StatefulWidget {
  const RotateScreen({super.key});

  @override
  State<RotateScreen> createState() => _RotateScreenState();
}

class _RotateScreenState extends State<RotateScreen> {
  String? _selectedFilePath;
  int _rotationAngle = 90;
  RotateMode _rotateMode = RotateMode.allPages;
  final Set<int> _selectedPages = {};
  int _totalPages = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rotate PDF'),
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
                          Icons.info_outline,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: AppDimensions.space12),
                        Expanded(
                          child: Text(
                            'Rotate pages in your PDF document clockwise or counter-clockwise.',
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

                // Rotation angle selector
                if (_selectedFilePath != null) ...[
                  const SizedBox(height: AppDimensions.space24),
                  _buildRotationSelector(),
                ],

                // Rotate mode selector
                if (_selectedFilePath != null) ...[
                  const SizedBox(height: AppDimensions.space16),
                  _buildRotateModeSelector(),
                ],

                // Page selector for custom mode
                if (_selectedFilePath != null && _rotateMode == RotateMode.customPages) ...[
                  const SizedBox(height: AppDimensions.space16),
                  _buildPageSelector(),
                ],

                // Rotate button
                if (_selectedFilePath != null) ...[
                  const SizedBox(height: AppDimensions.space32),
                  CustomButton(
                    text: 'Rotate PDF',
                    icon: Icons.rotate_right,
                    onPressed: () => _rotatePDF(toolsProvider),
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
                  if (_totalPages > 0) ...[
                    const SizedBox(height: AppDimensions.space4),
                    Text(
                      '$_totalPages ${_totalPages == 1 ? 'page' : 'pages'}',
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
                  _totalPages = 0;
                  _selectedPages.clear();
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRotationSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rotation Angle',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppDimensions.space16),
            Row(
              children: [
                Expanded(
                  child: _buildAngleOption(90, '90°\nClockwise', Icons.rotate_90_degrees_cw),
                ),
                const SizedBox(width: AppDimensions.space12),
                Expanded(
                  child: _buildAngleOption(180, '180°', Icons.rotate_right),
                ),
                const SizedBox(width: AppDimensions.space12),
                Expanded(
                  child: _buildAngleOption(270, '270°\nCounter-CW', Icons.rotate_90_degrees_ccw),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAngleOption(int angle, String label, IconData icon) {
    final isSelected = _rotationAngle == angle;

    return InkWell(
      onTap: () {
        setState(() {
          _rotationAngle = angle;
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
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
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

  Widget _buildRotateModeSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Apply To',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            RadioListTile<RotateMode>(
              title: const Text('All Pages'),
              value: RotateMode.allPages,
              groupValue: _rotateMode,
              onChanged: (value) {
                setState(() {
                  _rotateMode = value!;
                  _selectedPages.clear();
                });
              },
              contentPadding: EdgeInsets.zero,
            ),
            RadioListTile<RotateMode>(
              title: const Text('Even Pages Only'),
              value: RotateMode.evenPages,
              groupValue: _rotateMode,
              onChanged: (value) {
                setState(() {
                  _rotateMode = value!;
                  _selectedPages.clear();
                });
              },
              contentPadding: EdgeInsets.zero,
            ),
            RadioListTile<RotateMode>(
              title: const Text('Odd Pages Only'),
              value: RotateMode.oddPages,
              groupValue: _rotateMode,
              onChanged: (value) {
                setState(() {
                  _rotateMode = value!;
                  _selectedPages.clear();
                });
              },
              contentPadding: EdgeInsets.zero,
            ),
            RadioListTile<RotateMode>(
              title: const Text('Custom Pages'),
              value: RotateMode.customPages,
              groupValue: _rotateMode,
              onChanged: (value) {
                setState(() {
                  _rotateMode = value!;
                });
              },
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Pages',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: AppDimensions.space12),
            if (_totalPages > 0)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(_totalPages, (index) {
                  final pageNum = index + 1;
                  final isSelected = _selectedPages.contains(pageNum);

                  return FilterChip(
                    label: Text('$pageNum'),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedPages.add(pageNum);
                        } else {
                          _selectedPages.remove(pageNum);
                        }
                      });
                    },
                  );
                }),
              ),
            if (_selectedPages.isNotEmpty) ...[
              const SizedBox(height: AppDimensions.space12),
              Text(
                '${_selectedPages.length} ${_selectedPages.length == 1 ? 'page' : 'pages'} selected',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
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

        // Get actual page count
        final pageCount = await _getPageCount(filePath);

        setState(() {
          _selectedFilePath = filePath;
          _totalPages = pageCount;
          _selectedPages.clear();
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

  Future<void> _rotatePDF(ToolsProvider provider) async {
    if (_selectedFilePath == null) return;

    // Validate custom mode
    if (_rotateMode == RotateMode.customPages && _selectedPages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one page')),
      );
      return;
    }

    try {
      // Determine which pages to rotate
      final List<int> pagesToRotate = _getPageNumbersToRotate();

      if (pagesToRotate.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No pages selected for rotation')),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Rotating ${pagesToRotate.length} pages by $_rotationAngle°...'),
        ),
      );

      // Perform actual rotation using PDF Editor Service
      final editorService = PdfEditorService();
      final outputPath = await editorService.rotatePages(
        _selectedFilePath!,
        pageNumbers: pagesToRotate,
        degrees: _rotationAngle,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('PDF rotated successfully!\nSaved to: ${path.basename(outputPath)}'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 4),
          ),
        );

        setState(() {
          _selectedFilePath = null;
          _totalPages = 0;
          _selectedPages.clear();
        });
      }
    } catch (e) {
      if (mounted) {
        ErrorDialog.show(
          context,
          title: 'Rotation Failed',
          message: e.toString(),
        );
      }
    }
  }

  /// Get actual page count from PDF
  Future<int> _getPageCount(String pdfPath) async {
    try {
      final bytes = await File(pdfPath).readAsBytes();
      final PdfDocument document = PdfDocument(inputBytes: bytes);
      final pageCount = document.pages.count;
      document.dispose();
      return pageCount;
    } catch (e) {
      return 10; // Fallback to default
    }
  }

  /// Get list of page numbers to rotate based on mode
  List<int> _getPageNumbersToRotate() {
    switch (_rotateMode) {
      case RotateMode.allPages:
        return List.generate(_totalPages, (index) => index + 1);

      case RotateMode.evenPages:
        return List.generate(
          _totalPages ~/ 2,
          (index) => (index + 1) * 2,
        );

      case RotateMode.oddPages:
        return List.generate(
          (_totalPages + 1) ~/ 2,
          (index) => index * 2 + 1,
        );

      case RotateMode.customPages:
        return _selectedPages.toList()..sort();
    }
  }
}

enum RotateMode {
  allPages,
  evenPages,
  oddPages,
  customPages,
}
