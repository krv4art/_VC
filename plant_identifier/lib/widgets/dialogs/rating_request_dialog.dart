import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../l10n/app_localizations.dart';
import '../../services/rating_service.dart';
import '../../theme/app_theme.dart';
import '../../constants/app_dimensions.dart';
import '../animated_rating_stars.dart';

enum DialogStep { initial, enjoying, feedback }

class RatingRequestDialog extends StatefulWidget {
  const RatingRequestDialog({super.key});

  @override
  State<RatingRequestDialog> createState() => _RatingRequestDialogState();
}

class _RatingRequestDialogState extends State<RatingRequestDialog> {
  DialogStep _currentStep = DialogStep.initial;
  int _rating = 0;
  String _imageAsset = 'assets/images/figma/0.png';
  final TextEditingController _feedbackController = TextEditingController();

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  void _updateRating(int rating) {
    setState(() {
      _rating = rating;
      _imageAsset = 'assets/images/figma/$rating.png';
    });
  }

  // --- Step Builders ---

  Widget _buildInitialStep() {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          l10n.doYouEnjoyOurApp,
          textAlign: TextAlign.center,
          style: AppTheme.h3.copyWith(
            color: colors.onSurface,
          ),
        ),
        const SizedBox(height: AppTheme.space24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              flex: 2, // "No" button takes 2 parts
              child: TextButton(
                onPressed: () {
                  setState(() => _currentStep = DialogStep.feedback);
                },
                style: TextButton.styleFrom(
                  foregroundColor: colors.onSurface,
                  textStyle: AppTheme.button.copyWith(
                    fontSize: AppDimensions.space16,
                  ),
                  minimumSize: Size(0, AppDimensions.space48 + 2),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(l10n.notReally),
                ),
              ),
            ),
            const SizedBox(width: AppTheme.space12),
            Expanded(
              flex: 3, // "Yes" button takes 3 parts
              child: ElevatedButton(
                onPressed: () =>
                    setState(() => _currentStep = DialogStep.enjoying),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                  foregroundColor: colors.onPrimary,
                  minimumSize: Size(0, AppDimensions.space48 + 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radius12),
                  ),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    l10n.yesItsGreat,
                    style: AppTheme.button.copyWith(
                      fontSize: AppDimensions.space16,
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
    final colors = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: AppDimensions.space64 + AppDimensions.space48 + AppDimensions.space8,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: Image.asset(
              _imageAsset,
              key: ValueKey<String>(_imageAsset),
              height: AppDimensions.space64 + AppDimensions.space48 + AppDimensions.space8,
              errorBuilder: (context, error, stackTrace) {
                // Fallback to icon if image not found
                return Icon(
                  Icons.emoji_emotions,
                  size: AppDimensions.space64,
                  color: colors.primary,
                );
              },
            ),
          ),
        ),
        SizedBox(height: AppDimensions.space16 + AppDimensions.space4),
        Text(
          l10n.rateOurApp,
          textAlign: TextAlign.center,
          style: AppTheme.h3.copyWith(
            color: colors.onSurface,
          ),
        ),
        const SizedBox(height: AppTheme.space12),
        AnimatedRatingStars(
          rating: _rating,
          starCount: 5,
          size: AppDimensions.iconLarge + AppDimensions.space4,
          color: const Color(0xFFFFC107), // Amber color
          inactiveColor: colors.onSurface.withOpacity(0.3),
          onRatingChanged: (rating) => _updateRating(rating),
        ),
        // Hint under stars
        Padding(
          padding: EdgeInsets.only(right: AppTheme.space24),
          child: SizedBox(
            width: 5 * (AppDimensions.iconLarge + AppDimensions.space4 + AppDimensions.space16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: AppDimensions.space4,
                      left: AppDimensions.space16,
                    ),
                    child: Text(
                      l10n.bestRatingWeCanGet,
                      textAlign: TextAlign.right,
                      style: AppTheme.caption.copyWith(
                        color: colors.onSurface.withOpacity(0.6),
                        fontSize: AppDimensions.space12,
                      ),
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ),
                const SizedBox(width: AppDimensions.space4),
                Padding(
                  padding: EdgeInsets.zero,
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..scale(-1.0, 1.0) // Mirror horizontally
                      ..rotateZ(1.5708), // 90 degrees counterclockwise
                    child: Icon(
                      Icons.subdirectory_arrow_left,
                      size: AppDimensions.iconSmall,
                      color: colors.onSurface.withOpacity(0.6),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppTheme.space24),
        // Action button (always visible)
        _buildActionButton(),
      ],
    );
  }

  Widget _buildActionButton() {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final bool isTopRating = _rating == 5;
    final String text = isTopRating ? l10n.rateOnGooglePlay : l10n.rate;
    final bool isButtonActive = _rating > 0;

    return SizedBox(
      width: double.infinity,
      height: AppDimensions.space48 + 2,
      child: ElevatedButton(
        onPressed: isButtonActive
            ? () async {
                if (isTopRating) {
                  // Save navigator BEFORE async operations
                  final navigator = Navigator.of(context);

                  // User gave 5 stars - mark rating as completed
                  await RatingService().markRatingCompleted();

                  // TODO: Replace with your actual Google Play package ID
                  final Uri url = Uri.parse(
                    'https://play.google.com/store/apps/details?id=com.plantidentifier.app',
                  );
                  if (await canLaunchUrl(url)) {
                    await launchUrl(
                      url,
                      mode: LaunchMode.externalApplication,
                    );
                  }
                  if (mounted) navigator.pop();
                } else {
                  // Low rating (1-4 stars) - show feedback form
                  setState(() {
                    _currentStep = DialogStep.feedback;
                  });
                }
              }
            : null, // Button inactive until rating is selected
        style: ElevatedButton.styleFrom(
          backgroundColor: isButtonActive ? colors.primary : colors.surface,
          disabledBackgroundColor: colors.surface.withOpacity(0.5),
          foregroundColor: isButtonActive ? colors.onPrimary : colors.onSurface.withOpacity(0.5),
          minimumSize: Size(0, AppDimensions.space48 + 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radius12),
          ),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            text,
            style: AppTheme.button.copyWith(
              color: isButtonActive ? colors.onPrimary : colors.onSurface.withOpacity(0.5),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeedbackStep() {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          l10n.whatCanBeImproved,
          textAlign: TextAlign.center,
          style: AppTheme.h3.copyWith(
            color: colors.onSurface,
          ),
        ),
        const SizedBox(height: AppTheme.space12),
        Text(
          l10n.wereSorryYouDidntHaveAGreatExperience,
          textAlign: TextAlign.center,
          style: AppTheme.body.copyWith(
            color: colors.onSurface,
          ),
        ),
        SizedBox(height: AppDimensions.space16 + AppDimensions.space4),
        TextField(
          controller: _feedbackController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: l10n.yourFeedback,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radius12),
              borderSide: BorderSide(
                color: colors.onSurface.withOpacity(0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radius12),
              borderSide: BorderSide(
                color: colors.primary,
                width: 2,
              ),
            ),
            filled: true,
            fillColor: colors.surface,
            hintStyle: AppTheme.body.copyWith(
              color: colors.onSurface.withOpacity(0.5),
            ),
          ),
        ),
        SizedBox(height: AppDimensions.space16 + AppDimensions.space4),
        SizedBox(
          width: double.infinity,
          height: AppDimensions.space48 + 2,
          child: ElevatedButton(
            onPressed: () async {
              // Save values from context BEFORE async operations
              final scaffold = ScaffoldMessenger.of(context);
              final navigator = Navigator.of(context);
              final localizations = l10n;

              // User sent feedback - mark rating as completed
              await RatingService().markRatingCompleted();

              // Log feedback (in production, send to your backend)
              final feedbackText = _feedbackController.text;
              debugPrint('Feedback submitted: $feedbackText');
              debugPrint('Rating: $_rating stars');

              if (mounted) navigator.pop();
              if (mounted) {
                scaffold.showSnackBar(
                  SnackBar(
                    content: Text(
                      localizations.thankYouForYourFeedback,
                      style: AppTheme.body,
                    ),
                    backgroundColor: colors.surface,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.primary,
              foregroundColor: colors.onPrimary,
              minimumSize: Size(0, AppDimensions.space48 + 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radius12),
              ),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                l10n.sendFeedback,
                style: AppTheme.button,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppTheme.space8),
        TextButton(
          onPressed: () => context.pop(),
          style: TextButton.styleFrom(
            foregroundColor: colors.onSurface,
            textStyle: AppTheme.button.copyWith(
              fontSize: AppDimensions.space16,
            ),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(l10n.cancel),
          ),
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
      elevation: AppTheme.space8,
      backgroundColor: Theme.of(context).colorScheme.surface,
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
          padding: EdgeInsets.all(AppDimensions.space24),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radius24),
          ),
          child: content,
        ),
      ),
    );
  }
}
