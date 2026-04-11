import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'visitor_api_service.dart';

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

  Future<void> submitVisitorForm() async {
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
      }
    } catch (_) {}
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
