// lib/features/music/models/player_mode.dart

import 'package:flutter/foundation.dart';

enum PlayerMode {
  hidden, // no UI shown
  miniBar, // bottom strip (like Spotify mini player)
  bubble, // floating draggable circle
  popup, // center card popup
  fullScreen, // full screen
}

void logPlayerMode({
  required String source,
  required PlayerMode mode,
  String? note,
}) {
  final suffix = (note == null || note.isEmpty) ? '' : ' ($note)';
  debugPrint('[$source] mode=$mode$suffix');
}
