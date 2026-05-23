import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:her/core/constants/app_colors.dart';

class ParticleBackground extends StatefulWidget {
  final bool isPaused;
  const ParticleBackground({super.key, this.isPaused = false});

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Particle> _particles = [];
  final int _particleCount = 20;
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..addListener(() {
        if (!widget.isPaused) {
          setState(() {
            for (var particle in _particles) {
              particle.update();
            }
          });
        }
      });

    if (!widget.isPaused) {
      _controller.repeat();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_particles.isEmpty) {
      final size = MediaQuery.of(context).size;
      for (int i = 0; i < _particleCount; i++) {
        _particles.add(_Particle(size, _random));
      }
    }
  }

  @override
  void didUpdateWidget(ParticleBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPaused) {
      _controller.stop();
    } else {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ParticlePainter(_particles, Theme.of(context).brightness == Brightness.dark),
      size: Size.infinite,
    );
  }
}

class _Particle {
  late Offset position;
  late double size;
  late double speed;
  late double theta;
  final Size screenSize;
  final math.Random random;

  _Particle(this.screenSize, this.random) {
    position = Offset(random.nextDouble() * screenSize.width,
        random.nextDouble() * screenSize.height);
    size = random.nextDouble() * 4 + 2;
    speed = random.nextDouble() * 0.5 + 0.2;
    theta = random.nextDouble() * 2 * math.pi;
  }

  void update() {
    position += Offset(math.cos(theta) * speed, math.sin(theta) * speed);
    if (position.dx < 0) position = Offset(screenSize.width, position.dy);
    if (position.dx > screenSize.width) position = Offset(0, position.dy);
    if (position.dy < 0) position = Offset(position.dx, screenSize.height);
    if (position.dy > screenSize.height) position = Offset(position.dx, 0);
  }
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final bool isDark;

  _ParticlePainter(this.particles, this.isDark);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isDark
          ? AppColors.rosePrimary.withOpacity(0.1)
          : AppColors.rosePrimary.withOpacity(0.05)
      ..style = PaintingStyle.fill;

    for (var particle in particles) {
      canvas.drawCircle(particle.position, particle.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
