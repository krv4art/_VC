/// Model for background removal and replacement settings
class BackgroundSettings {
  final BackgroundType type;
  final String? customBackgroundUrl;
  final BackgroundColor? backgroundColor;
  final BackgroundStyle? style;
  final double blurAmount; // 0.0 to 1.0 for edge blur

  const BackgroundSettings({
    this.type = BackgroundType.transparent,
    this.customBackgroundUrl,
    this.backgroundColor,
    this.style,
    this.blurAmount = 0.0,
  });

  factory BackgroundSettings.fromMap(Map<String, dynamic> map) {
    return BackgroundSettings(
      type: BackgroundType.values.firstWhere(
        (e) => e.toString() == 'BackgroundType.${map['type']}',
        orElse: () => BackgroundType.transparent,
      ),
      customBackgroundUrl: map['custom_background_url'] as String?,
      backgroundColor: map['background_color'] != null
          ? BackgroundColor.values.firstWhere(
              (e) => e.toString() == 'BackgroundColor.${map['background_color']}',
              orElse: () => BackgroundColor.white,
            )
          : null,
      style: map['style'] != null
          ? BackgroundStyle.values.firstWhere(
              (e) => e.toString() == 'BackgroundStyle.${map['style']}',
              orElse: () => BackgroundStyle.office,
            )
          : null,
      blurAmount: map['blur_amount'] as double? ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type.toString().split('.').last,
      'custom_background_url': customBackgroundUrl,
      'background_color': backgroundColor?.toString().split('.').last,
      'style': style?.toString().split('.').last,
      'blur_amount': blurAmount,
    };
  }

  BackgroundSettings copyWith({
    BackgroundType? type,
    String? customBackgroundUrl,
    BackgroundColor? backgroundColor,
    BackgroundStyle? style,
    double? blurAmount,
  }) {
    return BackgroundSettings(
      type: type ?? this.type,
      customBackgroundUrl: customBackgroundUrl ?? this.customBackgroundUrl,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      style: style ?? this.style,
      blurAmount: blurAmount ?? this.blurAmount,
    );
  }
}

enum BackgroundType {
  transparent,
  solidColor,
  preset,
  custom,
  blurred,
}

enum BackgroundColor {
  white,
  gray,
  blue,
  beige,
  black,
  gradient,
}

enum BackgroundStyle {
  office,
  studio,
  outdoor,
  urban,
  library,
  conference,
  modern,
  classic,
}
