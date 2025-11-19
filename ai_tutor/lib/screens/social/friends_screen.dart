import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';
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
    final authProvider = context.watch<AuthProvider>();

    // Check if user is anonymous
    if (authProvider.isAnonymous) {
      return Scaffold(
        appBar: AppBar(
          title: Text(_isRussian ? 'Друзья' : 'Friends'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.people_outline,
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
                      ? 'Войдите в аккаунт, чтобы добавлять друзей и соревноваться с ними'
                      : 'Sign in to add friends and compete with them',
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
    List<Friend> searchResults = [];
    bool isSearching = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(_isRussian ? 'Найти друга' : 'Find Friend'),
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      labelText: _isRussian ? 'Имя пользователя' : 'Username',
                      hintText: _isRussian ? 'Введите имя...' : 'Enter name...',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () async {
                          final userId = context.read<AuthProvider>().userId;
                          if (userId == null || controller.text.trim().isEmpty) return;

                          setState(() {
                            isSearching = true;
                          });

                          final results = await _friendsService.searchUsers(
                            query: controller.text.trim(),
                            currentUserId: userId,
                          );

                          setState(() {
                            searchResults = results;
                            isSearching = false;
                          });
                        },
                      ),
                    ),
                    onSubmitted: (value) async {
                      final userId = context.read<AuthProvider>().userId;
                      if (userId == null || value.trim().isEmpty) return;

                      setState(() {
                        isSearching = true;
                      });

                      final results = await _friendsService.searchUsers(
                        query: value.trim(),
                        currentUserId: userId,
                      );

                      setState(() {
                        searchResults = results;
                        isSearching = false;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  if (isSearching)
                    const CircularProgressIndicator()
                  else if (searchResults.isEmpty && controller.text.isNotEmpty)
                    Text(
                      _isRussian ? 'Ничего не найдено' : 'No users found',
                      style: const TextStyle(color: Colors.grey),
                    )
                  else if (searchResults.isNotEmpty)
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: searchResults.length,
                        itemBuilder: (context, index) {
                          final user = searchResults[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: user.avatarUrl != null
                                  ? NetworkImage(user.avatarUrl!)
                                  : null,
                              child: user.avatarUrl == null
                                  ? Text(user.fullName[0].toUpperCase())
                                  : null,
                            ),
                            title: Text(user.fullName),
                            subtitle: Text('${user.totalXp} XP'),
                            trailing: IconButton(
                              icon: const Icon(Icons.person_add),
                              onPressed: () async {
                                final userId = context.read<AuthProvider>().userId;
                                if (userId == null) return;

                                final success = await _friendsService.sendFriendRequest(
                                  fromUserId: userId,
                                  toUserId: user.userId,
                                );

                                if (success) {
                                  if (context.mounted) {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          _isRussian
                                              ? 'Запрос отправлен'
                                              : 'Friend request sent',
                                        ),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  }
                                }
                              },
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(_isRussian ? 'Закрыть' : 'Close'),
              ),
            ],
          );
        },
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
