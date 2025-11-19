import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';
import '../services/subscription_service.dart';
import '../services/sync_service.dart';

/// Экран настроек приложения
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final AuthService _authService = AuthService();
  final SubscriptionService _subscriptionService = SubscriptionService();
  final SyncService _syncService = SyncService();

  bool _isLoading = false;
  int _remainingAnalyses = 0;
  String _selectedLanguage = 'English';
  String _selectedCurrency = 'USD';
  bool _priceAlertsEnabled = true;

  static const _availableLanguages = [
    'English',
    'Русский',
    'Español',
    'Français',
    'Deutsch',
    'Italiano',
    'Português',
    '中文',
    '日本語',
  ];

  static const _availableCurrencies = [
    'USD',
    'EUR',
    'GBP',
    'JPY',
    'CNY',
    'RUB',
    'AUD',
    'CAD',
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    _remainingAnalyses = await _subscriptionService.getRemainingFreeAnalyses();

    // Load preferences
    final prefs = await SharedPreferences.getInstance();
    _selectedLanguage = prefs.getString('language') ?? 'English';
    _selectedCurrency = prefs.getString('currency') ?? 'USD';
    _priceAlertsEnabled = prefs.getBool('price_alerts') ?? true;

    setState(() => _isLoading = false);
  }

  Future<void> _savePreference(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is String) {
      await prefs.setString(key, value);
    } else if (value is bool) {
      await prefs.setBool(key, value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                _buildAccountSection(),
                const Divider(height: 32),
                _buildSubscriptionSection(),
                const Divider(height: 32),
                _buildSyncSection(),
                const Divider(height: 32),
                _buildAppSection(),
                const Divider(height: 32),
                _buildAboutSection(),
              ],
            ),
    );
  }

  Widget _buildAccountSection() {
    final isAuthenticated = _authService.isAuthenticated;
    final userEmail = _authService.userEmail;

    return _buildSection(
      title: 'Account',
      children: [
        if (isAuthenticated) ...[
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Signed in as'),
            subtitle: Text(userEmail ?? 'Anonymous'),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sign Out'),
            onTap: _signOut,
          ),
        ] else ...[
          ListTile(
            leading: const Icon(Icons.login),
            title: const Text('Sign In / Sign Up'),
            subtitle: const Text('Sync your collection across devices'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: _showAuthDialog,
          ),
        ],
      ],
    );
  }

  Widget _buildSubscriptionSection() {
    final tier = _subscriptionService.currentTier;
    final tierName = tier == SubscriptionTier.free
        ? 'Free'
        : tier == SubscriptionTier.premium
            ? 'Premium'
            : 'Professional';

    return _buildSection(
      title: 'Subscription',
      children: [
        ListTile(
          leading: Icon(
            tier == SubscriptionTier.free ? Icons.free_breakfast : Icons.workspace_premium,
            color: tier == SubscriptionTier.free ? Colors.grey : Colors.amber,
          ),
          title: Text('Current Plan: $tierName'),
          subtitle: tier == SubscriptionTier.free
              ? Text('$_remainingAnalyses free analyses remaining this month')
              : const Text('Unlimited analyses'),
        ),
        if (tier == SubscriptionTier.free)
          ListTile(
            leading: const Icon(Icons.upgrade, color: Colors.green),
            title: const Text('Upgrade to Premium'),
            subtitle: const Text('\$9.99/month - Unlimited analyses & more'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: _showSubscriptionDialog,
          )
        else
          ListTile(
            leading: const Icon(Icons.manage_accounts),
            title: const Text('Manage Subscription'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: _showSubscriptionDialog,
          ),
      ],
    );
  }

  Widget _buildSyncSection() {
    return _buildSection(
      title: 'Data & Sync',
      children: [
        ListTile(
          leading: const Icon(Icons.cloud_sync),
          title: const Text('Sync Now'),
          subtitle: const Text('Sync your collection with cloud'),
          trailing: const Icon(Icons.sync),
          enabled: _authService.isAuthenticated,
          onTap: _syncNow,
        ),
        ListTile(
          leading: const Icon(Icons.storage),
          title: const Text('Storage Used'),
          subtitle: const Text('Local: ~5 MB, Cloud: ~2 MB'),
        ),
      ],
    );
  }

  Widget _buildAppSection() {
    return _buildSection(
      title: 'App Preferences',
      children: [
        ListTile(
          leading: const Icon(Icons.language),
          title: const Text('Language'),
          subtitle: Text(_selectedLanguage),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: _showLanguagePicker,
        ),
        ListTile(
          leading: const Icon(Icons.attach_money),
          title: const Text('Currency'),
          subtitle: Text(_selectedCurrency),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: _showCurrencyPicker,
        ),
        SwitchListTile(
          secondary: const Icon(Icons.notifications),
          title: const Text('Price Alerts'),
          subtitle: const Text('Notify when prices change'),
          value: _priceAlertsEnabled,
          onChanged: (value) {
            setState(() => _priceAlertsEnabled = value);
            _savePreference('price_alerts', value);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  value ? 'Price alerts enabled' : 'Price alerts disabled',
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return _buildSection(
      title: 'About',
      children: [
        ListTile(
          leading: const Icon(Icons.info),
          title: const Text('Version'),
          subtitle: const Text('2.0.0'),
        ),
        ListTile(
          leading: const Icon(Icons.privacy_tip),
          title: const Text('Privacy Policy'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: _showPrivacyPolicy,
        ),
        ListTile(
          leading: const Icon(Icons.description),
          title: const Text('Terms of Service'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: _showTermsOfService,
        ),
        ListTile(
          leading: const Icon(Icons.help),
          title: const Text('Help & Support'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: _showHelp,
        ),
      ],
    );
  }

  Widget _buildSection({required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ),
        ...children,
      ],
    );
  }

  Future<void> _signOut() async {
    try {
      await _authService.signOut();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Signed out successfully')),
        );
        setState(() {});
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error signing out: $e')),
        );
      }
    }
  }

  Future<void> _syncNow() async {
    if (!_authService.isAuthenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please sign in to sync')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // TODO: Get collection from CollectionService and sync
      await Future.delayed(const Duration(seconds: 2)); // Simulate sync

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sync completed successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sync failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showAuthDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign In'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Choose a sign-in method:'),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.email),
              label: const Text('Email'),
              onPressed: () {
                Navigator.pop(context);
                // TODO: Navigate to email sign-in
              },
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              icon: const Icon(Icons.g_mobiledata),
              label: const Text('Google'),
              onPressed: () async {
                Navigator.pop(context);
                await _authService.signInWithGoogle();
                setState(() {});
              },
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              icon: const Icon(Icons.apple),
              label: const Text('Apple'),
              onPressed: () async {
                Navigator.pop(context);
                await _authService.signInWithApple();
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showSubscriptionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Your Plan'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildPlanCard(
                title: 'Premium Monthly',
                price: '\$9.99/month',
                features: [
                  'Unlimited analyses',
                  'PDF export',
                  'Visual matches',
                  'Cloud sync',
                  'Marks recognition',
                ],
                onTap: () async {
                  Navigator.pop(context);
                  await _subscriptionService.subscribe(SubscriptionService.premiumMonthly);
                  setState(() {});
                },
              ),
              const SizedBox(height: 16),
              _buildPlanCard(
                title: 'Premium Yearly',
                price: '\$79.99/year',
                subtitle: 'Save 33%',
                features: [
                  'All Premium features',
                  'Best value',
                ],
                recommended: true,
                onTap: () async {
                  Navigator.pop(context);
                  await _subscriptionService.subscribe(SubscriptionService.premiumYearly);
                  setState(() {});
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlanCard({
    required String title,
    required String price,
    String? subtitle,
    required List<String> features,
    bool recommended = false,
    required VoidCallback onTap,
  }) {
    return Card(
      color: recommended ? Colors.amber.shade50 : null,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const Spacer(),
                  if (recommended)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'BEST',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                price,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.green.shade600),
                ),
              ],
              const SizedBox(height: 12),
              ...features.map((feature) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.check, size: 16, color: Colors.green),
                        const SizedBox(width: 8),
                        Text(feature),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  void _showLanguagePicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _availableLanguages.length,
            itemBuilder: (context, index) {
              final language = _availableLanguages[index];
              final isSelected = language == _selectedLanguage;
              return ListTile(
                title: Text(language),
                trailing: isSelected ? const Icon(Icons.check, color: Colors.green) : null,
                selected: isSelected,
                onTap: () {
                  setState(() => _selectedLanguage = language);
                  _savePreference('language', language);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Language set to $language')),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _showCurrencyPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Currency'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _availableCurrencies.length,
            itemBuilder: (context, index) {
              final currency = _availableCurrencies[index];
              final isSelected = currency == _selectedCurrency;
              return ListTile(
                title: Text(currency),
                trailing: isSelected ? const Icon(Icons.check, color: Colors.green) : null,
                selected: isSelected,
                onTap: () {
                  setState(() => _selectedCurrency = currency);
                  _savePreference('currency', currency);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Currency set to $currency')),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: const SingleChildScrollView(
          child: Text(
            'Antique Identifier Privacy Policy\n\n'
            'Last updated: 2025\n\n'
            '1. Information We Collect\n'
            'We collect images you upload for analysis, analysis results, and account information if you choose to sign in.\n\n'
            '2. How We Use Your Information\n'
            'Your images and data are used solely to provide antique identification services. We use AI services to analyze your images.\n\n'
            '3. Data Storage\n'
            'Data is stored securely on our servers and in local device storage. You can delete your data at any time.\n\n'
            '4. Third-Party Services\n'
            'We use Google AI (Gemini) for image analysis and Supabase for cloud storage.\n\n'
            '5. Your Rights\n'
            'You have the right to access, modify, or delete your data at any time.\n\n'
            'For questions, contact: support@antiqueidentifier.com',
            style: TextStyle(height: 1.5),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showTermsOfService() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terms of Service'),
        content: const SingleChildScrollView(
          child: Text(
            'Antique Identifier Terms of Service\n\n'
            'Last updated: 2025\n\n'
            '1. Acceptance of Terms\n'
            'By using Antique Identifier, you agree to these terms.\n\n'
            '2. Service Description\n'
            'Antique Identifier provides AI-powered identification and valuation of antique items. Results are estimates and not professional appraisals.\n\n'
            '3. User Responsibilities\n'
            '• Upload only images you own or have permission to use\n'
            '• Use the service for lawful purposes only\n'
            '• Do not attempt to reverse engineer or abuse the AI system\n\n'
            '4. Disclaimers\n'
            '• Valuations are estimates only\n'
            '• Professional appraisal recommended for significant items\n'
            '• We are not liable for decisions made based on app results\n\n'
            '5. Subscription Terms\n'
            '• Subscriptions renew automatically\n'
            '• Cancel anytime through your app store\n'
            '• No refunds for partial periods\n\n'
            '6. Changes to Terms\n'
            'We may update these terms. Continued use constitutes acceptance.\n\n'
            'Contact: support@antiqueidentifier.com',
            style: TextStyle(height: 1.5),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showHelp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Help & Support'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Getting Started',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              const Text('1. Take a clear photo of your antique item\n'
                  '2. The AI will analyze and identify it\n'
                  '3. Review the detailed analysis results\n'
                  '4. Save to your collection or export as PDF'),
              const SizedBox(height: 16),
              const Text(
                'Features',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              const Text('• Visual matches - Find similar items online\n'
                  '• Marks scanner - Identify manufacturer marks\n'
                  '• Encyclopedia - Learn about antiques\n'
                  '• Price tracking - Monitor value changes\n'
                  '• Multi-photo analysis - Better accuracy'),
              const SizedBox(height: 16),
              const Text(
                'Tips for Best Results',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              const Text('• Use good lighting\n'
                  '• Take photos from multiple angles\n'
                  '• Include close-ups of marks or signatures\n'
                  '• Clean the item before photographing'),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              const Text(
                'Need more help?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text('Email: support@antiqueidentifier.com'),
              const Text('Response time: 24-48 hours'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
