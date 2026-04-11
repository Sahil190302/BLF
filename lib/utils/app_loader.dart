import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app_colors.dart';

class AppLoader {
  static void show() {
    if (Get.isDialogOpen == true) return;

    Get.dialog(
      BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(.2)),
              boxShadow: [
                BoxShadow(blurRadius: 25, color: Colors.black.withOpacity(.25)),
              ],
            ),
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryDark.withOpacity(.9),
                    AppColors.green.withOpacity(.9),
                  ],
                ),
              ),
              child: const CircularProgressIndicator(
                strokeWidth: 3,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      barrierDismissible: false,
      barrierColor: Colors.black26,
    );
  }

 static void hide() {
  if (Get.isDialogOpen == true) {
    Navigator.of(Get.overlayContext!).pop();
  }
}
}
