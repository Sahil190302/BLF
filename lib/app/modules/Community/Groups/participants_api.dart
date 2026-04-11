import 'dart:convert';
import 'package:http/http.dart' as http;

class ParticipantsApi {

  static const String apiUrl =
      "https://bhartiyacoders.com/WEBSITE/YASH/blf_app_akshay/api/index.php";

  static const String imageBaseUrl =
      "https://bhartiyacoders.com/WEBSITE/YASH/blf_app_akshay/img/";

  static Future<List<Map<String, dynamic>>> fetchParticipants(int groupId) async {

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "action": "fetch",
        "table": "group_join",
        "where": {"group_id": groupId}
      }),
    );

    if (response.statusCode != 200) return [];

    final groupJoinData = jsonDecode(response.body);

    if (groupJoinData["status"] != true) return [];

    List joinList = groupJoinData["data"];

    List<Map<String, dynamic>> participants = [];

    for (var join in joinList) {

      int userId = join["user_id"];

      final userRes = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "action": "fetch",
          "table": "user",
          "where": {"sno": userId}
        }),
      );

      if (userRes.statusCode == 200) {

        final userData = jsonDecode(userRes.body);

        if (userData["status"] == true && userData["data"].isNotEmpty) {

          var user = userData["data"][0];

          String profile = user["profile_image"] ?? "";

          participants.add({
            "name": user["name"] ?? "User",
            "image": profile.isEmpty ? "" : imageBaseUrl + profile
          });
        }
      }
    }

    return participants;
  }
}