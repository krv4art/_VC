// services/resume_analytics_service.dart
// Service for analyzing resume quality and providing insights

import 'package:cv_engineer/models/resume.dart';
import 'package:cv_engineer/services/keyword_extractor.dart';

class ResumeAnalytics {
  final double overallScore; // 0-100
  final Map<String, double> sectionScores;
  final int wordCount;
  final double readabilityScore;
  final bool hasActionVerbs;
  final bool hasQuantifiableAchievements;
  final List<String> strengths;
  final List<String> improvements;
  final Map<String, int> completeness;

  ResumeAnalytics({
    required this.overallScore,
    required this.sectionScores,
    required this.wordCount,
    required this.readabilityScore,
    required this.hasActionVerbs,
    required this.hasQuantifiableAchievements,
    required this.strengths,
    required this.improvements,
    required this.completeness,
  });
}

class ResumeAnalyticsService {
  /// Analyze resume quality
  static ResumeAnalytics analyzeResume(Resume resume) {
    final sectionScores = <String, double>{};
    final strengths = <String>[];
    final improvements = <String>[];
    final completeness = <String, int>{};

    // Analyze each section
    sectionScores['personalInfo'] = _analyzePersonalInfo(resume, strengths, improvements, completeness);
    sectionScores['experience'] = _analyzeExperience(resume, strengths, improvements, completeness);
    sectionScores['education'] = _analyzeEducation(resume, strengths, improvements, completeness);
    sectionScores['skills'] = _analyzeSkills(resume, strengths, improvements, completeness);
    sectionScores['languages'] = _analyzeLanguages(resume, strengths, improvements, completeness);

    // Extract text for content analysis
    final resumeText = _extractResumeText(resume);
    final wordCount = resumeText.split(RegExp(r'\s+')).length;
    final readabilityScore = KeywordExtractor.calculateReadabilityScore(resumeText);
    final hasActionVerbs = KeywordExtractor.hasActionVerbs(resumeText);
    final hasQuantifiableAchievements = KeywordExtractor.hasQuantifiableAchievements(resumeText);

    // Content quality checks
    if (hasActionVerbs) {
      strengths.add('Uses strong action verbs');
    } else {
      improvements.add('Add action verbs (achieved, improved, led, etc.)');
    }

    if (hasQuantifiableAchievements) {
      strengths.add('Includes quantifiable achievements');
    } else {
      improvements.add('Add numbers and metrics to achievements');
    }

    if (wordCount >= 300 && wordCount <= 600) {
      strengths.add('Optimal resume length');
    } else if (wordCount < 300) {
      improvements.add('Resume is too short - add more details');
    } else {
      improvements.add('Resume is too long - be more concise');
    }

    // Calculate overall score
    final overallScore = _calculateOverallScore(
      sectionScores,
      wordCount,
      readabilityScore,
      hasActionVerbs,
      hasQuantifiableAchievements,
    );

    return ResumeAnalytics(
      overallScore: overallScore,
      sectionScores: sectionScores,
      wordCount: wordCount,
      readabilityScore: readabilityScore,
      hasActionVerbs: hasActionVerbs,
      hasQuantifiableAchievements: hasQuantifiableAchievements,
      strengths: strengths,
      improvements: improvements,
      completeness: completeness,
    );
  }

  static double _analyzePersonalInfo(
    Resume resume,
    List<String> strengths,
    List<String> improvements,
    Map<String, int> completeness,
  ) {
    double score = 0;
    int total = 4;
    int completed = 0;

    if (resume.personalInfo.fullName.isNotEmpty) {
      score += 25;
      completed++;
    }

    if (resume.personalInfo.email.isNotEmpty) {
      score += 25;
      completed++;
    } else {
      improvements.add('Add email address');
    }

    if (resume.personalInfo.phone.isNotEmpty) {
      score += 25;
      completed++;
    } else {
      improvements.add('Add phone number');
    }

    if (resume.personalInfo.summary.isNotEmpty) {
      final summaryWords = resume.personalInfo.summary.split(RegExp(r'\s+')).length;
      if (summaryWords >= 30 && summaryWords <= 80) {
        score += 25;
        strengths.add('Well-written professional summary');
        completed++;
      } else if (summaryWords < 30) {
        score += 15;
        improvements.add('Expand professional summary (30-80 words recommended)');
        completed++;
      } else {
        score += 15;
        improvements.add('Shorten professional summary');
        completed++;
      }
    } else {
      improvements.add('Add professional summary');
    }

    completeness['Personal Info'] = ((completed / total) * 100).round();
    return score;
  }

  static double _analyzeExperience(
    Resume resume,
    List<String> strengths,
    List<String> improvements,
    Map<String, int> completeness,
  ) {
    if (resume.experiences.isEmpty) {
      improvements.add('Add work experience');
      completeness['Experience'] = 0;
      return 0;
    }

    double score = 50; // Base score for having experience
    int qualityChecks = 0;
    final int totalChecks = 4;

    // Check for descriptions
    final hasDescriptions = resume.experiences.any((exp) => exp.description.isNotEmpty);
    if (hasDescriptions) {
      score += 12.5;
      qualityChecks++;
    } else {
      improvements.add('Add descriptions to experience entries');
    }

    // Check for responsibilities
    final hasResponsibilities = resume.experiences.any((exp) => exp.responsibilities.isNotEmpty);
    if (hasResponsibilities) {
      score += 12.5;
      qualityChecks++;
      strengths.add('Detailed job responsibilities');
    } else {
      improvements.add('Add bullet points to experience');
    }

    // Check for dates
    final hasDates = resume.experiences.every((exp) => exp.startDate != null);
    if (hasDates) {
      score += 12.5;
      qualityChecks++;
    } else {
      improvements.add('Add dates to all experience entries');
    }

    // Check for achievements
    final allText = resume.experiences.map((e) => '${e.description} ${e.responsibilities.join(' ')}').join(' ');
    if (KeywordExtractor.hasQuantifiableAchievements(allText)) {
      score += 12.5;
      qualityChecks++;
      strengths.add('Quantifiable achievements in experience');
    } else {
      improvements.add('Add metrics to achievements (%, numbers, etc.)');
    }

    completeness['Experience'] = ((qualityChecks / totalChecks) * 100).round();
    return score;
  }

  static double _analyzeEducation(
    Resume resume,
    List<String> strengths,
    List<String> improvements,
    Map<String, int> completeness,
  ) {
    if (resume.educations.isEmpty) {
      improvements.add('Add education background');
      completeness['Education'] = 50; // Optionalfor experienced professionals
      return 50;
    }

    strengths.add('Education background included');
    completeness['Education'] = 100;
    return 100;
  }

  static double _analyzeSkills(
    Resume resume,
    List<String> strengths,
    List<String> improvements,
    Map<String, int> completeness,
  ) {
    final skillCount = resume.skills.length;

    if (skillCount == 0) {
      improvements.add('Add relevant skills');
      completeness['Skills'] = 0;
      return 0;
    }

    double score = 0;
    if (skillCount >= 5 && skillCount <= 15) {
      score = 100;
      strengths.add('Good number of skills ($skillCount)');
    } else if (skillCount < 5) {
      score = 60;
      improvements.add('Add more skills (5-15 recommended)');
    } else {
      score = 80;
      improvements.add('Consider reducing to top 10-15 skills');
    }

    completeness['Skills'] = ((skillCount / 10) * 100).clamp(0, 100).round();
    return score;
  }

  static double _analyzeLanguages(
    Resume resume,
    List<String> strengths,
    List<String> improvements,
    Map<String, int> completeness,
  ) {
    if (resume.languages.isEmpty) {
      improvements.add('Add language proficiencies');
      completeness['Languages'] = 0;
      return 0;
    }

    strengths.add('Language skills specified');
    completeness['Languages'] = 100;
    return 100;
  }

  static String _extractResumeText(Resume resume) {
    final parts = <String>[];

    parts.add(resume.personalInfo.fullName);
    parts.add(resume.personalInfo.summary);

    for (final exp in resume.experiences) {
      parts.add(exp.jobTitle);
      parts.add(exp.company);
      parts.add(exp.description);
      parts.addAll(exp.responsibilities);
    }

    for (final edu in resume.educations) {
      parts.add(edu.degree);
      parts.add(edu.institution);
      parts.add(edu.description);
    }

    return parts.where((p) => p.isNotEmpty).join(' ');
  }

  static double _calculateOverallScore(
    Map<String, double> sectionScores,
    int wordCount,
    double readabilityScore,
    bool hasActionVerbs,
    bool hasQuantifiableAchievements,
  ) {
    // Weighted average of section scores
    double baseScore = 0;
    baseScore += sectionScores['personalInfo']! * 0.20;
    baseScore += sectionScores['experience']! * 0.35;
    baseScore += sectionScores['education']! * 0.15;
    baseScore += sectionScores['skills']! * 0.20;
    baseScore += sectionScores['languages']! * 0.10;

    // Content quality bonuses
    if (wordCount >= 300 && wordCount <= 600) {
      baseScore += 5;
    }
    if (hasActionVerbs) {
      baseScore += 3;
    }
    if (hasQuantifiableAchievements) {
      baseScore += 2;
    }

    return baseScore.clamp(0, 100);
  }
}
