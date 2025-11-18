import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../l10n/app_localizations.dart';
import '../services/rating_service.dart';
import '../config/app_config.dart';
import '../services/telegram_service.dart';
import 'animated_rating_stars.dart';

enum DialogStep { initial, enjoying, feedback }

/// Dialog для запроса оценки приложения Math AI Solver
class RatingRequestDialog extends StatefulWidget {
  const RatingRequestDialog({super.key});

  @override
  State<RatingRequestDialog> createState() => _RatingRequestDialogState();
}

class _RatingRequestDialogState extends State<RatingRequestDialog> {
  DialogStep _currentStep = DialogStep.initial;
  int _rating = 0;
  final TextEditingController _feedbackController = TextEditingController();

  // Цвета для градиента
  static const _primaryGradient = LinearGradient(
    colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
  );

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
    final l10n = AppLocalizations.of(context)!;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          l10n.doYouEnjoyOurApp,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              flex: 2,
              child: TextButton(
                onPressed: () {
                  setState(() => _currentStep = DialogStep.feedback);
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey[700],
                  minimumSize: const Size(0, 50),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(l10n.notReally),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 3,
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  gradient: _primaryGradient,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () => setState(() => _currentStep = DialogStep.enjoying),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(0, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      l10n.yesItsGreat,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEnjoyingStep() {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Emoji placeholder (можно заменить на изображение)
        Text(
          _getEmojiForRating(_rating),
          style: const TextStyle(fontSize: 80),
        ),
        const SizedBox(height: 20),
        Text(
          l10n.rateOurApp,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        AnimatedRatingStars(
          rating: _rating,
          starCount: 5,
          size: 40,
          color: const Color(0xFFFFC107),
          inactiveColor: Colors.grey[400]!,
          onRatingChanged: (rating) => _updateRating(rating),
        ),
        // Подсказка
        Padding(
          padding: const EdgeInsets.only(right: 24, top: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  l10n.bestRatingWeCanGet,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..scale(-1.0, 1.0)
                  ..rotateZ(1.5708),
                child: Icon(
                  Icons.subdirectory_arrow_left,
                  size: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        _buildActionButton(),
      ],
    );
  }

  Widget _buildActionButton() {
    final l10n = AppLocalizations.of(context)!;
    final bool isTopRating = _rating == 5;
    final String text = isTopRating ? l10n.rateOnGooglePlay : l10n.rate;
    final bool isButtonActive = _rating > 0;

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: Container(
        decoration: BoxDecoration(
          gradient: isButtonActive ? _primaryGradient : null,
          color: isButtonActive ? null : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
          boxShadow: isButtonActive
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: ElevatedButton(
          onPressed: isButtonActive
              ? () async {
                  if (isTopRating) {
                    final navigator = Navigator.of(context);
                    await RatingService().markRatingCompleted();

                    // TODO: Заменить на правильный package ID для Math AI Solver
                    final Uri url = Uri.parse(
                      'https://play.google.com/store/apps/details?id=com.mathaisolver.mas',
                    );
                    if (await canLaunchUrl(url)) {
                      await launchUrl(
                        url,
                        mode: LaunchMode.externalApplication,
                      );
                    }
                    if (mounted) navigator.pop();
                  } else {
                    // Низкая оценка - отправляем в Telegram
                    TelegramService().sendNegativeFeedback(
                      rating: _rating,
                      feedback: 'User gave $_rating stars',
                      userInfo: {
                        'Platform': defaultTargetPlatform.toString(),
                        'Step': 'Rating step',
                      },
                    );
                    setState(() {
                      _currentStep = DialogStep.feedback;
                    });
                  }
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: isButtonActive ? Colors.transparent : Colors.grey[300],
            disabledBackgroundColor: Colors.grey[300],
            shadowColor: Colors.transparent,
            foregroundColor: isButtonActive ? Colors.white : Colors.grey[600],
            minimumSize: const Size(0, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isButtonActive ? Colors.white : Colors.grey[600],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeedbackStep() {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          l10n.whatCanBeImproved,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        Text(
          l10n.wereSorryYouDidntHaveAGreatExperience,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[700],
              ),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _feedbackController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: l10n.yourFeedback,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[400]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFF667EEA),
                width: 2,
              ),
            ),
            filled: true,
            fillColor: Colors.grey[100],
            hintStyle: TextStyle(color: Colors.grey[500]),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: Container(
            decoration: BoxDecoration(
              gradient: _primaryGradient,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () async {
                final navigator = Navigator.of(context);

                await RatingService().markRatingCompleted();

                // Отправляем в Telegram
                final feedbackText = _feedbackController.text;
                debugPrint('Feedback submitted: $feedbackText');

                TelegramService().sendNegativeFeedback(
                  rating: _rating,
                  feedback: feedbackText,
                  userInfo: {
                    'Platform': defaultTargetPlatform.toString(),
                    'Step': _rating > 0
                        ? 'Rating: $_rating stars'
                        : 'Initial (Not Really button)',
                  },
                );

                if (mounted) navigator.pop();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.thankYouForYourFeedback),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                foregroundColor: Colors.white,
                minimumSize: const Size(0, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  l10n.sendFeedback,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () => context.pop(),
          style: TextButton.styleFrom(
            foregroundColor: Colors.grey[700],
          ),
          child: FittedBox(fit: BoxFit.scaleDown, child: Text(l10n.cancel)),
        ),
      ],
    );
  }

  String _getEmojiForRating(int rating) {
    switch (rating) {
      case 0:
        return '😊';
      case 1:
        return '😡';
      case 2:
        return '😞';
      case 3:
        return '😐';
      case 4:
        return '🙂';
      case 5:
        return '😍';
      default:
        return '😊';
    }
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
        borderRadius: BorderRadius.circular(24),
      ),
      elevation: 8,
      backgroundColor: Colors.white,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
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
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: content,
        ),
      ),
    );
  }
}
