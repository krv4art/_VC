// services/ats_service.dart
// Service for ATS analysis of resumes against job descriptions

import 'package:cv_engineer/models/ats_analysis.dart';
import 'package:cv_engineer/models/job_description.dart';
import 'package:cv_engineer/models/resume.dart';
import 'package:cv_engineer/services/keyword_extractor.dart';
import 'package:uuid/uuid.dart';

class ATSService {
  static const _uuid = Uuid();

  /// Analyze resume against job description
  static Future<ATSAnalysis> analyzeResume({
    required Resume resume,
    required JobDescription jobDescription,
  }) async {
    // Extract resume text
    final resumeText = _extractResumeText(resume);

    // Extract keywords from job description
    final jobKeywords = KeywordExtractor.extractKeywords(
      jobDescription.getCombinedText(),
      maxKeywords: 50,
    );

    // Extract skills from job description
    final jobSkills = KeywordExtractor.extractSkills(
      jobDescription.getCombinedText(),
    );

    // Match keywords
    final keywordMatches = KeywordExtractor.matchKeywords(
      jobKeywords: [...jobKeywords, ...jobSkills],
      resumeText: resumeText,
      requiredSkills: jobDescription.requiredSkills,
    );

    // Separate matched and missing keywords
    final matchedKeywords = keywordMatches.where((k) => k.isInResume).toList();
    final missingKeywords = keywordMatches.where((k) => !k.isInResume).toList();

    // Analyze sections
    final sectionAnalyses = _analyzeSections(resume);

    // Check format
    final formatAnalysis = _analyzeFormat(resume);

    // Analyze content
    final contentAnalysis = _analyzeContent(resume, resumeText);

    // Calculate scores
    final keywordScore = _calculateKeywordScore(
      matchedKeywords.length,
      keywordMatches.length,
      missingKeywords.where((k) => k.isRequired).length,
    );

    final formatScore = formatAnalysis['score'] as double;
    final contentScore = contentAnalysis['score'] as double;

    final overallScore = (keywordScore * 0.4 + formatScore * 0.3 + contentScore * 0.3);

    // Generate recommendations
    final recommendations = _generateRecommendations(
      matchedKeywords: matchedKeywords,
      missingKeywords: missingKeywords,
      sectionAnalyses: sectionAnalyses,
      formatIssues: formatAnalysis['issues'] as List<String>,
      contentAnalysis: contentAnalysis,
    );

    // Identify strengths
    final strengths = _identifyStrengths(
      matchedKeywords: matchedKeywords,
      sectionAnalyses: sectionAnalyses,
      contentAnalysis: contentAnalysis,
    );

    // Identify critical issues
    final criticalIssues = _identifyCriticalIssues(
      missingKeywords: missingKeywords,
      formatIssues: formatAnalysis['issues'] as List<String>,
      sectionAnalyses: sectionAnalyses,
    );

    return ATSAnalysis(
      id: _uuid.v4(),
      resume: resume,
      jobDescription: jobDescription,
      overallScore: overallScore,
      keywordMatchScore: keywordScore,
      formatScore: formatScore,
      contentScore: contentScore,
      matchedKeywords: matchedKeywords,
      missingKeywords: missingKeywords,
      totalKeywords: keywordMatches.length,
      matchedKeywordsCount: matchedKeywords.length,
      sectionAnalyses: sectionAnalyses,
      isATSFriendlyFormat: formatAnalysis['isATSFriendly'] as bool,
      formatIssues: formatAnalysis['issues'] as List<String>,
      formatWarnings: formatAnalysis['warnings'] as List<String>,
      totalWordCount: contentAnalysis['wordCount'] as int,
      recommendedWordCount: 400, // Standard recommendation
      readabilityScore: contentAnalysis['readabilityScore'] as double,
      hasActionVerbs: contentAnalysis['hasActionVerbs'] as bool,
      hasQuantifiableAchievements: contentAnalysis['hasQuantifiableAchievements'] as bool,
      criticalIssues: criticalIssues,
      recommendations: recommendations,
      strengthAreas: strengths,
      analyzedAt: DateTime.now(),
    );
  }

  // Extract all text from resume
  static String _extractResumeText(Resume resume) {
    final parts = <String>[];

    // Personal info
    parts.add(resume.personalInfo.fullName);
    parts.add(resume.personalInfo.email);
    parts.add(resume.personalInfo.phone);
    parts.add(resume.personalInfo.summary);

    // Experience
    for (final exp in resume.experiences) {
      parts.add(exp.jobTitle);
      parts.add(exp.company);
      parts.add(exp.description);
      parts.addAll(exp.responsibilities);
    }

    // Education
    for (final edu in resume.educations) {
      parts.add(edu.degree);
      parts.add(edu.institution);
      parts.add(edu.description);
      parts.addAll(edu.achievements);
    }

    // Skills
    for (final skill in resume.skills) {
      parts.add(skill.name);
    }

    // Languages
    for (final lang in resume.languages) {
      parts.add(lang.name);
    }

    // Custom sections
    for (final section in resume.customSections) {
      parts.add(section.title);
      for (final entry in section.entries) {
        parts.add(entry.title);
        parts.add(entry.description);
      }
    }

    return parts.where((p) => p.isNotEmpty).join(' ');
  }

  // Analyze resume sections
  static List<SectionAnalysis> _analyzeSections(Resume resume) {
    final analyses = <SectionAnalysis>[];

    // Personal Info
    final summaryWordCount = resume.personalInfo.summary.split(RegExp(r'\s+')).length;
    analyses.add(SectionAnalysis(
      sectionName: 'Professional Summary',
      isPresent: resume.personalInfo.summary.isNotEmpty,
      wordCount: summaryWordCount,
      qualityScore: summaryWordCount >= 30 && summaryWordCount <= 80 ? 1.0 : 0.5,
      suggestions: summaryWordCount < 30
          ? ['Add a more detailed professional summary (30-80 words recommended)']
          : summaryWordCount > 80
              ? ['Consider shortening your summary to 30-80 words']
              : [],
    ));

    // Experience
    final hasExperience = resume.experiences.isNotEmpty;
    final expWithMetrics = resume.experiences.where(
      (exp) => KeywordExtractor.hasQuantifiableAchievements(
        '${exp.description} ${exp.responsibilities.join(' ')}',
      ),
    ).length;

    analyses.add(SectionAnalysis(
      sectionName: 'Work Experience',
      isPresent: hasExperience,
      wordCount: resume.experiences.fold(0, (sum, exp) {
        return sum +
            exp.description.split(RegExp(r'\s+')).length +
            exp.responsibilities.join(' ').split(RegExp(r'\s+')).length;
      }),
      qualityScore: hasExperience && expWithMetrics > 0 ? 0.9 : hasExperience ? 0.6 : 0.0,
      suggestions: !hasExperience
          ? ['Add work experience to strengthen your resume']
          : expWithMetrics == 0
              ? ['Add quantifiable achievements to your experience (numbers, percentages)']
              : [],
    ));

    // Education
    analyses.add(SectionAnalysis(
      sectionName: 'Education',
      isPresent: resume.educations.isNotEmpty,
      wordCount: resume.educations.fold(0, (sum, edu) {
        return sum + edu.description.split(RegExp(r'\s+')).length;
      }),
      qualityScore: resume.educations.isNotEmpty ? 1.0 : 0.5,
      suggestions: resume.educations.isEmpty ? ['Add your education background'] : [],
    ));

    // Skills
    final hasSkills = resume.skills.isNotEmpty;
    analyses.add(SectionAnalysis(
      sectionName: 'Skills',
      isPresent: hasSkills,
      wordCount: resume.skills.length,
      qualityScore: resume.skills.length >= 5 ? 1.0 : resume.skills.length >= 3 ? 0.7 : 0.4,
      suggestions: resume.skills.length < 5
          ? ['Add more relevant skills (5-15 recommended)']
          : resume.skills.length > 20
              ? ['Consider reducing skills to most relevant 10-15']
              : [],
    ));

    return analyses;
  }

  // Analyze format (ATS-friendliness)
  static Map<String, dynamic> _analyzeFormat(Resume resume) {
    final issues = <String>[];
    final warnings = <String>[];
    double score = 100.0;

    // Check for contact information
    if (resume.personalInfo.email.isEmpty) {
      issues.add('Missing email address');
      score -= 15;
    }

    if (resume.personalInfo.phone.isEmpty) {
      warnings.add('Missing phone number');
      score -= 5;
    }

    // Check for professional summary
    if (resume.personalInfo.summary.isEmpty) {
      warnings.add('Missing professional summary');
      score -= 10;
    }

    // Check for work experience
    if (resume.experiences.isEmpty) {
      issues.add('No work experience listed');
      score -= 20;
    }

    // Check for education
    if (resume.educations.isEmpty) {
      warnings.add('No education listed');
      score -= 10;
    }

    // Check for skills
    if (resume.skills.isEmpty) {
      issues.add('No skills listed');
      score -= 15;
    }

    // Check for date formatting in experience
    for (final exp in resume.experiences) {
      if (exp.startDate == null) {
        warnings.add('Missing start date for ${exp.jobTitle}');
        score -= 2;
      }
    }

    final isATSFriendly = issues.isEmpty && score >= 70;

    return {
      'score': score.clamp(0.0, 100.0),
      'issues': issues,
      'warnings': warnings,
      'isATSFriendly': isATSFriendly,
    };
  }

  // Analyze content quality
  static Map<String, dynamic> _analyzeContent(Resume resume, String resumeText) {
    final wordCount = resumeText.split(RegExp(r'\s+')).length;
    final hasActionVerbs = KeywordExtractor.hasActionVerbs(resumeText);
    final hasQuantifiableAchievements = KeywordExtractor.hasQuantifiableAchievements(resumeText);
    final readabilityScore = KeywordExtractor.calculateReadabilityScore(resumeText);

    double score = 50.0; // Base score

    // Word count (optimal: 300-600 words)
    if (wordCount >= 300 && wordCount <= 600) {
      score += 20;
    } else if (wordCount >= 200 && wordCount <= 800) {
      score += 10;
    }

    // Action verbs
    if (hasActionVerbs) {
      score += 15;
    }

    // Quantifiable achievements
    if (hasQuantifiableAchievements) {
      score += 15;
    }

    return {
      'score': score.clamp(0.0, 100.0),
      'wordCount': wordCount,
      'hasActionVerbs': hasActionVerbs,
      'hasQuantifiableAchievements': hasQuantifiableAchievements,
      'readabilityScore': readabilityScore,
    };
  }

  // Calculate keyword match score
  static double _calculateKeywordScore(
    int matched,
    int total,
    int missingRequired,
  ) {
    if (total == 0) return 0.0;

    double baseScore = (matched / total) * 100;

    // Penalty for missing required skills
    final penalty = missingRequired * 10.0;

    return (baseScore - penalty).clamp(0.0, 100.0);
  }

  // Generate recommendations
  static List<String> _generateRecommendations({
    required List<KeywordMatch> matchedKeywords,
    required List<KeywordMatch> missingKeywords,
    required List<SectionAnalysis> sectionAnalyses,
    required List<String> formatIssues,
    required Map<String, dynamic> contentAnalysis,
  }) {
    final recommendations = <String>[];

    // Missing required keywords
    final missingRequired = missingKeywords.where((k) => k.isRequired).toList();
    if (missingRequired.isNotEmpty) {
      recommendations.add(
        'Add these required skills: ${missingRequired.take(5).map((k) => k.keyword).join(', ')}',
      );
    }

    // Missing preferred keywords
    final missingPreferred = missingKeywords.where((k) => !k.isRequired).take(3).toList();
    if (missingPreferred.isNotEmpty) {
      recommendations.add(
        'Consider adding: ${missingPreferred.map((k) => k.keyword).join(', ')}',
      );
    }

    // Section recommendations
    for (final section in sectionAnalyses) {
      recommendations.addAll(section.suggestions);
    }

    // Format issues
    for (final issue in formatIssues.take(3)) {
      recommendations.add('Fix: $issue');
    }

    // Content recommendations
    if (!(contentAnalysis['hasActionVerbs'] as bool)) {
      recommendations.add('Use more action verbs (achieved, improved, led, etc.)');
    }

    if (!(contentAnalysis['hasQuantifiableAchievements'] as bool)) {
      recommendations.add('Add quantifiable achievements (numbers, percentages, metrics)');
    }

    final wordCount = contentAnalysis['wordCount'] as int;
    if (wordCount < 300) {
      recommendations.add('Expand your resume content (current: $wordCount words, recommended: 300-600)');
    } else if (wordCount > 600) {
      recommendations.add('Consider condensing your resume (current: $wordCount words, recommended: 300-600)');
    }

    return recommendations.take(10).toList();
  }

  // Identify strengths
  static List<String> _identifyStrengths({
    required List<KeywordMatch> matchedKeywords,
    required List<SectionAnalysis> sectionAnalyses,
    required Map<String, dynamic> contentAnalysis,
  }) {
    final strengths = <String>[];

    // Keyword matches
    if (matchedKeywords.length >= 10) {
      strengths.add('Strong keyword alignment (${matchedKeywords.length} matches)');
    }

    // High-quality sections
    for (final section in sectionAnalyses) {
      if (section.qualityScore >= 0.8) {
        strengths.add('Well-written ${section.sectionName}');
      }
    }

    // Content quality
    if (contentAnalysis['hasActionVerbs'] as bool) {
      strengths.add('Uses strong action verbs');
    }

    if (contentAnalysis['hasQuantifiableAchievements'] as bool) {
      strengths.add('Includes quantifiable achievements');
    }

    final readability = contentAnalysis['readabilityScore'] as double;
    if (readability >= 60) {
      strengths.add('Good readability score');
    }

    return strengths;
  }

  // Identify critical issues
  static List<String> _identifyCriticalIssues({
    required List<KeywordMatch> missingKeywords,
    required List<String> formatIssues,
    required List<SectionAnalysis> sectionAnalyses,
  }) {
    final critical = <String>[];

    // Missing required skills
    final missingRequired = missingKeywords.where((k) => k.isRequired).toList();
    if (missingRequired.length >= 3) {
      critical.add('Missing ${missingRequired.length} required skills');
    }

    // Format issues
    if (formatIssues.isNotEmpty) {
      critical.addAll(formatIssues.take(2));
    }

    // Missing critical sections
    final missingSections = sectionAnalyses.where((s) => !s.isPresent).toList();
    if (missingSections.isNotEmpty) {
      critical.add('Missing sections: ${missingSections.map((s) => s.sectionName).join(', ')}');
    }

    return critical;
  }
}
