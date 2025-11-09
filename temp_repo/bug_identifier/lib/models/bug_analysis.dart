import 'package:flutter/foundation.dart';

/// Модель для характеристики насекомого
class CharacteristicInfo {
  final String name; // Название характеристики
  final String description; // Описание/значение
  final String? category; // Категория (anatomy, behavior, etc.)

  CharacteristicInfo({
    required this.name,
    required this.description,
    this.category,
  });

  factory CharacteristicInfo.fromJson(Map<String, dynamic> json) {
    return CharacteristicInfo(
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      category: json['category'] as String?,
    );
  }

  factory CharacteristicInfo.fromDynamic(dynamic data) {
    // Если это строка - проверяем, не является ли она "Instance of..."
    if (data is String) {
      if (data.startsWith('Instance of')) {
        debugPrint('=== WARNING: Found corrupted data: $data ===');
        return CharacteristicInfo(name: '', description: '');
      }
      return CharacteristicInfo(name: data, description: '');
    }
    // Если это Map - новый формат
    else if (data is Map<String, dynamic>) {
      return CharacteristicInfo.fromJson(data);
    }
    // Если это Map<dynamic, dynamic> - преобразуем в Map<String, dynamic>
    else if (data is Map) {
      final converted = Map<String, dynamic>.from(data);
      return CharacteristicInfo.fromJson(converted);
    }
    // Если null или пустое - возвращаем пустой объект
    else if (data == null) {
      return CharacteristicInfo(name: '', description: '');
    }
    // Любой другой тип - пытаемся преобразовать в строку
    else {
      debugPrint(
        '=== WARNING: Unexpected data type: ${data.runtimeType}, value: $data ===',
      );
      return CharacteristicInfo(name: data.toString(), description: '');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'category': category,
    };
  }
}

/// Основная модель анализа насекомого
class BugAnalysis {
  final bool isInsect; // Является ли объект насекомым
  final String? humorousMessage; // Юмористическое сообщение от AI
  final List<String> characteristics; // Список характеристик
  final double dangerLevel; // Уровень опасности (0-10)
  final List<CharacteristicInfo> dangerousTraits; // Опасные черты
  final List<CharacteristicInfo> notableTraits; // Заметные черты
  final List<CharacteristicInfo> commonTraits; // Обычные черты
  final List<String> personalizedWarnings; // Персонализированные предупреждения (аллергии, регион)
  final String ecologicalRole; // Экологическая роль насекомого
  final List<SimilarSpecies> similarSpecies; // Похожие виды

  // Расширенные поля для детального анализа
  final String? aiSummary; // Эмоциональный вердикт от AI
  final String? habitat; // Среда обитания
  final String? scientificName; // Научное название (латынь)
  final String? commonName; // Обычное название
  final TaxonomyInfo? taxonomyInfo; // Таксономическая информация
  final InsectSpecies? species; // Полная информация о виде

  BugAnalysis({
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
    this.aiSummary,
    this.habitat,
    this.scientificName,
    this.commonName,
    this.taxonomyInfo,
    this.species,
  });

  factory BugAnalysis.fromJson(Map<String, dynamic> json) {
    return BugAnalysis(
      isInsect: json['is_insect'] as bool? ?? false,
      humorousMessage: json['humorous_message'] as String?,
      characteristics: (json['characteristics'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      dangerLevel: (json['danger_level'] as num?)?.toDouble() ?? 0.0,
      dangerousTraits: (json['dangerous_traits'] as List<dynamic>?)
              ?.map((item) => CharacteristicInfo.fromDynamic(item))
              .toList() ??
          [],
      notableTraits: (json['notable_traits'] as List<dynamic>?)
              ?.map((item) => CharacteristicInfo.fromDynamic(item))
              .toList() ??
          [],
      commonTraits: (json['common_traits'] as List<dynamic>?)
              ?.map((item) => CharacteristicInfo.fromDynamic(item))
              .toList() ??
          [],
      personalizedWarnings: (json['personalized_warnings'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      ecologicalRole: json['ecological_role'] as String? ?? '',
      similarSpecies: (json['similar_species'] as List<dynamic>?)
              ?.map((e) => SimilarSpecies.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      aiSummary: json['ai_summary'] as String?,
      habitat: json['habitat'] as String?,
      scientificName: json['scientific_name'] as String?,
      commonName: json['common_name'] as String?,
      taxonomyInfo: json['taxonomy_info'] != null
          ? TaxonomyInfo.fromJson(
              json['taxonomy_info'] as Map<String, dynamic>,
            )
          : null,
      species: json['species'] != null
          ? InsectSpecies.fromJson(
              json['species'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'is_insect': isInsect,
      'humorous_message': humorousMessage,
      'characteristics': characteristics,
      'danger_level': dangerLevel,
      'dangerous_traits': dangerousTraits.map((e) => e.toJson()).toList(),
      'notable_traits': notableTraits.map((e) => e.toJson()).toList(),
      'common_traits': commonTraits.map((e) => e.toJson()).toList(),
      'personalized_warnings': personalizedWarnings,
      'ecological_role': ecologicalRole,
      'similar_species': similarSpecies.map((e) => e.toJson()).toList(),
      'ai_summary': aiSummary,
      'habitat': habitat,
      'scientific_name': scientificName,
      'common_name': commonName,
      'taxonomy_info': taxonomyInfo?.toJson(),
      'species': species?.toJson(),
    };
  }
}

/// Модель похожего вида насекомого
class SimilarSpecies {
  final String name; // Название вида
  final String scientificName; // Научное название
  final String similarity; // Описание сходства
  final String differences; // Ключевые отличия

  SimilarSpecies({
    required this.name,
    required this.scientificName,
    required this.similarity,
    required this.differences,
  });

  factory SimilarSpecies.fromJson(Map<String, dynamic> json) {
    return SimilarSpecies(
      name: json['name'] as String? ?? '',
      scientificName: json['scientific_name'] as String? ?? '',
      similarity: json['similarity'] as String? ?? '',
      differences: json['differences'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'scientific_name': scientificName,
      'similarity': similarity,
      'differences': differences,
    };
  }
}

/// Таксономическая информация о насекомом
class TaxonomyInfo {
  final String? kingdom; // Царство (Animalia)
  final String? phylum; // Тип (Arthropoda)
  final String? className; // Класс (Insecta)
  final String? order; // Отряд (Coleoptera, Hymenoptera, etc.)
  final String? family; // Семейство
  final String? genus; // Род
  final String? species; // Вид
  final int? knownSpeciesCount; // Количество известных видов в семействе

  TaxonomyInfo({
    this.kingdom,
    this.phylum,
    this.className,
    this.order,
    this.family,
    this.genus,
    this.species,
    this.knownSpeciesCount,
  });

  factory TaxonomyInfo.fromJson(Map<String, dynamic> json) {
    return TaxonomyInfo(
      kingdom: json['kingdom'] as String?,
      phylum: json['phylum'] as String?,
      className: json['class'] as String?,
      order: json['order'] as String?,
      family: json['family'] as String?,
      genus: json['genus'] as String?,
      species: json['species'] as String?,
      knownSpeciesCount: json['known_species_count'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kingdom': kingdom,
      'phylum': phylum,
      'class': className,
      'order': order,
      'family': family,
      'genus': genus,
      'species': species,
      'known_species_count': knownSpeciesCount,
    };
  }
}

/// Полная модель вида насекомого
class InsectSpecies {
  final String commonName; // Обычное название
  final String scientificName; // Научное название (латынь)
  final String? description; // Описание
  final String? habitat; // Среда обитания
  final String? diet; // Рацион питания
  final String? behavior; // Поведение
  final String? lifespan; // Продолжительность жизни
  final String? size; // Размер
  final String? distribution; // Географическое распространение
  final List<String>? colors; // Цвета
  final bool isDangerous; // Опасен ли
  final bool isVenomous; // Ядовит ли
  final bool isBeneficial; // Полезен ли (для сада/экологии)
  final String? conservationStatus; // Статус сохранения
  final TaxonomyInfo? taxonomy; // Таксономия

  InsectSpecies({
    required this.commonName,
    required this.scientificName,
    this.description,
    this.habitat,
    this.diet,
    this.behavior,
    this.lifespan,
    this.size,
    this.distribution,
    this.colors,
    this.isDangerous = false,
    this.isVenomous = false,
    this.isBeneficial = false,
    this.conservationStatus,
    this.taxonomy,
  });

  factory InsectSpecies.fromJson(Map<String, dynamic> json) {
    return InsectSpecies(
      commonName: json['common_name'] as String? ?? '',
      scientificName: json['scientific_name'] as String? ?? '',
      description: json['description'] as String?,
      habitat: json['habitat'] as String?,
      diet: json['diet'] as String?,
      behavior: json['behavior'] as String?,
      lifespan: json['lifespan'] as String?,
      size: json['size'] as String?,
      distribution: json['distribution'] as String?,
      colors: (json['colors'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      isDangerous: json['is_dangerous'] as bool? ?? false,
      isVenomous: json['is_venomous'] as bool? ?? false,
      isBeneficial: json['is_beneficial'] as bool? ?? false,
      conservationStatus: json['conservation_status'] as String?,
      taxonomy: json['taxonomy'] != null
          ? TaxonomyInfo.fromJson(json['taxonomy'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'common_name': commonName,
      'scientific_name': scientificName,
      'description': description,
      'habitat': habitat,
      'diet': diet,
      'behavior': behavior,
      'lifespan': lifespan,
      'size': size,
      'distribution': distribution,
      'colors': colors,
      'is_dangerous': isDangerous,
      'is_venomous': isVenomous,
      'is_beneficial': isBeneficial,
      'conservation_status': conservationStatus,
      'taxonomy': taxonomy?.toJson(),
    };
  }
}
