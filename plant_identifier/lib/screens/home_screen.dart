import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/theme_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/modern_drawer.dart';

/// Home screen - Main landing page
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final colors = themeProvider.colors;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      drawer: const ModernDrawer(),
      appBar: AppBar(
        title: Text(l10n.appName),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.space24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Welcome Section
              Text(
                l10n.homeTitle,
                style: AppTheme.h1.copyWith(color: colors.primary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppTheme.space16),
              Text(
                l10n.homeSubtitle,
                style: AppTheme.body.copyWith(color: colors.onBackground),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppTheme.space48),

              // Main Action Button
              ElevatedButton.icon(
                onPressed: () => context.push('/scan'),
                icon: const Icon(Icons.camera_alt, size: 32),
                label: Text(l10n.identifyPlant),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppTheme.space24,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusCard),
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.space24),

              // Secondary Actions
              _buildFeatureCard(
                context,
                icon: Icons.history,
                title: l10n.viewHistory,
                description: l10n.viewHistoryDesc,
                onTap: () => context.push('/history'),
                colors: colors,
              ),
              const SizedBox(height: AppTheme.space16),
              _buildFeatureCard(
                context,
                icon: Icons.info_outline,
                title: l10n.aboutApp,
                description: l10n.aboutAppDesc,
                onTap: () {
                  // TODO: Navigate to about screen
                },
                colors: colors,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              // Already on home
              break;
            case 1:
              context.push('/scan');
              break;
            case 2:
              context.push('/history');
              break;
            case 3:
              context.push('/settings');
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: l10n.home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.camera_alt),
            label: l10n.scan,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.history),
            label: l10n.history,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: l10n.settings,
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
    required dynamic colors,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.space16),
          child: Row(
            children: [
              Icon(icon, size: 40, color: colors.primary),
              const SizedBox(width: AppTheme.space16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTheme.h4.copyWith(color: colors.onSurface),
                    ),
                    const SizedBox(height: AppTheme.space4),
                    Text(
                      description,
                      style: AppTheme.bodySmall.copyWith(
                        color: colors.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: colors.neutral),
            ],
          ),
        ),
      ),
    );
  }
}
