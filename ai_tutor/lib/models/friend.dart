/// Friend model
class Friend {
  final String userId;
  final String fullName;
  final String? avatarUrl;
  final int totalXp;
  final int problemsSolved;
  final int currentStreak;
  final DateTime? lastActive;
  final FriendStatus status;

  Friend({
    required this.userId,
    required this.fullName,
    this.avatarUrl,
    required this.totalXp,
    required this.problemsSolved,
    required this.currentStreak,
    this.lastActive,
    required this.status,
  });

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      userId: json['user_id'] as String,
      fullName: json['full_name'] as String? ?? 'Anonymous',
      avatarUrl: json['avatar_url'] as String?,
      totalXp: json['total_xp'] as int? ?? 0,
      problemsSolved: json['problems_solved'] as int? ?? 0,
      currentStreak: json['current_streak'] as int? ?? 0,
      lastActive: json['last_active'] != null
          ? DateTime.parse(json['last_active'] as String)
          : null,
      status: FriendStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => FriendStatus.pending,
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'full_name': fullName,
        'avatar_url': avatarUrl,
        'total_xp': totalXp,
        'problems_solved': problemsSolved,
        'current_streak': currentStreak,
        'last_active': lastActive?.toIso8601String(),
        'status': status.name,
      };

  /// Check if friend is online (active in last 5 minutes)
  bool get isOnline {
    if (lastActive == null) return false;
    return DateTime.now().difference(lastActive!).inMinutes < 5;
  }
}

enum FriendStatus {
  pending,
  accepted,
  blocked,
}
