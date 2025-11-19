// services/linkedin_import_service.dart
// LinkedIn profile import service

import 'package:cv_engineer/models/resume.dart';
import 'package:cv_engineer/models/personal_info.dart';
import 'package:cv_engineer/models/experience.dart';
import 'package:cv_engineer/models/education.dart';
import 'package:cv_engineer/models/skill.dart';

class LinkedInImportService {
  /// Import resume data from LinkedIn URL
  /// Note: This is a placeholder for LinkedIn integration
  /// In production, this would require LinkedIn OAuth API
  static Future<Resume> importFromLinkedIn(String profileUrl) async {
    // TODO: Implement LinkedIn API integration
    // For now, return empty resume with a note

    throw UnimplementedError(
      'LinkedIn import requires OAuth API integration. '
      'Visit LinkedIn Developer Portal to set up API access.',
    );
  }

  /// Parse LinkedIn profile data
  /// This would be called after successful OAuth authentication
  static Resume parseLinkedInProfile(Map<String, dynamic> profileData) {
    final personalInfo = _parsePersonalInfo(profileData);
    final experiences = _parseExperiences(profileData);
    final educations = _parseEducation(profileData);
    final skills = _parseSkills(profileData);

    return Resume(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      templateId: 'professional',
      personalInfo: personalInfo,
      experiences: experiences,
      educations: educations,
      skills: skills,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  static PersonalInfo _parsePersonalInfo(Map<String, dynamic> data) {
    return PersonalInfo(
      fullName: data['firstName'] ?? '' + ' ' + (data['lastName'] ?? ''),
      email: data['emailAddress'] ?? '',
      phone: '', // LinkedIn doesn't always provide phone
      summary: data['headline'] ?? '',
      profileSummary: data['summary'] ?? null,
      photoUrl: data['profilePicture']?.['displayImage'] ?? null,
    );
  }

  static List<Experience> _parseExperiences(Map<String, dynamic> data) {
    final positions = data['positions']?['values'] as List? ?? [];

    return positions.map<Experience>((position) {
      return Experience(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        jobTitle: position['title'] ?? '',
        company: position['company']?['name'] ?? '',
        location: position['location']?['name'] ?? '',
        startDate: _parseDate(position['startDate']),
        endDate: _parseDate(position['endDate']),
        isCurrentPosition: position['isCurrent'] ?? false,
        description: position['summary'] ?? '',
        responsibilities: [],
      );
    }).toList();
  }

  static List<Education> _parseEducation(Map<String, dynamic> data) {
    final educations = data['educations']?['values'] as List? ?? [];

    return educations.map<Education>((edu) {
      return Education(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        degree: edu['degreeName'] ?? '',
        institution: edu['schoolName'] ?? '',
        location: '',
        startDate: _parseDate(edu['startDate']),
        endDate: _parseDate(edu['endDate']),
        isCurrentlyStudying: false,
        gpa: '',
        description: edu['activities'] ?? '',
        achievements: [],
      );
    }).toList();
  }

  static List<Skill> _parseSkills(Map<String, dynamic> data) {
    final skills = data['skills']?['values'] as List? ?? [];

    return skills.map<Skill>((skill) {
      return Skill(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: skill['name'] ?? '',
        category: 'Technical', // Default category
        proficiency: 'Advanced', // Default proficiency
      );
    }).toList();
  }

  static DateTime? _parseDate(Map<String, dynamic>? dateMap) {
    if (dateMap == null) return null;

    final year = dateMap['year'];
    final month = dateMap['month'] ?? 1;
    final day = dateMap['day'] ?? 1;

    if (year == null) return null;

    return DateTime(year as int, month as int, day as int);
  }

  /// Manual LinkedIn import helper
  /// Provides guidance for users to manually enter data
  static Map<String, String> getImportGuide() {
    return {
      'step1': 'Go to your LinkedIn profile',
      'step2': 'Click "More" → "Save to PDF"',
      'step3': 'Copy information from PDF to resume',
      'tip': 'Or use LinkedIn\'s "Request your data" feature for structured export',
    };
  }
}
