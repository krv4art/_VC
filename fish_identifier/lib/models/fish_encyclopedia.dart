/// Model for fish encyclopedia entries
class FishSpecies {
  final String id;
  final String commonName;
  final String scientificName;
  final List<String> alternativeNames;
  final TaxonomyData taxonomy;
  final String description;
  final String habitat;
  final String diet;
  final SizeData size;
  final String lifespan;
  final String behavior;
  final ConservationStatus conservationStatus;
  final FishingInfo fishingInfo;
  final CookingInfo cookingInfo;
  final List<String> imageUrls;
  final GeographicDistribution distribution;
  final bool isPremium; // Premium encyclopedia access

  FishSpecies({
    required this.id,
    required this.commonName,
    required this.scientificName,
    this.alternativeNames = const [],
    required this.taxonomy,
    required this.description,
    required this.habitat,
    required this.diet,
    required this.size,
    required this.lifespan,
    required this.behavior,
    required this.conservationStatus,
    required this.fishingInfo,
    required this.cookingInfo,
    this.imageUrls = const [],
    required this.distribution,
    this.isPremium = false,
  });

  factory FishSpecies.fromJson(Map<String, dynamic> json) {
    return FishSpecies(
      id: json['id'] as String,
      commonName: json['common_name'] as String,
      scientificName: json['scientific_name'] as String,
      alternativeNames: (json['alternative_names'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      taxonomy:
          TaxonomyData.fromJson(json['taxonomy'] as Map<String, dynamic>),
      description: json['description'] as String,
      habitat: json['habitat'] as String,
      diet: json['diet'] as String,
      size: SizeData.fromJson(json['size'] as Map<String, dynamic>),
      lifespan: json['lifespan'] as String,
      behavior: json['behavior'] as String,
      conservationStatus: ConservationStatus.values.firstWhere(
        (e) =>
            e.toString() == 'ConservationStatus.${json['conservation_status']}',
      ),
      fishingInfo:
          FishingInfo.fromJson(json['fishing_info'] as Map<String, dynamic>),
      cookingInfo:
          CookingInfo.fromJson(json['cooking_info'] as Map<String, dynamic>),
      imageUrls: (json['image_urls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      distribution: GeographicDistribution.fromJson(
          json['distribution'] as Map<String, dynamic>),
      isPremium: json['is_premium'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'common_name': commonName,
      'scientific_name': scientificName,
      'alternative_names': alternativeNames,
      'taxonomy': taxonomy.toJson(),
      'description': description,
      'habitat': habitat,
      'diet': diet,
      'size': size.toJson(),
      'lifespan': lifespan,
      'behavior': behavior,
      'conservation_status': conservationStatus.toString().split('.').last,
      'fishing_info': fishingInfo.toJson(),
      'cooking_info': cookingInfo.toJson(),
      'image_urls': imageUrls,
      'distribution': distribution.toJson(),
      'is_premium': isPremium,
    };
  }
}

/// Taxonomy classification
class TaxonomyData {
  final String kingdom;
  final String phylum;
  final String taxClass; // 'class' is reserved keyword
  final String order;
  final String family;
  final String genus;
  final String species;

  TaxonomyData({
    required this.kingdom,
    required this.phylum,
    required this.taxClass,
    required this.order,
    required this.family,
    required this.genus,
    required this.species,
  });

  factory TaxonomyData.fromJson(Map<String, dynamic> json) {
    return TaxonomyData(
      kingdom: json['kingdom'] as String,
      phylum: json['phylum'] as String,
      taxClass: json['class'] as String,
      order: json['order'] as String,
      family: json['family'] as String,
      genus: json['genus'] as String,
      species: json['species'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kingdom': kingdom,
      'phylum': phylum,
      'class': taxClass,
      'order': order,
      'family': family,
      'genus': genus,
      'species': species,
    };
  }
}

/// Size information
class SizeData {
  final double averageLength; // cm
  final double maxLength; // cm
  final double averageWeight; // kg
  final double maxWeight; // kg
  final String? worldRecord;

  SizeData({
    required this.averageLength,
    required this.maxLength,
    required this.averageWeight,
    required this.maxWeight,
    this.worldRecord,
  });

  factory SizeData.fromJson(Map<String, dynamic> json) {
    return SizeData(
      averageLength: (json['average_length'] as num).toDouble(),
      maxLength: (json['max_length'] as num).toDouble(),
      averageWeight: (json['average_weight'] as num).toDouble(),
      maxWeight: (json['max_weight'] as num).toDouble(),
      worldRecord: json['world_record'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'average_length': averageLength,
      'max_length': maxLength,
      'average_weight': averageWeight,
      'max_weight': maxWeight,
      'world_record': worldRecord,
    };
  }
}

/// Conservation status
enum ConservationStatus {
  extinct,
  extinctInWild,
  criticallyEndangered,
  endangered,
  vulnerable,
  nearThreatened,
  leastConcern,
  dataDeficient,
  notEvaluated,
}

/// Fishing information
class FishingInfo {
  final List<String> techniques;
  final List<String> bestBaits;
  final List<String> bestLures;
  final String bestTime; // "Dawn and dusk"
  final String bestSeason;
  final List<String> habitat;
  final int difficulty; // 1-10
  final bool isGameFish;

  FishingInfo({
    required this.techniques,
    required this.bestBaits,
    required this.bestLures,
    required this.bestTime,
    required this.bestSeason,
    required this.habitat,
    required this.difficulty,
    this.isGameFish = false,
  });

  factory FishingInfo.fromJson(Map<String, dynamic> json) {
    return FishingInfo(
      techniques: (json['techniques'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      bestBaits: (json['best_baits'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      bestLures: (json['best_lures'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      bestTime: json['best_time'] as String,
      bestSeason: json['best_season'] as String,
      habitat:
          (json['habitat'] as List<dynamic>).map((e) => e as String).toList(),
      difficulty: json['difficulty'] as int,
      isGameFish: json['is_game_fish'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'techniques': techniques,
      'best_baits': bestBaits,
      'best_lures': bestLures,
      'best_time': bestTime,
      'best_season': bestSeason,
      'habitat': habitat,
      'difficulty': difficulty,
      'is_game_fish': isGameFish,
    };
  }
}

/// Cooking information
class CookingInfo {
  final bool isEdible;
  final String? taste;
  final String? texture;
  final List<String> cookingMethods;
  final List<String> recipes;
  final String? nutritionalInfo;
  final List<String>? warnings; // Mercury content, parasites, etc.

  CookingInfo({
    required this.isEdible,
    this.taste,
    this.texture,
    this.cookingMethods = const [],
    this.recipes = const [],
    this.nutritionalInfo,
    this.warnings,
  });

  factory CookingInfo.fromJson(Map<String, dynamic> json) {
    return CookingInfo(
      isEdible: json['is_edible'] as bool,
      taste: json['taste'] as String?,
      texture: json['texture'] as String?,
      cookingMethods: (json['cooking_methods'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      recipes: (json['recipes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      nutritionalInfo: json['nutritional_info'] as String?,
      warnings: (json['warnings'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'is_edible': isEdible,
      'taste': taste,
      'texture': texture,
      'cooking_methods': cookingMethods,
      'recipes': recipes,
      'nutritional_info': nutritionalInfo,
      'warnings': warnings,
    };
  }
}

/// Geographic distribution
class GeographicDistribution {
  final List<String> regions;
  final String? nativeRange;
  final List<String>? introducedTo;
  final String waterType; // "Freshwater", "Saltwater", "Brackish"

  GeographicDistribution({
    required this.regions,
    this.nativeRange,
    this.introducedTo,
    required this.waterType,
  });

  factory GeographicDistribution.fromJson(Map<String, dynamic> json) {
    return GeographicDistribution(
      regions:
          (json['regions'] as List<dynamic>).map((e) => e as String).toList(),
      nativeRange: json['native_range'] as String?,
      introducedTo: (json['introduced_to'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      waterType: json['water_type'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'regions': regions,
      'native_range': nativeRange,
      'introduced_to': introducedTo,
      'water_type': waterType,
    };
  }
}
