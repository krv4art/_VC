import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';
import '../models/poll_option.dart';
import '../models/poll_vote.dart';

/// Service for managing feature polls and voting
class PollService {
  static final PollService _instance = PollService._internal();
  factory PollService() => _instance;
  PollService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;
  String? _deviceId;

  static const int _pageSize = 10;

  /// Get unique device ID
  Future<String> getDeviceId() async {
    if (_deviceId != null) return _deviceId!;

    try {
      final deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        _deviceId = androidInfo.id;
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        _deviceId = iosInfo.identifierForVendor ?? 'unknown';
      } else {
        _deviceId = 'web_${DateTime.now().millisecondsSinceEpoch}';
      }
    } catch (e) {
      debugPrint('Error getting device ID: $e');
      _deviceId = 'unknown_${DateTime.now().millisecondsSinceEpoch}';
    }

    return _deviceId!;
  }

  /// Fetch poll options with filter and pagination
  Future<List<PollOption>> fetchPollOptions({
    required PollFilter filter,
    int page = 0,
  }) async {
    try {
      final deviceId = await getDeviceId();
      final offset = page * _pageSize;

      // Build query based on filter
      var query = _supabase
          .from('poll_options')
          .select('*, poll_votes!poll_votes_poll_option_id_fkey(device_id)')
          .range(offset, offset + _pageSize - 1);

      switch (filter) {
        case PollFilter.newest:
          query = query.order('created_at', ascending: false);
          break;
        case PollFilter.topVoted:
          query = query.order('votes_count', ascending: false);
          break;
        case PollFilter.myVote:
          // Filter only options the user has voted for
          query = query
              .eq('poll_votes.device_id', deviceId)
              .order('created_at', ascending: false);
          break;
      }

      final response = await query;

      if (response == null) return [];

      return (response as List).map((json) {
        final votes = json['poll_votes'] as List?;
        final hasVoted = votes?.any((vote) => vote['device_id'] == deviceId) ?? false;

        return PollOption.fromJson({
          ...json,
          'has_voted': hasVoted,
        });
      }).toList();
    } catch (e) {
      debugPrint('Error fetching poll options: $e');
      return [];
    }
  }

  /// Vote for a poll option
  Future<bool> voteForOption(String optionId) async {
    try {
      final deviceId = await getDeviceId();

      // Check if already voted
      final existingVote = await _supabase
          .from('poll_votes')
          .select()
          .eq('poll_option_id', optionId)
          .eq('device_id', deviceId)
          .maybeSingle();

      if (existingVote != null) {
        debugPrint('Already voted for this option');
        return false;
      }

      // Insert vote
      await _supabase.from('poll_votes').insert({
        'poll_option_id': optionId,
        'device_id': deviceId,
      });

      // Increment votes count
      await _supabase.rpc('increment_poll_votes', params: {
        'option_id': optionId,
      });

      debugPrint('Vote recorded successfully');
      return true;
    } catch (e) {
      debugPrint('Error voting for option: $e');
      return false;
    }
  }

  /// Remove vote from a poll option
  Future<bool> unvoteForOption(String optionId) async {
    try {
      final deviceId = await getDeviceId();

      // Delete vote
      await _supabase
          .from('poll_votes')
          .delete()
          .eq('poll_option_id', optionId)
          .eq('device_id', deviceId);

      // Decrement votes count
      await _supabase.rpc('decrement_poll_votes', params: {
        'option_id': optionId,
      });

      debugPrint('Vote removed successfully');
      return true;
    } catch (e) {
      debugPrint('Error removing vote: $e');
      return false;
    }
  }

  /// Toggle vote (vote if not voted, unvote if already voted)
  Future<bool> toggleVote(String optionId, bool currentlyVoted) async {
    if (currentlyVoted) {
      return await unvoteForOption(optionId);
    } else {
      return await voteForOption(optionId);
    }
  }

  /// Get total number of votes for current device
  Future<int> getTotalVotesCount() async {
    try {
      final deviceId = await getDeviceId();
      final response = await _supabase
          .from('poll_votes')
          .select('id', const FetchOptions(count: CountOption.exact))
          .eq('device_id', deviceId);

      return response.count ?? 0;
    } catch (e) {
      debugPrint('Error getting total votes count: $e');
      return 0;
    }
  }
}
