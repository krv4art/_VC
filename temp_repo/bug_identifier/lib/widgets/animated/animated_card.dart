import 'package:flutter/material.dart';
import '../../theme/theme_extensions_v2.dart';
import '../../constants/app_dimensions.dart';

/// Универсальная анимированная карточка с различными эффектами
class AnimatedCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Duration duration;
  final double scaleAmount;
  final double? elevation;
  final Color? shadowColor;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final bool enableHoverEffect;
  final bool enablePressEffect;
  final AnimationType animationType;

  const AnimatedCard({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.duration = const Duration(milliseconds: 200),
    this.scaleAmount = 0.95,
    this.elevation,
    this.shadowColor,
    this.borderRadius,
    this.backgroundColor,
    this.padding,
    this.margin,
    this.enableHoverEffect = true,
    this.enablePressEffect = true,
    this.animationType = AnimationType.scale,
  });

  @override
  State<AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<AnimatedCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  bool _isHovered = false;

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
      end: (widget.elevation ?? 4.0) * 2.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.enablePressEffect) {
      _controller.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.enablePressEffect) {
      _controller.reverse();
    }
    widget.onTap?.call();
  }

  void _handleTapCancel() {
    if (widget.enablePressEffect) {
      _controller.reverse();
    }
  }

  void _handleHover(bool hovering) {
    if (widget.enableHoverEffect) {
      setState(() => _isHovered = hovering);
      if (hovering) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor =
        widget.backgroundColor ?? context.colors.cardBackground;
    final effectiveShadowColor =
        widget.shadowColor ?? context.colors.shadowColor;
    final effectiveBorderRadius =
        widget.borderRadius ?? BorderRadius.circular(16.0);

    return Container(
      margin: widget.margin,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          Widget cardWidget = Transform.scale(
            scale: widget.animationType == AnimationType.scale
                ? _scaleAnimation.value
                : 1.0,
            child: Card(
              margin: EdgeInsets.zero,
              elevation: widget.animationType == AnimationType.elevation
                  ? _elevationAnimation.value
                  : widget.elevation ?? 4.0,
              shadowColor: effectiveShadowColor,
              shape: RoundedRectangleBorder(
                borderRadius: effectiveBorderRadius,
              ),
              color: effectiveBackgroundColor,
              child: Container(padding: widget.padding, child: widget.child),
            ),
          );

          // Добавляем эффект свечения при наведении
          if (_isHovered && widget.enableHoverEffect) {
            cardWidget = Container(
              decoration: BoxDecoration(
                borderRadius: effectiveBorderRadius,
                boxShadow: [
                  BoxShadow(
                    color: effectiveShadowColor.withValues(alpha: 0.3),
                    blurRadius: AppDimensions.space8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: cardWidget,
            );
          }

          // ИСПРАВЛЕНИЕ: Оборачиваем в MouseRegion и GestureDetector если есть onTap
          if (widget.onTap != null || widget.onLongPress != null) {
            cardWidget = MouseRegion(
              cursor: SystemMouseCursors.click,
              onEnter: (_) => _handleHover(true),
              onExit: (_) => _handleHover(false),
              child: GestureDetector(
                onTapDown: _handleTapDown,
                onTapUp: _handleTapUp,
                onTapCancel: _handleTapCancel,
                onLongPress: widget.onLongPress,
                child: cardWidget,
              ),
            );
          }

          return cardWidget;
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

/// Анимированная карточка с появлением
class AnimatedEntranceCard extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;
  final Offset slideDirection;
  final Curve curve;
  final bool autoStart;

  const AnimatedEntranceCard({
    super.key,
    required this.child,
    this.delay = const Duration(milliseconds: 0),
    this.duration = const Duration(milliseconds: 600),
    this.slideDirection = const Offset(0, 0.3),
    this.curve = Curves.easeOutCubic,
    this.autoStart = true,
  });

  @override
  State<AnimatedEntranceCard> createState() => _AnimatedEntranceCardState();
}

class _AnimatedEntranceCardState extends State<AnimatedEntranceCard>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

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

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
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
            child: Transform.scale(
              scale: _scaleAnimation.value,
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

/// Анимированная карточка с пульсацией
class PulseAnimatedCard extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double minScale;
  final double maxScale;
  final bool autoStart;

  const PulseAnimatedCard({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1500),
    this.minScale = 0.95,
    this.maxScale = 1.05,
    this.autoStart = true,
  });

  @override
  State<PulseAnimatedCard> createState() => _PulseAnimatedCardState();
}

class _PulseAnimatedCardState extends State<PulseAnimatedCard>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    if (widget.autoStart) {
      _controller.repeat(reverse: true);
    }
  }

  void _initializeAnimations() {
    _controller = AnimationController(duration: widget.duration, vsync: this);

    _scaleAnimation = Tween<double>(
      begin: widget.minScale,
      end: widget.maxScale,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  void startPulse() {
    _controller.repeat(reverse: true);
  }

  void stopPulse() {
    _controller.stop();
    _controller.reset();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: widget.child,
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

/// Типы анимации для карточек
enum AnimationType { scale, elevation, both }
