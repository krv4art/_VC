import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/image_processing_provider.dart';
import '../providers/premium_provider.dart';
import '../models/processing_options.dart';
import '../navigation/app_router.dart';
import '../theme/app_theme.dart';
import '../constants/app_constants.dart';

class EditorScreen extends StatefulWidget {
  const EditorScreen({super.key});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  String _selectedMode = AppConstants.processingModes.first;
  Color? _selectedColor;
  bool _autoEnhance = true;

  Future<void> _processImage() async {
    final provider = context.read<ImageProcessingProvider>();
    final premiumProvider = context.read<PremiumProvider>();

    final options = ProcessingOptions(
      mode: _selectedMode,
      backgroundColor: _selectedColor,
      autoEnhance: _autoEnhance,
    );

    await provider.processImage(options);
    await premiumProvider.incrementProcessCount();

    if (mounted && provider.processedImage != null) {
      context.go(AppRouter.result);
    } else if (provider.error != null) {
      _showErrorDialog(provider.error!);
    }
  }

  void _showErrorDialog(String error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Processing Error'),
        content: Text(error),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ImageProcessingProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Image'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            provider.reset();
            context.pop();
          },
        ),
      ),
      body: provider.selectedImage == null
          ? const Center(child: Text('No image selected'))
          : Column(
              children: [
                // Image Preview
                Expanded(
                  flex: 2,
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: FileImage(provider.selectedImage!),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),

                // Processing Options
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Processing Mode',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            children: AppConstants.processingModes.map((mode) {
                              return ChoiceChip(
                                label: Text(mode),
                                selected: _selectedMode == mode,
                                onSelected: (selected) {
                                  if (selected) {
                                    setState(() {
                                      _selectedMode = mode;
                                    });
                                  }
                                },
                                selectedColor: AppTheme.primaryColor,
                                labelStyle: TextStyle(
                                  color: _selectedMode == mode
                                      ? Colors.white
                                      : null,
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 20),

                          // Background Color Picker
                          Text(
                            'Background Color',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 12,
                            children: [
                              _ColorOption(
                                color: null,
                                label: 'Transparent',
                                isSelected: _selectedColor == null,
                                onTap: () {
                                  setState(() {
                                    _selectedColor = null;
                                  });
                                },
                              ),
                              _ColorOption(
                                color: Colors.white,
                                isSelected: _selectedColor == Colors.white,
                                onTap: () {
                                  setState(() {
                                    _selectedColor = Colors.white;
                                  });
                                },
                              ),
                              _ColorOption(
                                color: Colors.black,
                                isSelected: _selectedColor == Colors.black,
                                onTap: () {
                                  setState(() {
                                    _selectedColor = Colors.black;
                                  });
                                },
                              ),
                              _ColorOption(
                                color: Colors.red,
                                isSelected: _selectedColor == Colors.red,
                                onTap: () {
                                  setState(() {
                                    _selectedColor = Colors.red;
                                  });
                                },
                              ),
                              _ColorOption(
                                color: Colors.blue,
                                isSelected: _selectedColor == Colors.blue,
                                onTap: () {
                                  setState(() {
                                    _selectedColor = Colors.blue;
                                  });
                                },
                              ),
                              _ColorOption(
                                color: Colors.green,
                                isSelected: _selectedColor == Colors.green,
                                onTap: () {
                                  setState(() {
                                    _selectedColor = Colors.green;
                                  });
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Auto Enhance Toggle
                          SwitchListTile(
                            title: const Text('Auto Enhance'),
                            subtitle: const Text(
                              'Automatically improve image quality',
                            ),
                            value: _autoEnhance,
                            onChanged: (value) {
                              setState(() {
                                _autoEnhance = value;
                              });
                            },
                            activeColor: AppTheme.primaryColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Process Button
                Container(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: provider.isProcessing ? null : _processImage,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: provider.isProcessing
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Processing ${(provider.progress * 100).toInt()}%',
                                ),
                              ],
                            )
                          : const Text(
                              'Process Image',
                              style: TextStyle(fontSize: 18),
                            ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class _ColorOption extends StatelessWidget {
  final Color? color;
  final String? label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ColorOption({
    required this.color,
    this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color ?? Colors.white,
              border: Border.all(
                color: isSelected ? AppTheme.primaryColor : Colors.grey[300]!,
                width: isSelected ? 3 : 1,
              ),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                if (isSelected)
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
              ],
            ),
            child: color == null
                ? Icon(
                    Icons.grid_4x4,
                    color: Colors.grey[400],
                  )
                : null,
          ),
          if (label != null) ...[
            const SizedBox(height: 4),
            Text(
              label!,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ],
      ),
    );
  }
}
