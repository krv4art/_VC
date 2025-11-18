import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/friend.dart';
import '../../services/friends_service.dart';
import '../../services/leaderboard_service.dart';
import '../../providers/user_profile_provider.dart';
import '../../providers/auth_provider.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  late FriendsService _friendsService;
  late LeaderboardService _leaderboardService;
  late bool _isRussian;

  List<Friend> _friends = [];
  List<Friend> _pendingRequests = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _friendsService = FriendsService(supabase: Supabase.instance.client);
    _leaderboardService = LeaderboardService(supabase: Supabase.instance.client);
    _loadFriends();
  }

  Future<void> _loadFriends() async {
    setState(() => _isLoading = true);

    final userId = context.read<AuthProvider>().userId;
    if (userId == null) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      final results = await Future.wait([
        _friendsService.getFriends(userId),
        _friendsService.getPendingRequests(userId),
      ]);

      setState(() {
        _friends = results[0] as List<Friend>;
        _pendingRequests = results[1] as List<Friend>;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading friends: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    _isRussian = context.watch<UserProfileProvider>().profile.preferredLanguage == 'ru';

    return Scaffold(
      appBar: AppBar(
        title: Text(_isRussian ? 'Друзья' : 'Friends'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () => _showAddFriendDialog(),
            tooltip: _isRussian ? 'Добавить друга' : 'Add Friend',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadFriends,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Pending requests
                  if (_pendingRequests.isNotEmpty) ...[
                    Text(
                      _isRussian ? 'Запросы в друзья' : 'Friend Requests',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    ..._pendingRequests.map((friend) =>
                        _buildFriendRequestCard(friend)),
                    const SizedBox(height: 24),
                  ],

                  // Friends list
                  Text(
                    _isRussian
                        ? 'Мои друзья (${_friends.length})'
                        : 'My Friends (${_friends.length})',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  if (_friends.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Text(
                          _isRussian
                              ? 'У вас пока нет друзей.\nДобавьте друзей, чтобы соревноваться!'
                              : 'You have no friends yet.\nAdd friends to compete!',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  else
                    ..._friends.map((friend) => _buildFriendCard(friend)),
                ],
              ),
            ),
    );
  }

  Widget _buildFriendRequestCard(Friend friend) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: friend.avatarUrl != null
              ? NetworkImage(friend.avatarUrl!)
              : null,
          child: friend.avatarUrl == null
              ? Text(friend.fullName[0].toUpperCase())
              : null,
        ),
        title: Text(friend.fullName),
        subtitle: Text('🏆 ${friend.totalXp} XP'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.check, color: Colors.green),
              onPressed: () => _acceptFriendRequest(friend.userId),
            ),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.red),
              onPressed: () => _rejectFriendRequest(friend.userId),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFriendCard(Friend friend) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Stack(
          children: [
            CircleAvatar(
              backgroundImage: friend.avatarUrl != null
                  ? NetworkImage(friend.avatarUrl!)
                  : null,
              child: friend.avatarUrl == null
                  ? Text(friend.fullName[0].toUpperCase())
                  : null,
            ),
            if (friend.isOnline)
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
          ],
        ),
        title: Text(friend.fullName),
        subtitle: Row(
          children: [
            Text('🏆 ${friend.totalXp}'),
            const SizedBox(width: 12),
            Text('📊 ${friend.problemsSolved}'),
            const SizedBox(width: 12),
            if (friend.currentStreak > 0)
              Text('🔥 ${friend.currentStreak}'),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () => _showFriendOptions(friend),
        ),
      ),
    );
  }

  Future<void> _showAddFriendDialog() async {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_isRussian ? 'Найти друга' : 'Find Friend'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: _isRussian ? 'Имя пользователя' : 'Username',
            hintText: _isRussian ? 'Введите имя...' : 'Enter name...',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(_isRussian ? 'Отмена' : 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Search and add friend
              Navigator.pop(context);
            },
            child: Text(_isRussian ? 'Поиск' : 'Search'),
          ),
        ],
      ),
    );
  }

  Future<void> _acceptFriendRequest(String friendId) async {
    final userId = context.read<AuthProvider>().userId;
    if (userId == null) return;

    final success = await _friendsService.acceptFriendRequest(
      userId: userId,
      friendId: friendId,
    );

    if (success) {
      _loadFriends();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isRussian ? 'Запрос принят' : 'Friend request accepted',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  Future<void> _rejectFriendRequest(String friendId) async {
    final userId = context.read<AuthProvider>().userId;
    if (userId == null) return;

    final success = await _friendsService.rejectFriendRequest(
      userId: userId,
      friendId: friendId,
    );

    if (success) {
      _loadFriends();
    }
  }

  void _showFriendOptions(Friend friend) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.person_remove, color: Colors.red),
              title: Text(_isRussian ? 'Удалить из друзей' : 'Remove Friend'),
              onTap: () {
                Navigator.pop(context);
                _removeFriend(friend.userId);
              },
            ),
            ListTile(
              leading: const Icon(Icons.block, color: Colors.red),
              title: Text(_isRussian ? 'Заблокировать' : 'Block'),
              onTap: () {
                Navigator.pop(context);
                _blockUser(friend.userId);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _removeFriend(String friendId) async {
    final userId = context.read<AuthProvider>().userId;
    if (userId == null) return;

    final success = await _friendsService.removeFriend(
      userId: userId,
      friendId: friendId,
    );

    if (success) {
      _loadFriends();
    }
  }

  Future<void> _blockUser(String friendId) async {
    final userId = context.read<AuthProvider>().userId;
    if (userId == null) return;

    final success = await _friendsService.blockUser(
      userId: userId,
      blockedUserId: friendId,
    );

    if (success) {
      _loadFriends();
    }
  }
}
