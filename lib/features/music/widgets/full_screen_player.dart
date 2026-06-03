// lib/features/music/widgets/full_screen_player.dart

import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:her/features/auth/providers/auth_provider.dart';
import 'package:her/core/constants/app_colors.dart';
import 'package:her/core/constants/app_radius.dart';
import 'package:her/core/constants/app_spacing.dart';
import 'package:her/core/constants/app_typography.dart';
import 'package:her/core/router/app_router.dart';
import '../controller/music_controller.dart';
import '../models/player_mode.dart';
import '../models/music_track.dart';
import '../models/music_state.dart';
import 'queue_bottom_sheet.dart';
import 'music_search_sheet.dart';

class FullScreenPlayer extends ConsumerStatefulWidget {
  const FullScreenPlayer({super.key});

  @override
  ConsumerState<FullScreenPlayer> createState() => _FullScreenPlayerState();
}

class _FullScreenPlayerState extends ConsumerState<FullScreenPlayer>
    with TickerProviderStateMixin {
  late final AnimationController _rotationController;
  late final AnimationController _pulseController;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 22),
    );
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(musicControllerProvider);
    final controller = ref.read(musicControllerProvider.notifier);
    final ytController = ref.watch(youtubePlayerControllerProvider);
    final track = state.currentTrack;

    if (track == null) return const SizedBox.shrink();

    if (state.isPlaying) {
      if (!_rotationController.isAnimating) _rotationController.repeat();
      if (!_pulseController.isAnimating) _pulseController.repeat(reverse: true);
    } else {
      _rotationController.stop();
      _pulseController.stop();
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final creamBackground = const Color(0xFFF5F0EA);
    final deepBlack = const Color(0xFF0A0A0A);
    final softGrey = const Color(0xFFE8E4DF);
    
    final user = ref.watch(authProvider).valueOrNull;
    final isHim = user?.role == 'him';
    final themeColor = isHim ? AppColors.slateBluePrimary : AppColors.rosePrimary;

    return Scaffold(
      backgroundColor: isDark ? deepBlack : creamBackground,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Bar ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.grey[300],
                    child: Text(
                      user?.displayName.substring(0, 1).toUpperCase() ?? 'U',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black54),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(Icons.more_horiz, color: isDark ? Colors.white70 : Colors.black87),
                    onPressed: () => _showOptions(context, ref),
                  ),
                  IconButton(
                    icon: Icon(Icons.settings_outlined, color: isDark ? Colors.white70 : Colors.black87),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            const Spacer(flex: 1),

            // ── Vinyl Disc Art ──
            Center(
              child: AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  final pulse = 1.0 + (sin(_pulseController.value * pi) * 0.02);
                  return Transform.scale(
                    scale: state.isPlaying ? 1.04 * pulse : 1.0,
                    child: RotationTransition(
                      turns: _rotationController,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.72,
                        height: MediaQuery.of(context).size.width * 0.72,
                        child: CustomPaint(
                          painter: VinylDiscPainter(),
                          child: Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(999),
                              child: CachedNetworkImage(
                                imageUrl: track.thumbnail,
                                width: MediaQuery.of(context).size.width * 0.22,
                                height: MediaQuery.of(context).size.width * 0.22,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const Spacer(flex: 2),

            // ── Track Metadata ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    track.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.dmSerifDisplay(
                      fontSize: 34,
                      height: 1.1,
                      letterSpacing: -0.5,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    track.channelName.toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white54 : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // ── Progress Seek Bar ──
            ValueListenableBuilder<YoutubePlayerValue>(
              valueListenable: ytController,
              builder: (context, value, _) {
                final pos = value.position.inMilliseconds.toDouble();
                final total = value.metaData.duration.inMilliseconds.toDouble();
                final displayTotal = total > 0 ? total : track.durationMs.toDouble();

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 3,
                          activeTrackColor: isDark ? Colors.white : Colors.black,
                          inactiveTrackColor: isDark ? Colors.white12 : softGrey,
                          thumbColor: _isDragging ? (isDark ? Colors.white : Colors.black) : Colors.transparent,
                          thumbShape: RoundSliderThumbShape(enabledThumbRadius: _isDragging ? 6 : 0),
                          overlayShape: const RoundSliderOverlayShape(overlayRadius: 0),
                        ),
                        child: Slider(
                          value: pos.clamp(0.0, displayTotal),
                          min: 0,
                          max: displayTotal > 0 ? displayTotal : 1.0,
                          onChangeStart: (_) => setState(() => _isDragging = true),
                          onChangeEnd: (v) {
                            setState(() => _isDragging = false);
                            controller.seekTo(v);
                          },
                          onChanged: (v) {},
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatMs(pos.toInt()),
                              style: GoogleFonts.robotoMono(
                                fontSize: 11,
                                color: isDark ? Colors.white38 : Colors.black38,
                              ),
                            ),
                            Text(
                              "-${_formatMs((displayTotal - pos).toInt())}",
                              style: GoogleFonts.robotoMono(
                                fontSize: 11,
                                color: isDark ? Colors.white38 : Colors.black38,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            // ── Controls Row ──
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _GhostCircleButton(
                  icon: Icons.skip_previous_rounded,
                  onTap: () => controller.seekTo(0),
                ),
                const SizedBox(width: 32),
                GestureDetector(
                  onTap: () => controller.togglePlay(),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark ? Colors.white : Colors.black,
                      boxShadow: [
                        BoxShadow(
                          color: (isDark ? Colors.white : Colors.black).withOpacity(0.15),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Icon(
                      state.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      color: isDark ? Colors.black : Colors.white,
                      size: 38,
                    ),
                  ),
                ),
                const SizedBox(width: 32),
                _GhostCircleButton(
                  icon: Icons.skip_next_rounded,
                  onTap: () => controller.skipNext(),
                ),
              ],
            ),

            const Spacer(flex: 1),

            // ── Secondary Action Row ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _SecondaryAction(
                    icon: Icons.lyrics_outlined,
                    label: 'Lyrics',
                    onTap: () => _openLyricsSheet(context, track, themeColor, ytController, controller, state),
                  ),
                  _SecondaryAction(
                    icon: Icons.queue_music_rounded,
                    label: 'Queue',
                    onTap: () => _showQueue(context),
                  ),
                  _SecondaryAction(
                    icon: Icons.shuffle_rounded,
                    label: 'Shuffle',
                    active: false,
                    themeColor: themeColor,
                    onTap: () {},
                  ),
                  _SecondaryAction(
                    icon: Icons.repeat_rounded,
                    label: 'Repeat',
                    active: false,
                    themeColor: themeColor,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatMs(int ms) {
    if (ms < 0) ms = 0;
    final duration = Duration(milliseconds: ms);
    final m = duration.inMinutes.remainder(60).toString();
    final s = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void _showQueue(BuildContext context) {
    final overlayContext = rootNavigatorKey.currentContext;
    showModalBottomSheet(
      context: overlayContext ?? context,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const QueueBottomSheet(),
    );
  }

  void _openLyricsSheet(BuildContext context, MusicTrack track, Color accent, YoutubePlayerController yt, MusicController controller, MusicState state) {
    final overlayContext = rootNavigatorKey.currentContext;
    showModalBottomSheet(
      context: overlayContext ?? context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _LyricsBottomSheet(
        track: track,
        themeColor: accent,
        ytController: yt,
        controller: controller,
        musicState: state,
      ),
    );
  }

  void _showOptions(BuildContext context, WidgetRef ref) {
    final overlayContext = rootNavigatorKey.currentContext;
    showModalBottomSheet(
      context: overlayContext ?? context,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          color: Theme.of(ctx).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.circular(2))),
              ListTile(
                leading: const Icon(Icons.search),
                title: const Text('Search & Add Songs'),
                onTap: () {
                  Navigator.pop(ctx);
                  showModalBottomSheet(
                    context: overlayContext ?? context,
                    useRootNavigator: true,
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    builder: (_) => const MusicSearchSheet(),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.music_off),
                title: const Text('End Playback Session'),
                onTap: () {
                  Navigator.pop(ctx);
                  ref.read(musicControllerProvider.notifier).endSession();
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class VinylDiscPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Disc fill
    canvas.drawCircle(center, radius, Paint()..color = const Color(0xFF111111));

    // Grooves
    final grooveRadii = [0.92, 0.84, 0.76, 0.68, 0.60, 0.52, 0.44, 0.38];
    for (final r in grooveRadii) {
      canvas.drawCircle(
        center,
        radius * r,
        Paint()
          ..color = Colors.white.withOpacity(0.04)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2,
      );
    }

    // Label area
    canvas.drawCircle(center, radius * 0.31, Paint()..color = const Color(0xFF1A1A1A));

    // Hole
    canvas.drawCircle(center, radius * 0.04, Paint()..color = Colors.black);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _GhostCircleButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _GhostCircleButton({required this.icon, required this.onTap});

  @override
  State<_GhostCircleButton> createState() => _GhostCircleButtonState();
}

class _GhostCircleButtonState extends State<_GhostCircleButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.9 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDark ? Colors.white.withOpacity(0.06) : Colors.black.withOpacity(0.05),
          ),
          child: Icon(widget.icon, color: isDark ? Colors.white70 : Colors.black87, size: 28),
        ),
      ),
    );
  }
}

class _SecondaryAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final Color? themeColor;
  final VoidCallback onTap;

  const _SecondaryAction({
    required this.icon,
    required this.label,
    this.active = false,
    this.themeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = active ? (themeColor ?? Colors.black) : (isDark ? Colors.white38 : Colors.black38);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: active ? FontWeight.bold : FontWeight.normal,
              color: color,
            ),
          ),
          if (active) ...[
            const SizedBox(height: 2),
            Container(width: 3, height: 3, decoration: BoxDecoration(shape: BoxShape.circle, color: color)),
          ],
        ],
      ),
    );
  }
}

class _LyricsBottomSheet extends StatelessWidget {
  final MusicTrack track;
  final Color themeColor;
  final YoutubePlayerController ytController;
  final MusicController controller;
  final MusicState musicState;

  const _LyricsBottomSheet({
    required this.track,
    required this.themeColor,
    required this.ytController,
    required this.controller,
    required this.musicState,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.95,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, scrollController) => Container(
        decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2))),
            
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 32),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          track.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.dmSerifDisplay(color: Colors.white, fontSize: 24),
                        ),
                        Text(
                            track.channelName,
                          style: const TextStyle(color: Colors.white54, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  IconButton(icon: const Icon(Icons.ios_share, color: Colors.white, size: 22), onPressed: () {}),
                  IconButton(icon: const Icon(Icons.favorite_border, color: Colors.white, size: 24), onPressed: () {}),
                ],
              ),
            ),

            // Lyrics List
            Expanded(
              child: ValueListenableBuilder<YoutubePlayerValue>(
                valueListenable: ytController,
                builder: (context, value, _) {
                  return _LyricsListView(
                    currentMs: value.position.inMilliseconds.toDouble(),
                    themeColor: themeColor,
                  );
                },
              ),
            ),

            // Bottom Controls
            Container(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
              color: Colors.black,
              child: Column(
                children: [
                  ValueListenableBuilder<YoutubePlayerValue>(
                    valueListenable: ytController,
                    builder: (context, value, _) {
                      final pos = value.position.inMilliseconds.toDouble();
                      final total = value.metaData.duration.inMilliseconds.toDouble();
                      final displayTotal = total > 0 ? total : track.durationMs.toDouble();
                      final progress = (pos / displayTotal).clamp(0.0, 1.0);
                      
                      return Column(
                        children: [
                          Container(
                            height: 3,
                            width: double.infinity,
                            decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(2)),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: progress,
                              child: Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(2))),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(_formatMs(pos.toInt()), style: const TextStyle(color: Colors.white38, fontSize: 10)),
                              Text("-${_formatMs((displayTotal - pos).toInt())}", style: const TextStyle(color: Colors.white38, fontSize: 10)),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => controller.togglePlay(),
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                      child: Icon(
                        musicState.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                        color: Colors.black,
                        size: 32,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatMs(int ms) {
    if (ms < 0) ms = 0;
    final duration = Duration(milliseconds: ms);
    final m = duration.inMinutes.remainder(60).toString();
    final s = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}

class _LyricsListView extends StatelessWidget {
  final double currentMs;
  final Color themeColor;

  const _LyricsListView({required this.currentMs, required this.themeColor});

  @override
  Widget build(BuildContext context) {
    // Mock lyrics data
    final List<LyricLine> lyrics = [
      LyricLine(text: "So independent", startMs: 0),
      LyricLine(text: "Tell me why", startMs: 3000),
      LyricLine(text: "'Cause the boy is mine, mine", startMs: 6000),
      LyricLine(text: "Somethin' about him is made for", startMs: 10000),
      LyricLine(text: "somebody like me", startMs: 13000),
      LyricLine(text: "Baby, come over, come over (over)", startMs: 16000),
      LyricLine(text: "And God knows I'm tryin', but there's just", startMs: 20000),
      LyricLine(text: "no use in denying", startMs: 24000),
      LyricLine(text: "The boy is mine", startMs: 28000),
      LyricLine(text: "I can't wait to try him", startMs: 32000),
      LyricLine(text: "Le-let's get intertwined", startMs: 35000),
      LyricLine(text: "The stars, they aligned", startMs: 40000),
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 40),
      itemCount: lyrics.length,
      itemBuilder: (context, index) {
        final line = lyrics[index];
        final isActive = currentMs >= line.startMs && (index == lyrics.length - 1 || currentMs < lyrics[index + 1].startMs);
        final isPast = currentMs > line.startMs && !isActive;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
          child: Text(
            line.text,
            style: TextStyle(
              fontSize: isActive ? 22 : 19,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
              color: isActive ? Colors.white : (isPast ? Colors.white24 : Colors.white54),
              height: 1.4,
              shadows: isActive ? [Shadow(color: themeColor.withOpacity(0.5), blurRadius: 15)] : null,
            ),
          ),
        );
      },
    );
  }
}

class LyricLine {
  final String text;
  final int startMs;
  LyricLine({required this.text, required this.startMs});
}

