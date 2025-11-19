// screens/social_links_editor_screen.dart
// Editor for social media and professional links

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cv_engineer/models/social_links.dart';
import 'package:cv_engineer/providers/resume_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uuid/uuid.dart';

class SocialLinksEditorScreen extends StatefulWidget {
  const SocialLinksEditorScreen({super.key});

  @override
  State<SocialLinksEditorScreen> createState() => _SocialLinksEditorScreenState();
}

class _SocialLinksEditorScreenState extends State<SocialLinksEditorScreen> {
  final _uuid = const Uuid();

  void _addSocialLink(SocialPlatform platform) {
    final resumeProvider = context.read<ResumeProvider>();
    final currentResume = resumeProvider.currentResume;

    if (currentResume == null) return;

    final newLink = SocialLink(
      id: _uuid.v4(),
      platform: platform,
      url: '',
      displayOrder: currentResume.socialLinks.length,
    );

    final updatedLinks = [...currentResume.socialLinks, newLink];
    final updatedResume = currentResume.copyWith(
      socialLinks: updatedLinks,
      updatedAt: DateTime.now(),
    );

    resumeProvider.updateResume(updatedResume);
  }

  void _removeSocialLink(String id) {
    final resumeProvider = context.read<ResumeProvider>();
    final currentResume = resumeProvider.currentResume;

    if (currentResume == null) return;

    final updatedLinks = currentResume.socialLinks.where((link) => link.id != id).toList();
    final updatedResume = currentResume.copyWith(
      socialLinks: updatedLinks,
      updatedAt: DateTime.now(),
    );

    resumeProvider.updateResume(updatedResume);
  }

  void _updateSocialLink(SocialLink updatedLink) {
    final resumeProvider = context.read<ResumeProvider>();
    final currentResume = resumeProvider.currentResume;

    if (currentResume == null) return;

    final updatedLinks = currentResume.socialLinks.map((link) {
      return link.id == updatedLink.id ? updatedLink : link;
    }).toList();

    final updatedResume = currentResume.copyWith(
      socialLinks: updatedLinks,
      updatedAt: DateTime.now(),
    );

    resumeProvider.updateResume(updatedResume);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final resumeProvider = context.watch<ResumeProvider>();
    final currentResume = resumeProvider.currentResume;

    if (currentResume == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Social Links')),
        body: const Center(child: Text('No resume loaded')),
      );
    }

    final socialLinks = currentResume.socialLinks;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Social & Professional Links'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => _showHelpDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Info card
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info_outline, color: theme.colorScheme.primary),
                    const SizedBox(width: 8),
                    Text(
                      'Add your professional links',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'These will appear in your resume and can be scanned via QR code',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),

          // Links list
          Expanded(
            child: socialLinks.isEmpty
                ? _buildEmptyState(context)
                : ReorderableListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: socialLinks.length,
                    onReorder: (oldIndex, newIndex) {
                      // Handle reordering
                      if (oldIndex < newIndex) {
                        newIndex -= 1;
                      }
                      final updatedLinks = List<SocialLink>.from(socialLinks);
                      final item = updatedLinks.removeAt(oldIndex);
                      updatedLinks.insert(newIndex, item);

                      // Update display orders
                      for (int i = 0; i < updatedLinks.length; i++) {
                        updatedLinks[i] = updatedLinks[i].copyWith(displayOrder: i);
                      }

                      final updatedResume = currentResume.copyWith(
                        socialLinks: updatedLinks,
                        updatedAt: DateTime.now(),
                      );
                      resumeProvider.updateResume(updatedResume);
                    },
                    itemBuilder: (context, index) {
                      final link = socialLinks[index];
                      return _buildSocialLinkCard(context, link, key: ValueKey(link.id));
                    },
                  ),
          ),

          // Add button
          Container(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: () => _showAddLinkDialog(context),
              icon: const Icon(Icons.add),
              label: const Text('Add Link'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.link_off,
            size: 80,
            color: theme.colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            'No links added yet',
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Add your LinkedIn, GitHub, Portfolio and more',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialLinkCard(BuildContext context, SocialLink link, {required Key key}) {
    final theme = Theme.of(context);

    return Card(
      key: key,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(
          _getPlatformIcon(link.platform),
          color: theme.colorScheme.primary,
        ),
        title: Text(link.platform.displayName),
        subtitle: Text(
          link.url.isEmpty ? 'Not set' : link.url,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _showEditLinkDialog(context, link),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _confirmDelete(context, link),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getPlatformIcon(SocialPlatform platform) {
    switch (platform) {
      case SocialPlatform.linkedin:
        return FontAwesomeIcons.linkedin;
      case SocialPlatform.github:
        return FontAwesomeIcons.github;
      case SocialPlatform.twitter:
        return FontAwesomeIcons.twitter;
      case SocialPlatform.portfolio:
        return FontAwesomeIcons.briefcase;
      case SocialPlatform.website:
        return FontAwesomeIcons.globe;
      case SocialPlatform.behance:
        return FontAwesomeIcons.behance;
      case SocialPlatform.dribbble:
        return FontAwesomeIcons.dribbble;
      case SocialPlatform.medium:
        return FontAwesomeIcons.medium;
      case SocialPlatform.stackoverflow:
        return FontAwesomeIcons.stackOverflow;
      case SocialPlatform.youtube:
        return FontAwesomeIcons.youtube;
      case SocialPlatform.instagram:
        return FontAwesomeIcons.instagram;
      case SocialPlatform.facebook:
        return FontAwesomeIcons.facebook;
      case SocialPlatform.other:
        return Icons.link;
    }
  }

  void _showAddLinkDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Social Link'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: SocialPlatform.values.map((platform) {
              return ListTile(
                leading: Icon(_getPlatformIcon(platform)),
                title: Text(platform.displayName),
                onTap: () {
                  Navigator.of(context).pop();
                  _addSocialLink(platform);
                  // Show edit dialog immediately
                  Future.delayed(const Duration(milliseconds: 300), () {
                    final resumeProvider = context.read<ResumeProvider>();
                    final currentResume = resumeProvider.currentResume;
                    if (currentResume != null && currentResume.socialLinks.isNotEmpty) {
                      final newLink = currentResume.socialLinks.last;
                      _showEditLinkDialog(context, newLink);
                    }
                  });
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  void _showEditLinkDialog(BuildContext context, SocialLink link) {
    final controller = TextEditingController(text: link.url);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit ${link.platform.displayName}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: 'URL',
                hintText: link.platform.placeholder,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.link),
              ),
              keyboardType: TextInputType.url,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final updatedLink = link.copyWith(url: controller.text.trim());
              _updateSocialLink(updatedLink);
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, SocialLink link) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Link'),
        content: Text('Remove ${link.platform.displayName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _removeSocialLink(link.id);
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Social Links'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Add your professional online presence:'),
              SizedBox(height: 12),
              Text('• LinkedIn - Professional network'),
              Text('• GitHub - Code portfolio'),
              Text('• Portfolio - Personal website'),
              Text('• Behance/Dribbble - Design work'),
              Text('• And more...'),
              SizedBox(height: 12),
              Text('These links will:'),
              Text('✓ Appear in your resume'),
              Text('✓ Be included in QR codes'),
              Text('✓ Help recruiters find you'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}
