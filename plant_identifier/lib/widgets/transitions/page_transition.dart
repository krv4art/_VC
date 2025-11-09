import 'package:flutter/material.dart';

/// Custom page transitions
class PageTransition extends PageRouteBuilder {
  final Widget page;
  final PageTransitionType type;

  PageTransition({
    required this.page,
    this.type = PageTransitionType.fade,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            switch (type) {
              case PageTransitionType.fade:
                return FadeTransition(opacity: animation, child: child);

              case PageTransitionType.slide:
                const begin = Offset(1.0, 0.0);
                const end = Offset.zero;
                const curve = Curves.easeInOut;
                var tween = Tween(begin: begin, end: end).chain(
                  CurveTween(curve: curve),
                );
                var offsetAnimation = animation.drive(tween);
                return SlideTransition(position: offsetAnimation, child: child);

              case PageTransitionType.scale:
                return ScaleTransition(
                  scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(parent: animation, curve: Curves.easeInOut),
                  ),
                  child: child,
                );

              case PageTransitionType.rotation:
                return RotationTransition(
                  turns: Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(parent: animation, curve: Curves.easeInOut),
                  ),
                  child: FadeTransition(opacity: animation, child: child),
                );

              case PageTransitionType.slideUp:
                const begin = Offset(0.0, 1.0);
                const end = Offset.zero;
                const curve = Curves.easeInOut;
                var tween = Tween(begin: begin, end: end).chain(
                  CurveTween(curve: curve),
                );
                var offsetAnimation = animation.drive(tween);
                return SlideTransition(position: offsetAnimation, child: child);
            }
          },
          transitionDuration: const Duration(milliseconds: 300),
        );
}

enum PageTransitionType {
  fade,
  slide,
  scale,
  rotation,
  slideUp,
}
