import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:her/core/constants/app_colors.dart';

class FloatingParticles extends StatefulWidget {
  final int count;
  final Widget? child;

  const FloatingParticles({
    super.key,
    this.count = 15,
    this.child,
  });

  @override
  State<FloatingParticles> createState() => _FloatingParticlesState();
}

class _FloatingParticlesState extends State<FloatingParticles>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Particle> _particles = [];
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    // Initialize random particles
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final size = MediaQuery.of(context).size;
        _initParticles(size.width, size.height);
      }
    });
  }

  void _initParticles(double width, double height) {
    _particles.clear();
    for (int i = 0; i < widget.count; i++) {
      _particles.add(
        _Particle(
          x: _random.nextDouble() * width,
          y: _random.nextDouble() * height,
          size: 3.0 + _random.nextDouble() * 5.0, // 3 - 8px
          speed: 0.5 + _random.nextDouble() * 0.8,
          opacity: 0.08 + _random.nextDouble() * 0.15, // 8% - 23%
          drift: -0.2 + _random.nextDouble() * 0.4,
        ),
      );
    }
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Initialize lazily on first build — defer setState to avoid calling
        // it during the current build phase (Flutter throws an assertion).
        if (_particles.isEmpty && constraints.maxWidth > 0) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && _particles.isEmpty) {
              _initParticles(constraints.maxWidth, constraints.maxHeight);
            }
          });
        }

        return Stack(
          children: [
            if (_particles.isNotEmpty)
              RepaintBoundary(
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, _) {
                    // Update particle positions
                    for (final particle in _particles) {
                      particle.y -= particle.speed;
                      particle.x += particle.drift;

                      // Recycle particle to bottom if it goes offscreen
                      if (particle.y < -20) {
                        particle.y = constraints.maxHeight + 20;
                        particle.x = _random.nextDouble() * constraints.maxWidth;
                      }
                      if (particle.x < -20) {
                        particle.x = constraints.maxWidth + 20;
                      } else if (particle.x > constraints.maxWidth + 20) {
                        particle.x = -20;
                      }
                    }

                    return CustomPaint(
                      painter: _ParticlePainter(_particles),
                      size: Size(constraints.maxWidth, constraints.maxHeight),
                    );
                  },
                ),
              ),
            if (widget.child != null) widget.child!,
          ],
        );
      },
    );
  }
}

class _Particle {
  double x;
  double y;
  final double size;
  final double speed;
  final double opacity;
  final double drift;

  _Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
    required this.drift,
  });
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;

  _ParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (final particle in particles) {
      // Fade out near the top
      double currentOpacity = particle.opacity;
      if (particle.y < 100) {
        currentOpacity = particle.opacity * (particle.y / 100).clamp(0.0, 1.0);
      }

      paint.color = AppColors.rosePrimary.withOpacity(currentOpacity);
      canvas.drawCircle(
        Offset(particle.x, particle.y),
        particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
