import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/background_provider.dart';
import '../models/background_result.dart';

class ProcessingScreen extends StatefulWidget {
  const ProcessingScreen({Key? key}) : super(key: key);

  @override
  State<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends State<ProcessingScreen> {
  @override
  void initState() {
    super.initState();
    _listenToProcessing();
  }

  void _listenToProcessing() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BackgroundProvider>().addListener(_onProcessingUpdate);
    });
  }

  void _onProcessingUpdate() {
    final provider = context.read<BackgroundProvider>();
    if (!provider.isProcessing &&
        provider.currentResult?.status == ProcessingStatus.completed) {
      context.go('/result?id=${provider.currentResult?.id}');
    } else if (!provider.isProcessing && provider.errorMessage != null) {
      // Show error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${provider.errorMessage}')),
      );
    }
  }

  @override
  void dispose() {
    context.read<BackgroundProvider>().removeListener(_onProcessingUpdate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Processing'),
        automaticallyImplyLeading: false,
      ),
      body: Consumer<BackgroundProvider>(
        builder: (context, provider, _) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Progress indicator
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: CircularProgressIndicator(
                      value: provider.progress,
                      strokeWidth: 8,
                      backgroundColor: Colors.grey[200],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Progress percentage
                  Text(
                    '${(provider.progress * 100).toInt()}%',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Status message
                  Text(
                    _getStatusMessage(provider.currentResult?.status),
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // Processing steps
                  _buildStepIndicator(
                    'Removing Background',
                    provider.progress >= 0.3,
                    provider.currentResult?.status == ProcessingStatus.removingBackground,
                  ),
                  const SizedBox(height: 12),
                  _buildStepIndicator(
                    'Generating New Background',
                    provider.progress >= 0.7,
                    provider.currentResult?.status == ProcessingStatus.generatingBackground,
                  ),
                  const SizedBox(height: 12),
                  _buildStepIndicator(
                    'Finalizing',
                    provider.progress >= 0.9,
                    false,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _getStatusMessage(ProcessingStatus? status) {
    switch (status) {
      case ProcessingStatus.removingBackground:
        return 'Removing background from your image...';
      case ProcessingStatus.generatingBackground:
        return 'Creating your new background...';
      case ProcessingStatus.completed:
        return 'Almost done!';
      default:
        return 'Processing your image...';
    }
  }

  Widget _buildStepIndicator(String label, bool isComplete, bool isActive) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isComplete
                ? Theme.of(context).colorScheme.primary
                : Colors.grey[300],
          ),
          child: isComplete
              ? const Icon(Icons.check, size: 16, color: Colors.white)
              : null,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              color: isActive ? Colors.black : Colors.grey[600],
            ),
          ),
        ),
      ],
    );
  }
}
