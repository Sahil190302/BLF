import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  // 1️⃣ Title / App Name
  static final title = GoogleFonts.poppins(
    fontSize: 26,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
    letterSpacing: 1.2,
  );

  // 2️⃣ Subtitle / Tagline
  static final subtitle = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textLight,
  );

  // 3️⃣ Button Text
  static final button = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );

  // 4️⃣ Body Text
  static final body = GoogleFonts.poppins(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.textDark,
  );

  // 5️⃣ Caption / Small Label
  static final caption = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textLight.withOpacity(0.8),
  );
}
