import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../../constants/app_dimensions.dart';
import '../../providers/tools_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/loading_overlay.dart';
import '../../widgets/common/error_dialog.dart';
import '../../utils/file_utils.dart';

/// Split Screen for separating PDF pages
class SplitScreen extends StatefulWidget {
  const SplitScreen({super.key});

  @override
  State<SplitScreen> createState() => _SplitScreenState();
}

class _SplitScreenState extends State<SplitScreen> {
  String? _selectedFilePath;
  int _totalPages = 0;
  SplitMode _splitMode = SplitMode.allPages;
  final TextEditingController _pagesPerFileController = TextEditingController(text: '1');
  final Set<int> _selectedPages = {};

  @override
  void dispose() {
    _pagesPerFileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Split PDF'),
      ),
      body: Consumer<ToolsProvider>(
        builder: (context, toolsProvider, child) {
          return LoadingOverlay(
            isLoading: toolsProvider.isProcessing,
            message: toolsProvider.currentOperation,
            child: ListView(
              padding: const EdgeInsets.all(AppDimensions.space16),
              children: [
                // File selection
                if (_selectedFilePath == null)
                  CustomButton(
                    text: 'Select PDF File',
                    icon: Icons.file_upload,
                    onPressed: _selectFile,
                  )
                else
                  _buildSelectedFile(),

                // Split mode selection
                if (_selectedFilePath != null) ...[
                  const SizedBox(height: AppDimensions.space24),
                  _buildSplitModeSelector(),
                ],

                // Mode-specific options
                if (_selectedFilePath != null) ...[
                  const SizedBox(height: AppDimensions.space16),
                  _buildModeOptions(),
                ],

                // Split button
                if (_selectedFilePath != null) ...[
                  const SizedBox(height: AppDimensions.space32),
                  CustomButton(
                    text: 'Split PDF',
                    icon: Icons.call_split,
                    onPressed: () => _splitPDF(toolsProvider),
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

  Widget _buildSplitModeSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Split Mode',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppDimensions.space16),
            RadioListTile<SplitMode>(
              title: const Text('All Pages'),
              subtitle: const Text('Extract each page as separate PDF'),
              value: SplitMode.allPages,
              groupValue: _splitMode,
              onChanged: (value) {
                setState(() {
                  _splitMode = value!;
                  _selectedPages.clear();
                });
              },
              contentPadding: EdgeInsets.zero,
            ),
            RadioListTile<SplitMode>(
              title: const Text('Every N Pages'),
              subtitle: const Text('Split into groups of pages'),
              value: SplitMode.everyNPages,
              groupValue: _splitMode,
              onChanged: (value) {
                setState(() {
                  _splitMode = value!;
                  _selectedPages.clear();
                });
              },
              contentPadding: EdgeInsets.zero,
            ),
            RadioListTile<SplitMode>(
              title: const Text('Custom Pages'),
              subtitle: const Text('Select specific pages to extract'),
              value: SplitMode.customPages,
              groupValue: _splitMode,
              onChanged: (value) {
                setState(() {
                  _splitMode = value!;
                });
              },
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeOptions() {
    switch (_splitMode) {
      case SplitMode.allPages:
        return Card(
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
                    'This will create ${_totalPages > 0 ? _totalPages : 'N'} separate PDF ${_totalPages == 1 ? 'file' : 'files'}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        );

      case SplitMode.everyNPages:
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.space16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pages per File',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: AppDimensions.space12),
                TextField(
                  controller: _pagesPerFileController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Enter number of pages',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.numbers),
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                if (_totalPages > 0 && _pagesPerFileController.text.isNotEmpty) ...[
                  const SizedBox(height: AppDimensions.space12),
                  Text(
                    'This will create approximately ${(_totalPages / (int.tryParse(_pagesPerFileController.text) ?? 1)).ceil()} files',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ],
            ),
          ),
        );

      case SplitMode.customPages:
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
          // TODO: Get actual page count from PDF
          _totalPages = 10; // Placeholder
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

  Future<void> _splitPDF(ToolsProvider provider) async {
    if (_selectedFilePath == null) return;

    // Validate based on mode
    if (_splitMode == SplitMode.everyNPages) {
      final pagesPerFile = int.tryParse(_pagesPerFileController.text);
      if (pagesPerFile == null || pagesPerFile < 1) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid number of pages')),
        );
        return;
      }
    } else if (_splitMode == SplitMode.customPages) {
      if (_selectedPages.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select at least one page')),
        );
        return;
      }
    }

    try {
      List<String>? outputPaths;

      switch (_splitMode) {
        case SplitMode.allPages:
          outputPaths = await provider.splitPDFPages(
            pdfPath: _selectedFilePath!,
          );
          break;

        case SplitMode.everyNPages:
          // TODO: Implement split by page count
          break;

        case SplitMode.customPages:
          final outputPath = await provider.extractPages(
            pdfPath: _selectedFilePath!,
            pageNumbers: _selectedPages.toList(),
          );
          if (outputPath != null) {
            outputPaths = [outputPath];
          }
          break;
      }

      if (outputPaths != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Created ${outputPaths.length} ${outputPaths.length == 1 ? 'file' : 'files'}',
            ),
            backgroundColor: Colors.green,
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
          title: 'Split Failed',
          message: e.toString(),
        );
      }
    }
  }
}

enum SplitMode {
  allPages,
  everyNPages,
  customPages,
}
