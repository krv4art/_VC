/// Types of brain training exercises
enum ExerciseType {
  stroopTest,
  memoryCards,
  speedReading,
  shapeCounter,
  numberSequences,
  nBackTest,
  quickMath,
  spotTheDifference,
}

extension ExerciseTypeExtension on ExerciseType {
  String get name {
    switch (this) {
      case ExerciseType.stroopTest:
        return 'Stroop Test';
      case ExerciseType.memoryCards:
        return 'Memory Cards';
      case ExerciseType.speedReading:
        return 'Speed Reading';
      case ExerciseType.shapeCounter:
        return 'Shape Counter';
      case ExerciseType.numberSequences:
        return 'Number Sequences';
      case ExerciseType.nBackTest:
        return 'N-Back Test';
      case ExerciseType.quickMath:
        return 'Quick Math';
      case ExerciseType.spotTheDifference:
        return 'Spot the Difference';
    }
  }

  String get nameRu {
    switch (this) {
      case ExerciseType.stroopTest:
        return 'Тест Струппа';
      case ExerciseType.memoryCards:
        return 'Карточки памяти';
      case ExerciseType.speedReading:
        return 'Скоростное чтение';
      case ExerciseType.shapeCounter:
        return 'Подсчет фигур';
      case ExerciseType.numberSequences:
        return 'Числовые последовательности';
      case ExerciseType.nBackTest:
        return 'N-Back тест';
      case ExerciseType.quickMath:
        return 'Быстрый счет';
      case ExerciseType.spotTheDifference:
        return 'Найди отличия';
    }
  }

  String get description {
    switch (this) {
      case ExerciseType.stroopTest:
        return 'Select the color of the text, not the word itself';
      case ExerciseType.memoryCards:
        return 'Find matching pairs of cards';
      case ExerciseType.speedReading:
        return 'Read text before it disappears';
      case ExerciseType.shapeCounter:
        return 'Count specific shapes among many';
      case ExerciseType.numberSequences:
        return 'Find the pattern and complete the sequence';
      case ExerciseType.nBackTest:
        return 'Remember items from N steps back';
      case ExerciseType.quickMath:
        return 'Solve math problems as fast as you can';
      case ExerciseType.spotTheDifference:
        return 'Find all differences between two images';
    }
  }

  String get descriptionRu {
    switch (this) {
      case ExerciseType.stroopTest:
        return 'Выберите цвет текста, а не само слово';
      case ExerciseType.memoryCards:
        return 'Найдите одинаковые пары карточек';
      case ExerciseType.speedReading:
        return 'Прочитайте текст до того, как он исчезнет';
      case ExerciseType.shapeCounter:
        return 'Посчитайте определенные фигуры среди множества';
      case ExerciseType.numberSequences:
        return 'Найдите закономерность и продолжите последовательность';
      case ExerciseType.nBackTest:
        return 'Запомните элементы на N шагов назад';
      case ExerciseType.quickMath:
        return 'Решайте математические задачи как можно быстрее';
      case ExerciseType.spotTheDifference:
        return 'Найдите все отличия между двумя картинками';
    }
  }

  String get icon {
    switch (this) {
      case ExerciseType.stroopTest:
        return '🎨';
      case ExerciseType.memoryCards:
        return '🃏';
      case ExerciseType.speedReading:
        return '📖';
      case ExerciseType.shapeCounter:
        return '🔺';
      case ExerciseType.numberSequences:
        return '🔢';
      case ExerciseType.nBackTest:
        return '🧠';
      case ExerciseType.quickMath:
        return '➕';
      case ExerciseType.spotTheDifference:
        return '🔍';
    }
  }

  /// What cognitive skills this exercise trains
  List<String> get trainedSkills {
    switch (this) {
      case ExerciseType.stroopTest:
        return ['Attention', 'Cognitive Control', 'Processing Speed'];
      case ExerciseType.memoryCards:
        return ['Memory', 'Visual Recognition', 'Concentration'];
      case ExerciseType.speedReading:
        return ['Reading Speed', 'Comprehension', 'Focus'];
      case ExerciseType.shapeCounter:
        return ['Visual Processing', 'Counting', 'Attention'];
      case ExerciseType.numberSequences:
        return ['Pattern Recognition', 'Logic', 'Problem Solving'];
      case ExerciseType.nBackTest:
        return ['Working Memory', 'Focus', 'Mental Agility'];
      case ExerciseType.quickMath:
        return ['Mental Math', 'Processing Speed', 'Accuracy'];
      case ExerciseType.spotTheDifference:
        return ['Visual Attention', 'Detail Detection', 'Comparison'];
    }
  }
}
