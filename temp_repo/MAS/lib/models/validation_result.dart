/// Результат проверки решения пользователя
class ValidationResult {
  final bool isCorrect; // Правильно ли решение в целом
  final List<StepValidation> stepValidations; // Проверка каждого шага
  final List<String> hints; // Подсказки для исправления
  final double accuracy; // Точность в процентах (0-100)
  final String finalVerdict; // Общий вердикт от AI

  ValidationResult({
    required this.isCorrect,
    required this.stepValidations,
    required this.hints,
    required this.accuracy,
    required this.finalVerdict,
  });

  factory ValidationResult.fromJson(Map<String, dynamic> json) {
    return ValidationResult(
      isCorrect: json['is_correct'] as bool? ?? false,
      stepValidations: (json['step_validations'] as List<dynamic>?)
              ?.map((e) => StepValidation.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      hints: (json['hints'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      accuracy: (json['accuracy'] as num?)?.toDouble() ?? 0.0,
      finalVerdict: json['final_verdict'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'is_correct': isCorrect,
      'step_validations': stepValidations.map((e) => e.toJson()).toList(),
      'hints': hints,
      'accuracy': accuracy,
      'final_verdict': finalVerdict,
    };
  }
}

/// Проверка одного шага решения
class StepValidation {
  final int stepNumber;
  final bool isCorrect;
  final ErrorType? errorType;
  final String? hint; // Подсказка для этого шага

  StepValidation({
    required this.stepNumber,
    required this.isCorrect,
    this.errorType,
    this.hint,
  });

  factory StepValidation.fromJson(Map<String, dynamic> json) {
    return StepValidation(
      stepNumber: json['step_number'] as int? ?? 0,
      isCorrect: json['is_correct'] as bool? ?? false,
      errorType: json['error_type'] != null
          ? ErrorType.values.firstWhere(
              (e) => e.name == json['error_type'],
              orElse: () => ErrorType.unknown,
            )
          : null,
      hint: json['hint'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'step_number': stepNumber,
      'is_correct': isCorrect,
      'error_type': errorType?.name,
      'hint': hint,
    };
  }
}

/// Типы ошибок
enum ErrorType {
  arithmetic, // Арифметическая ошибка
  logical, // Логическая ошибка
  missingStep, // Пропущен шаг
  wrongMethod, // Неправильный метод решения
  signError, // Ошибка со знаками
  algebraic, // Алгебраическая ошибка
  unknown, // Неизвестная ошибка
}

extension ErrorTypeExtension on ErrorType {
  String getLocalizedName(String languageCode) {
    switch (this) {
      case ErrorType.arithmetic:
        return languageCode == 'uk' ? 'Арифметична помилка' :
               languageCode == 'ru' ? 'Арифметическая ошибка' :
               'Arithmetic error';
      case ErrorType.logical:
        return languageCode == 'uk' ? 'Логічна помилка' :
               languageCode == 'ru' ? 'Логическая ошибка' :
               'Logical error';
      case ErrorType.missingStep:
        return languageCode == 'uk' ? 'Пропущений крок' :
               languageCode == 'ru' ? 'Пропущенный шаг' :
               'Missing step';
      case ErrorType.wrongMethod:
        return languageCode == 'uk' ? 'Невірний метод' :
               languageCode == 'ru' ? 'Неверный метод' :
               'Wrong method';
      case ErrorType.signError:
        return languageCode == 'uk' ? 'Помилка зі знаками' :
               languageCode == 'ru' ? 'Ошибка со знаками' :
               'Sign error';
      case ErrorType.algebraic:
        return languageCode == 'uk' ? 'Алгебраїчна помилка' :
               languageCode == 'ru' ? 'Алгебраическая ошибка' :
               'Algebraic error';
      case ErrorType.unknown:
        return languageCode == 'uk' ? 'Невідома помилка' :
               languageCode == 'ru' ? 'Неизвестная ошибка' :
               'Unknown error';
    }
  }
}
