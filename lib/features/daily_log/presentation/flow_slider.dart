import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:her/core/constants/app_colors.dart';
import 'package:her/core/constants/app_spacing.dart';
import 'package:her/core/constants/app_typography.dart';

class FlowSlider extends StatelessWidget {
  final int selectedFlow; // 0 to 5
  final ValueChanged<int> onFlowSelected;

  const FlowSlider({
    super.key,
    required this.selectedFlow,
    required this.onFlowSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Menstrual Flow 🩸',
              style: AppTypography.titleLarge.copyWith(
                color: isDark ? AppColors.darkText : AppColors.roseDark,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              _getFlowLabel(selectedFlow),
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.rosePrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(5, (index) {
            final activeIndex = index + 1;
            final isFilled = activeIndex <= selectedFlow;

            return GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                onFlowSelected(activeIndex == selectedFlow ? 0 : activeIndex); // toggle or set
              },
              child: AnimatedScale(
                scale: isFilled ? 1.15 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: SizedBox(
                  width: 50,
                  height: 60,
                  child: CustomPaint(
                    painter: _TeardropPainter(
                      isFilled: isFilled,
                      fillColor: AppColors.phaseMenstrual,
                      strokeColor: isDark ? AppColors.darkBorder : AppColors.roseSoft,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  String _getFlowLabel(int flow) {
    switch (flow) {
      case 0:
        return 'No active flow 🌱';
      case 1:
        return 'Spotting 💧';
      case 2:
        return 'Light Flow 💧💧';
      case 3:
        return 'Medium Flow 🩸';
      case 4:
        return 'Heavy Flow 🩸🩸';
      case 5:
        return 'Very Heavy Flow 🌊';
      default:
        return 'No flow';
    }
  }
}

class _TeardropPainter extends CustomPainter {
  final bool isFilled;
  final Color fillColor;
  final Color strokeColor;

  _TeardropPainter({
    required this.isFilled,
    required this.fillColor,
    required this.strokeColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = isFilled ? PaintingStyle.fill : PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..color = isFilled ? fillColor : strokeColor
      ..isAntiAlias = true;

    final path = Path();
    final width = size.width;
    final height = size.height;

    // Draw a teardrop: start at top peak, bezier curves to round bottom
    path.moveTo(width / 2, height * 0.1);
    path.cubicTo(
      width * 0.9, height * 0.5,
      width * 0.9, height * 0.9,
      width / 2, height * 0.95,
    );
    path.cubicTo(
      width * 0.1, height * 0.9,
      width * 0.1, height * 0.5,
      width / 2, height * 0.1,
    );
    path.close();

    canvas.drawPath(path, paint);

    // Draw little inner shine if filled for a premium glass aesthetic
    if (isFilled) {
      final shinePaint = Paint()
        ..color = Colors.white.withOpacity(0.4)
        ..style = PaintingStyle.fill;
      final shinePath = Path();
      shinePath.moveTo(width / 2 - 2, height * 0.25);
      shinePath.cubicTo(
        width / 2 - 8, height * 0.45,
        width / 2 - 8, height * 0.7,
        width / 2 - 4, height * 0.75,
      );
      shinePath.cubicTo(
        width / 2 - 6, height * 0.65,
        width / 2 - 6, height * 0.4,
        width / 2 - 2, height * 0.25,
      );
      canvas.drawPath(shinePath, shinePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _TeardropPainter oldDelegate) {
    return oldDelegate.isFilled != isFilled ||
        oldDelegate.fillColor != fillColor ||
        oldDelegate.strokeColor != strokeColor;
  }
}
