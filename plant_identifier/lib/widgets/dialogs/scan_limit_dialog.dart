import 'package:flutter/material.dart';

/// Dialog shown when scan limit is reached
void showScanLimitDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.warning_amber, color: Colors.orange),
          SizedBox(width: 8),
          Text('Scan Limit Reached'),
        ],
      ),
      content: const Text(
        'You have reached your daily scan limit. Please try again tomorrow or upgrade to premium for unlimited scans.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}
