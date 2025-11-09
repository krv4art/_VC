import 'package:flutter/material.dart';

/// Универсальный компонент для переходов между экранами
class PageTransitionBuilder {
  /// Плавный переход с появлением
  static Widget fadeTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(opacity: animation, child: child);
  }

  /// Переход с появлением и масштабированием
  static Widget fadeScaleTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return ScaleTransition(
      scale: Tween<double>(
        begin: 0.8,
        end: 1.0,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
      child: FadeTransition(opacity: animation, child: child),
    );
  }

  /// Переход с появлением и сдвигом снизу
  static Widget slideUpTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    const begin = Offset(0.0, 1.0);
    const end = Offset.zero;
    const curve = Curves.easeOutCubic;

    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

    return SlideTransition(position: animation.drive(tween), child: child);
  }

  /// Переход с появлением и сдвигом сверху
  static Widget slideDownTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    const begin = Offset(0.0, -1.0);
    const end = Offset.zero;
    const curve = Curves.easeOutCubic;

    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

    return SlideTransition(position: animation.drive(tween), child: child);
  }

  /// Переход с появлением и сдвигом справа
  static Widget slideRightTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    const begin = Offset(1.0, 0.0);
    const end = Offset.zero;
    const curve = Curves.easeOutCubic;

    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

    return SlideTransition(position: animation.drive(tween), child: child);
  }

  /// Переход с появлением и сдвигом слева
  static Widget slideLeftTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    const begin = Offset(-1.0, 0.0);
    const end = Offset.zero;
    const curve = Curves.easeOutCubic;

    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

    return SlideTransition(position: animation.drive(tween), child: child);
  }

  /// Переход с вращением
  static Widget rotationTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return RotationTransition(
      turns: Tween<double>(
        begin: 0.1,
        end: 0.0,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.8, end: 1.0).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
        ),
        child: FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  /// Переход с эффектом масштабирования из центра
  static Widget scaleTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return ScaleTransition(
      scale: Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
      child: child,
    );
  }

  /// Переход с эффектом раздвижения (doors)
  static Widget doorsTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final slideAmount = (1.0 - animation.value) * 1.0;

        return Row(
          children: [
            // Левая дверь
            Transform.translate(
              offset: Offset(-slideAmount * 200, 0),
              child: ClipRect(
                child: Align(
                  alignment: Alignment.centerLeft,
                  widthFactor: 0.5,
                  child: child,
                ),
              ),
            ),
            // Правая дверь
            Transform.translate(
              offset: Offset(slideAmount * 200, 0),
              child: ClipRect(
                child: Align(
                  alignment: Alignment.centerRight,
                  widthFactor: 0.5,
                  child: child,
                ),
              ),
            ),
          ],
        );
      },
      child: child,
    );
  }

  /// Универсальный builder переходов по типу
  static Widget transitionsBuilder(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
    PageTransitionType transitionType,
  ) {
    switch (transitionType) {
      case PageTransitionType.fade:
        return fadeTransition(context, animation, secondaryAnimation, child);
      case PageTransitionType.fadeScale:
        return fadeScaleTransition(
          context,
          animation,
          secondaryAnimation,
          child,
        );
      case PageTransitionType.slideUp:
        return slideUpTransition(context, animation, secondaryAnimation, child);
      case PageTransitionType.slideDown:
        return slideDownTransition(
          context,
          animation,
          secondaryAnimation,
          child,
        );
      case PageTransitionType.slideLeft:
        return slideLeftTransition(
          context,
          animation,
          secondaryAnimation,
          child,
        );
      case PageTransitionType.slideRight:
        return slideRightTransition(
          context,
          animation,
          secondaryAnimation,
          child,
        );
      case PageTransitionType.rotation:
        return rotationTransition(
          context,
          animation,
          secondaryAnimation,
          child,
        );
      case PageTransitionType.scale:
        return scaleTransition(context, animation, secondaryAnimation, child);
      case PageTransitionType.doors:
        return doorsTransition(context, animation, secondaryAnimation, child);
    }
  }
}

/// Типы переходов между страницами
enum PageTransitionType {
  fade,
  fadeScale,
  slideUp,
  slideDown,
  slideLeft,
  slideRight,
  rotation,
  scale,
  doors,
}

/// Класс для создания кастомных переходов между страницами
class CustomPageTransition extends PageRouteBuilder {
  final Widget child;
  final PageTransitionType transitionType;
  final Duration duration;

  CustomPageTransition({
    required this.child,
    this.transitionType = PageTransitionType.fade,
    this.duration = const Duration(milliseconds: 300),
  }) : super(
         pageBuilder: (context, animation, secondaryAnimation) => child,
         transitionDuration: duration,
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           switch (transitionType) {
             case PageTransitionType.fade:
               return PageTransitionBuilder.fadeTransition(
                 context,
                 animation,
                 secondaryAnimation,
                 child,
               );
             case PageTransitionType.fadeScale:
               return PageTransitionBuilder.fadeScaleTransition(
                 context,
                 animation,
                 secondaryAnimation,
                 child,
               );
             case PageTransitionType.slideUp:
               return PageTransitionBuilder.slideUpTransition(
                 context,
                 animation,
                 secondaryAnimation,
                 child,
               );
             case PageTransitionType.slideDown:
               return PageTransitionBuilder.slideDownTransition(
                 context,
                 animation,
                 secondaryAnimation,
                 child,
               );
             case PageTransitionType.slideLeft:
               return PageTransitionBuilder.slideLeftTransition(
                 context,
                 animation,
                 secondaryAnimation,
                 child,
               );
             case PageTransitionType.slideRight:
               return PageTransitionBuilder.slideRightTransition(
                 context,
                 animation,
                 secondaryAnimation,
                 child,
               );
             case PageTransitionType.rotation:
               return PageTransitionBuilder.rotationTransition(
                 context,
                 animation,
                 secondaryAnimation,
                 child,
               );
             case PageTransitionType.scale:
               return PageTransitionBuilder.scaleTransition(
                 context,
                 animation,
                 secondaryAnimation,
                 child,
               );
             case PageTransitionType.doors:
               return PageTransitionBuilder.doorsTransition(
                 context,
                 animation,
                 secondaryAnimation,
                 child,
               );
           }
         },
       );
}

/// Утилиты для навигации с анимациями
class NavigationHelper {
  /// Навигация с кастомным переходом
  static Future<T?> navigateWithTransition<T extends Object?>(
    BuildContext context,
    Widget route, {
    PageTransitionType transitionType = PageTransitionType.fade,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return Navigator.of(context).push<T>(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => route,
        transitionDuration: duration,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return PageTransitionBuilder.transitionsBuilder(
            context,
            animation,
            secondaryAnimation,
            child,
            transitionType,
          );
        },
      ),
    );
  }

  /// Замена текущего экрана с анимацией
  static Future<T?>
  replaceWithTransition<T extends Object?, TO extends Object?>(
    BuildContext context,
    Widget route, {
    PageTransitionType transitionType = PageTransitionType.fade,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return Navigator.of(context).pushReplacement<T, TO>(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => route,
        transitionDuration: duration,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return PageTransitionBuilder.transitionsBuilder(
            context,
            animation,
            secondaryAnimation,
            child,
            transitionType,
          );
        },
      ),
    );
  }

  /// Навигация с удалением всех предыдущих экранов
  static Future<T?> navigateAndClearStack<T extends Object?>(
    BuildContext context,
    Widget route, {
    PageTransitionType transitionType = PageTransitionType.fade,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return Navigator.of(context).pushAndRemoveUntil<T>(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => route,
        transitionDuration: duration,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return PageTransitionBuilder.transitionsBuilder(
            context,
            animation,
            secondaryAnimation,
            child,
            transitionType,
          );
        },
      ),
      (route) => false,
    );
  }
}

/// Виджет для плавного появления страницы
class PageEntranceAnimation extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;
  final PageTransitionType transitionType;
  final bool autoStart;

  const PageEntranceAnimation({
    super.key,
    required this.child,
    this.delay = const Duration(milliseconds: 0),
    this.duration = const Duration(milliseconds: 500),
    this.transitionType = PageTransitionType.fadeScale,
    this.autoStart = true,
  });

  @override
  State<PageEntranceAnimation> createState() => _PageEntranceAnimationState();
}

class _PageEntranceAnimationState extends State<PageEntranceAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);

    if (widget.autoStart) {
      _startAnimation();
    }
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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        switch (widget.transitionType) {
          case PageTransitionType.fade:
            return FadeTransition(opacity: _controller, child: widget.child);
          case PageTransitionType.fadeScale:
            return ScaleTransition(
              scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                CurvedAnimation(
                  parent: _controller,
                  curve: Curves.easeOutCubic,
                ),
              ),
              child: FadeTransition(opacity: _controller, child: widget.child),
            );
          case PageTransitionType.slideUp:
            return SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(0, 0.3),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: _controller,
                      curve: Curves.easeOutCubic,
                    ),
                  ),
              child: widget.child,
            );
          case PageTransitionType.slideDown:
            return SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(0, -0.3),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: _controller,
                      curve: Curves.easeOutCubic,
                    ),
                  ),
              child: widget.child,
            );
          case PageTransitionType.slideLeft:
            return SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(0.3, 0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: _controller,
                      curve: Curves.easeOutCubic,
                    ),
                  ),
              child: widget.child,
            );
          case PageTransitionType.slideRight:
            return SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(-0.3, 0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: _controller,
                      curve: Curves.easeOutCubic,
                    ),
                  ),
              child: widget.child,
            );
          case PageTransitionType.rotation:
            return RotationTransition(
              turns: Tween<double>(begin: 0.1, end: 0.0).animate(
                CurvedAnimation(
                  parent: _controller,
                  curve: Curves.easeOutCubic,
                ),
              ),
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                  CurvedAnimation(
                    parent: _controller,
                    curve: Curves.easeOutCubic,
                  ),
                ),
                child: FadeTransition(
                  opacity: _controller,
                  child: widget.child,
                ),
              ),
            );
          case PageTransitionType.scale:
            return ScaleTransition(
              scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                  parent: _controller,
                  curve: Curves.easeOutCubic,
                ),
              ),
              child: widget.child,
            );
          case PageTransitionType.doors:
            return AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final slideAmount = (1.0 - _controller.value) * 1.0;

                return Row(
                  children: [
                    // Левая дверь
                    Transform.translate(
                      offset: Offset(-slideAmount * 200, 0),
                      child: ClipRect(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          widthFactor: 0.5,
                          child: widget.child,
                        ),
                      ),
                    ),
                    // Правая дверь
                    Transform.translate(
                      offset: Offset(slideAmount * 200, 0),
                      child: ClipRect(
                        child: Align(
                          alignment: Alignment.centerRight,
                          widthFactor: 0.5,
                          child: widget.child,
                        ),
                      ),
                    ),
                  ],
                );
              },
              child: widget.child,
            );
        }
      },
    );
  }
}
