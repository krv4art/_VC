import 'package:flutter/material.dart';
import '../../theme/theme_extensions_v2.dart';
import '../../constants/app_dimensions.dart';

/// Универсальная анимированная кнопка с различными эффектами
class AnimatedButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final Duration duration;
  final double scaleAmount;
  final double? elevation;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;
  final BorderSide? borderSide;
  final ButtonType buttonType;
  final AnimationStyle animationStyle;

  const AnimatedButton({
    super.key,
    required this.child,
    this.onPressed,
    this.onLongPress,
    this.duration = const Duration(milliseconds: 200),
    this.scaleAmount = 0.95,
    this.elevation,
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius,
    this.padding,
    this.borderSide,
    this.buttonType = ButtonType.elevated,
    this.animationStyle = AnimationStyle.scale,
  });

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _controller = AnimationController(duration: widget.duration, vsync: this);

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scaleAmount,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _elevationAnimation = Tween<double>(
      begin: widget.elevation ?? 4.0,
      end: (widget.elevation ?? 4.0) * 0.5,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Анимация цвета при нажатии
    final effectiveBackgroundColor = widget.backgroundColor;
    if (effectiveBackgroundColor != null) {
      _colorAnimation = ColorTween(
        begin: effectiveBackgroundColor,
        end: effectiveBackgroundColor.withValues(alpha: 0.8),
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    }
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onPressed != null) {
      _controller.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.onPressed != null) {
      _controller.reverse();
      widget.onPressed?.call();
    }
  }

  void _handleTapCancel() {
    if (widget.onPressed != null) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor =
        widget.backgroundColor ?? context.colors.primary;
    final effectiveForegroundColor =
        widget.foregroundColor ?? context.colors.onPrimary;
    final effectiveBorderRadius =
        widget.borderRadius ?? BorderRadius.circular(12.0);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        Widget buttonWidget;

        switch (widget.buttonType) {
          case ButtonType.elevated:
            buttonWidget = ElevatedButton(
              onPressed: widget.onPressed,
              onLongPress: widget.onLongPress,
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.animationStyle == AnimationStyle.color
                    ? _colorAnimation.value
                    : effectiveBackgroundColor,
                foregroundColor: effectiveForegroundColor,
                elevation: widget.animationStyle == AnimationStyle.elevation
                    ? _elevationAnimation.value
                    : widget.elevation ?? 4.0,
                padding: widget.padding,
                shape: RoundedRectangleBorder(
                  borderRadius: effectiveBorderRadius,
                ),
              ),
              child: widget.child,
            );
            break;
          case ButtonType.outlined:
            buttonWidget = OutlinedButton(
              onPressed: widget.onPressed,
              onLongPress: widget.onLongPress,
              style: OutlinedButton.styleFrom(
                foregroundColor: effectiveForegroundColor,
                side:
                    widget.borderSide ??
                    BorderSide(color: effectiveBackgroundColor),
                padding: widget.padding,
                shape: RoundedRectangleBorder(
                  borderRadius: effectiveBorderRadius,
                ),
              ),
              child: widget.child,
            );
            break;
          case ButtonType.text:
            buttonWidget = TextButton(
              onPressed: widget.onPressed,
              onLongPress: widget.onLongPress,
              style: TextButton.styleFrom(
                foregroundColor: effectiveForegroundColor,
                padding: widget.padding,
                shape: RoundedRectangleBorder(
                  borderRadius: effectiveBorderRadius,
                ),
              ),
              child: widget.child,
            );
            break;
        }

        // Применяем анимацию масштабирования если нужно
        if (widget.animationStyle == AnimationStyle.scale) {
          buttonWidget = Transform.scale(
            scale: _scaleAnimation.value,
            child: buttonWidget,
          );
        }

        return GestureDetector(
          onTapDown: _handleTapDown,
          onTapUp: _handleTapUp,
          onTapCancel: _handleTapCancel,
          child: buttonWidget,
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

/// Анимированная кнопка с появлением
class AnimatedEntranceButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Duration delay;
  final Duration duration;
  final Offset slideDirection;
  final Curve curve;
  final bool autoStart;

  const AnimatedEntranceButton({
    super.key,
    required this.child,
    this.onPressed,
    this.delay = const Duration(milliseconds: 0),
    this.duration = const Duration(milliseconds: 600),
    this.slideDirection = const Offset(0, 0.3),
    this.curve = Curves.easeOutCubic,
    this.autoStart = true,
  });

  @override
  State<AnimatedEntranceButton> createState() => _AnimatedEntranceButtonState();
}

class _AnimatedEntranceButtonState extends State<AnimatedEntranceButton>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    if (widget.autoStart) {
      _startAnimation();
    }
  }

  void _initializeAnimations() {
    _controller = AnimationController(duration: widget.duration, vsync: this);

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    _slideAnimation = Tween<Offset>(
      begin: widget.slideDirection,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));
  }

  void _startAnimation() {
    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  void restartAnimation() {
    _controller.reset();
    _startAnimation();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: ElevatedButton(
              onPressed: widget.onPressed,
              child: widget.child,
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

/// Анимированная кнопка с иконкой и текстом
class AnimatedIconButton extends StatefulWidget {
  final IconData icon;
  final String? text;
  final VoidCallback? onPressed;
  final Duration duration;
  final double iconSize;
  final bool showBadge;
  final String? badgeText;
  final Color? badgeColor;
  final AnimationType animationType;

  const AnimatedIconButton({
    super.key,
    required this.icon,
    this.text,
    this.onPressed,
    this.duration = const Duration(milliseconds: 200),
    this.iconSize = AppDimensions.iconMedium,
    this.showBadge = false,
    this.badgeText,
    this.badgeColor,
    this.animationType = AnimationType.scale,
  });

  @override
  State<AnimatedIconButton> createState() => _AnimatedIconButtonState();
}

class _AnimatedIconButtonState extends State<AnimatedIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _controller = AnimationController(duration: widget.duration, vsync: this);

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onPressed != null) {
      _controller.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.onPressed != null) {
      _controller.reverse();
      widget.onPressed?.call();
    }
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          Widget buttonContent = Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  Transform.scale(
                    scale: widget.animationType == AnimationType.scale
                        ? _scaleAnimation.value
                        : 1.0,
                    child: Transform.rotate(
                      angle: widget.animationType == AnimationType.rotate
                          ? _rotationAnimation.value
                          : 0.0,
                      child: Icon(
                        widget.icon,
                        size: widget.iconSize,
                        color: context.colors.onBackground,
                      ),
                    ),
                  ),
                  if (widget.showBadge)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: EdgeInsets.all(AppDimensions.space4),
                        decoration: BoxDecoration(
                          color: widget.badgeColor ?? context.colors.error,
                          borderRadius: BorderRadius.circular(
                            AppDimensions.space8,
                          ),
                        ),
                        constraints: BoxConstraints(
                          minWidth: AppDimensions.space16,
                          minHeight: AppDimensions.space16,
                        ),
                        child: widget.badgeText != null
                            ? Text(
                                widget.badgeText!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                                textAlign: TextAlign.center,
                              )
                            : null,
                      ),
                    ),
                ],
              ),
              if (widget.text != null) ...[
                const SizedBox(height: 4),
                Text(
                  widget.text!,
                  style: TextStyle(
                    color: context.colors.onBackground,
                    fontSize: 12,
                  ),
                ),
              ],
            ],
          );

          return Container(
            padding: EdgeInsets.all(AppDimensions.space8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimensions.radius8),
              color: Colors.transparent,
            ),
            child: buttonContent,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

/// Типы кнопок
enum ButtonType { elevated, outlined, text }

/// Стили анимации
enum AnimationStyle { scale, elevation, color, both }

/// Типы анимации для иконок
enum AnimationType { scale, rotate, both }
