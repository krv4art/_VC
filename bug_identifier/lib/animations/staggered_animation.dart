import 'package:flutter/material.dart';

/// Универсальный компонент для каскадных анимаций списков элементов
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

/// Виджет для каскадного появления рядов (Row)
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

/// Виджет для каскадного появления с разными направлениями
class DirectionalStaggeredAnimation extends StatefulWidget {
  final Map<int, Widget> children;
  final Map<int, Offset> directions;
  final Duration staggerDelay;
  final Duration duration;
  final bool autoStart;
  final Curve curve;

  const DirectionalStaggeredAnimation({
    super.key,
    required this.children,
    required this.directions,
    this.staggerDelay = const Duration(milliseconds: 60),
    this.duration = const Duration(milliseconds: 500),
    this.autoStart = true,
    this.curve = Curves.easeOutCubic,
  });

  @override
  DirectionalStaggeredAnimationState createState() =>
      DirectionalStaggeredAnimationState();
}

class DirectionalStaggeredAnimationState
    extends State<DirectionalStaggeredAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Map<int, Animation<double>> _animations;

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

    _animations = {};
    widget.children.forEach((index, child) {
      final startTime =
          (index * widget.staggerDelay.inMilliseconds) /
          _controller.duration!.inMilliseconds;
      final endTime =
          ((index * widget.staggerDelay.inMilliseconds) +
              widget.duration.inMilliseconds) /
          _controller.duration!.inMilliseconds;

      _animations[index] = Tween<double>(begin: 0.0, end: 1.0).animate(
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
    final sortedKeys = widget.children.keys.toList()..sort();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: sortedKeys.map((index) {
        return AnimatedBuilder(
          animation: _animations[index]!,
          builder: (context, child) {
            return FadeTransition(
              opacity: _animations[index]!,
              child: SlideTransition(
                position:
                    Tween<Offset>(
                      begin: widget.directions[index] ?? const Offset(0.2, 0),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(
                        parent: _controller,
                        curve: Interval(
                          (index * widget.staggerDelay.inMilliseconds) /
                              _controller.duration!.inMilliseconds,
                          ((index * widget.staggerDelay.inMilliseconds) +
                                  widget.duration.inMilliseconds) /
                              _controller.duration!.inMilliseconds,
                          curve: widget.curve,
                        ),
                      ),
                    ),
                child: widget.children[index]!,
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
