import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../flutter_gen/gen_l10n/app_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/gemini_service.dart';
import '../providers/identification_provider.dart';
import '../providers/locale_provider.dart';
import '../theme/app_theme.dart';
import '../constants/app_dimensions.dart';
import 'fish_result_screen.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final ImagePicker _picker = ImagePicker();
  bool _isIdentifying = false;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image == null) return;

      setState(() {
        _isIdentifying = true;
      });

      await _identifyFish(image.path);
    } catch (e) {
      _showError(e.toString());
    } finally {
      setState(() {
        _isIdentifying = false;
      });
    }
  }

  Future<void> _identifyFish(String imagePath) async {
    final l10n = AppLocalizations.of(context)!;
    final localeProvider = context.read<LocaleProvider>();
    final identificationProvider = context.read<IdentificationProvider>();

    try {
      // Read image and convert to base64
      final imageBytes = await File(imagePath).readAsBytes();
      final base64Image = base64Encode(imageBytes);

      // Initialize Gemini service
      final geminiService = GeminiService(
        useProxy: true,
        supabaseClient: Supabase.instance.client,
      );

      // Identify fish
      final fishResult = await geminiService.identifyFish(
        base64Image,
        languageCode: localeProvider.locale.languageCode,
      );

      // Update with actual image path
      final fishWithPath = fishResult.copyWith(imagePath: imagePath);

      // Save to database
      await identificationProvider.addIdentification(fishWithPath);

      // Navigate to result screen
      if (mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => FishResultScreen(
              fishId: fishWithPath.id!,
            ),
          ),
        );
      }
    } catch (e) {
      _showError(e.toString());
    }
  }

  void _showError(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.cameraTitle),
        centerTitle: true,
      ),
      body: _isIdentifying
          ? _buildLoadingState(l10n)
          : _buildCameraUI(l10n, theme),
    );
  }

  Widget _buildLoadingState(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: AppDimensions.space24),
          Text(
            l10n.identifyingFish,
            style: AppTheme.h4,
          ),
        ],
      ),
    );
  }

  Widget _buildCameraUI(AppLocalizations l10n, ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.oceanGradient,
      ),
      child: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            // Fish icon
            Icon(
              Icons.set_meal,
              size: 120,
              color: Colors.white.withValues(alpha: 0.9),
            ),
            const SizedBox(height: AppDimensions.space24),
            Text(
              l10n.cameraHint,
              style: AppTheme.h3.copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            // Buttons
            Padding(
              padding: const EdgeInsets.all(AppDimensions.space24),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _pickImage(ImageSource.camera),
                      icon: const Icon(Icons.camera_alt),
                      label: Text(l10n.takePhoto),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: theme.primaryColor,
                        padding: const EdgeInsets.symmetric(
                          vertical: AppDimensions.space16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.space16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _pickImage(ImageSource.gallery),
                      icon: const Icon(Icons.photo_library),
                      label: Text(l10n.selectFromGallery),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white, width: 2),
                        padding: const EdgeInsets.symmetric(
                          vertical: AppDimensions.space16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
