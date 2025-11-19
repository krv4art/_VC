import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_mode_provider.dart';
import '../services/security_service.dart';
import '../services/offline_cache_service.dart';
import '../services/tutorial_service.dart';

/// Enhanced settings screen with all new features
class EnhancedSettingsScreen extends StatefulWidget {
  const EnhancedSettingsScreen({Key? key}) : super(key: key);

  @override
  State<EnhancedSettingsScreen> createState() => _EnhancedSettingsScreenState();
}

class _EnhancedSettingsScreenState extends State<EnhancedSettingsScreen> {
  final _securityService = SecurityService();
  final _cacheService = OfflineCacheService();
  final _tutorialService = TutorialService();

  bool _biometricEnabled = false;
  bool _authOnLaunch = false;
  bool _authForGallery = false;
  bool _autoDeleteEnabled = false;
  int _autoDeleteDays = 30;
  int _cacheSize = 0;
  int _cachedFiles = 0;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final biometricEnabled = await _securityService.isBiometricEnabled();
    final authOnLaunch = await _securityService.isAuthRequiredOnLaunch();
    final authForGallery = await _securityService.isAuthRequiredForGallery();
    final autoDeleteEnabled = await _securityService.isAutoDeleteEnabled();
    final autoDeleteDays = await _securityService.getAutoDeleteDays();
    final cacheSize = await _cacheService.getCacheSize();
    final cachedFiles = await _cacheService.getCachedFilesCount();

    setState(() {
      _biometricEnabled = biometricEnabled;
      _authOnLaunch = authOnLaunch;
      _authForGallery = authForGallery;
      _autoDeleteEnabled = autoDeleteEnabled;
      _autoDeleteDays = autoDeleteDays;
      _cacheSize = cacheSize;
      _cachedFiles = cachedFiles;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          // Appearance Section
          _buildSectionHeader('Appearance'),
          _buildThemeSettings(),
          const Divider(),

          // Security Section
          _buildSectionHeader('Security & Privacy'),
          _buildSecuritySettings(),
          const Divider(),

          // Storage Section
          _buildSectionHeader('Storage & Cache'),
          _buildStorageSettings(),
          const Divider(),

          // Features Section
          _buildSectionHeader('Features'),
          _buildFeaturesSettings(),
          const Divider(),

          // About Section
          _buildSectionHeader('About'),
          _buildAboutSettings(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Widget _buildThemeSettings() {
    return Consumer<ThemeModeProvider>(
      builder: (context, themeProvider, _) {
        return Column(
          children: [
            ListTile(
              leading: const Icon(Icons.brightness_6),
              title: const Text('Theme'),
              subtitle: Text(_getThemeModeText(themeProvider.themeMode)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showThemeDialog(themeProvider),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSecuritySettings() {
    return Column(
      children: [
        SwitchListTile(
          secondary: const Icon(Icons.fingerprint),
          title: const Text('Biometric Authentication'),
          subtitle: const Text('Use Face ID or fingerprint'),
          value: _biometricEnabled,
          onChanged: (value) async {
            final success = await _securityService.setBiometricEnabled(value);
            if (success) {
              setState(() => _biometricEnabled = value);
            } else {
              _showErrorSnackBar('Failed to enable biometric authentication');
            }
          },
        ),
        if (_biometricEnabled) ...[
          SwitchListTile(
            secondary: const SizedBox(width: 40),
            title: const Text('Require on Launch'),
            subtitle: const Text('Authenticate when opening app'),
            value: _authOnLaunch,
            onChanged: (value) async {
              await _securityService.setRequireAuthOnLaunch(value);
              setState(() => _authOnLaunch = value);
            },
          ),
          SwitchListTile(
            secondary: const SizedBox(width: 40),
            title: const Text('Lock Gallery'),
            subtitle: const Text('Authenticate to view gallery'),
            value: _authForGallery,
            onChanged: (value) async {
              await _securityService.setRequireAuthForGallery(value);
              setState(() => _authForGallery = value);
            },
          ),
        ],
        ListTile(
          leading: const Icon(Icons.delete_sweep),
          title: const Text('Auto-Delete Old Photos'),
          subtitle: Text(_autoDeleteEnabled
              ? 'Delete photos older than $_autoDeleteDays days'
              : 'Disabled'),
          trailing: Switch(
            value: _autoDeleteEnabled,
            onChanged: (value) => _showAutoDeleteDialog(value),
          ),
        ),
      ],
    );
  }

  Widget _buildStorageSettings() {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.storage),
          title: const Text('Cache Size'),
          subtitle: Text(
            '${_cacheService.formatCacheSize(_cacheSize)} ($_cachedFiles files)',
          ),
          trailing: TextButton(
            onPressed: _clearCache,
            child: const Text('Clear'),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.download),
          title: const Text('Download Quality'),
          subtitle: const Text('High quality'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // Show quality selection dialog
          },
        ),
      ],
    );
  }

  Widget _buildFeaturesSettings() {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.school),
          title: const Text('Show Tutorial Again'),
          subtitle: const Text('Replay app introduction'),
          trailing: const Icon(Icons.chevron_right),
          onTap: _resetTutorial,
        ),
        ListTile(
          leading: const Icon(Icons.notifications),
          title: const Text('Notifications'),
          subtitle: const Text('Manage notification preferences'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // Navigate to notification settings
          },
        ),
        ListTile(
          leading: const Icon(Icons.cloud_upload),
          title: const Text('Cloud Backup'),
          subtitle: const Text('Automatic photo backup'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // Navigate to cloud backup settings
          },
        ),
      ],
    );
  }

  Widget _buildAboutSettings() {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.info),
          title: const Text('App Version'),
          subtitle: const Text('1.0.0'),
        ),
        ListTile(
          leading: const Icon(Icons.bug_report),
          title: const Text('Report a Bug'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.pushNamed(context, '/feedback', arguments: true);
          },
        ),
        ListTile(
          leading: const Icon(Icons.feedback),
          title: const Text('Send Feedback'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.pushNamed(context, '/feedback');
          },
        ),
        ListTile(
          leading: const Icon(Icons.privacy_tip),
          title: const Text('Privacy Policy'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // Open privacy policy
          },
        ),
        ListTile(
          leading: const Icon(Icons.description),
          title: const Text('Terms of Service'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // Open terms of service
          },
        ),
      ],
    );
  }

  void _showThemeDialog(ThemeModeProvider themeProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ThemeMode>(
              title: const Text('Light'),
              value: ThemeMode.light,
              groupValue: themeProvider.themeMode,
              onChanged: (mode) {
                if (mode != null) {
                  themeProvider.setThemeMode(mode);
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Dark'),
              value: ThemeMode.dark,
              groupValue: themeProvider.themeMode,
              onChanged: (mode) {
                if (mode != null) {
                  themeProvider.setThemeMode(mode);
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('System Default'),
              value: ThemeMode.system,
              groupValue: themeProvider.themeMode,
              onChanged: (mode) {
                if (mode != null) {
                  themeProvider.setThemeMode(mode);
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAutoDeleteDialog(bool enable) {
    if (!enable) {
      _securityService.setAutoDeleteEnabled(false);
      setState(() => _autoDeleteEnabled = false);
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Auto-Delete Old Photos'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Delete photos older than:'),
            const SizedBox(height: 16),
            DropdownButton<int>(
              value: _autoDeleteDays,
              items: [7, 14, 30, 60, 90].map((days) {
                return DropdownMenuItem(
                  value: days,
                  child: Text('$days days'),
                );
              }).toList(),
              onChanged: (days) {
                if (days != null) {
                  setState(() => _autoDeleteDays = days);
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _securityService.setAutoDeleteEnabled(true, days: _autoDeleteDays);
              setState(() => _autoDeleteEnabled = true);
              Navigator.pop(context);
            },
            child: const Text('Enable'),
          ),
        ],
      ),
    );
  }

  Future<void> _clearCache() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache'),
        content: const Text(
          'This will clear all cached images and data. Downloaded photos in your gallery will not be affected.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Clear'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _cacheService.clearAllCache();
      await _loadSettings();
      _showSuccessSnackBar('Cache cleared successfully');
    }
  }

  Future<void> _resetTutorial() async {
    await _tutorialService.resetTutorials();
    _showSuccessSnackBar('Tutorial reset. It will show on next app launch.');
  }

  String _getThemeModeText(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System Default';
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}
