import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// Dialog with scanning hints for better results
void showScanningHintDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.tips_and_updates, color: Colors.blue),
          SizedBox(width: 8),
          Text('Scanning Tips'),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'For best results:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppTheme.space12),
            _buildTip('📸', 'Take a clear, well-lit photo'),
            _buildTip('🌿', 'Include leaves and flowers if possible'),
            _buildTip('📏', 'Get close enough to see details'),
            _buildTip('🎯', 'Center the plant in the frame'),
            _buildTip('☀️', 'Use natural lighting when available'),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Got it!'),
        ),
      ],
    ),
  );
}

Widget _buildTip(String emoji, String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: AppTheme.space8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 18)),
        const SizedBox(width: AppTheme.space8),
        Expanded(child: Text(text)),
      ],
    ),
  );
}
