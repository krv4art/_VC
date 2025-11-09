import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../services/image_picker_service.dart';
import '../services/plant_identification_service.dart';
import '../services/rating_service.dart';
import '../providers/user_preferences_provider.dart';
import '../providers/plant_history_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/dialogs/rating_request_dialog.dart';
import 'plant_result_screen.dart';

/// Scan screen - Camera/image picker for plant identification
class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final ImagePickerService _imagePickerService = ImagePickerService();
  final RatingService _ratingService = RatingService();
  File? _selectedImage;
  bool _isProcessing = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.scanTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: _isProcessing
          ? _buildProcessingView(l10n)
          : _selectedImage == null
              ? _buildInitialView(l10n, colors)
              : _buildImagePreview(l10n, colors),
    );
  }

  Widget _buildInitialView(AppLocalizations l10n, ColorScheme colors) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.space24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.camera_alt,
              size: 100,
              color: colors.primary,
            ),
            const SizedBox(height: AppTheme.space24),
            Text(
              l10n.scanTitle,
              style: AppTheme.h2.copyWith(
                fontWeight: FontWeight.bold,
                color: colors.onSurface,
              ),
            ),
            const SizedBox(height: AppTheme.space16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                l10n.scanDescription,
                textAlign: TextAlign.center,
                style: AppTheme.body.copyWith(color: colors.onSurface),
              ),
            ),
            const SizedBox(height: AppTheme.space48),
            if (_errorMessage != null) ...[
              Container(
                padding: const EdgeInsets.all(AppTheme.space16),
                margin: const EdgeInsets.only(bottom: AppTheme.space24),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(AppTheme.radiusCard),
                  border: Border.all(color: Colors.red[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red[700]),
                    const SizedBox(width: AppTheme.space12),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: AppTheme.body.copyWith(color: Colors.red[700]),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _pickFromCamera,
                icon: const Icon(Icons.camera, size: 24),
                label: Text(l10n.takePhoto),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppTheme.space20,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusCard),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppTheme.space16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _pickFromGallery,
                icon: const Icon(Icons.photo_library, size: 24),
                label: Text(l10n.chooseFromGallery),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppTheme.space20,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusCard),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview(AppLocalizations l10n, ColorScheme colors) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppTheme.space16),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppTheme.radiusCard),
                  child: Image.file(
                    _selectedImage!,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: AppTheme.space24),
                Text(
                  'Image selected. Ready to identify!',
                  style: AppTheme.h4.copyWith(color: colors.onSurface),
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(AppTheme.space16),
          decoration: BoxDecoration(
            color: colors.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _selectedImage = null;
                        _errorMessage = null;
                      });
                    },
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: AppTheme.space16),
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: _identifyPlant,
                    icon: const Icon(Icons.search),
                    label: Text(l10n.identifyPlant),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProcessingView(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: AppTheme.space24),
          Text(
            'Analyzing plant...',
            style: AppTheme.h4,
          ),
          const SizedBox(height: AppTheme.space12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              'This may take a few seconds',
              textAlign: TextAlign.center,
              style: AppTheme.body.copyWith(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickFromCamera() async {
    setState(() {
      _errorMessage = null;
    });

    final image = await _imagePickerService.pickFromCamera();
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  Future<void> _pickFromGallery() async {
    setState(() {
      _errorMessage = null;
    });

    final image = await _imagePickerService.pickFromGallery();
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  Future<void> _identifyPlant() async {
    if (_selectedImage == null) return;

    setState(() {
      _isProcessing = true;
      _errorMessage = null;
    });

    try {
      final identificationService = context.read<PlantIdentificationService>();
      final preferencesProvider = context.read<UserPreferencesProvider>();
      final historyProvider = context.read<PlantHistoryProvider>();

      // Convert image to base64
      final base64Image = await _imagePickerService.imageToBase64(_selectedImage!);

      // Identify plant
      final result = await identificationService.identifyPlant(
        imageBase64: base64Image,
        preferences: preferencesProvider.preferences,
      );

      // Save to history
      await historyProvider.addResult(result);

      // Increment scan count for rating
      await _ratingService.incrementScanCount();

      // Navigate to result screen
      if (mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PlantResultScreen(result: result),
          ),
        );

        // Clear selected image
        setState(() {
          _selectedImage = null;
          _isProcessing = false;
        });

        // Check and show rating dialog after navigation
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            showRatingDialog(context);
          }
        });
      }
    } catch (e) {
      setState(() {
        _isProcessing = false;
        _errorMessage = 'Failed to identify plant: ${e.toString()}';
      });
    }
  }
}
