import 'package:flutter/material.dart';
import '../services/analytics_service.dart';
import '../services/gamification_service.dart';

/// Analytics dashboard showing user statistics and insights
class AnalyticsDashboardScreen extends StatefulWidget {
  const AnalyticsDashboardScreen({Key? key}) : super(key: key);

  @override
  State<AnalyticsDashboardScreen> createState() => _AnalyticsDashboardScreenState();
}

class _AnalyticsDashboardScreenState extends State<AnalyticsDashboardScreen> {
  // late AnalyticsService _analyticsService;
  // late GamificationService _gamificationService;

  Map<String, dynamic>? _statistics;
  Map<String, dynamic>? _userProgress;
  List<Map<String, dynamic>> _styleUsage = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAnalytics();
  }

  Future<void> _loadAnalytics() async {
    setState(() => _isLoading = true);

    try {
      // Initialize services
      // final db = await DatabaseService.instance.database;
      // _analyticsService = AnalyticsService(db);
      // _gamificationService = GamificationService(db);

      // Load data
      // final stats = await _analyticsService.getUserStatistics();
      // final progress = await _gamificationService.getUserProgress();
      // final styleStats = await _analyticsService.getStyleUsageStats();

      // setState(() {
      //   _statistics = stats;
      //   _userProgress = progress;
      //   _styleUsage = styleStats;
      //   _isLoading = false;
      // });

      // Mock data for now
      setState(() {
        _statistics = {
          'total_photos_generated': 42,
          'total_photos_saved': 38,
          'total_photos_shared': 15,
          'total_app_opens': 127,
          'total_time_spent_seconds': 7200,
        };
        _userProgress = {
          'level': 5,
          'total_xp': 2500,
          'days_streak': 7,
          'photos_generated': 42,
        };
        _styleUsage = [
          {'style_name': 'Professional', 'times_used': 15},
          {'style_name': 'Casual', 'times_used': 12},
          {'style_name': 'Creative', 'times_used': 8},
          {'style_name': 'Outdoor', 'times_used': 7},
        ];
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading analytics: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Analytics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAnalytics,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadAnalytics,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User Level Card
                    _buildLevelCard(),
                    const SizedBox(height: 16),

                    // Quick Stats Grid
                    _buildQuickStatsGrid(),
                    const SizedBox(height: 24),

                    // Engagement Section
                    _buildSectionTitle('Engagement'),
                    const SizedBox(height: 12),
                    _buildEngagementCard(),
                    const SizedBox(height: 24),

                    // Style Usage Section
                    _buildSectionTitle('Favorite Styles'),
                    const SizedBox(height: 12),
                    _buildStyleUsageList(),
                    const SizedBox(height: 24),

                    // Activity Timeline
                    _buildSectionTitle('Recent Activity'),
                    const SizedBox(height: 12),
                    _buildActivityTimeline(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildLevelCard() {
    if (_userProgress == null) return const SizedBox.shrink();

    final level = _userProgress!['level'] as int;
    final xp = _userProgress!['total_xp'] as int;
    final xpForNextLevel = level * 1000;
    final xpProgress = (xp % 1000) / 1000;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [Colors.purple.shade400, Colors.blue.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your Level',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'Level $level',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '🏆',
                    style: const TextStyle(fontSize: 32),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$xp XP',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      '$xpForNextLevel XP',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: xpProgress,
                    minHeight: 8,
                    backgroundColor: Colors.white.withOpacity(0.3),
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStatsGrid() {
    if (_statistics == null) return const SizedBox.shrink();

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard(
          'Photos Generated',
          '${_statistics!['total_photos_generated']}',
          Icons.photo_camera,
          Colors.blue,
        ),
        _buildStatCard(
          'Photos Saved',
          '${_statistics!['total_photos_saved']}',
          Icons.save_alt,
          Colors.green,
        ),
        _buildStatCard(
          'Photos Shared',
          '${_statistics!['total_photos_shared']}',
          Icons.share,
          Colors.orange,
        ),
        _buildStatCard(
          'App Opens',
          '${_statistics!['total_app_opens']}',
          Icons.touch_app,
          Colors.purple,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ),
                Icon(icon, color: color, size: 20),
              ],
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEngagementCard() {
    final streak = _userProgress?['days_streak'] ?? 0;
    final timeSpent = _statistics?['total_time_spent_seconds'] ?? 0;
    final hours = (timeSpent / 3600).toStringAsFixed(1);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildEngagementRow('🔥 Day Streak', '$streak days'),
            const Divider(height: 24),
            _buildEngagementRow('⏱️ Time Spent', '$hours hours'),
            const Divider(height: 24),
            _buildEngagementRow('📊 Engagement Score', '85/100'),
          ],
        ),
      ),
    );
  }

  Widget _buildEngagementRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildStyleUsageList() {
    if (_styleUsage.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Center(
            child: Text('No style usage data yet'),
          ),
        ),
      );
    }

    final maxUsage = _styleUsage.first['times_used'] as int;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: _styleUsage.length,
        separatorBuilder: (_, __) => const Divider(height: 16),
        itemBuilder: (context, index) {
          final style = _styleUsage[index];
          final name = style['style_name'] as String;
          final usage = style['times_used'] as int;
          final percentage = usage / maxUsage;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '$usage times',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: percentage,
                  minHeight: 6,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.blue.shade400,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildActivityTimeline() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildActivityItem('Generated 3 photos', '2 hours ago', Icons.photo),
            _buildActivityItem('Shared photo to Instagram', '5 hours ago', Icons.share),
            _buildActivityItem('Unlocked achievement', 'Yesterday', Icons.emoji_events),
            _buildActivityItem('Reached Level 5', '2 days ago', Icons.arrow_upward),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(String title, String time, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: Colors.blue.shade700),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
