import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/resume_provider.dart';
import '../theme/app_theme.dart';
import '../utils/validators.dart';
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
    showDialog(
      context: context,
      builder: (context) => _PersonalInfoDialog(provider: provider),
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

class _PersonalInfoDialog extends StatefulWidget {
  final ResumeProvider provider;

  const _PersonalInfoDialog({required this.provider});

  @override
  State<_PersonalInfoDialog> createState() => _PersonalInfoDialogState();
}

class _PersonalInfoDialogState extends State<_PersonalInfoDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _summaryController;

  @override
  void initState() {
    super.initState();
    final personalInfo = widget.provider.currentResume!.personalInfo;
    _nameController = TextEditingController(text: personalInfo.fullName);
    _emailController = TextEditingController(text: personalInfo.email);
    _phoneController = TextEditingController(text: personalInfo.phone);
    _summaryController = TextEditingController(text: personalInfo.profileSummary);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _summaryController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final personalInfo = widget.provider.currentResume!.personalInfo;
      final updatedInfo = personalInfo.copyWith(
        fullName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        profileSummary: _summaryController.text.trim(),
      );
      widget.provider.updatePersonalInfo(updatedInfo);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Personal Information'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  hintText: 'John Doe',
                ),
                validator: (value) =>
                    Validators.validateRequired(value, fieldName: 'Full name'),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: AppTheme.space16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'john.doe@example.com',
                ),
                keyboardType: TextInputType.emailAddress,
                validator: Validators.validateEmail,
              ),
              const SizedBox(height: AppTheme.space16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone',
                  hintText: '+1 (555) 123-4567',
                ),
                keyboardType: TextInputType.phone,
                validator: Validators.validatePhone,
              ),
              const SizedBox(height: AppTheme.space16),
              TextFormField(
                controller: _summaryController,
                decoration: const InputDecoration(
                  labelText: 'Profile Summary',
                  hintText: 'Brief description about yourself...',
                  alignLabelWithHint: true,
                ),
                maxLines: 4,
                textCapitalization: TextCapitalization.sentences,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _save,
          child: const Text('Save'),
        ),
      ],
    );
  }
}
