import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../../constants/app_dimensions.dart';
import '../../providers/tools_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/loading_overlay.dart';
import '../../widgets/common/error_dialog.dart';
import '../../utils/file_utils.dart';

/// Merge Screen for combining multiple PDFs
class MergeScreen extends StatefulWidget {
  const MergeScreen({super.key});

  @override
  State<MergeScreen> createState() => _MergeScreenState();
}

class _MergeScreenState extends State<MergeScreen> {
  List<String> _selectedFiles = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Merge PDFs'),
        actions: [
          if (_selectedFiles.isNotEmpty)
            TextButton(
              onPressed: () {
                setState(() {
                  _selectedFiles.clear();
                });
              },
              child: const Text('Clear All'),
            ),
        ],
      ),
      body: Consumer<ToolsProvider>(
        builder: (context, toolsProvider, child) {
          return LoadingOverlay(
            isLoading: toolsProvider.isProcessing,
            message: toolsProvider.currentOperation,
            child: Column(
              children: [
                // Instructions
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppDimensions.space16),
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.merge,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: AppDimensions.space8),
                          Text(
                            'Merge Multiple PDFs',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.space8),
                      Text(
                        'Add PDF files and drag to reorder. They will be merged in the order shown.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),

                // File list
                Expanded(
                  child: _selectedFiles.isEmpty
                      ? _buildEmptyState()
                      : _buildFileList(),
                ),

                // Bottom buttons
                Padding(
                  padding: const EdgeInsets.all(AppDimensions.space16),
                  child: Column(
                    children: [
                      CustomButton(
                        text: 'Add PDF Files',
                        icon: Icons.add,
                        isOutlined: true,
                        onPressed: _addFiles,
                      ),
                      if (_selectedFiles.length >= 2) ...[
                        const SizedBox(height: AppDimensions.space12),
                        CustomButton(
                          text: 'Merge ${_selectedFiles.length} PDFs',
                          icon: Icons.merge,
                          onPressed: () => _mergePDFs(toolsProvider),
                          isLoading: toolsProvider.isProcessing,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.file_copy_outlined,
            size: 80,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
          ),
          const SizedBox(height: AppDimensions.space16),
          Text(
            'No PDF files added',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.6),
                ),
          ),
          const SizedBox(height: AppDimensions.space8),
          Text(
            'Add at least 2 PDF files to merge',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.5),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildFileList() {
    return ReorderableListView.builder(
      padding: const EdgeInsets.all(AppDimensions.space16),
      itemCount: _selectedFiles.length,
      onReorder: (oldIndex, newIndex) {
        setState(() {
          if (newIndex > oldIndex) {
            newIndex -= 1;
          }
          final item = _selectedFiles.removeAt(oldIndex);
          _selectedFiles.insert(newIndex, item);
        });
      },
      itemBuilder: (context, index) {
        final filePath = _selectedFiles[index];
        final fileName = FileUtils.getFilename(filePath);

        return Card(
          key: ValueKey(filePath),
          margin: const EdgeInsets.only(bottom: AppDimensions.space12),
          child: ListTile(
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.drag_handle,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(width: AppDimensions.space8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.space8,
                    vertical: AppDimensions.space4,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(AppDimensions.radius8),
                  ),
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            title: Text(
              fileName,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: FutureBuilder<int>(
              future: FileUtils.getFileSize(filePath),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(FileUtils.formatFileSize(snapshot.data!));
                }
                return const Text('...');
              },
            ),
            trailing: IconButton(
              icon: const Icon(Icons.close, color: Colors.red),
              onPressed: () {
                setState(() {
                  _selectedFiles.removeAt(index);
                });
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> _addFiles() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: true,
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          for (final file in result.files) {
            if (file.path != null && !_selectedFiles.contains(file.path)) {
              _selectedFiles.add(file.path!);
            }
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ErrorDialog.show(
          context,
          title: 'Error',
          message: 'Failed to select files',
        );
      }
    }
  }

  Future<void> _mergePDFs(ToolsProvider provider) async {
    if (_selectedFiles.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least 2 PDF files'),
        ),
      );
      return;
    }

    try {
      final outputPath = await provider.mergePDFs(
        pdfPaths: _selectedFiles,
      );

      if (outputPath != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('PDFs merged successfully!'),
            backgroundColor: Colors.green,
            action: SnackBarAction(
              label: 'View',
              textColor: Colors.white,
              onPressed: () {
                context.push('/viewer', extra: outputPath);
              },
            ),
          ),
        );

        setState(() {
          _selectedFiles.clear();
        });
      }
    } catch (e) {
      if (mounted) {
        ErrorDialog.show(
          context,
          title: 'Merge Failed',
          message: e.toString(),
        );
      }
    }
  }
}
