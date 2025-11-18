import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_dimensions.dart';
import '../widgets/common/app_spacer.dart';
import '../services/rating_service.dart';

enum DialogStep { initial, enjoying, feedback }

class RatingDialog extends StatefulWidget {
  const RatingDialog({Key? key}) : super(key: key);

  @override
  State<RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
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

  @override
  Widget build(BuildContext context) {
    Widget content;
    switch (_currentStep) {
      case DialogStep.initial:
        content = _buildInitialStep();
        break;
      case DialogStep.enjoying:
        content = _buildEnjoyingStep();
        break;
      case DialogStep.feedback:
        content = _buildFeedbackStep();
        break;
    }

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radius24),
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.95, end: 1.0).animate(animation),
              child: child,
            ),
          );
        },
        child: Container(
          key: ValueKey<DialogStep>(_currentStep),
          padding: const EdgeInsets.all(AppDimensions.space24),
          child: content,
        ),
      ),
    );
  }

  Widget _buildInitialStep() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Do you enjoy our app?',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        AppSpacer.v24(),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextButton(
                onPressed: () => setState(() => _currentStep = DialogStep.feedback),
                child: const Text('Not really'),
              ),
            ),
            AppSpacer.h12(),
            Expanded(
              flex: 3,
              child: ElevatedButton(
                onPressed: () => setState(() => _currentStep = DialogStep.enjoying),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6B4EFF),
                ),
                child: const Text('Yes, it\'s great!'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEnjoyingStep() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Rate our app',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        AppSpacer.v24(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            final starIndex = index + 1;
            return IconButton(
              icon: Icon(
                starIndex <= _rating ? Icons.star : Icons.star_border,
                color: Colors.amber,
                size: 40,
              ),
              onPressed: () => _updateRating(starIndex),
            );
          }),
        ),
        const Text(
          'Best rating we can get →',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        AppSpacer.v24(),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _rating > 0
                ? () async {
                    if (_rating == 5) {
                      await RatingService().markRatingCompleted();
                      final Uri url = Uri.parse(
                        'https://play.google.com/store/apps',
                      );
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url, mode: LaunchMode.externalApplication);
                      }
                      if (mounted) Navigator.pop(context);
                    } else {
                      setState(() => _currentStep = DialogStep.feedback);
                    }
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6B4EFF),
            ),
            child: Text(_rating == 5 ? 'Rate on Google Play' : 'Rate'),
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
          'What can be improved?',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        AppSpacer.v12(),
        const Text(
          'We\'re sorry you didn\'t have a great experience.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
        AppSpacer.v16(),
        TextField(
          controller: _feedbackController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Your feedback',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radius12),
            ),
          ),
        ),
        AppSpacer.v16(),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              await RatingService().markRatingCompleted();
              // TODO: Send feedback to backend
              if (mounted) Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Thank you for your feedback!')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6B4EFF),
            ),
            child: const Text('Send Feedback'),
          ),
        ),
        AppSpacer.v8(),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
