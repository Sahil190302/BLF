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

  Future<void> submitTestimonial() async {
    if (selectedMemberId.value == 0 || testimonialCtrl.text.trim().isEmpty) {
      final context = Get.context;
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please fill all fields"),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    try {
      bool success = await FeedbackApi.submitFeedback(
        userId: currentUserId,
        memberId: selectedMemberId.value,
        message: testimonialCtrl.text.trim(),
      );

      final context = Get.context;

      if (success) {
        testimonialCtrl.clear();
        selectedPerson.value = "";
        selectedMemberId.value = 0;

        if (context != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Submitted successfully"),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        if (context != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Submission failed"),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      final context = Get.context;

      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Something went wrong"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

class FeedbackPage extends StatelessWidget {
  FeedbackPage({super.key});

  final FeedbackController controller = Get.put(FeedbackController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(
        title: "Testimonials & Feedback",
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Write a Testimonial",
              style: GoogleFonts.kumbhSans(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryDark,
              ),
            ),

            const SizedBox(height: 15),

            _label("Member Name"),
            _memberSelector(context),

            _label("Your Testimonial"),

            CustomTextField(
              hint: "Write your testimonial here...",
              controller: controller.testimonialCtrl,
              maxLines: 5,
            ),

            const SizedBox(height: 25),

            CustomButton(
              text: "Submit Testimonial",
              onTap: controller.submitTestimonial,
            ),
          ],
        ),
      ),
    );
  }

  Widget _memberSelector(BuildContext context) {
    return GestureDetector(
      onTap: () => _openPeopleBottomSheet(context),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade400),
        ),
        child: Obx(
          () => Row(
            children: [
              Expanded(
                child: Text(
                  controller.selectedPerson.value.isEmpty
                      ? "Select Member"
                      : controller.selectedPerson.value,
                  style: GoogleFonts.kumbhSans(fontSize: 15),
                ),
              ),
              const Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
      ),
    );
  }

  void _openPeopleBottomSheet(BuildContext context) {
    Get.bottomSheet(
      Obx(() {
        return Container(
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
                ),
              ),

              const SizedBox(height: 15),

              TextField(
                controller: controller.searchController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: "Search member",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              Expanded(
                child: ListView.builder(
                  itemCount: controller.filteredUsers.length,
                  itemBuilder: (_, index) {
                    final user = controller.filteredUsers[index];
                    final name = user["name"].toString();

                    return GestureDetector(
                      onTap: () {
                        controller.selectedPerson.value = name;
                        controller.selectedMemberId.value = int.parse(
                          user["sno"].toString(),
                        );

                        Get.back();
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          name,
                          style: GoogleFonts.kumbhSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }),
      isScrollControlled: true,
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, top: 12),
      child: Text(
        text,
        style: GoogleFonts.kumbhSans(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }
}
