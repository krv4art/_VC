import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../models/cultural_theme.dart';
import '../../providers/user_profile_provider.dart';

class CulturalThemeScreen extends StatefulWidget {
  const CulturalThemeScreen({super.key});

  @override
  State<CulturalThemeScreen> createState() => _CulturalThemeScreenState();
}

class _CulturalThemeScreenState extends State<CulturalThemeScreen> {
  String _selectedThemeId = 'classic';

  @override
  void initState() {
    super.initState();
    // Load existing selection
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<UserProfileProvider>();
      setState(() {
        _selectedThemeId = provider.profile.culturalThemeId;
      });
    });
  }

  Future<void> _continue() async {
    final provider = context.read<UserProfileProvider>();
    await provider.updateCulturalTheme(_selectedThemeId);

    if (mounted) {
      context.go('/onboarding/style');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Your Style'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/onboarding/interests'),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Text(
                    'Pick a cultural theme',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'This will personalize the app\'s look, feel, and dialog style',
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Themes list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: CulturalThemes.all.length,
                itemBuilder: (context, index) {
                  final culturalTheme = CulturalThemes.all[index];
                  final isSelected = _selectedThemeId == culturalTheme.id;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: _ThemeCard(
                      theme: culturalTheme,
                      isSelected: isSelected,
                      onTap: () {
                        setState(() {
                          _selectedThemeId = culturalTheme.id;
                        });
                      },
                    ),
                  );
                },
              ),
            ),

            // Continue button
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: ElevatedButton(
                onPressed: _continue,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  minimumSize: const Size.fromHeight(56),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeCard extends StatelessWidget {
  final CulturalTheme theme;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeCard({
    required this.theme,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colors.primary.withOpacity(0.15)
              : appTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? theme.colors.primary
                : appTheme.colorScheme.outline.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Theme preview
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [
                    theme.colors.primary,
                    theme.colors.secondary,
                    theme.colors.accent,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Text(
                  theme.emoji,
                  style: const TextStyle(fontSize: 36),
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Theme info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    theme.name,
                    style: appTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? theme.colors.primary : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    theme.description,
                    style: appTheme.textTheme.bodyMedium?.copyWith(
                      color: appTheme.colorScheme.onBackground.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        _getDialogStyleIcon(theme.dialogStyle),
                        size: 16,
                        color: theme.colors.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _getDialogStyleText(theme.dialogStyle),
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Checkmark
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: theme.colors.primary,
                size: 32,
              ),
          ],
        ),
      ),
    );
  }

  IconData _getDialogStyleIcon(DialogStyle style) {
    switch (style) {
      case DialogStyle.casual:
        return Icons.sentiment_satisfied_alt;
      case DialogStyle.formal:
        return Icons.school;
      case DialogStyle.respectful:
        return Icons.favorite;
      case DialogStyle.enthusiastic:
        return Icons.celebration;
    }
  }

  String _getDialogStyleText(DialogStyle style) {
    switch (style) {
      case DialogStyle.casual:
        return 'Casual & Friendly';
      case DialogStyle.formal:
        return 'Formal & Academic';
      case DialogStyle.respectful:
        return 'Respectful & Patient';
      case DialogStyle.enthusiastic:
        return 'Enthusiastic & Fun';
    }
  }
}
