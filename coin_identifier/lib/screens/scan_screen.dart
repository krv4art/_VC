import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../services/coin_identification_service.dart';
import '../services/scanning/image_compression_service.dart';
import '../providers/analysis_provider.dart';

/// Экран для загрузки и сканирования фото монет и банкнот
class ScanScreen extends StatefulWidget {
  const ScanScreen({Key? key}) : super(key: key);

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final ImagePicker _imagePicker = ImagePicker();
  File? _selectedImage;
  bool _isAnalyzing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Coin')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            // Photo Preview
            if (_selectedImage != null)
              Container(
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade200,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    _selectedImage!,
                    fit: BoxFit.cover,
                  ),
                ),
              )
            else
              Container(
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade200,
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: const Center(
                  child: Icon(Icons.monetization_on, size: 80, color: Colors.grey),
                ),
              ),
            const SizedBox(height: 24),
            // Camera Button
            ElevatedButton.icon(
              onPressed: _isAnalyzing ? null : _capturePhoto,
              icon: const Icon(Icons.camera),
              label: const Text('Take Photo'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                backgroundColor: const Color(0xFFD4AF37),
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            // Gallery Button
            ElevatedButton.icon(
              onPressed: _isAnalyzing ? null : _pickFromGallery,
              icon: const Icon(Icons.photo_library),
              label: const Text('Choose from Gallery'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                backgroundColor: Colors.grey.shade700,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 32),
            // Tips Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Photo Tips for Best Results:',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.amber.shade900,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildTip('💡 Use good natural lighting'),
                  _buildTip('🪙 Photograph both obverse and reverse sides'),
                  _buildTip('🎯 Focus on mint marks and details'),
                  _buildTip('🚫 Avoid glare, shadows, and reflections'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Analyze Button
            if (_selectedImage != null)
              ElevatedButton.icon(
                onPressed: _isAnalyzing ? null : _analyzeImage,
                icon: _isAnalyzing
                    ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                )
                    : const Icon(Icons.auto_awesome),
                label: Text(
                  _isAnalyzing ? 'Analyzing Coin...' : 'Analyze with AI',
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: const Color(0xFFD4AF37),
                  foregroundColor: Colors.white,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _capturePhoto() async {
    try {
      final XFile? photo = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );
      if (photo != null) {
        setState(() {
          _selectedImage = File(photo.path);
        });
      }
    } catch (e) {
      _showError('Failed to capture photo: $e');
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final XFile? photo = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (photo != null) {
        setState(() {
          _selectedImage = File(photo.path);
        });
      }
    } catch (e) {
      _showError('Failed to pick photo: $e');
    }
  }

  Future<void> _analyzeImage() async {
    if (_selectedImage == null) return;

    final provider = context.read<AnalysisProvider>();

    setState(() {
      _isAnalyzing = true;
    });
    provider.setLoading(true);

    try {
      // 1. Read original image
      final imageBytes = await _selectedImage!.readAsBytes();
      debugPrint('Original image size: ${(imageBytes.length / 1024).toStringAsFixed(2)} KB');

      // 2. Compress image for AI analysis
      final compressedBytes = await ImageCompressionService.compressImageBytes(imageBytes);
      debugPrint('Compressed image size: ${(compressedBytes.length / 1024).toStringAsFixed(2)} KB');

      // 3. Analyze with Gemini AI
      final service = CoinIdentificationService();
      final result = await service.analyzeCoinImage(
        compressedBytes,
        languageCode: 'en',
      );

      if (!mounted) return;

      // 4. Update UI through provider
      provider.setCurrentAnalysis(result);
      provider.setLoading(false);

      // 5. Navigate to results screen
      if (mounted) {
        context.push('/results?id=${result.name}');
      }
    } catch (e) {
      if (!mounted) return;
      debugPrint('❌ Analysis error: $e');
      provider.setError('Analysis failed: $e');
      _showError('Analysis failed: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
        });
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 5),
      ),
    );
  }

  Widget _buildTip(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.amber.shade900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
