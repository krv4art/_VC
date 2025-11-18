import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';
import '../services/rating_service.dart';

enum DialogStep { initial, rating, feedback }

class RatingRequestDialog extends StatefulWidget {
  const RatingRequestDialog({super.key});

  @override
  State<RatingRequestDialog> createState() => _RatingRequestDialogState();
}

class _RatingRequestDialogState extends State<RatingRequestDialog> {
  DialogStep _currentStep = DialogStep.initial;
  int _rating = 0;
  final TextEditingController _feedbackController = TextEditingController();

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  void _updateRating(int rating) {
    setState(() {
      _rating = rating;
    });
  }

  // --- Step Builders ---

  Widget _buildInitialStep() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.star_rounded,
          size: 64,
          color: Color(0xFFFFC107),
        ),
        const SizedBox(height: 24),
        const Text(
          'Enjoying CV Engineer?',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Help us improve by sharing your experience',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 32),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  setState(() => _currentStep = DialogStep.feedback);
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  ),
                ),
                child: const Text('Not Really'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: () => setState(() => _currentStep = DialogStep.rating),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  ),
                ),
                child: const Text('Yes, I Like It!'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRatingStep() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Rate Our App',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            final starIndex = index + 1;
            return IconButton(
              onPressed: () => _updateRating(starIndex),
              icon: Icon(
                starIndex <= _rating ? Icons.star_rounded : Icons.star_outline_rounded,
                size: 48,
                color: const Color(0xFFFFC107),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        Text(
          _rating > 0 ? '$_rating out of 5' : 'Tap to rate',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _rating > 0
                ? () async {
                    if (_rating == 5) {
                      // High rating - send to store
                      final navigator = Navigator.of(context);
                      await RatingService().markRatingCompleted();

                      // TODO: Replace with actual Play Store/App Store URL
                      final Uri url = Uri.parse(
                        'https://play.google.com/store/apps/details?id=com.your.package',
                      );

                      if (await canLaunchUrl(url)) {
                        await launchUrl(url, mode: LaunchMode.externalApplication);
                      }

                      if (mounted) navigator.pop();
                    } else {
                      // Lower rating - collect feedback
                      setState(() => _currentStep = DialogStep.feedback);
                    }
                  }
                : null,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              ),
            ),
            child: Text(_rating == 5 ? 'Rate on Store' : 'Submit'),
          ),
        ),
      ],
    );
  }

  Widget _buildFeedbackStep() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Help Us Improve',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'We\'re sorry you didn\'t have a great experience. Your feedback helps us improve.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 24),
        TextField(
          controller: _feedbackController,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'What can we improve?',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            ),
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              final scaffold = ScaffoldMessenger.of(context);

              // Mark as completed
              await RatingService().markRatingCompleted();

              // TODO: Send feedback to your backend/analytics
              final feedback = _feedbackController.text;
              debugPrint('User feedback (rating: $_rating): $feedback');

              if (mounted) {
                navigator.pop();
                scaffold.showSnackBar(
                  const SnackBar(
                    content: Text('Thank you for your feedback!'),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              ),
            ),
            child: const Text('Send Feedback'),
          ),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Skip'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    switch (_currentStep) {
      case DialogStep.initial:
        content = _buildInitialStep();
        break;
      case DialogStep.rating:
        content = _buildRatingStep();
        break;
      case DialogStep.feedback:
        content = _buildFeedbackStep();
        break;
    }

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.95, end: 1.0).animate(animation),
              child: child,
            ),
          ),
        },
        child: Container(
          key: ValueKey<DialogStep>(_currentStep),
          padding: const EdgeInsets.all(AppTheme.space24),
          child: content,
        ),
      ),
    );
  }
}
