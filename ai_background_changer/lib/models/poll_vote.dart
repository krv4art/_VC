/// Model for poll votes
class PollVote {
  final String id;
  final String pollOptionId;
  final String deviceId;
  final DateTime createdAt;

  const PollVote({
    required this.id,
    required this.pollOptionId,
    required this.deviceId,
    required this.createdAt,
  });

  factory PollVote.fromJson(Map<String, dynamic> json) {
    return PollVote(
      id: json['id'] as String,
      pollOptionId: json['poll_option_id'] as String,
      deviceId: json['device_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'poll_option_id': pollOptionId,
      'device_id': deviceId,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

/// Filter types for polls
enum PollFilter {
  newest,
  topVoted,
  myVote,
}

extension PollFilterExtension on PollFilter {
  String get displayName {
    switch (this) {
      case PollFilter.newest:
        return 'Newest';
      case PollFilter.topVoted:
        return 'Top Voted';
      case PollFilter.myVote:
        return 'My Vote';
    }
  }

  String get iconName {
    switch (this) {
      case PollFilter.newest:
        return 'access_time';
      case PollFilter.topVoted:
        return 'trending_up';
      case PollFilter.myVote:
        return 'how_to_vote';
    }
  }
}
