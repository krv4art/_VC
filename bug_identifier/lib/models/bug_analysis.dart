class BugAnalysis {
  final String name;
  final String description;
  final String scientificName;
  final String habitat;
  final String diet;
  final bool isInsect;
  final String? humorousMessage;
  final List<dynamic> characteristics;
  final double dangerLevel;
  final List<dynamic> dangerousTraits;
  final List<dynamic> notableTraits;
  final List<dynamic> commonTraits;
  final List<dynamic> personalizedWarnings;
  final String ecologicalRole;
  final List<dynamic> similarSpecies;
  final String aiSummary;
  final String commonName;
  final TaxonomyInfo? taxonomyInfo;

  BugAnalysis({
    required this.name,
    required this.description,
    required this.scientificName,
    required this.habitat,
    required this.diet,
    required this.isInsect,
    this.humorousMessage,
    required this.characteristics,
    required this.dangerLevel,
    required this.dangerousTraits,
    required this.notableTraits,
    required this.commonTraits,
    required this.personalizedWarnings,
    required this.ecologicalRole,
    required this.similarSpecies,
    required this.aiSummary,
    required this.commonName,
    this.taxonomyInfo,
  });

  factory BugAnalysis.fromJson(Map<String, dynamic> json) {
    return BugAnalysis(
      name: json['name'] as String,
      description: json['description'] as String,
      scientificName: json['scientificName'] as String,
      habitat: json['habitat'] as String,
      diet: json['diet'] as String,
      isInsect: json['is_insect'] as bool,
      humorousMessage: json['humorous_message'] as String?,
      characteristics: List<dynamic>.from(json['characteristics'] as List),
      dangerLevel: (json['danger_level'] as num).toDouble(),
      dangerousTraits: List<dynamic>.from(json['dangerous_traits'] as List),
      notableTraits: List<dynamic>.from(json['notable_traits'] as List),
      commonTraits: List<dynamic>.from(json['common_traits'] as List),
      personalizedWarnings:
          List<dynamic>.from(json['personalized_warnings'] as List),
      ecologicalRole: json['ecological_role'] as String,
      similarSpecies: List<dynamic>.from(json['similar_species'] as List),
      aiSummary: json['ai_summary'] as String,
      commonName: json['common_name'] as String,
      taxonomyInfo: json['taxonomy_info'] != null
          ? TaxonomyInfo.fromJson(json['taxonomy_info'] as Map<String, dynamic>)
          : null,
    );
  }
}

class TaxonomyInfo {
  final String kingdom;
  final String phylum;
  final String classField;
  final String order;
  final String family;
  final String genus;
  final String species;

  TaxonomyInfo({
    required this.kingdom,
    required this.phylum,
    required this.classField,
    required this.order,
    required this.family,
    required this.genus,
    required this.species,
  });

  factory TaxonomyInfo.fromJson(Map<String, dynamic> json) {
    return TaxonomyInfo(
      kingdom: json['kingdom'] as String,
      phylum: json['phylum'] as String,
      classField: json['class'] as String,
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
      'class': classField,
      'order': order,
      'family': family,
      'genus': genus,
      'species': species,
    };
  }
}
