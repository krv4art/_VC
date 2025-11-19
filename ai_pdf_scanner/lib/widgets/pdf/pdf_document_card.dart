import 'package:flutter/material.dart';
import '../../constants/app_dimensions.dart';
import '../../models/pdf_document.dart';
import '../../utils/file_utils.dart';
import '../../utils/date_utils.dart' as date_utils;

/// Card widget for displaying PDF document in list
class PDFDocumentCard extends StatelessWidget {
  final PDFDocument document;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onDelete;
  final VoidCallback? onShare;
  final bool showActions;

  const PDFDocumentCard({
    super.key,
    required this.document,
    this.onTap,
    this.onLongPress,
    this.onDelete,
    this.onShare,
    this.showActions = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimensions.space16,
        vertical: AppDimensions.space8,
      ),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(AppDimensions.radius12),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.space12),
          child: Row(
            children: [
              // Thumbnail
              _buildThumbnail(context),
              const SizedBox(width: AppDimensions.space12),

              // Document info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      document.title,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppDimensions.space4),
                    Text(
                      '${document.pageCount} ${document.pageCount == 1 ? 'page' : 'pages'} • ${FileUtils.formatFileSize(document.fileSize)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.color
                                ?.withOpacity(0.6),
                          ),
                    ),
                    const SizedBox(height: AppDimensions.space2),
                    Text(
                      date_utils.DateUtils.formatRelativeTime(document.createdAt),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.color
                                ?.withOpacity(0.5),
                          ),
                    ),
                  ],
                ),
              ),

              // Actions
              if (showActions)
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (value) {
                    switch (value) {
                      case 'share':
                        onShare?.call();
                        break;
                      case 'delete':
                        onDelete?.call();
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'share',
                      child: Row(
                        children: [
                          Icon(Icons.share),
                          SizedBox(width: AppDimensions.space8),
                          Text('Share'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red),
                          SizedBox(width: AppDimensions.space8),
                          Text('Delete', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnail(BuildContext context) {
    if (document.thumbnailPath != null) {
      // TODO: Load actual thumbnail
      return Container(
        width: 60,
        height: 80,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppDimensions.radius8),
        ),
        child: const Icon(Icons.picture_as_pdf, size: 32),
      );
    }

    return Container(
      width: 60,
      height: 80,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppDimensions.radius8),
      ),
      child: Icon(
        Icons.picture_as_pdf,
        size: 32,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
