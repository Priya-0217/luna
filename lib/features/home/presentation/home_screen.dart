import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:her/core/constants/app_colors.dart';
import 'package:her/core/constants/app_illustrations.dart';
import 'package:her/core/constants/app_radius.dart';
import 'package:her/core/constants/app_spacing.dart';
import 'package:her/core/constants/app_typography.dart';
import 'package:her/core/widgets/animated_gradient_bg.dart';
import 'package:her/core/widgets/floating_particles.dart';
import 'package:her/core/widgets/luna_card.dart';
import 'package:her/core/widgets/luna_button.dart';
import 'package:her/core/widgets/luna_loading.dart';
import 'package:her/core/widgets/phase_ring.dart';
import 'package:her/core/router/app_routes.dart';
import 'package:her/core/services/suggestion_service.dart';
import 'package:her/core/role/app_role.dart';
import 'package:her/features/auth/providers/auth_provider.dart';
import 'package:her/features/home/domain/cycle_phase.dart';
import 'package:her/features/home/providers/dashboard_provider.dart';

class HomeScreen extends ConsumerWidget {
  final Widget child;

  const HomeScreen({super.key, required this.child});

  int _calculateSelectedIndex(BuildContext context, AppRole role) {
    final String location = GoRouterState.of(context).uri.toString();
    if (role == AppRole.her) {
      if (location.startsWith('/cycle')) return 1;
      if (location.startsWith('/garden')) return 2;
      if (location.startsWith('/from-him')) return 3;
      if (location.startsWith('/profile')) return 4;
    } else {
      if (location.startsWith('/him/care')) return 1;
      if (location.startsWith('/garden')) return 2;
      if (location.startsWith('/from-her')) return 3;
      if (location.startsWith('/us')) return 4;
      if (location.startsWith('/profile')) return 5;
    }
    return 0;
  }

  void _onItemTapped(int index, BuildContext context, AppRole role) {
    if (role == AppRole.her) {
      switch (index) {
        case 0:
          context.goNamed(AppRoutes.home);
          break;
        case 1:
          context.goNamed(AppRoutes.cycle);
          break;
        case 2:
          context.goNamed(AppRoutes.garden);
          break;
        case 3:
          context.goNamed(AppRoutes.fromHim);
          break;
        case 4:
          context.goNamed(AppRoutes.profile);
          break;
      }
    } else {
      switch (index) {
        case 0:
          context.goNamed(AppRoutes.home);
          break;
        case 1:
          context.goNamed(AppRoutes.himCare);
          break;
        case 2:
          context.goNamed(AppRoutes.garden);
          break;
        case 3:
          context.goNamed(AppRoutes.fromHer);
          break;
        case 4:
          context.goNamed(AppRoutes.us);
          break;
        case 5:
          context.goNamed(AppRoutes.profile);
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Default to Her if undefined
    final user = ref.watch(authProvider).valueOrNull;
    final role = user?.role == 'him' ? AppRole.him : AppRole.her;

    final currentIndex = _calculateSelectedIndex(context, role);
    final isHim = role == AppRole.him;

    // Use specific loading states or error boundaries if profile is still loading
    if (user == null) {
      return const Scaffold(
        body: Center(child: LunaLoading(width: 250, height: 180)),
      );
    }

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : (isHim ? AppColors.slateBlueLight : AppColors.roseLight),
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.white,
          border: Border(
            top: BorderSide(
              color: isDark
                  ? AppColors.darkBorder
                  : (isHim ? AppColors.slateBlueSoft : AppColors.roseSoft),
              width: 1.0,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) => _onItemTapped(index, context, role),
          backgroundColor: isDark ? AppColors.darkSurface : AppColors.white,
          selectedItemColor: isHim
              ? AppColors.slateBluePrimary
              : AppColors.rosePrimary,
          unselectedItemColor: isDark
              ? AppColors.warmGray600
              : AppColors.warmGray400,
          selectedLabelStyle: AppTypography.bodySmall.copyWith(
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: AppTypography.bodySmall,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: isHim
              ? const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home_outlined),
                    activeIcon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.favorite_outline),
                    activeIcon: Icon(Icons.favorite),
                    label: 'Her',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.spa_outlined),
                    activeIcon: Icon(Icons.spa),
                    label: 'Garden',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.mail_outline),
                    activeIcon: Icon(Icons.mail),
                    label: 'From Her',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.people_outline),
                    activeIcon: Icon(Icons.people),
                    label: 'Us',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person_outline),
                    activeIcon: Icon(Icons.person),
                    label: 'Me',
                  ),
                ]
              : const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.favorite_outline),
                    activeIcon: Icon(Icons.favorite),
                    label: 'Today',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.calendar_today_outlined),
                    activeIcon: Icon(Icons.calendar_today),
                    label: 'Cycle',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.spa_outlined),
                    activeIcon: Icon(Icons.spa),
                    label: 'Garden',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.mail_outline),
                    activeIcon: Icon(Icons.mail),
                    label: 'From Him',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person_outline),
                    activeIcon: Icon(Icons.person),
                    label: 'Me',
                  ),
                ],
        ),
      ),
      floatingActionButton: (currentIndex == 0 && !isHim)
          ? FloatingActionButton(
              onPressed: () => context.pushNamed(AppRoutes.dailyLog),
              backgroundColor: AppColors.rosePrimary,
              elevation: 4,
              shape: const CircleBorder(),
              child: const Icon(Icons.add, color: AppColors.white, size: 28),
            )
          : null,
    );
  }
}

// Today Active Tab Content
class HomeTab extends ConsumerStatefulWidget {
  const HomeTab({super.key});

  @override
  ConsumerState<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends ConsumerState<HomeTab> {
  bool _showWelcome = true;

  String _getPhaseTitle(CyclePhase phase) {
    switch (phase) {
      case CyclePhase.menstrual:
        return 'Menstrual Phase 🌸';
      case CyclePhase.follicular:
        return 'Follicular Phase 🌱';
      case CyclePhase.ovulation:
        return 'Ovulation Phase ☀️';
      case CyclePhase.luteal:
        return 'Luteal Phase 🌙';
    }
  }

  String _getPhaseCharacter(CyclePhase phase) {
    switch (phase) {
      case CyclePhase.menstrual:
        return AppIllustrations.cozy;
      case CyclePhase.follicular:
        return AppIllustrations.wakingUp;
      case CyclePhase.ovulation:
        return AppIllustrations.excited;
      case CyclePhase.luteal:
        return AppIllustrations.deepBreath;
    }
  }

  String _getPhaseGreeting(CyclePhase phase) {
    switch (phase) {
      case CyclePhase.menstrual:
        return 'Be gentle with yourself today 💕';
      case CyclePhase.follicular:
        return 'Your energy is rising, love 🌱';
      case CyclePhase.ovulation:
        return 'You\'re glowing today ☀️';
      case CyclePhase.luteal:
        return 'Take a soft breath, you\'re okay 🌙';
    }
  }

  Widget _buildFeatureCard({
    required bool isDark,
    required String title,
    required String subtitle,
    required String illustration,
    VoidCallback? onTap,
  }) {
    final showArrow = onTap != null;
    return LunaCard(
      onTap: onTap,
      borderColor: isDark ? AppColors.darkBorder : AppColors.roseSoft,
      child: Row(
        children: [
          Image.asset(
            illustration,
            width: 64,
            height: 64,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => const Icon(
              Icons.favorite,
              color: AppColors.rosePrimary,
              size: 36,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.titleLarge.copyWith(
                    color: isDark ? AppColors.darkText : AppColors.roseDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTypography.bodySmall.copyWith(
                    color: isDark
                        ? AppColors.warmGray400
                        : AppColors.warmGray600,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          if (showArrow)
            const Icon(Icons.arrow_forward, color: AppColors.rosePrimary),
        ],
      ),
    );
  }

  Widget _buildWelcomeContent(
    BuildContext context,
    DashboardData data,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome, ${data.username} 💕',
                  style: AppTypography.displayMedium.copyWith(
                    color: isDark ? AppColors.darkText : AppColors.roseDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'A gentle space made just for you',
                  style: AppTypography.bodySmall.copyWith(
                    color: isDark
                        ? AppColors.warmGray400
                        : AppColors.warmGray600,
                  ),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(
                Icons.history_edu,
                color: AppColors.rosePrimary,
                size: 28,
              ),
              onPressed: () => context.pushNamed(AppRoutes.journal),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [AppColors.darkCard, AppColors.darkSurface]
                  : [AppColors.roseSoft, AppColors.roseMid.withAlpha(102)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(AppRadius.xl),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.roseSoft,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Someone made this to care for you',
                      style: AppTypography.titleMedium.copyWith(
                        color: isDark ? AppColors.darkText : AppColors.roseDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Track your cycle, log your feelings, and keep the sweetest moments close.',
                      style: AppTypography.bodySmall.copyWith(
                        color: isDark
                            ? AppColors.warmGray400
                            : AppColors.warmGray600,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              Image.asset(
                AppIllustrations.hello,
                width: 120,
                height: 140,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const SizedBox(width: 120),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Features made for you',
          style: AppTypography.titleLarge.copyWith(
            color: isDark ? AppColors.darkText : AppColors.roseDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        _buildFeatureCard(
          isDark: isDark,
          title: 'Period Tracking',
          subtitle: 'See your cycle day, phases, and predictions.',
          illustration: AppIllustrations.planning,
          onTap: () {
            setState(() => _showWelcome = false);
          },
        ),
        const SizedBox(height: AppSpacing.md),
        _buildFeatureCard(
          isDark: isDark,
          title: 'Daily Log',
          subtitle: 'Log mood, flow, symptoms, and notes with care.',
          illustration: AppIllustrations.journaling,
        ),
        const SizedBox(height: AppSpacing.md),
        _buildFeatureCard(
          isDark: isDark,
          title: 'From Him',
          subtitle: 'Open messages, memories, and warm surprises.',
          illustration: AppIllustrations.inLove,
        ),
        if (!data.isLinked && data.myLoveCode != null) ...[
          const SizedBox(height: AppSpacing.xl),
          LunaCard(
            borderColor: AppColors.roseMid.withOpacity(0.3),
            color: isDark ? AppColors.darkCard : Colors.white.withOpacity(0.9),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.link, color: AppColors.rosePrimary),
                    const SizedBox(width: 8),
                    Text(
                      'Link with your partner',
                      style: AppTypography.titleMedium.copyWith(
                        color: AppColors.rosePrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Share your code so he can see your cycle and support you:',
                  textAlign: TextAlign.center,
                  style: AppTypography.bodySmall,
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.roseSoft.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.roseSoft),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        data.myLoveCode!,
                        style: AppTypography.titleLarge.copyWith(
                          letterSpacing: 2,
                          color: AppColors.rosePrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.copy, size: 20),
                        onPressed: () {
                          Clipboard.setData(
                            ClipboardData(text: data.myLoveCode!),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Code copied! 💕'),
                              backgroundColor: AppColors.rosePrimary,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => context.push('/code-entry'),
                  child: Text(
                    "Have his code? Enter it here",
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.rosePrimary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.xxl),
      ],
    );
  }

  Widget _buildTodayContent(
    BuildContext context,
    WidgetRef ref,
    DashboardData data,
    bool isDark,
  ) {
    final advice = SuggestionService.forPhase(data.phase);
    final selfCare = SuggestionService.selfCareFor(data.phase);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Header Row ────────────────────────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: AppColors.rosePrimary,
                  ),
                  onPressed: () => setState(() => _showWelcome = true),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello, ${data.username} 💕',
                      style: AppTypography.displayMedium.copyWith(
                        color: isDark ? AppColors.darkText : AppColors.roseDark,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _getPhaseTitle(data.phase),
                      style: AppTypography.bodySmall.copyWith(
                        color: isDark
                            ? AppColors.roseSoft
                            : AppColors.rosePrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            IconButton(
              icon: const Icon(
                Icons.history_edu,
                color: AppColors.rosePrimary,
                size: 28,
              ),
              onPressed: () => context.pushNamed(AppRoutes.journal),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),

        // ── Hero Phase Card (character + cycle info) ──────────────
        // Like the reference image: character sits on the right,
        // cycle stats on the left — soft gradient background
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [AppColors.darkCard, AppColors.darkSurface]
                  : [AppColors.roseSoft, AppColors.roseMid.withAlpha(102)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(AppRadius.xl),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.roseSoft,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Row(
            children: [
              // Left: Phase ring + stats
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PhaseRing(
                      phase: data.phase,
                      progress: data.cycleDay / data.cycleLength.toDouble(),
                      cycleDay: data.cycleDay,
                      size: 80,
                    ),
                    const SizedBox(height: 12),
                    if (data.phase == CyclePhase.menstrual) ...[
                      Text(
                        'Period Day',
                        style: AppTypography.bodySmall.copyWith(
                          color: isDark
                              ? AppColors.warmGray400
                              : AppColors.warmGray600,
                        ),
                      ),
                      Text(
                        'Day ${data.cycleDay}',
                        style: AppTypography.displayMedium.copyWith(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? AppColors.darkText
                              : AppColors.roseDark,
                        ),
                      ),
                    ] else ...[
                      Text(
                        data.daysUntilPeriod >= 0
                            ? 'Next Period in'
                            : 'Overdue by',
                        style: AppTypography.bodySmall.copyWith(
                          color: isDark
                              ? AppColors.warmGray400
                              : AppColors.warmGray600,
                        ),
                      ),
                      Text(
                        '${data.daysUntilPeriod.abs()} Days',
                        style: AppTypography.displayMedium.copyWith(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? AppColors.darkText
                              : AppColors.roseDark,
                        ),
                      ),
                    ],
                    const SizedBox(height: 4),
                    Text(
                      data.isFertile
                          ? '🌿 Fertile Window'
                          : _getPhaseGreeting(data.phase),
                      style: AppTypography.bodySmall.copyWith(
                        color: data.isFertile
                            ? AppColors.phaseFollicular
                            : AppColors.rosePrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              // Right: Character illustration
              Image.asset(
                _getPhaseCharacter(data.phase),
                width: 120,
                height: 140,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const SizedBox(width: 120),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // ── Today's Tip Card (smaller — text + character accent) ──
        if (advice.isNotEmpty)
          LunaCard(
            borderColor: isDark ? AppColors.darkBorder : AppColors.roseSoft,
            child: Row(
              children: [
                Image.asset(
                  AppIllustrations.deepBreath,
                  width: 60,
                  height: 60,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.spa,
                    color: AppColors.rosePrimary,
                    size: 40,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Loving Tip for Today',
                        style: AppTypography.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        advice[0],
                        style: AppTypography.bodySmall.copyWith(
                          color: isDark
                              ? AppColors.warmGray400
                              : AppColors.warmGray600,
                          height: 1.4,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: AppSpacing.lg),

        // ── Wellness Trackers ──────────────────────────────────────
        Row(
          children: [
            // Hydration
            Expanded(
              child: LunaCard(
                onTap: () {
                  ref.read(dashboardProvider.notifier).addHydration(250.0);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Added 250ml water 💧')),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(
                          Icons.water_drop,
                          color: Colors.lightBlueAccent,
                          size: 24,
                        ),
                        Image.asset(
                          AppIllustrations.selfCare,
                          width: 40,
                          height: 40,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) =>
                              const SizedBox(width: 40),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text('Hydration', style: AppTypography.titleMedium),
                    Text(
                      '${data.hydration.toInt()} ml',
                      style: AppTypography.titleLarge.copyWith(
                        color: AppColors.rosePrimary,
                      ),
                    ),
                    Text('+250ml on tap', style: AppTypography.bodySmall),
                  ],
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),

            // Sleep
            Expanded(
              child: LunaCard(
                onTap: () {
                  ref.read(dashboardProvider.notifier).setSleep(7.5);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(
                          Icons.hotel,
                          color: AppColors.mauvePrimary,
                          size: 24,
                        ),
                        Image.asset(
                          AppIllustrations.sleepy,
                          width: 40,
                          height: 40,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) =>
                              const SizedBox(width: 40),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text('Sleep', style: AppTypography.titleMedium),
                    Text(
                      '${data.sleep} hrs',
                      style: AppTypography.titleLarge.copyWith(
                        color: AppColors.mauvePrimary,
                      ),
                    ),
                    Text('Tap to log 7.5h', style: AppTypography.bodySmall),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),

        // ── Self-Care Cards ────────────────────────────────────────
        Text(
          'Self-Care Picks 🛁',
          style: AppTypography.titleLarge.copyWith(
            color: isDark ? AppColors.darkText : AppColors.roseDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: 110,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: selfCare.length,
            itemBuilder: (context, index) {
              final illus = AppIllustrations.forSelfCare(selfCare[index]);
              return Container(
                width: 140,
                margin: const EdgeInsets.only(right: 12),
                child: LunaCard(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  borderColor: isDark
                      ? AppColors.darkBorder
                      : AppColors.roseSoft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        illus,
                        width: 36,
                        height: 36,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.spa,
                          color: AppColors.rosePrimary,
                          size: 28,
                        ),
                      ),
                      Text(
                        selfCare[index],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.bodySmall.copyWith(
                          fontWeight: FontWeight.w600,
                          height: 1.2,
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

        // ── From Him Envelope Card ─────────────────────────────────
        LunaCard(
          color: isDark ? AppColors.darkCard : AppColors.goldSoft,
          borderColor: isDark ? AppColors.darkBorder : AppColors.goldMid,
          onTap: () => context.pushNamed(AppRoutes.fromHim),
          child: Row(
            children: [
              Image.asset(
                AppIllustrations.inLove,
                width: 56,
                height: 56,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) =>
                    const Text('✉️', style: TextStyle(fontSize: 36)),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'A secret envelope is waiting...',
                      style: AppTypography.handwrittenLg.copyWith(
                        color: isDark ? AppColors.goldMid : AppColors.roseDark,
                      ),
                    ),
                    Text(
                      'He left handwritten messages for you 💕',
                      style: AppTypography.handwritten.copyWith(
                        color: isDark
                            ? AppColors.warmGray400
                            : AppColors.charcoal,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_right, color: AppColors.rosePrimary),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dashboardState = ref.watch(dashboardProvider);

    return dashboardState.when(
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: LunaLoading(width: 250, height: 180),
        ),
      ),
      error: (e, s) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Something didn\'t connect 🌸',
                style: AppTypography.displayMedium,
              ),
              const SizedBox(height: 12),
              Text(
                'Your data is completely safe, we\'ll reload in a second 💕',
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium,
              ),
              const SizedBox(height: 20),
              LunaButton(
                text: 'Try Again',
                width: 140,
                onPressed: () => ref.invalidate(dashboardProvider),
              ),
            ],
          ),
        ),
      ),
      data: (data) {
        return BackButtonListener(
          onBackButtonPressed: () async {
            if (!_showWelcome) {
              setState(() => _showWelcome = true);
              return true;
            }
            return false;
          },
          child: AnimatedGradientBackground(
            phase: data.phase,
            child: FloatingParticles(
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                  child: _showWelcome
                      ? _buildWelcomeContent(context, data, isDark)
                      : _buildTodayContent(context, ref, data, isDark),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
