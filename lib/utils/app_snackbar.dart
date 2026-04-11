import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppSnackbar {

  static void success(String message) {
    _show(
      message,
      AppColors.primaryDark,
      AppColors.white,
      Icons.check_circle,
    );
  }

  static void error(String message) {
    _show(
      message,
      AppColors.red,
      AppColors.white,
      Icons.error,
    );
  }

  static void warning(String message) {
    _show(
      message,
      AppColors.warning,
      AppColors.white,
      Icons.warning,
    );
  }

  static void _show(
    String message,
    Color bgColor,
    Color textColor,
    IconData icon,
  ) {

    Get.showSnackbar(
      GetSnackBar(
        backgroundColor: bgColor,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(12),
        borderRadius: 10,
        duration: const Duration(seconds: 3),
        messageText: Row(
          children: [
            Icon(icon, color: textColor),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.kumbhSans(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}