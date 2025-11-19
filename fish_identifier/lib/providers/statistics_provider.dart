import 'package:flutter/foundation.dart';
import '../models/fishing_statistics.dart';
import '../models/fish_collection.dart';
import '../models/fish_identification.dart';
import '../services/database_service.dart';

/// Provider for fishing statistics and analytics
class StatisticsProvider extends ChangeNotifier {
  FishingStatistics? _currentStats;
  bool _isLoading = false;
  DateTime _periodStart = DateTime.now().subtract(const Duration(days: 30));
  DateTime _periodEnd = DateTime.now();

  // Getters
  FishingStatistics? get currentStats => _currentStats;
  bool get isLoading => _isLoading;
  DateTime get periodStart => _periodStart;
  DateTime get periodEnd => _periodEnd;

  bool get hasData => _currentStats != null;

  /// Set date range
  void setDateRange(DateTime start, DateTime end) {
    _periodStart = start;
    _periodEnd = end;
    notifyListeners();
  }

  /// Load statistics for current period
  Future<void> loadStatistics({String? userId}) async {
    _isLoading = true;
    notifyListeners();

    try {
      _currentStats = await _calculateStatistics(
        userId: userId ?? 'current_user',
        periodStart: _periodStart,
        periodEnd: _periodEnd,
      );
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint('Error loading statistics: $e');
    }
  }

  /// Calculate statistics from database
  Future<FishingStatistics> _calculateStatistics({
    required String userId,
    required DateTime periodStart,
    required DateTime periodEnd,
  }) async {
    final collection = await DatabaseService.instance.getAllCollection();

    // Filter by date range
    final filtered = collection.where((fish) {
      final catchDate = DateTime.parse(fish.catchDate);
      return catchDate.isAfter(periodStart) && catchDate.isBefore(periodEnd);
    }).toList();

    // Calculate overall stats
    final overall = _calculateOverallStats(filtered);

    // Calculate species stats
    final bySpecies = await _calculateSpeciesStats(filtered);

    // Calculate location stats
    final byLocation = _calculateLocationStats(filtered);

    // Calculate time stats
    final byTime = _calculateTimeStats(filtered);

    // Calculate weather correlation
    final weatherCorrelation = _calculateWeatherCorrelation(filtered);

    // Calculate personal records
    final records = await _calculatePersonalRecords(collection);

    return FishingStatistics(
      userId: userId,
      periodStart: periodStart,
      periodEnd: periodEnd,
      overall: overall,
      bySpecies: bySpecies,
      byLocation: byLocation,
      byTime: byTime,
      weatherCorrelation: weatherCorrelation,
      records: records,
    );
  }

  OverallStats _calculateOverallStats(List<FishCollection> collection) {
    if (collection.isEmpty) {
      return OverallStats(
        totalCatches: 0,
        uniqueSpecies: 0,
        uniqueLocations: 0,
        averageLength: 0,
        averageWeight: 0,
        totalWeight: 0,
        daysActive: 0,
        catchesPerDay: 0,
      );
    }

    final totalCatches = collection.length;
    final uniqueSpecies =
        collection.map((f) => f.fishIdentificationId).toSet().length;
    final uniqueLocations =
        collection.where((f) => f.location != null).map((f) => f.location).toSet().length;

    final lengths = collection.where((f) => f.length != null).map((f) => f.length!).toList();
    final weights = collection.where((f) => f.weight != null).map((f) => f.weight!).toList();

    final averageLength = lengths.isNotEmpty
        ? lengths.reduce((a, b) => a + b) / lengths.length
        : 0.0;

    final averageWeight = weights.isNotEmpty
        ? weights.reduce((a, b) => a + b) / weights.length
        : 0.0;

    final totalWeight = weights.isNotEmpty
        ? weights.reduce((a, b) => a + b)
        : 0.0;

    // Calculate days active
    final dates = collection
        .map((f) => DateTime.parse(f.catchDate))
        .map((d) => DateTime(d.year, d.month, d.day))
        .toSet();
    final daysActive = dates.length;

    final catchesPerDay = daysActive > 0 ? totalCatches / daysActive : 0.0;

    return OverallStats(
      totalCatches: totalCatches,
      uniqueSpecies: uniqueSpecies,
      uniqueLocations: uniqueLocations,
      averageLength: averageLength,
      averageWeight: averageWeight,
      totalWeight: totalWeight,
      daysActive: daysActive,
      catchesPerDay: catchesPerDay,
    );
  }

  Future<List<SpeciesStats>> _calculateSpeciesStats(
    List<FishCollection> collection,
  ) async {
    final speciesMap = <int, List<FishCollection>>{};

    for (final fish in collection) {
      speciesMap.putIfAbsent(fish.fishIdentificationId, () => []).add(fish);
    }

    final statsList = <SpeciesStats>[];

    for (final entry in speciesMap.entries) {
      final fishData = await DatabaseService.instance
          .getFishIdentificationById(entry.key);

      if (fishData == null) continue;

      final catches = entry.value;
      final lengths = catches.where((f) => f.length != null).map((f) => f.length!).toList();
      final weights = catches.where((f) => f.weight != null).map((f) => f.weight!).toList();

      statsList.add(SpeciesStats(
        speciesName: fishData.fishName,
        count: catches.length,
        percentage: (catches.length / collection.length) * 100,
        averageLength: lengths.isNotEmpty
            ? lengths.reduce((a, b) => a + b) / lengths.length
            : 0,
        averageWeight: weights.isNotEmpty
            ? weights.reduce((a, b) => a + b) / weights.length
            : 0,
        maxLength: lengths.isNotEmpty ? lengths.reduce((a, b) => a > b ? a : b) : 0,
        maxWeight: weights.isNotEmpty ? weights.reduce((a, b) => a > b ? a : b) : 0,
      ));
    }

    statsList.sort((a, b) => b.count.compareTo(a.count));
    return statsList;
  }

  List<LocationStats> _calculateLocationStats(List<FishCollection> collection) {
    final locationMap = <String, List<FishCollection>>{};

    for (final fish in collection) {
      if (fish.location != null) {
        locationMap.putIfAbsent(fish.location!, () => []).add(fish);
      }
    }

    final statsList = <LocationStats>[];

    for (final entry in locationMap.entries) {
      final catches = entry.value;
      final firstCatch = catches.first;

      statsList.add(LocationStats(
        locationName: entry.key,
        latitude: firstCatch.latitude ?? 0,
        longitude: firstCatch.longitude ?? 0,
        count: catches.length,
        uniqueSpecies: catches.map((f) => f.fishIdentificationId).toSet().length,
        successRate: 1.0, // TODO: Calculate based on total trips
      ));
    }

    statsList.sort((a, b) => b.count.compareTo(a.count));
    return statsList;
  }

  List<TimeStats> _calculateTimeStats(List<FishCollection> collection) {
    final dateMap = <DateTime, List<FishCollection>>{};

    for (final fish in collection) {
      final date = DateTime.parse(fish.catchDate);
      final dateOnly = DateTime(date.year, date.month, date.day);
      dateMap.putIfAbsent(dateOnly, () => []).add(fish);
    }

    final statsList = <TimeStats>[];

    for (final entry in dateMap.entries) {
      statsList.add(TimeStats(
        date: entry.key,
        catches: entry.value.length,
        species: entry.value.map((f) => f.fishIdentificationId).toSet().length,
      ));
    }

    statsList.sort((a, b) => a.date.compareTo(b.date));
    return statsList;
  }

  WeatherCorrelation _calculateWeatherCorrelation(
    List<FishCollection> collection,
  ) {
    final byCondition = <String, int>{};
    final byTemperatureRange = <String, int>{};
    final byPressureRange = <String, int>{};

    for (final fish in collection) {
      if (fish.weatherConditions != null) {
        byCondition[fish.weatherConditions!] =
            (byCondition[fish.weatherConditions!] ?? 0) + 1;
      }
    }

    return WeatherCorrelation(
      byCondition: byCondition,
      byTemperatureRange: byTemperatureRange,
      byPressureRange: byPressureRange,
      mostSuccessfulCondition:
          byCondition.isNotEmpty ? byCondition.keys.first : 'Unknown',
      bestTemperatureRange: '15-25°C',
      bestPressureRange: '1010-1020 hPa',
    );
  }

  Future<PersonalRecords> _calculatePersonalRecords(
    List<FishCollection> collection,
  ) async {
    FishRecord? longestFish;
    FishRecord? heaviestFish;
    int biggestDayCount = 0;
    DateTime? biggestDayDate;

    // Find longest fish
    final withLength = collection.where((f) => f.length != null).toList();
    if (withLength.isNotEmpty) {
      withLength.sort((a, b) => b.length!.compareTo(a.length!));
      final longest = withLength.first;
      final fishData = await DatabaseService.instance
          .getFishIdentificationById(longest.fishIdentificationId);

      if (fishData != null) {
        longestFish = FishRecord(
          speciesName: fishData.fishName,
          length: longest.length!,
          weight: longest.weight ?? 0,
          caughtAt: DateTime.parse(longest.catchDate),
          location: longest.location,
        );
      }
    }

    // Find heaviest fish
    final withWeight = collection.where((f) => f.weight != null).toList();
    if (withWeight.isNotEmpty) {
      withWeight.sort((a, b) => b.weight!.compareTo(a.weight!));
      final heaviest = withWeight.first;
      final fishData = await DatabaseService.instance
          .getFishIdentificationById(heaviest.fishIdentificationId);

      if (fishData != null) {
        heaviestFish = FishRecord(
          speciesName: fishData.fishName,
          length: heaviest.length ?? 0,
          weight: heaviest.weight!,
          caughtAt: DateTime.parse(heaviest.catchDate),
          location: heaviest.location,
        );
      }
    }

    // Calculate streaks
    final dates = collection
        .map((f) => DateTime.parse(f.catchDate))
        .map((d) => DateTime(d.year, d.month, d.day))
        .toSet()
        .toList()
      ..sort();

    int currentStreak = 0;
    int longestStreak = 0;
    int tempStreak = 1;

    if (dates.isNotEmpty) {
      for (int i = 1; i < dates.length; i++) {
        if (dates[i].difference(dates[i - 1]).inDays == 1) {
          tempStreak++;
        } else {
          longestStreak = tempStreak > longestStreak ? tempStreak : longestStreak;
          tempStreak = 1;
        }
      }
      longestStreak = tempStreak > longestStreak ? tempStreak : longestStreak;

      // Check if current streak is active
      if (DateTime.now().difference(dates.last).inDays <= 1) {
        currentStreak = tempStreak;
      }
    }

    return PersonalRecords(
      longestFish: longestFish,
      heaviestFish: heaviestFish,
      rarestFish: null,
      biggestDayCount: biggestDayCount,
      biggestDayDate: biggestDayDate,
      currentStreak: currentStreak,
      longestStreak: longestStreak,
    );
  }
}
