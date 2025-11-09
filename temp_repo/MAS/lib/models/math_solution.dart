import 'math_expression.dart';
import 'solution_step.dart';

/// Полное решение математической задачи
class MathSolution {
  final MathExpression problem; // Исходная задача
  final List<SolutionStep> steps; // Шаги решения
  final String finalAnswer; // Финальный ответ
  final DifficultyLevel difficulty; // Сложность
  final String explanation; // Общее объяснение
  final String? tips; // Советы и подсказки
  final DateTime createdAt; // Когда решена

  MathSolution({
    required this.problem,
    required this.steps,
    required this.finalAnswer,
    required this.difficulty,
    required this.explanation,
    this.tips,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory MathSolution.fromJson(Map<String, dynamic> json) {
    return MathSolution(
      problem: MathExpression.fromJson(json['problem'] as Map<String, dynamic>),
      steps: (json['steps'] as List<dynamic>?)
              ?.map((e) => SolutionStep.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      finalAnswer: json['final_answer'] as String? ?? '',
      difficulty: DifficultyLevel.values.firstWhere(
        (e) => e.name == json['difficulty'],
        orElse: () => DifficultyLevel.medium,
      ),
      explanation: json['explanation'] as String? ?? '',
      tips: json['tips'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'problem': problem.toJson(),
      'steps': steps.map((e) => e.toJson()).toList(),
      'final_answer': finalAnswer,
      'difficulty': difficulty.name,
      'explanation': explanation,
      'tips': tips,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
