import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:her/core/constants/app_colors.dart';
import 'package:her/core/constants/app_illustrations.dart';
import 'package:her/core/constants/app_spacing.dart';
import 'package:her/core/constants/app_typography.dart';
import 'package:her/core/widgets/luna_card.dart';
import 'package:her/core/widgets/luna_loading.dart';
import 'package:her/features/auth/providers/auth_provider.dart';
import 'package:her/features/him/providers/partner_data_provider.dart';
import 'package:her/features/cycle/utils/cycle_calculator.dart';
import 'package:her/features/cycle/domain/cycle_phase.dart';
import 'package:her/features/relationship/data/relationship_repository.dart';

class HimHomeTab extends ConsumerWidget {
  const HimHomeTab({super.key});

  Widget _buildHerMoodCard(bool isDark, String phaseName, int cycleDay) {
    return LunaCard(
      borderColor: isDark ? AppColors.darkBorder : AppColors.slateBlueSoft,
      color: isDark ? AppColors.darkCard : AppColors.slateBlueLight,
      child: Row(
        children: [
          Image.asset(
            AppIllustrations.content,
            width: 80,
            height: 80,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => const Icon(
              Icons.favorite,
              color: AppColors.slateBluePrimary,
              size: 40,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "She's in her $phaseName phase",
                  style: AppTypography.titleLarge.copyWith(
                    color: isDark
                        ? AppColors.darkText
                        : AppColors.slateBlueDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "$phaseName · Day $cycleDay",
                  style: AppTypography.bodySmall.copyWith(
                    color: isDark
                        ? AppColors.warmGray400
                        : AppColors.warmGray600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCareTipCard(bool isDark, CyclePhase phase) {
    final tips = CycleCalculator.getSupportTips(phase);
    final description = CycleCalculator.getPhaseDescription(phase);
    final tipTitle = tips.isNotEmpty ? tips[0]['title'] : 'Be Supportive';
    final tipDesc = tips.isNotEmpty
        ? tips[0]['desc']
        : "She'd love a simple 'I'm thinking of you' today.";

    return LunaCard(
      borderColor: isDark ? AppColors.darkBorder : AppColors.goldMid,
      color: isDark ? AppColors.darkCard : AppColors.goldSoft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.star, color: AppColors.goldPrimary, size: 24),
              const SizedBox(width: 8),
              Text(
                'Care tip: $tipTitle',
                style: AppTypography.titleMedium.copyWith(
                  color: isDark ? AppColors.darkText : AppColors.charcoal,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            tipDesc,
            style: AppTypography.bodyMedium.copyWith(
              color: isDark ? AppColors.warmGray400 : AppColors.charcoal,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: AppTypography.handwritten.copyWith(
              color: isDark
                  ? AppColors.slateBlueMid
                  : AppColors.slateBluePrimary,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFromHerCard(bool isDark) {
    return LunaCard(
      borderColor: isDark ? AppColors.darkBorder : AppColors.slateBlueMid,
      color: isDark ? AppColors.darkCard : AppColors.white,
      child: Row(
        children: [
          Image.asset(
            AppIllustrations.inLove,
            width: 60,
            height: 60,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => const Icon(
              Icons.mail,
              color: AppColors.slateBluePrimary,
              size: 32,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "From Her",
                  style: AppTypography.titleMedium.copyWith(
                    color: isDark
                        ? AppColors.darkText
                        : AppColors.slateBlueDark,
                  ),
                ),
                Text(
                  "She left something for you ✨",
                  style: AppTypography.bodySmall.copyWith(
                    color: isDark
                        ? AppColors.warmGray400
                        : AppColors.warmGray600,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward, color: AppColors.slateBluePrimary),
        ],
      ),
    );
  }

  Widget _buildActionButtons(bool isDark) {
    return Row(
      children: [
        Expanded(
          child: LunaCard(
            borderColor: isDark ? AppColors.darkBorder : AppColors.goldMid,
            color: isDark ? AppColors.darkCard : AppColors.goldSoft,
            child: const Center(
              child: Text("🤗 Send\nhug", textAlign: TextAlign.center),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          flex: 2,
          child: LunaCard(
            borderColor: isDark ? AppColors.darkBorder : AppColors.slateBlueMid,
            color: isDark ? AppColors.darkCard : AppColors.slateBlueLight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.edit, color: AppColors.slateBluePrimary),
                const SizedBox(width: 8),
                Text(
                  "Write to her",
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.slateBlueDark,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRelationshipCard(bool isDark, int daysTogether) {
    return LunaCard(
      borderColor: isDark ? AppColors.darkBorder : AppColors.roseSoft,
      color: isDark ? AppColors.darkCard : AppColors.roseLight,
      child: Row(
        children: [
          const Text("👫", style: TextStyle(fontSize: 24)),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$daysTogether days together 💕",
                  style: AppTypography.titleMedium.copyWith(
                    color: isDark ? AppColors.darkText : AppColors.roseDark,
                  ),
                ),
                Text(
                  "Every day is a beautiful milestone",
                  style: AppTypography.bodySmall.copyWith(
                    color: isDark
                        ? AppColors.warmGray400
                        : AppColors.warmGray600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHisMoodQuickLog(bool isDark) {
    return LunaCard(
      borderColor: isDark ? AppColors.darkBorder : AppColors.slateBlueSoft,
      color: isDark ? AppColors.darkCard : AppColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "💙 How are YOU today?",
            style: AppTypography.titleMedium.copyWith(
              color: isDark ? AppColors.darkText : AppColors.slateBlueDark,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text("😊", style: TextStyle(fontSize: 32)),
              Text("😰", style: TextStyle(fontSize: 32)),
              Text("😴", style: TextStyle(fontSize: 32)),
              Text("🤩", style: TextStyle(fontSize: 32)),
              Text("🙏", style: TextStyle(fontSize: 32)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Happy",
                style: AppTypography.bodySmall.copyWith(fontSize: 10),
              ),
              Text(
                "Stressed",
                style: AppTypography.bodySmall.copyWith(fontSize: 10),
              ),
              Text(
                "Tired",
                style: AppTypography.bodySmall.copyWith(fontSize: 10),
              ),
              Text(
                "Excited",
                style: AppTypography.bodySmall.copyWith(fontSize: 10),
              ),
              Text(
                "Grateful",
                style: AppTypography.bodySmall.copyWith(fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('💙 HimHomeTab: Building...');
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final partnerProfileAsync = ref.watch(partnerProfileProvider);
    final partnerCycleEntriesAsync = ref.watch(partnerCycleEntriesProvider);
    final user = ref.watch(authProvider).valueOrNull;

    return partnerProfileAsync.when(
      loading: () => const Center(child: LunaLoading(width: 250, height: 180)),
      error: (e, s) {
        debugPrint('❌ HimHomeTab: Partner profile error: $e');
        return const Center(child: Text('Something didn\'t connect 💙'));
      },
      data: (partner) {
        if (partner == null) {
          debugPrint('💙 HimHomeTab: No partner found, showing invite screen');
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF1A1A3E), const Color(0xFF2A2060)]
                    : [AppColors.slateBlueLight, AppColors.slateBlueSoft],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32.0,
                    vertical: 40.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              AppColors.slateBlueSoft.withOpacity(0.7),
                              AppColors.slateBluePrimary.withOpacity(0.15),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.slateBluePrimary.withOpacity(
                                0.2,
                              ),
                              blurRadius: 30,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.favorite_rounded,
                          size: 56,
                          color: AppColors.slateBluePrimary,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        "Welcome, ${user?.displayName ?? 'Partner'} 💙",
                        style: AppTypography.displayMedium.copyWith(
                          color: isDark
                              ? AppColors.darkText
                              : AppColors.slateBlueDark,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Once your partner joins, this will be your window into her world — her cycle, her moods, and how to show up for her.",
                        style: AppTypography.bodyMedium.copyWith(
                          color: isDark
                              ? AppColors.warmGray400
                              : AppColors.warmGray600,
                          height: 1.6,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        "✨ Something beautiful is on its way",
                        style: AppTypography.handwritten.copyWith(
                          color: AppColors.slateBluePrimary,
                          fontSize: 16,
                        ),
                      ),
                      if (user?.myLoveCode != null) ...[
                        const SizedBox(height: 40),
                        LunaCard(
                          padding: const EdgeInsets.all(24),
                          color: isDark
                              ? AppColors.darkCard
                              : Colors.white.withOpacity(0.9),
                          borderColor: isDark
                              ? AppColors.darkBorder
                              : AppColors.slateBlueMid.withOpacity(0.3),
                          child: Column(
                            children: [
                              Text(
                                "Your Connection Code",
                                style: AppTypography.labelSmall.copyWith(
                                  color: isDark
                                      ? AppColors.warmGray400
                                      : AppColors.warmGray600,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                user!.myLoveCode!,
                                style: AppTypography.displayMedium.copyWith(
                                  color: AppColors.slateBluePrimary,
                                  fontFamily: 'Cormorant Garamond',
                                  letterSpacing: 2,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                "Share this with her so she can connect with you",
                                textAlign: TextAlign.center,
                                style: AppTypography.bodySmall.copyWith(
                                  color: isDark
                                      ? AppColors.warmGray400
                                      : AppColors.warmGray600,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      Clipboard.setData(
                                        ClipboardData(text: user.myLoveCode!),
                                      );
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: const Text(
                                            'Code copied to clipboard! 💙',
                                          ),
                                          behavior: SnackBarBehavior.floating,
                                          backgroundColor:
                                              AppColors.slateBluePrimary,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.copy, size: 16),
                                    label: const Text("Copy Code"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          AppColors.slateBluePrimary,
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () => context.push('/code-entry'),
                          child: Text(
                            "Have her code? Enter it here",
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.slateBluePrimary,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        // Main Dashboard View when partner is linked
        final entries = partnerCycleEntriesAsync.value ?? [];
        final stats = entries.isNotEmpty
            ? CycleCalculator.calculate(entries)
            : null;
        final phaseName = stats != null
            ? stats.phase.name[0].toUpperCase() + stats.phase.name.substring(1)
            : "Relationship";

        final coupleId = user?.coupleId;

        return StreamBuilder<Map<String, dynamic>?>(
          stream: coupleId != null
              ? ref
                    .watch(relationshipRepositoryProvider)
                    .watchRelationship(coupleId)
              : null,
          builder: (context, snapshot) {
            final relData = snapshot.data;
            final anniversary =
                (relData?['anniversary'] as dynamic)?.toDate() ??
                (relData?['createdAt'] as dynamic)?.toDate() ??
                DateTime.now();
            final daysTogether = DateTime.now().difference(anniversary).inDays;

            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [const Color(0xFF1A1A3E), const Color(0xFF2A2060)]
                      : [AppColors.slateBlueLight, AppColors.slateBlueSoft],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          // Header
                          Text(
                            "Good morning, Partner 💙",
                            style: AppTypography.displayMedium.copyWith(
                              color: isDark
                                  ? AppColors.darkText
                                  : AppColors.slateBlueDark,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Building a beautiful journey with ${partner.displayName}",
                            style: AppTypography.bodySmall.copyWith(
                              color: isDark
                                  ? AppColors.warmGray400
                                  : AppColors.warmGray600,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xxl),

                          // Cycle Info (Only if entries exist and no error)
                          if (stats != null) ...[
                            _buildHerMoodCard(
                              isDark,
                              phaseName,
                              stats.dayOfCycle,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            _buildCareTipCard(isDark, stats.phase),
                            const SizedBox(height: AppSpacing.md),
                          ] else if (partnerCycleEntriesAsync.hasError) ...[
                            _buildCyclePrivacyCard(isDark),
                            const SizedBox(height: AppSpacing.md),
                          ] else if (partnerCycleEntriesAsync.isLoading) ...[
                            const Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            const SizedBox(height: AppSpacing.md),
                          ] else ...[
                            _buildWaitingForDataCard(isDark),
                            const SizedBox(height: AppSpacing.md),
                          ],

                          _buildFromHerCard(isDark),
                          const SizedBox(height: AppSpacing.md),
                          _buildActionButtons(isDark),
                          const SizedBox(height: AppSpacing.md),
                          _buildRelationshipCard(isDark, daysTogether),
                          const SizedBox(height: AppSpacing.md),
                          _buildHisMoodQuickLog(isDark),

                          const SizedBox(height: 100),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCyclePrivacyCard(bool isDark) {
    return LunaCard(
      borderColor: isDark ? AppColors.darkBorder : AppColors.slateBlueSoft,
      color: isDark ? AppColors.darkCard : Colors.white.withOpacity(0.5),
      child: Row(
        children: [
          const Icon(
            Icons.lock_person_rounded,
            color: AppColors.slateBluePrimary,
            size: 32,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              "She hasn't linked her health data yet. You'll see her cycle phases here once she does! ✨",
              style: AppTypography.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWaitingForDataCard(bool isDark) {
    return LunaCard(
      borderColor: isDark ? AppColors.darkBorder : AppColors.slateBlueSoft,
      color: isDark ? AppColors.darkCard : Colors.white.withOpacity(0.5),
      child: Row(
        children: [
          const Icon(
            Icons.hourglass_empty_rounded,
            color: AppColors.slateBluePrimary,
            size: 32,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              "Waiting for her first cycle entry to provide care insights! 🌸",
              style: AppTypography.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
