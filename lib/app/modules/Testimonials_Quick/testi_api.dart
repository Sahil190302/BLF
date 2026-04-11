import 'dart:convert';
import 'package:http/http.dart' as http;

class TestimonialApi {

  static const String url =
      "https://bhartiyacoders.com/WEBSITE/YASH/blf_app_akshay/api/index.php";

  // RECEIVED TESTIMONIALS (user received)
  static Future<List<Map<String, dynamic>>> fetchReceived(String userId) async {

    final payload = {
      "action": "fetch",
      "table": "feedback_testimonial",
      "where": {"user_id": userId}
    };

    print("----- FETCH RECEIVED TESTIMONIAL -----");
    print("Payload: ${jsonEncode(payload)}");

    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(payload),
    );

    print("Response: ${response.body}");

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data["status"] == true) {
      return List<Map<String, dynamic>>.from(data["data"]);
    }

    return [];
  }

  // GIVEN TESTIMONIALS (user gave)
  static Future<List<Map<String, dynamic>>> fetchGiven(String memberId) async {

    final payload = {
      "action": "fetch",
      "table": "feedback_testimonial",
      "where": {"member_id": memberId}
    };

    print("----- FETCH GIVEN TESTIMONIAL -----");
    print("Payload: ${jsonEncode(payload)}");

    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(payload),
    );

    print("Response: ${response.body}");

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data["status"] == true) {
      return List<Map<String, dynamic>>.from(data["data"]);
    }

    return [];
  }

  // FETCH USER NAME
  static Future<String> fetchUserName(String sno) async {

    final payload = {
      "action": "fetch",
      "table": "user",
      "where": {"sno": sno}
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(payload),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data["status"] == true) {
      return data["data"][0]["name"] ?? "";
    }

    return "";
  }
}