import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProfileApi {

  static const String _url =
      "https://bhartiyacoders.com/WEBSITE/YASH/blf_app_akshay/api/index.php";

  static Future<bool> uploadProfileImage({
    required int sno,
    required File imageFile,
  }) async {

    final request = http.MultipartRequest("POST", Uri.parse(_url));

    request.fields["action"] = "update";
    request.fields["table"] = "user";
    request.fields["where[sno]"] = sno.toString();

    request.files.add(
      await http.MultipartFile.fromPath(
        "profile_image",
        imageFile.path,
      ),
    );

    final response = await request.send();
    final body = await response.stream.bytesToString();

    print("ServerResponse: $body");

    if (response.statusCode != 200) return false;

    final res = jsonDecode(body);
    return res["status"] == true;
  }
}