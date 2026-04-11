import 'dart:convert';
import 'package:http/http.dart' as http;

class UpdateBioApi {
  static const String _url =
      "https://bhartiyacoders.com/WEBSITE/YASH/blf_app_akshay/api/index.php";

  static Future<bool> updateUserBio({
    required int sno,
    required Map<String, dynamic> data,
  }) async {
    final response = await http.post(
      Uri.parse(_url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "action": "update",
        "table": "user",
        "data": data,
        "where": {"sno": sno},
      }),
    );

    final res = jsonDecode(response.body);
    return response.statusCode == 200 && res["status"] == true;
  }
}
