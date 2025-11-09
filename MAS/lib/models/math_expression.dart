/// Математическое выражение
class MathExpression {
  final String rawText; // Исходный текст
  final String latexFormula; // Формула в LaTeX формате
  final ExpressionType type; // Тип выражения

  MathExpression({
    required this.rawText,
    required this.latexFormula,
    required this.type,
  });

  factory MathExpression.fromJson(Map<String, dynamic> json) {
    return MathExpression(
      rawText: json['raw_text'] as String? ?? '',
      latexFormula: json['latex_formula'] as String? ?? '',
      type: ExpressionType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => ExpressionType.unknown,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'raw_text': rawText,
      'latex_formula': latexFormula,
      'type': type.name,
    };
  }
}

/// Типы математических выражений
enum ExpressionType {
  equation, // Уравнение
  inequality, // Неравенство
  expression, // Выражение для упрощения
  system, // Система уравнений
  derivative, // Производная
  integral, // Интеграл
  limit, // Предел
  geometry, // Геометрическая задача
  wordProblem, // Текстовая задача
  unknown, // Неизвестный тип
}

/// Сложность задачи
enum DifficultyLevel {
  easy, // 1-2
  medium, // 3-4
  hard, // 5
}

extension DifficultyLevelExtension on DifficultyLevel {
  int get numericValue {
    switch (this) {
      case DifficultyLevel.easy:
        return 1;
      case DifficultyLevel.medium:
        return 3;
      case DifficultyLevel.hard:
        return 5;
    }
  }

  String getLocalizedName(String languageCode) {
    switch (this) {
      case DifficultyLevel.easy:
        return languageCode == 'uk' ? 'Легко' :
               languageCode == 'ru' ? 'Легко' : 'Easy';
      case DifficultyLevel.medium:
        return languageCode == 'uk' ? 'Середнє' :
               languageCode == 'ru' ? 'Среднее' : 'Medium';
      case DifficultyLevel.hard:
        return languageCode == 'uk' ? 'Складно' :
               languageCode == 'ru' ? 'Сложно' : 'Hard';
    }
  }
}
