import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/leaderboard_entry.dart';

enum LeaderboardPeriod {
  daily,
  weekly,
  monthly,
  allTime,
}

class LeaderboardService {
  final SupabaseClient _supabase;

  LeaderboardService({required SupabaseClient supabase}) : _supabase = supabase;

  /// Get global leaderboard
  Future<List<LeaderboardEntry>> getGlobalLeaderboard({
    LeaderboardPeriod period = LeaderboardPeriod.allTime,
    int limit = 100,
  }) async {
    try {
      // Query leaderboard view (created in Supabase)
      final response = await _supabase
          .from('leaderboard_view')
          .select()
          .order('total_xp', ascending: false)
          .limit(limit);

      final List<dynamic> data = response as List<dynamic>;

      return data
          .asMap()
          .entries
          .map((entry) => LeaderboardEntry.fromJson(
                entry.value as Map<String, dynamic>,
                entry.key + 1, // rank starts from 1
              ))
          .toList();
    } catch (e) {
      debugPrint('Error getting global leaderboard: $e');
      return [];
    }
  }

  /// Get friends leaderboard
  Future<List<LeaderboardEntry>> getFriendsLeaderboard({
    required String userId,
    int limit = 50,
  }) async {
    try {
      // Get user's friends
      final friendsResponse = await _supabase
          .from('friends')
          .select('friend_id')
          .eq('user_id', userId)
          .eq('status', 'accepted');

      final List<dynamic> friendsData = friendsResponse as List<dynamic>;
      final friendIds = friendsData
          .map((f) => f['friend_id'] as String)
          .toList();

      // Add current user
      friendIds.add(userId);

      // Get leaderboard for these users
      final response = await _supabase
          .from('leaderboard_view')
          .select()
          .inFilter('user_id', friendIds)
          .order('total_xp', ascending: false)
          .limit(limit);

      final List<dynamic> data = response as List<dynamic>;

      return data
          .asMap()
          .entries
          .map((entry) => LeaderboardEntry.fromJson(
                entry.value as Map<String, dynamic>,
                entry.key + 1,
              ))
          .toList();
    } catch (e) {
      debugPrint('Error getting friends leaderboard: $e');
      return [];
    }
  }

  /// Get user's rank
  Future<int?> getUserRank(String userId) async {
    try {
      // Get user's XP
      final userResponse = await _supabase
          .from('leaderboard_view')
          .select('total_xp')
          .eq('user_id', userId)
          .maybeSingle();

      if (userResponse == null) return null;

      final userXp = userResponse['total_xp'] as int;

      // Count users with higher XP
      final countResponse = await _supabase
          .from('leaderboard_view')
          .select()
          .gt('total_xp', userXp);

      final List<dynamic> data = countResponse as List<dynamic>;
      return data.length + 1;
    } catch (e) {
      debugPrint('Error getting user rank: $e');
      return null;
    }
  }

  /// Get nearby users (users close in rank)
  Future<List<LeaderboardEntry>> getNearbyUsers({
    required String userId,
    int range = 5,
  }) async {
    try {
      final rank = await getUserRank(userId);
      if (rank == null) return [];

      final startRank = (rank - range).clamp(1, double.infinity).toInt();
      final endRank = rank + range;

      final response = await _supabase
          .from('leaderboard_view')
          .select()
          .order('total_xp', ascending: false)
          .range(startRank - 1, endRank - 1);

      final List<dynamic> data = response as List<dynamic>;

      return data
          .asMap()
          .entries
          .map((entry) => LeaderboardEntry.fromJson(
                entry.value as Map<String, dynamic>,
                startRank + entry.key,
              ))
          .toList();
    } catch (e) {
      debugPrint('Error getting nearby users: $e');
      return [];
    }
  }

  /// Search users by name (for adding friends)
  Future<List<LeaderboardEntry>> searchUsers(String query) async {
    try {
      final response = await _supabase
          .from('leaderboard_view')
          .select()
          .ilike('full_name', '%$query%')
          .limit(20);

      final List<dynamic> data = response as List<dynamic>;

      return data
          .map((json) => LeaderboardEntry.fromJson(
                json as Map<String, dynamic>,
                0, // rank not relevant for search
              ))
          .toList();
    } catch (e) {
      debugPrint('Error searching users: $e');
      return [];
    }
  }
}
