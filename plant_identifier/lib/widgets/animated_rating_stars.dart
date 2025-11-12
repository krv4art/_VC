import 'package:flutter/material.dart';

/// Animated rating stars widget with initial animation
class AnimatedRatingStars extends StatefulWidget {
  final int rating;
  final int starCount;
  final double size;
  final Color color;
  final Color inactiveColor;
  final Function(int) onRatingChanged;

  const AnimatedRatingStars({
    super.key,
    required this.rating,
    this.starCount = 5,
    this.size = 36.0,
    this.color = const Color(0xFFFFC107), // Amber color
    this.inactiveColor = const Color(0xFFBDBDBD), // Gray
    required this.onRatingChanged,
  });

  @override
  State<AnimatedRatingStars> createState() => _AnimatedRatingStarsState();
}

class _AnimatedRatingStarsState extends State<AnimatedRatingStars>
    with TickerProviderStateMixin {
  late List<AnimationController> _scaleControllers;
  late List<AnimationController> _shakeControllers;
  late List<Animation<double>> _scaleAnimations;
  late List<Animation<double>> _shakeAnimations;
  late List<Animation<double>> _opacityAnimations;

  bool _isInitialAnimationComplete = false;
  bool _canInteract = false;

  @override
  void initState() {
    super.initState();

    // Controllers for scaling (star growth)
    _scaleControllers = List.generate(
      widget.starCount,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 500),
        vsync: this,
      ),
    );

    // Controllers for shaking last star
    _shakeControllers = List.generate(
      widget.starCount,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 600),
        vsync: this,
      ),
    );

    // Scale animation: 0 -> 1.5 -> 1.0
    _scaleAnimations = _scaleControllers.map((controller) {
      return TweenSequence<double>([
        TweenSequenceItem(
          tween: Tween<double>(
            begin: 0.0,
            end: 1.5,
          ).chain(CurveTween(curve: Curves.easeOut)),
          weight: 50,
        ),
        TweenSequenceItem(
          tween: Tween<double>(
            begin: 1.5,
            end: 1.0,
          ).chain(CurveTween(curve: Curves.easeIn)),
          weight: 50,
        ),
      ]).animate(controller);
    }).toList();

    // Shake animation (for last star)
    _shakeAnimations = _shakeControllers.map((controller) {
      return TweenSequence<double>([
        TweenSequenceItem(
          tween: Tween<double>(begin: 0.0, end: 0.1),
          weight: 25,
        ),
        TweenSequenceItem(
          tween: Tween<double>(begin: 0.1, end: -0.1),
          weight: 25,
        ),
        TweenSequenceItem(
          tween: Tween<double>(begin: -0.1, end: 0.1),
          weight: 25,
        ),
        TweenSequenceItem(
          tween: Tween<double>(begin: 0.1, end: 0.0),
          weight: 25,
        ),
      ]).animate(controller);
    }).toList();

    // Opacity animation: 0 -> 1 -> 0
    _opacityAnimations = _scaleControllers.map((controller) {
      return TweenSequence<double>([
        TweenSequenceItem(
          tween: Tween<double>(begin: 0.0, end: 1.0),
          weight: 50,
        ),
        TweenSequenceItem(
          tween: Tween<double>(begin: 1.0, end: 1.0),
          weight: 50,
        ),
      ]).animate(controller);
    }).toList();

    // Start initial animation
    _startInitialAnimation();
  }

  Future<void> _startInitialAnimation() async {
    // 300ms pause before start
    await Future.delayed(const Duration(milliseconds: 300));

    // Animate stars one by one
    for (int i = 0; i < widget.starCount; i++) {
      if (mounted) {
        final scaleFuture = _scaleControllers[i].forward();

        // If last star, add shake animation
        if (i == widget.starCount - 1) {
          // Wait for scale animation to complete
          await scaleFuture;
          // Start shake
          if (mounted) {
            final shakeFuture = _shakeControllers[i].forward();
            await shakeFuture;
          }
        } else {
          // Small delay before next star
          await Future.delayed(const Duration(milliseconds: 150));
        }
      }
    }

    // Delay before hiding
    await Future.delayed(const Duration(milliseconds: 300));

    // Hide filled stars
    if (mounted) {
      setState(() {
        _isInitialAnimationComplete = true;
        _canInteract = true;
      });
    }
  }

  @override
  void didUpdateWidget(AnimatedRatingStars oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.rating != widget.rating && _canInteract) {
      // Animate stars on rating change (only after initial animation)
      for (int i = 0; i < widget.starCount; i++) {
        if (i < widget.rating && i >= oldWidget.rating) {
          _scaleControllers[i].forward(from: 0.0);
        }
      }
    }
  }

  @override
  void dispose() {
    for (final controller in _scaleControllers) {
      controller.dispose();
    }
    for (final controller in _shakeControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.starCount, (index) {
        final starNumber = index + 1;
        final isActive = starNumber <= widget.rating;

        return AnimatedBuilder(
          animation: Listenable.merge([
            _scaleControllers[index],
            _shakeControllers[index],
          ]),
          builder: (context, child) {
            final isLastStar = index == widget.starCount - 1;
            final rotation = isLastStar ? _shakeAnimations[index].value : 0.0;

            return Transform.rotate(
              angle: rotation,
              child: SizedBox(
                width: widget.size + 16,
                height: widget.size + 16,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outline star (always visible)
                    IconButton(
                      icon: Icon(
                        isActive && _isInitialAnimationComplete
                            ? Icons.star_rounded
                            : Icons.star_border_rounded,
                        size: widget.size,
                        color: isActive && _isInitialAnimationComplete
                            ? widget.color
                            : widget.inactiveColor,
                      ),
                      onPressed: _canInteract
                          ? () => widget.onRatingChanged(starNumber)
                          : null,
                    ),
                    // Filled star (animated)
                    if (!_isInitialAnimationComplete)
                      Positioned.fill(
                        child: IgnorePointer(
                          child: Opacity(
                            opacity: _opacityAnimations[index].value,
                            child: Transform.scale(
                              scale: _scaleAnimations[index].value,
                              child: Icon(
                                Icons.star_rounded,
                                size: widget.size,
                                color: widget.color,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
