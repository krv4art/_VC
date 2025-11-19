import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../../models/resume.dart';
import '../../theme/app_theme.dart';
import 'resume_template.dart';

/// Professional template - Clean, traditional layout with blue theme
class ProfessionalTemplate extends ResumeTemplate {
  const ProfessionalTemplate({
    super.key,
    required super.resume,
  });

  @override
  String get templateId => 'professional';

  @override
  String get templateName => 'Professional';

  @override
  String get templateDescription => 'Clean and traditional layout perfect for corporate roles';

  @override
  Color get primaryColor => const Color(0xFF1976D2);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: EdgeInsets.all(resume.marginSize),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(theme),
          const SizedBox(height: 24),

          if (resume.personalInfo.profileSummary != null &&
              resume.personalInfo.profileSummary!.isNotEmpty) ...[
            _buildSectionTitle('PROFESSIONAL SUMMARY', theme),
            const SizedBox(height: 12),
            Text(
              resume.personalInfo.profileSummary!,
              style: TextStyle(
                fontSize: resume.fontSize,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 24),
          ],

          if (resume.experiences.isNotEmpty) ...[
            _buildSectionTitle('EXPERIENCE', theme),
            const SizedBox(height: 12),
            ...resume.experiences.map((exp) => _buildExperience(exp, theme)),
            const SizedBox(height: 24),
          ],

          if (resume.educations.isNotEmpty) ...[
            _buildSectionTitle('EDUCATION', theme),
            const SizedBox(height: 12),
            ...resume.educations.map((edu) => _buildEducation(edu, theme)),
            const SizedBox(height: 24),
          ],

          if (resume.skills.isNotEmpty) ...[
            _buildSectionTitle('SKILLS', theme),
            const SizedBox(height: 12),
            _buildSkills(theme),
            const SizedBox(height: 24),
          ],

          if (resume.languages.isNotEmpty) ...[
            _buildSectionTitle('LANGUAGES', theme),
            const SizedBox(height: 12),
            _buildLanguages(theme),
            const SizedBox(height: 24),
          ],

          ...resume.customSections.map((section) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle(section.title.toUpperCase(), theme),
              const SizedBox(height: 12),
              ...section.items.map((item) => _buildCustomItem(item, theme)),
              const SizedBox(height: 24),
            ],
          )),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    final hasPhoto = resume.personalInfo.photoPath != null &&
                    resume.personalInfo.photoPath!.isNotEmpty;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasPhoto) ...[
          _buildProfilePhoto(),
          const SizedBox(width: 24),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                resume.personalInfo.fullName,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 16,
                runSpacing: 8,
                children: [
                  if (resume.personalInfo.email.isNotEmpty)
                    _buildContactItem(Icons.email, resume.personalInfo.email),
                  if (resume.personalInfo.phone.isNotEmpty)
                    _buildContactItem(Icons.phone, resume.personalInfo.phone),
                  if (resume.personalInfo.city != null && resume.personalInfo.city!.isNotEmpty)
                    _buildContactItem(Icons.location_on,
                      [resume.personalInfo.city, resume.personalInfo.country]
                        .where((s) => s != null && s.isNotEmpty).join(', ')),
                  if (resume.personalInfo.linkedin != null)
                    _buildContactItem(Icons.link, resume.personalInfo.linkedin!),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                height: 3,
                width: 60,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfilePhoto() {
    final photoPath = resume.personalInfo.photoPath!;

    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: primaryColor, width: 3),
        image: DecorationImage(
          image: kIsWeb
            ? NetworkImage(photoPath) as ImageProvider
            : FileImage(File(photoPath)),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: primaryColor),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(fontSize: resume.fontSize - 1),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: resume.fontSize + 4,
            fontWeight: FontWeight.bold,
            color: primaryColor,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          height: 2,
          width: 40,
          color: primaryColor,
        ),
      ],
    );
  }

  Widget _buildExperience(dynamic exp, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  exp.jobTitle,
                  style: TextStyle(
                    fontSize: resume.fontSize + 2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                exp.getDuration(),
                style: TextStyle(
                  fontSize: resume.fontSize - 1,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                exp.company,
                style: TextStyle(
                  fontSize: resume.fontSize,
                  fontWeight: FontWeight.w600,
                  color: primaryColor,
                ),
              ),
              if (exp.location != null) ...[
                Text(' • ', style: TextStyle(fontSize: resume.fontSize)),
                Expanded(
                  child: Text(
                    exp.location!,
                    style: TextStyle(
                      fontSize: resume.fontSize,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ],
          ),
          if (exp.description != null && exp.description!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              exp.description!,
              style: TextStyle(fontSize: resume.fontSize, height: 1.5),
            ),
          ],
          if (exp.responsibilities.isNotEmpty) ...[
            const SizedBox(height: 8),
            ...exp.responsibilities.map((resp) => Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('• ', style: TextStyle(fontSize: resume.fontSize)),
                  Expanded(
                    child: Text(
                      resp,
                      style: TextStyle(fontSize: resume.fontSize, height: 1.5),
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
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            edu.degree,
            style: TextStyle(
              fontSize: resume.fontSize + 2,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            edu.institution,
            style: TextStyle(
              fontSize: resume.fontSize,
              color: primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (edu.gpa != null) ...[
            const SizedBox(height: 4),
            Text(
              'GPA: ${edu.gpa}',
              style: TextStyle(fontSize: resume.fontSize - 1),
            ),
          ],
          if (edu.achievements.isNotEmpty) ...[
            const SizedBox(height: 8),
            ...edu.achievements.map((achievement) => Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('• ', style: TextStyle(fontSize: resume.fontSize)),
                  Expanded(
                    child: Text(
                      achievement,
                      style: TextStyle(fontSize: resume.fontSize),
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

  Widget _buildSkills(ThemeData theme) {
    final groupedSkills = <String, List<String>>{};
    for (var skill in resume.skills) {
      groupedSkills.putIfAbsent(skill.category, () => []).add(skill.name);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: groupedSkills.entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 150,
                child: Text(
                  '${entry.key}:',
                  style: TextStyle(
                    fontSize: resume.fontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  entry.value.join(' • '),
                  style: TextStyle(fontSize: resume.fontSize),
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
      spacing: 16,
      runSpacing: 8,
      children: resume.languages.map((lang) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            border: Border.all(color: primaryColor),
            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
          ),
          child: Text(
            '${lang.name} - ${lang.proficiency.shortName}',
            style: TextStyle(
              fontSize: resume.fontSize - 1,
              color: primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCustomItem(dynamic item, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.title,
            style: TextStyle(
              fontSize: resume.fontSize + 2,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (item.subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              item.subtitle!,
              style: TextStyle(
                fontSize: resume.fontSize,
                color: primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          if (item.description != null && item.description!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              item.description!,
              style: TextStyle(fontSize: resume.fontSize),
            ),
          ],
          if (item.bulletPoints.isNotEmpty) ...[
            const SizedBox(height: 8),
            ...item.bulletPoints.map((bp) => Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('• ', style: TextStyle(fontSize: resume.fontSize)),
                  Expanded(
                    child: Text(
                      bp,
                      style: TextStyle(fontSize: resume.fontSize),
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
