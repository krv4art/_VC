import 'package:flutter/material.dart';
import '../services/gamification_service.dart';

/// Achievements and rewards screen
class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({Key? key}) : super(key: key);

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  // late GamificationService _gamificationService;

  List<Map<String, dynamic>> _allAchievements = [];
  List<Map<String, dynamic>> _unlockedAchievements = [];
  Map<String, dynamic>? _dailyBonus;
  bool _canClaimBonus = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadAchievements();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadAchievements() async {
    setState(() => _isLoading = true);

    try {
      // Initialize service
      // final db = await DatabaseService.instance.database;
      // _gamificationService = GamificationService(db);

      // Load data
      // final all = await _gamificationService.getAllAchievements();
      // final unlocked = await _gamificationService.getUnlockedAchievements();
      // final canClaim = await _gamificationService.canClaimDailyBonus();

      // Mock data
      setState(() {
        _allAchievements = [
          {
            'id': 'first_photo',
            'name': 'First Steps',
            'description': 'Generate your first AI photo',
            'icon': '🎨',
            'xp_reward': 100,
            'unlocked': 1,
            'progress': 1,
            'target': 1,
          },
          {
            'id': 'photo_master_10',
            'name': 'Photo Master',
            'description': 'Generate 10 AI photos',
            'icon': '📸',
            'xp_reward': 500,
            'unlocked': 1,
            'progress': 10,
            'target': 10,
          },
          {
            'id': 'photo_expert_50',
            'name': 'Photo Expert',
            'description': 'Generate 50 AI photos',
            'icon': '🏆',
            'xp_reward': 2000,
            'unlocked': 0,
            'progress': 25,
            'target': 50,
          },
          {
            'id': 'streak_7',
            'name': 'Week Warrior',
            'description': 'Use app 7 days in a row',
            'icon': '🔥',
            'xp_reward': 700,
            'unlocked': 1,
            'progress': 7,
            'target': 7,
          },
        ];
        _unlockedAchievements = _allAchievements.where((a) => a['unlocked'] == 1).toList();
        _canClaimBonus = true;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading achievements: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Achievements & Rewards'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Achievements'),
            Tab(text: 'Daily Bonus'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildAchievementsTab(),
                _buildDailyBonusTab(),
              ],
            ),
    );
  }

  Widget _buildAchievementsTab() {
    return RefreshIndicator(
      onRefresh: _loadAchievements,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Progress Summary
          _buildProgressSummary(),
          const SizedBox(height: 24),

          // Unlocked Section
          _buildSectionHeader('Unlocked (${_unlockedAchievements.length})'),
          const SizedBox(height: 12),
          ..._unlockedAchievements.map(_buildAchievementCard),

          const SizedBox(height: 24),

          // Locked Section
          _buildSectionHeader('Locked'),
          const SizedBox(height: 12),
          ..._allAchievements
              .where((a) => a['unlocked'] == 0)
              .map(_buildAchievementCard),
        ],
      ),
    );
  }

  Widget _buildDailyBonusTab() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Bonus Icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.amber.shade400, Colors.orange.shade400],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  '🎁',
                  style: TextStyle(fontSize: 64),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Title
            const Text(
              'Daily Bonus',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Description
            Text(
              _canClaimBonus
                  ? 'Claim your daily reward!'
                  : 'Come back tomorrow for your next bonus',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 32),

            // Claim Button
            if (_canClaimBonus)
              ElevatedButton(
                onPressed: _claimDailyBonus,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 4,
                ),
                child: const Text(
                  'Claim Bonus',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

            const SizedBox(height: 48),

            // Streak Info
            _buildStreakInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressSummary() {
    final unlocked = _unlockedAchievements.length;
    final total = _allAchievements.length;
    final percentage = total > 0 ? unlocked / total : 0.0;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Your Progress',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '$unlocked / $total',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: percentage,
                minHeight: 12,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade700),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildAchievementCard(Map<String, dynamic> achievement) {
    final isUnlocked = achievement['unlocked'] == 1;
    final progress = achievement['progress'] as int;
    final target = achievement['target'] as int;
    final percentage = target > 0 ? progress / target : 0.0;

    return Card(
      elevation: isUnlocked ? 2 : 1,
      margin: const EdgeInsets.only(bottom: 12),
      color: isUnlocked ? null : Colors.grey[100],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Icon
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: isUnlocked ? Colors.blue.shade50 : Colors.grey[300],
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  achievement['icon'] as String,
                  style: TextStyle(
                    fontSize: 28,
                    color: isUnlocked ? null : Colors.grey[500],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    achievement['name'] as String,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isUnlocked ? null : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    achievement['description'] as String,
                    style: TextStyle(
                      fontSize: 14,
                      color: isUnlocked ? Colors.grey[600] : Colors.grey[500],
                    ),
                  ),
                  if (!isUnlocked) ...[
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: percentage,
                        minHeight: 6,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade700),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$progress / $target',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // XP Reward
            Column(
              children: [
                Icon(
                  isUnlocked ? Icons.check_circle : Icons.lock,
                  color: isUnlocked ? Colors.green : Colors.grey[400],
                  size: 24,
                ),
                const SizedBox(height: 4),
                Text(
                  '+${achievement['xp_reward']} XP',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isUnlocked ? Colors.blue.shade700 : Colors.grey[500],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStreakInfo() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              '7-Day Streak Bonus',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                7,
                (index) => Column(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: index < 3 ? Colors.orange : Colors.grey[200],
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${(index + 1) * 50}',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: index < 3 ? Colors.white : Colors.grey[600],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'D${index + 1}',
                      style: const TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _claimDailyBonus() async {
    try {
      // final bonus = await _gamificationService.claimDailyBonus();

      // if (bonus != null) {
      //   setState(() {
      //     _canClaimBonus = false;
      //     _dailyBonus = bonus;
      //   });

      //   _showBonusClaimedDialog(bonus);
      // }

      // Mock
      setState(() => _canClaimBonus = false);
      _showBonusClaimedDialog({'reward_value': 150, 'day_number': 3});
    } catch (e) {
      debugPrint('Error claiming daily bonus: $e');
    }
  }

  void _showBonusClaimedDialog(Map<String, dynamic> bonus) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '🎉',
              style: TextStyle(fontSize: 64),
            ),
            const SizedBox(height: 16),
            const Text(
              'Bonus Claimed!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '+${bonus['reward_value']} XP',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.orange.shade700,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Day ${bonus['day_number']} bonus',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Awesome!'),
          ),
        ],
      ),
    );
  }
}
