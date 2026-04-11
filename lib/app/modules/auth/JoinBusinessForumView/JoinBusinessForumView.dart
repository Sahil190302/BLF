import 'package:blf/app/modules/auth/JoinBusinessForumView/JoinForumController.dart';
import 'package:blf/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../utils/app_colors.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/custom_textfield.dart';

class JoinBusinessForumView extends StatelessWidget {
  JoinBusinessForumView({super.key});

  final JoinForumController controller = Get.put(JoinForumController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        title: "Join Business Leaders Forum",
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// ================= PERSONAL INFORMATION =================
            _sectionTitle("Personal Information"),

            _label("Full Name *"),
            CustomTextField(
              hint: "Enter your full name",
              controller: controller.nameController,
            ),

            _label("Phone Number *"),
            CustomTextField(
              hint: "Enter phone number",
              keyboard: TextInputType.phone,
              controller: controller.phoneController,
            ),
            _label("Email ID *"),
            CustomTextField(
              hint: "example@email.com",
              keyboard: TextInputType.emailAddress,
              controller: controller.emailController,
            ),
            /// ================= BUSINESS PORTFOLIO =================
            _sectionTitle("Business Portfolio"),

            _label("Business Name *"),
            CustomTextField(
              hint: "Enter business name",
              controller: controller.businessNameController,
            ),

            _label("Category (e.g. IT, Legal) *"),
            CustomTextField(
              hint: "Enter category",
              controller: controller.businessCategoryController,
            ),

            _label("Business Age (e.g. 5 Years) *"),
            CustomTextField(
              hint: "Enter business age",
              controller: controller.businessDurationController,
            ),

            _label("Registration Number *"),
            CustomTextField(
              hint: "Enter registration number",
              controller: controller.registrationController,
            ),

            _label("Website URL (Optional)"),
            CustomTextField(
              hint: "https://www.example.com",
              controller: controller.websiteController,
            ),

            _label("Social Media Link (Optional)"),
            CustomTextField(
              hint: "Instagram / LinkedIn / LinkedIn",
              controller: controller.socialLinksController,
            ),



            _label("Office Address *"),
            CustomTextField(
              hint: "Enter complete office address",
              controller: controller.addressController,
              maxLines: 3,
            ),

            /// ================= IMPORTANT DATES =================
            _sectionTitle("Important Dates"),

            _datePicker(
              label: "Date of Birth *",
              date: controller.dob,
              onTap: () => controller.pickDate(context, controller.dob),
            ),

            _datePicker(
              label: "Anniversary (Optional)",
              date: controller.anniversary,
              onTap: () =>
                  controller.pickDate(context, controller.anniversary),
            ),

            /// ================= NETWORKING STATUS =================
            _sectionTitle("Networking Status"),

            _yesNoQuestion(
              "Are you part of any other referral networking groups? *",
              controller.isMemberOtherGroup,
            ),

            Obx(() => controller.isMemberOtherGroup.value
                ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _label("If YES, specify Group Name"),
                CustomTextField(
                  hint: "Enter group name",
                  controller: controller.otherGroupNameController,
                ),
              ],
            )
                : const SizedBox()),

            /// ================= MEETING TERMS =================
            _sectionTitle("Meeting Terms"),

            _infoText(
              "• Meeting will be held once in a month.\n"
                  "• 12-month meeting fee is compulsory.\n"
                  "• No exemption under any circumstances.\n"
                  "• Failure to attend two consecutive meetings without valid reason "
                  "will result in termination.",
            ),

            const SizedBox(height: 12),

            _checkbox("I agree to attend monthly meeting without fail.",
                controller.declaration1),

            _checkbox(
                "I will abide by BLF core values: Quality, Accountability, Credibility & Integrity.",
                controller.declaration2),

            _checkbox(
                "I will maintain decorum and respect fellow members.",
                controller.declaration3),

            _checkbox(
                "I will promote only my registered business category.",
                controller.declaration4),

            _checkbox(
                "I am not part of any other referral networking group. "
                    "If I join any, my BLF membership will terminate automatically.",
                controller.declaration5),

            const SizedBox(height: 20),

            /// ================= FINAL AGREEMENT =================
            _yesNoQuestion(
              "Do you agree with these terms? *",
              controller.finalAgreement,
            ),

            /// ================= REFERENCES =================
            _sectionTitle("Business References"),

            _label("Reference Name 1 *"),
            CustomTextField(
              hint: "Enter reference details",
              controller: controller.referenceOneController,
            ),

            _label("Reference Name 2 *"),
            CustomTextField(
              hint: "Enter reference details",
              controller: controller.referenceTwoController,
            ),

            /// ================= PHOTO =================
            _sectionTitle("Professional Photo"),

            _uploadBox(),

            const SizedBox(height: 30),

            CustomButton(
              text: "Submit Application",
              onTap: controller.submitForm,
            ),
          ],
        ),
      ),
    );
  }

  // ================= UI HELPERS =================

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 6),
      child: Text(
        text,
        style: GoogleFonts.kumbhSans(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 22, bottom: 10),
      child: Text(
        text,
        style: GoogleFonts.kumbhSans(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryDark,
        ),
      ),
    );
  }

  Widget _infoText(String text) {
    return Text(
      text,
      style: GoogleFonts.kumbhSans(fontSize: 14, color: Colors.grey[700]),
    );
  }

  Widget _checkbox(String title, RxBool value) {
    return Obx(() => CheckboxListTile(
      value: value.value,
      onChanged: (val) => value.value = val ?? false,
      activeColor: AppColors.primaryDark,
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: GoogleFonts.kumbhSans(fontSize: 13),
      ),
    ));
  }

  Widget _yesNoQuestion(String question, RxBool value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text(
          question,
          style: GoogleFonts.kumbhSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Obx(() => Row(
          children: ["YES", "NO"].map((e) {
            bool selected =
                (e == "YES" && value.value) ||
                    (e == "NO" && !value.value);

            return GestureDetector(
              onTap: () => value.value = e == "YES",
              child: Container(
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.symmetric(
                    horizontal: 18, vertical: 10),
                decoration: BoxDecoration(
                  color: selected
                      ? AppColors.primaryDark
                      : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.primaryDark,
                  ),
                ),
                child: Text(
                  e,
                  style: GoogleFonts.kumbhSans(
                    color: selected
                        ? Colors.white
                        : AppColors.primaryDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          }).toList(),
        )),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _datePicker({
    required String label,
    required Rx<DateTime> date,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.primaryDark,
            width: 1.2,
          ),
        ),
        child: Obx(() => Text(
          "$label: ${date.value.day}-${date.value.month}-${date.value.year}",
          style: GoogleFonts.kumbhSans(fontSize: 14),
        )),
      ),
    );
  }

  Widget _uploadBox() {
    return GestureDetector(
      onTap: controller.pickImage,
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primaryDark),
        ),
        child: Center(
          child: Obx(() => controller.imagePath.isEmpty
              ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.upload_file,
                  color: AppColors.primaryDark),
              const SizedBox(height: 8),
              Text(
                "Upload Professional Photo",
                style: GoogleFonts.kumbhSans(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Supported: JPG, PNG (Max 5MB)",
                style: GoogleFonts.kumbhSans(
                  fontSize: 11,
                  color: Colors.grey,
                ),
              ),
            ],
          )
              : Text(
            "Image Selected ✔",
            style: GoogleFonts.kumbhSans(
              color: AppColors.primaryDark,
              fontWeight: FontWeight.w600,
            ),
          )),
        ),
      ),
    );
  }


}
