import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ReferralSlipController extends GetxController {
  var selectedDate = DateTime.now().obs;

  var status = "Not Contacted Yet".obs;

  var comment = "".obs;

  var referralHot = 3.0.obs;

  List<String> statuses = [
    "Not Contacted Yet",
    "Contacted | No Response",
    "Got the Business",
    "Did Not Get the Business",
    "Not a Good Fit",
    "Confidential"
  ];

  Color getStatusColor(String s) {
    switch (s) {
      case "Not Contacted Yet":
        return Colors.grey;
      case "Contacted | No Response":
        return Colors.orange;
      case "Got the Business":
        return Colors.green;
      case "Did Not Get the Business":
        return Colors.red;
      case "Not a Good Fit":
        return Colors.blue;
      case "Confidential":
        return Colors.purple;
      default:
        return Colors.grey.shade700;
    }
  }
}
