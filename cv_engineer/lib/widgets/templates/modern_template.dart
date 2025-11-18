import 'package:flutter/material.dart';
import '../../models/resume.dart';
import '../../theme/app_theme.dart';
import 'resume_template.dart';

/// Modern template - Minimalist, tech-focused layout with teal theme
class ModernTemplate extends ResumeTemplate {
  const ModernTemplate({
    super.key,
    required super.resume,
  });

  @override
  String get templateId => 'modern';

  @override
  String get templateName => 'Modern';

  @override
  String get templateDescription => 'Clean and minimal design perfect for tech professionals';

  @override
  Color get primaryColor => const Color(0xFF009688);

  Color get secondaryColor => const Color(0xFF00BCD4);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: EdgeInsets.all(resume.marginSize),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left sidebar
          SizedBox(
            width: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSidebarSection('Contact', _buildContactInfo(), theme),
                const SizedBox(height: 24),

                if (resume.skills.isNotEmpty) ...[
                  _buildSidebarSection('Skills', _buildSkillsSidebar(), theme),
                  const SizedBox(height: 24),
                ],

                if (resume.languages.isNotEmpty) ...[
                  _buildSidebarSection('Languages', _buildLanguagesSidebar(), theme),
                  const SizedBox(height: 24),
                ],
              ],
            ),
          ),

          const SizedBox(width: 32),

          // Main content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(theme),
                const SizedBox(height: 32),

                if (resume.personalInfo.profileSummary != null &&
                    resume.personalInfo.profileSummary!.isNotEmpty) ...[
                  _buildMainSectionTitle('Summary'),
                  const SizedBox(height: 12),
                  Text(
                    resume.personalInfo.profileSummary!,
                    style: TextStyle(
                      fontSize: resume.fontSize,
                      height: 1.6,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                if (resume.experiences.isNotEmpty) ...[
                  _buildMainSectionTitle('Experience'),
                  const SizedBox(height: 12),
                  ...resume.experiences.map((exp) => _buildExperience(exp, theme)),
                ],

                if (resume.educations.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  _buildMainSectionTitle('Education'),
                  const SizedBox(height: 12),
                  ...resume.educations.map((edu) => _buildEducation(edu, theme)),
                ],

                ...resume.customSections.map((section) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    _buildMainSectionTitle(section.title),
                    const SizedBox(height: 12),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          resume.personalInfo.fullName.toUpperCase(),
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w300,
            letterSpacing: 4,
            color: primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 4,
          width: 80,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryColor, secondaryColor],
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }

  Widget _buildSidebarSection(String title, Widget content, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: TextStyle(
            fontSize: resume.fontSize,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            color: primaryColor,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          height: 2,
          width: 30,
          color: secondaryColor,
        ),
        const SizedBox(height: 12),
        content,
      ],
    );
  }

  Widget _buildContactInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (resume.personalInfo.email.isNotEmpty)
          _buildContactItem(Icons.email_outlined, resume.personalInfo.email),
        if (resume.personalInfo.phone.isNotEmpty)
          _buildContactItem(Icons.phone_outlined, resume.personalInfo.phone),
        if (resume.personalInfo.city != null && resume.personalInfo.city!.isNotEmpty)
          _buildContactItem(Icons.location_on_outlined,
            [resume.personalInfo.city, resume.personalInfo.country]
              .where((s) => s != null && s.isNotEmpty).join(', ')),
        if (resume.personalInfo.linkedin != null)
          _buildContactItem(Icons.link, 'LinkedIn'),
        if (resume.personalInfo.github != null)
          _buildContactItem(Icons.code, 'GitHub'),
      ],
    );
  }

  Widget _buildContactItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: secondaryColor),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: resume.fontSize - 2,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillsSidebar() {
    // Group skills by category
    final groupedSkills = <String, List<String>>{};
    for (var skill in resume.skills) {
      groupedSkills.putIfAbsent(skill.category, () => []).add(skill.name);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: groupedSkills.entries.expand((entry) {
        return [
          Text(
            entry.key,
            style: TextStyle(
              fontSize: resume.fontSize - 1,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 6),
          ...entry.value.map((skillName) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: secondaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    skillName,
                    style: TextStyle(
                      fontSize: resume.fontSize - 2,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          )),
          const SizedBox(height: 12),
        ];
      }).toList(),
    );
  }

  Widget _buildLanguagesSidebar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: resume.languages.map((lang) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                lang.name,
                style: TextStyle(
                  fontSize: resume.fontSize - 1,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                width: double.infinity,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(3),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: _getLanguageProficiency(lang.proficiency.value),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [primaryColor, secondaryColor],
                      ),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                lang.proficiency.shortName,
                style: TextStyle(
                  fontSize: resume.fontSize - 3,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  double _getLanguageProficiency(int value) {
    // Convert CEFR level (1-6) to percentage
    return value / 6.0;
  }

  Widget _buildMainSectionTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: TextStyle(
            fontSize: resume.fontSize + 4,
            fontWeight: FontWeight.w600,
            letterSpacing: 2,
            color: primaryColor,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          height: 3,
          width: 50,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryColor, secondaryColor],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExperience(dynamic exp, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryColor, secondaryColor],
                  ),
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                width: 2,
                height: 100,
                color: Colors.grey[300],
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                      ),
                      child: Text(
                        exp.getDuration(),
                        style: TextStyle(
                          fontSize: resume.fontSize - 2,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  exp.company,
                  style: TextStyle(
                    fontSize: resume.fontSize,
                    fontWeight: FontWeight.w600,
                    color: secondaryColor,
                  ),
                ),
                if (exp.location != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    exp.location!,
                    style: TextStyle(
                      fontSize: resume.fontSize - 1,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
                if (exp.description != null && exp.description!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    exp.description!,
                    style: TextStyle(
                      fontSize: resume.fontSize,
                      height: 1.5,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
                if (exp.responsibilities.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  ...exp.responsibilities.map((resp) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [primaryColor, secondaryColor],
                            ),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            resp,
                            style: TextStyle(
                              fontSize: resume.fontSize,
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
          ),
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
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryColor, secondaryColor],
                  ),
                  shape: BoxShape.circle,
                ),
              ),
              if (resume.educations.last != edu)
                Container(
                  width: 2,
                  height: 80,
                  color: Colors.grey[300],
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
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
                    fontWeight: FontWeight.w600,
                    color: secondaryColor,
                  ),
                ),
                if (edu.gpa != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'GPA: ${edu.gpa}',
                    style: TextStyle(
                      fontSize: resume.fontSize - 1,
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
                if (edu.achievements.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  ...edu.achievements.map((achievement) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: secondaryColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
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
          ),
        ],
      ),
    );
  }

  Widget _buildCustomItem(dynamic item, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryColor, secondaryColor],
                  ),
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                width: 2,
                height: 60,
                color: Colors.grey[300],
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
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
                      fontWeight: FontWeight.w600,
                      color: secondaryColor,
                    ),
                  ),
                ],
                if (item.description != null && item.description!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    item.description!,
                    style: TextStyle(
                      fontSize: resume.fontSize,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
                if (item.bulletPoints.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  ...item.bulletPoints.map((bp) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [primaryColor, secondaryColor],
                            ),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
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
          ),
        ],
      ),
    );
  }
}
