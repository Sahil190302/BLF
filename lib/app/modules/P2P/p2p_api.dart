import 'dart:convert';
import 'package:http/http.dart' as http;

class P2PApi {
  static const String _url =
      "https://bhartiyacoders.com/WEBSITE/YASH/blf_app_akshay/api/index.php";

  static Future<List<Map<String, dynamic>>> fetchMeetings({
    required String userId,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse(_url),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({
              "action": "fetch",
              "table": "meeting_one_to_one",
              "where": {"user_id": userId}
            }),
          )
          .timeout(const Duration(seconds: 15));

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 &&
          data["status"] == true) {
        return List<Map<String, dynamic>>.from(
            data["data"]);
      } else {
        throw Exception("P2P data not found");
      }
    } catch (e) {
      throw Exception("P2P API error: $e");
    }
  }
  static Future<void> deleteMeeting(int sno) async {
  try {
    final response = await http
        .post(
          Uri.parse(_url),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "action": "delete",
            "table": "meeting_one_to_one",
            "id": sno
          }),
        )
        .timeout(const Duration(seconds: 15));

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 &&
        data["status"] == true) {
      return;
    } else {
      throw Exception(
          data["message"] ?? "Delete failed");
    }
  } catch (e) {
    throw Exception("Delete error: $e");
  }
}
}