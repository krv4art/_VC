import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../models/retouch_settings.dart';
import '../models/background_settings.dart';
import '../providers/enhanced_photo_provider.dart';
import '../services/ai_outfit_change_service.dart';
import '../services/ai_image_expansion_service.dart';
import '../l10n/app_localizations.dart';
import '../services/local_photo_database_service.dart';
import '../models/generated_photo.dart';
import 'package:path/path.dart' as path;

class AdvancedPhotoEditorScreen extends StatefulWidget {
  final String imagePath;

  const AdvancedPhotoEditorScreen({
    super.key,
    required this.imagePath,
  });

  @override
  State<AdvancedPhotoEditorScreen> createState() => _AdvancedPhotoEditorScreenState();
}

class _AdvancedPhotoEditorScreenState extends State<AdvancedPhotoEditorScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Retouch settings
  RetouchSettings _retouchSettings = const RetouchSettings();

  // Background settings
  BackgroundSettings _backgroundSettings = const BackgroundSettings();

  // Other settings
  OutfitType? _selectedOutfit;
  AspectRatio? _selectedAspectRatio;
  bool _upscaleTo4K = false;

  String? _processedImagePath;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _processedImagePath = widget.imagePath;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = context.watch<EnhancedPhotoProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.advancedEditor ?? 'Advanced Editor'),
        actions: [
          if (_processedImagePath != null)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _savePhoto,
            ),
        ],
      ),
      body: Column(
        children: [
          // Image preview
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.black,
              child: Center(
                child: _processedImagePath != null
                    ? Image.file(
                        File(_processedImagePath!),
                        fit: BoxFit.contain,
                      )
                    : const CircularProgressIndicator(),
              ),
            ),
          ),

          // Progress indicator
          if (provider.isProcessing)
            LinearProgressIndicator(value: provider.progress),

          // Tabs
          TabBar(
            controller: _tabController,
            isScrollable: true,
            tabs: [
              Tab(icon: const Icon(Icons.face_retouching_natural), text: l10n.retouch ?? 'Retouch'),
              Tab(icon: const Icon(Icons.wallpaper), text: l10n.background ?? 'Background'),
              Tab(icon: const Icon(Icons.checkroom), text: l10n.outfit ?? 'Outfit'),
              Tab(icon: const Icon(Icons.aspect_ratio), text: l10n.expand ?? 'Expand'),
              Tab(icon: const Icon(Icons.high_quality), text: l10n.quality ?? 'Quality'),
            ],
          ),

          // Tab content
          Expanded(
            flex: 2,
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildRetouchTab(l10n, provider),
                _buildBackgroundTab(l10n, provider),
                _buildOutfitTab(l10n, provider),
                _buildExpansionTab(l10n, provider),
                _buildQualityTab(l10n, provider),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRetouchTab(AppLocalizations l10n, EnhancedPhotoProvider provider) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Preset buttons
        Wrap(
          spacing: 8,
          children: [
            ElevatedButton(
              onPressed: () => _applyRetouchPreset(RetouchSettings.natural(), provider),
              child: Text(l10n.natural ?? 'Natural'),
            ),
            ElevatedButton(
              onPressed: () => _applyRetouchPreset(RetouchSettings.professional(), provider),
              child: Text(l10n.professional ?? 'Professional'),
            ),
            ElevatedButton(
              onPressed: () => _applyRetouchPreset(RetouchSettings.glamour(), provider),
              child: Text(l10n.glamour ?? 'Glamour'),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Custom settings
        SwitchListTile(
          title: Text(l10n.removeBlemishes ?? 'Remove Blemishes'),
          value: _retouchSettings.removeBlemishes,
          onChanged: (value) {
            setState(() {
              _retouchSettings = _retouchSettings.copyWith(removeBlemishes: value);
            });
          },
        ),
        SwitchListTile(
          title: Text(l10n.smoothSkin ?? 'Smooth Skin'),
          value: _retouchSettings.smoothSkin,
          onChanged: (value) {
            setState(() {
              _retouchSettings = _retouchSettings.copyWith(smoothSkin: value);
            });
          },
        ),
        SwitchListTile(
          title: Text(l10n.enhanceLighting ?? 'Enhance Lighting'),
          value: _retouchSettings.enhanceLighting,
          onChanged: (value) {
            setState(() {
              _retouchSettings = _retouchSettings.copyWith(enhanceLighting: value);
            });
          },
        ),
        SwitchListTile(
          title: Text(l10n.enhanceEyes ?? 'Enhance Eyes'),
          value: _retouchSettings.enhanceEyes,
          onChanged: (value) {
            setState(() {
              _retouchSettings = _retouchSettings.copyWith(enhanceEyes: value);
            });
          },
        ),

        const SizedBox(height: 16),
        Text(l10n.smoothness ?? 'Smoothness: ${(_retouchSettings.smoothnessLevel * 100).toInt()}%'),
        Slider(
          value: _retouchSettings.smoothnessLevel,
          onChanged: (value) {
            setState(() {
              _retouchSettings = _retouchSettings.copyWith(smoothnessLevel: value);
            });
          },
        ),

        const SizedBox(height: 24),
        ElevatedButton.icon(
          onPressed: provider.isProcessing
              ? null
              : () => _applyRetouchPreset(_retouchSettings, provider),
          icon: const Icon(Icons.auto_fix_high),
          label: Text(l10n.applyRetouch ?? 'Apply Retouch'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }

  Widget _buildBackgroundTab(AppLocalizations l10n, EnhancedPhotoProvider provider) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ElevatedButton.icon(
          onPressed: provider.isProcessing ? null : () => _removeBackground(provider),
          icon: const Icon(Icons.auto_awesome),
          label: Text(l10n.removeBackground ?? 'Remove Background'),
          style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
        ),
        const SizedBox(height: 16),

        Text(l10n.backgroundType ?? 'Background Type:',
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),

        Wrap(
          spacing: 8,
          children: [
            ChoiceChip(
              label: Text(l10n.transparent ?? 'Transparent'),
              selected: _backgroundSettings.type == BackgroundType.transparent,
              onSelected: (selected) {
                setState(() {
                  _backgroundSettings = BackgroundSettings(type: BackgroundType.transparent);
                });
              },
            ),
            ChoiceChip(
              label: Text(l10n.solidColor ?? 'Solid Color'),
              selected: _backgroundSettings.type == BackgroundType.solidColor,
              onSelected: (selected) {
                setState(() {
                  _backgroundSettings = BackgroundSettings(type: BackgroundType.solidColor);
                });
              },
            ),
            ChoiceChip(
              label: Text(l10n.preset ?? 'Preset'),
              selected: _backgroundSettings.type == BackgroundType.preset,
              onSelected: (selected) {
                setState(() {
                  _backgroundSettings = BackgroundSettings(type: BackgroundType.preset);
                });
              },
            ),
          ],
        ),

        if (_backgroundSettings.type == BackgroundType.preset) ...[
          const SizedBox(height: 16),
          Text(l10n.selectStyle ?? 'Select Style:'),
          Wrap(
            spacing: 8,
            children: BackgroundStyle.values.map((style) {
              return ChoiceChip(
                label: Text(style.toString().split('.').last),
                selected: _backgroundSettings.style == style,
                onSelected: (selected) {
                  setState(() {
                    _backgroundSettings = _backgroundSettings.copyWith(style: style);
                  });
                },
              );
            }).toList(),
          ),
        ],

        const SizedBox(height: 24),
        ElevatedButton.icon(
          onPressed: provider.isProcessing
              ? null
              : () => _applyBackground(provider),
          icon: const Icon(Icons.wallpaper),
          label: Text(l10n.applyBackground ?? 'Apply Background'),
          style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
        ),
      ],
    );
  }

  Widget _buildOutfitTab(AppLocalizations l10n, EnhancedPhotoProvider provider) {
    final outfits = AIOutfitChangeService.getAvailableOutfits();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(l10n.selectOutfit ?? 'Select Outfit:',
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 16),
        ...outfits.map((outfit) => Card(
          child: ListTile(
            leading: const Icon(Icons.checkroom),
            title: Text(outfit.name),
            subtitle: Text('${outfit.description}\n${outfit.profession}'),
            isThreeLine: true,
            selected: _selectedOutfit == outfit.type,
            onTap: () {
              setState(() {
                _selectedOutfit = outfit.type;
              });
            },
          ),
        )),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: provider.isProcessing || _selectedOutfit == null
              ? null
              : () => _changeOutfit(provider),
          icon: const Icon(Icons.checkroom),
          label: Text(l10n.changeOutfit ?? 'Change Outfit'),
          style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
        ),
      ],
    );
  }

  Widget _buildExpansionTab(AppLocalizations l10n, EnhancedPhotoProvider provider) {
    final ratios = AIImageExpansionService.getAvailableRatios();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(l10n.selectAspectRatio ?? 'Select Aspect Ratio:',
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 16),
        ...ratios.map((ratio) => Card(
          child: ListTile(
            leading: const Icon(Icons.aspect_ratio),
            title: Text(ratio.name),
            subtitle: Text('${ratio.description}\n${ratio.width}x${ratio.height}'),
            isThreeLine: true,
            selected: _selectedAspectRatio == ratio.ratio,
            onTap: () {
              setState(() {
                _selectedAspectRatio = ratio.ratio;
              });
            },
          ),
        )),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: provider.isProcessing || _selectedAspectRatio == null
              ? null
              : () => _expandImage(provider),
          icon: const Icon(Icons.aspect_ratio),
          label: Text(l10n.expandImage ?? 'Expand Image'),
          style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
        ),
      ],
    );
  }

  Widget _buildQualityTab(AppLocalizations l10n, EnhancedPhotoProvider provider) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SwitchListTile(
          title: Text(l10n.upscaleTo4K ?? 'Upscale to 4K'),
          subtitle: Text(l10n.upscaleDescription ?? 'Enhance image resolution to 3840x2160'),
          value: _upscaleTo4K,
          onChanged: (value) {
            setState(() {
              _upscaleTo4K = value;
            });
          },
        ),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          onPressed: provider.isProcessing
              ? null
              : () => _upscaleImage(provider),
          icon: const Icon(Icons.high_quality),
          label: Text(l10n.enhanceQuality ?? 'Enhance Quality'),
          style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
        ),
      ],
    );
  }

  Future<void> _applyRetouchPreset(RetouchSettings settings, EnhancedPhotoProvider provider) async {
    try {
      final result = await provider.applyRetouch(
        imagePath: _processedImagePath!,
        settings: settings,
      );
      setState(() {
        _processedImagePath = result;
      });
    } catch (e) {
      _showError(e.toString());
    }
  }

  Future<void> _removeBackground(EnhancedPhotoProvider provider) async {
    try {
      final result = await provider.removeBackground(_processedImagePath!);
      setState(() {
        _processedImagePath = result;
      });
    } catch (e) {
      _showError(e.toString());
    }
  }

  Future<void> _applyBackground(EnhancedPhotoProvider provider) async {
    try {
      final result = await provider.replaceBackground(
        imagePath: _processedImagePath!,
        settings: _backgroundSettings,
      );
      setState(() {
        _processedImagePath = result;
      });
    } catch (e) {
      _showError(e.toString());
    }
  }

  Future<void> _changeOutfit(EnhancedPhotoProvider provider) async {
    if (_selectedOutfit == null) return;

    try {
      final result = await provider.changeOutfit(
        imagePath: _processedImagePath!,
        outfitType: _selectedOutfit!,
      );
      setState(() {
        _processedImagePath = result;
      });
    } catch (e) {
      _showError(e.toString());
    }
  }

  Future<void> _expandImage(EnhancedPhotoProvider provider) async {
    if (_selectedAspectRatio == null) return;

    try {
      final result = await provider.expandImage(
        imagePath: _processedImagePath!,
        targetRatio: _selectedAspectRatio!,
      );
      setState(() {
        _processedImagePath = result;
      });
    } catch (e) {
      _showError(e.toString());
    }
  }

  Future<void> _upscaleImage(EnhancedPhotoProvider provider) async {
    try {
      final result = await provider.upscaleTo4K(_processedImagePath!);
      setState(() {
        _processedImagePath = result;
      });
    } catch (e) {
      _showError(e.toString());
    }
  }

  Future<void> _savePhoto() async {
    try {
      final l10n = AppLocalizations.of(context)!;
      final photoDb = context.read<LocalPhotoDatabase>();

      // Get the current processed image path
      final imagePath = _processedImagePath ?? widget.imagePath;
      final file = File(imagePath);

      if (!await file.exists()) {
        _showError(l10n.errorPhotoUpload);
        return;
      }

      // Create a GeneratedPhoto object
      final photo = GeneratedPhoto(
        imagePath: imagePath,
        styleId: 'enhanced', // Mark as enhanced photo
        styleName: l10n.aiEditor,
        createdAt: DateTime.now(),
      );

      // Save to database
      await photoDb.insertPhoto(photo);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.save} ✓'),
            backgroundColor: Colors.green,
            action: SnackBarAction(
              label: l10n.done,
              onPressed: () {},
              textColor: Colors.white,
            ),
          ),
        );
      }
    } catch (e) {
      _showError(e.toString());
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $message'), backgroundColor: Colors.red),
    );
  }
}
