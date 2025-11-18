import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../providers/resume_provider.dart';
import '../models/education.dart';
import '../theme/app_theme.dart';

class EducationEditorScreen extends StatelessWidget {
  const EducationEditorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final resumeProvider = context.watch<ResumeProvider>();
    final educations = resumeProvider.currentResume?.educations ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Education'),
      ),
      body: educations.isEmpty
          ? _EmptyState(
              onAdd: () => _showEducationDialog(context, null),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(AppTheme.space16),
              itemCount: educations.length,
              itemBuilder: (context, index) {
                final edu = educations[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: AppTheme.space12),
                  child: ListTile(
                    leading: const Icon(Icons.school),
                    title: Text(edu.degree),
                    subtitle: Text(edu.institution),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _showEducationDialog(context, edu),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _confirmDelete(context, edu.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showEducationDialog(context, null),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showEducationDialog(BuildContext context, Education? education) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _EducationFormScreen(education: education),
      ),
    );
  }

  void _confirmDelete(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Education'),
        content: const Text('Are you sure you want to delete this education entry?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<ResumeProvider>().deleteEducation(id);
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
            Icons.school_outlined,
            size: 80,
            color: theme.colorScheme.primary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: AppTheme.space16),
          Text(
            'No education yet',
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: AppTheme.space8),
          Text(
            'Add your education to get started',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: AppTheme.space24),
          ElevatedButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add),
            label: const Text('Add Education'),
          ),
        ],
      ),
    );
  }
}

class _EducationFormScreen extends StatefulWidget {
  final Education? education;

  const _EducationFormScreen({this.education});

  @override
  State<_EducationFormScreen> createState() => _EducationFormScreenState();
}

class _EducationFormScreenState extends State<_EducationFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _degreeController;
  late TextEditingController _institutionController;
  late TextEditingController _locationController;
  late TextEditingController _gpaController;
  late TextEditingController _descriptionController;
  late List<TextEditingController> _achievementControllers;
  late DateTime _startDate;
  DateTime? _endDate;
  bool _isCurrent = false;

  @override
  void initState() {
    super.initState();
    _degreeController = TextEditingController(text: widget.education?.degree ?? '');
    _institutionController = TextEditingController(text: widget.education?.institution ?? '');
    _locationController = TextEditingController(text: widget.education?.location ?? '');
    _gpaController = TextEditingController(text: widget.education?.gpa ?? '');
    _descriptionController = TextEditingController(text: widget.education?.description ?? '');
    _startDate = widget.education?.startDate ?? DateTime.now();
    _endDate = widget.education?.endDate;
    _isCurrent = widget.education?.isCurrent ?? false;

    _achievementControllers = (widget.education?.achievements ?? [''])
        .map((a) => TextEditingController(text: a))
        .toList();
  }

  @override
  void dispose() {
    _degreeController.dispose();
    _institutionController.dispose();
    _locationController.dispose();
    _gpaController.dispose();
    _descriptionController.dispose();
    for (var controller in _achievementControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.education == null ? 'Add Education' : 'Edit Education'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveEducation,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppTheme.space16),
          children: [
            // Degree
            TextFormField(
              controller: _degreeController,
              decoration: const InputDecoration(
                labelText: 'Degree *',
                hintText: 'e.g. Bachelor of Science in Computer Science',
              ),
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: AppTheme.space16),

            // Institution
            TextFormField(
              controller: _institutionController,
              decoration: const InputDecoration(
                labelText: 'Institution *',
                hintText: 'e.g. Stanford University',
              ),
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: AppTheme.space16),

            // Location
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Location',
                hintText: 'e.g. Stanford, CA',
              ),
            ),
            const SizedBox(height: AppTheme.space16),

            // GPA
            TextFormField(
              controller: _gpaController,
              decoration: const InputDecoration(
                labelText: 'GPA (Optional)',
                hintText: 'e.g. 3.8/4.0',
              ),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: AppTheme.space16),

            // Start Date
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today),
              title: const Text('Start Date'),
              subtitle: Text(_formatDate(_startDate)),
              onTap: () => _selectDate(context, true),
            ),

            // Current Switch
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('I currently study here'),
              value: _isCurrent,
              onChanged: (value) {
                setState(() {
                  _isCurrent = value;
                  if (value) {
                    _endDate = null;
                  }
                });
              },
            ),

            // End Date
            if (!_isCurrent)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.calendar_today),
                title: const Text('End Date'),
                subtitle: Text(_endDate != null ? _formatDate(_endDate!) : 'Not set'),
                onTap: () => _selectDate(context, false),
              ),

            const SizedBox(height: AppTheme.space16),

            // Description
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Additional information about your studies',
                alignLabelWithHint: true,
              ),
              maxLines: 3,
            ),
            const SizedBox(height: AppTheme.space24),

            // Achievements
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Achievements & Honors',
                  style: theme.textTheme.titleMedium,
                ),
                TextButton.icon(
                  onPressed: _addAchievement,
                  icon: const Icon(Icons.add),
                  label: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.space8),

            ..._achievementControllers.asMap().entries.map((entry) {
              final index = entry.key;
              final controller = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: AppTheme.space8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: controller,
                        decoration: InputDecoration(
                          hintText: 'Achievement ${index + 1}',
                          prefixIcon: const Icon(Icons.star_outline),
                        ),
                        maxLines: 2,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _removeAchievement(index),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final date = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : (_endDate ?? DateTime.now()),
      firstDate: DateTime(1950),
      lastDate: DateTime.now().add(const Duration(days: 3650)), // +10 years for future graduation
    );

    if (date != null) {
      setState(() {
        if (isStartDate) {
          _startDate = date;
        } else {
          _endDate = date;
        }
      });
    }
  }

  void _addAchievement() {
    setState(() {
      _achievementControllers.add(TextEditingController());
    });
  }

  void _removeAchievement(int index) {
    setState(() {
      _achievementControllers[index].dispose();
      _achievementControllers.removeAt(index);
    });
  }

  void _saveEducation() {
    if (_formKey.currentState?.validate() ?? false) {
      final achievements = _achievementControllers
          .map((c) => c.text.trim())
          .where((text) => text.isNotEmpty)
          .toList();

      final education = Education(
        id: widget.education?.id ?? const Uuid().v4(),
        degree: _degreeController.text.trim(),
        institution: _institutionController.text.trim(),
        location: _locationController.text.trim().isEmpty
            ? null
            : _locationController.text.trim(),
        startDate: _startDate,
        endDate: _endDate,
        isCurrent: _isCurrent,
        gpa: _gpaController.text.trim().isEmpty ? null : _gpaController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        achievements: achievements,
      );

      final provider = context.read<ResumeProvider>();
      if (widget.education == null) {
        provider.addEducation(education);
      } else {
        provider.updateEducation(education);
      }

      Navigator.pop(context);
    }
  }

  String _formatDate(DateTime date) {
    return '${_getMonthName(date.month)} ${date.year}';
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }
}
