import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../../models/resume.dart';
import '../../theme/app_theme.dart';
import 'resume_template.dart';

/// Academic template - Traditional academic CV layout
class AcademicTemplate extends ResumeTemplate {
  const AcademicTemplate({
    super.key,
    required super.resume,
  });

  @override
  String get templateId => 'academic';

  @override
  String get templateName => 'Academic';

  @override
  String get templateDescription => 'Traditional academic CV format for researchers and educators';

  @override
  Color get primaryColor => const Color(0xFF8B0000); // Dark red

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: EdgeInsets.all(resume.marginSize),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(theme),

          // Horizontal line separator
          const SizedBox(height: 16),
          Container(
            height: 1,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 24),

          if (resume.personalInfo.profileSummary != null &&
              resume.personalInfo.profileSummary!.isNotEmpty) ...[
            _buildSectionTitle('Research Interests & Summary'),
            const SizedBox(height: 12),
            Text(
              resume.personalInfo.profileSummary!,
              style: TextStyle(
                fontSize: resume.fontSize,
                height: 1.7,
                color: Colors.grey[800],
                fontFamily: 'Georgia',
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 28),
          ],

          if (resume.educations.isNotEmpty) ...[
            _buildSectionTitle('Education'),
            const SizedBox(height: 12),
            ...resume.educations.map((edu) => _buildEducation(edu, theme)),
            const SizedBox(height: 28),
          ],

          if (resume.experiences.isNotEmpty) ...[
            _buildSectionTitle('Professional Experience'),
            const SizedBox(height: 12),
            ...resume.experiences.map((exp) => _buildExperience(exp, theme)),
            const SizedBox(height: 28),
          ],

          if (resume.skills.isNotEmpty) ...[
            _buildSectionTitle('Skills & Expertise'),
            const SizedBox(height: 12),
            _buildSkills(theme),
            const SizedBox(height: 28),
          ],

          if (resume.languages.isNotEmpty) ...[
            _buildSectionTitle('Languages'),
            const SizedBox(height: 12),
            _buildLanguages(theme),
            const SizedBox(height: 28),
          ],

          ...resume.customSections.map((section) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle(section.title),
              const SizedBox(height: 12),
              ...section.items.map((item) => _buildCustomItem(item, theme)),
              const SizedBox(height: 28),
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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (hasPhoto) ...[
          _buildProfilePhoto(),
          const SizedBox(height: 16),
        ],
        Text(
          resume.personalInfo.fullName,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: primaryColor,
            fontFamily: 'Georgia',
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        _buildContactInfo(),
      ],
    );
  }

  Widget _buildProfilePhoto() {
    final photoPath = resume.personalInfo.photoPath!;

    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: primaryColor, width: 2),
        image: DecorationImage(
          image: kIsWeb
            ? NetworkImage(photoPath) as ImageProvider
            : FileImage(File(photoPath)),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildContactInfo() {
    final contactItems = <String>[];

    if (resume.personalInfo.email.isNotEmpty) {
      contactItems.add(resume.personalInfo.email);
    }
    if (resume.personalInfo.phone.isNotEmpty) {
      contactItems.add(resume.personalInfo.phone);
    }
    if (resume.personalInfo.city != null && resume.personalInfo.city!.isNotEmpty) {
      contactItems.add(
        [resume.personalInfo.city, resume.personalInfo.country]
          .where((s) => s != null && s.isNotEmpty).join(', ')
      );
    }
    if (resume.personalInfo.linkedin != null) {
      contactItems.add(resume.personalInfo.linkedin!);
    }

    return Column(
      children: contactItems.map((item) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Text(
          item,
          style: TextStyle(
            fontSize: resume.fontSize - 1,
            color: Colors.grey[700],
          ),
          textAlign: TextAlign.center,
        ),
      )).toList(),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: TextStyle(
            fontSize: resume.fontSize + 2,
            fontWeight: FontWeight.bold,
            color: primaryColor,
            letterSpacing: 0.5,
            fontFamily: 'Georgia',
          ),
        ),
        const SizedBox(height: 4),
        Container(
          height: 1,
          color: primaryColor,
        ),
      ],
    );
  }

  Widget _buildEducation(dynamic edu, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: resume.fontSize,
                      color: Colors.black,
                      fontFamily: 'Georgia',
                    ),
                    children: [
                      TextSpan(
                        text: edu.degree,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(text: ', '),
                      TextSpan(
                        text: edu.institution,
                        style: const TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),
              ),
              Text(
                _formatEducationDate(edu),
                style: TextStyle(
                  fontSize: resume.fontSize - 1,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
          if (edu.gpa != null) ...[
            const SizedBox(height: 6),
            Text(
              'GPA: ${edu.gpa}',
              style: TextStyle(
                fontSize: resume.fontSize - 1,
                color: Colors.grey[700],
              ),
            ),
          ],
          if (edu.achievements.isNotEmpty) ...[
            const SizedBox(height: 10),
            ...edu.achievements.map((achievement) => Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '◦ ',
                    style: TextStyle(
                      fontSize: resume.fontSize,
                      color: primaryColor,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      achievement,
                      style: TextStyle(
                        fontSize: resume.fontSize - 1,
                        color: Colors.grey[800],
                        height: 1.5,
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

  String _formatEducationDate(dynamic edu) {
    if (edu.endDate != null) {
      return '${edu.endDate!.year}';
    } else if (edu.startDate != null) {
      return '${edu.startDate!.year} - Present';
    }
    return '';
  }

  Widget _buildExperience(dynamic exp, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: resume.fontSize,
                      color: Colors.black,
                      fontFamily: 'Georgia',
                    ),
                    children: [
                      TextSpan(
                        text: exp.jobTitle,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              Text(
                exp.getDuration(),
                style: TextStyle(
                  fontSize: resume.fontSize - 1,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: resume.fontSize - 1,
                color: Colors.grey[800],
                fontFamily: 'Georgia',
              ),
              children: [
                TextSpan(
                  text: exp.company,
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
                if (exp.location != null)
                  TextSpan(text: ', ${exp.location}'),
              ],
            ),
          ),
          if (exp.description != null && exp.description!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              exp.description!,
              style: TextStyle(
                fontSize: resume.fontSize - 1,
                height: 1.6,
                color: Colors.grey[800],
              ),
              textAlign: TextAlign.justify,
            ),
          ],
          if (exp.responsibilities.isNotEmpty) ...[
            const SizedBox(height: 10),
            ...exp.responsibilities.map((resp) => Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '◦ ',
                    style: TextStyle(
                      fontSize: resume.fontSize,
                      color: primaryColor,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      resp,
                      style: TextStyle(
                        fontSize: resume.fontSize - 1,
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

  Widget _buildSkills(ThemeData theme) {
    final groupedSkills = <String, List<String>>{};
    for (var skill in resume.skills) {
      groupedSkills.putIfAbsent(skill.category, () => []).add(skill.name);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: groupedSkills.entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: resume.fontSize - 1,
                color: Colors.grey[800],
                fontFamily: 'Georgia',
              ),
              children: [
                TextSpan(
                  text: '${entry.key}: ',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                TextSpan(text: entry.value.join(', ')),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLanguages(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: resume.languages.map((lang) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: resume.fontSize - 1,
                color: Colors.grey[800],
                fontFamily: 'Georgia',
              ),
              children: [
                TextSpan(
                  text: lang.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: ' - ${lang.proficiency.displayName}'),
              ],
            ),
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
              fontSize: resume.fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: 'Georgia',
            ),
          ),
          if (item.subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              item.subtitle!,
              style: TextStyle(
                fontSize: resume.fontSize - 1,
                fontStyle: FontStyle.italic,
                color: Colors.grey[700],
              ),
            ),
          ],
          if (item.description != null && item.description!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              item.description!,
              style: TextStyle(
                fontSize: resume.fontSize - 1,
                color: Colors.grey[800],
                height: 1.6,
              ),
              textAlign: TextAlign.justify,
            ),
          ],
          if (item.bulletPoints.isNotEmpty) ...[
            const SizedBox(height: 10),
            ...item.bulletPoints.map((bp) => Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '◦ ',
                    style: TextStyle(
                      fontSize: resume.fontSize,
                      color: primaryColor,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      bp,
                      style: TextStyle(
                        fontSize: resume.fontSize - 1,
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
