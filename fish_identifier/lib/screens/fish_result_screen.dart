import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../flutter_gen/gen_l10n/app_localizations.dart';
import '../providers/identification_provider.dart';
import '../providers/collection_provider.dart';
import '../models/fish_identification.dart';
import '../models/fish_collection.dart';
import '../constants/app_dimensions.dart';
import '../theme/app_theme.dart';
import '../services/rating_service.dart';
import '../widgets/rating_request_dialog.dart';
import 'chat_screen.dart';

class FishResultScreen extends StatefulWidget {
  final int fishId;

  const FishResultScreen({super.key, required this.fishId});

  @override
  State<FishResultScreen> createState() => _FishResultScreenState();
}

class _FishResultScreenState extends State<FishResultScreen> {
  @override
  void initState() {
    super.initState();
    // Show rating dialog after the screen is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowRatingDialog();
    });
  }

  Future<void> _checkAndShowRatingDialog() async {
    final shouldShow = await RatingService().shouldShowRatingDialog();
    if (shouldShow && mounted) {
      await RatingService().recordRatingDialogShown();
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const RatingRequestDialog(),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final identificationProvider = context.watch<IdentificationProvider>();
    final fish = identificationProvider.getIdentificationById(widget.fishId);

    if (fish == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.errorTitle)),
        body: Center(child: Text(l10n.errorGeneral)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(fish.fishName),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareResult(context, fish),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _deleteResult(context, fish.id!),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fish image
            if (fish.imagePath.isNotEmpty)
              Image.file(
                File(fish.imagePath),
                width: double.infinity,
                height: 300,
                fit: BoxFit.cover,
              ),

            Padding(
              padding: const EdgeInsets.all(AppDimensions.space16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Fish name
                  Text(fish.fishName, style: AppTheme.h2),
                  const SizedBox(height: AppDimensions.space8),

                  // Scientific name
                  Text(
                    fish.scientificName,
                    style: AppTheme.body.copyWith(
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: AppDimensions.space16),

                  // Confidence
                  _buildConfidenceBar(fish.confidenceScore, context),
                  const SizedBox(height: AppDimensions.space24),

                  // Details
                  _buildSection(l10n.habitat, fish.habitat),
                  _buildSection(l10n.diet, fish.diet),

                  if (fish.edibility != null)
                    _buildSection(l10n.edibility, fish.edibility!),

                  if (fish.cookingTips != null)
                    _buildSection(l10n.cookingTips, fish.cookingTips!),

                  if (fish.fishingTips != null)
                    _buildSection(l10n.fishingTips, fish.fishingTips!),

                  // Fun facts
                  if (fish.funFacts.isNotEmpty) ...[
                    const SizedBox(height: AppDimensions.space16),
                    Text(l10n.funFacts, style: AppTheme.h4),
                    const SizedBox(height: AppDimensions.space8),
                    ...fish.funFacts.map((fact) => Padding(
                          padding: const EdgeInsets.only(
                            bottom: AppDimensions.space8,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('• ', style: AppTheme.body),
                              Expanded(
                                child: Text(fact, style: AppTheme.body),
                              ),
                            ],
                          ),
                        )),
                  ],

                  const SizedBox(height: AppDimensions.space24),

                  // Action buttons
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _addToCollection(context, fish),
                      icon: const Icon(Icons.add),
                      label: Text(l10n.addToCollection),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.space12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ChatScreen(fishId: fish.id),
                          ),
                        );
                      },
                      icon: const Icon(Icons.chat),
                      label: Text(l10n.chatAboutFish),
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

  Widget _buildConfidenceBar(double confidence, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(l10n.confidence, style: AppTheme.bodySmall),
            Text(
              '${(confidence * 100).toStringAsFixed(0)}%',
              style: AppTheme.bodySmall.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.space8),
        LinearProgressIndicator(
          value: confidence,
          minHeight: 8,
          borderRadius: BorderRadius.circular(AppDimensions.radius8),
        ),
      ],
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.space16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTheme.h4),
          const SizedBox(height: AppDimensions.space8),
          Text(content, style: AppTheme.body),
        ],
      ),
    );
  }

  void _addToCollection(BuildContext context, FishIdentification fish) {
    final l10n = AppLocalizations.of(context)!;
    final collectionProvider = context.read<CollectionProvider>();

    final collection = FishCollection(
      fishIdentificationId: fish.id!,
      catchDate: DateTime.now(),
      location: fish.location,
      latitude: fish.latitude,
      longitude: fish.longitude,
    );

    collectionProvider.addToCollection(collection);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.addToCollection)),
    );
  }

  void _shareResult(BuildContext context, FishIdentification fish) async {
    try {
      final text = '''
🐟 ${fish.fishName}
📝 Scientific Name: ${fish.scientificName}
📊 Confidence: ${(fish.confidenceScore * 100).toStringAsFixed(0)}%
🌊 Habitat: ${fish.habitat}
🍽️ Diet: ${fish.diet}
${fish.edibility != null ? '🍴 Edibility: ${fish.edibility}' : ''}

Identified using Fish Identifier 🎣
''';

      // Share with image if available
      if (fish.imagePath.isNotEmpty) {
        final file = File(fish.imagePath);
        if (await file.exists()) {
          await Share.shareXFiles(
            [XFile(fish.imagePath)],
            text: text,
          );
          return;
        }
      }

      // Share text only if image not available
      await Share.share(text);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to share. Please try again.')),
        );
      }
    }
  }

  void _deleteResult(BuildContext context, int id) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.delete),
        content: Text(l10n.confirmClearDataMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              context.read<IdentificationProvider>().deleteIdentification(id);
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close result screen
            },
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }
}
