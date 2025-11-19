import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/resume_provider.dart';
import '../theme/app_theme.dart';
import 'experience_editor_screen.dart';
import 'education_editor_screen.dart';
import 'skills_editor_screen.dart';
import 'languages_editor_screen.dart';
import 'custom_sections_editor_screen.dart';

class ResumeEditorScreen extends StatelessWidget {
  const ResumeEditorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final resumeProvider = context.watch<ResumeProvider>();

    if (!resumeProvider.hasCurrentResume) {
      return Scaffold(
        appBar: AppBar(title: const Text('Resume Editor')),
        body: const Center(
          child: Text('No resume selected. Please create a new resume.'),
        ),
      );
    }

    final resume = resumeProvider.currentResume!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Resume'),
        actions: [
          IconButton(
            icon: const Icon(Icons.visibility),
            onPressed: () => context.push('/preview'),
            tooltip: 'Preview',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppTheme.space16),
        children: [
          _SectionCard(
            icon: Icons.person,
            title: 'Personal Information',
            subtitle: resume.personalInfo.fullName.isNotEmpty
                ? resume.personalInfo.fullName
                : 'Add your personal info',
            onTap: () {
              _showPersonalInfoDialog(context, resumeProvider);
            },
          ),
          const SizedBox(height: AppTheme.space12),
          _SectionCard(
            icon: Icons.work,
            title: 'Experience',
            subtitle: '${resume.experiences.length} entries',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ExperienceEditorScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: AppTheme.space12),
          _SectionCard(
            icon: Icons.school,
            title: 'Education',
            subtitle: '${resume.educations.length} entries',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EducationEditorScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: AppTheme.space12),
          _SectionCard(
            icon: Icons.emoji_objects,
            title: 'Skills',
            subtitle: '${resume.skills.length} skills',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SkillsEditorScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: AppTheme.space12),
          _SectionCard(
            icon: Icons.language,
            title: 'Languages',
            subtitle: '${resume.languages.length} languages',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LanguagesEditorScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: AppTheme.space12),
          _SectionCard(
            icon: Icons.add_box,
            title: 'Custom Sections',
            subtitle: '${resume.customSections.length} sections',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CustomSectionsEditorScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: AppTheme.space32),
          OutlinedButton.icon(
            onPressed: () => context.push('/templates'),
            icon: const Icon(Icons.palette),
            label: const Text('Change Template'),
          ),
        ],
      ),
    );
  }

  void _showPersonalInfoDialog(BuildContext context, ResumeProvider provider) {
    final personalInfo = provider.currentResume!.personalInfo;
    final nameController = TextEditingController(text: personalInfo.fullName);
    final emailController = TextEditingController(text: personalInfo.email);
    final phoneController = TextEditingController(text: personalInfo.phone);
    final summaryController = TextEditingController(text: personalInfo.profileSummary);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Personal Information'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
              ),
              const SizedBox(height: AppTheme.space16),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: AppTheme.space16),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: AppTheme.space16),
              TextField(
                controller: summaryController,
                decoration: const InputDecoration(labelText: 'Profile Summary'),
                maxLines: 4,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final updatedInfo = personalInfo.copyWith(
                fullName: nameController.text,
                email: emailController.text,
                phone: phoneController.text,
                profileSummary: summaryController.text,
              );
              provider.updatePersonalInfo(updatedInfo);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SectionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: ListTile(
        leading: Icon(icon, color: theme.colorScheme.primary),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
