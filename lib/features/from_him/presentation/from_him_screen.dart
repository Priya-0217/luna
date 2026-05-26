import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:her/core/constants/app_colors.dart';
import 'package:her/core/constants/app_illustrations.dart';
import 'package:her/core/constants/app_radius.dart';
import 'package:her/core/constants/app_spacing.dart';
import 'package:her/core/constants/app_typography.dart';
import 'package:her/core/widgets/luna_card.dart';
import 'package:her/core/router/app_routes.dart';

class FromHimScreen extends StatefulWidget {
  const FromHimScreen({super.key});

  @override
  State<FromHimScreen> createState() => _FromHimScreenState();
}

class _FromHimScreenState extends State<FromHimScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _hugController;
  bool _isHugging = false;

  @override
  void initState() {
    super.initState();
    _hugController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    _hugController.dispose();
    super.dispose();
  }

  void _triggerHug() {
    HapticFeedback.mediumImpact();
    setState(() => _isHugging = true);
    _hugController.repeat();

    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _isHugging = false;
          _hugController.stop();
          _hugController.reset();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Text('🫂  ', style: TextStyle(fontSize: 18)),
                Expanded(
                  child: Text(
                    'Held close, just for you 💕',
                    style: AppTypography.bodySmall
                        .copyWith(color: AppColors.white),
                  ),
                ),
              ],
            ),
            backgroundColor: AppColors.rosePrimary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.md)),
          ),
        );
      }
    });
  }

  // Sealed envelope letters
  final List<Map<String, String>> _letters = [
    {
      'id': 'cramps',
      'title': 'Read during cramps ⚡',
      'desc': 'Open this when your body hurts and you need comfort.',
      'seal': '🌸',
    },
    {
      'id': 'sad',
      'title': 'Read when down 🌧️',
      'desc': 'A soft note to dry your tears and hold you tight.',
      'seal': '💙',
    },
    {
      'id': 'sunny',
      'title': 'Read when happy ☀️',
      'desc': 'Celebrate the sunshine together.',
      'seal': '✨',
    },
    {
      'id': 'argument',
      'title': 'Read after an argument 🌸',
      'desc': 'Because nothing can stand between us.',
      'seal': '💕',
    },
    {
      'id': 'miss_me',
      'title': 'Read when you miss me 💕',
      'desc': 'To remind you how close I really am.',
      'seal': '🫂',
    },
  ];

  // Polaroid memories — slightly rotated for authentic feel
  final List<Map<String, dynamic>> _memories = [
    {'title': 'Our first sunset 🌅', 'date': 'Oct 12, 2025', 'tilt': -2.0},
    {'title': 'Rainy coffee day ☕', 'date': 'Nov 04, 2025', 'tilt': 1.5},
    {'title': 'Walking in the park 🌳', 'date': 'Dec 25, 2025', 'tilt': -1.0},
    {'title': 'Surprise dinner 🕯️', 'date': 'Jan 14, 2026', 'tilt': 2.5},
  ];

  // Comfort songs with "why he picked it" notes
  final List<Map<String, String>> _songs = [
    {
      'title': 'Perfect',
      'artist': 'Ed Sheeran',
      'why': 'because you are, to me.',
    },
    {
      'title': 'Love Story',
      'artist': 'Taylor Swift',
      'why': 'because this is our story.',
    },
    {
      'title': 'Say You Won\'t Let Go',
      'artist': 'James Arthur',
      'why': 'because I never will.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Text(
              'From Him 💌',
              style: AppTypography.displayLarge.copyWith(
                color: isDark ? AppColors.darkText : AppColors.roseDark,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Comfort, secret envelopes, and shared memories handpicked by him.',
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.warmGray400 : AppColors.warmGray600,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // ── Virtual Hug Button ─────────────────────────────────────
            LunaCard(
              color: isDark ? AppColors.darkCard : AppColors.goldSoft,
              borderColor: isDark ? AppColors.darkBorder : AppColors.goldMid,
              child: Column(
                children: [
                  Text(
                    _isHugging
                        ? 'Holding you close... 💕'
                        : 'Need a squeeze? 🧸',
                    style: AppTypography.titleLarge.copyWith(
                      color: isDark ? AppColors.darkText : AppColors.roseDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Tap to trigger a warm virtual hug sent directly from him.',
                    textAlign: TextAlign.center,
                    style: AppTypography.bodySmall.copyWith(
                      color:
                          isDark ? AppColors.warmGray400 : AppColors.warmGray600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Pulsing rings while hugging
                        if (_isHugging)
                          AnimatedBuilder(
                            animation: _hugController,
                            builder: (context, child) {
                              return Container(
                                width: 90 + (70 * _hugController.value),
                                height: 90 + (70 * _hugController.value),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.goldPrimary.withOpacity(
                                      0.3 * (1.0 - _hugController.value)),
                                ),
                              );
                            },
                          ),
                        GestureDetector(
                          onTap: _triggerHug,
                          child: Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [
                                  AppColors.goldPrimary,
                                  AppColors.rosePrimary,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.goldPrimary.withOpacity(0.35),
                                  blurRadius: 16,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              '🫂',
                              style: TextStyle(fontSize: 38),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // ── Sealed Envelopes ───────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Sealed Envelopes ✉️',
                  style: AppTypography.titleLarge.copyWith(
                    color: isDark ? AppColors.darkText : AppColors.roseDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Tap to open',
                  style: AppTypography.bodySmall.copyWith(
                      color: AppColors.warmGray600),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              height: 168,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _letters.length,
                itemBuilder: (context, index) {
                  final letter = _letters[index];
                  return GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      context.pushNamed(
                        AppRoutes.envelope,
                        pathParameters: {'id': letter['id']!},
                      );
                    },
                    child: Container(
                      width: 200,
                      margin: const EdgeInsets.only(right: 14),
                      padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
                      decoration: BoxDecoration(
                        // Ivory envelope background
                        color: isDark
                            ? AppColors.darkCard
                            : AppColors.ivory,
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        border: Border.all(
                          color: isDark
                              ? AppColors.darkBorder
                              : AppColors.goldMid.withOpacity(0.6),
                          width: 0.8,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.goldPrimary.withOpacity(0.08),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Top envelope flap icon
                          const Text('✉️',
                              style: TextStyle(fontSize: 26)),
                          Text(
                            letter['title']!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.handwrittenLg.copyWith(
                              color: isDark
                                  ? AppColors.goldMid
                                  : AppColors.roseDark,
                              height: 1.2,
                            ),
                          ),
                          Text(
                            letter['desc']!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.handwrittenSm.copyWith(
                              color: isDark
                                  ? AppColors.warmGray400
                                  : AppColors.warmGray600,
                            ),
                          ),
                          // Wax seal dot at bottom center
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.rosePrimary,
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        AppColors.rosePrimary.withOpacity(0.3),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                letter['seal']!,
                                style: const TextStyle(fontSize: 11),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // ── Polaroid Memories ──────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Polaroid Memories 📸',
                  style: AppTypography.titleLarge.copyWith(
                    color: isDark ? AppColors.darkText : AppColors.roseDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    context.pushNamed(AppRoutes.memoryGallery);
                  },
                  child: Text(
                    'View all',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.rosePrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.82,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: _memories.length,
              itemBuilder: (context, index) {
                final mem = _memories[index];
                final tilt = mem['tilt'] as double;

                // Authentic polaroid with subtle rotation
                return Transform.rotate(
                  angle: tilt * math.pi / 180,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 24),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                        BoxShadow(
                          color: AppColors.roseSoft.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(2, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Photo placeholder — soft rose tint
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.roseSoft.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(2),
                            ),
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.photo_camera_outlined,
                                  color: AppColors.rosePrimary.withOpacity(0.6),
                                  size: 32,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Memory',
                                  style: AppTypography.bodySmall.copyWith(
                                    color: AppColors.rosePrimary.withOpacity(0.6),
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Caption + date in Caveat handwriting
                        Text(
                          mem['title'] as String,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.handwritten.copyWith(
                            color: AppColors.charcoal,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          mem['date'] as String,
                          style: GoogleFonts.dmSans(
                            fontSize: 9,
                            color: AppColors.warmGray600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: AppSpacing.xl),

            // ── Comfort Playlist ───────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Comfort Playlist 🎵',
                  style: AppTypography.titleLarge.copyWith(
                    color: isDark ? AppColors.darkText : AppColors.roseDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    context.pushNamed(AppRoutes.playlist);
                  },
                  child: Text(
                    'Full playlist',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.rosePrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            LunaCard(
              borderColor:
                  isDark ? AppColors.darkBorder : AppColors.roseSoft,
              child: Column(
                children: List.generate(_songs.length, (index) {
                  final song = _songs[index];
                  return Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                AppColors.rosePrimary,
                                AppColors.mauvePrimary,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(AppRadius.md),
                          ),
                          alignment: Alignment.center,
                          child: const Icon(Icons.music_note,
                              color: Colors.white, size: 20),
                        ),
                        title: Text(song['title']!,
                            style: AppTypography.titleMedium),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(song['artist']!,
                                style: AppTypography.bodySmall),
                            // "Why he picked it" note in Caveat
                            Text(
                              song['why']!,
                              style: AppTypography.handwrittenSm.copyWith(
                                color: isDark
                                    ? AppColors.warmGray400
                                    : AppColors.rosePrimary,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                        isThreeLine: true,
                        trailing: const Icon(
                          Icons.favorite,
                          color: AppColors.rosePrimary,
                          size: 18,
                        ),
                        onTap: () {
                          HapticFeedback.lightImpact();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Playing ${song['title']}... 🎵'),
                            ),
                          );
                        },
                      ),
                      if (index < _songs.length - 1)
                        Divider(
                          color: isDark
                              ? AppColors.darkBorder
                              : AppColors.roseSoft,
                          height: 1,
                        ),
                    ],
                  );
                }),
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }
}
