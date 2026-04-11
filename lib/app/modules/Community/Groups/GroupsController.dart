import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'group_api.dart';

class GroupsController extends GetxController {

  final searchController = TextEditingController();
  final searchQuery = "".obs;

  final groups = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    fetchGroups();

    searchController.addListener(() {
      searchQuery.value = searchController.text;
    });
  }

  Future<void> fetchGroups() async {

    try {

      isLoading.value = true;

      final data = await GroupsApi.fetchGroups();

      groups.assignAll(data);

    } catch (e) {

      print("Group fetch error: $e");

    } finally {

      isLoading.value = false;

    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}