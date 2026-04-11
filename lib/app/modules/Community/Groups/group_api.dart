import 'dart:convert';
import 'package:http/http.dart' as http;

class GroupsApi {
  static const String apiUrl =
      "https://bhartiyacoders.com/WEBSITE/YASH/blf_app_akshay/api/index.php";

  static const String imageBaseUrl =
      "https://bhartiyacoders.com/WEBSITE/YASH/blf_app_akshay/img/";

  static Future<List<Map<String, dynamic>>> fetchGroups() async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"action": "fetch", "table": "group"}),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      if (jsonData["status"] == true) {
        List list = jsonData["data"];

        return list.map<Map<String, dynamic>>((g) {
          String img = g["profile_image"] ?? "";
          img = img.replaceAll("../img/", "");

          return {
            "sno": g["sno"],
            "icon": imageBaseUrl + img,
            "name": g["name"] ?? "",
            "since": g["since_year"] ?? "",
            "description": g["group_description"] ?? "",
            "members": g["invite_connection"] ?? "0",
            "creator": g["language"] ?? "",
            "lastPost": g["date"] ?? "",
          };
        }).toList();
      }
    }

    return [];
  }
}
