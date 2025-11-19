import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/marks_recognition_service.dart';
import '../models/maker_mark.dart';

/// Экран сканирования клейм производителей
class MarksScannerScreen extends StatefulWidget {
  const MarksScannerScreen({Key? key}) : super(key: key);

  @override
  State<MarksScannerScreen> createState() => _MarksScannerScreenState();
}

class _MarksScannerScreenState extends State<MarksScannerScreen> {
  final MarksRecognitionService _service = MarksRecognitionService();
  final ImagePicker _picker = ImagePicker();

  MakerMark? _recognizedMark;
  String? _imagePath;
  bool _isScanning = false;
  String? _errorMessage;

  Future<void> _scanFromCamera() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (photo == null) return;

      setState(() {
        _isScanning = true;
        _errorMessage = null;
        _imagePath = photo.path;
      });

      final mark = await _service.recognizeMark(photo.path);

      setState(() {
        _recognizedMark = mark;
        _isScanning = false;
        if (mark == null) {
          _errorMessage = 'Could not recognize the mark. Try taking a clearer photo.';
        }
      });
    } catch (e) {
      setState(() {
        _isScanning = false;
        _errorMessage = 'Error scanning mark: $e';
      });
    }
  }

  Future<void> _scanFromGallery() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (photo == null) return;

      setState(() {
        _isScanning = true;
        _errorMessage = null;
        _imagePath = photo.path;
      });

      final mark = await _service.recognizeMark(photo.path);

      setState(() {
        _recognizedMark = mark;
        _isScanning = false;
        if (mark == null) {
          _errorMessage = 'Could not recognize the mark. Try a different image.';
        }
      });
    } catch (e) {
      setState(() {
        _isScanning = false;
        _errorMessage = 'Error scanning mark: $e';
      });
    }
  }

  void _reset() {
    setState(() {
      _recognizedMark = null;
      _imagePath = null;
      _errorMessage = null;
    });
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'porcelain':
        return Colors.blue;
      case 'silver':
        return Colors.grey;
      case 'pottery':
        return Colors.brown;
      case 'glass':
        return Colors.cyan;
      default:
        return Colors.purple;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'porcelain':
        return Icons.local_cafe;
      case 'silver':
        return Icons.stars;
      case 'pottery':
        return Icons.emoji_nature;
      case 'glass':
        return Icons.wine_bar;
      default:
        return Icons.diamond;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Marks Scanner'),
        actions: [
          if (_recognizedMark != null || _errorMessage != null)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _reset,
              tooltip: 'Scan another mark',
            ),
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('How to Scan Marks'),
                  content: const SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tips for best results:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text('• Clean the mark before photographing'),
                        Text('• Use good lighting'),
                        Text('• Keep the camera steady'),
                        Text('• Fill the frame with the mark'),
                        Text('• Avoid shadows and reflections'),
                        SizedBox(height: 16),
                        Text(
                          'The AI will analyze the mark and match it against our database of known manufacturers.',
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Got it'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isScanning) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 24),
            Text(
              'Analyzing mark...',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'This may take a few seconds',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                  ),
            ),
          ],
        ),
      );
    }

    if (_recognizedMark != null) {
      return _buildRecognizedMarkView();
    }

    if (_errorMessage != null) {
      return _buildErrorView();
    }

    return _buildWelcomeView();
  }

  Widget _buildWelcomeView() {
    final knownMarks = _service.getKnownMarks();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Инструкция
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Icon(
                    Icons.camera_alt,
                    size: 64,
                    color: Colors.amber.shade700,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Scan Maker\'s Marks',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Take a photo of a manufacturer\'s mark or hallmark to identify the maker, origin, and period of your antique item.',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Кнопки сканирования
          ElevatedButton.icon(
            onPressed: _scanFromCamera,
            icon: const Icon(Icons.photo_camera),
            label: const Text('Take Photo'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 12),

          OutlinedButton.icon(
            onPressed: _scanFromGallery,
            icon: const Icon(Icons.photo_library),
            label: const Text('Choose from Gallery'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              textStyle: const TextStyle(fontSize: 18),
            ),
          ),

          const SizedBox(height: 32),

          // База известных клейм
          Text(
            'Known Manufacturers',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Our database includes ${knownMarks.length} famous manufacturers',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade600,
                ),
          ),

          const SizedBox(height: 16),

          // Список известных клейм
          ...knownMarks.map((mark) => _buildKnownMarkCard(mark)),
        ],
      ),
    );
  }

  Widget _buildKnownMarkCard(MakerMark mark) {
    final categoryColor = _getCategoryColor(mark.category);
    final categoryIcon = _getCategoryIcon(mark.category);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: categoryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(categoryIcon, color: categoryColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mark.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${mark.country}${mark.period != null ? ' • ${mark.period}' : ''}',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
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

  Widget _buildRecognizedMarkView() {
    final mark = _recognizedMark!;
    final categoryColor = _getCategoryColor(mark.category);
    final categoryIcon = _getCategoryIcon(mark.category);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Изображение
          if (_imagePath != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                File(_imagePath!),
                height: 200,
                fit: BoxFit.cover,
              ),
            ),

          const SizedBox(height: 24),

          // Success indicator
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green.shade700, size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mark Identified!',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.green.shade900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'We found a match in our database',
                        style: TextStyle(color: Colors.green.shade700),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Название производителя
          Text(
            mark.name,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.amber.shade900,
                ),
          ),

          const SizedBox(height: 16),

          // Категория
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: categoryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: categoryColor),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(categoryIcon, size: 16, color: categoryColor),
                    const SizedBox(width: 6),
                    Text(
                      mark.category.toUpperCase(),
                      style: TextStyle(
                        color: categoryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Информация
          _buildInfoSection('Country', mark.country, Icons.public),

          if (mark.period != null)
            _buildInfoSection('Period', mark.period!, Icons.calendar_today),

          const SizedBox(height: 24),

          // Описание
          Text(
            'Description',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            mark.description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  height: 1.6,
                ),
          ),

          if (mark.keywords.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text(
              'Keywords',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: mark.keywords.map((keyword) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Text(
                    keyword,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                );
              }).toList(),
            ),
          ],

          const SizedBox(height: 32),

          // Кнопка сканировать еще
          OutlinedButton.icon(
            onPressed: _reset,
            icon: const Icon(Icons.camera_alt),
            label: const Text('Scan Another Mark'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_imagePath != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(_imagePath!),
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 24),
            ],
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.orange.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'Mark Not Found',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage ?? 'Could not recognize the mark',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade700,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _reset,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
