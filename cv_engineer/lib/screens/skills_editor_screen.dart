import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../providers/resume_provider.dart';
import '../models/skill.dart';
import '../theme/app_theme.dart';
import '../utils/common_skills.dart';

class SkillsEditorScreen extends StatelessWidget {
  const SkillsEditorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final resumeProvider = context.watch<ResumeProvider>();
    final skills = resumeProvider.currentResume?.skills ?? [];

    // Group skills by category
    final Map<String, List<Skill>> groupedSkills = {};
    for (var skill in skills) {
      groupedSkills.putIfAbsent(skill.category, () => []).add(skill);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Skills'),
      ),
      body: skills.isEmpty
          ? _EmptyState(
              onAdd: () => _showSkillDialog(context, null),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(AppTheme.space16),
              itemCount: groupedSkills.length,
              itemBuilder: (context, index) {
                final category = groupedSkills.keys.elementAt(index);
                final categorySkills = groupedSkills[category]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: AppTheme.space8),
                      child: Text(
                        category,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    Wrap(
                      spacing: AppTheme.space8,
                      runSpacing: AppTheme.space8,
                      children: categorySkills.map((skill) {
                        return _SkillChip(
                          skill: skill,
                          onTap: () => _showSkillDialog(context, skill),
                          onDelete: () => _confirmDelete(context, skill.id),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: AppTheme.space16),
                  ],
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showSkillDialog(context, null),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showSkillDialog(BuildContext context, Skill? skill) {
    showDialog(
      context: context,
      builder: (context) => _SkillDialog(skill: skill),
    );
  }

  void _confirmDelete(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Skill'),
        content: const Text('Are you sure you want to delete this skill?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<ResumeProvider>().deleteSkill(id);
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
            Icons.emoji_objects_outlined,
            size: 80,
            color: theme.colorScheme.primary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: AppTheme.space16),
          Text(
            'No skills yet',
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: AppTheme.space8),
          Text(
            'Add your skills to get started',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: AppTheme.space24),
          ElevatedButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add),
            label: const Text('Add Skill'),
          ),
        ],
      ),
    );
  }
}

class _SkillChip extends StatelessWidget {
  final Skill skill;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _SkillChip({
    required this.skill,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ActionChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(skill.name),
          const SizedBox(width: AppTheme.space4),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(2),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: skill.level.percentage,
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ],
      ),
      onPressed: onTap,
      deleteIcon: const Icon(Icons.close, size: 18),
      onDeleted: onDelete,
    );
  }
}

class _SkillDialog extends StatefulWidget {
  final Skill? skill;

  const _SkillDialog({this.skill});

  @override
  State<_SkillDialog> createState() => _SkillDialogState();
}

class _SkillDialogState extends State<_SkillDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _categoryController;
  late SkillLevel _level;

  final List<String> _categoryPresets = [
    'Technical Skills',
    'Programming Languages',
    'Frameworks & Libraries',
    'Tools & Platforms',
    'Soft Skills',
    'Languages',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.skill?.name ?? '');
    _categoryController = TextEditingController(text: widget.skill?.category ?? 'Technical Skills');
    _level = widget.skill?.level ?? SkillLevel.intermediate;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text(widget.skill == null ? 'Add Skill' : 'Edit Skill'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Skill Name with Autocomplete
              Autocomplete<String>(
                initialValue: TextEditingValue(text: _nameController.text),
                optionsBuilder: (textEditingValue) {
                  if (textEditingValue.text.isEmpty) {
                    return const Iterable<String>.empty();
                  }
                  return CommonSkills.searchSkills(textEditingValue.text);
                },
                onSelected: (selection) {
                  _nameController.text = selection;
                },
                fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
                  // Sync with our controller
                  if (controller.text != _nameController.text) {
                    controller.text = _nameController.text;
                  }
                  return TextFormField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: const InputDecoration(
                      labelText: 'Skill Name *',
                      hintText: 'e.g. Flutter, JavaScript',
                      helperText: 'Start typing for suggestions',
                    ),
                    validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                    autofocus: true,
                    onChanged: (value) => _nameController.text = value,
                  );
                },
              ),
              const SizedBox(height: AppTheme.space16),

              // Category
              DropdownButtonFormField<String>(
                value: _categoryController.text,
                decoration: const InputDecoration(
                  labelText: 'Category',
                ),
                items: _categoryPresets.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    _categoryController.text = value;
                  }
                },
              ),
              const SizedBox(height: AppTheme.space16),

              // Proficiency Level
              Text(
                'Proficiency Level',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: AppTheme.space8),
              ...SkillLevel.values.map((level) {
                return RadioListTile<SkillLevel>(
                  contentPadding: EdgeInsets.zero,
                  title: Row(
                    children: [
                      Text(level.displayName),
                      const SizedBox(width: AppTheme.space8),
                      Expanded(
                        child: LinearProgressIndicator(
                          value: level.percentage,
                          backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.2),
                        ),
                      ),
                    ],
                  ),
                  value: level,
                  groupValue: _level,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _level = value;
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
          onPressed: _saveSkill,
          child: const Text('Save'),
        ),
      ],
    );
  }

  void _saveSkill() {
    if (_formKey.currentState?.validate() ?? false) {
      final skill = Skill(
        id: widget.skill?.id ?? const Uuid().v4(),
        name: _nameController.text.trim(),
        level: _level,
        category: _categoryController.text.trim(),
      );

      final provider = context.read<ResumeProvider>();
      if (widget.skill == null) {
        provider.addSkill(skill);
      } else {
        provider.updateSkill(skill);
      }

      Navigator.pop(context);
    }
  }
}
