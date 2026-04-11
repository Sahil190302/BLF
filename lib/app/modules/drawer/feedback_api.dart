import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class FeedbackApi {
  static const String _url =
      "https://bhartiyacoders.com/WEBSITE/YASH/blf_app_akshay/api/index.php";

  static Future<bool> submitFeedback({
    required int userId,
    required int memberId,
    required String message,
  }) async {

    final date = DateFormat('yyyy-MM-dd').format(DateTime.now());

    print("------ SUBMIT FEEDBACK API ------");
    print("User ID (sender): $userId");
    print("Member ID (receiver): $memberId");
    print("Message: $message");
    print("Date: $date");

    final payload = {
      "action": "insert",
      "table": "feedback_testimonial",
      "data": {
        "user_id": userId,
        "member_id": memberId,
        "message": message,
        "date": date
      }
    };

    print("Payload:");
    print(jsonEncode(payload));

    final response = await http.post(
      Uri.parse(_url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(payload),
    );

    print("Status Code: ${response.statusCode}");
    print("Raw Response:");
    print(response.body);

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data["status"] == true) {
      print("Feedback inserted successfully");
      return true;
    } else {
      print("Feedback API Failed: ${data["message"]}");
      return false;
    }
  }
}