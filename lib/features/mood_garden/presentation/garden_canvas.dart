import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:her/core/constants/app_colors.dart';
import 'package:her/core/constants/app_radius.dart';
import 'package:her/features/home/domain/cycle_phase.dart';

class GardenCanvas extends StatefulWidget {
  final String mood; // 'happy', 'cozy', 'down', 'anxious', 'irritable'
  final int flowersCount; // number of flowers to bloom based on check-ins

  const GardenCanvas({
    super.key,
    required this.mood,
    required this.flowersCount,
  });

  @override
  State<GardenCanvas> createState() => _GardenCanvasState();
}

class _GardenCanvasState extends State<GardenCanvas> with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _animController,
        builder: (context, _) {
          return CustomPaint(
            painter: _GardenPainter(
              animationValue: _animController.value,
              mood: widget.mood,
              flowersCount: widget.flowersCount,
              isDark: isDark,
            ),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class _GardenPainter extends CustomPainter {
  final double animationValue;
  final String mood;
  final int flowersCount;
  final bool isDark;

  _GardenPainter({
    required this.animationValue,
    required this.mood,
    required this.flowersCount,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    // 1. Paint Dynamic Weather Sky Background
    _paintSky(canvas, width, height);

    // 2. Paint Ground Curves
    _paintGround(canvas, width, height);

    // 3. Paint Flowers (Blooms grow based on flowersCount)
    _paintFlowers(canvas, width, height);

    // 4. Paint Fluttering Butterflies (sine wave paths)
    _paintButterflies(canvas, width, height);

    // 5. Paint Raindrops if mood is down
    if (mood == 'down') {
      _paintRain(canvas, width, height);
    }
  }

  void _paintSky(Canvas canvas, double width, double height) {
    final rect = Rect.fromLTWH(0, 0, width, height);
    late Gradient gradient;

    if (mood == 'happy' || mood == 'cozy') {
      gradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: isDark
            ? [const Color(0xFF1A0F14), const Color(0xFF2D1A22)]
            : [const Color(0xFFFFF0F3), const Color(0xFFFFE3E8)],
      );
    } else if (mood == 'down' || mood == 'anxious') {
      gradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: isDark
            ? [const Color(0xFF121214), const Color(0xFF1E1F24)]
            : [const Color(0xFFE2E6EC), const Color(0xFFF0F3F7)],
      );
    } else {
      // irritable (warm mauve twilight)
      gradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: isDark
            ? [const Color(0xFF1D121B), const Color(0xFF2A1828)]
            : [const Color(0xFFF9EBF7), const Color(0xFFF2D6ED)],
      );
    }

    final paint = Paint()..shader = gradient.createShader(rect);
    canvas.drawRect(rect, paint);

    // Paint a soft Sun or Moon in the corner
    final sunPaint = Paint()
      ..color = mood == 'happy'
          ? const Color(0xFFFFD166).withOpacity(isDark ? 0.3 : 0.8)
          : const Color(0xFFECECEF).withOpacity(isDark ? 0.2 : 0.6)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);

    canvas.drawCircle(Offset(width * 0.8, height * 0.25), 45.0, sunPaint);
  }

  void _paintGround(Canvas canvas, double width, double height) {
    final path = Path();
    final paint = Paint()
      ..color = isDark ? const Color(0xFF162A1F) : const Color(0xFFD8EAD3)
      ..style = PaintingStyle.fill;

    // Curved layered ground
    path.moveTo(0, height);
    path.lineTo(0, height * 0.78);
    path.quadraticBezierTo(width * 0.3, height * 0.72, width * 0.6, height * 0.79);
    path.quadraticBezierTo(width * 0.85, height * 0.84, width, height * 0.74);
    path.lineTo(width, height);
    path.close();

    canvas.drawPath(path, paint);

    // Draw second overlay hill
    final hillPath = Path();
    final hillPaint = Paint()
      ..color = isDark ? const Color(0xFF112017) : const Color(0xFFC6DEC1)
      ..style = PaintingStyle.fill;

    hillPath.moveTo(0, height);
    hillPath.lineTo(0, height * 0.84);
    hillPath.quadraticBezierTo(width * 0.45, height * 0.89, width * 0.75, height * 0.82);
    hillPath.quadraticBezierTo(width * 0.9, height * 0.8, width, height * 0.83);
    hillPath.lineTo(width, height);
    hillPath.close();

    canvas.drawPath(hillPath, hillPaint);
  }

  void _paintFlowers(Canvas canvas, double width, double height) {
    // Determine how many flowers to draw (clamp between 1 and 6 for layout spacing)
    final count = flowersCount.clamp(1, 6);
    final spacing = width / (count + 1);

    for (int i = 0; i < count; i++) {
      final x = spacing * (i + 1);
      // Vary flower heights for premium organic look
      final stemHeight = height * 0.2 + (15.0 * math.sin(i * 1.5));
      final startY = height * 0.82;
      final endY = startY - stemHeight;

      // Draw Green Stem
      final stemPaint = Paint()
        ..color = isDark ? const Color(0xFF274E13) : const Color(0xFF6AA84F)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0
        ..strokeCap = StrokeCap.round;

      final stemPath = Path();
      stemPath.moveTo(x, startY);
      // Gentle curve sway based on math
      stemPath.quadraticBezierTo(
        x + 8 * math.sin(animationValue * 2 * math.pi + i),
        startY - stemHeight * 0.5,
        x,
        endY,
      );
      canvas.drawPath(stemPath, stemPaint);

      // Draw Flower Petals
      final flowerPaint = Paint()
        ..color = _getFlowerColor(i)
        ..style = PaintingStyle.fill;

      final center = Offset(x, endY);
      const petalRadius = 10.0;

      // Center gold dot
      final centerPaint = Paint()..color = const Color(0xFFFFD166);

      // Draw 5 circular petals around center
      for (int k = 0; k < 5; k++) {
        final angle = (k * 2 * math.pi) / 5 + (animationValue * 0.2);
        final petalOffset = Offset(
          center.dx + petalRadius * math.cos(angle),
          center.dy + petalRadius * math.sin(angle),
        );
        canvas.drawCircle(petalOffset, 8.0, flowerPaint);
      }

      // Draw gold center circle
      canvas.drawCircle(center, 5.0, centerPaint);
    }
  }

  Color _getFlowerColor(int index) {
    final colors = [
      AppColors.rosePrimary,
      AppColors.mauvePrimary,
      const Color(0xFFF4A261),
      const Color(0xFFE76F51),
      AppColors.roseSoft,
      AppColors.goldPrimary,
    ];
    return colors[index % colors.length];
  }

  void _paintButterflies(Canvas canvas, double width, double height) {
    // Render 2 butterflies hovering around ground
    for (int i = 0; i < 2; i++) {
      final t = (animationValue + (i * 0.5)) % 1.0;
      // Fly along horizontal sine wave paths
      final x = width * 0.15 + (width * 0.7 * t);
      final y = height * 0.55 + (40.0 * math.sin(t * 4 * math.pi + i));

      final wingPaint = Paint()
        ..color = i == 0 ? AppColors.rosePrimary.withOpacity(0.85) : AppColors.goldPrimary.withOpacity(0.85)
        ..style = PaintingStyle.fill;

      // Draw simple wings
      canvas.drawOval(
        Rect.fromCenter(center: Offset(x - 5, y), width: 12, height: 16),
        wingPaint,
      );
      canvas.drawOval(
        Rect.fromCenter(center: Offset(x + 5, y), width: 12, height: 16),
        wingPaint,
      );

      // Core body
      final bodyPaint = Paint()..color = Colors.black54;
      canvas.drawOval(
        Rect.fromCenter(center: Offset(x, y), width: 4, height: 18),
        bodyPaint,
      );
    }
  }

  void _paintRain(Canvas canvas, double width, double height) {
    final rainPaint = Paint()
      ..color = const Color(0xFF98C1D9).withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    // Draw 15 falling rain streaks
    for (int i = 0; i < 15; i++) {
      final x = (width / 15) * i + (20 * math.sin(animationValue * 2 * math.pi));
      final startY = ((height * i / 15) + (animationValue * height)) % height;
      final endY = startY + 18.0;

      // slanted line
      canvas.drawLine(Offset(x, startY), Offset(x - 4, endY), rainPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _GardenPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.mood != mood ||
        oldDelegate.flowersCount != flowersCount ||
        oldDelegate.isDark != isDark;
  }
}
