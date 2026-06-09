import 'package:blf/app/modules/bottombar/bottom_nav_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/app_loader.dart';
import '../../../../utils/app_snackbar.dart';
import '../../../../utils/app_validation.dart';
import '../../../services/home_api.dart';
import '../../../services/app_session.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';

class OneToOneMeetingController extends GetxController {
  /// USERS FROM API
  RxList<Map<String, dynamic>> users = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> filteredUsers = <Map<String, dynamic>>[].obs;

  /// SELECTED PERSONS (NAMES)
  RxString selectedPerson = ''.obs;
  Rx<File?> meetingImage = Rx<File?>(null);
  final ImagePicker picker = ImagePicker();

  final TextEditingController searchController = TextEditingController();

  /// INITIATED BY
  var selectedInitiatedBy = "Myself".obs;
  final List<String> initiatedByList = ["Invited By", "Myself"];

  /// FORM DATA
  final locationController = TextEditingController();
  var meetingDate = DateTime.now().obs;
  var agenda = ''.obs;
  var summary = ''.obs;

  /// FOLLOW-UP
  var followUpReminder = false.obs;

  @override
  void onInit() {
    super.onInit();
    searchController.addListener(_searchUser);
  }

  Future<void> pickImage() async {
    final XFile? picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      meetingImage.value = File(picked.path);
    }
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

  /// LOAD USERS EXCLUDING LOGGED IN USER
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

  void submitMeeting(BuildContext context) async {
    print("STEP 1 → Submit clicked");

    if (selectedPerson.value.isEmpty) {
      AppSnackbar.error("Please select person");
      return;
    }

    if (!AppValidator.required(locationController.text, "Location")) return;
    if (!AppValidator.required(agenda.value, "Agenda")) return;

    try {
      AppLoader.show();

      final userSno = AppSession.userSno;
      if (userSno == null) throw Exception("Session expired");

      List<int> withUserIds = users
          .where((u) => u['name'] == selectedPerson.value)
          .map<int>((u) => int.parse(u['sno'].toString()))
          .toList();

      await HomeApi.insertMeeting(
        userId: int.parse(userSno),
        withUserIds: withUserIds,
        location: locationController.text.trim(),
        meetingDate: meetingDate.value,
        initiatedBy: selectedInitiatedBy.value,
        agenda: agenda.value.trim(),
        meetingSummary: summary.value.trim(),
        image: meetingImage.value,
      );

      AppLoader.hide();

      /// ✅ CLEAR FORM DATA
      selectedPerson.value = '';
      locationController.clear();
      agenda.value = '';
      summary.value = '';
      meetingImage.value = null;
      selectedInitiatedBy.value = "Myself";
      meetingDate.value = DateTime.now();

      // Show success popup
      _showSuccessPopup(context);
      
    } catch (e, stack) {
      print("ERROR → $e");
      print("STACK → $stack");
      AppLoader.hide();
      await Future.delayed(const Duration(milliseconds: 150));

      final context = Get.context;

      if (context != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
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
                  "Meeting Scheduled\nSuccessfully",
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
    locationController.dispose();
    searchController.dispose();
    super.onClose();
  }
}