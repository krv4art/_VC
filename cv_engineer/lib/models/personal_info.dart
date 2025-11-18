import 'dart:convert';

/// Personal information model for resume
class PersonalInfo {
  final String fullName;
  final String email;
  final String phone;
  final String? address;
  final String? city;
  final String? country;
  final String? postalCode;
  final String? website;
  final String? linkedin;
  final String? github;
  final String? profileSummary;
  final String? photoPath;

  PersonalInfo({
    required this.fullName,
    required this.email,
    required this.phone,
    this.address,
    this.city,
    this.country,
    this.postalCode,
    this.website,
    this.linkedin,
    this.github,
    this.profileSummary,
    this.photoPath,
  });

  PersonalInfo copyWith({
    String? fullName,
    String? email,
    String? phone,
    String? address,
    String? city,
    String? country,
    String? postalCode,
    String? website,
    String? linkedin,
    String? github,
    String? profileSummary,
    String? photoPath,
  }) {
    return PersonalInfo(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      city: city ?? this.city,
      country: country ?? this.country,
      postalCode: postalCode ?? this.postalCode,
      website: website ?? this.website,
      linkedin: linkedin ?? this.linkedin,
      github: github ?? this.github,
      profileSummary: profileSummary ?? this.profileSummary,
      photoPath: photoPath ?? this.photoPath,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'address': address,
      'city': city,
      'country': country,
      'postalCode': postalCode,
      'website': website,
      'linkedin': linkedin,
      'github': github,
      'profileSummary': profileSummary,
      'photoPath': photoPath,
    };
  }

  factory PersonalInfo.fromJson(Map<String, dynamic> json) {
    return PersonalInfo(
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'],
      city: json['city'],
      country: json['country'],
      postalCode: json['postalCode'],
      website: json['website'],
      linkedin: json['linkedin'],
      github: json['github'],
      profileSummary: json['profileSummary'],
      photoPath: json['photoPath'],
    );
  }

  String toJsonString() => jsonEncode(toJson());

  factory PersonalInfo.fromJsonString(String jsonString) {
    return PersonalInfo.fromJson(jsonDecode(jsonString));
  }

  static PersonalInfo empty() {
    return PersonalInfo(
      fullName: '',
      email: '',
      phone: '',
    );
  }
}
