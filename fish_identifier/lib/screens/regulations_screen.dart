import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/regulations_provider.dart';
import '../flutter_gen/gen_l10n/app_localizations.dart';

/// Screen for fishing regulations and compliance checking
class RegulationsScreen extends StatefulWidget {
  const RegulationsScreen({super.key});

  @override
  State<RegulationsScreen> createState() => _RegulationsScreenState();
}

class _RegulationsScreenState extends State<RegulationsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _lengthController = TextEditingController();
  String _selectedRegion = 'USA';

  @override
  void initState() {
    super.initState();
    _loadRegulations();
  }

  Future<void> _loadRegulations() async {
    await context.read<RegulationsProvider>().loadRegulationsForRegion(_selectedRegion);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tabRegulations ?? 'Regulations'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _showSearchDialog,
          ),
        ],
      ),
      body: Consumer<RegulationsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Region selector
              _buildRegionSelector(),
              const SizedBox(height: 16),

              // Compliance checker
              _buildComplianceChecker(provider),
              const SizedBox(height: 16),

              // Regulations list
              if (provider.regulations.isNotEmpty)
                ...provider.regulations.map((reg) => Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        title: Text(reg.speciesName),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (reg.minSize != null)
                              Text('Min: ${reg.minSize}cm'),
                            if (reg.bagLimit != null)
                              Text('Bag limit: ${reg.bagLimit}'),
                          ],
                        ),
                        trailing: Icon(
                          reg.licenseRequired ? Icons.card_membership : Icons.check_circle,
                          color: reg.licenseRequired ? Colors.orange : Colors.green,
                        ),
                        onTap: () => _showRegulationDetails(reg),
                      ),
                    ))
              else
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Text('No regulations found for this region'),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildRegionSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select Region', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButton<String>(
              value: _selectedRegion,
              isExpanded: true,
              items: ['USA', 'Canada', 'Europe', 'Australia']
                  .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedRegion = value);
                  _loadRegulations();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComplianceChecker(RegulationsProvider provider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Check Compliance', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            TextField(
              controller: _lengthController,
              decoration: const InputDecoration(
                labelText: 'Fish Length (cm)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                final length = double.tryParse(_lengthController.text);
                if (length != null && provider.currentRegulation != null) {
                  await provider.checkCompliance(
                    speciesName: provider.currentRegulation!.speciesName,
                    fishLength: length,
                    region: _selectedRegion,
                  );
                  _showComplianceResult();
                }
              },
              child: const Text('Check'),
            ),
          ],
        ),
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Regulations'),
        content: TextField(
          controller: _searchController,
          decoration: const InputDecoration(hintText: 'Enter species name'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Perform search
            },
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  void _showRegulationDetails(regulation) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(regulation.speciesName),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (regulation.scientificName.isNotEmpty)
                Text('Scientific: ${regulation.scientificName}', style: const TextStyle(fontStyle: FontStyle.italic)),
              const Divider(),
              if (regulation.minSize != null) Text('Minimum size: ${regulation.minSize}cm'),
              if (regulation.maxSize != null) Text('Maximum size: ${regulation.maxSize}cm'),
              if (regulation.bagLimit != null) Text('Bag limit: ${regulation.bagLimit} per day'),
              if (regulation.possessionLimit != null) Text('Possession limit: ${regulation.possessionLimit}'),
              const SizedBox(height: 8),
              Text('License required: ${regulation.licenseRequired ? "Yes" : "No"}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showComplianceResult() {
    final compliance = context.read<RegulationsProvider>().lastComplianceCheck;
    if (compliance == null) return;

    final icon = context.read<RegulationsProvider>().getComplianceIcon(compliance);
    final color = context.read<RegulationsProvider>().getComplianceColor(compliance);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 32)),
            const SizedBox(width: 8),
            Text(compliance.canKeep ? 'Legal to Keep' : 'Must Release'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (compliance.violations.isNotEmpty) ...[
              const Text('Violations:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
              ...compliance.violations.map((v) => Text('• $v')),
            ],
            if (compliance.warnings.isNotEmpty) ...[
              const SizedBox(height: 8),
              const Text('Warnings:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
              ...compliance.warnings.map((w) => Text('• $w')),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
