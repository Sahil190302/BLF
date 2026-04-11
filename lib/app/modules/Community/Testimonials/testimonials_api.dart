import 'dart:convert';
import 'package:http/http.dart' as http;

class TestimonialsApi {
    static const String baseImageUrl =
      "https://bhartiyacoders.com/WEBSITE/YASH/blf_app_akshay/";
  static const String _url =
      "https://bhartiyacoders.com/WEBSITE/YASH/blf_app_akshay/api/index.php";

  /// RECEIVED → given_user_id = sno AND status = 1
  static Future<List<dynamic>> fetchReceived(String userSno) async {
    final response = await http.post(
      Uri.parse(_url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "action": "fetch",
        "table": "thankyou_given",
        "where": {"given_user_id": userSno, "status": 1},
      }),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200 && data["status"] == true) {
      return data["data"];
    }
    return [];
  }

  static Future<bool> acceptTestimonial(int sno) async {
  final response = await http.post(
    Uri.parse(_url),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "action": "update",
      "table": "thankyou_given",
      "data": {"status": "1"},
      "where": {"sno": sno}
    }),
  );

  final data = jsonDecode(response.body);

  return response.statusCode == 200 && data["status"] == true;
}

static Future<bool> rejectTestimonial(int sno) async {
  final response = await http.post(
    Uri.parse(_url),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "action": "update",
      "table": "thankyou_given",
      "data": {"status": "2"},
      "where": {"sno": sno}
    }),
  );

  final data = jsonDecode(response.body);

  return response.statusCode == 200 && data["status"] == true;
}

  static Future<Map<String, dynamic>?> fetchUserBySno(String sno) async {
  try {
    final response = await http.post(
      Uri.parse(_url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "action": "fetch",
        "table": "user",
        "where": {"sno": sno},
      }),
    );

    if (response.statusCode != 200) return null;

    final data = jsonDecode(response.body);

    if (data["status"] == true && data["data"] != null && data["data"].isNotEmpty) {
      return data["data"][0];
    }

    return null;
  } catch (_) {
    return null;
  }
}

  /// GIVEN → user_id = sno AND status = 1
  static Future<List<dynamic>> fetchGiven(String userSno) async {
    final response = await http.post(
      Uri.parse(_url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "action": "fetch",
        "table": "thankyou_given",
        "where": {"user_id": userSno, "status": 1},
      }),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200 && data["status"] == true) {
      return data["data"];
    }
    return [];
  }

  /// REQUESTS → given_user_id = sno AND status = 0
  static Future<List<dynamic>> fetchRequests(String userSno) async {
    final response = await http.post(
      Uri.parse(_url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "action": "fetch",
        "table": "thankyou_given",
        "where": {"given_user_id": userSno, "status": 0},
      }),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200 && data["status"] == true) {
      return data["data"];
    }
    return [];
  }

  static Future<bool> deleteTestimonial(int id) async {
    final response = await http.post(
      Uri.parse(_url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "action": "delete",
        "table": "thankyou_given",
        "id": id,
      }),
    );

    final data = jsonDecode(response.body);

    return response.statusCode == 200 && data["status"] == true;
  }
}
