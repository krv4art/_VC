import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../providers/resume_provider.dart';
import '../models/experience.dart';
import '../theme/app_theme.dart';

class ExperienceEditorScreen extends StatelessWidget {
  const ExperienceEditorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final resumeProvider = context.watch<ResumeProvider>();
    final experiences = resumeProvider.currentResume?.experiences ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Work Experience'),
      ),
      body: experiences.isEmpty
          ? _EmptyState(
              onAdd: () => _showExperienceDialog(context, null),
            )
          : ReorderableListView.builder(
              padding: const EdgeInsets.all(AppTheme.space16),
              itemCount: experiences.length,
              onReorder: (oldIndex, newIndex) {
                resumeProvider.reorderExperiences(oldIndex, newIndex);
              },
              itemBuilder: (context, index) {
                final exp = experiences[index];
                return Card(
                  key: ValueKey(exp.id),
                  margin: const EdgeInsets.only(bottom: AppTheme.space12),
                  child: ListTile(
                    leading: const Icon(Icons.work),
                    title: Text(exp.jobTitle),
                    subtitle: Text('${exp.company} • ${exp.getDuration()}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _showExperienceDialog(context, exp),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _confirmDelete(context, exp.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showExperienceDialog(context, null),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showExperienceDialog(BuildContext context, Experience? experience) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _ExperienceFormScreen(experience: experience),
      ),
    );
  }

  void _confirmDelete(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Experience'),
        content: const Text('Are you sure you want to delete this experience?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<ResumeProvider>().deleteExperience(id);
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
            Icons.work_outline,
            size: 80,
            color: theme.colorScheme.primary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: AppTheme.space16),
          Text(
            'No work experience yet',
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: AppTheme.space8),
          Text(
            'Add your work experience to get started',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: AppTheme.space24),
          ElevatedButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add),
            label: const Text('Add Experience'),
          ),
        ],
      ),
    );
  }
}

class _ExperienceFormScreen extends StatefulWidget {
  final Experience? experience;

  const _ExperienceFormScreen({this.experience});

  @override
  State<_ExperienceFormScreen> createState() => _ExperienceFormScreenState();
}

class _ExperienceFormScreenState extends State<_ExperienceFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _jobTitleController;
  late TextEditingController _companyController;
  late TextEditingController _locationController;
  late TextEditingController _descriptionController;
  late List<TextEditingController> _responsibilityControllers;
  late DateTime _startDate;
  DateTime? _endDate;
  bool _isCurrentJob = false;

  @override
  void initState() {
    super.initState();
    _jobTitleController = TextEditingController(text: widget.experience?.jobTitle ?? '');
    _companyController = TextEditingController(text: widget.experience?.company ?? '');
    _locationController = TextEditingController(text: widget.experience?.location ?? '');
    _descriptionController = TextEditingController(text: widget.experience?.description ?? '');
    _startDate = widget.experience?.startDate ?? DateTime.now();
    _endDate = widget.experience?.endDate;
    _isCurrentJob = widget.experience?.isCurrentJob ?? false;

    _responsibilityControllers = (widget.experience?.responsibilities ?? [''])
        .map((r) => TextEditingController(text: r))
        .toList();
  }

  @override
  void dispose() {
    _jobTitleController.dispose();
    _companyController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    for (var controller in _responsibilityControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.experience == null ? 'Add Experience' : 'Edit Experience'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveExperience,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppTheme.space16),
          children: [
            // Job Title
            TextFormField(
              controller: _jobTitleController,
              decoration: const InputDecoration(
                labelText: 'Job Title *',
                hintText: 'e.g. Software Engineer',
              ),
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: AppTheme.space16),

            // Company
            TextFormField(
              controller: _companyController,
              decoration: const InputDecoration(
                labelText: 'Company *',
                hintText: 'e.g. Google',
              ),
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: AppTheme.space16),

            // Location
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Location',
                hintText: 'e.g. San Francisco, CA',
              ),
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

            // Current Job Switch
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('I currently work here'),
              value: _isCurrentJob,
              onChanged: (value) {
                setState(() {
                  _isCurrentJob = value;
                  if (value) {
                    _endDate = null;
                  }
                });
              },
            ),

            // End Date
            if (!_isCurrentJob)
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
                hintText: 'Brief description of your role',
                alignLabelWithHint: true,
              ),
              maxLines: 3,
            ),
            const SizedBox(height: AppTheme.space24),

            // Responsibilities
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Key Responsibilities',
                  style: theme.textTheme.titleMedium,
                ),
                TextButton.icon(
                  onPressed: _addResponsibility,
                  icon: const Icon(Icons.add),
                  label: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.space8),

            ..._responsibilityControllers.asMap().entries.map((entry) {
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
                          hintText: 'Responsibility ${index + 1}',
                          prefixIcon: const Icon(Icons.check_circle_outline),
                        ),
                        maxLines: 2,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _removeResponsibility(index),
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
      lastDate: DateTime.now(),
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

  void _addResponsibility() {
    setState(() {
      _responsibilityControllers.add(TextEditingController());
    });
  }

  void _removeResponsibility(int index) {
    setState(() {
      _responsibilityControllers[index].dispose();
      _responsibilityControllers.removeAt(index);
    });
  }

  void _saveExperience() {
    if (_formKey.currentState?.validate() ?? false) {
      final responsibilities = _responsibilityControllers
          .map((c) => c.text.trim())
          .where((text) => text.isNotEmpty)
          .toList();

      final experience = Experience(
        id: widget.experience?.id ?? const Uuid().v4(),
        jobTitle: _jobTitleController.text.trim(),
        company: _companyController.text.trim(),
        location: _locationController.text.trim().isEmpty
            ? null
            : _locationController.text.trim(),
        startDate: _startDate,
        endDate: _endDate,
        isCurrentJob: _isCurrentJob,
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        responsibilities: responsibilities,
      );

      final provider = context.read<ResumeProvider>();
      if (widget.experience == null) {
        provider.addExperience(experience);
      } else {
        provider.updateExperience(experience);
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
