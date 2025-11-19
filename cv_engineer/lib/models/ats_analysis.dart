// models/ats_analysis.dart
// Model for ATS analysis results

import 'package:cv_engineer/models/job_description.dart';
import 'package:cv_engineer/models/resume.dart';

class KeywordMatch {
  final String keyword;
  final bool isInResume;
  final int occurrencesInJob;
  final int occurrencesInResume;
  final double relevanceScore; // 0.0 to 1.0
  final bool isRequired; // Required vs preferred skill

  KeywordMatch({
    required this.keyword,
    required this.isInResume,
    required this.occurrencesInJob,
    required this.occurrencesInResume,
    required this.relevanceScore,
    this.isRequired = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'keyword': keyword,
      'isInResume': isInResume,
      'occurrencesInJob': occurrencesInJob,
      'occurrencesInResume': occurrencesInResume,
      'relevanceScore': relevanceScore,
      'isRequired': isRequired,
    };
  }

  factory KeywordMatch.fromJson(Map<String, dynamic> json) {
    return KeywordMatch(
      keyword: json['keyword'] as String,
      isInResume: json['isInResume'] as bool,
      occurrencesInJob: json['occurrencesInJob'] as int,
      occurrencesInResume: json['occurrencesInResume'] as int,
      relevanceScore: (json['relevanceScore'] as num).toDouble(),
      isRequired: json['isRequired'] as bool? ?? false,
    );
  }
}

class SectionAnalysis {
  final String sectionName;
  final bool isPresent;
  final int wordCount;
  final double qualityScore; // 0.0 to 1.0
  final List<String> suggestions;

  SectionAnalysis({
    required this.sectionName,
    required this.isPresent,
    required this.wordCount,
    required this.qualityScore,
    required this.suggestions,
  });

  Map<String, dynamic> toJson() {
    return {
      'sectionName': sectionName,
      'isPresent': isPresent,
      'wordCount': wordCount,
      'qualityScore': qualityScore,
      'suggestions': suggestions,
    };
  }

  factory SectionAnalysis.fromJson(Map<String, dynamic> json) {
    return SectionAnalysis(
      sectionName: json['sectionName'] as String,
      isPresent: json['isPresent'] as bool,
      wordCount: json['wordCount'] as int,
      qualityScore: (json['qualityScore'] as num).toDouble(),
      suggestions: (json['suggestions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );
  }
}

class ATSAnalysis {
  final String id;
  final Resume resume;
  final JobDescription jobDescription;

  // Overall scores
  final double overallScore; // 0-100
  final double keywordMatchScore; // 0-100
  final double formatScore; // 0-100
  final double contentScore; // 0-100

  // Keyword analysis
  final List<KeywordMatch> matchedKeywords;
  final List<KeywordMatch> missingKeywords;
  final int totalKeywords;
  final int matchedKeywordsCount;

  // Section analysis
  final List<SectionAnalysis> sectionAnalyses;

  // Format checks
  final bool isATSFriendlyFormat;
  final List<String> formatIssues;
  final List<String> formatWarnings;

  // Content analysis
  final int totalWordCount;
  final int recommendedWordCount;
  final double readabilityScore; // Flesch reading ease
  final bool hasActionVerbs;
  final bool hasQuantifiableAchievements;

  // Recommendations
  final List<String> criticalIssues;
  final List<String> recommendations;
  final List<String> strengthAreas;

  // Metadata
  final DateTime analyzedAt;
  final String version; // Analysis algorithm version

  ATSAnalysis({
    required this.id,
    required this.resume,
    required this.jobDescription,
    required this.overallScore,
    required this.keywordMatchScore,
    required this.formatScore,
    required this.contentScore,
    required this.matchedKeywords,
    required this.missingKeywords,
    required this.totalKeywords,
    required this.matchedKeywordsCount,
    required this.sectionAnalyses,
    required this.isATSFriendlyFormat,
    required this.formatIssues,
    required this.formatWarnings,
    required this.totalWordCount,
    required this.recommendedWordCount,
    required this.readabilityScore,
    required this.hasActionVerbs,
    required this.hasQuantifiableAchievements,
    required this.criticalIssues,
    required this.recommendations,
    required this.strengthAreas,
    required this.analyzedAt,
    this.version = '1.0.0',
  });

  // Get score level (Poor, Fair, Good, Excellent)
  String getScoreLevel() {
    if (overallScore >= 80) return 'Excellent';
    if (overallScore >= 60) return 'Good';
    if (overallScore >= 40) return 'Fair';
    return 'Poor';
  }

  // Get score color for UI
  String getScoreColor() {
    if (overallScore >= 80) return '#4CAF50'; // Green
    if (overallScore >= 60) return '#8BC34A'; // Light Green
    if (overallScore >= 40) return '#FF9800'; // Orange
    return '#F44336'; // Red
  }

  // Get keyword match percentage
  double getKeywordMatchPercentage() {
    if (totalKeywords == 0) return 0.0;
    return (matchedKeywordsCount / totalKeywords) * 100;
  }

  // Get missing required skills
  List<KeywordMatch> getMissingRequiredSkills() {
    return missingKeywords.where((k) => k.isRequired).toList();
  }

  // Get missing preferred skills
  List<KeywordMatch> getMissingPreferredSkills() {
    return missingKeywords.where((k) => !k.isRequired).toList();
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'resume': resume.toJson(),
      'jobDescription': jobDescription.toJson(),
      'overallScore': overallScore,
      'keywordMatchScore': keywordMatchScore,
      'formatScore': formatScore,
      'contentScore': contentScore,
      'matchedKeywords': matchedKeywords.map((k) => k.toJson()).toList(),
      'missingKeywords': missingKeywords.map((k) => k.toJson()).toList(),
      'totalKeywords': totalKeywords,
      'matchedKeywordsCount': matchedKeywordsCount,
      'sectionAnalyses': sectionAnalyses.map((s) => s.toJson()).toList(),
      'isATSFriendlyFormat': isATSFriendlyFormat,
      'formatIssues': formatIssues,
      'formatWarnings': formatWarnings,
      'totalWordCount': totalWordCount,
      'recommendedWordCount': recommendedWordCount,
      'readabilityScore': readabilityScore,
      'hasActionVerbs': hasActionVerbs,
      'hasQuantifiableAchievements': hasQuantifiableAchievements,
      'criticalIssues': criticalIssues,
      'recommendations': recommendations,
      'strengthAreas': strengthAreas,
      'analyzedAt': analyzedAt.toIso8601String(),
      'version': version,
    };
  }

  // Create from JSON
  factory ATSAnalysis.fromJson(Map<String, dynamic> json) {
    return ATSAnalysis(
      id: json['id'] as String,
      resume: Resume.fromJson(json['resume'] as Map<String, dynamic>),
      jobDescription: JobDescription.fromJson(
        json['jobDescription'] as Map<String, dynamic>,
      ),
      overallScore: (json['overallScore'] as num).toDouble(),
      keywordMatchScore: (json['keywordMatchScore'] as num).toDouble(),
      formatScore: (json['formatScore'] as num).toDouble(),
      contentScore: (json['contentScore'] as num).toDouble(),
      matchedKeywords: (json['matchedKeywords'] as List<dynamic>)
          .map((k) => KeywordMatch.fromJson(k as Map<String, dynamic>))
          .toList(),
      missingKeywords: (json['missingKeywords'] as List<dynamic>)
          .map((k) => KeywordMatch.fromJson(k as Map<String, dynamic>))
          .toList(),
      totalKeywords: json['totalKeywords'] as int,
      matchedKeywordsCount: json['matchedKeywordsCount'] as int,
      sectionAnalyses: (json['sectionAnalyses'] as List<dynamic>)
          .map((s) => SectionAnalysis.fromJson(s as Map<String, dynamic>))
          .toList(),
      isATSFriendlyFormat: json['isATSFriendlyFormat'] as bool,
      formatIssues: (json['formatIssues'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      formatWarnings: (json['formatWarnings'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      totalWordCount: json['totalWordCount'] as int,
      recommendedWordCount: json['recommendedWordCount'] as int,
      readabilityScore: (json['readabilityScore'] as num).toDouble(),
      hasActionVerbs: json['hasActionVerbs'] as bool,
      hasQuantifiableAchievements: json['hasQuantifiableAchievements'] as bool,
      criticalIssues: (json['criticalIssues'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      recommendations: (json['recommendations'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      strengthAreas: (json['strengthAreas'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      analyzedAt: DateTime.parse(json['analyzedAt'] as String),
      version: json['version'] as String? ?? '1.0.0',
    );
  }
}
