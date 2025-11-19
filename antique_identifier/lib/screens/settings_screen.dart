import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    _remainingAnalyses = await _subscriptionService.getRemainingFreeAnalyses();

    setState(() => _isLoading = false);
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
          subtitle: const Text('English'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            // TODO: Open language picker
          },
        ),
        ListTile(
          leading: const Icon(Icons.attach_money),
          title: const Text('Currency'),
          subtitle: const Text('USD'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            // TODO: Open currency picker
          },
        ),
        SwitchListTile(
          secondary: const Icon(Icons.notifications),
          title: const Text('Price Alerts'),
          subtitle: const Text('Notify when prices change'),
          value: true,
          onChanged: (value) {
            // TODO: Toggle notifications
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
          onTap: () {
            // TODO: Open privacy policy
          },
        ),
        ListTile(
          leading: const Icon(Icons.description),
          title: const Text('Terms of Service'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            // TODO: Open terms
          },
        ),
        ListTile(
          leading: const Icon(Icons.help),
          title: const Text('Help & Support'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            // TODO: Open help
          },
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
}
