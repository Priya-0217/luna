import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:her/core/constants/app_colors.dart';
import 'package:her/core/constants/app_typography.dart';
import 'package:her/features/home/domain/cycle_phase.dart';
import 'package:her/features/home/domain/cycle_calculator.dart';

class PetalCalendar extends StatefulWidget {
  final int currentDay;
  final int selectedDay;
  final int cycleLength;
  final int periodDuration;
  final double size;
  final ValueChanged<int> onDaySelected;
  final VoidCallback? onCenterTap;

  const PetalCalendar({
    super.key,
    required this.currentDay,
    required this.selectedDay,
    required this.cycleLength,
    required this.periodDuration,
    this.size = 280,
    required this.onDaySelected,
    this.onCenterTap,
  });

  @override
  State<PetalCalendar> createState() => _PetalCalendarState();
}

class _PetalCalendarState extends State<PetalCalendar> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: widget.size,
            height: widget.size,
            child: GestureDetector(
              onTapDown: (details) {
                // Determine which day segment was clicked based on angles
                final box = context.findRenderObject() as RenderBox;
                final center = box.size.center(Offset.zero);
                final localPosition = details.localPosition;
                final dx = localPosition.dx - center.dx;
                final dy = localPosition.dy - center.dy;

                // Check if tap is in center area
                final distance = math.sqrt(dx * dx + dy * dy);
                if (distance < widget.size * 0.2 && widget.onCenterTap != null) {
                  widget.onCenterTap!();
                  return;
                }

                // Calculate angle from -pi to pi, shift to 0 to 2pi
                var angle = math.atan2(dy, dx) + math.pi / 2;
                if (angle < 0) angle += 2 * math.pi;

                // Segment index: angle maps to cycleLength segments
                final segmentSize = (2 * math.pi) / widget.cycleLength;
                var tappedDay = (angle / segmentSize).round() + 1;
                if (tappedDay > widget.cycleLength) tappedDay = 1;

                widget.onDaySelected(tappedDay);
              },
              child: CustomPaint(
                painter: _PetalCalendarPainter(
                  currentDay: widget.currentDay,
                  selectedDay: widget.selectedDay,
                  cycleLength: widget.cycleLength,
                  periodDuration: widget.periodDuration,
                  isDark: isDark,
                ),
                size: Size(widget.size, widget.size),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            widget.selectedDay == widget.currentDay 
                ? 'Your cycle today 💕 (Tap center for journey)'
                : 'Day ${widget.selectedDay} predictions 🌙 (Tap center for journey)',
            style: AppTypography.bodySmall.copyWith(
              color: isDark ? AppColors.warmGray400 : AppColors.warmGray600,
            ),
          ),
        ],
      ),
    );
  }
}

class _PetalCalendarPainter extends CustomPainter {
  final int currentDay;
  final int selectedDay;
  final int cycleLength;
  final int periodDuration;
  final bool isDark;

  _PetalCalendarPainter({
    required this.currentDay,
    required this.selectedDay,
    required this.cycleLength,
    required this.periodDuration,
    required this.isDark,
  });

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

  CyclePhase _getPhaseForDay(int day) {
    return CycleCalculator.calculatePhase(
      cycleDay: day,
      cycleLength: cycleLength,
      periodDuration: periodDuration,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final baseRadius = size.width * 0.28; // central void
    final maxPetalLength = size.width * 0.16;

    final segmentAngle = (2 * math.pi) / cycleLength;

    // Draw central base circle
    final innerCirclePaint = Paint()
      ..color = isDark ? AppColors.darkSurface : AppColors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, baseRadius, innerCirclePaint);

    // Outline inner circle
    final innerOutlinePaint = Paint()
      ..color = isDark ? AppColors.darkBorder : AppColors.roseSoft.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(center, baseRadius, innerOutlinePaint);

    // Draw segment petals radiating outwards
    for (int i = 0; i < cycleLength; i++) {
      final day = i + 1;
      final phase = _getPhaseForDay(day);
      final phaseColor = _getPhaseColor(phase);

      // Angle for this day (starting at top)
      final startAngle = -math.pi / 2 + (i * segmentAngle);
      final midAngle = startAngle + (segmentAngle / 2);
      final endAngle = startAngle + segmentAngle;

      final isToday = day == currentDay;
      final isSelected = day == selectedDay;

      // Petal height varies to give a flower bloom look
      // Menstrual days have taller petals for easy visualization, follicular standard, ovulation gold glows
      double petalLength = baseRadius + maxPetalLength * 0.7;
      if (phase == CyclePhase.menstrual) {
        petalLength = baseRadius + maxPetalLength * 0.95;
      } else if (phase == CyclePhase.ovulation) {
        petalLength = baseRadius + maxPetalLength * 0.85;
      }
      
      if (isSelected) {
        petalLength += 12; // Pronounced expansion for selected petal
      }

      // Draw segment path (bloom petal)
      final path = Path();
      final p1 = Offset(
        center.dx + baseRadius * math.cos(startAngle),
        center.dy + baseRadius * math.sin(startAngle),
      );
      final p2 = Offset(
        center.dx + petalLength * math.cos(midAngle),
        center.dy + petalLength * math.sin(midAngle),
      );
      final p3 = Offset(
        center.dx + baseRadius * math.cos(endAngle),
        center.dy + baseRadius * math.sin(endAngle),
      );

      path.moveTo(p1.dx, p1.dy);
      // Soft bezier curve outward peak
      path.quadraticBezierTo(p2.dx, p2.dy, p3.dx, p3.dy);
      path.close();

      final petalPaint = Paint()
        ..color = isSelected || isToday
            ? phaseColor
            : phaseColor.withOpacity(isDark ? 0.35 : 0.25)
        ..style = PaintingStyle.fill;

      canvas.drawPath(path, petalPaint);

      // Draw segment outline dividers
      final dividerPaint = Paint()
        ..color = isSelected || isToday
            ? phaseColor
            : (isDark ? AppColors.darkBorder : AppColors.white.withOpacity(0.9))
        ..style = PaintingStyle.stroke
        ..strokeWidth = isSelected || isToday ? 2.5 : 1.0;

      canvas.drawPath(path, dividerPaint);

      // Small active dot on current day tip
      if (isToday) {
        final dotPaint = Paint()
          ..color = AppColors.white
          ..style = PaintingStyle.fill;
        canvas.drawCircle(p2, 4.0, dotPaint);
      }
    }

    // Text in the center
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    // Draw "Day"
    textPainter.text = TextSpan(
      text: selectedDay == currentDay ? 'Today' : 'Exploring',
      style: AppTypography.bodySmall.copyWith(
        fontSize: 12,
        color: isDark ? AppColors.warmGray400 : AppColors.warmGray600,
        height: 1.0,
      ),
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(center.dx - textPainter.width / 2, center.dy - 16),
    );

    // Draw active day number
    textPainter.text = TextSpan(
      text: 'Day $selectedDay',
      style: AppTypography.displayMedium.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: isDark ? AppColors.darkText : AppColors.roseDark,
        height: 1.1,
      ),
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(center.dx - textPainter.width / 2, center.dy + 2),
    );
  }

  @override
  bool shouldRepaint(covariant _PetalCalendarPainter oldDelegate) {
    return oldDelegate.currentDay != currentDay ||
        oldDelegate.selectedDay != selectedDay ||
        oldDelegate.cycleLength != cycleLength ||
        oldDelegate.periodDuration != periodDuration ||
        oldDelegate.isDark != isDark;
  }
}
