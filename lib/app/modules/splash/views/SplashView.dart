import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_textstyles.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SplashController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Subtle Background Pattern
          Positioned.fill(
            child: CustomPaint(
              painter: _BackgroundPatternPainter(),
            ),
          ),

          // Animated Background Circles
          Positioned(
            top: -80,
            right: -80,
            child: _AnimatedCircle(
              size: 250,
           color: AppColors.splashGreen.withOpacity(0.05),
              duration: 3,
            ),
          ),
          Positioned(
            bottom: -100,
            left: -100,
            child: _AnimatedCircle(
              size: 300,
              color: AppColors.splashGreen.withOpacity(0.04),
              duration: 4,
            ),
          ),

          // Main Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                const SizedBox(height: 50),

                // App Name with Animation
                _FadeInText(
                  text: "BLF",
                  style: GoogleFonts.kumbhSans  (
                    fontSize: 40,
                    fontWeight: FontWeight.w600,
                   color: AppColors.splashGreen
                  ),
                  delay: 400,
                ),


                // Tagline with Animation
                _FadeInText(
                  text: "Connect. Grow. Succeed.",
                  style: GoogleFonts.raleway(
                    fontSize: 18,
                    fontWeight: FontWeight.w200,
                    color: Colors.grey.shade600,
                    letterSpacing: 1,
                  ),
                  delay: 700,
                ),

                const SizedBox(height: 80),

                // Animated Loading Dots
              ],
            ),
          ),


        ],
      ),
    );
  }
}

// Custom Background Pattern Painter
class _BackgroundPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withOpacity(0.02)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    const spacing = 40.0;

    // Draw subtle grid pattern
    for (double i = 0; i < size.width; i += spacing) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i, size.height),
        paint,
      );
    }

    for (double i = 0; i < size.height; i += spacing) {
      canvas.drawLine(
        Offset(0, i),
        Offset(size.width, i),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


// Fade In Text Widget
class _FadeInText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final int delay;
  final Alignment alignment;

  const _FadeInText({
    required this.text,
    required this.style,
    this.delay = 0,
    this.alignment = Alignment.center,
  });

  @override
  State<_FadeInText> createState() => _FadeInTextState();
}

class _FadeInTextState extends State<_FadeInText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    Timer(Duration(milliseconds: widget.delay), () {
      if (mounted) {
        _controller.forward();
      }
    });
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
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Align(
              alignment: widget.alignment,
              child: Text(
                widget.text,
                style: widget.style,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      },
    );
  }
}


// Animated Background Circle
class _AnimatedCircle extends StatefulWidget {
  final double size;
  final Color color;
  final int duration;

  const _AnimatedCircle({
    required this.size,
    required this.color,
    required this.duration,
  });

  @override
  State<_AnimatedCircle> createState() => _AnimatedCircleState();
}

class _AnimatedCircleState extends State<_AnimatedCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: widget.duration),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: widget.color,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }
}