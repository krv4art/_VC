/// Subject/Topic for tutoring
class Subject {
  final String id;
  final String name;
  final String emoji;
  final String description;
  final List<String> topics;
  final int minGrade;
  final int maxGrade;

  const Subject({
    required this.id,
    required this.name,
    required this.emoji,
    required this.description,
    required this.topics,
    required this.minGrade,
    required this.maxGrade,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'emoji': emoji,
        'description': description,
        'topics': topics,
        'min_grade': minGrade,
        'max_grade': maxGrade,
      };

  factory Subject.fromJson(Map<String, dynamic> json) => Subject(
        id: json['id'],
        name: json['name'],
        emoji: json['emoji'],
        description: json['description'],
        topics: List<String>.from(json['topics']),
        minGrade: json['min_grade'],
        maxGrade: json['max_grade'],
      );
}

/// Predefined subjects
class Subjects {
  static const math = Subject(
    id: 'math',
    name: 'Mathematics',
    emoji: '🔢',
    description: 'Algebra, geometry, calculus, and more',
    topics: [
      'Arithmetic',
      'Algebra',
      'Geometry',
      'Trigonometry',
      'Calculus',
      'Statistics',
      'Equations',
      'Functions',
      'Graphs',
    ],
    minGrade: 1,
    maxGrade: 12,
  );

  static const physics = Subject(
    id: 'physics',
    name: 'Physics',
    emoji: '⚛️',
    description: 'Motion, forces, energy, and the universe',
    topics: [
      'Mechanics',
      'Kinematics',
      'Forces',
      'Energy',
      'Electricity',
      'Magnetism',
      'Waves',
      'Optics',
      'Thermodynamics',
    ],
    minGrade: 6,
    maxGrade: 12,
  );

  static const chemistry = Subject(
    id: 'chemistry',
    name: 'Chemistry',
    emoji: '⚗️',
    description: 'Elements, reactions, and molecules',
    topics: [
      'Atoms',
      'Periodic Table',
      'Chemical Reactions',
      'Acids & Bases',
      'Organic Chemistry',
      'Solutions',
      'Stoichiometry',
      'Thermochemistry',
    ],
    minGrade: 7,
    maxGrade: 12,
  );

  static const programming = Subject(
    id: 'programming',
    name: 'Programming',
    emoji: '💻',
    description: 'Coding, algorithms, and computer science',
    topics: [
      'Variables & Data Types',
      'Conditionals',
      'Loops',
      'Functions',
      'Arrays & Lists',
      'Algorithms',
      'Object-Oriented Programming',
      'Data Structures',
    ],
    minGrade: 6,
    maxGrade: 12,
  );

  static const biology = Subject(
    id: 'biology',
    name: 'Biology',
    emoji: '🧬',
    description: 'Life, cells, and living organisms',
    topics: [
      'Cells',
      'DNA & Genetics',
      'Evolution',
      'Ecology',
      'Human Body',
      'Plants',
      'Animals',
      'Microbiology',
    ],
    minGrade: 6,
    maxGrade: 12,
  );

  static const english = Subject(
    id: 'english',
    name: 'English',
    emoji: '📝',
    description: 'Grammar, writing, and literature',
    topics: [
      'Grammar',
      'Vocabulary',
      'Reading Comprehension',
      'Writing',
      'Essay Structure',
      'Literature Analysis',
      'Poetry',
    ],
    minGrade: 1,
    maxGrade: 12,
  );

  static List<Subject> get all => [
        math,
        physics,
        chemistry,
        programming,
        biology,
        english,
      ];

  static Subject? getById(String id) {
    try {
      return all.firstWhere((subject) => subject.id == id);
    } catch (e) {
      return null;
    }
  }
}
