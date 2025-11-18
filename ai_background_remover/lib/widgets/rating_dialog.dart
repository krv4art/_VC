import 'package:flutter/material.dart';
import '../services/rating_service.dart';
import '../theme/app_theme.dart';

class RatingDialog extends StatefulWidget {
  const RatingDialog({super.key});

  @override
  State<RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  final RatingService _ratingService = RatingService();
  int _rating = 0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.star,
              size: 48,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Enjoying the app?',
            textAlign: TextAlign.center,
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Would you mind taking a moment to rate it?',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return IconButton(
                onPressed: () {
                  setState(() {
                    _rating = index + 1;
                  });
                },
                icon: Icon(
                  index < _rating ? Icons.star : Icons.star_border,
                  color: const Color(0xFFFFD700),
                  size: 40,
                ),
              );
            }),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            _ratingService.recordPromptShown();
            Navigator.pop(context);
          },
          child: const Text('Maybe Later'),
        ),
        ElevatedButton(
          onPressed: _rating > 0
              ? () async {
                  if (_rating >= 4) {
                    await _ratingService.openAppStore();
                  }
                  await _ratingService.markAsRated();
                  await _ratingService.recordPromptShown();
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                }
              : null,
          child: const Text('Rate Now'),
        ),
      ],
    );
  }
}
