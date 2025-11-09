import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../providers/theme_provider.dart';
import '../theme/app_theme.dart';

/// Modern drawer menu
class ModernDrawer extends StatelessWidget {
  const ModernDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final themeProvider = context.watch<ThemeProvider>();
    final colors = themeProvider.colors;

    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colors.primary,
              colors.primaryLight,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(AppTheme.space24),
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppTheme.space16),
                      ),
                      child: Icon(
                        Icons.eco,
                        size: 48,
                        color: colors.primary,
                      ),
                    ),
                    const SizedBox(height: AppTheme.space16),
                    Text(
                      l10n.appName,
                      style: AppTheme.h3.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Menu Items
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(AppTheme.space24),
                      topRight: Radius.circular(AppTheme.space24),
                    ),
                  ),
                  child: ListView(
                    padding: const EdgeInsets.all(AppTheme.space16),
                    children: [
                      _buildDrawerItem(
                        context,
                        icon: Icons.home,
                        title: l10n.home,
                        onTap: () {
                          Navigator.pop(context);
                          context.go('/');
                        },
                      ),
                      _buildDrawerItem(
                        context,
                        icon: Icons.camera_alt,
                        title: l10n.scan,
                        onTap: () {
                          Navigator.pop(context);
                          context.push('/scan');
                        },
                      ),
                      _buildDrawerItem(
                        context,
                        icon: Icons.history,
                        title: l10n.history,
                        onTap: () {
                          Navigator.pop(context);
                          context.push('/history');
                        },
                      ),
                      const Divider(height: AppTheme.space32),
                      _buildDrawerItem(
                        context,
                        icon: Icons.language,
                        title: l10n.language,
                        onTap: () {
                          Navigator.pop(context);
                          context.push('/language');
                        },
                      ),
                      _buildDrawerItem(
                        context,
                        icon: Icons.palette,
                        title: l10n.theme,
                        onTap: () {
                          Navigator.pop(context);
                          context.push('/theme-selection');
                        },
                      ),
                      _buildDrawerItem(
                        context,
                        icon: Icons.settings,
                        title: l10n.settings,
                        onTap: () {
                          Navigator.pop(context);
                          context.push('/settings');
                        },
                      ),
                      const Divider(height: AppTheme.space32),
                      _buildDrawerItem(
                        context,
                        icon: Icons.info_outline,
                        title: l10n.about,
                        onTap: () {
                          Navigator.pop(context);
                          _showAboutDialog(context, l10n);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
      ),
    );
  }

  void _showAboutDialog(BuildContext context, AppLocalizations l10n) {
    showAboutDialog(
      context: context,
      applicationName: l10n.appName,
      applicationVersion: '1.0.0',
      applicationIcon: Icon(Icons.eco, size: 48, color: Theme.of(context).primaryColor),
      children: [
        const Text('AI-powered plant identification app'),
        const SizedBox(height: 8),
        const Text('Identify plants, learn care instructions, and track your botanical discoveries.'),
      ],
    );
  }
}
