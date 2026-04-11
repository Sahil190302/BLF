import 'dart:convert';
import 'package:http/http.dart' as http;
import 'search_model.dart';

class SearchApi {
  static const String url =
      "https://bhartiyacoders.com/WEBSITE/YASH/blf_app_akshay/api/index.php";

  static Future<List<SearchUser>> fetchUsers() async {
    final payload = {
      "action": "fetch",
      "table": "user",
    };

    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode(payload),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      if (decoded["status"] == true) {
        List data = decoded["data"];

        return data.map((e) => SearchUser.fromJson(e)).toList();
      }
    }

    return [];
  }
}