import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:her/core/constants/app_colors.dart';
import 'package:her/core/constants/app_typography.dart';
import 'package:her/core/role/app_role.dart';
import 'package:her/core/role/role_provider.dart';
import 'package:her/core/providers/daily_content_provider.dart';

class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref.watch(currentRoleProvider);
    final isHer = role == AppRole.her;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dailyAsync = ref.watch(dailyContentProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.softIvory,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isHer
                        ? [
                            AppColors.rosePrimary.withOpacity(0.8),
                            AppColors.rosePrimary,
                          ]
                        : [
                            AppColors.slateBlue.withOpacity(0.8),
                            AppColors.slateBlue,
                          ],
                  ),
                ),
                child: Center(
                  child: Icon(
                    isHer ? Icons.auto_awesome : Icons.shield_moon,
                    size: 80,
                    color: Colors.white.withOpacity(0.2),
                  ),
                ),
              ),
              title: Text(
                "Good Morning",
                style: AppTypography.h3.copyWith(color: Colors.white),
              ),
              centerTitle: false,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  dailyAsync.when(
                    data: (data) =>
                        _DailyCard(
                              title: data['title']!,
                              content: data['content']!,
                              color: isHer
                                  ? AppColors.rosePrimary
                                  : AppColors.slateBlue,
                            )
                            .animate()
                            .fadeIn(duration: 600.ms)
                            .slideY(begin: 0.2, end: 0),
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (_, __) => const Text("Could not load daily focus."),
                  ),
                  const SizedBox(height: 24),
                  Text("Up Next", style: AppTypography.h4),
                  const SizedBox(height: 16),
                  _ActionTile(
                    label: isHer ? "Check your cycle" : "View her dashboard",
                    icon: isHer
                        ? Icons.calendar_today
                        : Icons.analytics_outlined,
                    onTap: () => context.push(isHer ? '/cycle' : '/care'),
                  ).animate().fadeIn(delay: 200.ms).slideX(begin: 0.2, end: 0),
                  const SizedBox(height: 12),
                  _ActionTile(
                    label: "Build your bucket list",
                    icon: Icons.explore_outlined,
                    onTap: () => context.push('/us'),
                  ).animate().fadeIn(delay: 400.ms).slideX(begin: 0.2, end: 0),
                  const SizedBox(height: 48),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          "Connect Deeply",
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.warmGray400,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Icon(
                          Icons.favorite,
                          color: AppColors.roseSoft,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DailyCard extends StatelessWidget {
  final String title;
  final String content;
  final Color color;
  const _DailyCard({
    required this.title,
    required this.content,
    required this.color,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.format_quote, color: color, size: 24),
              const SizedBox(width: 8),
              Text(
                title,
                style: AppTypography.labelSmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(content, style: AppTypography.bodyLarge.copyWith(height: 1.6)),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _ActionTile({
    required this.label,
    required this.icon,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.warmGray200.withOpacity(0.5)),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.rosePrimary),
            const SizedBox(width: 16),
            Expanded(child: Text(label, style: AppTypography.bodyMedium)),
            const Icon(Icons.chevron_right, color: AppColors.warmGray400),
          ],
        ),
      ),
    );
  }
}
