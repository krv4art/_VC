/// Model for feature poll options
class PollOption {
  final String id;
  final String title;
  final String description;
  final int votesCount;
  final DateTime createdAt;
  final bool hasVoted;

  const PollOption({
    required this.id,
    required this.title,
    required this.description,
    this.votesCount = 0,
    required this.createdAt,
    this.hasVoted = false,
  });

  factory PollOption.fromJson(Map<String, dynamic> json) {
    return PollOption(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      votesCount: json['votes_count'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      hasVoted: json['has_voted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'votes_count': votesCount,
      'created_at': createdAt.toIso8601String(),
      'has_voted': hasVoted,
    };
  }

  PollOption copyWith({
    String? id,
    String? title,
    String? description,
    int? votesCount,
    DateTime? createdAt,
    bool? hasVoted,
  }) {
    return PollOption(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      votesCount: votesCount ?? this.votesCount,
      createdAt: createdAt ?? this.createdAt,
      hasVoted: hasVoted ?? this.hasVoted,
    );
  }
}
