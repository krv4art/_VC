// services/keyword_extractor.dart
// Service for extracting keywords from job descriptions and resumes

import 'package:cv_engineer/models/ats_analysis.dart';

class KeywordExtractor {
  // Common stop words to filter out
  static const Set<String> _stopWords = {
    'a', 'an', 'and', 'are', 'as', 'at', 'be', 'by', 'for', 'from',
    'has', 'he', 'in', 'is', 'it', 'its', 'of', 'on', 'that', 'the',
    'to', 'was', 'will', 'with', 'the', 'this', 'but', 'they', 'have',
    'had', 'what', 'when', 'where', 'who', 'which', 'why', 'how', 'or',
    'not', 'so', 'than', 'too', 'very', 'can', 'could', 'should', 'would',
    'may', 'might', 'must', 'shall', 'do', 'does', 'did', 'doing', 'done',
    'if', 'then', 'else', 'each', 'such', 'any', 'more', 'most', 'other',
    'some', 'no', 'nor', 'only', 'own', 'same', 'than', 'those', 'through',
    'into', 'during', 'before', 'after', 'above', 'below', 'up', 'down',
    'out', 'off', 'over', 'under', 'again', 'further', 'once', 'here',
    'there', 'all', 'both', 'few', 'more', 'most', 'other', 'some', 'such',
  };

  // Common technical skills and keywords (extendable)
  static const Set<String> _technicalKeywords = {
    // Programming Languages
    'python', 'java', 'javascript', 'typescript', 'c++', 'c#', 'ruby', 'go',
    'rust', 'swift', 'kotlin', 'php', 'sql', 'r', 'matlab', 'scala',

    // Frameworks & Libraries
    'react', 'angular', 'vue', 'node', 'express', 'django', 'flask', 'spring',
    'flutter', 'react native', 'tensorflow', 'pytorch', 'keras', 'scikit-learn',

    // Tools & Technologies
    'git', 'docker', 'kubernetes', 'aws', 'azure', 'gcp', 'jenkins', 'ci/cd',
    'agile', 'scrum', 'jira', 'confluence', 'mongodb', 'postgresql', 'mysql',
    'redis', 'elasticsearch', 'kafka', 'rabbitmq', 'graphql', 'rest', 'api',

    // Skills & Concepts
    'machine learning', 'artificial intelligence', 'deep learning', 'data science',
    'data analysis', 'devops', 'cloud computing', 'microservices', 'architecture',
    'design patterns', 'testing', 'tdd', 'bdd', 'automation', 'monitoring',
    'security', 'authentication', 'authorization', 'encryption', 'optimization',
  };

  // Action verbs commonly used in resumes
  static const Set<String> _actionVerbs = {
    'achieved', 'improved', 'trained', 'managed', 'created', 'designed',
    'developed', 'implemented', 'increased', 'decreased', 'reduced', 'led',
    'launched', 'initiated', 'established', 'founded', 'formulated', 'executed',
    'delivered', 'generated', 'built', 'solved', 'analyzed', 'assessed',
    'streamlined', 'optimized', 'enhanced', 'strengthened', 'transformed',
    'pioneered', 'spearheaded', 'orchestrated', 'coordinated', 'collaborated',
  };

  /// Extract keywords from text
  static List<String> extractKeywords(String text, {int maxKeywords = 50}) {
    if (text.isEmpty) return [];

    // Clean and normalize text
    final cleaned = _cleanText(text);

    // Split into words
    final words = cleaned.toLowerCase().split(RegExp(r'\s+'));

    // Count word frequencies
    final Map<String, int> wordFreq = {};
    for (final word in words) {
      if (word.length < 3) continue; // Skip very short words
      if (_stopWords.contains(word)) continue;

      wordFreq[word] = (wordFreq[word] ?? 0) + 1;
    }

    // Extract multi-word technical terms (bigrams and trigrams)
    final phrases = _extractPhrases(cleaned.toLowerCase());
    for (final phrase in phrases) {
      wordFreq[phrase] = (wordFreq[phrase] ?? 0) + 2; // Give phrases higher weight
    }

    // Sort by frequency and relevance
    final sortedWords = wordFreq.entries.toList()
      ..sort((a, b) {
        // Prioritize technical keywords
        final aIsTech = _technicalKeywords.contains(a.key);
        final bIsTech = _technicalKeywords.contains(b.key);

        if (aIsTech && !bIsTech) return -1;
        if (!aIsTech && bIsTech) return 1;

        // Then sort by frequency
        return b.value.compareTo(a.value);
      });

    // Return top keywords
    return sortedWords
        .take(maxKeywords)
        .map((e) => _capitalizeKeyword(e.key))
        .toList();
  }

  /// Extract skills from text (more targeted)
  static List<String> extractSkills(String text) {
    final cleaned = text.toLowerCase();
    final skills = <String>{};

    // Check for known technical keywords
    for (final keyword in _technicalKeywords) {
      if (cleaned.contains(keyword)) {
        skills.add(_capitalizeKeyword(keyword));
      }
    }

    // Extract custom skills using patterns
    final skillPatterns = [
      RegExp(r'skilled in ([^,\.]+)', caseSensitive: false),
      RegExp(r'experience with ([^,\.]+)', caseSensitive: false),
      RegExp(r'proficient in ([^,\.]+)', caseSensitive: false),
      RegExp(r'knowledge of ([^,\.]+)', caseSensitive: false),
    ];

    for (final pattern in skillPatterns) {
      final matches = pattern.allMatches(text);
      for (final match in matches) {
        if (match.groupCount > 0) {
          final skill = match.group(1)?.trim();
          if (skill != null && skill.isNotEmpty) {
            skills.add(_capitalizeKeyword(skill));
          }
        }
      }
    }

    return skills.toList();
  }

  /// Match keywords between job description and resume
  static List<KeywordMatch> matchKeywords({
    required List<String> jobKeywords,
    required String resumeText,
    required List<String> requiredSkills,
  }) {
    final resumeLower = resumeText.toLowerCase();
    final matches = <KeywordMatch>[];

    for (final keyword in jobKeywords) {
      final keywordLower = keyword.toLowerCase();
      final isRequired = requiredSkills.any(
        (skill) => skill.toLowerCase() == keywordLower,
      );

      // Count occurrences in resume
      final occurrences = _countOccurrences(resumeLower, keywordLower);
      final isInResume = occurrences > 0;

      // Calculate relevance score based on frequency and context
      double relevance = 0.0;
      if (isInResume) {
        relevance = (occurrences / 10.0).clamp(0.0, 1.0);
        if (_technicalKeywords.contains(keywordLower)) {
          relevance = (relevance * 1.2).clamp(0.0, 1.0);
        }
      }

      matches.add(KeywordMatch(
        keyword: keyword,
        isInResume: isInResume,
        occurrencesInJob: 1, // Simplified - could be enhanced
        occurrencesInResume: occurrences,
        relevanceScore: relevance,
        isRequired: isRequired,
      ));
    }

    return matches;
  }

  /// Check if text contains action verbs
  static bool hasActionVerbs(String text) {
    final cleaned = text.toLowerCase();
    return _actionVerbs.any((verb) => cleaned.contains(verb));
  }

  /// Check if text has quantifiable achievements (numbers, percentages)
  static bool hasQuantifiableAchievements(String text) {
    // Check for numbers followed by %
    final percentagePattern = RegExp(r'\d+%');
    if (percentagePattern.hasMatch(text)) return true;

    // Check for numbers with common units
    final quantityPattern = RegExp(
      r'\d+[\s]*(users|customers|projects|years|months|million|thousand|hours|days)',
      caseSensitive: false,
    );
    if (quantityPattern.hasMatch(text)) return true;

    // Check for dollar amounts
    final moneyPattern = RegExp(r'\$[\d,]+');
    if (moneyPattern.hasMatch(text)) return true;

    return false;
  }

  /// Calculate readability score (Flesch Reading Ease)
  static double calculateReadabilityScore(String text) {
    if (text.isEmpty) return 0.0;

    final sentences = text.split(RegExp(r'[.!?]+'));
    final words = text.split(RegExp(r'\s+'));
    final syllables = words.fold<int>(0, (sum, word) => sum + _countSyllables(word));

    if (sentences.isEmpty || words.isEmpty) return 0.0;

    final avgWordsPerSentence = words.length / sentences.length;
    final avgSyllablesPerWord = syllables / words.length;

    // Flesch Reading Ease formula
    final score = 206.835 - (1.015 * avgWordsPerSentence) - (84.6 * avgSyllablesPerWord);

    return score.clamp(0.0, 100.0);
  }

  // Private helper methods

  static String _cleanText(String text) {
    return text
        .replaceAll(RegExp(r'[^\w\s]'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  static List<String> _extractPhrases(String text) {
    final words = text.split(RegExp(r'\s+'));
    final phrases = <String>[];

    // Extract bigrams
    for (int i = 0; i < words.length - 1; i++) {
      final bigram = '${words[i]} ${words[i + 1]}';
      if (_technicalKeywords.contains(bigram)) {
        phrases.add(bigram);
      }
    }

    // Extract trigrams
    for (int i = 0; i < words.length - 2; i++) {
      final trigram = '${words[i]} ${words[i + 1]} ${words[i + 2]}';
      if (_technicalKeywords.contains(trigram)) {
        phrases.add(trigram);
      }
    }

    return phrases;
  }

  static int _countOccurrences(String text, String keyword) {
    if (text.isEmpty || keyword.isEmpty) return 0;

    final pattern = RegExp(r'\b' + RegExp.escape(keyword) + r'\b', caseSensitive: false);
    return pattern.allMatches(text).length;
  }

  static String _capitalizeKeyword(String keyword) {
    if (keyword.isEmpty) return keyword;

    // Special cases for acronyms
    final upper = keyword.toUpperCase();
    if (_technicalKeywords.contains(keyword.toLowerCase()) && keyword.length <= 4) {
      return upper;
    }

    // Title case for phrases
    return keyword.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  static int _countSyllables(String word) {
    if (word.isEmpty) return 0;

    word = word.toLowerCase();
    int count = 0;
    bool previousWasVowel = false;

    for (int i = 0; i < word.length; i++) {
      final isVowel = 'aeiouy'.contains(word[i]);
      if (isVowel && !previousWasVowel) {
        count++;
      }
      previousWasVowel = isVowel;
    }

    // Adjust for silent 'e'
    if (word.endsWith('e')) {
      count--;
    }

    return count > 0 ? count : 1;
  }
}
