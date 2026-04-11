import 'package:get/get.dart';
import 'package:flutter/material.dart';

class AddConnectionController extends GetxController {
  TextEditingController searchController = TextEditingController();

  var isSearching = false.obs;

  // Dummy data
  var connections = [
    {
      "name": "Kanchan Lalwani",
      "profession": "Construction",
      "group": "BNI Titans",
    },
    {
      "name": "Mandeep Manchanda",
      "profession": "Retail",
      "group": "HIGH FLYER",
    },
    {
      "name": "Ravi Chhajer",
      "profession": "Construction",
      "group": "BNI Amber",
    },
  ].obs;

  void searchConnection() {
    isSearching.value = true;

    // simulate API delay
    Future.delayed(const Duration(seconds: 1), () {
      isSearching.value = false;
    });
  }

  void addConnection(int index) {
    Get.snackbar(
      "Success",
      "Connection request sent to ${connections[index]['name']}",
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
