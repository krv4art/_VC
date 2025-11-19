import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/generated_photo.dart';
import '../services/social_sharing_service.dart';
import '../services/gallery_saver_service.dart';
import '../services/favorites_service.dart';
import '../widgets/before_after_slider.dart';

/// Enhanced photo viewer with share, save, edit, favorite features
class EnhancedPhotoViewerScreen extends StatefulWidget {
  final GeneratedPhoto photo;
  final bool showBeforeAfter;

  const EnhancedPhotoViewerScreen({
    Key? key,
    required this.photo,
    this.showBeforeAfter = true,
  }) : super(key: key);

  @override
  State<EnhancedPhotoViewerScreen> createState() => _EnhancedPhotoViewerScreenState();
}

class _EnhancedPhotoViewerScreenState extends State<EnhancedPhotoViewerScreen> {
  final _sharingService = SocialSharingService();
  final _gallerySaverService = GallerySaverService();
  late FavoritesService _favoritesService;

  bool _isFavorite = false;
  bool _isLoading = false;
  bool _showBeforeAfter = false;

  @override
  void initState() {
    super.initState();
    _initializeFavorites();
    _showBeforeAfter = widget.showBeforeAfter && widget.photo.originalPath != null;
  }

  Future<void> _initializeFavorites() async {
    // Initialize favorites service from database
    // final db = await DatabaseService.instance.database;
    // _favoritesService = FavoritesService(db);
    // final isFav = await _favoritesService.isInFavorites(widget.photo.id!);
    // setState(() => _isFavorite = isFav);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? Colors.red : Colors.white,
            ),
            onPressed: _toggleFavorite,
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: _showOptionsMenu,
          ),
        ],
      ),
      body: Stack(
        children: [
          // Photo viewer
          Center(
            child: _showBeforeAfter && widget.photo.originalPath != null
                ? BeforeAfterSlider(
                    beforeImagePath: widget.photo.originalPath!,
                    afterImagePath: widget.photo.generatedPath!,
                  )
                : InteractiveViewer(
                    minScale: 0.5,
                    maxScale: 4.0,
                    child: Image.file(
                      File(widget.photo.generatedPath!),
                      fit: BoxFit.contain,
                    ),
                  ),
          ),

          // Bottom action bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionButton(
                    icon: Icons.compare,
                    label: 'Compare',
                    onPressed: widget.photo.originalPath != null
                        ? () {
                            setState(() => _showBeforeAfter = !_showBeforeAfter);
                          }
                        : null,
                  ),
                  _buildActionButton(
                    icon: Icons.edit,
                    label: 'Edit',
                    onPressed: _navigateToEdit,
                  ),
                  _buildActionButton(
                    icon: Icons.share,
                    label: 'Share',
                    onPressed: _sharePhoto,
                  ),
                  _buildActionButton(
                    icon: Icons.save_alt,
                    label: 'Save',
                    onPressed: _saveToGallery,
                  ),
                ],
              ),
            ),
          ),

          // Loading indicator
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(icon, color: Colors.white),
          iconSize: 28,
          onPressed: onPressed,
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Future<void> _toggleFavorite() async {
    try {
      // final success = await _favoritesService.toggleFavorite(widget.photo.id!);
      // if (success) {
      //   setState(() => _isFavorite = !_isFavorite);
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       content: Text(_isFavorite ? 'Added to favorites' : 'Removed from favorites'),
      //       duration: const Duration(seconds: 1),
      //     ),
      //   );
      // }
    } catch (e) {
      debugPrint('Error toggling favorite: $e');
    }
  }

  Future<void> _sharePhoto() async {
    setState(() => _isLoading = true);

    try {
      final success = await _sharingService.sharePhoto(
        photoPath: widget.photo.generatedPath!,
        sharePositionOrigin: _sharingService.getSharePositionOrigin(context),
      );

      if (!success) {
        _showErrorSnackBar('Failed to share photo');
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveToGallery() async {
    setState(() => _isLoading = true);

    try {
      final success = await _gallerySaverService.saveToGallery(
        filePath: widget.photo.generatedPath!,
      );

      if (success) {
        _showSuccessSnackBar('Photo saved to gallery');
      } else {
        _showErrorSnackBar('Failed to save photo');
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _navigateToEdit() {
    // Navigate to photo editing screen
    // Navigator.pushNamed(
    //   context,
    //   '/photo-editor',
    //   arguments: widget.photo,
    // );
    _showInfoSnackBar('Photo editing coming soon!');
  }

  void _showOptionsMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.image, color: Colors.white),
              title: const Text('Set as wallpaper', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                _showInfoSnackBar('Feature coming soon!');
              },
            ),
            ListTile(
              leading: const Icon(Icons.cloud_upload, color: Colors.white),
              title: const Text('Backup to cloud', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                _backupToCloud();
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete photo', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _confirmDelete();
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<void> _backupToCloud() async {
    _showInfoSnackBar('Backing up to cloud...');
    // Implement cloud backup
  }

  Future<void> _confirmDelete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Photo'),
        content: const Text('Are you sure you want to delete this photo?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      // Delete photo logic
      Navigator.pop(context);
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showInfoSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
