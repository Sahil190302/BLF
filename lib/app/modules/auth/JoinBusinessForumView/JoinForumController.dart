import 'dart:io';
import 'package:blf/app/modules/auth/JoinBusinessForumView/join_api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../utils/app_loader.dart';
import '../../../../utils/app_snackbar.dart';

class JoinForumController extends GetxController {
  final nameController = TextEditingController();
  final businessNameController = TextEditingController();
  final businessCategoryController = TextEditingController();
  final websiteController = TextEditingController();
  final socialLinksController = TextEditingController();
  final businessDurationController = TextEditingController();
  final registrationController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  final otherGroupNameController = TextEditingController();
  final referenceOneController = TextEditingController();
  final referenceTwoController = TextEditingController();

  var dob = DateTime.now().obs;
  var anniversary = DateTime.now().obs;

  var isMemberOtherGroup = false.obs;

  RxBool declaration1 = false.obs;
  RxBool declaration2 = false.obs;
  RxBool declaration3 = false.obs;
  RxBool declaration4 = false.obs;
  RxBool declaration5 = false.obs;

  RxBool finalAgreement = false.obs;

  var imagePath = "".obs;

  void pickDate(BuildContext context, Rx<DateTime> date) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: date.value,
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      date.value = picked;
    }
  }

  void pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      imagePath.value = image.path;
    }
  }

  void submitForm() async {
    try {
      debugPrint("=== SUBMIT BUTTON PRESSED ===");

      AppLoader.show();

      debugPrint("Calling Join API...");

      final response = await JoinApiService.submitJoinForm(
        referral1: referenceOneController.text,
        referral2: referenceTwoController.text,
        name: nameController.text,
        email: emailController.text,
        mobile: phoneController.text,
        businessName: businessNameController.text,
        businessCategory: businessCategoryController.text,
        registrationNo: registrationController.text,
        businessAddress: addressController.text,
        website: websiteController.text,
        socialLink: socialLinksController.text,
        businessYear: businessDurationController.text,
        isOtherGroupMember: isMemberOtherGroup.value ? "Yes" : "No",
        termsAgree: finalAgreement.value ? "Yes" : "No",
        yearlyFeeAgree: declaration1.value ? "Yes" : "No",
        profileImage: imagePath.value.isNotEmpty ? File(imagePath.value) : null,
      );

      debugPrint("API Response Received:");
      debugPrint(response.toString());

      AppLoader.hide();

      await Future.delayed(const Duration(milliseconds: 150));

      final context = Get.context;

      if (context != null) {
        if (response != null && response["status"] == true) {
          clearForm();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Application Submitted Successfully")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response?["message"] ?? "Submission Failed"),
            ),
          );
        }
      }
    } catch (e, stackTrace) {
      AppLoader.hide();
      debugPrint("API ERROR OCCURRED:");
      debugPrint(e.toString());
      debugPrint(stackTrace.toString());
      await Future.delayed(const Duration(milliseconds: 150));

      final context = Get.context;

      if (context != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Something went wrong")));
      }
    }
  }

  void clearForm() {
    nameController.clear();
    phoneController.clear();
    emailController.clear();
    businessNameController.clear();
    businessCategoryController.clear();
    businessDurationController.clear();
    registrationController.clear();
    websiteController.clear();
    socialLinksController.clear();
    addressController.clear();
    otherGroupNameController.clear();
    referenceOneController.clear();
    referenceTwoController.clear();

    isMemberOtherGroup.value = false;
    declaration1.value = false;
    declaration2.value = false;
    declaration3.value = false;
    declaration4.value = false;
    declaration5.value = false;
    finalAgreement.value = false;

    dob.value = DateTime.now();
    anniversary.value = DateTime.now();

    imagePath.value = "";
  }
}
