import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import '../providers/background_provider.dart';
import '../models/background_result.dart';

class ResultScreen extends StatefulWidget {
  final String? resultId;

  const ResultScreen({Key? key, this.resultId}) : super(key: key);

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  BackgroundResult? _result;

  @override
  void initState() {
    super.initState();
    _loadResult();
  }

  Future<void> _loadResult() async {
    final provider = context.read<BackgroundProvider>();
    if (widget.resultId != null) {
      final result = provider.history.firstWhere(
        (r) => r.id == widget.resultId,
        orElse: () => provider.currentResult!,
      );
      setState(() {
        _result = result;
      });
    } else {
      setState(() {
        _result = provider.currentResult;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_result == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Result'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.go('/'),
        ),
        actions: [
          IconButton(
            icon: Icon(_result!.isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: () {
              context.read<BackgroundProvider>().toggleFavorite(_result!.id);
              setState(() {
                _result = _result!.copyWith(isFavorite: !_result!.isFavorite);
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareImage,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: _result!.processedImagePath != null
                  ? Image.file(
                      File(_result!.processedImagePath!),
                      fit: BoxFit.contain,
                    )
                  : const Text('No processed image available'),
            ),
          ),
          _buildBottomActions(),
        ],
      ),
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => context.go('/select-image'),
              icon: const Icon(Icons.add_photo_alternate),
              label: const Text('Try Another'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => context.push('/chat'),
              icon: const Icon(Icons.chat),
              label: const Text('Ask AI'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _shareImage() async {
    if (_result?.processedImagePath != null) {
      await Share.shareXFiles([XFile(_result!.processedImagePath!)]);
    }
  }
}
