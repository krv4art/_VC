import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:bug_identifier/theme/app_theme.dart';
import 'package:bug_identifier/theme/theme_extensions_v2.dart';
import '../l10n/app_localizations.dart';
import '../services/rating_service.dart';
import '../config/app_config.dart';
import '../services/telegram_service.dart';
import 'animated_rating_stars.dart';
import '../constants/app_dimensions.dart';
import 'common/app_spacer.dart';

enum DialogStep { initial, enjoying, feedback }

class RatingRequestDialog extends StatefulWidget {
  const RatingRequestDialog({super.key});

  @override
  State<RatingRequestDialog> createState() => _RatingRequestDialogState();
}

class _RatingRequestDialogState extends State<RatingRequestDialog> {
  DialogStep _currentStep = DialogStep.initial;
  int _rating = 0;
  String _imageAsset = 'figma/0.png';
  final TextEditingController _feedbackController = TextEditingController();

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  void _updateRating(int rating) {
    setState(() {
      _rating = rating;
      _imageAsset = 'figma/$rating.png';
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
          style: AppTheme.h3.copyWith(
            color: context.colors.onBackground,
          ), // Use theme typography
        ),
        AppSpacer.v24(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              flex: 2, // Кнопка "Нет" занимает 2 части (на треть меньше чем 3)
              child: TextButton(
                onPressed: () {
                  // Просто переходим к шагу обратной связи без отправки в Telegram
                  setState(() => _currentStep = DialogStep.feedback);
                },
                style: TextButton.styleFrom(
                  foregroundColor: context.colors.onSurface, // Adapts to theme
                  textStyle: AppTheme.button.copyWith(
                    fontSize: AppDimensions.space16,
                  ), // Use theme typography
                  minimumSize: Size(0, AppDimensions.buttonLarge + 2),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(l10n.notReally),
                ),
              ),
            ),
            AppSpacer.h12(),
            Expanded(
              flex:
                  3, // Кнопка "Нравится" занимает 3 части (на треть больше чем 2)
              child: Container(
                // Wrap ElevatedButton for gradient and shadow
                height: AppDimensions.buttonLarge + 2,
                decoration: BoxDecoration(
                  gradient: context.colors.primaryGradient,
                  borderRadius: BorderRadius.circular(AppDimensions.radius12),
                  boxShadow: [
                    BoxShadow(
                      color: context.colors.shadowColor.withValues(alpha: 0.4),
                      blurRadius: AppDimensions.space16,
                      offset: const Offset(0, AppDimensions.space8),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () =>
                      setState(() => _currentStep = DialogStep.enjoying),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.transparent, // Make transparent to show gradient
                    shadowColor: Colors.transparent, // Remove elevation shadow
                    foregroundColor: Colors.white,
                    minimumSize: Size(0, AppDimensions.buttonLarge + 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radius12,
                      ),
                    ),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      l10n.yesItsGreat,
                      style: AppTheme.button.copyWith(
                        fontSize: AppDimensions.space16,
                      ),
                    ), // Use theme typography
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
        SizedBox(
          height:
              AppDimensions.space64 +
              AppDimensions.space48 +
              AppDimensions.space8,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: Image.asset(
              _imageAsset,
              key: ValueKey<String>(_imageAsset),
              height:
                  AppDimensions.space64 +
                  AppDimensions.space48 +
                  AppDimensions.space8,
            ),
          ),
        ),
        SizedBox(height: AppDimensions.space16 + AppDimensions.space4),
        Text(
          l10n.rateOurApp,
          textAlign: TextAlign.center,
          style: AppTheme.h3.copyWith(
            color: context.colors.onBackground,
          ), // Use theme typography
        ),
        AppSpacer.v12(),
        AnimatedRatingStars(
          rating: _rating,
          starCount: 5,
          size: AppDimensions.iconLarge + AppDimensions.space4,
          color: const Color(0xFFFFC107), // Желтый цвет как в Natural теме
          inactiveColor: context.colors.neutral,
          onRatingChanged: (rating) => _updateRating(rating),
        ),
        //const SizedBox(height: 4), // Уменьшенный отступ между звездами и текстом
        // Подсказка под звездочками
        // Ширина = 5 звезд * (размер звезды + отступ IconButton)
        // IconButton добавляет padding по 8px с каждой стороны = 16px на кнопку
        Padding(
          padding: EdgeInsets.only(right: AppDimensions.space24),
          child: SizedBox(
            width:
                5 *
                (AppDimensions.iconLarge +
                    AppDimensions.space4 +
                    AppDimensions.space16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Выравнивание по верхнему краю
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
                        color: context.colors.neutral,
                        fontSize: AppDimensions.space12,
                      ),
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ),
                AppSpacer.h4(),
                Padding(
                  padding: EdgeInsets.zero,
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..scale(-1.0, 1.0) // Зеркально по горизонтали
                      ..rotateZ(1.5708), // 90 градусов против часовой стрелки
                    child: Icon(
                      Icons.subdirectory_arrow_left,
                      size: AppDimensions.iconSmall,
                      color: context.colors.neutral,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        AppSpacer.v24(),
        // Кнопка всегда видна
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
      height: AppDimensions.buttonLarge + 2,
      child: Container(
        decoration: BoxDecoration(
          gradient: isButtonActive ? context.colors.primaryGradient : null,
          color: isButtonActive ? null : context.colors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radius12),
          boxShadow: isButtonActive
              ? [
                  BoxShadow(
                    color: context.colors.shadowColor.withValues(alpha: 0.4),
                    blurRadius: AppDimensions.space16,
                    offset: const Offset(0, AppDimensions.space8),
                  ),
                ]
              : [], // Use theme shadow only when button is active
        ),
        child: ElevatedButton(
          onPressed: isButtonActive
              ? () async {
                  if (isTopRating) {
                    // Сохраняем navigator ДО асинхронных операций
                    final navigator = Navigator.of(context);

                    // Пользователь поставил 5 звезд - отмечаем оценку как завершенную
                    await RatingService().markRatingCompleted();

                    final Uri url = Uri.parse(
                      'https://play.google.com/store/apps/details?id=${AppConfig().googlePlayPackageId}',
                    );
                    if (await canLaunchUrl(url)) {
                      await launchUrl(
                        url,
                        mode: LaunchMode.externalApplication,
                      );
                    }
                    if (mounted) navigator.pop();
                  } else {
                    // Низкая оценка (1-4 звезды) - отправляем в Telegram
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
              : null, // Кнопка неактивна, пока не выбрана оценка
          style: ElevatedButton.styleFrom(
            backgroundColor: isButtonActive
                ? Colors
                      .transparent // Make transparent to show gradient
                : context.colors.surface,
            disabledBackgroundColor: context.colors.surface.withValues(
              alpha: 0.5,
            ),
            shadowColor: Colors.transparent, // Remove elevation shadow
            foregroundColor: isButtonActive
                ? Colors.white
                : context.colors.onSurface.withValues(alpha: 0.5),
            minimumSize: Size(0, AppDimensions.buttonLarge + 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radius12),
            ),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              text,
              style: AppTheme.button.copyWith(
                color: isButtonActive
                    ? Colors.white
                    : context.colors.onSurface.withValues(alpha: 0.5),
              ),
            ), // Use theme typography
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
          style: AppTheme.h3.copyWith(
            color: context.colors.onBackground,
          ), // Use theme typography
        ),
        AppSpacer.v12(),
        Text(
          l10n.wereSorryYouDidntHaveAGreatExperience,
          textAlign: TextAlign.center,
          style: AppTheme.body.copyWith(
            color: context.colors.onSurface,
          ), // Use theme typography and color
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
                color: context.colors.neutral,
              ), // Use theme color
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radius12),
              borderSide: BorderSide(
                color: context.colors.primary,
                width: 2,
              ), // Use theme color
            ),
            filled: true, // Ensure filled is true for fillColor to work
            fillColor: context.colors.surface, // Use theme color
            hintStyle: AppTheme.body.copyWith(
              color: context.colors.neutral,
            ), // Use theme typography and color
          ),
        ),
        SizedBox(height: AppDimensions.space16 + AppDimensions.space4),
        SizedBox(
          // Wrap ElevatedButton for gradient and shadow
          width: double.infinity,
          height: AppDimensions.buttonLarge + 2,
          child: Container(
            decoration: BoxDecoration(
              gradient: context.colors.primaryGradient,
              borderRadius: BorderRadius.circular(AppDimensions.radius12),
              boxShadow: [
                BoxShadow(
                  color: context.colors.shadowColor.withValues(alpha: 0.4),
                  blurRadius: AppDimensions.space16,
                  offset: const Offset(0, AppDimensions.space8),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () async {
                // Сохраняем значения из context ДО асинхронных операций
                final scaffold = ScaffoldMessenger.of(context);
                final navigator = Navigator.of(context);
                final localizations = l10n;
                final surfaceColor = context.colors.surface;
                final onSurfaceColor = context.colors.onSurface;

                // Пользователь отправил фидбек - отмечаем оценку как завершенную
                await RatingService().markRatingCompleted();

                // Отправка негативного отзыва в Telegram
                final feedbackText = _feedbackController.text;
                debugPrint('Feedback submitted: $feedbackText');

                // Отправляем в Telegram (не блокируем UI)
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
                  scaffold.showSnackBar(
                    SnackBar(
                      content: Text(
                        localizations.thankYouForYourFeedback,
                        style: AppTheme.body.copyWith(color: onSurfaceColor),
                      ), // Use theme typography
                      backgroundColor: surfaceColor, // Use theme color
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.transparent, // Make transparent to show gradient
                shadowColor: Colors.transparent, // Remove elevation shadow
                foregroundColor: Colors.white,
                minimumSize: Size(0, AppDimensions.buttonLarge + 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radius12),
                ),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  l10n.sendFeedback,
                  style: AppTheme.button,
                ), // Use theme typography
              ),
            ),
          ),
        ),
        AppSpacer.v8(),
        TextButton(
          onPressed: () => context.pop(),
          style: TextButton.styleFrom(
            foregroundColor: context.colors.onSurface, // Adapts to theme
            textStyle: AppTheme.button.copyWith(
              fontSize: AppDimensions.space16,
            ), // Use theme typography
          ),
          child: FittedBox(fit: BoxFit.scaleDown, child: Text(l10n.cancel)),
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
      elevation: AppDimensions.space8,
      backgroundColor: context.colors.surface,
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
            color: context.colors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radius24),
          ),
          child: content,
        ),
      ),
    );
  }
}
