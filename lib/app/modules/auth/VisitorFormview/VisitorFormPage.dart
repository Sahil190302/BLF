import 'dart:io';
import 'package:blf/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/app_colors.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/custom_textfield.dart';
import 'VisitorController.dart';

class VisitorView extends StatelessWidget {
  VisitorView({super.key});

  final VisitorController controller = Get.put(VisitorController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        title: "Visitor Form",
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            _label("Name"),
            CustomTextField(
              hint: "Enter your full name",
              controller: controller.nameCtrl,
            ),

            _label("Business Name"),
            CustomTextField(
              hint: "Enter business name",
              controller: controller.businessNameCtrl,
            ),

            _label("Business Category"),
            CustomTextField(
              hint: "e.g. IT, Trading, Manufacturing",
              controller: controller.businessCategoryCtrl,
            ),

            _label("Business Website"),
            CustomTextField(
              hint: "https://www.example.com",
              controller: controller.websiteCtrl,
              keyboard: TextInputType.url,
            ),

            _label("How long have you been in this business"),
            CustomTextField(
              hint: "e.g. 3 years",
              controller: controller.experienceCtrl,
            ),

            _label("Email Address"),
            CustomTextField(
              hint: "example@email.com",
              controller: controller.emailCtrl,
              keyboard: TextInputType.emailAddress,
            ),

            _label("Business Address"),
            CustomTextField(
              hint: "Enter complete business address",
              controller: controller.addressCtrl,
              maxLines: 3,
            ),

            _label("Phone Number"),
            CustomTextField(
              hint: "Enter phone number",
              controller: controller.phoneCtrl,
              keyboard: TextInputType.phone,
            ),

            const SizedBox(height: 20),
            _sectionTitle("Business Networking"),

            _yesNoQuestion(
              "Are you a member of any other business networking group?",
              controller.isOtherGroupMemberBool,
            ),

            Obx(() => controller.isOtherGroupMemberBool.value
                ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _label("Other Group Name"),
                CustomTextField(
                  hint: "Enter group name",
                  controller: controller.otherGroupNameCtrl,
                ),
              ],
            )
                : const SizedBox()),

            _label("Referral Code of the member who is inviting you"),
            CustomTextField(
              hint: "Enter Referral Code ",
              controller: controller.invitedByCtrl,
            ),

            const SizedBox(height: 20),
            _sectionTitle("Visitor Meeting Contribution"),

            _infoText(
              "Please scan the QR code for visitor meeting contribution "
                  "and pay ₹1200/-",
            ),

            // QR CODE
            const SizedBox(height: 10),

            _sectionTitle("Scan QR code and pay ₹1200/-"),

            const SizedBox(height: 10),

            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey),
              ),
              child: Image.network(
                "https://img.freepik.com/premium-vector/vector-qr-code-example-smartphone-scan_535345-3786.jpg?semt=ais_hybrid&w=740&q=80", // YOUR QR IMAGE
                fit: BoxFit.contain,
              ),
            ),

            _sectionTitle("Upload Payment Screenshot (After Payment)"),

            _uploadBox(),

            const SizedBox(height: 30),

            CustomButton(
              text: "Submit Visitor Form",
              onTap: controller.submitVisitorForm,
            ),
          ],
        ),
      ),
    );
  }

  // ================= UI HELPERS =================

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, top: 12),
      child: Text(
        text,
        style: GoogleFonts.kumbhSans(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Colors.grey[700],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 20),
      child: Text(
        text,
        style: GoogleFonts.kumbhSans(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryDark,
        ),
      ),
    );
  }

  Widget _infoText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: GoogleFonts.kumbhSans(
          fontSize: 14,
          color: Colors.grey[700],
        ),
      ),
    );
  }

  Widget _yesNoQuestion(String question, RxBool value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: GoogleFonts.kumbhSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Obx(() => Row(
          children: ["Yes", "No"].map((e) {
            bool selected =
                (e == "Yes" && value.value) ||
                    (e == "No" && !value.value);
            return GestureDetector(
              onTap: () => value.value = e == "Yes",
              child: Container(
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.symmetric(
                    horizontal: 18, vertical: 10),
                decoration: BoxDecoration(
                  color: selected
                      ? AppColors.primaryDark
                      : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.green),
                ),
                child: Text(
                  e,
                  style: GoogleFonts.kumbhSans(
                    color: selected
                        ? Colors.white
                        : AppColors.black,
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

  Widget _uploadBox() {
    return GestureDetector(
      onTap: controller.pickPaymentImage,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primaryDark),
        ),
        child: Center(
          child: Obx(() => controller.paymentImage.value == null
              ? Text(
            "Upload Payment Screenshot\n(Max 10MB, Image Only)",
            textAlign: TextAlign.center,
            style:
            GoogleFonts.kumbhSans(color: Colors.grey),
          )
              : Text(
            "Payment Image Selected",
            style: GoogleFonts.kumbhSans(

                color: AppColors.primaryDark),
          )),
        ),
      ),
    );
  }
}
