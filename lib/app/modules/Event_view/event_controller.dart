import 'dart:convert';
import 'package:blf/app/services/home_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class EventsController extends GetxController {
  final List<String> notificationTypes = ["once", "yearly"];
  var notificationType = "yearly".obs;

  final notificationPushDate = TextEditingController();

  var notificationTitle = ''.obs;
  var notificationDetail = ''.obs;
  var isLoading = false.obs;

  static const String _url =
      "https://bhartiyacoders.com/WEBSITE/YASH/blf_app_akshay/api/index.php";

  Future<bool> submitEvent() async {
    try {
      isLoading.value = true;

      final userData = await HomeApi.fetchUser();
      final String userSno = userData["sno"].toString();

      if (notificationTitle.value.trim().isEmpty ||
          notificationDetail.value.trim().isEmpty ||
          notificationPushDate.text.trim().isEmpty) {
        return false;
      }

      final currentDate =
          DateTime.now().toIso8601String().split('T').first;

      final response = await http
          .post(
            Uri.parse(_url),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({
              "action": "insert",
              "table": "notification",
              "data": {
                "user_id": userSno,
                "notification_detail":
                    notificationDetail.value.trim(),
                "notification_title":
                    notificationTitle.value.trim(),
                "date": currentDate,
                "notification_push_date":
                    notificationPushDate.text.trim(),
              }
            }),
          )
          .timeout(const Duration(seconds: 20));

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 &&
          data["status"] == true) {
        notificationTitle.value = '';
        notificationDetail.value = '';
        notificationPushDate.clear();
        return true;
      }

      return false;
    } catch (_) {
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    notificationPushDate.dispose();
    super.onClose();
  }
}