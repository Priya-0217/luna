import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:her/core/constants/app_colors.dart';
import 'package:her/core/router/app_routes.dart';
import 'package:her/features/auth/providers/auth_provider.dart';
import 'package:her/features/auth/domain/app_user.dart';
import 'package:her/features/relationship/data/relationship_repository.dart';
import 'package:her/features/relationship/domain/memory.dart';

class RelationshipScreen extends ConsumerWidget {
  const RelationshipScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('💙 RelationshipScreen: Building...');
    final user = ref.watch(authProvider).valueOrNull;

    if (user == null || !user.isLinked || user.coupleId == null) {
      debugPrint('💙 RelationshipScreen: User not linked or no coupleId');
      return const RelationshipWaitingScreen();
    }

    return Scaffold(
      backgroundColor: AppColors.ivory,
      body: StreamBuilder<Map<String, dynamic>?>(
        stream: ref
            .watch(relationshipRepositoryProvider)
            .watchRelationship(user.coupleId!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data;
          if (data == null) {
            debugPrint(
              '💙 RelationshipScreen: No relationship data found for ${user.coupleId}',
            );
            return const Center(child: Text('Relationship document not found'));
          }

          final anniversary =
              (data['anniversary'] as dynamic)?.toDate() ?? DateTime.now();
          final daysTogether = DateTime.now().difference(anniversary).inDays;
          debugPrint('💙 RelationshipScreen: Days together: $daysTogether');

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 180,
                pinned: true,
                backgroundColor: AppColors.ivory,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text(
                    'Our Story',
                    style: GoogleFonts.cormorantGaramond(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                      color: AppColors.charcoal,
                    ),
                  ),
                  background: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              AppColors.roseLight.withOpacity(0.8),
                              AppColors.ivory,
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        right: -20,
                        top: -20,
                        child: Icon(
                          Icons.favorite,
                          size: 200,
                          color: AppColors.roseMid.withOpacity(0.05),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      _buildProfilesHeader(context, user),
                      const SizedBox(height: 24),
                      _buildDaysCounter(context, daysTogether),
                      const SizedBox(height: 32),
                      _buildSharedFeaturesGrid(context),
                      const SizedBox(height: 32),
                      _buildRecentMemoriesHeader(context, ref),
                    ],
                  ),
                ),
              ),
              const SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                sliver: _MemoriesList(),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProfilesHeader(BuildContext context, AppUser user) {
    final isHer = user.role == 'her';
    final herName = isHer
        ? user.displayName
        : (user.partnerDisplayName ?? 'Her');
    final himName = !isHer
        ? user.displayName
        : (user.partnerDisplayName ?? 'Him');

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildProfileItem(herName, 'HER 🌸', AppColors.rosePrimary),
        Container(
          height: 1,
          width: 40,
          color: AppColors.goldMid.withOpacity(0.5),
        ),
        _buildProfileItem(himName, 'HIM 💙', AppColors.slateBluePrimary),
      ],
    );
  }

  Widget _buildProfileItem(String name, String label, Color color) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.white,
            border: Border.all(color: color.withOpacity(0.3), width: 2),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.1),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: CircleAvatar(
              radius: 36,
              backgroundColor: color.withOpacity(0.05),
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : '?',
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          name.toUpperCase(),
          style: GoogleFonts.dmSans(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
            color: AppColors.charcoal,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.dmSans(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: AppColors.warmGray600,
          ),
        ),
      ],
    );
  }

  Widget _buildDaysCounter(BuildContext context, int days) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.charcoal.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'LUNA HEARTS',
            style: GoogleFonts.dmSans(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
              color: AppColors.goldPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$days',
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 72,
                  fontWeight: FontWeight.bold,
                  color: AppColors.charcoal,
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'DAYS',
                    style: GoogleFonts.dmSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                      color: AppColors.warmGray600,
                    ),
                  ),
                  Text(
                    'TOGETHER',
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.goldPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSharedFeaturesGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        GestureDetector(
          onTap: () => context.pushNamed(AppRoutes.bucketList),
          child: _buildFeatureCard(
            context,
            'Bucket List',
            Icons.auto_awesome,
            AppColors.mauvePrimary,
          ),
        ),
        _buildFeatureCard(
          context,
          'Questions',
          Icons.chat_bubble_outline,
          AppColors.slateBlue,
        ),
        _buildFeatureCard(
          context,
          'Mood Board',
          Icons.grid_view,
          AppColors.rosePrimary,
        ),
        _buildFeatureCard(
          context,
          'Our Songs',
          Icons.music_note,
          AppColors.mauveMid,
        ),
      ],
    );
  }

  Widget _buildFeatureCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.dmSans(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.darkText.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentMemoriesHeader(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Our Memories',
          style: GoogleFonts.cormorantGaramond(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.darkText,
          ),
        ),
        TextButton(
          onPressed: () => _showAddMemoryDialog(context, ref),
          child: Text(
            '+ Add Memory',
            style: TextStyle(color: AppColors.rosePrimary),
          ),
        ),
      ],
    );
  }

  void _showAddMemoryDialog(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();
    final descController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.white,
        title: Text(
          'Capture a Moment',
          style: GoogleFonts.cormorantGaramond(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Title (e.g., First Date)',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: 'Note (Optional)'),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final user = ref.read(authProvider).valueOrNull;
              if (user?.coupleId != null && titleController.text.isNotEmpty) {
                await ref
                    .read(relationshipRepositoryProvider)
                    .addMemory(
                      user!.coupleId!,
                      Memory(
                        title: titleController.text,
                        description: descController.text.isNotEmpty
                            ? descController.text
                            : null,
                        imageUrl: '',
                        addedBy: user.uid,
                        createdAt: DateTime.now(),
                      ),
                    );
                if (context.mounted) Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.rosePrimary,
            ),
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _MemoriesList extends ConsumerWidget {
  const _MemoriesList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).valueOrNull;
    if (user?.coupleId == null)
      return const SliverToBoxAdapter(child: SizedBox());

    return StreamBuilder<List<Memory>>(
      stream: ref
          .watch(relationshipRepositoryProvider)
          .watchMemories(user!.coupleId!),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(40),
              child: Column(
                children: [
                  Icon(
                    Icons.photo_library_outlined,
                    size: 48,
                    color: AppColors.roseSoft,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No memories yet.\nRecord your first moment together.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.dmSans(
                      color: AppColors.mauvePrimary.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final memories = snapshot.data!;
        return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final memory = memories[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.roseLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.favorite,
                      color: AppColors.rosePrimary.withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          memory.title,
                          style: GoogleFonts.dmSans(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          memory.description ?? '',
                          style: GoogleFonts.dmSans(
                            fontSize: 13,
                            color: AppColors.darkText.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }, childCount: memories.length),
        );
      },
    );
  }
}

class RelationshipWaitingScreen extends StatelessWidget {
  const RelationshipWaitingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Us',
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: AppColors.rosePrimary,
                ),
              ),
              const SizedBox(height: 24),
              const Icon(
                Icons.favorite_border,
                size: 64,
                color: AppColors.roseSoft,
              ),
              const SizedBox(height: 24),
              Text(
                'This space is just for the two of you.',
                textAlign: TextAlign.center,
                style: GoogleFonts.dmSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColors.darkText,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Connect with your partner to unlock shared memories, bucket lists, and more.',
                textAlign: TextAlign.center,
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  color: AppColors.darkText.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  // TODO: Navigate to linking screen or show code entry modal
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.rosePrimary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Connect Now'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
