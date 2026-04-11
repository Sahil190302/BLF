import 'package:blf/app/services/app_session.dart';
import 'package:blf/app/services/home_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/app_loader.dart';
import '../../../utils/app_snackbar.dart';
import '../../../utils/app_validation.dart';
import '../../services/api_exception.dart';
import '../../services/repo/app_repo.dart';

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
  RxList<String> selectedPersons = <String>[].obs;

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
  void submitTYFCB() async {
    print("STEP 1 → Submit clicked");

    try {
      if (selectedPersons.isEmpty) {
        print("STEP 2 → No persons selected");
        throw Exception("Please select at least one person");
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
          .where((u) => selectedPersons.contains(u['name']))
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

      Future.delayed(const Duration(milliseconds: 250), () {
        final context = Get.context;
        if (context != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Acknowledgement submitted successfully")),
          );
        }
      });
    } catch (e, stack) {
      print("ERROR OCCURRED → $e");
      print("STACK TRACE → $stack");
      AppLoader.hide();

      AppSnackbar.error(e.toString());
    }
  }

  @override
  void onClose() {
    amount.dispose();
    searchController.dispose();
    super.onClose();
  }
}
