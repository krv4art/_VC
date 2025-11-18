import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../providers/resume_provider.dart';
import '../models/custom_section.dart';
import '../theme/app_theme.dart';

class CustomSectionsEditorScreen extends StatelessWidget {
  const CustomSectionsEditorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final resumeProvider = context.watch<ResumeProvider>();
    final sections = resumeProvider.currentResume?.customSections ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Sections'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => _showHelpDialog(context),
            tooltip: 'Help',
          ),
        ],
      ),
      body: sections.isEmpty
          ? _EmptyState(
              onAdd: () => _showSectionDialog(context, null),
            )
          : ReorderableListView.builder(
              padding: const EdgeInsets.all(AppTheme.space16),
              itemCount: sections.length,
              onReorder: (oldIndex, newIndex) {
                // TODO: Implement reordering
              },
              itemBuilder: (context, index) {
                final section = sections[index];
                return Card(
                  key: ValueKey(section.id),
                  margin: const EdgeInsets.only(bottom: AppTheme.space12),
                  child: ExpansionTile(
                    leading: const Icon(Icons.reorder),
                    title: Text(section.title),
                    subtitle: Text('${section.items.length} items'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _showSectionDialog(context, section),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _confirmDeleteSection(context, section.id),
                        ),
                      ],
                    ),
                    children: section.items.map((item) {
                      return ListTile(
                        title: Text(item.title),
                        subtitle: item.subtitle != null ? Text(item.subtitle!) : null,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, size: 20),
                              onPressed: () => _showItemDialog(context, section, item),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, size: 20),
                              onPressed: () => _confirmDeleteItem(context, section, item.id),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showSectionDialog(context, null),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Custom Sections'),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Custom sections let you add any additional information to your resume.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              Text('Examples:'),
              SizedBox(height: 8),
              Text('• Certifications'),
              Text('• Publications'),
              Text('• Projects'),
              Text('• Awards & Honors'),
              Text('• Volunteer Work'),
              Text('• Professional Memberships'),
              Text('• Conferences & Workshops'),
              Text('• Patents'),
              SizedBox(height: 12),
              Text(
                'Each section can contain multiple items with title, subtitle, description, and bullet points.',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  void _showSectionDialog(BuildContext context, CustomSection? section) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _SectionFormScreen(section: section),
      ),
    );
  }

  void _showItemDialog(BuildContext context, CustomSection section, CustomSectionItem? item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _ItemFormScreen(section: section, item: item),
      ),
    );
  }

  void _confirmDeleteSection(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Section'),
        content: const Text('Are you sure you want to delete this entire section?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<ResumeProvider>().deleteCustomSection(id);
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

  void _confirmDeleteItem(BuildContext context, CustomSection section, String itemId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item'),
        content: const Text('Are you sure you want to delete this item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final updatedItems = section.items.where((i) => i.id != itemId).toList();
              final updatedSection = section.copyWith(items: updatedItems);
              context.read<ResumeProvider>().updateCustomSection(updatedSection);
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
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.space32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_box_outlined,
              size: 80,
              color: theme.colorScheme.primary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppTheme.space16),
            Text(
              'No custom sections yet',
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: AppTheme.space8),
            Text(
              'Add sections for certifications, projects, awards, and more',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.space24),
            ElevatedButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              label: const Text('Add Custom Section'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionFormScreen extends StatefulWidget {
  final CustomSection? section;

  const _SectionFormScreen({this.section});

  @override
  State<_SectionFormScreen> createState() => _SectionFormScreenState();
}

class _SectionFormScreenState extends State<_SectionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;

  final List<String> _sectionPresets = [
    'Certifications',
    'Publications',
    'Projects',
    'Awards & Honors',
    'Volunteer Work',
    'Professional Memberships',
    'Conferences & Workshops',
    'Patents',
    'Research',
    'Teaching Experience',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.section?.title ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.section == null ? 'Add Section' : 'Edit Section'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveSection,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppTheme.space16),
          children: [
            Text(
              'Section Title',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppTheme.space8),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title *',
                hintText: 'e.g. Certifications, Projects',
              ),
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
              autofocus: widget.section == null,
            ),
            const SizedBox(height: AppTheme.space16),
            Text(
              'Common Section Types',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: AppTheme.space8),
            Wrap(
              spacing: AppTheme.space8,
              runSpacing: AppTheme.space8,
              children: _sectionPresets.map((preset) {
                return ActionChip(
                  label: Text(preset),
                  onPressed: () {
                    _titleController.text = preset;
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: AppTheme.space32),
            if (widget.section != null && widget.section!.items.isNotEmpty) ...[
              Text(
                'Items in this section',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppTheme.space8),
              Text(
                '${widget.section!.items.length} items',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
              ),
              const SizedBox(height: AppTheme.space8),
              const Text(
                'Go back to manage items in this section',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _saveSection() {
    if (_formKey.currentState?.validate() ?? false) {
      final section = CustomSection(
        id: widget.section?.id ?? const Uuid().v4(),
        title: _titleController.text.trim(),
        items: widget.section?.items ?? [],
        order: widget.section?.order ?? 0,
      );

      final provider = context.read<ResumeProvider>();
      if (widget.section == null) {
        provider.addCustomSection(section);
      } else {
        provider.updateCustomSection(section);
      }

      Navigator.pop(context);
    }
  }
}

class _ItemFormScreen extends StatefulWidget {
  final CustomSection section;
  final CustomSectionItem? item;

  const _ItemFormScreen({required this.section, this.item});

  @override
  State<_ItemFormScreen> createState() => _ItemFormScreenState();
}

class _ItemFormScreenState extends State<_ItemFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _subtitleController;
  late TextEditingController _descriptionController;
  late List<TextEditingController> _bulletPointControllers;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.item?.title ?? '');
    _subtitleController = TextEditingController(text: widget.item?.subtitle ?? '');
    _descriptionController = TextEditingController(text: widget.item?.description ?? '');
    _bulletPointControllers = (widget.item?.bulletPoints ?? [''])
        .map((bp) => TextEditingController(text: bp))
        .toList();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _descriptionController.dispose();
    for (var controller in _bulletPointControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item == null ? 'Add Item' : 'Edit Item'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveItem,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppTheme.space16),
          children: [
            // Title
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title *',
                hintText: _getTitleHint(),
              ),
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
              autofocus: widget.item == null,
            ),
            const SizedBox(height: AppTheme.space16),

            // Subtitle
            TextFormField(
              controller: _subtitleController,
              decoration: InputDecoration(
                labelText: 'Subtitle',
                hintText: _getSubtitleHint(),
              ),
            ),
            const SizedBox(height: AppTheme.space16),

            // Description
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Brief description',
                alignLabelWithHint: true,
              ),
              maxLines: 3,
            ),
            const SizedBox(height: AppTheme.space24),

            // Bullet Points
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Bullet Points', style: theme.textTheme.titleMedium),
                TextButton.icon(
                  onPressed: _addBulletPoint,
                  icon: const Icon(Icons.add),
                  label: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.space8),

            ..._bulletPointControllers.asMap().entries.map((entry) {
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
                          hintText: 'Bullet point ${index + 1}',
                          prefixIcon: const Icon(Icons.circle, size: 8),
                        ),
                        maxLines: 2,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _removeBulletPoint(index),
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

  String _getTitleHint() {
    final title = widget.section.title.toLowerCase();
    if (title.contains('certification')) return 'e.g. AWS Certified Solutions Architect';
    if (title.contains('project')) return 'e.g. E-commerce Platform';
    if (title.contains('award')) return 'e.g. Employee of the Year 2023';
    if (title.contains('publication')) return 'e.g. Article Title';
    return 'Item title';
  }

  String _getSubtitleHint() {
    final title = widget.section.title.toLowerCase();
    if (title.contains('certification')) return 'Issuing organization';
    if (title.contains('project')) return 'Technology stack or role';
    if (title.contains('award')) return 'Awarding organization';
    if (title.contains('publication')) return 'Journal or publication';
    return 'Optional subtitle';
  }

  void _addBulletPoint() {
    setState(() {
      _bulletPointControllers.add(TextEditingController());
    });
  }

  void _removeBulletPoint(int index) {
    setState(() {
      _bulletPointControllers[index].dispose();
      _bulletPointControllers.removeAt(index);
    });
  }

  void _saveItem() {
    if (_formKey.currentState?.validate() ?? false) {
      final bulletPoints = _bulletPointControllers
          .map((c) => c.text.trim())
          .where((text) => text.isNotEmpty)
          .toList();

      final item = CustomSectionItem(
        id: widget.item?.id ?? const Uuid().v4(),
        title: _titleController.text.trim(),
        subtitle: _subtitleController.text.trim().isEmpty
            ? null
            : _subtitleController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        bulletPoints: bulletPoints,
      );

      // Update section with new/updated item
      final items = List<CustomSectionItem>.from(widget.section.items);
      if (widget.item == null) {
        items.add(item);
      } else {
        final index = items.indexWhere((i) => i.id == item.id);
        if (index >= 0) {
          items[index] = item;
        }
      }

      final updatedSection = widget.section.copyWith(items: items);
      context.read<ResumeProvider>().updateCustomSection(updatedSection);

      Navigator.pop(context);
    }
  }
}
