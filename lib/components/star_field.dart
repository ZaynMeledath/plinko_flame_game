import 'dart:math';

import 'package:flutter/material.dart';

class StarField extends StatefulWidget {
  const StarField({super.key});

  @override
  State<StarField> createState() => _StarFieldState();
}

class _StarFieldState extends State<StarField>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late DateTime _lastTime;
  final Random _random = Random();
  final int _numStars = 160;
  late List<Star> _stars;

  @override
  void initState() {
    super.initState();

    _stars = List.generate(_numStars, (_) => Star.random(_random));

    _lastTime = DateTime.now();
    _controller =
        AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: 100),
          )
          ..addListener(_tick)
          ..repeat();
  }

  void _tick() {
    final now = DateTime.now();
    final dt = now.difference(_lastTime).inMilliseconds / 1000.0;
    _lastTime = now;

    for (var s in _stars) {
      s.update(dt, _random);
    }
    setState(() {}); // repaint
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomPaint(painter: StarPainter(_stars, size), child: SizedBox()),
    );
  }
}

class Star {
  // normalized positions (0..1)
  double x;
  double y;

  // appearance
  double baseSize; // size multiplier (will be multiplied by screen scale)
  double depth; // 0.0 (far) .. 1.0 (near) -> affects speed & size

  // twinkle (sinusoidal)
  double baseOpacity; // center opacity
  double amplitude; // how much opacity oscillates
  double period; // seconds
  double phase; // 0..1
  double timeAccumulator = 0.0;

  // drift velocity (normalized units per second)
  double vx;
  double vy;

  Star({
    required this.x,
    required this.y,
    required this.baseSize,
    required this.depth,
    required this.baseOpacity,
    required this.amplitude,
    required this.period,
    required this.phase,
    required this.vx,
    required this.vy,
  });

  factory Star.random(Random r) {
    // depth: near stars (0.6..1.0), mid (0.3..0.6), far (0.0..0.3)
    final depth = r.nextDouble(); // 0..1
    // size scaled by depth (near = larger)
    final baseSize = 0.6 + depth * 2.4; // ~0.6..3.0

    // twinkle settings randomised
    final baseOpacity = 0.3 + r.nextDouble() * 0.6; // 0.3..0.9
    final amplitude = 0.08 + r.nextDouble() * 0.35; // small..bigger twinkle
    final period = 1.2 + r.nextDouble() * 3.0; // 1.2..4.2s
    final phase = r.nextDouble();

    // drift direction slight (mostly left/up) but random
    final angle = (-pi / 2) + (r.nextDouble() - 0.5) * 0.8; // bias upward
    // velocity magnitude depends on depth: nearer stars move faster (parallax)
    final speedNorm = 0.01 + depth * 0.06; // normalized units/sec (~0.01..0.07)
    final vx = cos(angle) * speedNorm;
    final vy = sin(angle) * speedNorm * 0.6; // reduce vertical motion

    return Star(
      x: r.nextDouble(),
      y: r.nextDouble(),
      baseSize: baseSize,
      depth: depth,
      baseOpacity: baseOpacity,
      amplitude: amplitude,
      period: period,
      phase: phase,
      vx: vx,
      vy: vy,
    );
  }

  void update(double dt, Random r) {
    // drift
    x += vx * dt;
    y += vy * dt;

    // wrap-around (keep normalized coords in 0..1)
    if (x < 0) x += 1;
    if (x > 1) x -= 1;
    if (y < 0) y += 1;
    if (y > 1) y -= 1;

    // twinkle: sinusoidal oscillation with unique period & phase
    timeAccumulator += dt;
    // use (time + phase*period) to offset starting point
    final t = timeAccumulator + phase * period;
    // sin argument
    final sinv = sin(2 * pi * (t / period));
    // resulting opacity (clamped 0..1)
    double op = baseOpacity + amplitude * sinv;
    if (op < 0.0) op = 0.0;
    if (op > 1.0) op = 1.0;

    // occasionally (rare) change period/amplitude slightly for more randomness
    if (r.nextDouble() < 0.0008) {
      // small random tweak
      // keep values reasonable
      // ignore large jumps
      final dp = (r.nextDouble() - 0.5) * 0.6;
      final da = (r.nextDouble() - 0.5) * 0.1;
      period = (period + dp).clamp(0.6, 6.0);
      amplitude = (amplitude + da).clamp(0.02, 0.6);
    }

    // store current opacity in baseOpacity temporarily for painter convenience
    // but keep baseOpacity as center; we'll expose getOpacity() instead
    _currentOpacity = op;
  }

  // private current opacity to be read by painter
  double _currentOpacity = 1.0;
  double get currentOpacity => _currentOpacity;
}

class StarPainter extends CustomPainter {
  final List<Star> stars;
  final Size screenSize;

  StarPainter(this.stars, this.screenSize);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (var s in stars) {
      // projected size: scale by min(screen dimension) so normalized size becomes pixels
      final minDim = screenSize.shortestSide;
      final radius = s.baseSize * (minDim / 400); // tweak divisor for density

      paint.color = Colors.blue.withOpacity(s.currentOpacity);
      final dx = (s.x * screenSize.width);
      final dy = (s.y * screenSize.height);

      // draw simple circle
      canvas.drawCircle(Offset(dx, dy), radius, paint);

      // small glow for nearest stars
      if (s.depth > 0.75) {
        final glow = Paint()
          ..style = PaintingStyle.fill
          ..color = Colors.white.withOpacity(s.currentOpacity * 0.08);
        canvas.drawCircle(Offset(dx, dy), radius * 3.2, glow);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
