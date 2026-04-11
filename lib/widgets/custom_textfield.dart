import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';

class CustomTextField extends StatefulWidget {
  final String? hint; // 👈 optional
  final IconData? icon;
  final TextEditingController controller;
  final bool obscure;
  final int maxLines;
  final TextInputType keyboard;

  const CustomTextField({
    super.key,
    this.hint, // 👈 optional
    this.icon,
    required this.controller,
    this.obscure = false,
    this.maxLines = 1,
    this.keyboard = TextInputType.text,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (focus) => setState(() => _isFocused = focus),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _isFocused
                ? AppColors.primary
                : Colors.grey.shade300,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.10),
              blurRadius: 5,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: TextField(
          controller: widget.controller,
          maxLines: widget.maxLines,
          keyboardType: widget.keyboard,
          obscureText: widget.obscure,
          cursorColor: AppColors.primary,
          style: GoogleFonts.kumbhSans(fontSize: 16),
          decoration: InputDecoration(
            prefixIcon: widget.icon != null
                ? Icon(widget.icon, color: AppColors.primary)
                : null,

            // 👇 show hint ONLY if provided
            hintText: widget.hint,
            hintStyle: widget.hint != null
                ? GoogleFonts.kumbhSans(color: Colors.grey)
                : null,

            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ),
    );
  }
}
