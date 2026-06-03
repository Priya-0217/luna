// lib/features/music/widgets/music_search_sheet.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:her/features/auth/providers/auth_provider.dart';
import 'package:her/core/constants/app_colors.dart';
import 'package:her/core/constants/app_typography.dart';
import '../controller/youtube_search_service.dart';
import '../controller/music_controller.dart';
import '../models/music_track.dart';

class MusicSearchSheet extends ConsumerStatefulWidget {
  const MusicSearchSheet({super.key});

  @override
  ConsumerState<MusicSearchSheet> createState() => _MusicSearchSheetState();
}

class _MusicSearchSheetState extends ConsumerState<MusicSearchSheet> {
  final TextEditingController _searchController = TextEditingController();
  final YouTubeSearchService _searchService = YouTubeSearchService();
  List<MusicTrack> _results = [];
  bool _isLoading = false;
  String _error = '';

  // Preset lovely couple recommendations when search is empty
  final List<MusicTrack> _recommendations = const [
    MusicTrack(
      videoId: '2Vv-BfVoq4g',
      title: 'Ed Sheeran - Perfect',
      thumbnail: 'https://img.youtube.com/vi/2Vv-BfVoq4g/hqdefault.jpg',
      channelName: 'Ed Sheeran',
      durationMs: 263000,
    ),
    MusicTrack(
      videoId: 'GxldQ9GyXQM',
      title: 'Stephen Sanchez - Until I Found You',
      thumbnail: 'https://img.youtube.com/vi/GxldQ9GyXQM/hqdefault.jpg',
      channelName: 'Stephen Sanchez',
      durationMs: 177000,
    ),
    MusicTrack(
      videoId: '0yW7w8F2TVA',
      title: 'Taylor Swift - Lover',
      thumbnail: 'https://img.youtube.com/vi/0yW7w8F2TVA/hqdefault.jpg',
      channelName: 'Taylor Swift',
      durationMs: 221000,
    ),
    MusicTrack(
      videoId: 'fKopy74weus',
      title: 'James Arthur - Say You Won\'t Let Go',
      thumbnail: 'https://img.youtube.com/vi/fKopy74weus/hqdefault.jpg',
      channelName: 'James Arthur',
      durationMs: 211000,
    ),
  ];

  @override
  void initState() {
    super.initState();
    debugPrint('[MusicSearchSheet] initState');
  }

  @override
  void dispose() {
    debugPrint('[MusicSearchSheet] dispose');
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _results = [];
        _error = '';
      });
      return;
    }

    debugPrint('[MusicSearchSheet] search query="$query"');
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final list = await _searchService.search(query);
      setState(() {
        _results = list;
        _isLoading = false;
      });
      debugPrint('[MusicSearchSheet] results count=${list.length}');
    } catch (e) {
      setState(() {
        _error = 'Failed to load songs. Please try again.';
        _isLoading = false;
      });
      debugPrint('[MusicSearchSheet] search error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(musicControllerProvider);
    final controller = ref.read(musicControllerProvider.notifier);

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = ref.watch(authProvider).valueOrNull;
    final isHim = user?.role == 'him';
    final themeColor = isHim
        ? AppColors.slateBluePrimary
        : AppColors.rosePrimary;
    final textThemeColor = isHim ? AppColors.slateBlueDark : AppColors.roseDark;

    final displayList = _searchController.text.trim().isEmpty
        ? _recommendations
        : _results;

    debugPrint(
      '[MusicSearchSheet] build loading=$_isLoading error="$_error" '
      'query="${_searchController.text}" results=${displayList.length} '
      'isPlaying=${state.isPlaying} mode=${state.mode}',
    );

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Drag handle indicator
          const SizedBox(height: 8),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),

          // Search Field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
              decoration: InputDecoration(
                hintText: 'Search songs on YouTube Music...',
                hintStyle: TextStyle(color: Colors.grey[500]),
                prefixIcon: Icon(Icons.search, color: themeColor),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _results = [];
                          });
                        },
                      )
                    : null,
                filled: true,
                fillColor: isDark
                    ? AppColors.darkCard
                    : AppColors.roseSoft.withOpacity(0.3),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: isDark
                        ? AppColors.darkBorder
                        : (isHim
                              ? AppColors.slateBlueSoft
                              : AppColors.roseSoft),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: themeColor, width: 2),
                ),
              ),
              onChanged: _performSearch,
            ),
          ),
          const SizedBox(height: 12),

          // Header Text
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _searchController.text.trim().isEmpty
                    ? '💖 Cozy Recommendations'
                    : '🔍 Search Results',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.darkText : textThemeColor,
                ),
              ),
            ),
          ),
          const Divider(),

          // Body Content
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator(color: themeColor))
                : _error.isNotEmpty
                ? Center(
                    child: Text(
                      _error,
                      style: const TextStyle(color: AppColors.error),
                    ),
                  )
                : displayList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.sentiment_dissatisfied,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No results found',
                          style: AppTypography.titleMedium.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 24),
                    itemCount: displayList.length,
                    itemBuilder: (context, index) {
                      final track = displayList[index];
                      return ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: track.thumbnail,
                            width: 52,
                            height: 52,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => Container(
                              width: 52,
                              height: 52,
                              color: Colors.grey[200],
                            ),
                            errorWidget: (_, __, ___) => Container(
                              width: 52,
                              height: 52,
                              color: Colors.grey[300],
                              child: const Icon(
                                Icons.music_note,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        title: Text(
                          track.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.bodySmall.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          track.channelName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Play Now Button
                            IconButton(
                              icon: Icon(Icons.play_arrow, color: themeColor),
                              onPressed: () {
                                if (track.videoId.isEmpty) {
                                  debugPrint(
                                    '[MusicSearchSheet] play ignored (empty videoId)',
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'This track cannot be played yet.',
                                      ),
                                    ),
                                  );
                                  return;
                                }
                                debugPrint(
                                  '[MusicSearchSheet] play track=${track.videoId}',
                                );
                                controller.playSong(track);
                                Navigator.pop(context);
                              },
                            ),
                            // Add to Queue Button
                            IconButton(
                              icon: const Icon(
                                Icons.add_circle_outline,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                debugPrint(
                                  '[MusicSearchSheet] addToQueue track=${track.videoId}',
                                );
                                controller.addToQueue(track);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Added "${track.title}" to queue 🎵',
                                    ),
                                    backgroundColor: themeColor,
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
