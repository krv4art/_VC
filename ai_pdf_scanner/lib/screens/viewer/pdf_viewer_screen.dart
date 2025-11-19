import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:go_router/go_router.dart';
import '../../models/pdf_document.dart';
import '../../constants/app_dimensions.dart';
import '../../widgets/common/loading_overlay.dart';
import 'dart:io';

/// PDF Viewer Screen for viewing PDF documents
class PDFViewerScreen extends StatefulWidget {
  final PDFDocument document;

  const PDFViewerScreen({
    super.key,
    required this.document,
  });

  @override
  State<PDFViewerScreen> createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends State<PDFViewerScreen> {
  final PdfViewerController _pdfViewerController = PdfViewerController();
  bool _isLoading = true;
  int _currentPage = 1;
  int _totalPages = 0;

  @override
  void initState() {
    super.initState();
    _totalPages = widget.document.pageCount;
    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.document.title),
        actions: [
          // Share button
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _sharePDF,
          ),

          // Edit button
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _editPDF,
          ),

          // More options
          PopupMenuButton<String>(
            onSelected: _handleMenuSelection,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'info',
                child: Row(
                  children: [
                    Icon(Icons.info_outline),
                    SizedBox(width: AppDimensions.space8),
                    Text('Document Info'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'print',
                child: Row(
                  children: [
                    Icon(Icons.print),
                    SizedBox(width: AppDimensions.space8),
                    Text('Print'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'favorite',
                child: Row(
                  children: [
                    Icon(Icons.star_outline),
                    SizedBox(width: AppDimensions.space8),
                    Text('Add to Favorites'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: LoadingOverlay(
        isLoading: _isLoading,
        message: 'Loading PDF...',
        child: Column(
          children: [
            // PDF Viewer
            Expanded(
              child: SfPdfViewer.file(
                File(widget.document.filePath),
                controller: _pdfViewerController,
                onPageChanged: (PdfPageChangedDetails details) {
                  setState(() {
                    _currentPage = details.newPageNumber;
                  });
                },
                onDocumentLoaded: (PdfDocumentLoadedDetails details) {
                  setState(() {
                    _totalPages = details.document.pages.count;
                  });
                },
              ),
            ),

            // Bottom toolbar
            _buildBottomToolbar(),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomToolbar() {
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
          // Previous page button
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: _currentPage > 1
                ? () {
                    _pdfViewerController.previousPage();
                  }
                : null,
          ),

          // Page indicator
          Text(
            'Page $_currentPage of $_totalPages',
            style: Theme.of(context).textTheme.bodyMedium,
          ),

          // Next page button
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: _currentPage < _totalPages
                ? () {
                    _pdfViewerController.nextPage();
                  }
                : null,
          ),

          // Zoom controls
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.zoom_out),
                onPressed: () {
                  _pdfViewerController.zoomLevel = (_pdfViewerController.zoomLevel - 0.25).clamp(0.5, 3.0);
                },
              ),
              IconButton(
                icon: const Icon(Icons.zoom_in),
                onPressed: () {
                  _pdfViewerController.zoomLevel = (_pdfViewerController.zoomLevel + 0.25).clamp(0.5, 3.0);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _sharePDF() {
    // TODO: Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Share functionality coming soon!')),
    );
  }

  void _editPDF() {
    // Navigate to PDF Editor
    context.push('/pdf-editor', extra: widget.document);
  }

  void _handleMenuSelection(String value) {
    switch (value) {
      case 'info':
        _showDocumentInfo();
        break;
      case 'print':
        _printPDF();
        break;
      case 'favorite':
        _toggleFavorite();
        break;
    }
  }

  void _showDocumentInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Document Info'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Title', widget.document.title),
            const SizedBox(height: AppDimensions.space8),
            _buildInfoRow('Pages', '${widget.document.pageCount}'),
            const SizedBox(height: AppDimensions.space8),
            _buildInfoRow('Size', _formatFileSize(widget.document.fileSize)),
            const SizedBox(height: AppDimensions.space8),
            _buildInfoRow('Type', widget.document.documentType),
            const SizedBox(height: AppDimensions.space8),
            _buildInfoRow(
              'Created',
              _formatDate(widget.document.createdAt),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            '$label:',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Text(value),
        ),
      ],
    );
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _printPDF() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Print functionality coming soon!')),
    );
  }

  void _toggleFavorite() {
    // TODO: Implement favorite toggle
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.document.isFavorite
              ? 'Removed from favorites'
              : 'Added to favorites',
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pdfViewerController.dispose();
    super.dispose();
  }
}
