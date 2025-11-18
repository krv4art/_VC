/// Leaderboard entry model
class LeaderboardEntry {
  final String userId;
  final String fullName;
  final int totalXp;
  final int problemsSolved;
  final int currentStreak;
  final String? avatarUrl;
  final int rank;

  LeaderboardEntry({
    required this.userId,
    required this.fullName,
    required this.totalXp,
    required this.problemsSolved,
    required this.currentStreak,
    this.avatarUrl,
    required this.rank,
  });

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json, int rank) {
    return LeaderboardEntry(
      userId: json['user_id'] as String,
      fullName: json['full_name'] as String? ?? 'Anonymous',
      totalXp: json['total_xp'] as int? ?? 0,
      problemsSolved: json['problems_solved'] as int? ?? 0,
      currentStreak: json['current_streak'] as int? ?? 0,
      avatarUrl: json['avatar_url'] as String?,
      rank: rank,
    );
  }

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'full_name': fullName,
        'total_xp': totalXp,
        'problems_solved': problemsSolved,
        'current_streak': currentStreak,
        'avatar_url': avatarUrl,
        'rank': rank,
      };
}
