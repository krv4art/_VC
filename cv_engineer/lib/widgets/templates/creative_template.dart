import 'package:flutter/material.dart';
import '../../models/resume.dart';
import '../../theme/app_theme.dart';
import 'resume_template.dart';

/// Creative template - Modern, colorful layout with purple theme
class CreativeTemplate extends ResumeTemplate {
  const CreativeTemplate({
    super.key,
    required super.resume,
  });

  @override
  String get templateId => 'creative';

  @override
  String get templateName => 'Creative';

  @override
  String get templateDescription => 'Bold and modern design for creative professionals';

  @override
  Color get primaryColor => const Color(0xFF9C27B0);

  Color get accentColor => const Color(0xFFE91E63);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: EdgeInsets.all(resume.marginSize),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(theme),
          const SizedBox(height: 32),

          if (resume.personalInfo.profileSummary != null &&
              resume.personalInfo.profileSummary!.isNotEmpty) ...[
            _buildSectionTitle(Icons.person, 'About Me', theme),
            const SizedBox(height: 12),
            _buildSummaryCard(theme),
            const SizedBox(height: 24),
          ],

          if (resume.experiences.isNotEmpty) ...[
            _buildSectionTitle(Icons.work, 'Experience', theme),
            const SizedBox(height: 12),
            ...resume.experiences.map((exp) => _buildExperience(exp, theme)),
            const SizedBox(height: 24),
          ],

          if (resume.educations.isNotEmpty) ...[
            _buildSectionTitle(Icons.school, 'Education', theme),
            const SizedBox(height: 12),
            ...resume.educations.map((edu) => _buildEducation(edu, theme)),
            const SizedBox(height: 24),
          ],

          if (resume.skills.isNotEmpty) ...[
            _buildSectionTitle(Icons.stars, 'Skills', theme),
            const SizedBox(height: 12),
            _buildSkills(theme),
            const SizedBox(height: 24),
          ],

          if (resume.languages.isNotEmpty) ...[
            _buildSectionTitle(Icons.language, 'Languages', theme),
            const SizedBox(height: 12),
            _buildLanguages(theme),
            const SizedBox(height: 24),
          ],

          ...resume.customSections.map((section) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle(Icons.add_box, section.title, theme),
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
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor, accentColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            resume.personalInfo.fullName,
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 20,
            runSpacing: 12,
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
      ),
    );
  }

  Widget _buildHeaderContact(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: Colors.white),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            fontSize: resume.fontSize,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(IconData icon, String title, ThemeData theme) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryColor, accentColor],
            ),
            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
          ),
          child: Icon(icon, size: 20, color: Colors.white),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: resume.fontSize + 6,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        border: Border.all(color: primaryColor.withOpacity(0.2)),
      ),
      child: Text(
        resume.personalInfo.profileSummary!,
        style: TextStyle(
          fontSize: resume.fontSize,
          height: 1.6,
        ),
      ),
    );
  }

  Widget _buildExperience(dynamic exp, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        border: Border.all(color: primaryColor.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                ),
                child: Icon(Icons.work_outline, color: primaryColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exp.jobTitle,
                      style: TextStyle(
                        fontSize: resume.fontSize + 2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      exp.company,
                      style: TextStyle(
                        fontSize: resume.fontSize,
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryColor.withOpacity(0.2), accentColor.withOpacity(0.2)],
                  ),
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
          if (exp.location != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  exp.location!,
                  style: TextStyle(
                    fontSize: resume.fontSize - 1,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
          if (exp.description != null && exp.description!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              exp.description!,
              style: TextStyle(fontSize: resume.fontSize, height: 1.5),
            ),
          ],
          if (exp.responsibilities.isNotEmpty) ...[
            const SizedBox(height: 12),
            ...exp.responsibilities.map((resp) => Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
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
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        border: Border.all(color: primaryColor.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
            ),
            child: Icon(Icons.school_outlined, color: accentColor, size: 20),
          ),
          const SizedBox(width: 12),
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
                    color: accentColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (edu.gpa != null) ...[
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                    ),
                    child: Text(
                      'GPA: ${edu.gpa}',
                      style: TextStyle(
                        fontSize: resume.fontSize - 1,
                        fontWeight: FontWeight.bold,
                        color: accentColor,
                      ),
                    ),
                  ),
                ],
                if (edu.achievements.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  ...edu.achievements.map((achievement) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.star, size: 14, color: accentColor),
                        const SizedBox(width: 6),
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

  Widget _buildSkills(ThemeData theme) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: resume.skills.map((skill) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                primaryColor.withOpacity(0.1),
                accentColor.withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            border: Border.all(
              color: primaryColor.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                skill.name,
                style: TextStyle(
                  fontSize: resume.fontSize,
                  fontWeight: FontWeight.w600,
                  color: primaryColor,
                ),
              ),
              const SizedBox(width: 8),
              ...List.generate(
                (skill.proficiency.value * 5 / 100).round(),
                (index) => Icon(Icons.star, size: 12, color: accentColor),
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
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryColor, accentColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                lang.name,
                style: TextStyle(
                  fontSize: resume.fontSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                lang.proficiency.displayName,
                style: TextStyle(
                  fontSize: resume.fontSize - 2,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCustomItem(dynamic item, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        border: Border.all(color: primaryColor.withOpacity(0.2)),
      ),
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
              padding: const EdgeInsets.only(left: 8, bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: accentColor,
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
    );
  }
}
