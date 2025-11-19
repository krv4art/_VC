// models/social_links.dart
// Model for social media and professional links

class SocialLink {
  final String id;
  final SocialPlatform platform;
  final String url;
  final int displayOrder;

  SocialLink({
    required this.id,
    required this.platform,
    required this.url,
    this.displayOrder = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'platform': platform.name,
      'url': url,
      'displayOrder': displayOrder,
    };
  }

  factory SocialLink.fromJson(Map<String, dynamic> json) {
    return SocialLink(
      id: json['id'] as String,
      platform: SocialPlatform.values.firstWhere(
        (p) => p.name == json['platform'],
        orElse: () => SocialPlatform.other,
      ),
      url: json['url'] as String,
      displayOrder: json['displayOrder'] as int? ?? 0,
    );
  }

  SocialLink copyWith({
    String? id,
    SocialPlatform? platform,
    String? url,
    int? displayOrder,
  }) {
    return SocialLink(
      id: id ?? this.id,
      platform: platform ?? this.platform,
      url: url ?? this.url,
      displayOrder: displayOrder ?? this.displayOrder,
    );
  }
}

enum SocialPlatform {
  linkedin,
  github,
  twitter,
  portfolio,
  website,
  behance,
  dribbble,
  medium,
  stackoverflow,
  youtube,
  instagram,
  facebook,
  other;

  String get displayName {
    switch (this) {
      case SocialPlatform.linkedin:
        return 'LinkedIn';
      case SocialPlatform.github:
        return 'GitHub';
      case SocialPlatform.twitter:
        return 'Twitter/X';
      case SocialPlatform.portfolio:
        return 'Portfolio';
      case SocialPlatform.website:
        return 'Website';
      case SocialPlatform.behance:
        return 'Behance';
      case SocialPlatform.dribbble:
        return 'Dribbble';
      case SocialPlatform.medium:
        return 'Medium';
      case SocialPlatform.stackoverflow:
        return 'Stack Overflow';
      case SocialPlatform.youtube:
        return 'YouTube';
      case SocialPlatform.instagram:
        return 'Instagram';
      case SocialPlatform.facebook:
        return 'Facebook';
      case SocialPlatform.other:
        return 'Other';
    }
  }

  String get placeholder {
    switch (this) {
      case SocialPlatform.linkedin:
        return 'https://linkedin.com/in/yourprofile';
      case SocialPlatform.github:
        return 'https://github.com/yourusername';
      case SocialPlatform.twitter:
        return 'https://twitter.com/yourusername';
      case SocialPlatform.portfolio:
        return 'https://yourportfolio.com';
      case SocialPlatform.website:
        return 'https://yourwebsite.com';
      case SocialPlatform.behance:
        return 'https://behance.net/yourprofile';
      case SocialPlatform.dribbble:
        return 'https://dribbble.com/yourusername';
      case SocialPlatform.medium:
        return 'https://medium.com/@yourusername';
      case SocialPlatform.stackoverflow:
        return 'https://stackoverflow.com/users/yourprofile';
      default:
        return 'https://';
    }
  }
}
