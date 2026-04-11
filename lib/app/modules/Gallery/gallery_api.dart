import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class GalleryApi {
  static const String url =
      "https://bhartiyacoders.com/WEBSITE/YASH/blf_app_akshay/api/index.php";

  static const String fileBaseUrl =
      "https://bhartiyacoders.com/WEBSITE/YASH/blf_app_akshay/img/";

  static Future<Map<String, dynamic>> insertGallery({
    required String userId,
    required File file,
  }) async {
    print("STEP 1 → Gallery API started");

    final currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    print("STEP 2 → Date = $currentDate");

    print("STEP 3 → UserId = $userId");

    print("STEP 4 → File Path = ${file.path}");
    print("STEP 5 → File Exists = ${file.existsSync()}");
    print("STEP 6 → File Size = ${file.lengthSync()} bytes");

    var request = http.MultipartRequest('POST', Uri.parse(url));

    request.fields['action'] = "insert";
    request.fields['table'] = "gallery";

    request.fields['data[user_id]'] = userId;
    request.fields['data[date]'] = currentDate;

    print("STEP 7 → Fields Added");

    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    print("STEP 8 → File attached to request");

    print("STEP 9 → Sending request");

    var response = await request.send();

    print("STEP 10 → HTTP Status = ${response.statusCode}");

    var responseData = await response.stream.bytesToString();

    print("STEP 11 → Raw Response");
    print(responseData);

    final data = jsonDecode(responseData);

    print("STEP 12 → Parsed JSON");
    print(data);

    if (response.statusCode == 200 && data["status"] == true) {
      print("STEP 13 → Gallery upload success");
      return data;
    } else {
      print("STEP 14 → API Error");
      throw Exception(data["message"] ?? "Gallery upload failed");
    }
  }

    static Future<List<Map<String, dynamic>>> fetchGallery({
    required String userId,
  }) async {

    print("STEP 1 → Fetch Gallery API called");
    print("STEP 2 → userId = $userId");

    final payload = {
      "action": "fetch",
      "table": "gallery",
      "where": {"user_id": userId}
    };

    print("STEP 3 → Payload");
    print(jsonEncode(payload));

    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(payload),
    );

    print("STEP 4 → Status Code = ${response.statusCode}");
    print("STEP 5 → Raw Response = ${response.body}");

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data["status"] == true) {
      print("STEP 6 → Gallery data received");

      List<Map<String, dynamic>> gallery =
          List<Map<String, dynamic>>.from(data["data"]);

      /// Convert relative paths to full URLs
      for (var item in gallery) {
        String file = item["file"];

        if (!file.startsWith("http")) {
          file = file.replaceAll("../img/", "");
          item["file"] = fileBaseUrl + file;
        }
      }

      return gallery;

    } else {
      throw Exception("Gallery fetch failed");
    }
  }

  static Future<List<Map<String, dynamic>>> fetchUsersGallery({
  required String userId,
}) async {

  print("STEP 1 → Fetch Users Gallery API");

  final payload = {
    "action": "fetchWithFilters",
    "table": "gallery",
    "filters": {
      "user_id_not": userId
    }
  };

  print("STEP 2 → Payload");
  print(jsonEncode(payload));

  final response = await http.post(
    Uri.parse(url),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode(payload),
  );

  print("STEP 3 → Status Code = ${response.statusCode}");
  print("STEP 4 → Raw Response = ${response.body}");

  final data = jsonDecode(response.body);

  if (response.statusCode == 200 && data["status"] == true) {

    List<Map<String, dynamic>> gallery =
        List<Map<String, dynamic>>.from(data["data"]);

    for (var item in gallery) {
      String file = item["file"];

      if (!file.startsWith("http")) {
        file = file.replaceAll("../img/", "");
        item["file"] = fileBaseUrl + file;
      }
    }

    print("STEP 5 → Users gallery loaded");

    return gallery;

  } else {
    throw Exception("Users gallery fetch failed");
  }
}
}
