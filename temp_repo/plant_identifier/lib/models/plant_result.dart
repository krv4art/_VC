/// Model for plant identification result
class PlantResult {
  final String id;
  final String plantName;
  final String scientificName;
  final String description;
  final PlantType type; // plant, mushroom, herb, etc.
  final String imageUrl;
  final DateTime identifiedAt;

  // Care information
  final PlantCareInfo? careInfo;

  // Additional details
  final List<String> commonNames;
  final String? family;
  final String? origin;
  final bool isToxic;
  final bool isEdible;
  final List<String> usesAndBenefits;

  // Confidence score
  final double confidence;

  PlantResult({
    required this.id,
    required this.plantName,
    required this.scientificName,
    required this.description,
    required this.type,
    required this.imageUrl,
    required this.identifiedAt,
    this.careInfo,
    this.commonNames = const [],
    this.family,
    this.origin,
    this.isToxic = false,
    this.isEdible = false,
    this.usesAndBenefits = const [],
    this.confidence = 0.0,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plantName': plantName,
      'scientificName': scientificName,
      'description': description,
      'type': type.toString().split('.').last,
      'imageUrl': imageUrl,
      'identifiedAt': identifiedAt.toIso8601String(),
      'careInfo': careInfo?.toJson(),
      'commonNames': commonNames,
      'family': family,
      'origin': origin,
      'isToxic': isToxic,
      'isEdible': isEdible,
      'usesAndBenefits': usesAndBenefits,
      'confidence': confidence,
    };
  }

  factory PlantResult.fromJson(Map<String, dynamic> json) {
    return PlantResult(
      id: json['id'] as String,
      plantName: json['plantName'] as String,
      scientificName: json['scientificName'] as String,
      description: json['description'] as String,
      type: PlantType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => PlantType.plant,
      ),
      imageUrl: json['imageUrl'] as String,
      identifiedAt: DateTime.parse(json['identifiedAt'] as String),
      careInfo: json['careInfo'] != null
          ? PlantCareInfo.fromJson(json['careInfo'] as Map<String, dynamic>)
          : null,
      commonNames: (json['commonNames'] as List<dynamic>?)?.cast<String>() ?? [],
      family: json['family'] as String?,
      origin: json['origin'] as String?,
      isToxic: json['isToxic'] as bool? ?? false,
      isEdible: json['isEdible'] as bool? ?? false,
      usesAndBenefits: (json['usesAndBenefits'] as List<dynamic>?)?.cast<String>() ?? [],
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

/// Plant care information
class PlantCareInfo {
  final String wateringFrequency;
  final String sunlightRequirement;
  final String soilType;
  final String temperature;
  final String humidity;
  final String fertilizer;
  final List<String> commonPests;
  final List<String> commonDiseases;

  PlantCareInfo({
    required this.wateringFrequency,
    required this.sunlightRequirement,
    required this.soilType,
    required this.temperature,
    required this.humidity,
    required this.fertilizer,
    this.commonPests = const [],
    this.commonDiseases = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'wateringFrequency': wateringFrequency,
      'sunlightRequirement': sunlightRequirement,
      'soilType': soilType,
      'temperature': temperature,
      'humidity': humidity,
      'fertilizer': fertilizer,
      'commonPests': commonPests,
      'commonDiseases': commonDiseases,
    };
  }

  factory PlantCareInfo.fromJson(Map<String, dynamic> json) {
    return PlantCareInfo(
      wateringFrequency: json['wateringFrequency'] as String,
      sunlightRequirement: json['sunlightRequirement'] as String,
      soilType: json['soilType'] as String,
      temperature: json['temperature'] as String,
      humidity: json['humidity'] as String,
      fertilizer: json['fertilizer'] as String,
      commonPests: (json['commonPests'] as List<dynamic>?)?.cast<String>() ?? [],
      commonDiseases: (json['commonDiseases'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }
}

/// Types of plants
enum PlantType {
  plant,      // Regular plants
  mushroom,   // Fungi
  herb,       // Herbs
  tree,       // Trees
  flower,     // Flowering plants
  succulent,  // Succulents
  fern,       // Ferns
  moss,       // Mosses
  cactus,     // Cacti
  unknown,    // Unknown type
}
