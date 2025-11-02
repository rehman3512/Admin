import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:admin/Constants/AppColors/appcolors.dart';
import 'package:admin/Controllers/AuthController/authcontroller.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔹 Call AuthController for navigation after animation delay
    Future.delayed(const Duration(seconds: 3), () {
      Get.find<AuthController>().checkLogin();
    });

    return Scaffold(
      backgroundColor: AppColors.splashBg,
      body: Stack(
        children: [
          const _AnimatedBackground(),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                _AnimatedLogo(),
                SizedBox(height: 40),
                _AnimatedTitle(),
                SizedBox(height: 20),
                _AnimatedSubtitle(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 🫧 Animated soft-moving bubbles background (infinite motion)
class _AnimatedBackground extends StatefulWidget {
  const _AnimatedBackground();

  @override
  State<_AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<_AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final value = _controller.value * 2 * math.pi;
        return Stack(
          children: List.generate(6, (i) {
            final double radius = 80 + (i * 18);
            final double speed = 0.6 + (i * 0.12);
            final offsetX = [0.15, 0.25, 0.7, 0.8, 0.1, 0.55][i];
            final offsetY = [0.2, 0.6, 0.3, 0.8, 0.9, 0.15][i];
            final floatY = math.sin(value * speed) * 25;
            final floatX = math.cos(value * speed) * 20;

            return Positioned(
              left: Get.width * offsetX + floatX,
              top: Get.height * offsetY + floatY,
              child: Container(
                width: radius,
                height: radius,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: i.isEven
                      ? AppColors.bubble1.withOpacity(0.45)
                      : AppColors.bubble2.withOpacity(0.45),
                  boxShadow: [
                    BoxShadow(
                      color: (i.isEven
                          ? AppColors.primary
                          : AppColors.accent)
                          .withOpacity(0.08),
                      blurRadius: 50,
                      spreadRadius: 25,
                    ),
                  ],
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

/// 🎓 Logo Animation – smooth scale-in + glow
class _AnimatedLogo extends StatelessWidget {
  const _AnimatedLogo();

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 1200),
      curve: Curves.easeOutBack,
      builder: (context, value, _) {
        final opacity = value.clamp(0.0, 1.0); // prevent NaN or overflow
        return Transform.scale(
          scale: 0.7 + value * 0.3,
          child: Opacity(
            opacity: opacity,
            child: Container(
              width: 130,
              height: 130,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Colors.white, Color(0xFFF5F0FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Icon(
                Icons.school_rounded,
                size: 75,
                color: AppColors.primary,
              ),
            ),
          ),
        );
      },
    );
  }
}

/// 🏫 Title Animation — Fade + Slide Up
class _AnimatedTitle extends StatelessWidget {
  const _AnimatedTitle();

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 1300),
      curve: Curves.easeOutCubic,
      builder: (context, value, _) {
        return Opacity(
          opacity: value.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: Text(
              "ALPHA ACADEMY",
              style: GoogleFonts.poppins(
                fontSize: 34,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
                letterSpacing: 3.5,
                shadows: [
                  Shadow(
                    color: AppColors.glow.withOpacity(0.6),
                    blurRadius: 20,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// ✨ Subtitle Animation — Fade + Gentle Scale
class _AnimatedSubtitle extends StatelessWidget {
  const _AnimatedSubtitle();

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 1400),
      curve: Curves.easeOutQuart,
      builder: (context, value, _) {
        return Opacity(
          opacity: value.clamp(0.0, 1.0),
          child: Transform.scale(
            scale: 0.9 + (value * 0.1),
            child: Text(
              "Learn • Grow • Succeed",
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: AppColors.accent.withOpacity(0.9),
                fontWeight: FontWeight.w600,
                letterSpacing: 1.3,
              ),
            ),
          ),
        );
      },
    );
  }
}
