/// Model for user's personal fish collection (catches)
class FishCollection {
  final int? id;
  final int fishIdentificationId; // Reference to fish_identifications table
  final DateTime catchDate;
  final String? location; // Name of the location (e.g., "Lake Michigan")
  final double? latitude;
  final double? longitude;
  final String? notes; // User notes about this catch
  final bool isFavorite;
  final double? weight; // Weight in kg
  final double? length; // Length in cm
  final String? weatherConditions; // Weather during catch
  final String? baitUsed; // Type of bait/lure used

  FishCollection({
    this.id,
    required this.fishIdentificationId,
    required this.catchDate,
    this.location,
    this.latitude,
    this.longitude,
    this.notes,
    this.isFavorite = false,
    this.weight,
    this.length,
    this.weatherConditions,
    this.baitUsed,
  });

  factory FishCollection.fromMap(Map<String, dynamic> map) {
    return FishCollection(
      id: map['id'] as int?,
      fishIdentificationId: map['fishIdentificationId'] as int,
      catchDate: DateTime.parse(map['catchDate'] as String),
      location: map['location'] as String?,
      latitude: (map['latitude'] as num?)?.toDouble(),
      longitude: (map['longitude'] as num?)?.toDouble(),
      notes: map['notes'] as String?,
      isFavorite: (map['isFavorite'] as int?) == 1,
      weight: (map['weight'] as num?)?.toDouble(),
      length: (map['length'] as num?)?.toDouble(),
      weatherConditions: map['weatherConditions'] as String?,
      baitUsed: map['baitUsed'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fishIdentificationId': fishIdentificationId,
      'catchDate': catchDate.toIso8601String(),
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'notes': notes,
      'isFavorite': isFavorite ? 1 : 0,
      'weight': weight,
      'length': length,
      'weatherConditions': weatherConditions,
      'baitUsed': baitUsed,
    };
  }

  FishCollection copyWith({
    int? id,
    int? fishIdentificationId,
    DateTime? catchDate,
    String? location,
    double? latitude,
    double? longitude,
    String? notes,
    bool? isFavorite,
    double? weight,
    double? length,
    String? weatherConditions,
    String? baitUsed,
  }) {
    return FishCollection(
      id: id ?? this.id,
      fishIdentificationId: fishIdentificationId ?? this.fishIdentificationId,
      catchDate: catchDate ?? this.catchDate,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      notes: notes ?? this.notes,
      isFavorite: isFavorite ?? this.isFavorite,
      weight: weight ?? this.weight,
      length: length ?? this.length,
      weatherConditions: weatherConditions ?? this.weatherConditions,
      baitUsed: baitUsed ?? this.baitUsed,
    );
  }
}
