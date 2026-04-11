import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class MyConnectionsController extends GetxController {

  final searchController = TextEditingController();

  var connections = <Map<String, String>>[
    {
      "name": "Abhilash Joshi",
      "profession": "Kitchen Construction",
      "image": "https://randomuser.me/api/portraits/men/32.jpg",
    },
    {
      "name": "Ankur Goyal",
      "profession": "Dentist",
      "image": "https://randomuser.me/api/portraits/men/45.jpg",
    },
    {
      "name": "Anupam Jangid",
      "profession": "Manufacturing (Other)",
      "image": "https://randomuser.me/api/portraits/men/66.jpg",
    },
    {
      "name": "Anurag Gangwal",
      "profession": "Tax Advisor",
      "image": "https://randomuser.me/api/portraits/men/18.jpg",
    },
    {
      "name": "Arun Sharma",
      "profession": "Construction (Other)",
      "image": "https://randomuser.me/api/portraits/men/53.jpg",
    },
    {
      "name": "Aziz Khan",
      "profession": "Car & Motorcycle (Other)",
      "image": "https://randomuser.me/api/portraits/men/72.jpg",
    },
    {
      "name": "Himani Arora",
      "profession": "Digital Marketing",
      "image": "https://randomuser.me/api/portraits/women/48.jpg",
    },
  ].obs;
  final filteredConnections = <Map<String, String>>[].obs;

  @override
  void onInit() {
    super.onInit();

    filteredConnections.assignAll(connections);

    searchController.addListener(() {
      updateSearch(searchController.text);
    });
  }

  void updateSearch(String query) {
    if (query.isEmpty) {
      filteredConnections.assignAll(connections);
    } else {
      filteredConnections.assignAll(
        connections.where((item) =>
            item["name"]!.toLowerCase().contains(query.toLowerCase())),
      );
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
