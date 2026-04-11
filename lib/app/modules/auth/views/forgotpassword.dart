import 'package:blf/app/modules/auth/controller/forget_password_controller.dart';
import 'package:blf/app/modules/auth/views/verifiy_otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_customtextfield.dart';

class ForgetPasswordView extends StatelessWidget {
  ForgetPasswordView({super.key});

  final ForgetPasswordController controller = Get.put(ForgetPasswordController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          const _AnimatedBackground(),

          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),

                  Text(
                    "Forgot Password 🔐",
                    style: GoogleFonts.kumbhSans(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryDark,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "Don’t worry! Enter your email and we’ll send you reset instructions.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.kumbhSans(
                      color: Colors.grey[700],
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 40),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Email address",
                      style: GoogleFonts.kumbhSans(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  CustomTextField(
                    hint: "Enter your email",
                    icon: Icons.email_outlined,
                    controller: controller.emailController,
                  ),

                  const SizedBox(height: 30),

                  _buildButton(
                    text: "Send Reset Link",
                    onTap: () {
                      Get.to(() => FillOtpView());

                      controller.forgetPasswordApi();
                    },
                  ),

                  const SizedBox(height: 20),

                  GestureDetector(
                    onTap: () {
                    },
                    child: Text(
                      "Back to Login",
                      style: GoogleFonts.kumbhSans(
                        color: AppColors.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton({required String text, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primaryDark.withOpacity(0.9),
              AppColors.green.withOpacity(0.9),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.kumbhSans(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}




class _AnimatedBackground extends StatelessWidget {
  const _AnimatedBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: const [
        Positioned(
          top: -90,
          left: -70,
          child: _AnimatedCircle(size: 240, opacity: 0.07, duration: 3),
        ),
        Positioned(
          bottom: -120,
          right: -100,
          child: _AnimatedCircle(size: 300, opacity: 0.06, duration: 4),
        ),
      ],
    );
  }
}
class _AnimatedCircle extends StatefulWidget {
  final double size;
  final double opacity;
  final int duration;

  const _AnimatedCircle({
    required this.size,
    required this.opacity,
    required this.duration,
  });

  @override
  State<_AnimatedCircle> createState() => _AnimatedCircleState();
}

class _AnimatedCircleState extends State<_AnimatedCircle>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: Duration(seconds: widget.duration),
    vsync: this,
  )..repeat(reverse: true);

  late final Animation<double> _animation =
  Tween(begin: 0.95, end: 1.1).animate(
    CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _animation,
    builder: (_, __) => Transform.scale(
      scale: _animation.value,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: AppColors.primaryDark.withOpacity(widget.opacity),
          shape: BoxShape.circle,
        ),
      ),
    ),
  );
}