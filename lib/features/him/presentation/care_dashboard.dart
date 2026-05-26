import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:her/core/constants/app_colors.dart';
import 'package:her/core/constants/app_typography.dart';
import 'package:her/features/auth/domain/app_user.dart';
import 'package:her/features/auth/providers/auth_provider.dart';
import 'package:her/features/him/providers/partner_data_provider.dart';
import 'package:her/features/cycle/domain/cycle_entry.dart';
import 'package:her/features/cycle/domain/cycle_phase.dart';
import 'package:her/features/cycle/utils/cycle_calculator.dart';
import 'package:her/features/relationship/presentation/widgets/ping_system.dart';
import 'package:her/core/utils/async_value_ui.dart';

class CareDashboard extends ConsumerWidget {
  const CareDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final partnerProfileAsync = ref.watch(partnerProfileProvider);
    final partnerEntriesAsync = ref.watch(partnerCycleEntriesProvider);

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
              data: (partner) => partner == null
                  ? const _NoPartnerState()
                  : _DashboardContent(
                      partner: partner,
                      entriesAsync: partnerEntriesAsync,
                    ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const PingSystem(),
        _PartnerStatusHeader(partner: partner),
        entriesAsync.whenWidget(
          loadingMessage: "Retrieving her cycle data...",
          data: (entries) {
            if (entries.isEmpty) return const _NoDataState();
            final stats = CycleCalculator.calculate(entries);

            return Column(
              children: [
                _CurrentPhaseCard(phase: stats.phase, day: stats.dayOfCycle),
                _InsightsGrid(phase: stats.phase),
              ],
            );
          },
        ),
      ],
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

class _NoPartnerState extends StatelessWidget {
  const _NoPartnerState();
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 64.0),
        child: Column(
          children: [
            Icon(Icons.people_outline, size: 80, color: AppColors.warmGray300),
            SizedBox(height: 24),
            Text("No partner linked yet."),
          ],
        ),
      ),
    );
  }
}

class _NoDataState extends StatelessWidget {
  const _NoDataState();
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Partner hasn't logged any data yet."));
  }
}
