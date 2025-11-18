/// Model representing a student's interest category
class Interest {
  final String id;
  final String name;
  final String emoji;
  final String description;
  final List<String> keywords; // For personalizing examples
  final List<String> examples; // Sample contexts
  final bool isCustom; // Whether this is a user-created custom interest

  const Interest({
    required this.id,
    required this.name,
    required this.emoji,
    required this.description,
    required this.keywords,
    required this.examples,
    this.isCustom = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'emoji': emoji,
        'description': description,
        'keywords': keywords,
        'examples': examples,
        'isCustom': isCustom,
      };

  factory Interest.fromJson(Map<String, dynamic> json) => Interest(
        id: json['id'],
        name: json['name'],
        emoji: json['emoji'],
        description: json['description'],
        keywords: List<String>.from(json['keywords']),
        examples: List<String>.from(json['examples'] ?? []),
        isCustom: json['isCustom'] ?? false,
      );

  /// Create a custom interest from user input
  factory Interest.custom({
    required String name,
    required String emoji,
    required List<String> keywords,
  }) {
    final id = 'custom_${name.toLowerCase().replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}';
    return Interest(
      id: id,
      name: name,
      emoji: emoji,
      description: 'Custom interest: $name',
      keywords: keywords,
      examples: [], // Custom interests don't need predefined examples
      isCustom: true,
    );
  }
}

/// Predefined interests
class Interests {
  static const gaming = Interest(
    id: 'gaming',
    name: 'Gaming',
    emoji: '🎮',
    description: 'Video games like Minecraft, Roblox, Fortnite',
    keywords: ['blocks', 'inventory', 'craft', 'build', 'mobs', 'game', 'player'],
    examples: [
      'In Minecraft, you have 64 stone blocks...',
      'If each Roblox player earns 50 coins...',
      'Your Fortnite squad has 4 players...',
    ],
  );

  static const sports = Interest(
    id: 'sports',
    name: 'Sports',
    emoji: '⚽',
    description: 'Football, basketball, and other sports',
    keywords: ['goal', 'score', 'player', 'team', 'match', 'field', 'ball'],
    examples: [
      'A football field is 100 meters long...',
      'The basketball team scored 24 points...',
      'If each player runs 5 km per match...',
    ],
  );

  static const space = Interest(
    id: 'space',
    name: 'Space & Astronomy',
    emoji: '🚀',
    description: 'Planets, rockets, and space exploration',
    keywords: ['rocket', 'planet', 'star', 'orbit', 'galaxy', 'astronaut', 'space'],
    examples: [
      'A rocket travels at 11 km/s...',
      'Mars is 228 million km from the Sun...',
      'If a satellite orbits every 90 minutes...',
    ],
  );

  static const animals = Interest(
    id: 'animals',
    name: 'Animals & Nature',
    emoji: '🐱',
    description: 'Pets, wildlife, and nature',
    keywords: ['animal', 'pet', 'bird', 'forest', 'ocean', 'wild', 'nature'],
    examples: [
      'A cheetah runs at 120 km/h...',
      'If a bird flies 15 meters per second...',
      'The aquarium has 8 fish tanks...',
    ],
  );

  static const music = Interest(
    id: 'music',
    name: 'Music',
    emoji: '🎵',
    description: 'Instruments, songs, and music theory',
    keywords: ['note', 'song', 'instrument', 'beat', 'rhythm', 'melody', 'band'],
    examples: [
      'A song has 4 verses of 16 bars each...',
      'If a drummer plays 120 beats per minute...',
      'The band has 5 members...',
    ],
  );

  static const art = Interest(
    id: 'art',
    name: 'Art & Drawing',
    emoji: '🎨',
    description: 'Painting, drawing, and creative arts',
    keywords: ['paint', 'canvas', 'color', 'draw', 'brush', 'palette', 'art'],
    examples: [
      'A canvas is 50 cm by 70 cm...',
      'If you mix 3 colors equally...',
      'The gallery displays 12 paintings...',
    ],
  );

  static const coding = Interest(
    id: 'coding',
    name: 'Programming',
    emoji: '💻',
    description: 'Coding, apps, and technology',
    keywords: ['code', 'app', 'program', 'algorithm', 'function', 'variable', 'loop'],
    examples: [
      'A loop runs 10 times...',
      'If an array has 5 elements...',
      'The function processes 100 items per second...',
    ],
  );

  static const movies = Interest(
    id: 'movies',
    name: 'Movies & TV',
    emoji: '🎬',
    description: 'Marvel, Star Wars, Harry Potter, and more',
    keywords: ['hero', 'villain', 'scene', 'episode', 'sequel', 'character', 'movie'],
    examples: [
      'The Avengers have 6 original members...',
      'If each Star Wars episode is 2 hours...',
      'Harry Potter studied at Hogwarts for 7 years...',
    ],
  );

  static const books = Interest(
    id: 'books',
    name: 'Books & Reading',
    emoji: '📚',
    description: 'Fantasy, sci-fi, and adventure books',
    keywords: ['book', 'page', 'chapter', 'story', 'hero', 'quest', 'library'],
    examples: [
      'A book has 12 chapters...',
      'If you read 20 pages per day...',
      'The library has 500 books...',
    ],
  );

  static const food = Interest(
    id: 'food',
    name: 'Cooking & Food',
    emoji: '🍕',
    description: 'Recipes, cooking, and favorite foods',
    keywords: ['recipe', 'ingredient', 'cook', 'bake', 'dish', 'meal', 'kitchen'],
    examples: [
      'A pizza is divided into 8 slices...',
      'If a recipe needs 3 cups of flour...',
      'The restaurant serves 50 meals per hour...',
    ],
  );

  static List<Interest> get all => [
        gaming,
        sports,
        space,
        animals,
        music,
        art,
        coding,
        movies,
        books,
        food,
      ];

  static Interest? getById(String id) {
    try {
      return all.firstWhere((interest) => interest.id == id);
    } catch (e) {
      return null;
    }
  }
}
