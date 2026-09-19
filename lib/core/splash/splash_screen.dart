import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'splash_icon.dart';

/// Full-screen splash shown after the native Android splash.
///
/// The native splash already renders the brand-purple background and the
/// dialog-box mark (dots removed — see `assets/ic_splash.png`); this screen
/// renders the *same* bubble and makes its three "…" dots fade in/out on a
/// staggered loop, so the launch animation reads as the icon's own dots
/// breathing — not a second, separate animation.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  static const _brandPurple = Color(0xFF7C6FDE);
  static const _dotColor = Color(0xFFBFF3FA);

  /// Matches the Android 12+ native splash icon's on-screen size, so the bubble
  /// doesn't jump when the native splash hands off to this screen.
  static const double _iconSize = 288;

  /// Dot geometry in the 512px source icon (three 36px squares).
  static const List<double> _dotCenterX = [164, 237, 310];
  static const double _dotCenterY = 200;
  static const double _dotSizeSrc = 36;

  /// Breathing loop.
  late final AnimationController _loop = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat();

  /// One-shot intro: eases the dots from full brightness (matching the native
  /// splash's static dots) into the staggered breathing, so the handoff doesn't
  /// visibly dim them.
  late final AnimationController _intro = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 600),
  )..forward();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1600), () {
      if (mounted) context.go('/chat');
    });
  }

  @override
  void dispose() {
    _loop.dispose();
    _intro.dispose();
    super.dispose();
  }

  /// Smooth staggered pulse: each dot is offset by a third of the cycle, eased
  /// in from full brightness over the intro so the first frame matches the
  /// native splash's static dots.
  double _opacity(int i) {
    final phase = (_loop.value + i / 3) % 1.0;
    final staggered =
        0.25 + 0.75 * (0.5 - 0.5 * math.cos(phase * 2 * math.pi));
    return 1.0 - (1.0 - staggered) * _intro.value;
  }

  @override
  Widget build(BuildContext context) {
    final scale = _iconSize / 512;
    final dotSize = _dotSizeSrc * scale;
    return Scaffold(
      backgroundColor: _brandPurple,
      body: Center(
        child: SizedBox(
          width: _iconSize,
          height: _iconSize,
          child: AnimatedBuilder(
            animation: Listenable.merge([_loop, _intro]),
            builder: (context, _) => Stack(
              fit: StackFit.expand,
              children: [
                // Pre-decoded icon renders synchronously on the first frame;
                // fall back to Image.asset if the preload didn't happen.
                if (splashIconImage != null)
                  RawImage(image: splashIconImage, fit: BoxFit.fill)
                else
                  Image.asset('assets/ic_splash.png'),
                for (var i = 0; i < 3; i++)
                  Positioned(
                    left: _dotCenterX[i] * scale - dotSize / 2,
                    top: _dotCenterY * scale - dotSize / 2,
                    width: dotSize,
                    height: dotSize,
                    child: Opacity(
                      opacity: _opacity(i),
                      child: Container(color: _dotColor),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
