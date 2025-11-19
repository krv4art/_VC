import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';
import '../../models/leaderboard_entry.dart';
import '../../services/leaderboard_service.dart';
import '../../providers/user_profile_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/progress_provider.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late LeaderboardService _leaderboardService;
  late bool _isRussian;

  List<LeaderboardEntry> _globalLeaderboard = [];
  List<LeaderboardEntry> _friendsLeaderboard = [];
  int? _userRank;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _leaderboardService = LeaderboardService(supabase: Supabase.instance.client);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    final userId = context.read<AuthProvider>().userId;
    if (userId == null) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      final results = await Future.wait([
        _leaderboardService.getGlobalLeaderboard(limit: 100),
        _leaderboardService.getFriendsLeaderboard(userId: userId),
        _leaderboardService.getUserRank(userId),
      ]);

      setState(() {
        _globalLeaderboard = results[0] as List<LeaderboardEntry>;
        _friendsLeaderboard = results[1] as List<LeaderboardEntry>;
        _userRank = results[2] as int?;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading leaderboard: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    _isRussian = context.watch<UserProfileProvider>().profile.preferredLanguage == 'ru';
    final authProvider = context.watch<AuthProvider>();

    // Check if user is anonymous
    if (authProvider.isAnonymous) {
      return Scaffold(
        appBar: AppBar(
          title: Text(_isRussian ? 'Таблица лидеров' : 'Leaderboard'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lock_outline,
                  size: 80,
                  color: Theme.of(context).primaryColor.withOpacity(0.5),
                ),
                const SizedBox(height: 24),
                Text(
                  _isRussian
                      ? 'Требуется авторизация'
                      : 'Authentication Required',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  _isRussian
                      ? 'Войдите в аккаунт, чтобы увидеть таблицу лидеров и соревноваться с друзьями'
                      : 'Sign in to view the leaderboard and compete with friends',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: () => context.push('/login'),
                  icon: const Icon(Icons.login),
                  label: Text(_isRussian ? 'Войти' : 'Sign In'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_isRussian ? 'Таблица лидеров' : 'Leaderboard'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: _isRussian ? 'Глобальная' : 'Global'),
            Tab(text: _isRussian ? 'Друзья' : 'Friends'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // User's rank card
                if (_userRank != null) _buildUserRankCard(),

                // Leaderboard list
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildLeaderboardList(_globalLeaderboard),
                      _buildLeaderboardList(_friendsLeaderboard),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildUserRankCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Text(
                _isRussian ? 'Ваше место' : 'Your Rank',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '#$_userRank',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Container(
            width: 1,
            height: 50,
            color: Colors.white30,
          ),
          Consumer<ProgressProvider>(
            builder: (context, progressProvider, _) {
              final stats = progressProvider.getOverallStats();
              final totalXp = stats['total_problems'] * 10; // 10 XP per problem
              final totalProblems = stats['total_problems'];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatRow(
                    '🏆',
                    '$totalXp XP',
                  ),
                  const SizedBox(height: 4),
                  _buildStatRow(
                    '📊',
                    '$totalProblems ${_isRussian ? "задач" : "problems"}',
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String emoji, String text) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildLeaderboardList(List<LeaderboardEntry> entries) {
    if (entries.isEmpty) {
      return Center(
        child: Text(
          _isRussian
              ? 'Нет данных для отображения'
              : 'No data to display',
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: entries.length,
        itemBuilder: (context, index) {
          final entry = entries[index];
          return _buildLeaderboardItem(entry);
        },
      ),
    );
  }

  Widget _buildLeaderboardItem(LeaderboardEntry entry) {
    final isCurrentUser =
        entry.userId == context.read<AuthProvider>().userId;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isCurrentUser
            ? Theme.of(context).primaryColor.withOpacity(0.1)
            : null,
        border: Border.all(
          color: isCurrentUser
              ? Theme.of(context).primaryColor
              : Colors.grey[300]!,
          width: isCurrentUser ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Rank medal
            _buildRankMedal(entry.rank),
            const SizedBox(width: 12),
            // Avatar
            CircleAvatar(
              backgroundImage: entry.avatarUrl != null
                  ? NetworkImage(entry.avatarUrl!)
                  : null,
              child: entry.avatarUrl == null
                  ? Text(entry.fullName[0].toUpperCase())
                  : null,
            ),
          ],
        ),
        title: Text(
          entry.fullName,
          style: TextStyle(
            fontWeight: isCurrentUser ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        subtitle: Row(
          children: [
            Text('🏆 ${entry.totalXp} XP'),
            const SizedBox(width: 12),
            Text('📊 ${entry.problemsSolved}'),
            const SizedBox(width: 12),
            if (entry.currentStreak > 0)
              Text('🔥 ${entry.currentStreak}'),
          ],
        ),
      ),
    );
  }

  Widget _buildRankMedal(int rank) {
    String medal;
    Color color;

    if (rank == 1) {
      medal = '🥇';
      color = Colors.amber;
    } else if (rank == 2) {
      medal = '🥈';
      color = Colors.grey[400]!;
    } else if (rank == 3) {
      medal = '🥉';
      color = Colors.brown[300]!;
    } else {
      return Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            '$rank',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(medal, style: const TextStyle(fontSize: 20)),
      ),
    );
  }
}
