import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../providers/resume_provider.dart';
import '../models/language.dart' as lang;
import '../theme/app_theme.dart';

class LanguagesEditorScreen extends StatelessWidget {
  const LanguagesEditorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final resumeProvider = context.watch<ResumeProvider>();
    final languages = resumeProvider.currentResume?.languages ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Languages'),
      ),
      body: languages.isEmpty
          ? _EmptyState(
              onAdd: () => _showLanguageDialog(context, null),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(AppTheme.space16),
              itemCount: languages.length,
              itemBuilder: (context, index) {
                final language = languages[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: AppTheme.space12),
                  child: ListTile(
                    leading: const Icon(Icons.language),
                    title: Text(language.name),
                    subtitle: Text(language.proficiency.displayName),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppTheme.space8,
                            vertical: AppTheme.space4,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                          ),
                          child: Text(
                            language.proficiency.shortName,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _showLanguageDialog(context, language),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _confirmDelete(context, language.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showLanguageDialog(context, null),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, lang.Language? language) {
    showDialog(
      context: context,
      builder: (context) => _LanguageDialog(language: language),
    );
  }

  void _confirmDelete(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Language'),
        content: const Text('Are you sure you want to delete this language?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<ResumeProvider>().deleteLanguage(id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onAdd;

  const _EmptyState({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.translate,
            size: 80,
            color: theme.colorScheme.primary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: AppTheme.space16),
          Text(
            'No languages yet',
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: AppTheme.space8),
          Text(
            'Add languages you speak',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: AppTheme.space24),
          ElevatedButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add),
            label: const Text('Add Language'),
          ),
        ],
      ),
    );
  }
}

class _LanguageDialog extends StatefulWidget {
  final lang.Language? language;

  const _LanguageDialog({this.language});

  @override
  State<_LanguageDialog> createState() => _LanguageDialogState();
}

class _LanguageDialogState extends State<_LanguageDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late lang.LanguageProficiency _proficiency;

  final List<String> _commonLanguages = [
    'English',
    'Spanish',
    'French',
    'German',
    'Italian',
    'Portuguese',
    'Russian',
    'Chinese',
    'Japanese',
    'Korean',
    'Arabic',
    'Hindi',
    'Polish',
    'Turkish',
    'Dutch',
    'Swedish',
    'Norwegian',
    'Danish',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.language?.name ?? '');
    _proficiency = widget.language?.proficiency ?? lang.LanguageProficiency.b1;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text(widget.language == null ? 'Add Language' : 'Edit Language'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Language Name
              Autocomplete<String>(
                initialValue: TextEditingValue(text: _nameController.text),
                optionsBuilder: (textEditingValue) {
                  if (textEditingValue.text.isEmpty) {
                    return _commonLanguages;
                  }
                  return _commonLanguages.where((lang) {
                    return lang.toLowerCase().contains(textEditingValue.text.toLowerCase());
                  });
                },
                onSelected: (value) {
                  _nameController.text = value;
                },
                fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                  _nameController = controller;
                  return TextFormField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: const InputDecoration(
                      labelText: 'Language *',
                      hintText: 'e.g. English, Spanish',
                    ),
                    validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                    autofocus: true,
                  );
                },
              ),
              const SizedBox(height: AppTheme.space24),

              // Proficiency Level (CEFR)
              Text(
                'Proficiency Level (CEFR)',
                style: theme.textTheme.titleSmall,
              ),
              const SizedBox(height: AppTheme.space8),
              Text(
                'Common European Framework of Reference for Languages',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: AppTheme.space16),

              ...lang.LanguageProficiency.values.map((level) {
                return RadioListTile<lang.LanguageProficiency>(
                  contentPadding: EdgeInsets.zero,
                  title: Text(level.displayName),
                  value: level,
                  groupValue: _proficiency,
                  dense: true,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _proficiency = value;
                      });
                    }
                  },
                );
              }),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveLanguage,
          child: const Text('Save'),
        ),
      ],
    );
  }

  void _saveLanguage() {
    if (_formKey.currentState?.validate() ?? false) {
      final language = lang.Language(
        id: widget.language?.id ?? const Uuid().v4(),
        name: _nameController.text.trim(),
        proficiency: _proficiency,
      );

      final provider = context.read<ResumeProvider>();
      if (widget.language == null) {
        provider.addLanguage(language);
      } else {
        provider.updateLanguage(language);
      }

      Navigator.pop(context);
    }
  }
}
