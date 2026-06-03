// lib/features/music/widgets/music_global_layer.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controller/music_controller.dart';
import '../models/music_state.dart';
import '../models/player_mode.dart';
import 'youtube_core_widget.dart';
import 'mini_player_bar.dart';
import 'bubble_player.dart';
import 'popup_player.dart';
import 'full_screen_player.dart';

class MusicGlobalLayer extends ConsumerWidget {
  const MusicGlobalLayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(musicControllerProvider);
    final bottomPadding = MediaQuery.of(context).padding.bottom + kBottomNavigationBarHeight;

    return Stack(
      children: [
        // ── Persistent Core Youtube Widget ──
        // Kept offstage to maintain playback while the vinyl disc handles the visual representation
        const Positioned(
          left: -9999,
          top: 0,
          child: Offstage(
            offstage: false,
            child: YouTubeCoreWidget(),
          ),
        ),

        // ── UI Shell Mode Switcher ──
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, animation) {
            if (child.key == const ValueKey(PlayerMode.fullScreen)) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(animation),
                  child: ScaleTransition(scale: Tween<double>(begin: 0.95, end: 1.0).animate(animation), child: child),
                ),
              );
            }
            return FadeTransition(opacity: animation, child: child);
          },
          child: _buildLayerForMode(state.mode, bottomPadding),
        ),
      ],
    );
  }

  Widget _buildLayerForMode(PlayerMode mode, double bottomPadding) {
    switch (mode) {
      case PlayerMode.miniBar:
        return Stack(
          key: const ValueKey(PlayerMode.miniBar),
          children: [
            Positioned(
              bottom: bottomPadding,
              left: 0,
              right: 0,
              child: const MiniPlayerBar(),
            ),
          ],
        );
      case PlayerMode.fullScreen:
        return const FullScreenPlayer(
          key: ValueKey(PlayerMode.fullScreen),
        );
      case PlayerMode.bubble:
        return Stack(
          key: const ValueKey(PlayerMode.bubble),
          children: [
            const BubblePlayer(
              x: 100, // This would normally come from state, keeping simple for now
              y: 100,
            ),
          ],
        );
      case PlayerMode.popup:
        return const PopupPlayer(key: ValueKey(PlayerMode.popup));
      case PlayerMode.hidden:
      default:
        return const SizedBox.shrink(key: ValueKey(PlayerMode.hidden));
    }
  }
}

