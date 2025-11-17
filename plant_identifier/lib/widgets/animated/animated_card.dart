import 'package:flutter/material.dart';

/// Animated card with various effects
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
      begin: widget.elevation ?? 2.0,
      end: (widget.elevation ?? 2.0) * 2.0,
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
        widget.backgroundColor ?? Theme.of(context).cardColor;
    final effectiveShadowColor =
        widget.shadowColor ?? Colors.black.withOpacity(0.1);
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
                  : widget.elevation ?? 2.0,
              shadowColor: effectiveShadowColor,
              shape: RoundedRectangleBorder(
                borderRadius: effectiveBorderRadius,
              ),
              color: effectiveBackgroundColor,
              child: Container(padding: widget.padding, child: widget.child),
            ),
          );

          // Add hover glow effect
          if (_isHovered && widget.enableHoverEffect) {
            cardWidget = Container(
              decoration: BoxDecoration(
                borderRadius: effectiveBorderRadius,
                boxShadow: [
                  BoxShadow(
                    color: effectiveShadowColor.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: cardWidget,
            );
          }

          // Wrap with MouseRegion and GestureDetector if needed
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

/// Animation types for cards
enum AnimationType { scale, elevation, both }
