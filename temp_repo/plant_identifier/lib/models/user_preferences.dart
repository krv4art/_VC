/// User preferences for personalized plant identification and care
class UserPreferences {
  final String id;

  // Garden/Location settings
  final String? location;
  final String? climate; // tropical, temperate, arid, etc.
  final String? gardenType; // indoor, outdoor, balcony, etc.

  // Environmental conditions
  final double? temperature; // Average temperature in Celsius
  final double? humidity; // Average humidity percentage (0-100)

  // Experience level
  final GardeningExperience experience;

  // Preferences
  final List<PlantInterest> interests;
  final bool showToxicWarnings;
  final bool preferNativePlants;
  final bool lowMaintenancePreference;

  // Notification settings
  final bool wateringReminders;
  final bool careReminders;
  final bool seasonalTips;

  // App state
  final bool? onboardingCompleted;

  UserPreferences({
    required this.id,
    this.location,
    this.climate,
    this.gardenType,
    this.temperature,
    this.humidity,
    this.experience = GardeningExperience.beginner,
    this.interests = const [],
    this.showToxicWarnings = true,
    this.preferNativePlants = false,
    this.lowMaintenancePreference = false,
    this.wateringReminders = true,
    this.careReminders = true,
    this.seasonalTips = true,
    this.onboardingCompleted,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'location': location,
      'climate': climate,
      'gardenType': gardenType,
      'temperature': temperature,
      'humidity': humidity,
      'experience': experience.toString().split('.').last,
      'interests': interests.map((i) => i.toString().split('.').last).toList(),
      'showToxicWarnings': showToxicWarnings,
      'preferNativePlants': preferNativePlants,
      'lowMaintenancePreference': lowMaintenancePreference,
      'wateringReminders': wateringReminders,
      'careReminders': careReminders,
      'seasonalTips': seasonalTips,
      'onboardingCompleted': onboardingCompleted,
    };
  }

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      id: json['id'] as String,
      location: json['location'] as String?,
      climate: json['climate'] as String?,
      gardenType: json['gardenType'] as String?,
      temperature: (json['temperature'] as num?)?.toDouble(),
      humidity: (json['humidity'] as num?)?.toDouble(),
      experience: GardeningExperience.values.firstWhere(
        (e) => e.toString().split('.').last == json['experience'],
        orElse: () => GardeningExperience.beginner,
      ),
      interests: (json['interests'] as List<dynamic>?)
              ?.map((i) => PlantInterest.values.firstWhere(
                    (e) => e.toString().split('.').last == i,
                    orElse: () => PlantInterest.general,
                  ))
              .toList() ??
          [],
      showToxicWarnings: json['showToxicWarnings'] as bool? ?? true,
      preferNativePlants: json['preferNativePlants'] as bool? ?? false,
      lowMaintenancePreference: json['lowMaintenancePreference'] as bool? ?? false,
      wateringReminders: json['wateringReminders'] as bool? ?? true,
      careReminders: json['careReminders'] as bool? ?? true,
      seasonalTips: json['seasonalTips'] as bool? ?? true,
      onboardingCompleted: json['onboardingCompleted'] as bool?,
    );
  }

  UserPreferences copyWith({
    String? id,
    String? location,
    String? climate,
    String? gardenType,
    double? temperature,
    double? humidity,
    GardeningExperience? experience,
    List<PlantInterest>? interests,
    bool? showToxicWarnings,
    bool? preferNativePlants,
    bool? lowMaintenancePreference,
    bool? wateringReminders,
    bool? careReminders,
    bool? seasonalTips,
    bool? onboardingCompleted,
  }) {
    return UserPreferences(
      id: id ?? this.id,
      location: location ?? this.location,
      climate: climate ?? this.climate,
      gardenType: gardenType ?? this.gardenType,
      temperature: temperature ?? this.temperature,
      humidity: humidity ?? this.humidity,
      experience: experience ?? this.experience,
      interests: interests ?? this.interests,
      showToxicWarnings: showToxicWarnings ?? this.showToxicWarnings,
      preferNativePlants: preferNativePlants ?? this.preferNativePlants,
      lowMaintenancePreference: lowMaintenancePreference ?? this.lowMaintenancePreference,
      wateringReminders: wateringReminders ?? this.wateringReminders,
      careReminders: careReminders ?? this.careReminders,
      seasonalTips: seasonalTips ?? this.seasonalTips,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
    );
  }
}

/// Gardening experience levels
enum GardeningExperience {
  beginner,
  intermediate,
  advanced,
  professional,
}

/// Plant interests for personalization
enum PlantInterest {
  general,          // General plant care
  ediblePlants,     // Herbs, vegetables
  ornamental,       // Decorative plants
  medicinal,        // Medicinal plants
  mushrooms,        // Fungi identification
  succulents,       // Succulents and cacti
  houseplants,      // Indoor plants
  trees,            // Tree identification
  wildflowers,      // Wild plants
  toxicPlants,      // Safety and toxic plant identification
}
