/// Один шаг решения задачи
class SolutionStep {
  final int stepNumber;
  final String description; // Описание шага
  final String formula; // Формула в LaTeX
  final String explanation; // Объяснение почему делаем этот шаг

  SolutionStep({
    required this.stepNumber,
    required this.description,
    required this.formula,
    required this.explanation,
  });

  factory SolutionStep.fromJson(Map<String, dynamic> json) {
    return SolutionStep(
      stepNumber: json['step_number'] as int? ?? 0,
      description: json['description'] as String? ?? '',
      formula: json['formula'] as String? ?? '',
      explanation: json['explanation'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'step_number': stepNumber,
      'description': description,
      'formula': formula,
      'explanation': explanation,
    };
  }
}
