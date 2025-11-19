import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../models/pdf_document.dart';
import '../../providers/editor_provider.dart';
import '../../constants/app_dimensions.dart';
import '../../widgets/common/loading_overlay.dart';
import '../../widgets/common/error_dialog.dart';
import 'dart:io';

/// PDF Editor Screen for editing and annotating PDFs
class PDFEditorScreen extends StatefulWidget {
  final PDFDocument document;

  const PDFEditorScreen({
    super.key,
    required this.document,
  });

  @override
  State<PDFEditorScreen> createState() => _PDFEditorScreenState();
}

class _PDFEditorScreenState extends State<PDFEditorScreen> {
  final PdfViewerController _pdfViewerController = PdfViewerController();
  late EditorProvider _editorProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _editorProvider = context.read<EditorProvider>();
      _editorProvider.loadDocument(widget.document);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EditorProvider>(
      builder: (context, editorProvider, child) {
        return WillPopScope(
          onWillPop: () => _handleBackPress(editorProvider),
          child: Scaffold(
            appBar: _buildAppBar(editorProvider),
            body: LoadingOverlay(
              isLoading: editorProvider.isLoading || editorProvider.isSaving,
              message: editorProvider.isSaving
                  ? 'Saving changes...'
                  : 'Loading document...',
              child: Column(
                children: [
                  // Mode selector
                  _buildModeSelector(editorProvider),

                  // PDF Viewer
                  Expanded(
                    child: Stack(
                      children: [
                        SfPdfViewer.file(
                          File(widget.document.filePath),
                          controller: _pdfViewerController,
                          onPageChanged: (PdfPageChangedDetails details) {
                            editorProvider.setCurrentPage(details.newPageNumber);
                          },
                        ),

                        // Annotation overlay
                        if (editorProvider.mode != EditorMode.view)
                          _buildAnnotationOverlay(editorProvider),
                      ],
                    ),
                  ),

                  // Bottom toolbar
                  _buildBottomToolbar(editorProvider),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(EditorProvider provider) {
    return AppBar(
      title: Text(widget.document.title),
      actions: [
        // Undo button
        IconButton(
          icon: const Icon(Icons.undo),
          onPressed: provider.hasUnsavedChanges ? () {} : null,
          tooltip: 'Undo',
        ),

        // Redo button
        IconButton(
          icon: const Icon(Icons.redo),
          onPressed: null, // TODO: Implement redo
          tooltip: 'Redo',
        ),

        // Save button
        if (provider.hasUnsavedChanges)
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () => _saveChanges(provider),
            tooltip: 'Save',
          ),

        // More options
        PopupMenuButton<String>(
          onSelected: (value) => _handleMenuAction(value, provider),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'add_page',
              child: Row(
                children: [
                  Icon(Icons.add),
                  SizedBox(width: AppDimensions.space8),
                  Text('Add Page'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete_page',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: AppDimensions.space8),
                  Text('Delete Page', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'rotate',
              child: Row(
                children: [
                  Icon(Icons.rotate_right),
                  SizedBox(width: AppDimensions.space8),
                  Text('Rotate Page'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildModeSelector(EditorProvider provider) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.space8,
        vertical: AppDimensions.space8,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildModeButton(
            provider,
            EditorMode.view,
            Icons.visibility,
            'View',
          ),
          _buildModeButton(
            provider,
            EditorMode.highlight,
            Icons.highlight,
            'Highlight',
            color: Colors.yellow,
          ),
          _buildModeButton(
            provider,
            EditorMode.note,
            Icons.note,
            'Note',
            color: Colors.orange,
          ),
          _buildModeButton(
            provider,
            EditorMode.draw,
            Icons.draw,
            'Draw',
            color: Colors.blue,
          ),
          _buildModeButton(
            provider,
            EditorMode.text,
            Icons.text_fields,
            'Text',
          ),
          _buildModeButton(
            provider,
            EditorMode.image,
            Icons.image,
            'Image',
          ),
          _buildModeButton(
            provider,
            EditorMode.signature,
            Icons.edit,
            'Sign',
            color: Colors.purple,
          ),
        ],
      ),
    );
  }

  Widget _buildModeButton(
    EditorProvider provider,
    EditorMode mode,
    IconData icon,
    String label, {
    Color? color,
  }) {
    final isSelected = provider.mode == mode;
    final buttonColor = color ?? Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.space4),
      child: InkWell(
        onTap: () => provider.setMode(mode),
        borderRadius: BorderRadius.circular(AppDimensions.radius8),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.space12,
            vertical: AppDimensions.space8,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? buttonColor.withOpacity(0.2)
                : Colors.transparent,
            border: Border.all(
              color: isSelected ? buttonColor : Colors.grey.shade300,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(AppDimensions.radius8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected ? buttonColor : Colors.grey,
                size: 20,
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: isSelected ? buttonColor : Colors.grey,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnnotationOverlay(EditorProvider provider) {
    return GestureDetector(
      onTapDown: (details) {
        // Handle annotation creation based on current mode
        _handleAnnotationTap(provider, details.localPosition);
      },
      child: Container(
        color: Colors.transparent,
      ),
    );
  }

  Widget _buildBottomToolbar(EditorProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.space16,
        vertical: AppDimensions.space12,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Previous page
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: provider.currentPage > 1
                ? () {
                    provider.previousPage();
                    _pdfViewerController.previousPage();
                  }
                : null,
          ),

          // Page indicator
          Text(
            'Page ${provider.currentPage} of ${provider.totalPages}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),

          // Next page
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: provider.currentPage < provider.totalPages
                ? () {
                    provider.nextPage();
                    _pdfViewerController.nextPage();
                  }
                : null,
          ),

          // Annotations count
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.space12,
              vertical: AppDimensions.space4,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(AppDimensions.radius8),
            ),
            child: Row(
              children: [
                const Icon(Icons.comment, size: 16),
                const SizedBox(width: AppDimensions.space4),
                Text(
                  '${provider.getAnnotationsForCurrentPage().length}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleAnnotationTap(EditorProvider provider, Offset position) {
    // TODO: Implement annotation creation based on mode
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Annotation mode: ${provider.mode.name}'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _handleMenuAction(String action, EditorProvider provider) {
    switch (action) {
      case 'add_page':
        _addPage(provider);
        break;
      case 'delete_page':
        _deletePage(provider);
        break;
      case 'rotate':
        _rotatePage(provider);
        break;
    }
  }

  void _addPage(EditorProvider provider) {
    // TODO: Implement add page
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Add page feature coming soon!')),
    );
  }

  void _deletePage(EditorProvider provider) {
    if (provider.totalPages <= 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cannot delete the only page')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Page'),
        content: Text(
          'Are you sure you want to delete page ${provider.currentPage}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                await provider.deleteCurrentPage();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Page deleted')),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ErrorDialog.show(
                    context,
                    title: 'Error',
                    message: 'Failed to delete page',
                  );
                }
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _rotatePage(EditorProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rotate Page'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Rotate 90° clockwise'),
              onTap: () {
                Navigator.of(context).pop();
                _performRotate(provider, 90);
              },
            ),
            ListTile(
              title: const Text('Rotate 180°'),
              onTap: () {
                Navigator.of(context).pop();
                _performRotate(provider, 180);
              },
            ),
            ListTile(
              title: const Text('Rotate 270° (90° counter-clockwise)'),
              onTap: () {
                Navigator.of(context).pop();
                _performRotate(provider, 270);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Future<void> _performRotate(EditorProvider provider, int degrees) async {
    try {
      await provider.rotatePage(degrees);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Page rotated')),
        );
      }
    } catch (e) {
      if (mounted) {
        ErrorDialog.show(
          context,
          title: 'Error',
          message: 'Failed to rotate page',
        );
      }
    }
  }

  Future<void> _saveChanges(EditorProvider provider) async {
    try {
      await provider.saveChanges();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Changes saved successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ErrorDialog.show(
          context,
          title: 'Error',
          message: 'Failed to save changes',
        );
      }
    }
  }

  Future<bool> _handleBackPress(EditorProvider provider) async {
    if (!provider.hasUnsavedChanges) {
      return true;
    }

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unsaved Changes'),
        content: const Text(
          'You have unsaved changes. Do you want to save before leaving?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Discard'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(null),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (result == null) return false; // Cancel
    if (result == true) {
      await _saveChanges(provider);
    }
    return true;
  }

  @override
  void dispose() {
    _pdfViewerController.dispose();
    super.dispose();
  }
}
