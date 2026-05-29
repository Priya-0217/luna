import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:her/core/constants/app_colors.dart';
import 'package:her/core/constants/app_illustrations.dart';
import 'package:her/core/constants/app_radius.dart';
import 'package:her/core/constants/app_spacing.dart';
import 'package:her/core/constants/app_typography.dart';
import 'package:her/core/widgets/luna_card.dart';
import 'package:her/core/router/app_routes.dart';
import 'package:her/features/auth/providers/auth_provider.dart';

class FromHerScreen extends ConsumerStatefulWidget {
  const FromHerScreen({super.key});

  @override
  ConsumerState<FromHerScreen> createState() => _FromHerScreenState();
}

class _FromHerScreenState extends ConsumerState<FromHerScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _sparkleController;
  bool _isAppreciating = false;

  @override
  void initState() {
    super.initState();
    debugPrint('💙 FromHerScreen: Initialized');
    _sparkleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    debugPrint('💙 FromHerScreen: Disposed');
    _sparkleController.dispose();
    super.dispose();
  }

  void _triggerAppreciation() {
    debugPrint('💙 FromHerScreen: Triggering appreciation sparks');
    HapticFeedback.mediumImpact();
    setState(() => _isAppreciating = true);
    _sparkleController.repeat();

    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _isAppreciating = false;
          _sparkleController.stop();
          _sparkleController.reset();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Text('✨  ', style: TextStyle(fontSize: 18)),
                Expanded(
                  child: Text(
                    'Appreciation sparks sent directly to her! 🌸',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: AppColors.slateBluePrimary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
          ),
        );
      }
    });
  }

  Widget _buildMiniProfile(String name, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: color,
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : '?',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            name,
            style: GoogleFonts.cormorantGaramond(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // Letters written by her
  final List<Map<String, String>> _letters = [
    {
      'id': 'him_stressed',
      'title': 'Read when stressed 🌪️',
      'desc': 'A gentle note to help you unwind and take a deep breath.',
      'seal': '🌸',
    },
    {
      'id': 'him_tired',
      'title': 'Read when exhausted 😴',
      'desc': 'A cozy reminder that I am proud of your hard work.',
      'seal': '🌙',
    },
    {
      'id': 'him_happy',
      'title': 'Read when joyful 🎉',
      'desc': 'Share the absolute sunshine of your day with me!',
      'seal': '✨',
    },
    {
      'id': 'him_missing',
      'title': 'Read when you miss me 🫂',
      'desc': 'Open this to feel like I am holding your hand.',
      'seal': '💕',
    },
  ];

  // Polaroid memories shared by her
  final List<Map<String, dynamic>> _memories = [
    {'title': 'Beach picnic 🧺', 'date': 'Sep 08, 2025', 'tilt': 1.8},
    {'title': 'Amusement park 🎡', 'date': 'Oct 22, 2025', 'tilt': -2.2},
    {'title': 'Cozy winter cocoa ☕', 'date': 'Dec 18, 2025', 'tilt': 1.2},
  ];

  // Songs she shared with him
  final List<Map<String, String>> _songs = [
    {
      'title': 'Thinking Out Loud',
      'artist': 'Ed Sheeran',
      'why': 'This always makes me think of our slow dances.',
    },
    {
      'title': 'Make You Feel My Love',
      'artist': 'Adele',
      'why': 'To remind you I\'m always here standing by you.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = ref.watch(authProvider).valueOrNull;
    final partnerName = user?.partnerDisplayName ?? 'Her';

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.roseLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'From ${partnerName} 💌',
                          style: AppTypography.displayLarge.copyWith(
                            color: isDark
                                ? AppColors.darkText
                                : AppColors.roseDark,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Letters, playlists, and cozy surprises sent by Her, just for you.',
                          style: AppTypography.bodySmall.copyWith(
                            color: isDark
                                ? AppColors.warmGray400
                                : AppColors.warmGray600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildMiniProfile(partnerName, AppColors.rosePrimary),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),

              // ── Quick Appreciation / Spark Widget ───────────────────────
              LunaCard(
                color: isDark ? AppColors.darkCard : AppColors.white,
                borderColor: isDark ? AppColors.darkBorder : AppColors.roseSoft,
                child: Column(
                  children: [
                    Text(
                      _isAppreciating
                          ? 'Sending warm sparks... ✨'
                          : 'Show her some love! 🌸',
                      style: AppTypography.titleLarge.copyWith(
                        color: isDark ? AppColors.darkText : AppColors.roseDark,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Tap to send a sparkle overlay of appreciation directly to her device.',
                      textAlign: TextAlign.center,
                      style: AppTypography.bodySmall.copyWith(
                        color: isDark
                            ? AppColors.warmGray400
                            : AppColors.warmGray600,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          if (_isAppreciating)
                            AnimatedBuilder(
                              animation: _sparkleController,
                              builder: (context, child) {
                                return Container(
                                  width: 90 + (70 * _sparkleController.value),
                                  height: 90 + (70 * _sparkleController.value),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.rosePrimary.withOpacity(
                                      0.3 * (1.0 - _sparkleController.value),
                                    ),
                                  ),
                                );
                              },
                            ),
                          GestureDetector(
                            onTap: _triggerAppreciation,
                            child: Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  colors: [
                                    AppColors.slateBluePrimary,
                                    AppColors.rosePrimary,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.slateBluePrimary
                                        .withOpacity(0.35),
                                    blurRadius: 16,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                '🌸',
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
                    'Secret Letters ✉️',
                    style: AppTypography.titleLarge.copyWith(
                      color: isDark
                          ? AppColors.darkText
                          : AppColors.slateBlueDark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Tap to open',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.warmGray600,
                    ),
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
                          color: isDark ? AppColors.darkCard : AppColors.white,
                          borderRadius: BorderRadius.circular(AppRadius.lg),
                          border: Border.all(
                            color: isDark
                                ? AppColors.darkBorder
                                : AppColors.slateBlueSoft.withOpacity(0.6),
                            width: 0.8,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.slateBluePrimary.withOpacity(
                                0.08,
                              ),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('✉️', style: TextStyle(fontSize: 26)),
                            Text(
                              letter['title']!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.handwrittenLg.copyWith(
                                color: isDark
                                    ? AppColors.goldMid
                                    : AppColors.slateBlueDark,
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
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.slateBluePrimary,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.slateBluePrimary
                                          .withOpacity(0.3),
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
                      color: isDark
                          ? AppColors.darkText
                          : AppColors.slateBlueDark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.pushNamed(AppRoutes.memoryGallery),
                    child: Text(
                      'View all',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.slateBluePrimary,
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
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.slateBlueSoft.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(2),
                              ),
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.photo_camera_outlined,
                                color: AppColors.slateBluePrimary.withOpacity(
                                  0.6,
                                ),
                                size: 32,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
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

              // ── Curated Playlists ──────────────────────────────────────
              Text(
                'Curated Playlists 🎵',
                style: AppTypography.titleLarge.copyWith(
                  color: isDark ? AppColors.darkText : AppColors.slateBlueDark,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              LunaCard(
                borderColor: isDark
                    ? AppColors.darkBorder
                    : AppColors.slateBlueSoft,
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
                                  AppColors.slateBluePrimary,
                                  AppColors.rosePrimary,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(AppRadius.md),
                            ),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.music_note,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          title: Text(
                            song['title']!,
                            style: AppTypography.titleMedium,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                song['artist']!,
                                style: AppTypography.bodySmall,
                              ),
                              Text(
                                song['why']!,
                                style: AppTypography.handwrittenSm.copyWith(
                                  color: isDark
                                      ? AppColors.warmGray400
                                      : AppColors.slateBluePrimary,
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
                                content: Text('Playing ${song['title']}... 🎵'),
                              ),
                            );
                          },
                        ),
                        if (index < _songs.length - 1)
                          Divider(
                            color: isDark
                                ? AppColors.darkBorder
                                : AppColors.slateBlueSoft,
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
      ),
    );
  }
}
