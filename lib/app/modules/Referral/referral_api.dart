import 'dart:convert';
import 'package:http/http.dart' as http;

class ReferralApi {

  static const String _url =
      "https://bhartiyacoders.com/WEBSITE/YASH/blf_app_akshay/api/index.php";

  /// FETCH REFERRALS
  static Future<List<Map<String, dynamic>>> fetchReferralsByField({
  required String field,
  required String value,
}) async {
  try {
    final response = await http.post(
      Uri.parse(_url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "action": "fetch",
        "table": "referral",
        "where": {field: value}
      }),
    ).timeout(const Duration(seconds: 15));

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data["status"] == true) {
      return List<Map<String, dynamic>>.from(data["data"]);
    } else {
      throw Exception("Referral data not found");
    }
  } catch (e) {
    throw Exception("Referral API error: $e");
  }
}

  /// UPDATE REFERRAL
 static Future<void> updateReferral({
  required int sno,
  required int referralUserId,
  required String referralType,
  required String referralStatus,
  required String email,
  required String mobile,
  required String address,
  required String comment,
  required String referralHotRating,
  required String date,
}) async {
  try {
    final response = await http.post(
      Uri.parse(_url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "action": "update",
        "table": "referral",
        "data": {
          "referral_user_id": referralUserId,
          "referral_type": referralType,
          "referral_status": referralStatus,
          "email": email,
          "mobile": mobile,
          "address": address,
          "comment": comment,
          "referral_hot_rating": referralHotRating,
          "date": date
        },
        "where": {
          "sno": sno
        }
      }),
    ).timeout(const Duration(seconds: 15));

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data["status"] == true) {
      return;
    } else {
      throw Exception(data["message"] ?? "Update failed");
    }
  } catch (e) {
    throw Exception("Update error: $e");
  }
}

  /// FETCH USER NAME
  static Future<String> fetchUserNameBySno(String sno) async {

    try {

      final response = await http.post(
        Uri.parse(_url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "action": "fetch",
          "table": "user",
          "where": {"sno": sno}
        }),
      ).timeout(const Duration(seconds: 15));

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 &&
          data["status"] == true &&
          data["data"] != null &&
          data["data"].isNotEmpty) {

        return data["data"][0]["name"] ?? "";

      } else {
        throw Exception("User not found");
      }

    } catch (e) {
      throw Exception("User fetch error: $e");
    }
  }

  /// DELETE REFERRAL
  static Future<void> deleteReferral(int sno) async {

    try {

      final response = await http.post(
        Uri.parse(_url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "action": "delete",
          "table": "referral",
          "id": sno
        }),
      ).timeout(const Duration(seconds: 15));

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data["status"] == true) {
        return;
      } else {
        throw Exception(data["message"] ?? "Delete failed");
      }

    } catch (e) {
      throw Exception("Delete error: $e");
    }
  }
}