# 🎵 Premium Music Player UI — Flutter Implementation Prompt

> Based on the reference design: minimal luxury aesthetic (cream/black palette),
> large editorial typography, vinyl disc art, inline lyrics bottom sheet.
> App uses Riverpod + YouTubePlayerFlutter + isHim/themeColor role-based theming.

---

## 🖼️ DESIGN LANGUAGE — Reference Screen Analysis

### Screen 1 (Main Player)
- **Background**: Warm off-white / cream (`#F5F0EA`) — NOT white, NOT grey
- **Vinyl disc**: Large centered circle (~75% screen width), deep matte black
  with subtle grooves, artist thumbnail embedded in the center hole (~30% disc diameter)
- **Typography**: Large editorial serif font (like Playfair Display or DM Serif)
  for the track title — multi-line, left-aligned, very large (`fontSize: 36–42`)
- **Artist name**: Small, light weight, centered below title, `Colors.black54`
- **Progress bar**: Slim (3px), full-width, minimal — no thumb dot by default,
  only appears on drag. Black active fill, light grey inactive.
- **Timestamps**: Small monospace-style, left (`0:34`) and right (`-2:12`)
- **Controls row**: Three buttons — skip_previous, play/pause (large filled black
  circle, white icon, ~64px), skip_next — equal spacing, circular grey ghost buttons
  for prev/next (40px, `Colors.black08` fill)
- **Top bar**: Avatar (circular, top-left), `...` menu (center), settings gear (top-right)

### Screen 2 (Lyrics Bottom Sheet — opens ON the same screen)
- **This is NOT a new screen** — it's a `DraggableScrollableSheet` that slides
  up from the bottom, covering ~90% of the screen
- **Top pill**: White rounded-rectangle drag handle
- **Collapsed header** (sticky at top of sheet): Shows `v` chevron (left),
  large bold serif title (center, same typography), upload icon + heart (right)
- **Background**: Pure `Colors.black` (`#000000`)
- **Lyrics list**: Scrolling lines, no timestamps shown
  - Active line: `Colors.white`, `fontWeight: FontWeight.bold`, `fontSize: 17`
  - Upcoming lines: `Colors.white60`, `fontWeight: FontWeight.w400`, `fontSize: 16`
  - Past lines: `Colors.white30`, `fontSize: 15`
  - Auto-scroll: keeps active line at ~35% from top
  - Line spacing: generous (`height: 2.2`)
- **Bottom controls bar** (sticky): Slim progress bar (same as main screen) +
  timestamps + single play/pause circle button (white filled, black icon, 56px)
  centered below the bar. No other buttons visible.

---

## 🎨 COLOR SYSTEM

```dart
// Derive from isHim themeColor — but override background always:
const creamBackground = Color(0xFFF5F0EA);   // main player bg (light mode)
const deepBlack = Color(0xFF0A0A0A);          // lyrics sheet bg, disc color
const softGrey = Color(0xFFE8E4DF);           // inactive progress, ghost buttons

// Dynamic accent still uses themeColor from isHim:
// rosePrimary for her, slateBluePrimary for him
// BUT in this minimal design, themeColor is only used for:
//   - progress bar active fill
//   - heart icon when liked
//   - active lyrics line subtle glow
// Everything else is black/cream/white
```

---

## 📐 FULL SCREEN PLAYER — `full_screen_player.dart`

### Convert to `ConsumerStatefulWidget`
Required for `AnimationController`s. Keep all existing providers and logic.

### Background
```dart
Scaffold(
  backgroundColor: isDark ? deepBlack : creamBackground,
  body: SafeArea(child: ...)
)
```

### Top Bar
```dart
// Replace current top bar with:
Row(
  children: [
    // Left: circular avatar (user profile photo or placeholder)
    CircleAvatar(radius: 18, backgroundImage: ...),
    const Spacer(),
    // Center: "..." icon (options)
    IconButton(icon: Icon(Icons.more_horiz, color: Colors.black87)),
    // Right: settings gear
    IconButton(icon: Icon(Icons.settings_outlined, color: Colors.black87)),
  ],
)
// isDark variant: all icons Colors.white70
```

### Vinyl Disc (replaces the 16:9 video placeholder area)
```dart
// The YouTube video box stays hidden via MusicGlobalLayer offstage logic.
// In its place, render the animated vinyl disc:

Center(
  child: RotationTransition(
    turns: _rotationController,  // repeat when playing, stop when paused
    child: SizedBox(
      width: MediaQuery.of(context).size.width * 0.72,
      height: MediaQuery.of(context).size.width * 0.72,
      child: CustomPaint(
        painter: VinylDiscPainter(),   // see below
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.25,
            height: MediaQuery.of(context).size.width * 0.25,
            child: ClipOval(
              child: track.thumbnail.isNotEmpty
                  ? CachedNetworkImage(imageUrl: track.thumbnail, fit: BoxFit.cover)
                  : Container(color: Colors.grey[800]),
            ),
          ),
        ),
      ),
    ),
  ),
)
```

### `VinylDiscPainter` (private class, bottom of file)
```dart
class VinylDiscPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Main disc fill — deep matte black
    canvas.drawCircle(center, radius,
        Paint()..color = const Color(0xFF111111));

    // Grooves — concentric circles at varying radii
    final grooveRadii = [0.92, 0.84, 0.76, 0.68, 0.60, 0.52, 0.44, 0.38];
    for (final r in grooveRadii) {
      canvas.drawCircle(
        center, radius * r,
        Paint()
          ..color = Colors.white.withOpacity(0.04)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2,
      );
    }

    // Label area circle (slightly lighter than disc)
    canvas.drawCircle(center, radius * 0.31,
        Paint()..color = const Color(0xFF1A1A1A));

    // Center spindle hole
    canvas.drawCircle(center, radius * 0.04,
        Paint()..color = Colors.black);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
```

### Track Metadata
```dart
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 28),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Large editorial serif title — multi-line
      Text(
        track.title,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontFamily: 'DM Serif Display',   // or Playfair Display
          fontSize: 38,
          fontWeight: FontWeight.w700,
          height: 1.15,
          color: isDark ? Colors.white : Colors.black,
          letterSpacing: -0.5,
        ),
      ),
      const SizedBox(height: 10),
      // Artist — small, centered relative to title block
      Text(
        track.channelName,
        style: TextStyle(
          fontSize: 13,
          color: isDark ? Colors.white54 : Colors.black45,
          letterSpacing: 0.3,
        ),
      ),
    ],
  ),
)
```

> **Font setup**: Add `google_fonts` package and use
> `GoogleFonts.dmSerifDisplay()` or `GoogleFonts.playfairDisplay()` as the
> TextStyle. Or declare in `pubspec.yaml` assets if bundling locally.

### Progress Bar
```dart
// Minimal slim progress — no visible thumb until drag
SliderTheme(
  data: SliderThemeData(
    trackHeight: 3,
    activeTrackColor: isDark ? Colors.white : Colors.black,
    inactiveTrackColor: isDark ? Colors.white15 : softGrey,
    thumbColor: Colors.transparent,           // hidden by default
    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 0),
    overlayShape: const RoundSliderOverlayShape(overlayRadius: 0),
    // Show thumb on interaction via _isDragging state flag:
    // thumbShape: _isDragging
    //     ? RoundSliderThumbShape(enabledThumbRadius: 6)
    //     : RoundSliderThumbShape(enabledThumbRadius: 0),
  ),
  child: Slider(value: ..., onChanged: ...),
)
// Timestamps: left=elapsed, right="-" + remaining (NOT total)
// remaining = _formatMs((displayTotal - pos).toInt()) with "-" prefix
```

### Controls Row
```dart
// Three-button layout: prev | play/pause | next
// Ghost circle buttons for prev/next, solid black filled circle for play/pause

Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    // Previous — ghost circle
    _GhostCircleButton(
      icon: Icons.skip_previous_rounded,
      size: 44,
      onTap: () => controller.skipPrevious(),   // or replay 10
    ),
    const SizedBox(width: 28),

    // Play/Pause — large solid circle
    GestureDetector(
      onTap: () => controller.togglePlay(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 66, height: 66,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDark ? Colors.white : Colors.black,
          boxShadow: [
            BoxShadow(
              color: (isDark ? Colors.white : Colors.black).withOpacity(0.15),
              blurRadius: 20, spreadRadius: 2,
            ),
          ],
        ),
        child: Icon(
          state.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
          color: isDark ? Colors.black : Colors.white,
          size: 32,
        ),
      ),
    ),

    const SizedBox(width: 28),

    // Next — ghost circle
    _GhostCircleButton(
      icon: Icons.skip_next_rounded,
      size: 44,
      onTap: () => controller.skipNext(),
    ),
  ],
)

// _GhostCircleButton private widget:
class _GhostCircleButton extends StatefulWidget {
  // onTap, icon, size
  // Renders: Container(circle, color: Colors.black.withOpacity(0.07))
  // Press state: scale 0.90 via GestureDetector + AnimatedScale
}
```

### Secondary Icon Row (below controls)
```dart
// Lyrics, Queue, Shuffle, Repeat — small icon + label
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 36),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      _SecondaryAction(
        icon: Icons.lyrics_outlined,
        label: 'Lyrics',
        onTap: () => _openLyricsSheet(context),  // opens bottom sheet
      ),
      _SecondaryAction(
        icon: Icons.queue_music_rounded,
        label: 'Queue',
        onTap: () => _openQueueSheet(context),
      ),
      _SecondaryAction(
        icon: Icons.shuffle_rounded,
        label: 'Shuffle',
        active: state.isShuffle,
        themeColor: themeColor,
      ),
      _SecondaryAction(
        icon: Icons.repeat_rounded,
        label: 'Repeat',
        active: state.isRepeat,
        themeColor: themeColor,
      ),
    ],
  ),
)

// _SecondaryAction: Column(icon + text), opacity 0.35 default, 1.0 when active
// Active state uses themeColor for icon + adds underline dot indicator
```

---

## 📋 LYRICS BOTTOM SHEET — `_LyricsBottomSheet`

> This is the key feature. Triggered from the "Lyrics" secondary action button.
> NOT a new route — a `DraggableScrollableSheet` presented via `showModalBottomSheet`.

```dart
void _openLyricsSheet(BuildContext context) {
  showModalBottomSheet(
    context: rootNavigatorKey.currentContext ?? context,
    useRootNavigator: true,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.5),
    builder: (_) => _LyricsBottomSheet(
      track: track,
      themeColor: themeColor,
      isPlaying: state.isPlaying,
      position: currentPosition,      // pass current ms
      duration: displayTotal,         // pass total ms
      onPlayPause: controller.togglePlay,
      onSeek: controller.seekTo,
    ),
  );
}
```

### `_LyricsBottomSheet` Widget Structure

```dart
class _LyricsBottomSheet extends StatefulWidget {
  // Receives: track, themeColor, isPlaying, position, duration,
  //           onPlayPause, onSeek

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      minChildSize: 0.55,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFF0A0A0A),   // pure near-black
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // ── Drag Handle ──
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 6),
                  width: 36, height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // ── Sticky Header (track info + actions) ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  children: [
                    // Collapse chevron
                    IconButton(
                      icon: const Icon(Icons.keyboard_arrow_down,
                          color: Colors.white, size: 26),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Spacer(),
                    // Track title — large serif, white, center
                    Expanded(
                      flex: 4,
                      child: Text(
                        track.title,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: TextStyle(
                          fontFamily: 'DM Serif Display',
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 1.2,
                        ),
                      ),
                    ),
                    const Spacer(),
                    // Share + Heart icons
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.ios_share_outlined,
                              color: Colors.white70, size: 20),
                          onPressed: () {},
                        ),
                        _HeartButton(themeColor: themeColor),
                      ],
                    ),
                  ],
                ),
              ),

              // Artist name below header
              Text(
                track.channelName,
                style: const TextStyle(
                  color: Colors.white38, fontSize: 12, letterSpacing: 0.5),
              ),
              const SizedBox(height: 12),

              const Divider(color: Colors.white10, height: 1),

              // ── Scrollable Lyrics List ──
              Expanded(
                child: _LyricsListView(
                  scrollController: scrollController,
                  lyrics: _mockLyrics,         // or fetched lyrics list
                  currentPositionMs: positionMs,
                  themeColor: themeColor,
                ),
              ),

              const Divider(color: Colors.white10, height: 1),

              // ── Sticky Bottom Controls ──
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                child: Column(
                  children: [
                    // Progress bar (same minimal style as main player)
                    SliderTheme(
                      data: SliderThemeData(
                        trackHeight: 3,
                        activeTrackColor: Colors.white,
                        inactiveTrackColor: Colors.white15,
                        thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 0),
                        overlayShape: const RoundSliderOverlayShape(
                            overlayRadius: 0),
                      ),
                      child: Slider(
                        value: positionMs.clamp(0.0, durationMs),
                        min: 0, max: durationMs > 0 ? durationMs : 1,
                        onChanged: onSeek,
                      ),
                    ),
                    // Timestamps
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_formatMs(positionMs.toInt()),
                            style: const TextStyle(
                                color: Colors.white54, fontSize: 11)),
                        Text('-${_formatMs((durationMs - positionMs).toInt())}',
                            style: const TextStyle(
                                color: Colors.white38, fontSize: 11)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Single centered play/pause button
                    GestureDetector(
                      onTap: onPlayPause,
                      child: Container(
                        width: 58, height: 58,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: Icon(
                          isPlaying
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                          color: Colors.black,
                          size: 28,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
```

### `_LyricsListView` — Synchronized Scrolling
```dart
class _LyricsListView extends StatefulWidget {
  // lyrics: List<LyricLine>  (each has: text, startMs, isChorus)
  // currentPositionMs: double
  // themeColor: Color

  // Find active index: last line where startMs <= currentPositionMs
  // Auto-scroll: scrollController.animateTo(
  //   activeIndex * lineHeight - listHeight * 0.35,
  //   duration: 400ms, curve: Curves.easeOut
  // )

  // Each line renders as:
  Padding(
    padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 24),
    child: Text(
      line.text,
      style: TextStyle(
        fontSize: isActive ? 17 : (isPast ? 15 : 16),
        fontWeight: isActive ? FontWeight.bold : FontWeight.w400,
        color: isActive
            ? Colors.white
            : (isPast ? Colors.white24 : Colors.white55),
        height: 1.5,
        // Active line: optional subtle themeColor glow
        shadows: isActive ? [Shadow(color: themeColor.withOpacity(0.4),
            blurRadius: 8)] : null,
      ),
    ),
  )
}

// LyricLine model:
class LyricLine {
  final String text;
  final int startMs;   // when this line becomes active
  final bool isChorus; // optional: bold + slightly larger
  const LyricLine({required this.text, required this.startMs,
      this.isChorus = false});
}
```

---

## 🎵 QUEUE BOTTOM SHEET — `queue_bottom_sheet.dart` (upgrade hints)

Keep existing logic. Upgrade visual to match the black sheet style:

```dart
// Same DraggableScrollableSheet approach as lyrics
// Background: Color(0xFF0A0A0A)
// Header: "Up Next" in white serif + X close button
// Each track row:
ListTile(
  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
  leading: ClipRRect(
    borderRadius: BorderRadius.circular(6),
    child: CachedNetworkImage(imageUrl: ..., width: 44, height: 44, fit: BoxFit.cover),
  ),
  title: Text(track.title,
      maxLines: 1,
      style: TextStyle(color: Colors.white, fontSize: 14,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal)),
  subtitle: Text(track.channelName,
      style: TextStyle(color: Colors.white38, fontSize: 12)),
  // Active track: animated equalizer bars widget on trailing
  trailing: isActive
      ? _AnimatedEqualizerBars(color: themeColor)
      : Text(_formatMs(track.durationMs),
             style: TextStyle(color: Colors.white38, fontSize: 12)),
)
```

`_AnimatedEqualizerBars`: Row of 3 small bars (width 3, gap 2) that scale
height between 6px and 18px using staggered AnimationControllers.

---

## 🎛️ MINI PLAYER BAR — upgrade hints for `mini_player_bar.dart`

```dart
// Match the cream/black aesthetic:
Container(
  height: 72,
  margin: const EdgeInsets.symmetric(horizontal: 12),
  decoration: BoxDecoration(
    color: isDark
        ? Colors.white.withOpacity(0.08)
        : Colors.black.withOpacity(0.06),
    borderRadius: BorderRadius.circular(16),
    border: Border.all(
      color: isDark ? Colors.white12 : Colors.black08, width: 0.5),
  ),
  child: Column(
    children: [
      // Progress line at TOP of bar
      ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        child: LinearProgressIndicator(
          value: durationMs > 0 ? positionMs / durationMs : 0,
          minHeight: 2,
          backgroundColor: Colors.transparent,
          color: themeColor,
        ),
      ),
      // Row: thumbnail | title+artist | play/pause
      Expanded(
        child: Row(
          children: [
            const SizedBox(width: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                  imageUrl: track.thumbnail, width: 40, height: 40,
                  fit: BoxFit.cover),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(track.title, maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : Colors.black87)),
                  Text(track.channelName, maxLines: 1,
                      style: TextStyle(
                          fontSize: 11,
                          color: isDark ? Colors.white45 : Colors.black38)),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                  state.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  color: isDark ? Colors.white : Colors.black87, size: 26),
              onPressed: () => controller.togglePlay(),
            ),
            const SizedBox(width: 4),
          ],
        ),
      ),
    ],
  ),
)
```

---

## 🔁 GLOBAL LAYER TRANSITIONS — `music_global_layer.dart`

```dart
// Wrap mode-switching widgets in AnimatedSwitcher:
AnimatedSwitcher(
  duration: const Duration(milliseconds: 350),
  transitionBuilder: (child, animation) {
    return FadeTransition(
      opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.04),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
        child: child,
      ),
    );
  },
  child: KeyedSubtree(
    key: ValueKey(state.mode),
    child: _buildCurrentModeWidget(state),
  ),
)

// MiniBar: AnimatedSlide from bottom
// fullScreen: FadeIn + slight scale up (0.96 → 1.0)
```

---

## ✅ IMPLEMENTATION RULES

1. **Preserve ALL existing logic** — `togglePlay`, `skipNext`, `seekTo`,
   `setMode`, `endSession`, all providers, all `debugPrint` calls — untouched.

2. **Convert `FullScreenPlayer`** from `ConsumerWidget` to
   `ConsumerStatefulWidget` for `AnimationController`s. Dispose all controllers.

3. **Font**: Add `google_fonts: ^6.x` to pubspec if not present and use
   `GoogleFonts.dmSerifDisplay()` for titles. Fallback: `GoogleFonts.playfairDisplay()`.

4. **New imports needed** (add only these):
   ```dart
   import 'dart:ui';                           // ImageFilter for blur
   import 'package:google_fonts/google_fonts.dart'; // serif font
   ```

5. **No new packages** beyond `google_fonts` — everything else uses existing deps.

6. All new widgets are **private `_` classes at the bottom of each file**.

7. `_LyricsBottomSheet` uses **mock lyrics** by default with a `List<LyricLine>`.
   Wire to a real lyrics provider later without changing the widget interface.

8. The lyrics sheet **is not a new route** — always presented via
   `showModalBottomSheet` with `useRootNavigator: true`.

9. **isDark** is respected everywhere — cream bg in light mode, near-black in dark.
   `themeColor` (rose/slateBlue) is used only for accents: progress fill,
   heart icon active, lyrics active line glow. Never as a background.

10. The vinyl disc **replaces the 16:9 black box** visually in `FullScreenPlayer`
    but does NOT remove the `MusicGlobalLayer` offstage YouTubeCoreWidget logic.
    The video continues playing in the background; only the visual frame changes.