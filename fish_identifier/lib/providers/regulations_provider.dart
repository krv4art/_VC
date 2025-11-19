import 'package:flutter/foundation.dart';
import '../models/fishing_regulation.dart';
import '../services/regulations_service.dart';

/// Provider for fishing regulations
class RegulationsProvider extends ChangeNotifier {
  List<FishingRegulation> _regulations = [];
  FishingRegulation? _currentRegulation;
  RegulationCompliance? _lastComplianceCheck;
  bool _isLoading = false;
  String? _error;
  String? _currentRegion;

  // Getters
  List<FishingRegulation> get regulations => _regulations;
  FishingRegulation? get currentRegulation => _currentRegulation;
  RegulationCompliance? get lastComplianceCheck => _lastComplianceCheck;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get currentRegion => _currentRegion;

  /// Load regulations for a region
  Future<void> loadRegulationsForRegion(String region) async {
    _isLoading = true;
    _error = null;
    _currentRegion = region;
    notifyListeners();

    try {
      _regulations =
          await RegulationsService.instance.getRegulationsForRegion(region);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      debugPrint('Error loading regulations: $e');
    }
  }

  /// Get regulation for specific species
  Future<void> loadRegulation({
    required String speciesName,
    required String region,
    String? subRegion,
  }) async {
    try {
      _currentRegulation = await RegulationsService.instance.getRegulation(
        speciesName: speciesName,
        region: region,
        subRegion: subRegion,
      );
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading regulation: $e');
    }
  }

  /// Check if fish meets regulations
  Future<RegulationCompliance> checkCompliance({
    required String speciesName,
    required double fishLength,
    required String region,
    String? subRegion,
    DateTime? catchDate,
  }) async {
    try {
      _lastComplianceCheck =
          await RegulationsService.instance.checkCompliance(
        speciesName: speciesName,
        fishLength: fishLength,
        region: region,
        subRegion: subRegion,
        catchDate: catchDate,
      );
      notifyListeners();
      return _lastComplianceCheck!;
    } catch (e) {
      debugPrint('Error checking compliance: $e');
      rethrow;
    }
  }

  /// Search regulations
  Future<List<FishingRegulation>> searchRegulations(String query) async {
    try {
      return await RegulationsService.instance.searchRegulations(query);
    } catch (e) {
      debugPrint('Error searching regulations: $e');
      return [];
    }
  }

  /// Import regulations data
  Future<void> importRegulations(List<FishingRegulation> regulations) async {
    try {
      await RegulationsService.instance.importRegulations(regulations);
      if (_currentRegion != null) {
        await loadRegulationsForRegion(_currentRegion!);
      }
    } catch (e) {
      debugPrint('Error importing regulations: $e');
    }
  }

  /// Clear current regulation
  void clearCurrentRegulation() {
    _currentRegulation = null;
    _lastComplianceCheck = null;
    notifyListeners();
  }

  /// Get compliance status color
  Color getComplianceColor(RegulationCompliance compliance) {
    if (compliance.isCompliant && compliance.violations.isEmpty) {
      return const Color(0xFF4CAF50); // Green
    } else if (compliance.warnings.isNotEmpty && compliance.violations.isEmpty) {
      return const Color(0xFFFFC107); // Amber
    } else {
      return const Color(0xFFF44336); // Red
    }
  }

  /// Get compliance icon
  String getComplianceIcon(RegulationCompliance compliance) {
    if (compliance.canKeep) return '✅';
    if (compliance.warnings.isNotEmpty && compliance.violations.isEmpty) {
      return '⚠️';
    }
    return '❌';
  }
}
