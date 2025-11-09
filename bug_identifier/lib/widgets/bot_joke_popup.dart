import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/bot_joke_message.dart';
import '../theme/theme_extensions_v2.dart';
import '../constants/app_dimensions.dart';
import '../widgets/common/app_spacer.dart';

/// Виджет для отображения всплывающего сообщения от смеющегося бота
/// Показывается вместо SnackBar при обнаружении не-косметического объекта
class BotJokePopup extends StatefulWidget {
  final BotJokeMessage message;
  final VoidCallback onDismiss;

  const BotJokePopup({
    super.key,
    required this.message,
    required this.onDismiss,
  });

  @override
  State<BotJokePopup> createState() => _BotJokePopupState();
}

class _BotJokePopupState extends State<BotJokePopup>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _bubbleController;

  late Animation<double> _slideAnimation;
  late Animation<double> _bubbleFadeAnimation;
  late Animation<double> _bubbleScaleAnimation;

  @override
  void initState() {
    super.initState();

    // Инициализация контроллеров анимации
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _bubbleController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    // Настройка анимаций
    _slideAnimation = CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    );

    _bubbleFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _bubbleController, curve: Curves.easeIn));

    _bubbleScaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _bubbleController, curve: Curves.elasticOut),
    );

    // Запуск последовательности анимаций
    _startAnimationSequence();

    // Автоматическое закрытие через 6 секунд
    Future.delayed(const Duration(seconds: 6), () {
      if (mounted) {
        _dismiss();
      }
    });
  }

  void _startAnimationSequence() async {
    // Сначала slide down
    await _slideController.forward();

    // Затем fade + scale облачка
    if (mounted) {
      _bubbleController.forward();
    }
  }

  Future<void> _dismiss() async {
    // Slide up анимация выхода
    await _slideController.reverse();

    // Callback для закрытия
    widget.onDismiss();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _bubbleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('=== BotJokePopup.build() ===');
    debugPrint('jokeText: ${widget.message.jokeText}');

    try {
      return SafeArea(
        child: AnimatedBuilder(
          animation: _slideAnimation,
          builder: (context, child) {
            return Positioned(
              top:
                  -(AppDimensions.space64 +
                      AppDimensions.space32 +
                      AppDimensions.space4) +
                  (AppDimensions.space64 +
                          AppDimensions.space32 +
                          AppDimensions.space4 +
                          AppDimensions.space16) *
                      _slideAnimation.value, // от -100 до 16
              left: AppDimensions.space16,
              right: AppDimensions.space16,
              child: child!,
            );
          },
          child: _buildContent(),
        ),
      );
    } catch (e, stackTrace) {
      debugPrint('=== ERROR in BotJokePopup.build() ===');
      debugPrint('Error: $e');
      debugPrint('StackTrace: $stackTrace');
      // Возвращаем пустой контейнер в случае ошибки
      return const SizedBox.shrink();
    }
  }

  Widget _buildContent() {
    debugPrint('=== _buildContent() ===');
    try {
      return Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.3,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildChatBubble(),
            AppSpacer.v8(),
            Text(
              widget.message.botName,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: context.colors.onSurface,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      );
    } catch (e) {
      debugPrint('ERROR in _buildContent: $e');
      rethrow;
    }
  }

  Widget _buildChatBubble() {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _bubbleFadeAnimation,
        _bubbleScaleAnimation,
      ]),
      builder: (context, child) {
        return FadeTransition(
          opacity: _bubbleFadeAnimation,
          child: ScaleTransition(
            scale: _bubbleScaleAnimation,
            child: _buildBubbleContent(),
          ),
        );
      },
    );
  }

  Widget _buildBubbleContent() {
    return Stack(
      children: [
        // CustomPaint для фона с хвостиком
        CustomPaint(
          painter: ChatBubblePainter(
            color: context.colors.surface,
            shadowColor: Colors.black.withValues(alpha: 0.1),
          ),
          child: Container(
            padding: EdgeInsets.all(AppDimensions.space12),
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(right: AppDimensions.space24),
                  child: Text(
                    widget.message.jokeText,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: context.colors.onSurface,
                    ),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      _dismiss();
                    },
                    child: Container(
                      width: AppDimensions.avatarSmall,
                      height: AppDimensions.avatarSmall,
                      decoration: BoxDecoration(
                        color: context.colors.onSurface.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        size: AppDimensions.iconSmall - 2,
                        color: context.colors.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// CustomPainter для рисования облачка с "хвостиком"
class ChatBubblePainter extends CustomPainter {
  final Color color;
  final Color shadowColor;

  ChatBubblePainter({required this.color, required this.shadowColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final shadowPaint = Paint()
      ..color = shadowColor
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    final path = Path();
    final radius = AppDimensions.radius16;

    // Рисуем тень
    final shadowPath = Path();
    shadowPath.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(radius),
      ),
    );
    canvas.drawPath(shadowPath, shadowPaint);

    // Рисуем основное облачко
    path.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(radius),
      ),
    );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
