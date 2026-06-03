// lib/features/music/controller/youtube_search_service.dart

import 'package:flutter/foundation.dart';
import 'package:dart_ytmusic_api/yt_music.dart';
import '../models/music_track.dart';

class YouTubeSearchService {
  final YTMusic _ytmusic = YTMusic();
  bool _initialized = false;

  Future<void> _ensureInitialized() async {
    if (!_initialized) {
      debugPrint('[YouTubeSearchService] initialize');
      await _ytmusic.initialize();
      _initialized = true;
      debugPrint('[YouTubeSearchService] initialize complete');
    }
  }

  Future<List<MusicTrack>> search(String query) async {
    try {
      debugPrint('[YouTubeSearchService] search query="$query"');
      await _ensureInitialized();
      final songResults = await _ytmusic.searchSongs(query);

      final filtered = songResults.where((song) => song.videoId.isNotEmpty).map((
        song,
      ) {
        // Thumbnail URL resolution
        String thumbnailUrl = '';
        if (song.thumbnails.isNotEmpty) {
          thumbnailUrl = song.thumbnails.last.url;
        }

        // Duration conversion: song.duration is in seconds, we need milliseconds
        final durationMs = (song.duration ?? 0) * 1000;
        final artistName = song.artist.name.isNotEmpty
            ? song.artist.name
            : 'Unknown Artist';

        return MusicTrack(
          videoId: song.videoId,
          title: song.name,
          thumbnail: thumbnailUrl,
          channelName: artistName,
          durationMs: durationMs,
        );
      }).toList();

      debugPrint('[YouTubeSearchService] results count=${filtered.length}');
      return filtered;
    } catch (e) {
      debugPrint('[YouTubeSearchService] search error: $e');
      // Fallback: If search fails (e.g. YouTube Music blocks the request), return empty list or fallback results.
      return [];
    }
  }

  Future<int> getVideoDurationMs(String videoId) async {
    try {
      debugPrint('[YouTubeSearchService] getVideoDurationMs videoId=$videoId');
      await _ensureInitialized();
      final song = await _ytmusic.getSong(videoId);
      return (song.duration ?? 0) * 1000;
    } catch (e) {
      debugPrint('[YouTubeSearchService] getVideoDurationMs error: $e');
      return 0;
    }
  }
}
