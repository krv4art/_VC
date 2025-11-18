import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../models/interest.dart';
import '../../providers/user_profile_provider.dart';
import '../../constants/app_constants.dart';

class InterestsSelectionScreen extends StatefulWidget {
  const InterestsSelectionScreen({super.key});

  @override
  State<InterestsSelectionScreen> createState() => _InterestsSelectionScreenState();
}

class _InterestsSelectionScreenState extends State<InterestsSelectionScreen> {
  final Set<String> _selectedInterests = {};
  List<Interest> _customInterests = [];

  @override
  void initState() {
    super.initState();
    // Load existing selections
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<UserProfileProvider>();
      setState(() {
        _selectedInterests.addAll(provider.profile.selectedInterests);
        _customInterests = List.from(provider.customInterests);
      });
    });
  }

  void _toggleInterest(String interestId) {
    setState(() {
      if (_selectedInterests.contains(interestId)) {
        _selectedInterests.remove(interestId);
      } else {
        if (_selectedInterests.length < AppConstants.maxInterestsSelection) {
          _selectedInterests.add(interestId);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('You can select up to ${AppConstants.maxInterestsSelection} interests'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    });
  }

  Future<void> _continue() async {
    final totalSelected = _selectedInterests.length +
        _customInterests.where((i) => _selectedInterests.contains(i.id)).length;

    if (totalSelected < AppConstants.minInterestsSelection) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least 1 interest'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final provider = context.read<UserProfileProvider>();

    // Save predefined interests
    final predefinedInterests = _selectedInterests
        .where((id) => !id.startsWith('custom_'))
        .toList();
    await provider.updateInterests(predefinedInterests);

    // Save custom interests
    await provider.updateCustomInterests(_customInterests);

    if (mounted) {
      context.go('/onboarding/theme');
    }
  }

  Future<void> _showAddCustomInterestDialog() async {
    final result = await showDialog<Interest>(
      context: context,
      builder: (context) => const _AddCustomInterestDialog(),
    );

    if (result != null) {
      setState(() {
        _customInterests.add(result);
        _selectedInterests.add(result.id);
      });
    }
  }

  void _removeCustomInterest(String interestId) {
    setState(() {
      _customInterests.removeWhere((i) => i.id == interestId);
      _selectedInterests.remove(interestId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Interests'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/onboarding/welcome'),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Text(
                    'What are you interested in?',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'We\'ll use these to make learning fun and relatable!\nSelect 1-${AppConstants.maxInterestsSelection} interests.',
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${_selectedInterests.length}/${AppConstants.maxInterestsSelection} selected',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Interests grid
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.1,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: Interests.all.length + _customInterests.length,
                itemBuilder: (context, index) {
                  // Show predefined interests first
                  if (index < Interests.all.length) {
                    final interest = Interests.all[index];
                    final isSelected = _selectedInterests.contains(interest.id);

                    return _InterestCard(
                      interest: interest,
                      isSelected: isSelected,
                      onTap: () => _toggleInterest(interest.id),
                    );
                  }

                  // Then show custom interests
                  final customIndex = index - Interests.all.length;
                  final interest = _customInterests[customIndex];
                  final isSelected = _selectedInterests.contains(interest.id);

                  return _InterestCard(
                    interest: interest,
                    isSelected: isSelected,
                    onTap: () => _toggleInterest(interest.id),
                    isCustom: true,
                    onDelete: () => _removeCustomInterest(interest.id),
                  );
                },
              ),
            ),

            // Add custom interest button
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
              child: OutlinedButton.icon(
                onPressed: _showAddCustomInterestDialog,
                icon: const Icon(Icons.add_circle_outline),
                label: const Text('Add Your Own Interest'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  minimumSize: const Size.fromHeight(56),
                ),
              ),
            ),

            // Continue button
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: ElevatedButton(
                onPressed: _selectedInterests.isNotEmpty ? _continue : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  minimumSize: const Size.fromHeight(56),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InterestCard extends StatelessWidget {
  final Interest interest;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isCustom;
  final VoidCallback? onDelete;

  const _InterestCard({
    required this.interest,
    required this.isSelected,
    required this.onTap,
    this.isCustom = false,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primary.withOpacity(0.2)
              : colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? colorScheme.primary : colorScheme.outline.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Stack(
          children: [
            // Content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    interest.emoji,
                    style: const TextStyle(fontSize: 48),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    interest.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? colorScheme.primary : null,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Checkmark
            if (isSelected)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check,
                    size: 16,
                    color: colorScheme.onPrimary,
                  ),
                ),
              ),

            // Delete button for custom interests
            if (isCustom && onDelete != null)
              Positioned(
                top: 8,
                left: 8,
                child: GestureDetector(
                  onTap: () {
                    // Stop propagation to card
                    onDelete!();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: colorScheme.error,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      size: 16,
                      color: colorScheme.onError,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _AddCustomInterestDialog extends StatefulWidget {
  const _AddCustomInterestDialog();

  @override
  State<_AddCustomInterestDialog> createState() => _AddCustomInterestDialogState();
}

class _AddCustomInterestDialogState extends State<_AddCustomInterestDialog> {
  final _nameController = TextEditingController();
  final _keywordsController = TextEditingController();
  String _selectedEmoji = '⭐';

  final List<String> _emojiOptions = [
    '⭐', '🎯', '🚀', '💎', '🎨', '🎵', '🏆', '🌟',
    '🎭', '🎪', '🎸', '🎹', '🎬', '📸', '🏀', '⚽',
    '🏐', '🎾', '🏈', '🏉', '🎱', '🏓', '🏸', '🥊',
    '🚗', '✈️', '🚁', '🚂', '🚢', '🏰', '🗿', '🎡',
    '🦖', '🦕', '🐉', '🦄', '🐺', '🦁', '🦅', '🦋',
    '🌈', '⚡', '🔥', '💧', '🌊', '🌙', '☀️', '⛄',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _keywordsController.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _nameController.text.trim();
    final keywordsText = _keywordsController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a name for your interest'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (keywordsText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter at least one keyword'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Parse keywords (comma or space separated)
    final keywords = keywordsText
        .split(RegExp(r'[,\s]+'))
        .where((k) => k.isNotEmpty)
        .toList();

    if (keywords.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter valid keywords'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Create custom interest
    final customInterest = Interest.custom(
      name: name,
      emoji: _selectedEmoji,
      keywords: keywords,
    );

    Navigator.of(context).pop(customInterest);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AlertDialog(
      title: const Text('Add Your Own Interest'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Emoji selector
            Text(
              'Choose an emoji',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              height: 120,
              decoration: BoxDecoration(
                border: Border.all(color: colorScheme.outline.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                ),
                itemCount: _emojiOptions.length,
                itemBuilder: (context, index) {
                  final emoji = _emojiOptions[index];
                  final isSelected = emoji == _selectedEmoji;

                  return GestureDetector(
                    onTap: () => setState(() => _selectedEmoji = emoji),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? colorScheme.primary.withOpacity(0.2)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: isSelected
                            ? Border.all(color: colorScheme.primary, width: 2)
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        emoji,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // Name field
            Text(
              'Interest name',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'e.g., LEGO, Dinosaurs, Dancing',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 20),

            // Keywords field
            Text(
              'Keywords (for AI personalization)',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Separate with commas or spaces',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _keywordsController,
              decoration: InputDecoration(
                hintText: 'e.g., blocks, build, bricks, pieces',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: colorScheme.primary.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    size: 20,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'AI will use these keywords to create personalized examples in all lessons!',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Add Interest'),
        ),
      ],
    );
  }
}
