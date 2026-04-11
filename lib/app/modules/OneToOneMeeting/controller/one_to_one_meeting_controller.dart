import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../utils/app_loader.dart';
import '../../../../utils/app_snackbar.dart';
import '../../../../utils/app_validation.dart';
import '../../../services/api_exception.dart';
import '../../../services/repo/app_repo.dart';
import '../../../services/home_api.dart';
import '../../../services/app_session.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class OneToOneMeetingController extends GetxController {
  /// USERS FROM API
  RxList<Map<String, dynamic>> users = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> filteredUsers = <Map<String, dynamic>>[].obs;

  /// SELECTED PERSONS (NAMES)
  RxList<String> selectedPersons = <String>[].obs;
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

  void submitMeeting() async {
    print("STEP 1 → Submit clicked");

    if (selectedPersons.isEmpty) {
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
          .where((u) => selectedPersons.contains(u['name']))
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
      selectedPersons.clear();
      locationController.clear();
      agenda.value = '';
      summary.value = '';
      meetingImage.value = null;
      selectedInitiatedBy.value = "Myself";
      meetingDate.value = DateTime.now();

      await Future.delayed(const Duration(milliseconds: 150));

      final context = Get.context;

      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Meeting Scheduled Successfully")),
        );
      }
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

  @override
  void onClose() {
    locationController.dispose();
    searchController.dispose();
    super.onClose();
  }
}
