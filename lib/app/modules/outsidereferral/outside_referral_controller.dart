import 'package:blf/app/modules/bottombar/bottom_nav_page.dart';
import 'package:blf/app/services/app_session.dart';
import 'package:blf/app/services/home_api.dart';
import 'package:blf/app/services/repo/app_repo.dart';
import 'package:blf/utils/app_snackbar.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/app_loader.dart';
import '../../../utils/app_validation.dart';
import '../../services/api_exception.dart';

class OutsideReferralController extends GetxController {
  RxString referralType = "Outside".obs;
  RxList<Map<String, dynamic>> users = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> filteredUsers = <Map<String, dynamic>>[].obs;
  final TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    searchController.addListener(_searchUser);
  }

  void loadUsers() async {
    try {
      final allUsers = await HomeApi.fetchAllUsers();
      final loggedInSno = AppSession.userSno;

      final filtered = allUsers
          .where((u) => u['sno'].toString() != loggedInSno)
          .toList();

      users.value = filtered;
      filteredUsers.value = filtered;
    } catch (e) {
      AppSnackbar.error("Failed to load users");
    }
  }

  void _searchUser() {
    String query = searchController.text.toLowerCase();

    if (query.isEmpty) {
      filteredUsers.value = users;
    } else {
      filteredUsers.value = users
          .where((u) => u['name'].toString().toLowerCase().contains(query))
          .toList();
    }
  }

  RxString selectedPerson = ''.obs;

  final List<String> statusList = ["Told Them You Will You", "Given Your Card"];

  var selectedStatus = "".obs;

  final phone = TextEditingController();
  final email = TextEditingController();
  final address = TextEditingController();
  final commentController = TextEditingController();
  var hotLevel = 5.0.obs;
  final comment = "".obs;
  String get hotRating {
    if (hotLevel.value >= 8) return "hot";
    if (hotLevel.value >= 5) return "warm";
    return "cold";
  }

  Future<void> fetchUsers() async {
    try {
      final allUsers = await HomeApi.fetchAllUsers();
      final loggedInSno = AppSession.userSno;

      final filtered = allUsers
          .where((u) => u['sno'].toString() != loggedInSno)
          .toList();

      users.assignAll(filtered);
      filteredUsers.assignAll(filtered);
    } catch (e) {
      AppSnackbar.error("Failed to load users");
    }
  }

  Future<void> submitOutsideReferral(BuildContext context) async {
    print("STEP 1 → Confirm clicked");

    if (selectedPerson.value.isEmpty ||
        selectedStatus.value.isEmpty ||
        comment.value.trim().isEmpty) {
      AppSnackbar.error(
        "These fields are mandatory: Referral Person, Referral Status, Comment",
      );
      return;
    }

    if (phone.text.trim().isNotEmpty && !AppValidator.phone(phone.text)) {
      AppSnackbar.error("Invalid telephone number");
      return;
    }

    try {
      AppLoader.show();

      final userSno = AppSession.userSno;
      if (userSno == null) throw Exception("Session expired");

      List<int> referralUserIds = users
          .where((u) => u['name'] == selectedPerson.value)
          .map<int>((u) => int.parse(u['sno'].toString()))
          .toList();

      print("STEP 2 → userId: $userSno");
      print("STEP 3 → referralUserIds: $referralUserIds");

      final response = await HomeApi.insertReferral(
        userId: int.parse(userSno),
        referralUserIds: referralUserIds,
        referralType: referralType.value,
        referralStatus: selectedStatus.value,
        email: email.text.trim().isEmpty ? "" : email.text.trim(),
        mobile: phone.text.trim().isEmpty ? "" : phone.text.trim(),
        address: address.text.trim().isEmpty ? "" : address.text.trim(),
        comment: comment.value.trim(),
        referralHotRating: hotRating.toUpperCase(),
      );

      print("STEP 4 → API Response: $response");

      AppLoader.hide();

      if (response != null && response["status"] == true) {
        // Clear form fields
        selectedPerson.value = "";
        selectedStatus.value = "";
        phone.clear();
        email.clear();
        address.clear();
        comment.value = "";
        hotLevel.value = 5.0;
        referralType.value = "Outside";

        // Show success popup
        _showSuccessPopup(context);
      } else {
        Get.snackbar(
          "Error",
          "Referral submission failed",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e, stack) {
      print("ERROR → $e");
      print("STACK → $stack");
      AppLoader.hide();
      AppSnackbar.error(e.toString());
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
                  "Referral Confirmed\nSuccessfully",
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
    phone.dispose();
    email.dispose();
    address.dispose();
    commentController.dispose();
    searchController.dispose();
    super.onClose();
  }
}