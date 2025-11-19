import 'dart:io';
import 'package:flutter/material.dart';
import '../services/photo_editing_service.dart';
import '../models/generated_photo.dart';

/// Photo editor screen with editing tools
class PhotoEditorScreen extends StatefulWidget {
  final GeneratedPhoto photo;

  const PhotoEditorScreen({
    Key? key,
    required this.photo,
  }) : super(key: key);

  @override
  State<PhotoEditorScreen> createState() => _PhotoEditorScreenState();
}

class _PhotoEditorScreenState extends State<PhotoEditorScreen> {
  final _editingService = PhotoEditingService();

  String? _currentImagePath;
  bool _isProcessing = false;

  // Adjustment values
  double _brightness = 0;
  double _contrast = 0;
  double _saturation = 0;

  EditorMode _currentMode = EditorMode.none;

  @override
  void initState() {
    super.initState();
    _currentImagePath = widget.photo.generatedPath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Edit Photo', style: TextStyle(color: Colors.white)),
        actions: [
          if (_isProcessing)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else
            TextButton(
              onPressed: _saveEdits,
              child: const Text('Save', style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
      body: Column(
        children: [
          // Image preview
          Expanded(
            child: Center(
              child: _currentImagePath != null
                  ? Image.file(
                      File(_currentImagePath!),
                      fit: BoxFit.contain,
                    )
                  : const CircularProgressIndicator(),
            ),
          ),

          // Adjustment controls
          if (_currentMode == EditorMode.adjust) _buildAdjustmentControls(),

          // Bottom toolbar
          _buildBottomToolbar(),
        ],
      ),
    );
  }

  Widget _buildBottomToolbar() {
    return Container(
      color: Colors.grey[900],
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildToolButton(
            icon: Icons.crop,
            label: 'Crop',
            onTap: () => _setMode(EditorMode.crop),
          ),
          _buildToolButton(
            icon: Icons.rotate_right,
            label: 'Rotate',
            onTap: _rotateImage,
          ),
          _buildToolButton(
            icon: Icons.flip,
            label: 'Flip',
            onTap: _flipImage,
          ),
          _buildToolButton(
            icon: Icons.tune,
            label: 'Adjust',
            onTap: () => _setMode(EditorMode.adjust),
          ),
          _buildToolButton(
            icon: Icons.filter,
            label: 'Filters',
            onTap: () => _setMode(EditorMode.filters),
          ),
        ],
      ),
    );
  }

  Widget _buildToolButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildAdjustmentControls() {
    return Container(
      color: Colors.grey[900],
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSlider(
            label: 'Brightness',
            value: _brightness,
            onChanged: (value) {
              setState(() => _brightness = value);
            },
            onChangeEnd: (value) => _applyAdjustments(),
          ),
          _buildSlider(
            label: 'Contrast',
            value: _contrast,
            onChanged: (value) {
              setState(() => _contrast = value);
            },
            onChangeEnd: (value) => _applyAdjustments(),
          ),
          _buildSlider(
            label: 'Saturation',
            value: _saturation,
            onChanged: (value) {
              setState(() => _saturation = value);
            },
            onChangeEnd: (value) => _applyAdjustments(),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: _resetAdjustments,
                child: const Text('Reset'),
              ),
              ElevatedButton(
                onPressed: () => _setMode(EditorMode.none),
                child: const Text('Done'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSlider({
    required String label,
    required double value,
    required ValueChanged<double> onChanged,
    required ValueChanged<double>? onChangeEnd,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
        Slider(
          value: value,
          min: -100,
          max: 100,
          divisions: 200,
          label: value.round().toString(),
          onChanged: onChanged,
          onChangeEnd: onChangeEnd,
        ),
      ],
    );
  }

  void _setMode(EditorMode mode) {
    setState(() => _currentMode = mode);
  }

  Future<void> _rotateImage() async {
    if (_currentImagePath == null) return;

    setState(() => _isProcessing = true);

    try {
      final rotated = await _editingService.rotateImage(
        imagePath: _currentImagePath!,
        angle: 90,
      );

      if (rotated != null) {
        setState(() => _currentImagePath = rotated);
      }
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  Future<void> _flipImage() async {
    if (_currentImagePath == null) return;

    setState(() => _isProcessing = true);

    try {
      final flipped = await _editingService.flipHorizontal(_currentImagePath!);

      if (flipped != null) {
        setState(() => _currentImagePath = flipped);
      }
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  Future<void> _applyAdjustments() async {
    if (_currentImagePath == null) return;

    setState(() => _isProcessing = true);

    try {
      final adjusted = await _editingService.adjustImage(
        imagePath: widget.photo.generatedPath!, // Use original
        brightness: _brightness.round(),
        contrast: _contrast.round(),
        saturation: _saturation.round(),
      );

      if (adjusted != null) {
        setState(() => _currentImagePath = adjusted);
      }
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  void _resetAdjustments() {
    setState(() {
      _brightness = 0;
      _contrast = 0;
      _saturation = 0;
      _currentImagePath = widget.photo.generatedPath;
    });
  }

  Future<void> _saveEdits() async {
    if (_currentImagePath == null) return;

    // Return the edited photo path
    Navigator.pop(context, _currentImagePath);
  }
}

enum EditorMode {
  none,
  crop,
  adjust,
  filters,
}
