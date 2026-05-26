import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:her/core/constants/app_colors.dart';
import 'package:her/core/constants/app_illustrations.dart';
import 'package:her/core/constants/app_spacing.dart';
import 'package:her/core/constants/app_typography.dart';
import 'package:her/core/widgets/luna_card.dart';

class HimHomeTab extends ConsumerWidget {
  const HimHomeTab({super.key});

  Widget _buildHerMoodCard(bool isDark) {
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
                  "She's feeling calm today",
                  style: AppTypography.titleLarge.copyWith(
                    color: isDark ? AppColors.darkText : AppColors.slateBlueDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Follicular · Day 8",
                  style: AppTypography.bodySmall.copyWith(
                    color: isDark ? AppColors.warmGray400 : AppColors.warmGray600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCareTipCard(bool isDark) {
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
                'Care tip for today',
                style: AppTypography.titleMedium.copyWith(
                  color: isDark ? AppColors.darkText : AppColors.charcoal,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "She'd love a simple 'I'm thinking of you' today.",
            style: AppTypography.bodyMedium.copyWith(
              color: isDark ? AppColors.warmGray400 : AppColors.charcoal,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "She'd want you to know 💙",
            style: AppTypography.handwritten.copyWith(
              color: isDark ? AppColors.slateBlueMid : AppColors.slateBluePrimary,
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
                    color: isDark ? AppColors.darkText : AppColors.slateBlueDark,
                  ),
                ),
                Text(
                  "She left something for you ✨",
                  style: AppTypography.bodySmall.copyWith(
                    color: isDark ? AppColors.warmGray400 : AppColors.warmGray600,
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

  Widget _buildRelationshipCard(bool isDark) {
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
                  "47 days together 💕",
                  style: AppTypography.titleMedium.copyWith(
                    color: isDark ? AppColors.darkText : AppColors.roseDark,
                  ),
                ),
                Text(
                  "Couple streak: 5 days 🔥",
                  style: AppTypography.bodySmall.copyWith(
                    color: isDark ? AppColors.warmGray400 : AppColors.warmGray600,
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
              Text("Happy", style: AppTypography.bodySmall.copyWith(fontSize: 10)),
              Text("Stressed", style: AppTypography.bodySmall.copyWith(fontSize: 10)),
              Text("Tired", style: AppTypography.bodySmall.copyWith(fontSize: 10)),
              Text("Excited", style: AppTypography.bodySmall.copyWith(fontSize: 10)),
              Text("Grateful", style: AppTypography.bodySmall.copyWith(fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                      color: isDark ? AppColors.darkText : AppColors.slateBlueDark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "She made this for you",
                    style: AppTypography.bodyMedium.copyWith(
                      color: isDark ? AppColors.warmGray400 : AppColors.warmGray600,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  
                  // Cards
                  _buildHerMoodCard(isDark),
                  const SizedBox(height: AppSpacing.md),
                  _buildCareTipCard(isDark),
                  const SizedBox(height: AppSpacing.md),
                  _buildFromHerCard(isDark),
                  const SizedBox(height: AppSpacing.md),
                  _buildActionButtons(isDark),
                  const SizedBox(height: AppSpacing.md),
                  _buildRelationshipCard(isDark),
                  const SizedBox(height: AppSpacing.md),
                  _buildHisMoodQuickLog(isDark),
                  
                  const SizedBox(height: 100), // Bottom padding for navbar
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
