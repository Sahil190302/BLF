import 'package:blf/app/services/home_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:blf/utils/app_colors.dart';
import 'package:blf/widgets/custom_appbar.dart';
import 'package:blf/widgets/custom_button.dart';
import 'package:blf/widgets/custom_textfield.dart';
import 'feedback_api.dart';

class FeedbackController extends GetxController {
  final TextEditingController testimonialCtrl = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  var users = <Map<String, dynamic>>[].obs;
  var filteredUsers = <Map<String, dynamic>>[].obs;

  var selectedPerson = "".obs;
  var selectedMemberId = 0.obs;
  var isSubmitting = false.obs;

  int currentUserId = 0;

  @override
  void onInit() {
    loadData();
    super.onInit();
  }

  Future<void> loadData() async {
    final user = await HomeApi.fetchUser();
    currentUserId = int.parse(user["sno"].toString());

    final fetchedUsers = await HomeApi.fetchAllUsers();

    users.assignAll(fetchedUsers);
    filteredUsers.assignAll(fetchedUsers);

    searchController.addListener(() {
      filterUsers(searchController.text);
    });
  }

  void filterUsers(String query) {
    if (query.isEmpty) {
      filteredUsers.assignAll(users);
    } else {
      filteredUsers.assignAll(
        users.where(
          (u) =>
              u["name"].toString().toLowerCase().contains(query.toLowerCase()),
        ),
      );
    }
  }

  Future<void> submitTestimonial(BuildContext context) async {
    if (selectedMemberId.value == 0 ||
        testimonialCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select a member and write your testimonial"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    isSubmitting.value = true;

    try {
      bool success = await FeedbackApi.submitFeedback(
        userId: currentUserId,
        memberId: selectedMemberId.value,
        message: testimonialCtrl.text.trim(),
      );

      isSubmitting.value = false;

      if (success) {
        testimonialCtrl.clear();
        selectedPerson.value = "";
        selectedMemberId.value = 0;
        
        _showSuccessPopup(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Submission failed. Please try again."),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      isSubmitting.value = false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Something went wrong. Please try again."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showSuccessPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
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
                          Icons.favorite_rounded,
                          color: Colors.white,
                          size: 50,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                Text(
                  "Thank You!",
                  style: GoogleFonts.kumbhSans(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2E7D32),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Your Feedback\nSubmitted Successfully",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.kumbhSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 1,
                  color: Colors.grey.shade200,
                ),
                const SizedBox(height: 20),
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

    Future.delayed(const Duration(seconds: 3), () {
      if (Get.context != null) {
        Navigator.of(Get.context!).pop();
        Get.back();
      }
    });
  }

  @override
  void onClose() {
    testimonialCtrl.dispose();
    searchController.dispose();
    super.onClose();
  }
}

// ============= FIXED UI VIEW =============

class FeedbackPage extends StatelessWidget {
  FeedbackPage({super.key});

  final FeedbackController controller = Get.put(FeedbackController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        title: "Testimonials & Feedback",
        showBackButton: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Card with Icon
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primaryDark, AppColors.primary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.star_rounded,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Share Your Experience",
                        style: GoogleFonts.kumbhSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Your feedback helps us grow and serve you better",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.kumbhSans(
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Member Selection Card
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.person_outline,
                              size: 20,
                              color: AppColors.primaryDark,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Select Member",
                              style: GoogleFonts.kumbhSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: _memberSelector(context),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Testimonial Card
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.edit_note,
                              size: 20,
                              color: AppColors.primaryDark,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Your Testimonial",
                              style: GoogleFonts.kumbhSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: CustomTextField(
                          hint: "Share your experience with this member...",
                          controller: controller.testimonialCtrl,
                          maxLines: 5,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Submit Button with icon
                CustomButton(
                  text: "Submit Testimonial",
                  onTap: () => controller.submitTestimonial(context),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),

          // Loading Overlay
          Obx(() {
            if (!controller.isSubmitting.value) return const SizedBox();

            return Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryDark),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Submitting your testimonial...",
                        style: GoogleFonts.kumbhSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _memberSelector(BuildContext context) {
    return GestureDetector(
      onTap: () => _openPeopleBottomSheet(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300, width: 1.5),
          color: Colors.grey.shade50,
        ),
        child: Obx(
          () => Row(
            children: [
              Icon(
                Icons.person,
                size: 20,
                color: controller.selectedPerson.value.isEmpty
                    ? Colors.grey.shade400
                    : AppColors.primaryDark,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  controller.selectedPerson.value.isEmpty
                      ? "Select a member"
                      : controller.selectedPerson.value,
                  style: GoogleFonts.kumbhSans(
                    fontSize: 15,
                    color: controller.selectedPerson.value.isEmpty
                        ? Colors.grey.shade500
                        : Colors.black87,
                    fontWeight: controller.selectedPerson.value.isEmpty
                        ? FontWeight.normal
                        : FontWeight.w500,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_drop_down,
                color: AppColors.primaryDark,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openPeopleBottomSheet(BuildContext context) {
    // Store reference to controller to avoid Obx inside bottom sheet
    final localController = controller;
    
    Get.bottomSheet(
      Container(
        height: MediaQuery.of(context).size.height * 0.85,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 15),

            Text(
              "Select Member",
              style: GoogleFonts.kumbhSans(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryDark,
              ),
            ),
            const SizedBox(height: 15),

            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: localController.searchController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  hintText: "Search member",
                  hintStyle: GoogleFonts.kumbhSans(color: Colors.grey[400]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                ),
              ),
            ),
            const SizedBox(height: 15),

            Expanded(
              child: Obx(() {
                if (localController.filteredUsers.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person_off, size: 48, color: Colors.grey[400]),
                        const SizedBox(height: 12),
                        Text(
                          "No members found",
                          style: GoogleFonts.kumbhSans(
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: localController.filteredUsers.length,
                  itemBuilder: (_, index) {
                    final user = localController.filteredUsers[index];
                    final name = user["name"].toString();

                    return Obx(() {
                      final isSelected =
                          localController.selectedPerson.value == name;

                      return GestureDetector(
                        onTap: () {
                          localController.selectedPerson.value = name;
                          localController.selectedMemberId.value =
                              int.parse(user["sno"].toString());
                          Get.back();
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary.withOpacity(0.1)
                                : Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primaryDark
                                  : Colors.transparent,
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.person_outlined,
                                color: isSelected
                                    ? AppColors.primaryDark
                                    : Colors.grey[500],
                                size: 28,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  name,
                                  style: GoogleFonts.kumbhSans(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected
                                        ? AppColors.primaryDark
                                        : Colors.black87,
                                  ),
                                ),
                              ),
                              if (isSelected)
                                Icon(
                                  Icons.check_circle,
                                  color: AppColors.primaryDark,
                                  size: 22,
                                ),
                            ],
                          ),
                        ),
                      );
                    });
                  },
                );
              }),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}