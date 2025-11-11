/// Model for fishing spots shared by users
class FishingSpot {
  final int? id;
  final String name;
  final String? description;
  final double latitude;
  final double longitude;
  final String? fishSpecies; // Common fish species at this spot
  final DateTime dateAdded;
  final bool isPublic; // Can be shared with other users
  final String? addedBy; // User ID who added this spot
  final int? rating; // 1-5 stars
  final String? imagePath; // Optional photo of the spot
  final String? waterType; // Lake, River, Ocean, etc.
  final String? accessInfo; // How to get there
  final String? bestTimeToFish; // Morning, Evening, etc.
  final bool isFavorite;

  const FishingSpot({
    this.id,
    required this.name,
    this.description,
    required this.latitude,
    required this.longitude,
    this.fishSpecies,
    required this.dateAdded,
    this.isPublic = true,
    this.addedBy,
    this.rating,
    this.imagePath,
    this.waterType,
    this.accessInfo,
    this.bestTimeToFish,
    this.isFavorite = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'fishSpecies': fishSpecies,
      'dateAdded': dateAdded.toIso8601String(),
      'isPublic': isPublic ? 1 : 0,
      'addedBy': addedBy,
      'rating': rating,
      'imagePath': imagePath,
      'waterType': waterType,
      'accessInfo': accessInfo,
      'bestTimeToFish': bestTimeToFish,
      'isFavorite': isFavorite ? 1 : 0,
    };
  }

  factory FishingSpot.fromMap(Map<String, dynamic> map) {
    return FishingSpot(
      id: map['id'] as int?,
      name: map['name'] as String,
      description: map['description'] as String?,
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
      fishSpecies: map['fishSpecies'] as String?,
      dateAdded: DateTime.parse(map['dateAdded'] as String),
      isPublic: (map['isPublic'] as int) == 1,
      addedBy: map['addedBy'] as String?,
      rating: map['rating'] as int?,
      imagePath: map['imagePath'] as String?,
      waterType: map['waterType'] as String?,
      accessInfo: map['accessInfo'] as String?,
      bestTimeToFish: map['bestTimeToFish'] as String?,
      isFavorite: (map['isFavorite'] as int?) == 1,
    );
  }

  FishingSpot copyWith({
    int? id,
    String? name,
    String? description,
    double? latitude,
    double? longitude,
    String? fishSpecies,
    DateTime? dateAdded,
    bool? isPublic,
    String? addedBy,
    int? rating,
    String? imagePath,
    String? waterType,
    String? accessInfo,
    String? bestTimeToFish,
    bool? isFavorite,
  }) {
    return FishingSpot(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      fishSpecies: fishSpecies ?? this.fishSpecies,
      dateAdded: dateAdded ?? this.dateAdded,
      isPublic: isPublic ?? this.isPublic,
      addedBy: addedBy ?? this.addedBy,
      rating: rating ?? this.rating,
      imagePath: imagePath ?? this.imagePath,
      waterType: waterType ?? this.waterType,
      accessInfo: accessInfo ?? this.accessInfo,
      bestTimeToFish: bestTimeToFish ?? this.bestTimeToFish,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
