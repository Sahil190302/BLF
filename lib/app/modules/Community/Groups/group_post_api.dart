import 'dart:convert';
import 'package:http/http.dart' as http;

class GroupPostApi {
  static const String apiUrl =
      "https://bhartiyacoders.com/WEBSITE/YASH/blf_app_akshay/api/index.php";

  static const String imageBaseUrl =
      "https://bhartiyacoders.com/WEBSITE/YASH/blf_app_akshay/img/";

  // -------------------------------------------------------
  // FETCH GROUP POSTS
  // -------------------------------------------------------
  static Future<List<Map<String, dynamic>>> fetchPosts(int groupId) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "action": "fetch",
        "table": "group_post",
        "where": {"group_id": groupId.toString()},
      }),
    );

    if (response.statusCode != 200) return [];

    final data = jsonDecode(response.body);

    if (data["status"] != true) return [];

    List posts = data["data"];

    List<Map<String, dynamic>> result = [];

    for (var p in posts) {
      final user = await fetchUserProfile(p["user_id"]);

      String img = user["profile_image"] ?? "";
      img = img.replaceAll("../img/", "");

      int commentCount = 0;

      try {
        final commentResponse = await http.post(
          Uri.parse(apiUrl),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "action": "fetch",
            "table": "group_post_comment",
            "where": {"group_post_id": p["sno"].toString()},
          }),
        );

        if (commentResponse.statusCode == 200) {
          final commentData = jsonDecode(commentResponse.body);

          if (commentData["status"] == true) {
            commentCount = commentData["data"].length;
          }
        }
      } catch (_) {}

      result.add({
        "sno": p["sno"],
        "title": p["title"] ?? "",
        "content": p["detail"] ?? "",
        "date": p["show_date"] ?? "",
        "postedBy": user["name"] ?? "User",
        "image": img.isEmpty ? "" : imageBaseUrl + img,
        "comments": commentCount,
      });
    }

    return result;
  }

  // -------------------------------------------------------
  // ADD GROUP POST
  // -------------------------------------------------------
  static Future<bool> addPost({
    required int groupId,
    required int userId,
    required String title,
    required String detail,
    required String date,
  }) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "action": "insert",
        "table": "group_post",
        "data": {
          "group_id": groupId.toString(),
          "user_id": userId.toString(),
          "title": title,
          "detail": detail,
          "show_date": date,
          "date": date,
        },
      }),
    );

    if (response.statusCode != 200) return false;

    final data = jsonDecode(response.body);

    return data["status"] == true;
  }

  // -------------------------------------------------------
  // FETCH USER PROFILE
  // -------------------------------------------------------
  static Future<Map<String, dynamic>> fetchUserProfile(dynamic userId) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "action": "fetch",
        "table": "user",
        "where": {"sno": userId.toString()},
      }),
    );

    if (response.statusCode != 200) return {};

    final data = jsonDecode(response.body);

    if (data["status"] != true) return {};

    if (data["data"] == null || data["data"].isEmpty) {
      return {"name": "User", "profile_image": ""};
    }

    return data["data"][0];
  }

  // -------------------------------------------------------
  // ADD COMMENT
  // -------------------------------------------------------
  static Future<bool> addComment({
    required int postId,
    required int userId,
    required String comment,
    required String date,
  }) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "action": "insert",
        "table": "group_post_comment",
        "data": {
          "group_post_id": postId.toString(),
          "user_id": userId.toString(),
          "comment": comment,
          "show_date": date,
          "date": date,
        },
      }),
    );

    if (response.statusCode != 200) return false;

    final data = jsonDecode(response.body);

    return data["status"] == true;
  }

  // -------------------------------------------------------
  // FETCH COMMENTS
  // -------------------------------------------------------
  static Future<List<Map<String, dynamic>>> fetchComments(int postId) async {
    print("------ FETCH COMMENTS API ------");
    print("Post ID Sent: $postId");

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "action": "fetch",
        "table": "group_post_comment",
        "where": {"group_post_id": postId.toString()},
      }),
    );

    print("Status Code: ${response.statusCode}");
    print("Raw Response: ${response.body}");

    if (response.statusCode != 200) {
      print("HTTP ERROR");
      return [];
    }

    final data = jsonDecode(response.body);

    if (data["status"] != true) {
      print("API STATUS FALSE");
      return [];
    }

    List list = data["data"];

    print("Total Comments: ${list.length}");

    List<Map<String, dynamic>> comments = [];

    for (var c in list) {
      print("Processing Comment ID: ${c["sno"]}");
      print("User ID: ${c["user_id"]}");

      Map<String, dynamic> user = {};
      try {
        user = await fetchUserProfile(c["user_id"]);
      } catch (_) {
        user = {"name": "User", "profile_image": ""};
      }

      print("Fetched User: ${user["name"]}");

      String img = user["profile_image"] ?? "";
      img = img.replaceAll("../img/", "");

      comments.add({
        "sno": c["sno"],
        "name": user["name"] ?? "User",
        "comment": c["comment"] ?? "",
        "date": c["show_date"] ?? "",
        "image": img.isEmpty ? "" : imageBaseUrl + img,
      });
    }

    print("Mapped Comments List: $comments");

    return comments;
  }
}
