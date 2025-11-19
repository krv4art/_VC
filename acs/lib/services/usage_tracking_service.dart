import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// !5@28A 4;O >BA;56820=8O 8A?>;L7>20=8O ?@8;>65=8O 15A?;0B=K<8 ?>;L7>20B5;O<8
class UsageTrackingService {
  static final UsageTrackingService _instance = UsageTrackingService._internal();
  factory UsageTrackingService() => _instance;
  UsageTrackingService._internal();

  // SharedPreferences :;NG8
  static const String _weeklyScansCountKey = 'weekly_scans_count';
  static const String _weeklyScansResetDateKey = 'weekly_scans_reset_date';
  static const String _dailyMessagesCountKey = 'daily_messages_count';
  static const String _dailyMessagesResetDateKey = 'daily_messages_reset_date';

  // 8<8BK
  static const int freeScansPerWeek = 5;
  static const int freeMessagesPerDay = 5;
  static const int freeVisibleScans = 1;

  /// =8F80;870F8O A5@28A0
  Future<void> initialize() async {
    await _checkAndResetCounters();
    debugPrint('UsageTrackingService initialized');
  }

  /// @>25@8BL 8 A1@>A8BL AG5BG8:8, 5A;8 ?@>H5; ?5@8>4
  Future<void> _checkAndResetCounters() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();

    // @>25@:0 =545;L=>3> AG5BG8:0 A:0=>2
    final weeklyResetDateStr = prefs.getString(_weeklyScansResetDateKey);
    if (weeklyResetDateStr != null) {
      final resetDate = DateTime.parse(weeklyResetDateStr);
      if (now.difference(resetDate).inDays >= 7) {
        await prefs.setInt(_weeklyScansCountKey, 0);
        await prefs.setString(
          _weeklyScansResetDateKey,
          now.toIso8601String(),
        );
      }
    } else {
      // 5@2K9 70?CA: - CAB0=02;8205< 40BC
      await prefs.setString(
        _weeklyScansResetDateKey,
        now.toIso8601String(),
      );
    }

    // @>25@:0 4=52=>3> AG5BG8:0 A>>1I5=89
    final dailyResetDateStr = prefs.getString(_dailyMessagesResetDateKey);
    if (dailyResetDateStr != null) {
      final resetDate = DateTime.parse(dailyResetDateStr);
      if (!_isSameDay(now, resetDate)) {
        await prefs.setInt(_dailyMessagesCountKey, 0);
        await prefs.setString(
          _dailyMessagesResetDateKey,
          now.toIso8601String(),
        );
      }
    } else {
      // 5@2K9 70?CA: - CAB0=02;8205< 40BC
      await prefs.setString(
        _dailyMessagesResetDateKey,
        now.toIso8601String(),
      );
    }
  }

  /// @>25@8BL, A>2?0405B ;8 45=L
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  // ========== !+ ==========

  /// >;CG8BL :>;8G5AB2> A:0=>2 70 MBC =545;N
  Future<int> getWeeklyScansCount() async {
    await _checkAndResetCounters();
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_weeklyScansCountKey) ?? 0;
  }

  /// #25;8G8BL AG5BG8: A:0=>2
  Future<void> incrementScansCount() async {
    final prefs = await SharedPreferences.getInstance();
    final currentCount = await getWeeklyScansCount();
    await prefs.setInt(_weeklyScansCountKey, currentCount + 1);
    debugPrint('Scans count incremented: ${currentCount + 1}/$freeScansPerWeek');
  }

  /// @>25@8BL, <>65B ;8 ?>;L7>20B5;L A:0=8@>20BL
  Future<bool> canUserScan() async {
    final count = await getWeeklyScansCount();
    final canScan = count < freeScansPerWeek;
    debugPrint('Can user scan: $canScan (count: $count/$freeScansPerWeek)');
    return canScan;
  }

  /// >;CG8BL A:>;L:> A:0=>2 >AB0;>AL
  Future<int> getRemainingScanCount() async {
    final count = await getWeeklyScansCount();
    return freeScansPerWeek - count;
  }

  // ========== !)/  '" ==========

  /// >;CG8BL :>;8G5AB2> A>>1I5=89 70 A53>4=O
  Future<int> getDailyMessagesCount() async {
    await _checkAndResetCounters();
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_dailyMessagesCountKey) ?? 0;
  }

  /// #25;8G8BL AG5BG8: A>>1I5=89
  Future<void> incrementMessagesCount() async {
    final prefs = await SharedPreferences.getInstance();
    final currentCount = await getDailyMessagesCount();
    await prefs.setInt(_dailyMessagesCountKey, currentCount + 1);
    debugPrint('Messages count incremented: ${currentCount + 1}/$freeMessagesPerDay');
  }

  /// @>25@8BL, <>65B ;8 ?>;L7>20B5;L >B?@028BL A>>1I5=85
  Future<bool> canUserSendMessage() async {
    final count = await getDailyMessagesCount();
    final canSend = count < freeMessagesPerDay;
    debugPrint('Can user send message: $canSend (count: $count/$freeMessagesPerDay)');
    return canSend;
  }

  /// >;CG8BL A:>;L:> A>>1I5=89 >AB0;>AL
  Future<int> getRemainingMessageCount() async {
    final count = await getDailyMessagesCount();
    return freeMessagesPerDay - count;
  }

  // ========== !" / ! ==========

  /// @>25@8BL, 4>ABC?=0 ;8 ?>78F8O 2 8AB>@88 A:0=>2 (?> 8=45:AC)
  bool isHistoryItemAccessible(int index) {
    // ;O 15A?;0B=KE ?>;L7>20B5;59 4>ABC?=0 B>;L:> ?5@20O ?>78F8O (index 0)
    return index < freeVisibleScans;
  }

  // ========== ! ! (4;O B5AB8@>20=8O) ==========

  /// !1@>A8BL 2A5 AG5BG8:8 (4;O B5AB8@>20=8O)
  Future<void> resetAllCounters() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_weeklyScansCountKey);
    await prefs.remove(_weeklyScansResetDateKey);
    await prefs.remove(_dailyMessagesCountKey);
    await prefs.remove(_dailyMessagesResetDateKey);
    debugPrint('All usage counters reset');
  }

  /// !1@>A8BL AG5BG8: A:0=>2
  Future<void> resetWeeklyScansCount() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_weeklyScansCountKey, 0);
    debugPrint('Weekly scans counter reset');
  }

  /// !1@>A8BL AG5BG8: A>>1I5=89
  Future<void> resetDailyMessagesCount() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_dailyMessagesCountKey, 0);
    debugPrint('Daily messages counter reset');
  }

  // ========== SOFT PAYWALL ==========

  /// Проверить, нужно ли показать soft paywall после сканирования
  /// Показываем после 3-го сканирования (один раз)
  Future<bool> shouldShowSoftPaywallAfterScan() async {
    final count = await getWeeklyScansCount();
    return count == 3; // Точно после 3-го сканирования
  }

  /// Проверить, нужно ли показать soft paywall после отправки сообщения
  /// Показываем после 3-го сообщения (один раз)
  Future<bool> shouldShowSoftPaywallAfterMessage() async {
    final count = await getDailyMessagesCount();
    return count == 3; // Точно после 3-го сообщения
  }
}
