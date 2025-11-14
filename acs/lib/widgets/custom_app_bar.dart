import 'dart:async';
import 'package:flutter/material.dart';
import 'package:acs/theme/app_theme.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'rating_request_dialog.dart';
import '../theme/theme_extensions_v2.dart';
import 'scaffold_with_drawer.dart';
import '../constants/app_dimensions.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = false,
    this.onBackPressed,
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _shakeAnimation;
  late Animation<double> _rotationAnimation;
  Timer? _animationTimer;
  bool _shouldAnimate = true;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _checkRatingStatus();
  }

  void _initializeAnimations() {
    // Animation controller for shake + rotation
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    // Shake animation (subtle horizontal movement)
    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -2.0), weight: 25),
      TweenSequenceItem(tween: Tween(begin: -2.0, end: 2.0), weight: 25),
      TweenSequenceItem(tween: Tween(begin: 2.0, end: -2.0), weight: 25),
      TweenSequenceItem(tween: Tween(begin: -2.0, end: 0.0), weight: 25),
    ]).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Rotation animation (subtle tilt)
    _rotationAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -0.1), weight: 25),
      TweenSequenceItem(tween: Tween(begin: -0.1, end: 0.1), weight: 25),
      TweenSequenceItem(tween: Tween(begin: 0.1, end: -0.1), weight: 25),
      TweenSequenceItem(tween: Tween(begin: -0.1, end: 0.0), weight: 25),
    ]).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Start periodic animation (once every 3 seconds)
    _startPeriodicAnimation();
  }

  void _startPeriodicAnimation() {
    if (!_shouldAnimate) return;

    _animationTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted && _shouldAnimate) {
        _animationController.forward(from: 0.0);
      }
    });
  }

  Future<void> _checkRatingStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isRatingCompleted = prefs.getBool('rating_completed') ?? false;

      if (mounted) {
        setState(() {
          _shouldAnimate = !isRatingCompleted;
          if (!_shouldAnimate) {
            _animationTimer?.cancel();
            _animationController.stop();
          }
        });
      }
    } catch (e) {
      debugPrint('Error checking rating status: $e');
    }
  }

  @override
  void dispose() {
    _animationTimer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    // Для светлых тем используем primaryDark (уникальный цвет для каждой темы),
    // для темных тем - surface
    final appBarColor = colors.isDark ? colors.surface : colors.primaryDark;

    // Определяем цвет текста в зависимости от темы
    final textColor = _getTextColorForTheme(context.colors);

    return AppBar(
      title: Text(
        widget.title,
        style: TextStyle(
          fontFamily: AppTheme.fontFamilySerif,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
      backgroundColor: appBarColor,
      foregroundColor: textColor,
      elevation: 0,
      centerTitle: true,
      leading: widget.showBackButton
          ? IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: textColor,
                size: AppDimensions.iconMedium,
              ),
              onPressed:
                  widget.onBackPressed ??
                  () {
                    // Используем go_router для навигации назад
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      // Если нельзя вернуться назад, идем на главную
                      context.go('/home');
                    }
                  },
            )
          : IconButton(
              icon: Icon(
                Icons.menu,
                color: textColor,
                size: AppDimensions.iconMedium,
              ),
              onPressed: () {
                // Use custom drawer toggle from InheritedWidget
                final drawerToggle = DrawerToggleProvider.of(context);
                if (drawerToggle != null) {
                  drawerToggle.toggleDrawer();
                }
              },
            ),
      actions: [
        // Animated star icon
        AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(_shakeAnimation.value, 0),
              child: Transform.rotate(
                angle: _rotationAnimation.value,
                child: IconButton(
                  icon: Icon(
                    Icons.star_border,
                    color: textColor,
                    size: AppDimensions.iconMedium,
                  ),
                  onPressed: () async {
                    // Check rating status again before showing dialog
                    await _checkRatingStatus();

                    if (mounted) {
                      showDialog(
                        context: context,
                        builder: (context) => const RatingRequestDialog(),
                      );
                    }
                  },
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // Возвращает подходящий цвет текста для AppBar в зависимости от темы
  Color _getTextColorForTheme(ThemeColors colors) {
    // Для светлых тем AppBar использует primaryDark (темный цвет),
    // поэтому текст должен быть белым для хорошего контраста
    // Для темных тем AppBar использует surface (темный), текст тоже белый
    return Colors.white;
  }
}
