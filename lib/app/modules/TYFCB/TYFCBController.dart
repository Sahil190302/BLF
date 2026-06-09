import 'package:blf/app/modules/bottombar/bottom_nav_page.dart';
import 'package:blf/app/services/app_session.dart';
import 'package:blf/app/services/home_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/app_loader.dart';
import '../../../utils/app_snackbar.dart';
import '../../../utils/app_validation.dart';

class TyfcbController extends GetxController {
  /// TEXT CONTROLLERS
  TextEditingController amount = TextEditingController();
  TextEditingController searchController = TextEditingController();

  /// FORM VALUES
  var businessCategory = ''.obs;
  var referralType = 'Inside'.obs;
  var comment = ''.obs;

  /// APPROVAL STATUS
  var senderApproved = true.obs;
  var receiverApproved = false.obs;

  /// MULTIPLE PEOPLE SELECTION (Names)
  RxString selectedPerson = ''.obs;

  /// USERS FROM API
  RxList<Map<String, dynamic>> users = <Map<String, dynamic>>[].obs;

  /// FILTERED USERS (For Search UI)
  RxList<Map<String, dynamic>> filteredUsers = <Map<String, dynamic>>[].obs;

  /// BUSINESS CATEGORIES
  List<String> businessCategories = [
    'New Business',
    'Repeat Business',
    'Referral',
    'Project',
    'Service',
  ];

  /// REFERRAL TYPES
  List<String> referralTypes = ['Inside', 'Outside'];

  @override
  void onInit() {
    super.onInit();
    loadUsers();
    searchController.addListener(_searchUser);
  }

  /// LOAD USERS EXCLUDING LOGGED-IN USER
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

  /// SEARCH USER
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

  /// SUBMIT TYFCB
  void submitTYFCB(BuildContext context) async {
    print("STEP 1 → Submit clicked");

    try {
      if (selectedPerson.value.isEmpty) {
        print("STEP 2 → No person selected");
        throw Exception("Please select a person");
      }

      print("STEP 3 → Persons selected");

      if (!AppValidator.required(amount.text, "Amount")) {
        print("STEP 4 → Amount validation failed");
        return;
      }

      print("STEP 5 → Amount validated");

      if (businessCategory.value.isEmpty) {
        print("STEP 6 → Business category missing");
        throw Exception("Please select business category");
      }

      print("STEP 7 → Business category selected");

      print("STEP 8 → Showing loader");
      AppLoader.show();

      final userSno = AppSession.userSno;
      print("STEP 9 → userSno = $userSno");

      if (userSno == null) {
        throw Exception("Session expired");
      }

      List<int> givenUserIds = users
          .where((u) => u['name'] == selectedPerson.value)
          .map<int>((u) => int.parse(u['sno'].toString()))
          .toList();

      print("STEP 10 → givenUserIds = $givenUserIds");

      print("STEP 11 → Calling API");

      final response = await HomeApi.insertThankYou(
        userId: int.parse(userSno),
        amount: double.parse(amount.text.trim()),
        businessCategory: businessCategory.value,
        referralType: referralType.value,
        description: comment.value,
        date: DateTime.now().toString().split(" ")[0],
        givenUserIds: givenUserIds,
      );

      print("STEP 12 → API Response = $response");

      print("STEP 13 → Closing loader");
      AppLoader.hide();

      // Show success popup
      _showSuccessPopup(context);
      
    } catch (e, stack) {
      print("ERROR OCCURRED → $e");
      print("STACK TRACE → $stack");
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
                          gradient: LinearGradient(
                            colors: [Colors.green.shade400, Colors.green.shade700],
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
                    color: Colors.green.shade700,
                  ),
                ),
                const SizedBox(height: 10),
                
                Text(
                  "Acknowledgement Submitted\nSuccessfully",
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
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
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
    amount.dispose();
    searchController.dispose();
    super.onClose();
  }
}