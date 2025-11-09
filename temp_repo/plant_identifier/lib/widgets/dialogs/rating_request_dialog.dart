import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/rating_service.dart';

/// Rating request dialog
class RatingRequestDialog extends StatelessWidget {
  final VoidCallback? onRateNow;
  final VoidCallback? onLater;
  final VoidCallback? onNever;

  const RatingRequestDialog({
    super.key,
    this.onRateNow,
    this.onLater,
    this.onNever,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.space24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.star,
                size: 48,
                color: Colors.amber,
              ),
            ),
            const SizedBox(height: AppTheme.space16),

            // Title
            Text(
              'Enjoying Plant Identifier?',
              style: AppTheme.h3.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.space12),

            // Message
            Text(
              'Your feedback helps us improve and reach more plant lovers!',
              style: AppTheme.body.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.space24),

            // Star rating preview
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return const Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 32,
                );
              }),
            ),
            const SizedBox(height: AppTheme.space24),

            // Rate Now button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onRateNow,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppTheme.space16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusCard),
                  ),
                ),
                child: const Text(
                  'Rate Now',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppTheme.space12),

            // Later button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: onLater,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppTheme.space16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusCard),
                  ),
                ),
                child: const Text(
                  'Maybe Later',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: AppTheme.space8),

            // Never button
            TextButton(
              onPressed: onNever,
              child: Text(
                'Don\'t ask again',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Show rating dialog
Future<void> showRatingDialog(BuildContext context) async {
  final ratingService = RatingService();

  // Check if should show
  final shouldShow = await ratingService.shouldShowRatingDialog();
  if (!shouldShow) return;

  if (!context.mounted) return;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => RatingRequestDialog(
      onRateNow: () async {
        await ratingService.openAppStore();
        if (ctx.mounted) Navigator.pop(ctx);
      },
      onLater: () async {
        await ratingService.markRatingDeclined();
        if (ctx.mounted) Navigator.pop(ctx);
      },
      onNever: () async {
        await ratingService.markRatingShown();
        if (ctx.mounted) Navigator.pop(ctx);
      },
    ),
  );
}
