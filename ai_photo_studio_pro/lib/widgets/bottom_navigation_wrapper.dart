import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../l10n/app_localizations.dart';
import '../theme/theme_extensions_v2.dart';
import '../constants/app_dimensions.dart';
import 'common/app_spacer.dart';

class BottomNavigationWrapper extends StatelessWidget {
  final Widget child;
  final int currentIndex;
  final VoidCallback? onReturnToHome;

  const BottomNavigationWrapper({
    super.key,
    required this.child,
    required this.currentIndex,
    this.onReturnToHome,
  });

  void _onItemTapped(BuildContext context, int index) {
    // Если уже на главной и нажали на главную - перезапускаем анимации
    if (index == 0 && currentIndex == 0 && onReturnToHome != null) {
      onReturnToHome!();
      return;
    }

    switch (index) {
      case 0:
        context.go('/home');
        // Вызываем коллбек после небольшой задержки, чтобы навигация успела завершиться
        if (onReturnToHome != null) {
          Future.delayed(const Duration(milliseconds: 100), () {
            onReturnToHome!();
          });
        }
        break;
      case 1:
        context.go('/scanning');
        break;
      case 2:
        context.go('/chat');
        break;
      case 3:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: context.colors.surface,
          boxShadow: [
            BoxShadow(
              color: context.colors.shadowColor.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: AppDimensions.space64 + AppDimensions.space8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(
                  context,
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home,
                  label: l10n.home,
                  index: 0,
                  isActive: currentIndex == 0,
                ),
                _buildNavItem(
                  context,
                  icon: Icons.camera_alt_outlined,
                  activeIcon: Icons.camera_alt,
                  label: l10n.scan,
                  index: 1,
                  isActive: currentIndex == 1,
                ),
                _buildNavItem(
                  context,
                  icon: Icons.chat_bubble_outline,
                  activeIcon: Icons.chat_bubble,
                  label: l10n.aiChat,
                  index: 2,
                  isActive: currentIndex == 2,
                ),
                _buildNavItem(
                  context,
                  icon: Icons.person_outline,
                  activeIcon: Icons.person,
                  label: l10n.profile,
                  index: 3,
                  isActive: currentIndex == 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
    required bool isActive,
  }) {
    return Expanded(
      child: InkWell(
        onTap: () => _onItemTapped(context, index),
        splashColor: context.colors.primaryDark.withValues(alpha: 0.1),
        highlightColor: context.colors.primaryDark.withValues(alpha: 0.05),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: AppDimensions.space8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon with smooth animation
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                padding: EdgeInsets.all(AppDimensions.space4),
                decoration: BoxDecoration(
                  gradient: isActive ? context.colors.primaryGradient : null,
                  borderRadius: BorderRadius.circular(AppDimensions.radius12),
                ),
                child: Icon(
                  isActive ? activeIcon : icon,
                  color: isActive
                      ? Colors.white
                      : context.colors.onBackground.withValues(alpha: 0.6),
                  size: AppDimensions.iconMedium,
                ),
              ),
              AppSpacer.v4(),
              // Compact label
              Text(
                label,
                style: TextStyle(
                  color: isActive
                      ? context.colors.primaryDark
                      : context.colors.onBackground.withValues(alpha: 0.6),
                  fontSize: 11,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  letterSpacing: 0.1,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
