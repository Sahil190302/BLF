import 'dart:convert';
import 'package:blf/app/modules/bottombar/bottom_nav_page.dart';
import 'package:blf/app/services/home_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

class EventsController extends GetxController {
  final List<String> notificationTypes = ["once", "yearly"];
  var notificationType = "yearly".obs;

  final notificationPushDate = TextEditingController();

  var notificationTitle = ''.obs;
  var notificationDetail = ''.obs;
  var isLoading = false.obs;

  static const String _url =
      "https://bhartiyacoders.com/WEBSITE/YASH/blf_app_akshay/api/index.php";

  Future<bool> submitEvent(BuildContext context) async {
    try {
      isLoading.value = true;

      final userData = await HomeApi.fetchUser();
      final String userSno = userData["sno"].toString();

      if (notificationTitle.value.trim().isEmpty ||
          notificationDetail.value.trim().isEmpty ||
          notificationPushDate.text.trim().isEmpty) {
        isLoading.value = false;
        return false;
      }

      final currentDate =
          DateTime.now().toIso8601String().split('T').first;

      final response = await http
          .post(
            Uri.parse(_url),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({
              "action": "insert",
              "table": "notification",
              "data": {
                "user_id": userSno,
                "notification_detail":
                    notificationDetail.value.trim(),
                "notification_title":
                    notificationTitle.value.trim(),
                "date": currentDate,
                "notification_push_date":
                    notificationPushDate.text.trim(),
              }
            }),
          )
          .timeout(const Duration(seconds: 20));

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data["status"] == true) {
        // Clear form fields
        notificationTitle.value = '';
        notificationDetail.value = '';
        notificationPushDate.clear();
        notificationType.value = "yearly";
        
        isLoading.value = false;
        
        // Show success popup
        _showSuccessPopup(context);
        
        return true;
      }
      
      isLoading.value = false;
      return false;
    } catch (_) {
      isLoading.value = false;
      return false;
    }
  }

  /// Show Success Popup
  void _showSuccessPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // User cannot tap outside to dismiss
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Animated Checkmark
                TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 500),
                  builder: (context, double value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
                          ),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 50,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                
                // Success Text
                Text(
                  "Success!",
                  style: GoogleFonts.kumbhSans(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2E7D32),
                  ),
                ),
                const SizedBox(height: 10),
                
                Text(
                  "Event Submitted\nSuccessfully",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.kumbhSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 20),
                
                // Divider
                Container(
                  height: 1,
                  color: Colors.grey.shade200,
                ),
                const SizedBox(height: 20),
                
                // Loading indicator with timer text
                Column(
                  children: [
                    const SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0, end: 1),
                      duration: const Duration(seconds: 3),
                      builder: (context, double value, child) {
                        int secondsLeft = (3 - (value * 3)).ceil();
                        return Text(
                          "Redirecting in $secondsLeft second${secondsLeft != 1 ? 's' : ''}...",
                          style: GoogleFonts.kumbhSans(
                            fontSize: 13,
                            color: Colors.grey.shade500,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    // Auto redirect after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (Get.context != null) {
        Navigator.of(Get.context!).pop(); // Close dialog
        Get.offAll(() => BottomNavPage()); // Navigate to bottom nav
      }
    });
  }

  @override
  void onClose() {
    notificationPushDate.dispose();
    super.onClose();
  }
}