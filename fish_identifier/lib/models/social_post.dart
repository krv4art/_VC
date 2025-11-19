/// Model for social feed posts
class SocialPost {
  final String id;
  final String userId;
  final String userName;
  final String? userAvatarUrl;
  final String? fishIdentificationId;
  final String? fishName;
  final String? fishImageUrl;
  final String caption;
  final String? location;
  final double? latitude;
  final double? longitude;
  final double? fishLength; // cm
  final double? fishWeight; // kg
  final List<String> hashtags;
  final int likesCount;
  final int commentsCount;
  final int sharesCount;
  final bool isPublic;
  final bool isLikedByCurrentUser;
  final DateTime createdAt;
  final DateTime? updatedAt;

  SocialPost({
    required this.id,
    required this.userId,
    required this.userName,
    this.userAvatarUrl,
    this.fishIdentificationId,
    this.fishName,
    this.fishImageUrl,
    required this.caption,
    this.location,
    this.latitude,
    this.longitude,
    this.fishLength,
    this.fishWeight,
    this.hashtags = const [],
    this.likesCount = 0,
    this.commentsCount = 0,
    this.sharesCount = 0,
    this.isPublic = true,
    this.isLikedByCurrentUser = false,
    required this.createdAt,
    this.updatedAt,
  });

  factory SocialPost.fromJson(Map<String, dynamic> json) {
    return SocialPost(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      userName: json['user_name'] as String,
      userAvatarUrl: json['user_avatar_url'] as String?,
      fishIdentificationId: json['fish_identification_id'] as String?,
      fishName: json['fish_name'] as String?,
      fishImageUrl: json['fish_image_url'] as String?,
      caption: json['caption'] as String,
      location: json['location'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      fishLength: (json['fish_length'] as num?)?.toDouble(),
      fishWeight: (json['fish_weight'] as num?)?.toDouble(),
      hashtags: (json['hashtags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      likesCount: json['likes_count'] as int? ?? 0,
      commentsCount: json['comments_count'] as int? ?? 0,
      sharesCount: json['shares_count'] as int? ?? 0,
      isPublic: json['is_public'] as bool? ?? true,
      isLikedByCurrentUser: json['is_liked_by_current_user'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'user_name': userName,
      'user_avatar_url': userAvatarUrl,
      'fish_identification_id': fishIdentificationId,
      'fish_name': fishName,
      'fish_image_url': fishImageUrl,
      'caption': caption,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'fish_length': fishLength,
      'fish_weight': fishWeight,
      'hashtags': hashtags,
      'likes_count': likesCount,
      'comments_count': commentsCount,
      'shares_count': sharesCount,
      'is_public': isPublic,
      'is_liked_by_current_user': isLikedByCurrentUser,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  SocialPost copyWith({
    int? likesCount,
    int? commentsCount,
    int? sharesCount,
    bool? isLikedByCurrentUser,
  }) {
    return SocialPost(
      id: id,
      userId: userId,
      userName: userName,
      userAvatarUrl: userAvatarUrl,
      fishIdentificationId: fishIdentificationId,
      fishName: fishName,
      fishImageUrl: fishImageUrl,
      caption: caption,
      location: location,
      latitude: latitude,
      longitude: longitude,
      fishLength: fishLength,
      fishWeight: fishWeight,
      hashtags: hashtags,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      sharesCount: sharesCount ?? this.sharesCount,
      isPublic: isPublic,
      isLikedByCurrentUser: isLikedByCurrentUser ?? this.isLikedByCurrentUser,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

/// Model for post comments
class PostComment {
  final String id;
  final String postId;
  final String userId;
  final String userName;
  final String? userAvatarUrl;
  final String comment;
  final int likesCount;
  final bool isLikedByCurrentUser;
  final DateTime createdAt;

  PostComment({
    required this.id,
    required this.postId,
    required this.userId,
    required this.userName,
    this.userAvatarUrl,
    required this.comment,
    this.likesCount = 0,
    this.isLikedByCurrentUser = false,
    required this.createdAt,
  });

  factory PostComment.fromJson(Map<String, dynamic> json) {
    return PostComment(
      id: json['id'] as String,
      postId: json['post_id'] as String,
      userId: json['user_id'] as String,
      userName: json['user_name'] as String,
      userAvatarUrl: json['user_avatar_url'] as String?,
      comment: json['comment'] as String,
      likesCount: json['likes_count'] as int? ?? 0,
      isLikedByCurrentUser: json['is_liked_by_current_user'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'post_id': postId,
      'user_id': userId,
      'user_name': userName,
      'user_avatar_url': userAvatarUrl,
      'comment': comment,
      'likes_count': likesCount,
      'is_liked_by_current_user': isLikedByCurrentUser,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

/// Model for user profile
class UserProfile {
  final String id;
  final String userName;
  final String? displayName;
  final String? avatarUrl;
  final String? bio;
  final String? location;
  final int postsCount;
  final int followersCount;
  final int followingCount;
  final int totalCatches;
  final int speciesCount;
  final bool isFollowedByCurrentUser;
  final DateTime joinedAt;

  UserProfile({
    required this.id,
    required this.userName,
    this.displayName,
    this.avatarUrl,
    this.bio,
    this.location,
    this.postsCount = 0,
    this.followersCount = 0,
    this.followingCount = 0,
    this.totalCatches = 0,
    this.speciesCount = 0,
    this.isFollowedByCurrentUser = false,
    required this.joinedAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      userName: json['user_name'] as String,
      displayName: json['display_name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      bio: json['bio'] as String?,
      location: json['location'] as String?,
      postsCount: json['posts_count'] as int? ?? 0,
      followersCount: json['followers_count'] as int? ?? 0,
      followingCount: json['following_count'] as int? ?? 0,
      totalCatches: json['total_catches'] as int? ?? 0,
      speciesCount: json['species_count'] as int? ?? 0,
      isFollowedByCurrentUser:
          json['is_followed_by_current_user'] as bool? ?? false,
      joinedAt: DateTime.parse(json['joined_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_name': userName,
      'display_name': displayName,
      'avatar_url': avatarUrl,
      'bio': bio,
      'location': location,
      'posts_count': postsCount,
      'followers_count': followersCount,
      'following_count': followingCount,
      'total_catches': totalCatches,
      'species_count': speciesCount,
      'is_followed_by_current_user': isFollowedByCurrentUser,
      'joined_at': joinedAt.toIso8601String(),
    };
  }
}
