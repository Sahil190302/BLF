import 'dart:io';
import 'package:blf/app/modules/visitors/visitor_api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class VisitorController extends GetxController {
  RxBool isOtherGroupMemberBool = false.obs;

  final nameCtrl = TextEditingController();
  final businessNameCtrl = TextEditingController();
  final businessCategoryCtrl = TextEditingController();
  final websiteCtrl = TextEditingController();
  final experienceCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final otherGroupNameCtrl = TextEditingController();
  final invitedByCtrl = TextEditingController();

  Rx<File?> paymentImage = Rx<File?>(null);
  RxBool isLoading = false.obs;

  final ImagePicker _picker = ImagePicker();

  // Image Picker
  Future<void> pickPaymentImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      paymentImage.value = File(image.path);
    }
  }

  // Submit API Call
  Future<void> submitVisitorForm() async {
    if (nameCtrl.text.isEmpty ||
        emailCtrl.text.isEmpty ||
        phoneCtrl.text.isEmpty) {
      showMessage("Error", "Please fill required fields");
      return;
    }

    isLoading.value = true;

    try {
      final response = await VisitorApiService.submitVisitor(
        name: nameCtrl.text.trim(),
        email: emailCtrl.text.trim(),
        mobile: phoneCtrl.text.trim(),
        businessName: businessNameCtrl.text.trim(),
        businessCategory: businessCategoryCtrl.text.trim(),
        businessWebsite: websiteCtrl.text.trim(),
        businessYear: experienceCtrl.text.trim(),
        businessAddress: addressCtrl.text.trim(),
        isOtherGroupMember: isOtherGroupMemberBool.value ? "Yes" : "No",
        referralCode: invitedByCtrl.text.trim(),
        paymentImage: paymentImage.value,
      );

      if (response["status"] == true) {
        clearForm();
        showMessage("Success", "Visitor form submitted successfully");
      } else {
        showMessage("Error", "Submission failed");
      }
    } catch (e) {
      showMessage("Error", e.toString());
    }

    isLoading.value = false;
  }

  void showMessage(String title, String message) {
    if (Get.context != null) {
      ScaffoldMessenger.of(
        Get.context!,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  void clearForm() {
    nameCtrl.clear();
    businessNameCtrl.clear();
    businessCategoryCtrl.clear();
    websiteCtrl.clear();
    experienceCtrl.clear();
    emailCtrl.clear();
    addressCtrl.clear();
    phoneCtrl.clear();
    otherGroupNameCtrl.clear();
    invitedByCtrl.clear();
    paymentImage.value = null;
  }
}
