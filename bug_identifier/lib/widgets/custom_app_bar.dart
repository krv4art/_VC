import 'package:flutter/material.dart';
import 'package:bug_identifier/theme/app_theme.dart';
import 'package:go_router/go_router.dart';
import 'rating_request_dialog.dart';
import '../theme/theme_extensions_v2.dart';
import 'scaffold_with_drawer.dart';
import '../constants/app_dimensions.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
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
  Widget build(BuildContext context) {
    final colors = context.colors;
    // Для светлых тем используем primaryDark (уникальный цвет для каждой темы),
    // для темных тем - surface
    final appBarColor = colors.isDark ? colors.surface : colors.primaryDark;

    // Определяем цвет текста в зависимости от темы
    final textColor = _getTextColorForTheme(context.colors);

    return AppBar(
      title: Text(
        title,
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
      leading: showBackButton
          ? IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: textColor,
                size: AppDimensions.iconMedium,
              ),
              onPressed:
                  onBackPressed ??
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
        IconButton(
          icon: Icon(
            Icons.star_border,
            color: textColor,
            size: AppDimensions.iconMedium,
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => const RatingRequestDialog(),
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

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
