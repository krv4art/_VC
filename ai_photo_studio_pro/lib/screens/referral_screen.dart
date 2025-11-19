import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/referral_service.dart';
import '../services/social_sharing_service.dart';

/// Referral program screen for inviting friends
class ReferralScreen extends StatefulWidget {
  const ReferralScreen({Key? key}) : super(key: key);

  @override
  State<ReferralScreen> createState() => _ReferralScreenState();
}

class _ReferralScreenState extends State<ReferralScreen> {
  // late ReferralService _referralService;
  final _sharingService = SocialSharingService();

  String _referralCode = '';
  Map<String, dynamic> _statistics = {};
  List<Map<String, dynamic>> _referrals = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReferralData();
  }

  Future<void> _loadReferralData() async {
    setState(() => _isLoading = true);

    try {
      // Initialize service
      // final db = await DatabaseService.instance.database;
      // _referralService = ReferralService(db);

      // Load data
      // final code = await _referralService.getReferralCode() ?? await _referralService.initializeReferralCode();
      // final stats = await _referralService.getReferralStatistics();
      // final refs = await _referralService.getAllReferrals();

      // setState(() {
      //   _referralCode = code;
      //   _statistics = stats;
      //   _referrals = refs;
      //   _isLoading = false;
      // });

      // Mock data
      setState(() {
        _referralCode = 'APP12345';
        _statistics = {
          'total_referrals': 8,
          'completed_referrals': 5,
          'total_rewards_earned': 25,
          'pending_rewards_count': 2,
        };
        _referrals = [
          {'referred_user_code': 'USER001', 'status': 'completed', 'reward_value': 5},
          {'referred_user_code': 'USER002', 'status': 'pending', 'reward_value': 0},
        ];
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading referral data: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invite Friends'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: _showHowItWorks,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadReferralData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Referral Code Card
                    _buildReferralCodeCard(),
                    const SizedBox(height: 16),

                    // Stats Cards
                    _buildStatsGrid(),
                    const SizedBox(height: 24),

                    // How to Share
                    _buildShareSection(),
                    const SizedBox(height: 24),

                    // Referrals List
                    _buildReferralsList(),
                    const SizedBox(height: 24),

                    // Rewards Info
                    _buildRewardsInfo(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildReferralCodeCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [Colors.green.shade400, Colors.teal.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            const Text(
              'Your Referral Code',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _referralCode,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                  letterSpacing: 4,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _copyCode,
              icon: const Icon(Icons.copy),
              label: const Text('Copy Code'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.green.shade700,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Total Invites',
            '${_statistics['total_referrals'] ?? 0}',
            Icons.people,
            Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Rewards Earned',
            '${_statistics['total_rewards_earned'] ?? 0}',
            Icons.card_giftcard,
            Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShareSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Share your code',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildShareButton(
                  'WhatsApp',
                  Icons.chat,
                  Colors.green,
                  () => _shareViaApp('whatsapp'),
                ),
                _buildShareButton(
                  'Telegram',
                  Icons.send,
                  Colors.blue,
                  () => _shareViaApp('telegram'),
                ),
                _buildShareButton(
                  'VK',
                  Icons.people_alt,
                  Colors.blueAccent,
                  () => _shareViaApp('vk'),
                ),
                _buildShareButton(
                  'More',
                  Icons.more_horiz,
                  Colors.grey,
                  _shareGeneric,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShareButton(String label, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildReferralsList() {
    if (_referrals.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Icon(Icons.people_outline, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              const Text(
                'No referrals yet',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Text(
                'Share your code to start earning rewards!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Referrals',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(8),
            itemCount: _referrals.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final referral = _referrals[index];
              final status = referral['status'] as String;
              final reward = referral['reward_value'] as int;

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: status == 'completed'
                      ? Colors.green.shade100
                      : Colors.orange.shade100,
                  child: Icon(
                    status == 'completed' ? Icons.check : Icons.hourglass_empty,
                    color: status == 'completed' ? Colors.green : Colors.orange,
                  ),
                ),
                title: Text(referral['referred_user_code'] as String),
                subtitle: Text(
                  status == 'completed' ? 'Completed' : 'Pending',
                  style: TextStyle(
                    color: status == 'completed' ? Colors.green : Colors.orange,
                  ),
                ),
                trailing: status == 'completed'
                    ? Chip(
                        label: Text('+$reward scans'),
                        backgroundColor: Colors.green.shade50,
                      )
                    : null,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRewardsInfo() {
    return Card(
      elevation: 2,
      color: Colors.blue.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue.shade700),
                const SizedBox(width: 8),
                const Text(
                  'How it works',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildRewardStep('1', 'Share your referral code'),
            _buildRewardStep('2', 'Friend signs up with your code'),
            _buildRewardStep('3', 'You both get 5 free scans! 🎁'),
          ],
        ),
      ),
    );
  }

  Widget _buildRewardStep(String number, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.blue.shade700,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text),
          ),
        ],
      ),
    );
  }

  void _copyCode() {
    Clipboard.setData(ClipboardData(text: _referralCode));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Referral code copied to clipboard!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _shareViaApp(String app) async {
    // final text = _referralService.getReferralShareText(_referralCode);
    final text = '''
🎨 Join me on AI Photo Studio Pro!

Create stunning AI headshots with professional quality.

Use my code: $_referralCode

We'll both get free scans! 🎁
''';

    await _sharingService.shareText(text: text);
  }

  Future<void> _shareGeneric() async {
    // final text = _referralService.getReferralShareText(_referralCode);
    await _sharingService.shareAppLink(referralCode: _referralCode);
  }

  void _showHowItWorks() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('How Referrals Work'),
        content: const Text(
          'Share your unique referral code with friends. '
          'When they sign up and complete their first photo generation, '
          'you\'ll both receive 5 free photo scans!\n\n'
          'The more friends you invite, the more rewards you earn!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }
}
