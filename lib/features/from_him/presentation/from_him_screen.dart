import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:her/core/constants/app_colors.dart';
import 'package:her/core/constants/app_radius.dart';
import 'package:her/core/constants/app_shadows.dart';
import 'package:her/core/constants/app_spacing.dart';
import 'package:her/core/constants/app_typography.dart';
import 'package:her/core/widgets/luna_card.dart';
import 'package:her/core/widgets/luna_button.dart';
import 'package:her/core/router/app_routes.dart';

class FromHimScreen extends StatefulWidget {
  const FromHimScreen({super.key});

  @override
  State<FromHimScreen> createState() => _FromHimScreenState();
}

class _FromHimScreenState extends State<FromHimScreen> with SingleTickerProviderStateMixin {
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
          const SnackBar(
            content: Text('Envelope of love received 💕 Feel better, beautiful!'),
            backgroundColor: AppColors.rosePrimary,
          ),
        );
      }
    });
  }

  // Letters timeline mock
  final List<Map<String, String>> letters = [
    {'id': 'cramps', 'title': 'Read during cramps ⚡', 'desc': 'Open this when your body hurts and you need comfort.'},
    {'id': 'sad', 'title': 'Read when down 🌧️', 'desc': 'A soft note to dry your tears and hold you tight.'},
    {'id': 'sunny', 'title': 'Read when happy ☀️', 'desc': 'Celebrate the sunshine together.'},
    {'id': 'argument', 'title': 'Read after an argument 🌸', 'desc': 'Because nothing can stand between us.'},
    {'id': 'miss_me', 'title': 'Read when you miss me 💕', 'desc': 'To remind you how close I really am.'},
  ];

  // Polaroid memories mock
  final List<Map<String, String>> memories = [
    {'title': 'Our first sunset 🌅', 'date': 'Oct 12, 2025'},
    {'title': 'Rainy coffee day ☕', 'date': 'Nov 04, 2025'},
    {'title': 'Walking in the park 🌳', 'date': 'Dec 25, 2025'},
  ];

  // Songs list mock
  final List<Map<String, String>> songs = [
    {'title': 'Perfect', 'artist': 'Ed Sheeran', 'mood': 'Romantic'},
    {'title': 'Love Story', 'artist': 'Taylor Swift', 'mood': 'Sweet'},
    {'title': 'Say You Won\'t Let Go', 'artist': 'James Arthur', 'mood': 'Cozy'},
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

            // Pulsating Hug Button
            LunaCard(
              borderColor: isDark ? AppColors.darkBorder : AppColors.roseSoft,
              child: Column(
                children: [
                  Text(
                    _isHugging ? 'Holding you close... 💕' : 'Need a squeeze? 🧸',
                    style: AppTypography.titleLarge.copyWith(
                      color: isDark ? AppColors.darkText : AppColors.roseDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Tap to trigger a virtual, long warm hug sent directly from him.',
                    textAlign: TextAlign.center,
                    style: AppTypography.bodySmall,
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        if (_isHugging)
                          AnimatedBuilder(
                            animation: _hugController,
                            builder: (context, child) {
                              return Container(
                                width: 90 + (60 * _hugController.value),
                                height: 90 + (60 * _hugController.value),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.rosePrimary.withOpacity(0.25 * (1.0 - _hugController.value)),
                                ),
                              );
                            },
                          ),
                        GestureDetector(
                          onTap: _triggerHug,
                          child: Container(
                            width: 90,
                            height: 90,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [AppColors.rosePrimary, AppColors.roseDeep],
                              ),
                              boxShadow: [
                                BoxShadow(color: AppColors.roseSoft, blurRadius: 12, spreadRadius: 2),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              '🫂',
                              style: TextStyle(fontSize: 36),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Envelopes List
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
                  'Unlocks on mood check',
                  style: AppTypography.bodySmall.copyWith(color: AppColors.warmGray600),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: letters.length,
                itemBuilder: (context, index) {
                  final letter = letters[index];
                  return Container(
                    width: 220,
                    margin: const EdgeInsets.only(right: 12),
                    child: LunaCard(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        context.pushNamed(
                          AppRoutes.envelope,
                          pathParameters: {'id': letter['id']!},
                        );
                      },
                      color: isDark ? AppColors.darkCard : AppColors.goldSoft,
                      borderColor: isDark ? AppColors.darkBorder : AppColors.goldMid,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('✉️', style: TextStyle(fontSize: 28)),
                          const SizedBox(height: 6),
                          Text(
                            letter['title']!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.handwrittenLg.copyWith(
                              color: isDark ? AppColors.goldMid : AppColors.roseDark,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            letter['desc']!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.handwritten.copyWith(
                              fontSize: 12,
                              color: isDark ? AppColors.warmGray400 : AppColors.charcoal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Memories Polaroid grid
            Text(
              'Polaroid Memories 📸',
              style: AppTypography.titleLarge.copyWith(
                color: isDark ? AppColors.darkText : AppColors.roseDark,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.85,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: memories.length,
              itemBuilder: (context, index) {
                final mem = memories[index];

                return Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    border: Border.all(color: AppColors.roseSoft, width: 1.0),
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: AppShadows.subtleShadow,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Photo placeholder
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.roseSoft.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          alignment: Alignment.center,
                          child: const Icon(Icons.photo_outlined, color: AppColors.rosePrimary, size: 36),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        mem['title']!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.handwritten.copyWith(
                          color: AppColors.charcoal,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        mem['date']!,
                        style: GoogleFonts.dmSans(
                          fontSize: 9,
                          color: AppColors.warmGray600,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: AppSpacing.lg),

            // Playlist songs row
            Text(
              'Comfort Playlist 🎵',
              style: AppTypography.titleLarge.copyWith(
                color: isDark ? AppColors.darkText : AppColors.roseDark,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            LunaCard(
              borderColor: isDark ? AppColors.darkBorder : AppColors.roseSoft,
              child: Column(
                children: List.generate(songs.length, (index) {
                  final song = songs[index];
                  return Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.rosePrimary.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(AppRadius.md),
                          ),
                          alignment: Alignment.center,
                          child: const Icon(Icons.play_arrow, color: AppColors.rosePrimary),
                        ),
                        title: Text(song['title']!, style: AppTypography.titleMedium),
                        subtitle: Text('${song['artist']} • ${song['mood']}', style: AppTypography.bodySmall),
                        trailing: const Icon(Icons.favorite, color: AppColors.rosePrimary, size: 20),
                        onTap: () {
                          HapticFeedback.lightImpact();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Playing ${song['title']}... 🎵')),
                          );
                        },
                      ),
                      if (index < songs.length - 1) const Divider(),
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
