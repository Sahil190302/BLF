import 'package:blf/app/modules/auth/controller/verifiy_otp_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../utils/app_colors.dart';

class FillOtpView extends StatefulWidget {
  const  FillOtpView({super.key});

  @override
  State<FillOtpView> createState() => _FillOtpViewState();
}


class _FillOtpViewState extends State<FillOtpView> {

  final VerifiyOtpController controller = Get.put(VerifiyOtpController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
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
                    "Enter OTP 🔐",
                    style: GoogleFonts.kumbhSans(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryDark,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "We’ve sent a 4-digit verification code to your email.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.kumbhSans(
                      color: Colors.grey[700],
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // OTP Boxes
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      4,
                          (index) => _buildOtpBox(index,controller),
                    ),
                  ),

                  const SizedBox(height: 25),

                  GestureDetector(
                    onTap: () {
                      // TODO: Resend OTP function
                    },
                    child: Text(
                      "Resend OTP",
                      style: GoogleFonts.kumbhSans(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),

                  const SizedBox(height: 35),

                  _buildButton(
                    text: "Verify & Continue",
                    onTap: () {
                      controller.verifyOtpApi();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // OTP Single Box
  Widget _buildOtpBox(int index,controller) {
    return Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.5), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: TextField(
          controller: controller.otpControllers[index],
          maxLength: 1,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          style: GoogleFonts.kumbhSans(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryDark,
          ),
          cursorColor: AppColors.primary,
          decoration: const InputDecoration(
            counterText: "",
            border: InputBorder.none,
          ),
          onChanged: (value) {
            if (value.isNotEmpty && index < 3) {
              FocusScope.of(context).nextFocus();
            }
            if (value.isEmpty && index > 0) {
              FocusScope.of(context).previousFocus();
            }
          },
        ),
      ),
    );
  }

  // Gradient Button (Same as Login)
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
              color: AppColors.white,
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