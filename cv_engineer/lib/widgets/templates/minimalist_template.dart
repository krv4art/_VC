import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../../models/resume.dart';
import '../../theme/app_theme.dart';
import 'resume_template.dart';

/// Minimalist template - Ultra-clean layout with maximum white space
class MinimalistTemplate extends ResumeTemplate {
  const MinimalistTemplate({
    super.key,
    required super.resume,
  });

  @override
  String get templateId => 'minimalist';

  @override
  String get templateName => 'Minimalist';

  @override
  String get templateDescription => 'Ultra-clean and simple design with focus on content';

  @override
  Color get primaryColor => const Color(0xFF212121);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: EdgeInsets.all(resume.marginSize * 1.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(theme),
          const SizedBox(height: 40),

          if (resume.personalInfo.profileSummary != null &&
              resume.personalInfo.profileSummary!.isNotEmpty) ...[
            Text(
              resume.personalInfo.profileSummary!,
              style: TextStyle(
                fontSize: resume.fontSize,
                height: 1.8,
                color: Colors.grey[700],
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 40),
          ],

          if (resume.experiences.isNotEmpty) ...[
            _buildSectionTitle('Experience'),
            const SizedBox(height: 24),
            ...resume.experiences.map((exp) => _buildExperience(exp, theme)),
          ],

          if (resume.educations.isNotEmpty) ...[
            const SizedBox(height: 40),
            _buildSectionTitle('Education'),
            const SizedBox(height: 24),
            ...resume.educations.map((edu) => _buildEducation(edu, theme)),
          ],

          if (resume.skills.isNotEmpty) ...[
            const SizedBox(height: 40),
            _buildSectionTitle('Skills'),
            const SizedBox(height: 24),
            _buildSkills(theme),
          ],

          if (resume.languages.isNotEmpty) ...[
            const SizedBox(height: 40),
            _buildSectionTitle('Languages'),
            const SizedBox(height: 24),
            _buildLanguages(theme),
          ],

          ...resume.customSections.map((section) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              _buildSectionTitle(section.title),
              const SizedBox(height: 24),
              ...section.items.map((item) => _buildCustomItem(item, theme)),
            ],
          )),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    final hasPhoto = resume.personalInfo.photoPath != null &&
                    resume.personalInfo.photoPath!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasPhoto) ...[
          Center(child: _buildProfilePhoto()),
          const SizedBox(height: 24),
        ],
        Text(
          resume.personalInfo.fullName.toUpperCase(),
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w200,
            letterSpacing: 4,
            color: primaryColor,
          ),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 24,
          runSpacing: 12,
          children: [
            if (resume.personalInfo.email.isNotEmpty)
              _buildContactItem(resume.personalInfo.email),
            if (resume.personalInfo.phone.isNotEmpty)
              _buildContactItem(resume.personalInfo.phone),
            if (resume.personalInfo.city != null && resume.personalInfo.city!.isNotEmpty)
              _buildContactItem(
                [resume.personalInfo.city, resume.personalInfo.country]
                  .where((s) => s != null && s.isNotEmpty).join(', ')),
            if (resume.personalInfo.linkedin != null)
              _buildContactItem(resume.personalInfo.linkedin!),
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
        border: Border.all(color: Colors.grey[300]!, width: 1),
        image: DecorationImage(
          image: kIsWeb
            ? NetworkImage(photoPath) as ImageProvider
            : FileImage(File(photoPath)),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildContactItem(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: resume.fontSize - 1,
        color: Colors.grey[600],
        fontWeight: FontWeight.w300,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        fontSize: resume.fontSize + 2,
        fontWeight: FontWeight.w300,
        letterSpacing: 3,
        color: primaryColor,
      ),
    );
  }

  Widget _buildExperience(dynamic exp, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Expanded(
                child: Text(
                  exp.jobTitle,
                  style: TextStyle(
                    fontSize: resume.fontSize + 1,
                    fontWeight: FontWeight.w400,
                    color: primaryColor,
                  ),
                ),
              ),
              Text(
                exp.getDuration(),
                style: TextStyle(
                  fontSize: resume.fontSize - 2,
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            exp.company + (exp.location != null ? ' · ${exp.location}' : ''),
            style: TextStyle(
              fontSize: resume.fontSize - 1,
              color: Colors.grey[600],
              fontWeight: FontWeight.w300,
            ),
          ),
          if (exp.description != null && exp.description!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              exp.description!,
              style: TextStyle(
                fontSize: resume.fontSize - 1,
                height: 1.7,
                color: Colors.grey[700],
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
          if (exp.responsibilities.isNotEmpty) ...[
            const SizedBox(height: 12),
            ...exp.responsibilities.map((resp) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '—  ',
                    style: TextStyle(
                      fontSize: resume.fontSize - 1,
                      color: Colors.grey[400],
                    ),
                  ),
                  Expanded(
                    child: Text(
                      resp,
                      style: TextStyle(
                        fontSize: resume.fontSize - 1,
                        height: 1.7,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w300,
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
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            edu.degree,
            style: TextStyle(
              fontSize: resume.fontSize + 1,
              fontWeight: FontWeight.w400,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            edu.institution,
            style: TextStyle(
              fontSize: resume.fontSize - 1,
              color: Colors.grey[600],
              fontWeight: FontWeight.w300,
            ),
          ),
          if (edu.gpa != null) ...[
            const SizedBox(height: 4),
            Text(
              'GPA: ${edu.gpa}',
              style: TextStyle(
                fontSize: resume.fontSize - 2,
                color: Colors.grey[500],
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
          if (edu.achievements.isNotEmpty) ...[
            const SizedBox(height: 12),
            ...edu.achievements.map((achievement) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '—  ',
                    style: TextStyle(
                      fontSize: resume.fontSize - 1,
                      color: Colors.grey[400],
                    ),
                  ),
                  Expanded(
                    child: Text(
                      achievement,
                      style: TextStyle(
                        fontSize: resume.fontSize - 1,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w300,
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

  Widget _buildSkills(ThemeData theme) {
    final groupedSkills = <String, List<String>>{};
    for (var skill in resume.skills) {
      groupedSkills.putIfAbsent(skill.category, () => []).add(skill.name);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: groupedSkills.entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entry.key,
                style: TextStyle(
                  fontSize: resume.fontSize - 1,
                  fontWeight: FontWeight.w400,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                entry.value.join('  ·  '),
                style: TextStyle(
                  fontSize: resume.fontSize - 1,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w300,
                  height: 1.6,
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
      spacing: 24,
      runSpacing: 12,
      children: resume.languages.map((lang) {
        return Text(
          '${lang.name} (${lang.proficiency.shortName})',
          style: TextStyle(
            fontSize: resume.fontSize - 1,
            color: Colors.grey[700],
            fontWeight: FontWeight.w300,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCustomItem(dynamic item, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.title,
            style: TextStyle(
              fontSize: resume.fontSize + 1,
              fontWeight: FontWeight.w400,
              color: primaryColor,
            ),
          ),
          if (item.subtitle != null) ...[
            const SizedBox(height: 6),
            Text(
              item.subtitle!,
              style: TextStyle(
                fontSize: resume.fontSize - 1,
                color: Colors.grey[600],
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
          if (item.description != null && item.description!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              item.description!,
              style: TextStyle(
                fontSize: resume.fontSize - 1,
                color: Colors.grey[700],
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
          if (item.bulletPoints.isNotEmpty) ...[
            const SizedBox(height: 12),
            ...item.bulletPoints.map((bp) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '—  ',
                    style: TextStyle(
                      fontSize: resume.fontSize - 1,
                      color: Colors.grey[400],
                    ),
                  ),
                  Expanded(
                    child: Text(
                      bp,
                      style: TextStyle(
                        fontSize: resume.fontSize - 1,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w300,
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
