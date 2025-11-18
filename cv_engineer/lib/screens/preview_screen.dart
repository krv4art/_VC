import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/resume_provider.dart';
import '../theme/app_theme.dart';

class PreviewScreen extends StatelessWidget {
  const PreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final resumeProvider = context.watch<ResumeProvider>();

    if (!resumeProvider.hasCurrentResume) {
      return Scaffold(
        appBar: AppBar(title: const Text('Preview')),
        body: const Center(
          child: Text('No resume to preview'),
        ),
      );
    }

    final resume = resumeProvider.currentResume!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resume Preview'),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('PDF export coming soon')),
              );
            },
            tooltip: 'Export PDF',
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Share coming soon')),
              );
            },
            tooltip: 'Share',
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[300],
        child: Center(
          child: Container(
            width: 600,
            constraints: const BoxConstraints(maxHeight: 800),
            margin: const EdgeInsets.all(AppTheme.space16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [AppTheme.strongShadow],
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(resume.marginSize),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header - Personal Info
                  Text(
                    resume.personalInfo.fullName,
                    style: TextStyle(
                      fontSize: resume.fontSize + 8,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: AppTheme.space8),
                  Row(
                    children: [
                      if (resume.personalInfo.email.isNotEmpty) ...[
                        Icon(Icons.email, size: resume.fontSize, color: Colors.grey),
                        SizedBox(width: AppTheme.space4),
                        Text(resume.personalInfo.email, style: TextStyle(fontSize: resume.fontSize)),
                        SizedBox(width: AppTheme.space16),
                      ],
                      if (resume.personalInfo.phone.isNotEmpty) ...[
                        Icon(Icons.phone, size: resume.fontSize, color: Colors.grey),
                        SizedBox(width: AppTheme.space4),
                        Text(resume.personalInfo.phone, style: TextStyle(fontSize: resume.fontSize)),
                      ],
                    ],
                  ),

                  // Profile Summary
                  if (resume.personalInfo.profileSummary != null &&
                      resume.personalInfo.profileSummary!.isNotEmpty) ...[
                    const SizedBox(height: AppTheme.space24),
                    Text(
                      'Professional Summary',
                      style: TextStyle(
                        fontSize: resume.fontSize + 4,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const Divider(),
                    Text(
                      resume.personalInfo.profileSummary!,
                      style: TextStyle(fontSize: resume.fontSize),
                    ),
                  ],

                  // Experience
                  if (resume.experiences.isNotEmpty) ...[
                    const SizedBox(height: AppTheme.space24),
                    Text(
                      'Experience',
                      style: TextStyle(
                        fontSize: resume.fontSize + 4,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const Divider(),
                    ...resume.experiences.map((exp) => Padding(
                          padding: const EdgeInsets.only(bottom: AppTheme.space16),
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
                              Text(
                                '${exp.company} • ${exp.getDuration()}',
                                style: TextStyle(
                                  fontSize: resume.fontSize,
                                  color: Colors.grey[700],
                                ),
                              ),
                              if (exp.description != null) ...[
                                SizedBox(height: AppTheme.space8),
                                Text(
                                  exp.description!,
                                  style: TextStyle(fontSize: resume.fontSize),
                                ),
                              ],
                            ],
                          ),
                        )),
                  ],

                  // Education
                  if (resume.educations.isNotEmpty) ...[
                    const SizedBox(height: AppTheme.space24),
                    Text(
                      'Education',
                      style: TextStyle(
                        fontSize: resume.fontSize + 4,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const Divider(),
                    ...resume.educations.map((edu) => Padding(
                          padding: const EdgeInsets.only(bottom: AppTheme.space16),
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
                              Text(
                                edu.institution,
                                style: TextStyle(
                                  fontSize: resume.fontSize,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],

                  // Skills
                  if (resume.skills.isNotEmpty) ...[
                    const SizedBox(height: AppTheme.space24),
                    Text(
                      'Skills',
                      style: TextStyle(
                        fontSize: resume.fontSize + 4,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const Divider(),
                    Wrap(
                      spacing: AppTheme.space8,
                      runSpacing: AppTheme.space8,
                      children: resume.skills
                          .map((skill) => Chip(
                                label: Text(
                                  skill.name,
                                  style: TextStyle(fontSize: resume.fontSize - 1),
                                ),
                              ))
                          .toList(),
                    ),
                  ],

                  // Languages
                  if (resume.languages.isNotEmpty) ...[
                    const SizedBox(height: AppTheme.space24),
                    Text(
                      'Languages',
                      style: TextStyle(
                        fontSize: resume.fontSize + 4,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const Divider(),
                    ...resume.languages.map((lang) => Padding(
                          padding: const EdgeInsets.only(bottom: AppTheme.space8),
                          child: Row(
                            children: [
                              Text(
                                lang.name,
                                style: TextStyle(
                                  fontSize: resume.fontSize,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                ' - ${lang.proficiency.displayName}',
                                style: TextStyle(
                                  fontSize: resume.fontSize,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
