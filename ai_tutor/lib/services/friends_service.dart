import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/friend.dart';

class FriendsService {
  final SupabaseClient _supabase;

  FriendsService({required SupabaseClient supabase}) : _supabase = supabase;

  /// Get user's friends list
  Future<List<Friend>> getFriends(String userId) async {
    try {
      final response = await _supabase.rpc('get_friends', params: {
        'p_user_id': userId,
      });

      final List<dynamic> data = response as List<dynamic>;
      return data.map((json) => Friend.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      debugPrint('Error getting friends: $e');
      return [];
    }
  }

  /// Send friend request
  Future<bool> sendFriendRequest({
    required String fromUserId,
    required String toUserId,
  }) async {
    try {
      await _supabase.from('friends').insert({
        'user_id': fromUserId,
        'friend_id': toUserId,
        'status': 'pending',
        'created_at': DateTime.now().toIso8601String(),
      });

      // Create notification for the recipient
      await _supabase.from('notifications').insert({
        'user_id': toUserId,
        'type': 'friend_request',
        'from_user_id': fromUserId,
        'created_at': DateTime.now().toIso8601String(),
      });

      return true;
    } catch (e) {
      debugPrint('Error sending friend request: $e');
      return false;
    }
  }

  /// Accept friend request
  Future<bool> acceptFriendRequest({
    required String userId,
    required String friendId,
  }) async {
    try {
      // Update friend request status
      await _supabase
          .from('friends')
          .update({'status': 'accepted'})
          .eq('user_id', friendId)
          .eq('friend_id', userId);

      // Create reciprocal friendship
      await _supabase.from('friends').insert({
        'user_id': userId,
        'friend_id': friendId,
        'status': 'accepted',
        'created_at': DateTime.now().toIso8601String(),
      });

      return true;
    } catch (e) {
      debugPrint('Error accepting friend request: $e');
      return false;
    }
  }

  /// Reject friend request
  Future<bool> rejectFriendRequest({
    required String userId,
    required String friendId,
  }) async {
    try {
      await _supabase
          .from('friends')
          .delete()
          .eq('user_id', friendId)
          .eq('friend_id', userId);

      return true;
    } catch (e) {
      debugPrint('Error rejecting friend request: $e');
      return false;
    }
  }

  /// Remove friend
  Future<bool> removeFriend({
    required String userId,
    required String friendId,
  }) async {
    try {
      // Remove both directions of friendship
      await _supabase
          .from('friends')
          .delete()
          .or('user_id.eq.$userId,friend_id.eq.$userId')
          .or('user_id.eq.$friendId,friend_id.eq.$friendId');

      return true;
    } catch (e) {
      debugPrint('Error removing friend: $e');
      return false;
    }
  }

  /// Get pending friend requests
  Future<List<Friend>> getPendingRequests(String userId) async {
    try {
      final response = await _supabase.rpc('get_pending_friend_requests', params: {
        'p_user_id': userId,
      });

      final List<dynamic> data = response as List<dynamic>;
      return data.map((json) => Friend.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      debugPrint('Error getting pending requests: $e');
      return [];
    }
  }

  /// Check if users are friends
  Future<bool> areFriends({
    required String userId,
    required String friendId,
  }) async {
    try {
      final response = await _supabase
          .from('friends')
          .select()
          .eq('user_id', userId)
          .eq('friend_id', friendId)
          .eq('status', 'accepted')
          .maybeSingle();

      return response != null;
    } catch (e) {
      debugPrint('Error checking friendship: $e');
      return false;
    }
  }

  /// Get mutual friends count
  Future<int> getMutualFriendsCount({
    required String userId1,
    required String userId2,
  }) async {
    try {
      final response = await _supabase.rpc('get_mutual_friends_count', params: {
        'user_id_1': userId1,
        'user_id_2': userId2,
      });

      return response as int? ?? 0;
    } catch (e) {
      debugPrint('Error getting mutual friends count: $e');
      return 0;
    }
  }

  /// Block user
  Future<bool> blockUser({
    required String userId,
    required String blockedUserId,
  }) async {
    try {
      // Remove existing friendship
      await removeFriend(userId: userId, friendId: blockedUserId);

      // Add to blocked list
      await _supabase.from('blocked_users').insert({
        'user_id': userId,
        'blocked_user_id': blockedUserId,
        'created_at': DateTime.now().toIso8601String(),
      });

      return true;
    } catch (e) {
      debugPrint('Error blocking user: $e');
      return false;
    }
  }

  /// Unblock user
  Future<bool> unblockUser({
    required String userId,
    required String blockedUserId,
  }) async {
    try {
      await _supabase
          .from('blocked_users')
          .delete()
          .eq('user_id', userId)
          .eq('blocked_user_id', blockedUserId);

      return true;
    } catch (e) {
      debugPrint('Error unblocking user: $e');
      return false;
    }
  }

  /// Get blocked users
  Future<List<String>> getBlockedUsers(String userId) async {
    try {
      final response = await _supabase
          .from('blocked_users')
          .select('blocked_user_id')
          .eq('user_id', userId);

      final List<dynamic> data = response as List<dynamic>;
      return data.map((item) => item['blocked_user_id'] as String).toList();
    } catch (e) {
      debugPrint('Error getting blocked users: $e');
      return [];
    }
  }

  /// Search users by name
  Future<List<Friend>> searchUsers({
    required String query,
    required String currentUserId,
    int limit = 20,
  }) async {
    try {
      // Search in user_profiles table for matching names
      final response = await _supabase
          .from('user_profiles')
          .select('user_id, full_name, avatar_url, total_xp')
          .ilike('full_name', '%$query%')
          .neq('user_id', currentUserId)
          .limit(limit);

      final List<dynamic> data = response as List<dynamic>;

      // Convert to Friend objects with pending status
      return data.map((json) {
        return Friend(
          userId: json['user_id'] as String,
          fullName: json['full_name'] as String,
          avatarUrl: json['avatar_url'] as String?,
          totalXp: json['total_xp'] as int? ?? 0,
          status: FriendStatus.pending,
          lastActive: DateTime.now(),
        );
      }).toList();
    } catch (e) {
      debugPrint('Error searching users: $e');
      return [];
    }
  }
}
