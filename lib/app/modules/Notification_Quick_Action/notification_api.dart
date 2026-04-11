import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class NotificationApi {

  static const String _url =
      "https://bhartiyacoders.com/WEBSITE/YASH/blf_app_akshay/api/index.php";

  static Future<List<Map<String, dynamic>>> fetchNotifications({
    required String userId,
  }) async {

    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    final response = await http.post(
      Uri.parse(_url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "action": "fetch",
        "table": "notification",
        "where": {
          "user_id": userId,
          "notification_push_date": today,
          "user_seen": "0"
        }
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data["status"] == true) {
      return List<Map<String, dynamic>>.from(data["data"]);
    }

    return [];
  }

  static Future<bool> processNotification({
    required int userId,
    required int notificationId,
  }) async {

    final response = await http.post(
      Uri.parse(_url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "action": "process_notification",
        "user_id": userId,
        "notification_id": notificationId
      }),
    );

    final data = jsonDecode(response.body);

    return response.statusCode == 200 && data["status"] == true;
  }

  static Future<int> fetchNotificationCount({
    required String userId,
  }) async {

    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    final response = await http.post(
      Uri.parse(_url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "action": "count_table_row",
        "table": "notification",
        "where": {
          "user_id": userId,
          "notification_push_date": today,
          "user_seen": "0"
        }
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data["status"] == true) {
      return data["count"] ?? 0;
    }

    return 0;
  }
}