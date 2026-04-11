import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthApi {
  static const String _url =
      "https://bhartiyacoders.com/WEBSITE/YASH/blf_app_akshay/api/index.php";

  static Future<String> login(String email, String password) async {
    final response = await http.post(
      Uri.parse(_url),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "action": "user_login",
        "email": email,
        "password": password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data["status"] == true) {
      return data["token"];
    } else {
      throw Exception("Invalid credentials");
    }
  }
}