import 'package:blf/app/modules/auth/JoinBusinessForumView/JoinBusinessForumView.dart';
import 'package:blf/app/modules/auth/VisitorFormview/VisitorFormPage.dart';
import 'package:blf/app/modules/auth/views/forgotpassword.dart';
import 'package:blf/app/modules/bottombar/bottom_nav_page.dart';
import 'package:blf/app/modules/home/home_page.dart';
import 'package:blf/app/services/app_session.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_customtextfield.dart';
import '../controller/login_controller.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  final LoginController controller = Get.find<LoginController>();
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
                    "Welcome Back 👋",
                    style: GoogleFonts.kumbhSans(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryDark,
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

                 Autocomplete<String>(
  optionsBuilder: (TextEditingValue textEditingValue) {

    final emails =
        (AppSession.get("saved_emails") ?? []).cast<String>();

    if (textEditingValue.text.isEmpty) {
      return const Iterable<String>.empty();
    }

    return emails.where(
      (email) => email.toLowerCase().contains(
        textEditingValue.text.toLowerCase(),
      ),
    );
  },

  onSelected: (selection) {
    controller.emailController.text = selection;
  },

  fieldViewBuilder: (
    context,
    textEditingController,
    focusNode,
    onFieldSubmitted,
  ) {

    textEditingController.addListener(() {
      controller.emailController.text = textEditingController.text;
    });

    return CustomTextField(
      hint: "Email Address",
      icon: Icons.email_outlined,
      controller: textEditingController,
    );
  },
),

                  const SizedBox(height: 20),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Password",
                      style: GoogleFonts.kumbhSans(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  CustomTextField(
                    hint: "Password",
                    icon: Icons.lock_outline,
                    controller: controller.passwordController,
                    obscure: true,
                  ),

                  const SizedBox(height: 10),

                  // Align(
                  //   alignment: Alignment.centerRight,
                  //   child: TextButton(
                  //     onPressed: () {
                  //       Get.to(() => ForgetPasswordView());
                  //     },
                  //     child: Text(
                  //       "Forgot Password?",
                  //       style: GoogleFonts.kumbhSans(
                  //         color: AppColors.primary,
                  //         fontWeight: FontWeight.w600,
                  //       ),
                  //     ),
                  //   ),
                  // ),

                  const SizedBox(height: 25),

                  _buildLoginButton(),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: _buildOutlineButton(
                          text: "Join",
                          icon: Icons.person_add,
                          onTap: () {
                            Get.to(() => JoinBusinessForumView());
                          },
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: _buildOutlineButton(
                          text: "Visitor",
                          icon: Icons.group,
                          onTap: () {
                            Get.to(() => VisitorView());
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

 Widget _buildLoginButton() {
  return GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: () async {
      print("Login button tapped");

      final isSuccess = await controller.loginUser();

      print("Login result: $isSuccess");

    if (isSuccess) {
  Get.offAll(() => BottomNavPage());
}
    },
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: const Text(
        "Login",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    ),
  );
}

  Widget _buildOutlineButton({
    required String text,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.primary, width: 1.5),
            color: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                text,
                style: GoogleFonts.kumbhSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
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
    return IgnorePointer(
      child: Stack(
        children: const [
          Positioned(
            top: -90,
            right: -70,
            child: _AnimatedCircle(size: 240, opacity: 0.07, duration: 3),
          ),
          Positioned(
            bottom: -120,
            left: -100,
            child: _AnimatedCircle(size: 300, opacity: 0.06, duration: 4),
          ),
        ],
      ),
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

  late final Animation<double> _animation = Tween(
    begin: 0.95,
    end: 1.1,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) => Transform.scale(
        scale: _animation.value,
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(widget.opacity),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
