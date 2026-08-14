import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:restaurant_app/src/core/const/app_images.dart';

import '../../controller/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  final SplashController controller = Get.isRegistered<SplashController>()
      ? Get.find<SplashController>()
      : Get.put(SplashController());

  static const _background = Color(0xFFF3FFEC);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: RepaintBoundary(
        child: SizedBox.expand(
          child: AnimatedBuilder(
            animation: controller.timeline,
            builder: (context, _) {
              final seconds = controller.timeline.value * 5;
              return ClipRect(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned.fill(child: _FoodBackdrop(seconds: seconds)),
                    _LogoMoment(seconds: seconds),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _FoodBackdrop extends StatelessWidget {
  const _FoodBackdrop({required this.seconds});

  final double seconds;

  // Rectangles are in the exact 780 x 1688 coordinate space of splash.png.
  static const _doodles = <Rect>[
    Rect.fromLTWH(0, 165, 125, 155),
    Rect.fromLTWH(236, 108, 205, 172),
    Rect.fromLTWH(560, 112, 220, 190),
    Rect.fromLTWH(82, 405, 112, 145),
    Rect.fromLTWH(322, 356, 94, 96),
    Rect.fromLTWH(525, 402, 185, 148),
    Rect.fromLTWH(0, 700, 155, 335),
    Rect.fromLTWH(676, 700, 104, 250),
    Rect.fromLTWH(447, 900, 150, 164),
    Rect.fromLTWH(558, 1025, 222, 120),
    Rect.fromLTWH(150, 1090, 125, 175),
    Rect.fromLTWH(642, 1195, 112, 110),
    Rect.fromLTWH(370, 1338, 220, 175),
    Rect.fromLTWH(72, 1412, 175, 188),
    Rect.fromLTWH(614, 1435, 166, 180),
    // Starts after the reference screenshot's baked-in system gesture bar.
    Rect.fromLTWH(530, 1620, 250, 68),
  ];

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFF3FFEC),
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: 780,
          height: 1688,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              for (var i = 0; i < _doodles.length; i++)
                _DoodleSprite(
                  rect: _doodles[i],
                  reveal: _staggeredReveal(i),
                  motion: _motion(i),
                  rotation: _rotation(i),
                ),
            ],
          ),
        ),
      ),
    );
  }

  double _staggeredReveal(int index) {
    final start = index * 0.032;
    return _interval(seconds, start, math.min(start + 0.30, 0.70));
  }

  double _motion(int index) {
    final active = _interval(seconds, 2.45, 3.55);
    final phase = index * 0.83;
    return math.sin((seconds - 2.45) * math.pi * 1.6 + phase) *
        active *
        (1 - _interval(seconds, 3.35, 3.75));
  }

  double _rotation(int index) => _motion(index) * (index.isEven ? 1 : -1);
}

class _DoodleSprite extends StatelessWidget {
  const _DoodleSprite({
    required this.rect,
    required this.reveal,
    required this.motion,
    required this.rotation,
  });

  final Rect rect;
  final double reveal;
  final double motion;
  final double rotation;

  @override
  Widget build(BuildContext context) {
    final eased = Curves.easeOutCubic.transform(reveal);
    return Positioned.fromRect(
      rect: rect,
      child: Opacity(
        opacity: eased,
        child: Transform.translate(
          offset: Offset(0, motion * 7),
          child: Transform.rotate(
            angle: rotation * math.pi / 180 * 2.2,
            child: Transform.scale(
              scale: 0.96 + eased * 0.04,
              child: ClipRect(
                child: Stack(
                  clipBehavior: Clip.hardEdge,
                  children: [
                    Positioned(
                      left: -rect.left,
                      top: -rect.top,
                      width: 780,
                      height: 1688,
                      child: Image.asset(splashBackground, fit: BoxFit.fill),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LogoMoment extends StatelessWidget {
  const _LogoMoment({required this.seconds});

  final double seconds;

  @override
  Widget build(BuildContext context) {
    final reveal = _interval(seconds, 0.70, 1.50);
    final fade = Curves.easeOutCubic.transform(_interval(seconds, 0.70, 1.10));
    final energy = Curves.easeInOut.transform(_interval(seconds, 2.48, 3.42));
    final glow = Curves.easeOutCubic.transform(_interval(seconds, 3.45, 4.05));

    double scale;
    if (reveal < 0.72) {
      scale = 0.70 + Curves.easeOutBack.transform(reveal / 0.72) * 0.35;
    } else {
      scale =
          1.05 - Curves.easeOutCubic.transform((reveal - 0.72) / 0.28) * 0.05;
    }

    final pulse = math.sin(_interval(seconds, 3.52, 4.18) * math.pi) * 0.025;
    final logoWidth = math.min(MediaQuery.sizeOf(context).width * 0.37, 172.0);

    return Semantics(
      image: true,
      label: 'Kayal Food Delivery',
      child: Opacity(
        opacity: fade,
        child: Transform.translate(
          offset: Offset(0, 18 * (1 - Curves.easeOutCubic.transform(reveal))),
          child: Transform.scale(
            scale: scale + pulse,
            child: SizedBox(
              width: logoWidth * 1.34,
              height: logoWidth * 1.38,
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: logoWidth * 1.30,
                    height: logoWidth * 1.30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFF3FFEC),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: fade * 0.035),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                        BoxShadow(
                          color: const Color(
                            0xFF73E65C,
                          ).withValues(alpha: glow * 0.11),
                          blurRadius: 42 * glow,
                          spreadRadius: 4 * glow,
                        ),
                      ],
                    ),
                  ),
                  Lottie.asset(
                    kayalSplashLottie,
                    width: logoWidth * 2.25,
                    height: logoWidth * 2.25,
                    fit: BoxFit.contain,
                    repeat: false,
                    frameRate: FrameRate.max,
                    controller: AlwaysStoppedAnimation<double>(
                      _interval(seconds, 0, 2.5),
                    ),
                  ),
                  CustomPaint(
                    size: Size.square(logoWidth * 1.24),
                    painter: _EnergyPainter(
                      // The linked Lottie now supplies the exact concentric
                      // ring motion; this painter only retains Kayal's delivery
                      // trail and final halo.
                      ringProgress: 0,
                      effectsOpacity: 0,
                      trailProgress: energy,
                      glowProgress: glow,
                    ),
                  ),
                  ImageFiltered(
                    imageFilter: ui.ImageFilter.blur(
                      sigmaX: (1 - fade) * 5,
                      sigmaY: (1 - fade) * 5,
                    ),
                    child: Image.asset(
                      appLogo,
                      width: logoWidth,
                      height: logoWidth * 1.052,
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.high,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EnergyPainter extends CustomPainter {
  const _EnergyPainter({
    required this.ringProgress,
    required this.effectsOpacity,
    required this.trailProgress,
    required this.glowProgress,
  });

  final double ringProgress;
  final double effectsOpacity;
  final double trailProgress;
  final double glowProgress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide * 0.46;

    // The final halo is a low-opacity radial wash, not a solid disc, so the
    // supplied logo colours remain optically unchanged.
    canvas.drawCircle(
      center,
      radius * 1.10,
      Paint()
        ..shader = ui.Gradient.radial(
          center,
          radius * 1.10,
          [
            const Color(0xFF8CF16C).withValues(alpha: glowProgress * 0.12),
            const Color(0x008CF16C),
          ],
          const [0.18, 1],
        ),
    );

    final ringOpacity = effectsOpacity * (0.35 + ringProgress * 0.65);
    final ringPaint = Paint()
      ..shader = ui.Gradient.sweep(
        center,
        [
          const Color(0xFF0A9E37).withValues(alpha: ringOpacity * 0.16),
          const Color(0xFF0A9E37).withValues(alpha: ringOpacity * 0.84),
          const Color(0xFF65D94B).withValues(alpha: ringOpacity * 0.56),
        ],
        const [0, 0.72, 1],
        TileMode.clamp,
        -math.pi / 2,
        math.pi * 1.5,
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.65
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      math.pi * 2 * ringProgress,
      false,
      ringPaint,
    );

    // A tiny luminous head makes the clockwise draw read at a glance.
    if (ringProgress > 0 && effectsOpacity > 0) {
      final angle = -math.pi / 2 + math.pi * 2 * ringProgress;
      final head = center + Offset(math.cos(angle), math.sin(angle)) * radius;
      canvas.drawCircle(
        head,
        4,
        Paint()
          ..color = const Color(
            0xFF83EF69,
          ).withValues(alpha: ringOpacity * 0.13)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
      );
      canvas.drawCircle(
        head,
        1.65,
        Paint()..color = const Color(0xFF0A9E37).withValues(alpha: ringOpacity),
      );
    }

    // Two short echo arcs add depth without surrounding the brand in clutter.
    final echoOpacity =
        math.sin(ringProgress * math.pi).clamp(0.0, 1.0) * effectsOpacity;
    for (var i = 0; i < 2; i++) {
      canvas.drawArc(
        Rect.fromCircle(
          center: center,
          radius: radius + 7 + i * 7 + ringProgress * 5,
        ),
        -0.82 + i * math.pi,
        0.48,
        false,
        Paint()
          ..color = const Color(
            0xFF70DB54,
          ).withValues(alpha: echoOpacity * (0.20 - i * 0.06))
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..strokeCap = StrokeCap.round,
      );
    }

    const particles = <(double, double, double, Color)>[
      (0.13, 0.31, 2.1, Color(0xFF0A9E37)),
      (0.86, 0.35, 1.7, Color(0xFFFF7417)),
      (0.10, 0.70, 1.5, Color(0xFFFF7417)),
      (0.90, 0.67, 2.0, Color(0xFF0A9E37)),
      (0.68, 0.08, 1.4, Color(0xFFFF7417)),
    ];
    final particleLife =
        math.sin(ringProgress * math.pi).clamp(0.0, 1.0) * effectsOpacity;
    for (var i = 0; i < particles.length; i++) {
      final p = particles[i];
      final origin = Offset(size.width * p.$1, size.height * p.$2);
      final delta = origin - center;
      final direction = delta / math.max(delta.distance, 1);
      final drift = direction * (4 + i % 2 * 3) * ringProgress;
      final paint = Paint()
        ..color = p.$4.withValues(alpha: particleLife * 0.72);
      canvas.drawCircle(
        origin + drift,
        p.$3 * (0.70 + particleLife * 0.30),
        paint,
      );
    }

    // A restrained speed trail sits immediately behind the scooter portion of
    // the original logo. The logo bitmap itself is never cropped or altered.
    final trailOpacity = math.sin(trailProgress * math.pi).clamp(0.0, 1.0);
    final trailPaint = Paint()
      ..color = const Color(0xFFFF7417).withValues(alpha: trailOpacity * 0.48)
      ..strokeWidth = 1.7
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < 3; i++) {
      final y = size.height * (0.655 + i * 0.025);
      final x = size.width * (0.665 - i * 0.022) + trailProgress * 3;
      canvas.drawLine(
        Offset(x - 9 - i * 3, y),
        Offset(x, y),
        trailPaint..strokeWidth = 1.8 - i * 0.28,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _EnergyPainter oldDelegate) =>
      oldDelegate.ringProgress != ringProgress ||
      oldDelegate.effectsOpacity != effectsOpacity ||
      oldDelegate.trailProgress != trailProgress ||
      oldDelegate.glowProgress != glowProgress;
}

double _interval(double value, double begin, double end) =>
    ((value - begin) / (end - begin)).clamp(0.0, 1.0);
