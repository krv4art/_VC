import 'package:flutter/material.dart';

/// Universal component for staggered list animations
class StaggeredListAnimation extends StatefulWidget {
  final List<Widget> children;
  final Duration staggerDelay;
  final Duration duration;
  final Offset slideDirection;
  final bool autoStart;
  final Curve curve;

  const StaggeredListAnimation({
    super.key,
    required this.children,
    this.staggerDelay = const Duration(milliseconds: 60),
    this.duration = const Duration(milliseconds: 500),
    this.slideDirection = const Offset(0.2, 0),
    this.autoStart = true,
    this.curve = Curves.easeOutCubic,
  });

  @override
  StaggeredListAnimationState createState() => StaggeredListAnimationState();
}

class StaggeredListAnimationState extends State<StaggeredListAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    if (widget.autoStart) {
      _startAnimations();
    }
  }

  void _initializeAnimations() {
    _controller = AnimationController(
      duration:
          widget.duration + (widget.staggerDelay * widget.children.length),
      vsync: this,
    );

    _animations = List.generate(widget.children.length, (index) {
      final startTime =
          (index * widget.staggerDelay.inMilliseconds) /
          _controller.duration!.inMilliseconds;
      final endTime =
          ((index * widget.staggerDelay.inMilliseconds) +
              widget.duration.inMilliseconds) /
          _controller.duration!.inMilliseconds;

      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            startTime,
            endTime > 1.0 ? 1.0 : endTime,
            curve: widget.curve,
          ),
        ),
      );
    });
  }

  void _startAnimations() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) _controller.forward();
    });
  }

  void restartAnimations() {
    _controller.reset();
    _startAnimations();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.children.asMap().entries.map((entry) {
        return AnimatedBuilder(
          animation: _animations[entry.key],
          builder: (context, child) {
            return FadeTransition(
              opacity: _animations[entry.key],
              child: SlideTransition(
                position:
                    Tween<Offset>(
                      begin: widget.slideDirection,
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(
                        parent: _controller,
                        curve: Interval(
                          (entry.key * widget.staggerDelay.inMilliseconds) /
                              _controller.duration!.inMilliseconds,
                          ((entry.key * widget.staggerDelay.inMilliseconds) +
                                  widget.duration.inMilliseconds) /
                              _controller.duration!.inMilliseconds,
                          curve: widget.curve,
                        ),
                      ),
                    ),
                child: entry.value,
              ),
            );
          },
        );
      }).toList(),
    );
  }
}

/// Widget for staggered row animations
class StaggeredRowAnimation extends StatefulWidget {
  final List<Widget> children;
  final Duration staggerDelay;
  final Duration duration;
  final bool autoStart;
  final Curve curve;

  const StaggeredRowAnimation({
    super.key,
    required this.children,
    this.staggerDelay = const Duration(milliseconds: 60),
    this.duration = const Duration(milliseconds: 500),
    this.autoStart = true,
    this.curve = Curves.easeOutCubic,
  });

  @override
  StaggeredRowAnimationState createState() => StaggeredRowAnimationState();
}

class StaggeredRowAnimationState extends State<StaggeredRowAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    if (widget.autoStart) {
      _startAnimations();
    }
  }

  void _initializeAnimations() {
    _controller = AnimationController(
      duration:
          widget.duration + (widget.staggerDelay * widget.children.length),
      vsync: this,
    );

    _animations = List.generate(widget.children.length, (index) {
      final startTime =
          (index * widget.staggerDelay.inMilliseconds) /
          _controller.duration!.inMilliseconds;
      final endTime =
          ((index * widget.staggerDelay.inMilliseconds) +
              widget.duration.inMilliseconds) /
          _controller.duration!.inMilliseconds;

      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            startTime,
            endTime > 1.0 ? 1.0 : endTime,
            curve: widget.curve,
          ),
        ),
      );
    });
  }

  void _startAnimations() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) _controller.forward();
    });
  }

  void restartAnimations() {
    _controller.reset();
    _startAnimations();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: widget.children.asMap().entries.map((entry) {
        return Expanded(
          child: AnimatedBuilder(
            animation: _animations[entry.key],
            builder: (context, child) {
              return FadeTransition(
                opacity: _animations[entry.key],
                child: SlideTransition(
                  position:
                      Tween<Offset>(
                        begin: const Offset(0.2, 0),
                        end: Offset.zero,
                      ).animate(
                        CurvedAnimation(
                          parent: _controller,
                          curve: Interval(
                            (entry.key * widget.staggerDelay.inMilliseconds) /
                                _controller.duration!.inMilliseconds,
                            ((entry.key * widget.staggerDelay.inMilliseconds) +
                                    widget.duration.inMilliseconds) /
                                _controller.duration!.inMilliseconds,
                            curve: widget.curve,
                          ),
                        ),
                      ),
                  child: entry.value,
                ),
              );
            },
          ),
        );
      }).toList(),
    );
  }
}

/// Fade-in animation for single widgets
class FadeInAnimation extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;
  final bool autoStart;

  const FadeInAnimation({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 500),
    this.autoStart = true,
  });

  @override
  State<FadeInAnimation> createState() => _FadeInAnimationState();
}

class _FadeInAnimationState extends State<FadeInAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    if (widget.autoStart) {
      Future.delayed(widget.delay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: widget.child,
    );
  }
}
