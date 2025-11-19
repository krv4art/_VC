import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/batch_generation_request.dart';
import '../models/retouch_settings.dart';
import '../models/background_settings.dart';
import '../providers/enhanced_photo_provider.dart';
import '../providers/user_state.dart';
import '../l10n/app_localizations.dart';

class BatchGenerationScreen extends StatefulWidget {
  const BatchGenerationScreen({super.key});

  @override
  State<BatchGenerationScreen> createState() => _BatchGenerationScreenState();
}

class _BatchGenerationScreenState extends State<BatchGenerationScreen> {
  final ImagePicker _imagePicker = ImagePicker();
  final List<String> _selectedImages = [];

  // Generation settings
  String _styleId = 'professional';
  int _numberOfVariations = 5;
  bool _enableRetouch = true;
  bool _enableBackgroundChange = false;
  bool _highResolution = false;
  RetouchSettings _retouchSettings = RetouchSettings.professional();
  BackgroundSettings? _backgroundSettings;
  String? _customPrompt;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = context.watch<EnhancedPhotoProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.batchGeneration ?? 'Batch Generation'),
      ),
      body: provider.currentBatchJob != null
          ? _buildJobProgress(l10n, provider)
          : _buildGenerationSetup(l10n, provider),
      floatingActionButton: _selectedImages.isNotEmpty &&
              provider.currentBatchJob == null &&
              !provider.isProcessing
          ? FloatingActionButton.extended(
              onPressed: () => _startBatchGeneration(provider),
              icon: const Icon(Icons.play_arrow),
              label: Text(l10n.generateAll ?? 'Generate All'),
            )
          : null,
    );
  }

  Widget _buildGenerationSetup(AppLocalizations l10n, EnhancedPhotoProvider provider) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Image selection
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.selectedPhotos ?? 'Selected Photos: ${_selectedImages.length}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    ElevatedButton.icon(
                      onPressed: _selectImages,
                      icon: const Icon(Icons.add_photo_alternate),
                      label: Text(l10n.addPhotos ?? 'Add Photos'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (_selectedImages.isNotEmpty)
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _selectedImages.length,
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  File(_selectedImages[index]),
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: IconButton(
                                icon: const Icon(Icons.close, color: Colors.white),
                                style: IconButton.styleFrom(
                                  backgroundColor: Colors.black54,
                                  padding: const EdgeInsets.all(4),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _selectedImages.removeAt(index);
                                  });
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Generation settings
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.generationSettings ?? 'Generation Settings',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: Text(l10n.variationsPerPhoto ?? 'Variations per photo'),
                  subtitle: Text('$_numberOfVariations ${l10n.variations ?? "variations"}'),
                  trailing: SizedBox(
                    width: 200,
                    child: Slider(
                      value: _numberOfVariations.toDouble(),
                      min: 1,
                      max: 20,
                      divisions: 19,
                      label: '$_numberOfVariations',
                      onChanged: (value) {
                        setState(() {
                          _numberOfVariations = value.toInt();
                        });
                      },
                    ),
                  ),
                ),
                ListTile(
                  title: Text(l10n.totalGenerations ?? 'Total generations'),
                  subtitle: Text('${_selectedImages.length} × $_numberOfVariations = ${_selectedImages.length * _numberOfVariations}'),
                ),
                SwitchListTile(
                  title: Text(l10n.enableRetouch ?? 'Enable AI Retouch'),
                  subtitle: Text(l10n.retouchDescription ?? 'Apply automatic retouch to all photos'),
                  value: _enableRetouch,
                  onChanged: (value) {
                    setState(() {
                      _enableRetouch = value;
                    });
                  },
                ),
                SwitchListTile(
                  title: Text(l10n.changeBackground ?? 'Change Background'),
                  subtitle: Text(l10n.backgroundDescription ?? 'Apply professional backgrounds'),
                  value: _enableBackgroundChange,
                  onChanged: (value) {
                    setState(() {
                      _enableBackgroundChange = value;
                    });
                  },
                ),
                SwitchListTile(
                  title: Text(l10n.highResolution ?? 'High Resolution (4K)'),
                  subtitle: Text(l10n.highResDescription ?? 'Generate at maximum quality'),
                  value: _highResolution,
                  onChanged: (value) {
                    setState(() {
                      _highResolution = value;
                    });
                  },
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Style selection
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.selectStyle ?? 'Select Style',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  children: [
                    ChoiceChip(
                      label: Text(l10n.professional ?? 'Professional'),
                      selected: _styleId == 'professional',
                      onSelected: (selected) {
                        setState(() => _styleId = 'professional');
                      },
                    ),
                    ChoiceChip(
                      label: Text(l10n.casual ?? 'Casual'),
                      selected: _styleId == 'casual',
                      onSelected: (selected) {
                        setState(() => _styleId = 'casual');
                      },
                    ),
                    ChoiceChip(
                      label: Text(l10n.formal ?? 'Formal'),
                      selected: _styleId == 'formal',
                      onSelected: (selected) {
                        setState(() => _styleId = 'formal');
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Custom prompt
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                labelText: l10n.customPrompt ?? 'Custom Prompt (Optional)',
                hintText: l10n.customPromptHint ?? 'Describe the desired style...',
                border: const OutlineInputBorder(),
              ),
              maxLines: 3,
              onChanged: (value) {
                _customPrompt = value.isEmpty ? null : value;
              },
            ),
          ),
        ),

        const SizedBox(height: 100), // Space for FAB
      ],
    );
  }

  Widget _buildJobProgress(AppLocalizations l10n, EnhancedPhotoProvider provider) {
    final job = provider.currentBatchJob!;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.cloud_upload, size: 80, color: Colors.blue),
          const SizedBox(height: 24),
          Text(
            l10n.processingBatch ?? 'Processing Batch Job',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          Text(
            '${job.completedPhotos} / ${job.totalPhotos} ${l10n.completed ?? "completed"}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 24),
          LinearProgressIndicator(
            value: job.progress,
            minHeight: 8,
          ),
          const SizedBox(height: 8),
          Text('${(job.progress * 100).toInt()}%'),
          const SizedBox(height: 32),
          if (job.status == BatchJobStatus.processing) ...[
            ElevatedButton.icon(
              onPressed: () => provider.cancelCurrentBatchJob(),
              icon: const Icon(Icons.cancel),
              label: Text(l10n.cancel ?? 'Cancel'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
            ),
          ] else if (job.status == BatchJobStatus.completed) ...[
            const Icon(Icons.check_circle, size: 60, color: Colors.green),
            const SizedBox(height: 16),
            Text(
              l10n.batchCompleted ?? 'Batch generation completed!',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                provider.reset();
                setState(() {
                  _selectedImages.clear();
                });
              },
              icon: const Icon(Icons.refresh),
              label: Text(l10n.startNew ?? 'Start New Batch'),
            ),
          ] else if (job.status == BatchJobStatus.failed) ...[
            const Icon(Icons.error, size: 60, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              l10n.batchFailed ?? 'Batch generation failed',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            if (job.error != null) ...[
              const SizedBox(height: 8),
              Text(job.error!, style: const TextStyle(color: Colors.red)),
            ],
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                provider.reset();
              },
              icon: const Icon(Icons.refresh),
              label: Text(l10n.tryAgain ?? 'Try Again'),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _selectImages() async {
    final List<XFile> images = await _imagePicker.pickMultiImage();

    if (images.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(images.map((e) => e.path));
      });
    }
  }

  Future<void> _startBatchGeneration(EnhancedPhotoProvider provider) async {
    if (_selectedImages.isEmpty) {
      _showError('Please select at least one photo');
      return;
    }

    final userState = context.read<UserState>();
    final userId = userState.userId ?? 'anonymous';

    final request = BatchGenerationRequest(
      imagePaths: _selectedImages,
      styleId: _styleId,
      customPrompt: _customPrompt,
      retouchSettings: _enableRetouch ? _retouchSettings : null,
      backgroundSettings: _enableBackgroundChange ? _backgroundSettings : null,
      numberOfVariations: _numberOfVariations,
      highResolution: _highResolution,
      userId: userId,
    );

    try {
      await provider.startBatchGeneration(request);
    } catch (e) {
      _showError(e.toString());
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}
