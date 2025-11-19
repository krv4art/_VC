// services/cover_letter_service.dart
// Service for generating and managing cover letters

import 'package:cv_engineer/models/cover_letter.dart';
import 'package:cv_engineer/models/resume.dart';
import 'package:uuid/uuid.dart';

class CoverLetterService {
  static const _uuid = Uuid();

  /// Generate AI-powered cover letter
  static Future<CoverLetter> generateCoverLetter({
    required Resume resume,
    required String companyName,
    required String position,
    String hiringManagerName = '',
    String jobDescription = '',
    CoverLetterTemplate template = CoverLetterTemplate.professional,
  }) async {
    // AI generation logic (using fallback for offline)
    final content = await _generateContent(
      resume: resume,
      companyName: companyName,
      position: position,
      hiringManagerName: hiringManagerName,
      jobDescription: jobDescription,
      template: template,
    );

    return CoverLetter(
      id: _uuid.v4(),
      resumeId: resume.id,
      companyName: companyName,
      position: position,
      hiringManagerName: hiringManagerName,
      content: content,
      template: template,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Generate cover letter content
  static Future<String> _generateContent({
    required Resume resume,
    required String companyName,
    required String position,
    required String hiringManagerName,
    required String jobDescription,
    required CoverLetterTemplate template,
  }) async {
    // Fallback template-based generation
    final greeting = hiringManagerName.isNotEmpty
        ? 'Dear $hiringManagerName,'
        : 'Dear Hiring Manager,';

    final intro = _getIntroduction(position, companyName);
    final body = _getBody(resume, position, jobDescription);
    final closing = _getClosing(companyName);

    return '''
$greeting

$intro

$body

$closing

Sincerely,
${resume.personalInfo.fullName}
${resume.personalInfo.email}
${resume.personalInfo.phone}
''';
  }

  static String _getIntroduction(String position, String companyName) {
    return '''I am writing to express my strong interest in the $position position at $companyName. With my background and skills, I am confident that I would make a valuable addition to your team.''';
  }

  static String _getBody(Resume resume, String position, String jobDescription) {
    final buffer = StringBuffer();

    // Professional summary
    if (resume.personalInfo.summary.isNotEmpty) {
      buffer.writeln(resume.personalInfo.summary);
      buffer.writeln();
    }

    // Highlight key experience
    if (resume.experiences.isNotEmpty) {
      final latestExp = resume.experiences.first;
      buffer.writeln(
        'In my current role as ${latestExp.jobTitle} at ${latestExp.company}, I have gained extensive experience that directly aligns with the requirements for this position. ${latestExp.description}',
      );
      buffer.writeln();
    }

    // Highlight skills
    if (resume.skills.isNotEmpty) {
      final topSkills = resume.skills.take(5).map((s) => s.name).join(', ');
      buffer.writeln(
        'My technical expertise includes $topSkills, which I believe will be valuable in contributing to your team\'s success.',
      );
      buffer.writeln();
    }

    return buffer.toString();
  }

  static String _getClosing(String companyName) {
    return '''I am excited about the opportunity to contribute to $companyName and would welcome the chance to discuss how my skills and experience align with your needs. Thank you for considering my application.''';
  }

  /// Get template-specific styling
  static Map<String, dynamic> getTemplateStyle(CoverLetterTemplate template) {
    switch (template) {
      case CoverLetterTemplate.professional:
        return {
          'fontSize': 11.0,
          'fontFamily': 'Roboto',
          'lineSpacing': 1.5,
          'paragraphSpacing': 12.0,
        };
      case CoverLetterTemplate.creative:
        return {
          'fontSize': 10.5,
          'fontFamily': 'Merriweather',
          'lineSpacing': 1.6,
          'paragraphSpacing': 14.0,
        };
      case CoverLetterTemplate.modern:
        return {
          'fontSize': 11.0,
          'fontFamily': 'Roboto',
          'lineSpacing': 1.5,
          'paragraphSpacing': 12.0,
        };
      case CoverLetterTemplate.executive:
        return {
          'fontSize': 12.0,
          'fontFamily': 'Merriweather',
          'lineSpacing': 1.8,
          'paragraphSpacing': 16.0,
        };
      case CoverLetterTemplate.entryLevel:
        return {
          'fontSize': 10.5,
          'fontFamily': 'Roboto',
          'lineSpacing': 1.5,
          'paragraphSpacing': 10.0,
        };
    }
  }

  /// Custom content generation prompts
  static String getAIPrompt({
    required String position,
    required String companyName,
    required String jobDescription,
    required String resumeSummary,
  }) {
    return '''Generate a professional cover letter for:
Position: $position
Company: $companyName
Job Description: ${jobDescription.isNotEmpty ? jobDescription : 'Not provided'}

Candidate Summary: $resumeSummary

The cover letter should:
- Be concise (3-4 paragraphs)
- Highlight relevant skills and experience
- Show enthusiasm for the role
- Maintain professional tone
- Be specific to the company and role
''';
  }
}
