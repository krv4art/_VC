import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/photo_generation_provider.dart';
import '../models/generated_photo.dart';
import '../models/style_model.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import 'dart:io';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  StyleCategory? _filterCategory;
  String _sortBy = 'newest';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = context.watch<PhotoGenerationProvider>();

    var photos = provider.generatedPhotos;

    // Apply filters
    if (_filterCategory != null) {
      photos = photos.where((photo) {
        // TODO: Filter by category when we have style data
        return true;
      }).toList();
    }

    // Apply sorting
    if (_sortBy == 'oldest') {
      photos = photos.reversed.toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.gallery),
        actions: [
          _buildFilterButton(context, l10n),
          _buildSortButton(context, l10n),
        ],
      ),
      body: photos.isEmpty
          ? _buildEmptyState(context, l10n)
          : _buildPhotoGrid(context, photos, l10n),
    );
  }

  Widget _buildFilterButton(BuildContext context, AppLocalizations l10n) {
    return PopupMenuButton<StyleCategory?>(
      icon: const Icon(Icons.filter_list),
      onSelected: (category) {
        setState(() {
          _filterCategory = category;
        });
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: null,
          child: Text(l10n.allStyles),
        ),
        PopupMenuItem(
          value: StyleCategory.professional,
          child: Text(l10n.categoryProfessional),
        ),
        PopupMenuItem(
          value: StyleCategory.casual,
          child: Text(l10n.categoryCasual),
        ),
        PopupMenuItem(
          value: StyleCategory.creative,
          child: Text(l10n.categoryCreative),
        ),
        PopupMenuItem(
          value: StyleCategory.formal,
          child: Text(l10n.categoryFormal),
        ),
        PopupMenuItem(
          value: StyleCategory.outdoor,
          child: Text(l10n.categoryOutdoor),
        ),
        PopupMenuItem(
          value: StyleCategory.studio,
          child: Text(l10n.categoryStudio),
        ),
      ],
    );
  }

  Widget _buildSortButton(BuildContext context, AppLocalizations l10n) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.sort),
      onSelected: (sortBy) {
        setState(() {
          _sortBy = sortBy;
        });
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'newest',
          child: Text(l10n.sortNewest),
        ),
        PopupMenuItem(
          value: 'oldest',
          child: Text(l10n.sortOldest),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.photo_library_outlined,
            size: 80,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
          ),
          const SizedBox(height: AppTheme.space24),
          Text(
            'No photos yet',
            style: AppTheme.h3.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: AppTheme.space8),
          Text(
            'Generate your first professional headshot',
            style: AppTheme.body.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: AppTheme.space32),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.add_a_photo),
            label: Text(l10n.takePhoto),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoGrid(
    BuildContext context,
    List<GeneratedPhoto> photos,
    AppLocalizations l10n,
  ) {
    return GridView.builder(
      padding: const EdgeInsets.all(AppTheme.space16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppTheme.space12,
        mainAxisSpacing: AppTheme.space12,
        childAspectRatio: 0.75,
      ),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        return _buildPhotoCard(context, photos[index], l10n);
      },
    );
  }

  Widget _buildPhotoCard(
    BuildContext context,
    GeneratedPhoto photo,
    AppLocalizations l10n,
  ) {
    return GestureDetector(
      onTap: () => _showPhotoDetail(context, photo, l10n),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Photo
            if (photo.generatedPath != null)
              Image.file(
                File(photo.generatedPath!),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildPlaceholder();
                },
              )
            else
              _buildPlaceholder(),

            // Status badge
            if (photo.status != GenerationStatus.completed)
              Positioned(
                top: AppTheme.space8,
                right: AppTheme.space8,
                child: _buildStatusBadge(photo.status),
              ),

            // Gradient overlay at bottom
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(AppTheme.space8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Text(
                  photo.metadata['style_name'] ?? 'Unknown',
                  style: AppTheme.bodySmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: const Center(
        child: Icon(Icons.photo, size: 48, color: Colors.grey),
      ),
    );
  }

  Widget _buildStatusBadge(GenerationStatus status) {
    IconData icon;
    Color color;

    switch (status) {
      case GenerationStatus.pending:
        icon = Icons.pending;
        color = Colors.orange;
        break;
      case GenerationStatus.processing:
        icon = Icons.autorenew;
        color = Colors.blue;
        break;
      case GenerationStatus.failed:
        icon = Icons.error;
        color = Colors.red;
        break;
      default:
        icon = Icons.check_circle;
        color = Colors.green;
    }

    return Container(
      padding: const EdgeInsets.all(AppTheme.space4),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 16),
    );
  }

  void _showPhotoDetail(
    BuildContext context,
    GeneratedPhoto photo,
    AppLocalizations l10n,
  ) {
    showDialog(
      context: context,
      builder: (context) => _PhotoDetailDialog(photo: photo, l10n: l10n),
    );
  }
}

class _PhotoDetailDialog extends StatelessWidget {
  final GeneratedPhoto photo;
  final AppLocalizations l10n;

  const _PhotoDetailDialog({
    required this.photo,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Photo
          if (photo.generatedPath != null)
            AspectRatio(
              aspectRatio: 1.0,
              child: Image.file(
                File(photo.generatedPath!),
                fit: BoxFit.cover,
              ),
            ),

          // Actions
          Padding(
            padding: const EdgeInsets.all(AppTheme.space16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  photo.metadata['style_name'] ?? 'Unknown Style',
                  style: AppTheme.h4,
                ),
                const SizedBox(height: AppTheme.space8),
                Text(
                  _formatDate(photo.createdAt),
                  style: AppTheme.bodySmall,
                ),
                const SizedBox(height: AppTheme.space16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        // TODO: Implement share
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.share),
                      label: Text(l10n.sharePhoto),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        // TODO: Implement download
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.download),
                      label: Text(l10n.downloadHD),
                    ),
                    TextButton.icon(
                      onPressed: () => _confirmDelete(context),
                      icon: const Icon(Icons.delete, color: Colors.red),
                      label: Text(
                        l10n.deletePhoto,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.deletePhoto),
        content: Text(l10n.deleteConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              if (photo.id != null) {
                context.read<PhotoGenerationProvider>().deletePhoto(photo.id!);
              }
              Navigator.pop(dialogContext); // Close confirm dialog
              Navigator.pop(context); // Close detail dialog
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.photoDeleted)),
              );
            },
            child: Text(
              l10n.deletePhoto,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
