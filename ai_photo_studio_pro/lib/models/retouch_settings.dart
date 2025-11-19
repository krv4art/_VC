/// Model for AI retouch settings
class RetouchSettings {
  final bool removeBlemishes;
  final bool smoothSkin;
  final bool enhanceLighting;
  final bool colorCorrection;
  final bool removeShine;
  final bool enhanceEyes;
  final bool whitenTeeth;
  final double smoothnessLevel; // 0.0 to 1.0
  final double lightingIntensity; // 0.0 to 1.0

  const RetouchSettings({
    this.removeBlemishes = true,
    this.smoothSkin = true,
    this.enhanceLighting = true,
    this.colorCorrection = true,
    this.removeShine = true,
    this.enhanceEyes = false,
    this.whitenTeeth = false,
    this.smoothnessLevel = 0.7,
    this.lightingIntensity = 0.6,
  });

  /// Create a preset for natural retouch
  factory RetouchSettings.natural() {
    return const RetouchSettings(
      removeBlemishes: true,
      smoothSkin: true,
      enhanceLighting: true,
      colorCorrection: true,
      removeShine: true,
      enhanceEyes: false,
      whitenTeeth: false,
      smoothnessLevel: 0.5,
      lightingIntensity: 0.5,
    );
  }

  /// Create a preset for professional retouch
  factory RetouchSettings.professional() {
    return const RetouchSettings(
      removeBlemishes: true,
      smoothSkin: true,
      enhanceLighting: true,
      colorCorrection: true,
      removeShine: true,
      enhanceEyes: true,
      whitenTeeth: true,
      smoothnessLevel: 0.7,
      lightingIntensity: 0.7,
    );
  }

  /// Create a preset for glamour retouch
  factory RetouchSettings.glamour() {
    return const RetouchSettings(
      removeBlemishes: true,
      smoothSkin: true,
      enhanceLighting: true,
      colorCorrection: true,
      removeShine: true,
      enhanceEyes: true,
      whitenTeeth: true,
      smoothnessLevel: 0.9,
      lightingIntensity: 0.8,
    );
  }

  /// Create from map
  factory RetouchSettings.fromMap(Map<String, dynamic> map) {
    return RetouchSettings(
      removeBlemishes: map['remove_blemishes'] as bool? ?? true,
      smoothSkin: map['smooth_skin'] as bool? ?? true,
      enhanceLighting: map['enhance_lighting'] as bool? ?? true,
      colorCorrection: map['color_correction'] as bool? ?? true,
      removeShine: map['remove_shine'] as bool? ?? true,
      enhanceEyes: map['enhance_eyes'] as bool? ?? false,
      whitenTeeth: map['whiten_teeth'] as bool? ?? false,
      smoothnessLevel: map['smoothness_level'] as double? ?? 0.7,
      lightingIntensity: map['lighting_intensity'] as double? ?? 0.6,
    );
  }

  /// Convert to map
  Map<String, dynamic> toMap() {
    return {
      'remove_blemishes': removeBlemishes,
      'smooth_skin': smoothSkin,
      'enhance_lighting': enhanceLighting,
      'color_correction': colorCorrection,
      'remove_shine': removeShine,
      'enhance_eyes': enhanceEyes,
      'whiten_teeth': whitenTeeth,
      'smoothness_level': smoothnessLevel,
      'lighting_intensity': lightingIntensity,
    };
  }

  /// Copy with updated fields
  RetouchSettings copyWith({
    bool? removeBlemishes,
    bool? smoothSkin,
    bool? enhanceLighting,
    bool? colorCorrection,
    bool? removeShine,
    bool? enhanceEyes,
    bool? whitenTeeth,
    double? smoothnessLevel,
    double? lightingIntensity,
  }) {
    return RetouchSettings(
      removeBlemishes: removeBlemishes ?? this.removeBlemishes,
      smoothSkin: smoothSkin ?? this.smoothSkin,
      enhanceLighting: enhanceLighting ?? this.enhanceLighting,
      colorCorrection: colorCorrection ?? this.colorCorrection,
      removeShine: removeShine ?? this.removeShine,
      enhanceEyes: enhanceEyes ?? this.enhanceEyes,
      whitenTeeth: whitenTeeth ?? this.whitenTeeth,
      smoothnessLevel: smoothnessLevel ?? this.smoothnessLevel,
      lightingIntensity: lightingIntensity ?? this.lightingIntensity,
    );
  }
}
