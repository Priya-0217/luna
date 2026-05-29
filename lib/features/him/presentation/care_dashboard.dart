import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:her/core/constants/app_colors.dart';
import 'package:her/core/constants/app_typography.dart';
import 'package:her/core/widgets/luna_card.dart';
import 'package:her/features/auth/domain/app_user.dart';
import 'package:her/features/auth/providers/auth_provider.dart';
import 'package:her/features/him/providers/partner_data_provider.dart';
import 'package:her/features/cycle/domain/cycle_entry.dart';
import 'package:her/features/cycle/domain/cycle_phase.dart';
import 'package:her/features/cycle/utils/cycle_calculator.dart';
import 'package:her/features/relationship/presentation/widgets/ping_system.dart';
import 'package:her/features/relationship/data/relationship_repository.dart';
import 'package:her/core/utils/async_value_ui.dart';

class CareDashboard extends ConsumerWidget {
  const CareDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('💙 CareDashboard: Building...');
    final partnerProfileAsync = ref.watch(partnerProfileProvider);
    final partnerEntriesAsync = ref.watch(partnerCycleEntriesProvider);

    debugPrint(
      '💙 CareDashboard: PartnerProfile State: ${partnerProfileAsync.hasValue
          ? "Loaded"
          : partnerProfileAsync.isLoading
          ? "Loading"
          : "Error"}',
    );
    debugPrint(
      '💙 CareDashboard: PartnerEntries State: ${partnerEntriesAsync.hasValue
          ? "Loaded"
          : partnerEntriesAsync.isLoading
          ? "Loading"
          : "Error"}',
    );

    return Scaffold(
      backgroundColor: AppColors.softIvory,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.softIvory,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                "Care Dashboard",
                style: AppTypography.h3.copyWith(color: AppColors.rosePrimary),
              ),
              centerTitle: false,
            ),
          ),
          SliverToBoxAdapter(
            child: partnerProfileAsync.whenWidget(
              loadingMessage: "Connecting with partner...",
              data: (partner) {
                if (partner == null) {
                  debugPrint('💙 CareDashboard: State -> No Partner Linked');
                  return const _NoPartnerState();
                }
                debugPrint(
                  '💙 CareDashboard: State -> Dashboard for ${partner.displayName}',
                );
                return _DashboardContent(
                  partner: partner,
                  entriesAsync: partnerEntriesAsync,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  final AppUser partner;
  final AsyncValue<List<CycleEntry>> entriesAsync;

  const _DashboardContent({required this.partner, required this.entriesAsync});

  @override
  Widget build(BuildContext context) {
    debugPrint('💙 DashboardContent: Building for ${partner.displayName}');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const PingSystem(),
        _PartnerStatusHeader(partner: partner),

        // Relationship Focus: Shared Journey Summary
        const _RelationshipPulse(),

        const SizedBox(height: 16),

        // Cycle Feature: Handled elegantly as an optional part of the dashboard
        _CycleSection(entriesAsync: entriesAsync),

        const SizedBox(height: 32),
      ],
    );
  }
}

class _RelationshipPulse extends ConsumerWidget {
  const _RelationshipPulse();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).valueOrNull;
    final coupleId = user?.coupleId;

    if (coupleId == null) return const SizedBox.shrink();

    return StreamBuilder<Map<String, dynamic>?>(
      stream: ref
          .watch(relationshipRepositoryProvider)
          .watchRelationship(coupleId),
      builder: (context, snapshot) {
        final relData = snapshot.data;
        if (relData == null) return const SizedBox.shrink();

        final anniversary =
            (relData['anniversary'] as dynamic)?.toDate() ??
            (relData['createdAt'] as dynamic)?.toDate() ??
            DateTime.now();
        final daysTogether = DateTime.now().difference(anniversary).inDays;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: LunaCard(
            color: AppColors.white,
            borderColor: AppColors.roseSoft.withOpacity(0.5),
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.roseSoft.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Text("👫", style: TextStyle(fontSize: 24)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$daysTogether Days of Love",
                        style: AppTypography.h4.copyWith(
                          color: AppColors.rosePrimary,
                        ),
                      ),
                      Text(
                        "Building something beautiful every day.",
                        style: AppTypography.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CycleSection extends StatelessWidget {
  final AsyncValue<List<CycleEntry>> entriesAsync;

  const _CycleSection({required this.entriesAsync});

  @override
  Widget build(BuildContext context) {
    return entriesAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(32.0),
        child: Center(
          child: CircularProgressIndicator(color: AppColors.roseSoft),
        ),
      ),
      error: (err, stack) {
        debugPrint(
          '⚠️ CareDashboard: Cycle access issue (probably permissions): $err',
        );
        return const _CyclePrivacyNotice();
      },
      data: (entries) {
        debugPrint('💙 CycleSection: Found ${entries.length} entries');
        if (entries.isEmpty) {
          return const _NoDataState();
        }

        final stats = CycleCalculator.calculate(entries);
        return Column(
          children: [
            _CurrentPhaseCard(phase: stats.phase, day: stats.dayOfCycle),
            _InsightsGrid(phase: stats.phase),
          ],
        );
      },
    );
  }
}

class _CyclePrivacyNotice extends StatelessWidget {
  const _CyclePrivacyNotice();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: LunaCard(
        color: AppColors.white,
        borderColor: AppColors.warmGray300,
        child: Column(
          children: [
            const Icon(
              Icons.lock_person_rounded,
              color: AppColors.warmGray400,
              size: 32,
            ),
            const SizedBox(height: 12),
            Text("Cycle Privacy", style: AppTypography.titleMedium),
            const SizedBox(height: 4),
            Text(
              "She hasn't shared her cycle data with the connection yet. Ask her if she'd like to link her health data for deeper insights.",
              textAlign: TextAlign.center,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.warmGray600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PartnerStatusHeader extends StatelessWidget {
  final AppUser partner;
  const _PartnerStatusHeader({required this.partner});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.roseSoft,
            child: Text(
              partner.displayName[0],
              style: AppTypography.h3.copyWith(color: Colors.white),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(partner.displayName, style: AppTypography.h4),
              Text("Connected Relationship", style: AppTypography.bodySmall),
            ],
          ),
        ],
      ),
    );
  }
}

class _CurrentPhaseCard extends StatelessWidget {
  final CyclePhase phase;
  final int day;

  const _CurrentPhaseCard({required this.phase, required this.day});

  @override
  Widget build(BuildContext context) {
    final color = CycleCalculator.getPhaseColor(phase);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            "CURRENT PHASE",
            style: AppTypography.labelSmall.copyWith(
              letterSpacing: 2,
              fontWeight: FontWeight.bold,
              color: AppColors.warmGray400,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            phase.name.toUpperCase(),
            style: AppTypography.h2.copyWith(color: color),
          ),
          const SizedBox(height: 8),
          Text("Cycle Day $day", style: AppTypography.bodyMedium),
          const SizedBox(height: 20),
          LinearProgressIndicator(
            value: day / 28,
            backgroundColor: color.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation(color),
            borderRadius: BorderRadius.circular(10),
            minHeight: 8,
          ),
        ],
      ),
    );
  }
}

class _InsightsGrid extends StatelessWidget {
  final CyclePhase phase;
  const _InsightsGrid({required this.phase});

  @override
  Widget build(BuildContext context) {
    final tips = CycleCalculator.getSupportTips(phase);
    final color = CycleCalculator.getPhaseColor(phase);
    debugPrint(
      '💙 InsightsGrid: Rendering ${tips.length} tips for phase: ${phase.name}',
    );

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("How to support her today", style: AppTypography.h4),
          const SizedBox(height: 8),
          Text(
            CycleCalculator.getPhaseDescription(phase),
            style: AppTypography.bodySmall,
          ),
          const SizedBox(height: 24),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: tips.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
            ),
            itemBuilder: (context, index) {
              final tip = tips[index];
              return _InsightCard(
                icon: tip['icon'] as IconData,
                title: tip['title'] as String,
                desc: tip['desc'] as String,
                color: color,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _InsightCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;
  final Color color;
  const _InsightCard({
    required this.icon,
    required this.title,
    required this.desc,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const Spacer(),
          Text(
            title,
            style: AppTypography.bodyLarge.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            desc,
            style: AppTypography.bodySmall,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _NoPartnerState extends ConsumerStatefulWidget {
  const _NoPartnerState();
  @override
  ConsumerState<_NoPartnerState> createState() => _NoPartnerStateState();
}

class _NoPartnerStateState extends ConsumerState<_NoPartnerState>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _pulse;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    debugPrint('💙 NoPartnerState: Initialized - Showing connection code');
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulse = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _fade = Tween<double>(
      begin: 0.6,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    debugPrint('💙 NoPartnerState: Disposed');
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).valueOrNull;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulse.value,
                child: Opacity(opacity: _fade.value, child: child),
              );
            },
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.slateBlueSoft.withOpacity(0.6),
                    AppColors.slateBluePrimary.withOpacity(0.15),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.slateBluePrimary.withOpacity(0.2),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const Icon(
                Icons.favorite_rounded,
                size: 64,
                color: AppColors.slateBluePrimary,
              ),
            ),
          ),
          const SizedBox(height: 36),
          Text(
            "Your bond is blossoming",
            style: AppTypography.h3.copyWith(
              color: AppColors.slateBluePrimary,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            "Once your partner joins, you'll see her journey here — cycle insights, moods, and how you can show up for her.",
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.warmGray600,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
          if (user?.myLoveCode != null) ...[
            const SizedBox(height: 40),
            LunaCard(
              padding: const EdgeInsets.all(24),
              color: isDark ? AppColors.darkCard : Colors.white,
              borderColor: AppColors.slateBlueMid.withOpacity(0.3),
              child: Column(
                children: [
                  Text(
                    "Your Connection Code",
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.warmGray600,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user!.myLoveCode!,
                    style: AppTypography.h3.copyWith(
                      color: AppColors.slateBluePrimary,
                      fontFamily: 'Cormorant Garamond',
                      letterSpacing: 4,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Share this with her to link your accounts",
                    textAlign: TextAlign.center,
                    style: AppTypography.bodySmall,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      final code = user.myLoveCode!;
                      debugPrint(
                        '💙 NoPartnerState: Copying code to clipboard: $code',
                      );
                      Clipboard.setData(ClipboardData(text: code));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Code copied! 💙'),
                          backgroundColor: AppColors.slateBluePrimary,
                        ),
                      );
                    },
                    icon: const Icon(Icons.copy, size: 16),
                    label: const Text("Copy Code"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.slateBluePrimary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                debugPrint(
                  '💙 NoPartnerState: Navigating to manual code entry',
                );
                context.push('/code-entry');
              },
              child: Text(
                "Have her code? Enter it here",
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.slateBluePrimary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
          const SizedBox(height: 32),
          _WaitingDots(),
        ],
      ),
    );
  }
}

class _WaitingDots extends StatefulWidget {
  @override
  State<_WaitingDots> createState() => _WaitingDotsState();
}

class _WaitingDotsState extends State<_WaitingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (i) {
            final delay = i / 3.0;
            final phase = (_ctrl.value - delay).abs();
            final scale =
                0.5 + 0.5 * math.sin(phase * math.pi * 2).clamp(0.0, 1.0);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Transform.scale(
                scale: scale,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.rosePrimary.withOpacity(0.5 + 0.5 * scale),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

class _NoDataState extends StatelessWidget {
  const _NoDataState();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            const Icon(
              Icons.hourglass_top_rounded,
              size: 48,
              color: AppColors.roseSoft,
            ),
            const SizedBox(height: 16),
            Text(
              "Waiting for her first entry",
              style: AppTypography.h4.copyWith(color: AppColors.rosePrimary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              "Her cycle insights will appear here once she starts tracking.",
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.warmGray400,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
