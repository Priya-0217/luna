// lib/features/music/models/music_track.dart

import 'package:flutter/foundation.dart';

class MusicTrack {
  final String videoId;
  final String title;
  final String thumbnail;
  final String channelName;
  final int durationMs;

  const MusicTrack({
    required this.videoId,
    required this.title,
    required this.thumbnail,
    required this.channelName,
    required this.durationMs,
  });

  factory MusicTrack.fromJson(Map<String, dynamic> json) {
    final track = MusicTrack(
      videoId: json['videoId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      thumbnail: json['thumbnail'] as String? ?? '',
      channelName: json['channelName'] as String? ?? '',
      durationMs: json['durationMs'] as int? ?? 0,
    );

    if (kDebugMode) {
      debugPrint(
        '[MusicTrack] fromJson videoId=${track.videoId} title="${track.title}"',
      );
    }
    return track;
  }

  Map<String, dynamic> toJson() {
    if (kDebugMode) {
      debugPrint('[MusicTrack] toJson videoId=$videoId');
    }
    return {
      'videoId': videoId,
      'title': title,
      'thumbnail': thumbnail,
      'channelName': channelName,
      'durationMs': durationMs,
    };
  }

  @override
  String toString() {
    return 'MusicTrack(videoId=$videoId, title="$title", channel="$channelName", durationMs=$durationMs)';
  }
}
