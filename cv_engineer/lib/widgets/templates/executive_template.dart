import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../../models/resume.dart';
import '../../theme/app_theme.dart';
import 'resume_template.dart';

/// Executive template - Formal and sophisticated layout for senior positions
class ExecutiveTemplate extends ResumeTemplate {
  const ExecutiveTemplate({
    super.key,
    required super.resume,
  });

  @override
  String get templateId => 'executive';

  @override
  String get templateName => 'Executive';

  @override
  String get templateDescription => 'Sophisticated and formal design for C-level positions';

  @override
  Color get primaryColor => const Color(0xFF1A237E); // Deep indigo

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Column(
        children: [
          // Header with dark background
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(resume.marginSize * 1.5),
            decoration: BoxDecoration(
              color: primaryColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: _buildHeader(theme),
          ),

          // Content area
          Padding(
            padding: EdgeInsets.all(resume.marginSize * 1.5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (resume.personalInfo.profileSummary != null &&
                    resume.personalInfo.profileSummary!.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  _buildExecutiveSummary(theme),
                  const SizedBox(height: 32),
                ],

                if (resume.experiences.isNotEmpty) ...[
                  _buildSectionTitle('PROFESSIONAL EXPERIENCE', theme),
                  const SizedBox(height: 20),
                  ...resume.experiences.map((exp) => _buildExperience(exp, theme)),
                ],

                if (resume.educations.isNotEmpty) ...[
                  const SizedBox(height: 32),
                  _buildSectionTitle('EDUCATION & CREDENTIALS', theme),
                  const SizedBox(height: 20),
                  ...resume.educations.map((edu) => _buildEducation(edu, theme)),
                ],

                if (resume.skills.isNotEmpty) ...[
                  const SizedBox(height: 32),
                  _buildSectionTitle('CORE COMPETENCIES', theme),
                  const SizedBox(height: 20),
                  _buildSkills(theme),
                ],

                if (resume.languages.isNotEmpty) ...[
                  const SizedBox(height: 32),
                  _buildSectionTitle('LANGUAGES', theme),
                  const SizedBox(height: 20),
                  _buildLanguages(theme),
                ],

                ...resume.customSections.map((section) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 32),
                    _buildSectionTitle(section.title.toUpperCase(), theme),
                    const SizedBox(height: 20),
                    ...section.items.map((item) => _buildCustomItem(item, theme)),
                  ],
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    final hasPhoto = resume.personalInfo.photoPath != null &&
                    resume.personalInfo.photoPath!.isNotEmpty;

    return Column(
      children: [
        if (hasPhoto) ...[
          _buildProfilePhoto(),
          const SizedBox(height: 20),
        ],
        Text(
          resume.personalInfo.fullName.toUpperCase(),
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 2,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Container(
          height: 2,
          width: 80,
          color: Colors.amber[700],
        ),
        const SizedBox(height: 16),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 20,
          runSpacing: 8,
          children: [
            if (resume.personalInfo.email.isNotEmpty)
              _buildHeaderContact(Icons.email_outlined, resume.personalInfo.email),
            if (resume.personalInfo.phone.isNotEmpty)
              _buildHeaderContact(Icons.phone_outlined, resume.personalInfo.phone),
            if (resume.personalInfo.city != null && resume.personalInfo.city!.isNotEmpty)
              _buildHeaderContact(Icons.location_on_outlined,
                [resume.personalInfo.city, resume.personalInfo.country]
                  .where((s) => s != null && s.isNotEmpty).join(', ')),
            if (resume.personalInfo.linkedin != null)
              _buildHeaderContact(Icons.link, resume.personalInfo.linkedin!),
          ],
        ),
      ],
    );
  }

  Widget _buildProfilePhoto() {
    final photoPath = resume.personalInfo.photoPath!;

    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.amber[700]!, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        image: DecorationImage(
          image: kIsWeb
            ? NetworkImage(photoPath) as ImageProvider
            : FileImage(File(photoPath)),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildHeaderContact(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.amber[700]),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            fontSize: resume.fontSize - 1,
            color: Colors.white.withOpacity(0.95),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildExecutiveSummary(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border(
          left: BorderSide(color: Colors.amber[700]!, width: 4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'EXECUTIVE SUMMARY',
            style: TextStyle(
              fontSize: resume.fontSize,
              fontWeight: FontWeight.bold,
              color: primaryColor,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            resume.personalInfo.profileSummary!,
            style: TextStyle(
              fontSize: resume.fontSize,
              height: 1.7,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.amber[700]!, width: 2),
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: resume.fontSize + 4,
          fontWeight: FontWeight.bold,
          color: primaryColor,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildExperience(dynamic exp, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exp.jobTitle,
                      style: TextStyle(
                        fontSize: resume.fontSize + 2,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      exp.company,
                      style: TextStyle(
                        fontSize: resume.fontSize + 1,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Text(
                  exp.getDuration(),
                  style: TextStyle(
                    fontSize: resume.fontSize - 1,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          if (exp.location != null) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  exp.location!,
                  style: TextStyle(
                    fontSize: resume.fontSize - 1,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ],
          if (exp.description != null && exp.description!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              exp.description!,
              style: TextStyle(
                fontSize: resume.fontSize,
                height: 1.6,
                color: Colors.grey[800],
              ),
            ),
          ],
          if (exp.responsibilities.isNotEmpty) ...[
            const SizedBox(height: 12),
            ...exp.responsibilities.map((resp) => Padding(
              padding: const EdgeInsets.only(bottom: 8, left: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.amber[700],
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      resp,
                      style: TextStyle(
                        fontSize: resume.fontSize,
                        height: 1.6,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ],
      ),
    );
  }

  Widget _buildEducation(dynamic edu, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.school, color: primaryColor, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  edu.degree,
                  style: TextStyle(
                    fontSize: resume.fontSize + 1,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  edu.institution,
                  style: TextStyle(
                    fontSize: resume.fontSize,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                if (edu.gpa != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'GPA: ${edu.gpa}',
                    style: TextStyle(
                      fontSize: resume.fontSize - 1,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
                if (edu.achievements.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  ...edu.achievements.map((achievement) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      '• $achievement',
                      style: TextStyle(
                        fontSize: resume.fontSize - 1,
                        color: Colors.grey[700],
                      ),
                    ),
                  )),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkills(ThemeData theme) {
    final groupedSkills = <String, List<String>>{};
    for (var skill in resume.skills) {
      groupedSkills.putIfAbsent(skill.category, () => []).add(skill.name);
    }

    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: groupedSkills.entries.map((entry) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                entry.key,
                style: TextStyle(
                  fontSize: resume.fontSize,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                entry.value.join(' • '),
                style: TextStyle(
                  fontSize: resume.fontSize - 1,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLanguages(ThemeData theme) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: resume.languages.map((lang) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.language, size: 16, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                '${lang.name} (${lang.proficiency.shortName})',
                style: TextStyle(
                  fontSize: resume.fontSize - 1,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCustomItem(dynamic item, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.title,
            style: TextStyle(
              fontSize: resume.fontSize + 1,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          if (item.subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              item.subtitle!,
              style: TextStyle(
                fontSize: resume.fontSize,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
          ],
          if (item.description != null && item.description!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              item.description!,
              style: TextStyle(
                fontSize: resume.fontSize,
                color: Colors.grey[800],
              ),
            ),
          ],
          if (item.bulletPoints.isNotEmpty) ...[
            const SizedBox(height: 8),
            ...item.bulletPoints.map((bp) => Padding(
              padding: const EdgeInsets.only(bottom: 6, left: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.amber[700],
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      bp,
                      style: TextStyle(
                        fontSize: resume.fontSize,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ],
      ),
    );
  }
}
