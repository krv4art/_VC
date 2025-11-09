import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../providers/user_preferences_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/locale_provider.dart';
import '../models/user_preferences.dart';
import '../theme/app_theme.dart';
import '../widgets/common/app_spacer.dart';

/// Profile screen (without authentication, local settings only)
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final preferencesProvider = context.watch<UserPreferencesProvider>();
    final preferences = preferencesProvider.preferences;
    final themeProvider = context.watch<ThemeProvider>();
    final localeProvider = context.watch<LocaleProvider>();
    final colors = themeProvider.colors;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppTheme.space16),
        children: [
          // Experience Level
          _buildSectionHeader('Experience Level'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.space16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Gardening Experience',
                    style: AppTheme.h5.copyWith(fontWeight: FontWeight.bold),
                  ),
                  AppSpacer.v12(),
                  ...GardeningExperience.values.map((exp) {
                    return RadioListTile<GardeningExperience>(
                      title: Text(_getExperienceName(exp)),
                      value: exp,
                      groupValue: preferences.experience,
                      onChanged: (value) {
                        if (value != null) {
                          preferencesProvider.updateExperience(value);
                        }
                      },
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
          AppSpacer.v24(),

          // Interests
          _buildSectionHeader('Plant Interests'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.space16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'What interests you?',
                    style: AppTheme.h5.copyWith(fontWeight: FontWeight.bold),
                  ),
                  AppSpacer.v12(),
                  Wrap(
                    spacing: AppTheme.space8,
                    runSpacing: AppTheme.space8,
                    children: PlantInterest.values.map((interest) {
                      final isSelected = preferences.interests.contains(interest);
                      return FilterChip(
                        label: Text(_getInterestName(interest)),
                        selected: isSelected,
                        onSelected: (selected) {
                          preferencesProvider.toggleInterest(interest);
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          AppSpacer.v24(),

          // Location & Environment
          _buildSectionHeader('Location & Environment'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.location_on),
                  title: const Text('Location'),
                  subtitle: Text(preferences.location ?? 'Not set'),
                  onTap: () => _showLocationDialog(context, preferencesProvider),
                ),
                ListTile(
                  leading: const Icon(Icons.cloud),
                  title: const Text('Climate'),
                  subtitle: Text(preferences.climate ?? 'Not set'),
                  onTap: () => _showClimateDialog(context, preferencesProvider),
                ),
                ListTile(
                  leading: const Icon(Icons.yard),
                  title: const Text('Garden Type'),
                  subtitle: Text(preferences.gardenType ?? 'Not set'),
                  onTap: () => _showGardenTypeDialog(context, preferencesProvider),
                ),
              ],
            ),
          ),
          AppSpacer.v24(),

          // Quick Actions
          _buildSectionHeader('Actions'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.language),
                  title: Text(l10n.language),
                  subtitle: Text(localeProvider.getLocaleDisplayName(localeProvider.locale)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/settings'),
                ),
                ListTile(
                  leading: const Icon(Icons.palette),
                  title: Text(l10n.theme),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/settings'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: AppTheme.space8, bottom: AppTheme.space8),
      child: Text(
        title,
        style: AppTheme.h4.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.grey[700],
        ),
      ),
    );
  }

  String _getExperienceName(GardeningExperience exp) {
    switch (exp) {
      case GardeningExperience.beginner:
        return 'Beginner';
      case GardeningExperience.intermediate:
        return 'Intermediate';
      case GardeningExperience.advanced:
        return 'Advanced';
      case GardeningExperience.professional:
        return 'Professional';
    }
  }

  String _getInterestName(PlantInterest interest) {
    switch (interest) {
      case PlantInterest.general:
        return 'General';
      case PlantInterest.ediblePlants:
        return 'Edible Plants';
      case PlantInterest.ornamental:
        return 'Ornamental';
      case PlantInterest.medicinal:
        return 'Medicinal';
      case PlantInterest.mushrooms:
        return 'Mushrooms';
      case PlantInterest.succulents:
        return 'Succulents';
      case PlantInterest.houseplants:
        return 'Houseplants';
      case PlantInterest.trees:
        return 'Trees';
      case PlantInterest.wildflowers:
        return 'Wildflowers';
      case PlantInterest.toxicPlants:
        return 'Toxic Plants';
    }
  }

  void _showLocationDialog(BuildContext context, UserPreferencesProvider provider) {
    final controller = TextEditingController(text: provider.preferences.location);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Set Location'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Location',
            hintText: 'e.g., San Francisco, CA',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              provider.updateLocation(controller.text);
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showClimateDialog(BuildContext context, UserPreferencesProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Select Climate'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['Tropical', 'Temperate', 'Arid', 'Cold', 'Mediterranean'].map((climate) {
            return RadioListTile<String>(
              title: Text(climate),
              value: climate,
              groupValue: provider.preferences.climate,
              onChanged: (value) {
                if (value != null) {
                  provider.updateClimate(value);
                  Navigator.pop(ctx);
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showGardenTypeDialog(BuildContext context, UserPreferencesProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Select Garden Type'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['Indoor', 'Outdoor', 'Balcony', 'Greenhouse', 'Mixed'].map((type) {
            return RadioListTile<String>(
              title: Text(type),
              value: type,
              groupValue: provider.preferences.gardenType,
              onChanged: (value) {
                if (value != null) {
                  provider.updateGardenType(value);
                  Navigator.pop(ctx);
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
