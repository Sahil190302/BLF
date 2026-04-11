import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class CustomTextField extends StatefulWidget {
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final bool obscure;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;

  const CustomTextField({
    super.key,
    required this.hint,
    required this.icon,
    required this.controller,
    this.obscure = false,
    this.validator,
    this.keyboardType = TextInputType.text,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (focus) {
        setState(() => _isFocused = focus);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _isFocused ? AppColors.primary : Colors.transparent,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(_isFocused ? .25 : .05),
              blurRadius: _isFocused ? 10 : 5,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextFormField(
          controller: widget.controller,
          obscureText: widget.obscure,
          validator: widget.validator,
          keyboardType: widget.keyboardType,
          cursorColor: AppColors.primary,
          style: GoogleFonts.kumbhSans( color: Colors.black87, fontSize: 16, ),
          decoration: InputDecoration(
            prefixIcon: Icon(widget.icon, color: AppColors.primary),
            hintText: widget.hint,
            hintStyle: GoogleFonts.kumbhSans(color: Colors.grey.shade500),
            border: InputBorder.none,
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
          ),
        ),
      ),
    );
  }
}
