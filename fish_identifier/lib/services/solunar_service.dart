import 'dart:math' as math;
import '../models/fishing_forecast.dart';

/// Service for solunar calculations (moon phases and feeding times)
class SolunarService {
  static final SolunarService instance = SolunarService._internal();

  factory SolunarService() => instance;

  SolunarService._internal();

  /// Get solunar data for a specific date and location
  Future<SolunarData> getSolunarData(
    DateTime date,
    double latitude,
    double longitude,
  ) async {
    final moonPhase = _calculateMoonPhase(date);
    final moonIllumination = _calculateMoonIllumination(date);
    final majorPeriods = _calculateMajorPeriods(date, latitude, longitude);
    final minorPeriods = _calculateMinorPeriods(date, latitude, longitude);
    final sunTimes = _calculateSunTimes(date, latitude, longitude);
    final moonTimes = _calculateMoonTimes(date, latitude, longitude);

    return SolunarData(
      date: date,
      moonPhase: moonPhase,
      moonIllumination: moonIllumination,
      majorPeriods: majorPeriods,
      minorPeriods: minorPeriods,
      sunrise: sunTimes['sunrise'],
      sunset: sunTimes['sunset'],
      moonrise: moonTimes['moonrise'],
      moonset: moonTimes['moonset'],
    );
  }

  /// Calculate moon phase for a given date
  MoonPhase _calculateMoonPhase(DateTime date) {
    // Known new moon date
    final knownNewMoon = DateTime(2000, 1, 6, 18, 14);
    final daysSince = date.difference(knownNewMoon).inDays;

    // Lunar cycle is approximately 29.53 days
    const lunarCycle = 29.53;
    final phase = (daysSince % lunarCycle) / lunarCycle;

    if (phase < 0.0625) return MoonPhase.newMoon;
    if (phase < 0.1875) return MoonPhase.waxingCrescent;
    if (phase < 0.3125) return MoonPhase.firstQuarter;
    if (phase < 0.4375) return MoonPhase.waxingGibbous;
    if (phase < 0.5625) return MoonPhase.fullMoon;
    if (phase < 0.6875) return MoonPhase.waningGibbous;
    if (phase < 0.8125) return MoonPhase.lastQuarter;
    if (phase < 0.9375) return MoonPhase.waningCrescent;
    return MoonPhase.newMoon;
  }

  /// Calculate moon illumination (0.0 to 1.0)
  double _calculateMoonIllumination(DateTime date) {
    final knownNewMoon = DateTime(2000, 1, 6, 18, 14);
    final daysSince = date.difference(knownNewMoon).inDays;

    const lunarCycle = 29.53;
    final phase = (daysSince % lunarCycle) / lunarCycle;

    // Illumination follows a sine curve
    return (1 - math.cos(phase * 2 * math.pi)) / 2;
  }

  /// Calculate major feeding periods (2 hours each)
  /// Occur at moonrise and moonset
  List<SolunarPeriod> _calculateMajorPeriods(
    DateTime date,
    double latitude,
    double longitude,
  ) {
    final moonTimes = _calculateMoonTimes(date, latitude, longitude);
    final periods = <SolunarPeriod>[];

    if (moonTimes['moonrise'] != null) {
      final moonrise = moonTimes['moonrise']!;
      periods.add(SolunarPeriod(
        startTime: moonrise.subtract(const Duration(hours: 1)),
        endTime: moonrise.add(const Duration(hours: 1)),
        isMajor: true,
      ));
    }

    if (moonTimes['moonset'] != null) {
      final moonset = moonTimes['moonset']!;
      periods.add(SolunarPeriod(
        startTime: moonset.subtract(const Duration(hours: 1)),
        endTime: moonset.add(const Duration(hours: 1)),
        isMajor: true,
      ));
    }

    return periods;
  }

  /// Calculate minor feeding periods (1 hour each)
  /// Occur at moon overhead and moon underfoot
  List<SolunarPeriod> _calculateMinorPeriods(
    DateTime date,
    double latitude,
    double longitude,
  ) {
    final sunTimes = _calculateSunTimes(date, latitude, longitude);
    final periods = <SolunarPeriod>[];

    // Approximate moon overhead/underfoot times as 6 hours after/before moon transit
    final moonTimes = _calculateMoonTimes(date, latitude, longitude);

    if (moonTimes['moonrise'] != null && moonTimes['moonset'] != null) {
      final moonrise = moonTimes['moonrise']!;
      final moonset = moonTimes['moonset']!;

      // Moon overhead (between moonrise and moonset)
      final moonTransit = DateTime(
        date.year,
        date.month,
        date.day,
        (moonrise.hour + moonset.hour) ~/ 2,
        (moonrise.minute + moonset.minute) ~/ 2,
      );

      periods.add(SolunarPeriod(
        startTime: moonTransit.subtract(const Duration(minutes: 30)),
        endTime: moonTransit.add(const Duration(minutes: 30)),
        isMajor: false,
      ));

      // Moon underfoot (12 hours later)
      final moonUnderfoot = moonTransit.add(const Duration(hours: 12));

      periods.add(SolunarPeriod(
        startTime: moonUnderfoot.subtract(const Duration(minutes: 30)),
        endTime: moonUnderfoot.add(const Duration(minutes: 30)),
        isMajor: false,
      ));
    }

    return periods;
  }

  /// Calculate sunrise and sunset times
  Map<String, DateTime?> _calculateSunTimes(
    DateTime date,
    double latitude,
    double longitude,
  ) {
    // Simplified calculation (use a proper library for production)
    // This is an approximation

    final n = date.difference(DateTime(date.year, 1, 1)).inDays;
    final lngHour = longitude / 15;

    // Sunrise approximation
    final tRise = n + ((6 - lngHour) / 24);
    final sunriseHour = _calculateSunHour(tRise, latitude, true);

    // Sunset approximation
    final tSet = n + ((18 - lngHour) / 24);
    final sunsetHour = _calculateSunHour(tSet, latitude, false);

    final sunrise = sunriseHour != null
        ? DateTime(
            date.year,
            date.month,
            date.day,
            sunriseHour.floor(),
            ((sunriseHour - sunriseHour.floor()) * 60).round(),
          )
        : null;

    final sunset = sunsetHour != null
        ? DateTime(
            date.year,
            date.month,
            date.day,
            sunsetHour.floor(),
            ((sunsetHour - sunsetHour.floor()) * 60).round(),
          )
        : null;

    return {
      'sunrise': sunrise,
      'sunset': sunset,
    };
  }

  /// Calculate moon rise and set times
  Map<String, DateTime?> _calculateMoonTimes(
    DateTime date,
    double latitude,
    double longitude,
  ) {
    // Simplified approximation
    // Moon rises ~50 minutes later each day

    final knownMoonrise = DateTime(2000, 1, 1, 18, 0);
    final daysSince = date.difference(DateTime(2000, 1, 1)).inDays;

    // Moon rises approximately 50 minutes later each day
    final moonriseMinutes = (daysSince * 50) % (24 * 60);
    final moonriseHour = moonriseMinutes ~/ 60;
    final moonriseMinute = moonriseMinutes % 60;

    final moonrise = DateTime(
      date.year,
      date.month,
      date.day,
      moonriseHour,
      moonriseMinute,
    );

    // Moonset is approximately 12 hours after moonrise
    final moonset = moonrise.add(const Duration(hours: 12, minutes: 25));

    return {
      'moonrise': moonrise,
      'moonset': moonset.day == date.day ? moonset : null,
    };
  }

  /// Helper method to calculate sun hour
  double? _calculateSunHour(double t, double latitude, bool isSunrise) {
    // Simplified solar calculation
    final m = (0.9856 * t) - 3.289;
    final l = m +
        (1.916 * _sinDeg(m)) +
        (0.020 * _sinDeg(2 * m)) +
        282.634;

    final ra = _atanDeg(_cosDeg(l) * 0.91764);
    final lQuadrant = (l / 90).floor() * 90;
    final raQuadrant = (ra / 90).floor() * 90;
    final raAdjusted = ra + (lQuadrant - raQuadrant);

    final sinDec = 0.39782 * _sinDeg(l);
    final cosDec = _cosDeg(_asinDeg(sinDec));

    final cosH = (math.cos(math.pi / 180 * 90.833) -
            (sinDec * _sinDeg(latitude))) /
        (cosDec * _cosDeg(latitude));

    if (cosH > 1 || cosH < -1) {
      return null; // Sun never rises/sets at this location on this date
    }

    final h = isSunrise
        ? 360 - _acosDeg(cosH)
        : _acosDeg(cosH);

    final hour = h / 15 + raAdjusted / 15 - (0.06571 * t) - 6.622;

    return hour;
  }

  // Trigonometric helper methods
  double _sinDeg(double deg) => math.sin(deg * math.pi / 180);
  double _cosDeg(double deg) => math.cos(deg * math.pi / 180);
  double _atanDeg(double value) => math.atan(value) * 180 / math.pi;
  double _asinDeg(double value) => math.asin(value) * 180 / math.pi;
  double _acosDeg(double value) => math.acos(value) * 180 / math.pi;
}
