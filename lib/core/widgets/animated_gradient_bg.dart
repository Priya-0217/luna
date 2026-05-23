import 'package:flutter/material.dart';
import 'package:her/core/constants/app_colors.dart';
import 'package:her/features/home/domain/cycle_phase.dart';

class AnimatedGradientBackground extends StatefulWidget {
  final CyclePhase phase;
  final Widget? child;

  const AnimatedGradientBackground({
    super.key,
    required this.phase,
    this.child,
  });

  @override
  State<AnimatedGradientBackground> createState() => _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState extends State<AnimatedGradientBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _breathingController;
  late Animation<double> _breathingAnimation;

  @override
  void initState() {
    super.initState();
    _breathingController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat(reverse: true);

    _breathingAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _breathingController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _breathingController.dispose();
    super.dispose();
  }

  List<Color> _getColorsForPhase(CyclePhase phase, bool isDark) {
    if (isDark) {
      return [
        AppColors.darkBackground,
        AppColors.darkSurface,
        AppColors.darkCard,
      ];
    }

    switch (phase) {
      case CyclePhase.menstrual:
        return [
          const Color(0xFFFFF0F3), // AppColors.roseLight
          const Color(0xFFFFD6DE), // AppColors.roseSoft
          const Color(0xFFFFB3C1), // AppColors.roseMid
        ];
      case CyclePhase.follicular:
        return [
          const Color(0xFFFFF5EE), // cream
          const Color(0xFFFFD6DE), // AppColors.roseSoft
          const Color(0xFFFFB3C1), // AppColors.roseMid
        ];
      case CyclePhase.ovulation:
        return [
          const Color(0xFFFFF8E7), // AppColors.goldSoft
          const Color(0xFFFFD97D), // AppColors.goldMid
          const Color(0xFFFFB830), // AppColors.goldPrimary
        ];
      case CyclePhase.luteal:
        return [
          const Color(0xFFF5EEF8), // AppColors.mauveSoft
          const Color(0xFFD7A8E0), // AppColors.mauveMid
          const Color(0xFFB36CC8), // AppColors.mauvePrimary
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final targetColors = _getColorsForPhase(widget.phase, isDark);

    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _breathingAnimation,
        builder: (context, child) {
          // Slowly shift gradient alignment for a breathing/moving sky effect
          final breathingVal = _breathingAnimation.value;
          final topOffset = Alignment(-0.2 * breathingVal, -1.0 + (0.1 * breathingVal));
          final bottomOffset = Alignment(0.2 * breathingVal, 1.0 - (0.1 * breathingVal));

          return AnimatedContainer(
            duration: const Duration(milliseconds: 3000), // slow 3s cross-fade on phase change
            curve: Curves.easeInOutCubic,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: targetColors,
                begin: topOffset,
                end: bottomOffset,
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}
