import 'package:flutter/foundation.dart';

/// Model for fish identification result from AI
class FishIdentification {
  final int? id;
  final String imagePath;
  final String fishName; // Common name (e.g., "Largemouth Bass")
  final String scientificName; // Scientific name (e.g., "Micropterus salmoides")
  final String habitat; // Habitat information
  final String diet; // Diet information
  final List<String> funFacts; // Fun facts about the fish
  final double confidenceScore; // AI confidence (0.0-1.0)
  final DateTime identifyDate;

  // Optional geographic data
  final String? location;
  final double? latitude;
  final double? longitude;

  // Additional info
  final String? edibility; // "Edible", "Not recommended", "Toxic"
  final String? cookingTips; // Cooking recommendations
  final String? fishingTips; // Tips for catching this fish
  final String? conservationStatus; // "Least Concern", "Endangered", etc.

  FishIdentification({
    this.id,
    required this.imagePath,
    required this.fishName,
    required this.scientificName,
    required this.habitat,
    required this.diet,
    required this.funFacts,
    required this.confidenceScore,
    required this.identifyDate,
    this.location,
    this.latitude,
    this.longitude,
    this.edibility,
    this.cookingTips,
    this.fishingTips,
    this.conservationStatus,
  });

  factory FishIdentification.fromJson(Map<String, dynamic> json) {
    return FishIdentification(
      id: json['id'] as int?,
      imagePath: json['image_path'] as String? ?? '',
      fishName: json['fish_name'] as String? ?? '',
      scientificName: json['scientific_name'] as String? ?? '',
      habitat: json['habitat'] as String? ?? '',
      diet: json['diet'] as String? ?? '',
      funFacts: (json['fun_facts'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      confidenceScore: (json['confidence_score'] as num?)?.toDouble() ?? 0.0,
      identifyDate: json['identify_date'] != null
          ? DateTime.parse(json['identify_date'] as String)
          : DateTime.now(),
      location: json['location'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      edibility: json['edibility'] as String?,
      cookingTips: json['cooking_tips'] as String?,
      fishingTips: json['fishing_tips'] as String?,
      conservationStatus: json['conservation_status'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image_path': imagePath,
      'fish_name': fishName,
      'scientific_name': scientificName,
      'habitat': habitat,
      'diet': diet,
      'fun_facts': funFacts,
      'confidence_score': confidenceScore,
      'identify_date': identifyDate.toIso8601String(),
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'edibility': edibility,
      'cooking_tips': cookingTips,
      'fishing_tips': fishingTips,
      'conservation_status': conservationStatus,
    };
  }

  /// Convert to SQLite map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imagePath': imagePath,
      'fishData': _encodeFishData(),
      'identifyDate': identifyDate.toIso8601String(),
    };
  }

  /// Create from SQLite map
  factory FishIdentification.fromMap(Map<String, dynamic> map) {
    final fishData = _decodeFishData(map['fishData'] as String);
    return FishIdentification(
      id: map['id'] as int?,
      imagePath: map['imagePath'] as String,
      fishName: fishData['fishName'] as String,
      scientificName: fishData['scientificName'] as String,
      habitat: fishData['habitat'] as String,
      diet: fishData['diet'] as String,
      funFacts: (fishData['funFacts'] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
      confidenceScore: fishData['confidenceScore'] as double,
      identifyDate: DateTime.parse(map['identifyDate'] as String),
      location: fishData['location'] as String?,
      latitude: fishData['latitude'] as double?,
      longitude: fishData['longitude'] as double?,
      edibility: fishData['edibility'] as String?,
      cookingTips: fishData['cookingTips'] as String?,
      fishingTips: fishData['fishingTips'] as String?,
      conservationStatus: fishData['conservationStatus'] as String?,
    );
  }

  String _encodeFishData() {
    return toJson().toString();
  }

  static Map<String, dynamic> _decodeFishData(String data) {
    // Simple JSON-like parsing - in production use json.encode/decode
    // For now, returning a mock structure
    return {};
  }

  FishIdentification copyWith({
    int? id,
    String? imagePath,
    String? fishName,
    String? scientificName,
    String? habitat,
    String? diet,
    List<String>? funFacts,
    double? confidenceScore,
    DateTime? identifyDate,
    String? location,
    double? latitude,
    double? longitude,
    String? edibility,
    String? cookingTips,
    String? fishingTips,
    String? conservationStatus,
  }) {
    return FishIdentification(
      id: id ?? this.id,
      imagePath: imagePath ?? this.imagePath,
      fishName: fishName ?? this.fishName,
      scientificName: scientificName ?? this.scientificName,
      habitat: habitat ?? this.habitat,
      diet: diet ?? this.diet,
      funFacts: funFacts ?? this.funFacts,
      confidenceScore: confidenceScore ?? this.confidenceScore,
      identifyDate: identifyDate ?? this.identifyDate,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      edibility: edibility ?? this.edibility,
      cookingTips: cookingTips ?? this.cookingTips,
      fishingTips: fishingTips ?? this.fishingTips,
      conservationStatus: conservationStatus ?? this.conservationStatus,
    );
  }
}
