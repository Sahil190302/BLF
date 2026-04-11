import 'package:blf/app/services/app_session.dart';
import 'package:blf/app/services/home_api.dart';
import 'package:blf/app/services/repo/app_repo.dart';
import 'package:blf/utils/app_snackbar.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

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

  RxList<String> selectedPersons = <String>[].obs;

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

  Future<void> submitOutsideReferral() async {
    print("STEP 1 → Confirm clicked");

    if (selectedPersons.isEmpty ||
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
          .where((u) => selectedPersons.contains(u['name']))
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

      await Future.delayed(const Duration(milliseconds: 150));

      final context = Get.context;

      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              response != null && response["status"] == true
                  ? "Referral Confirmed Successfully"
                  : "Referral submission failed",
            ),
          ),
        );
      }

      if (response != null && response["status"] == true) {
        selectedPersons.clear();
        selectedStatus.value = "";
        phone.clear();
        email.clear();
        address.clear();
        comment.value = "";
        hotLevel.value = 5.0;
        referralType.value = "Outside";

        Future.delayed(const Duration(milliseconds: 250), () {
          Get.snackbar(
            "Success",
            "Referral Confirmed Successfully",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        });
      } else {
        Future.delayed(const Duration(milliseconds: 250), () {
          Get.snackbar(
            "Error",
            "Referral submission failed",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        });
      }
    } catch (e, stack) {
      print("ERROR → $e");
      print("STACK → $stack");
      AppLoader.hide();
      AppSnackbar.error(e.toString());
    }
  }

  @override
  void onClose() {
    phone.dispose();
    email.dispose();
    address.dispose();
    commentController.dispose();
    super.onClose();
  }
}
