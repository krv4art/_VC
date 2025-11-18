import 'package:flutter/material.dart';
import '../models/poll_option.dart';
import '../models/poll_vote.dart';
import '../services/poll_service.dart';
import '../constants/app_dimensions.dart';
import 'animated/animated_card.dart';
import 'common/app_spacer.dart';

/// Widget for displaying and managing feature polls
class PollWidget extends StatefulWidget {
  const PollWidget({Key? key}) : super(key: key);

  @override
  State<PollWidget> createState() => _PollWidgetState();
}

class _PollWidgetState extends State<PollWidget> {
  final PollService _pollService = PollService();
  final ScrollController _scrollController = ScrollController();

  List<PollOption> _pollOptions = [];
  PollFilter _currentFilter = PollFilter.newest;
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _loadPollOptions();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoading && _hasMore) {
        _loadMoreOptions();
      }
    }
  }

  Future<void> _loadPollOptions() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _currentPage = 0;
      _hasMore = true;
    });

    final options = await _pollService.fetchPollOptions(
      filter: _currentFilter,
      page: 0,
    );

    setState(() {
      _pollOptions = options;
      _isLoading = false;
      _hasMore = options.length == 10;
    });
  }

  Future<void> _loadMoreOptions() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _currentPage++;
    });

    final options = await _pollService.fetchPollOptions(
      filter: _currentFilter,
      page: _currentPage,
    );

    setState(() {
      _pollOptions.addAll(options);
      _isLoading = false;
      _hasMore = options.length == 10;
    });
  }

  Future<void> _toggleVote(PollOption option) async {
    final success = await _pollService.toggleVote(option.id, option.hasVoted);

    if (success) {
      setState(() {
        final index = _pollOptions.indexWhere((o) => o.id == option.id);
        if (index != -1) {
          _pollOptions[index] = option.copyWith(
            hasVoted: !option.hasVoted,
            votesCount: option.hasVoted
                ? option.votesCount - 1
                : option.votesCount + 1,
          );
        }
      });
    }
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildFilterBottomSheet(),
    );
  }

  Widget _buildFilterBottomSheet() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.space24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filter Options',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          AppSpacer.v16(),
          ...PollFilter.values.map((filter) {
            final isSelected = _currentFilter == filter;
            return AnimatedCard(
              margin: const EdgeInsets.only(bottom: AppDimensions.space8),
              onTap: () {
                setState(() {
                  _currentFilter = filter;
                });
                Navigator.pop(context);
                _loadPollOptions();
              },
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.space16),
                child: Row(
                  children: [
                    Icon(
                      _getFilterIcon(filter),
                      color: isSelected
                          ? const Color(0xFF6B4EFF)
                          : Colors.grey,
                    ),
                    AppSpacer.h16(),
                    Expanded(
                      child: Text(
                        filter.displayName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected
                              ? const Color(0xFF6B4EFF)
                              : Colors.black,
                        ),
                      ),
                    ),
                    if (isSelected)
                      const Icon(
                        Icons.check_circle,
                        color: Color(0xFF6B4EFF),
                      ),
                  ],
                ),
              ),
            );
          }).toList(),
          AppSpacer.v16(),
        ],
      ),
    );
  }

  IconData _getFilterIcon(PollFilter filter) {
    switch (filter) {
      case PollFilter.newest:
        return Icons.access_time;
      case PollFilter.topVoted:
        return Icons.trending_up;
      case PollFilter.myVote:
        return Icons.how_to_vote;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.all(AppDimensions.space16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Vote for Features',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: _showFilterBottomSheet,
                color: const Color(0xFF6B4EFF),
              ),
            ],
          ),
        ),

        // Current filter indicator
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.space16),
          child: Row(
            children: [
              Icon(
                _getFilterIcon(_currentFilter),
                size: 16,
                color: Colors.grey,
              ),
              AppSpacer.h8(),
              Text(
                _currentFilter.displayName,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),

        AppSpacer.v16(),

        // Poll options list
        Expanded(
          child: _isLoading && _pollOptions.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : _pollOptions.isEmpty
                  ? const Center(
                      child: Text('No feature requests yet'),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.space16,
                      ),
                      itemCount:
                          _pollOptions.length + (_hasMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index >= _pollOptions.length) {
                          return const Padding(
                            padding: EdgeInsets.all(AppDimensions.space16),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        final option = _pollOptions[index];
                        return _buildPollCard(option);
                      },
                    ),
        ),
      ],
    );
  }

  Widget _buildPollCard(PollOption option) {
    return AnimatedCard(
      margin: const EdgeInsets.only(bottom: AppDimensions.space12),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              option.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            AppSpacer.v8(),

            // Description
            Text(
              option.description,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            AppSpacer.v16(),

            // Vote button and count
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Vote count
                Row(
                  children: [
                    const Icon(
                      Icons.how_to_vote,
                      size: 18,
                      color: Colors.grey,
                    ),
                    AppSpacer.h8(),
                    Text(
                      '${option.votesCount} ${option.votesCount == 1 ? 'vote' : 'votes'}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),

                // Vote button
                ElevatedButton.icon(
                  onPressed: () => _toggleVote(option),
                  icon: Icon(
                    option.hasVoted ? Icons.check : Icons.add,
                    size: 18,
                  ),
                  label: Text(
                    option.hasVoted ? 'Voted' : 'Vote',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: option.hasVoted
                        ? const Color(0xFF6B4EFF)
                        : Colors.grey[200],
                    foregroundColor:
                        option.hasVoted ? Colors.white : Colors.black87,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.space16,
                      vertical: AppDimensions.space8,
                    ),
                  ),
                ),
              ],
            ),

            // Date
            AppSpacer.v8(),
            Text(
              _formatDate(option.createdAt),
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 7) {
      return '${date.day}/${date.month}/${date.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
