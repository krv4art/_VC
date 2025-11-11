import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../flutter_gen/gen_l10n/app_localizations.dart';
import '../providers/identification_provider.dart';
import '../constants/app_dimensions.dart';
import '../theme/app_theme.dart';
import 'fish_result_screen.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final identificationProvider = context.watch<IdentificationProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.historyTitle),
      ),
      body: identificationProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : identificationProvider.identifications.isEmpty
              ? _buildEmptyState(l10n)
              : _buildHistoryList(
                  context,
                  identificationProvider.identifications,
                ),
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.history,
            size: 80,
            color: Colors.grey,
          ),
          const SizedBox(height: AppDimensions.space16),
          Text(l10n.historyEmpty, style: AppTheme.h3),
          const SizedBox(height: AppDimensions.space8),
          Text(
            l10n.historyHint,
            style: AppTheme.body.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList(BuildContext context, List identifications) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppDimensions.space16),
      itemCount: identifications.length,
      itemBuilder: (context, index) {
        final fish = identifications[index];
        return Card(
          margin: const EdgeInsets.only(bottom: AppDimensions.space12),
          child: ListTile(
            contentPadding: const EdgeInsets.all(AppDimensions.space12),
            leading: fish.imagePath.isNotEmpty
                ? ClipRRect(
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radius8),
                    child: Image.file(
                      File(fish.imagePath),
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  )
                : const Icon(Icons.image, size: 60),
            title: Text(fish.fishName, style: AppTheme.h4),
            subtitle: Text(
              fish.scientificName,
              style: AppTheme.bodySmall.copyWith(fontStyle: FontStyle.italic),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FishResultScreen(fishId: fish.id!),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
