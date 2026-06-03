// lib/features/music/screens/music_search_screen.dart

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:her/core/constants/app_colors.dart';
import 'package:her/features/auth/providers/auth_provider.dart';
import '../controller/music_controller.dart';
import '../models/player_mode.dart';
import '../widgets/music_search_sheet.dart';

class MusicSearchScreen extends ConsumerStatefulWidget {
  const MusicSearchScreen({super.key});

  @override
  ConsumerState<MusicSearchScreen> createState() => _MusicSearchScreenState();
}

class _MusicSearchScreenState extends ConsumerState<MusicSearchScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = ref.read(musicControllerProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = ref.watch(authProvider).valueOrNull;
    final isHim = user?.role == 'him';
    final themeColor = isHim ? AppColors.slateBluePrimary : AppColors.rosePrimary;

    final creamBackground = const Color(0xFFF5F0EA);
    final deepBlack = const Color(0xFF0A0A0A);

    return Scaffold(
      backgroundColor: isDark ? deepBlack : creamBackground,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Premium App Bar ──
          SliverAppBar(
            expandedHeight: 140,
            floating: true,
            pinned: true,
            elevation: 0,
            backgroundColor: isDark ? deepBlack : creamBackground,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: false,
              titlePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              title: Text(
                'Explore Music',
                style: GoogleFonts.dmSerifDisplay(
                  color: isDark ? Colors.white : Colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // ── Search & Suggestions ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   // Search Bar
                  GestureDetector(
                    onTap: () => _openSearchSheet(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.04),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: isDark ? Colors.white12 : Colors.black.withOpacity(0.05)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.search, color: isDark ? Colors.white38 : Colors.black38, size: 22),
                          const SizedBox(width: 12),
                          Text(
                            'Search for songs, artists...',
                            style: TextStyle(color: isDark ? Colors.white38 : Colors.black38, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),
                  
                  _SectionHeader(title: 'Recommended for You', themeColor: themeColor),
                  const SizedBox(height: 16),
                  _MusicGrid(
                    items: [
                      _MockMusicItem(title: "The boy is mine", artist: "Ariana Grande", thumb: "https://i.ytimg.com/vi/qZ9vW9uXm_E/hqdefault.jpg"),
                      _MockMusicItem(title: "we can't be friends", artist: "Ariana Grande", thumb: "https://i.ytimg.com/vi/KNtJGQkC-WI/hqdefault.jpg"),
                      _MockMusicItem(title: "Espresso", artist: "Sabrina Carpenter", thumb: "https://i.ytimg.com/vi/ep2I73V3eW4/hqdefault.jpg"),
                      _MockMusicItem(title: "Fortnight", artist: "Taylor Swift", thumb: "https://i.ytimg.com/vi/q3zqJs7HaEs/hqdefault.jpg"),
                    ],
                    onTap: (item) {
                      controller.setMode(PlayerMode.fullScreen);
                    },
                  ),

                  const SizedBox(height: 32),
                  _SectionHeader(title: 'Shared with Partner', themeColor: themeColor),
                  const SizedBox(height: 16),
                  _SharedPlaylist(themeColor: themeColor),
                  
                  const SizedBox(height: 100), // Spacing for miniplayer
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openSearchSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const MusicSearchSheet(),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final Color themeColor;

  const _SectionHeader({required this.title, required this.themeColor});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        Text(
          'See all',
          style: TextStyle(color: themeColor, fontWeight: FontWeight.w600, fontSize: 13),
        ),
      ],
    );
  }
}

class _MusicGrid extends StatelessWidget {
  final List<_MockMusicItem> items;
  final Function(_MockMusicItem) onTap;

  const _MusicGrid({required this.items, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 20,
        crossAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return GestureDetector(
          onTap: () => onTap(item),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(image: CachedNetworkImageProvider(item.thumb), fit: BoxFit.cover),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                item.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              Text(
                item.artist,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SharedPlaylist extends StatelessWidget {
  final Color themeColor;

  const _SharedPlaylist({required this.themeColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [themeColor.withOpacity(0.8), themeColor.withOpacity(0.4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            bottom: -20,
            child: Icon(Icons.favorite, color: Colors.white.withOpacity(0.1), size: 160),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Our Little Galaxy 🌌',
                  style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  '124 tracks shared with your partner',
                  style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: themeColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Sync Now', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MockMusicItem {
  final String title;
  final String artist;
  final String thumb;
  _MockMusicItem({required this.title, required this.artist, required this.thumb});
}
