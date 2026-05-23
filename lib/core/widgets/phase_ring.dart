import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:her/core/constants/app_colors.dart';
import 'package:her/core/constants/app_typography.dart';
import 'package:her/features/home/domain/cycle_phase.dart';

class PhaseRing extends StatefulWidget {
  final CyclePhase phase;
  final double progress; // 0.0 to 1.0
  final int cycleDay;
  final double size;

  const PhaseRing({
    super.key,
    required this.phase,
    required this.progress,
    required this.cycleDay,
    this.size = 90.0,
  });

  @override
  State<PhaseRing> createState() => _PhaseRingState();
}

class _PhaseRingState extends State<PhaseRing> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: widget.progress).animate(
      CurvedAnimation(
        parent: _animController,
        curve: Curves.easeOutCubic,
      ),
    );

    _animController.forward();
  }

  @override
  void didUpdateWidget(covariant PhaseRing oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _progressAnimation = Tween<double>(
        begin: _progressAnimation.value,
        end: widget.progress,
      ).animate(
        CurvedAnimation(
          parent: _animController,
          curve: Curves.easeOutCubic,
        ),
      );
      _animController.reset();
      _animController.forward();
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Color _getPhaseColor(CyclePhase phase) {
    switch (phase) {
      case CyclePhase.menstrual:
        return AppColors.phaseMenstrual;
      case CyclePhase.follicular:
        return AppColors.phaseFollicular;
      case CyclePhase.ovulation:
        return AppColors.phaseOvulation;
      case CyclePhase.luteal:
        return AppColors.phaseLuteal;
    }
  }

  IconData _getPhaseIcon(CyclePhase phase) {
    switch (phase) {
      case CyclePhase.menstrual:
        return Icons.water_drop_outlined;
      case CyclePhase.follicular:
        return Icons.wb_twilight_outlined;
      case CyclePhase.ovulation:
        return Icons.wb_sunny_outlined;
      case CyclePhase.luteal:
        return Icons.nights_stay_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final phaseColor = _getPhaseColor(widget.phase);
    final iconData = _getPhaseIcon(widget.phase);

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // CustomPainter drawing the ring arcs
          AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, _) {
              return CustomPaint(
                painter: _PhaseRingPainter(
                  progress: _progressAnimation.value,
                  phaseColor: phaseColor,
                  isDark: isDark,
                ),
                size: Size(widget.size, widget.size),
              );
            },
          ),

          // Central Label and Icon
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                iconData,
                size: widget.size * 0.22,
                color: isDark ? AppColors.darkText : AppColors.charcoal,
              ),
              const SizedBox(height: 2.0),
              Text(
                'Day',
                style: AppTypography.bodySmall.copyWith(
                  fontSize: widget.size * 0.12,
                  color: isDark ? AppColors.warmGray400 : AppColors.warmGray600,
                  height: 1.0,
                ),
              ),
              Text(
                '${widget.cycleDay}',
                style: AppTypography.displayMedium.copyWith(
                  fontSize: widget.size * 0.26,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.darkText : AppColors.roseDark,
                  height: 1.1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PhaseRingPainter extends CustomPainter {
  final double progress;
  final Color phaseColor;
  final bool isDark;

  _PhaseRingPainter({
    required this.progress,
    required this.phaseColor,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 6.0) / 2;

    // 1. Draw Background Track (full circle)
    final backgroundPaint = Paint()
      ..color = isDark ? AppColors.darkBorder : AppColors.roseSoft.withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    canvas.drawCircle(center, radius, backgroundPaint);

    // 2. Draw Progress Arc
    if (progress > 0.0) {
      final progressPaint = Paint()
        ..color = phaseColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.5
        ..strokeCap = StrokeCap.round;

      // Start arc from top (-pi / 2)
      const startAngle = -math.pi / 2;
      final sweepAngle = 2 * math.pi * progress.clamp(0.0, 1.0);

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _PhaseRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.phaseColor != phaseColor ||
        oldDelegate.isDark != isDark;
  }
}
