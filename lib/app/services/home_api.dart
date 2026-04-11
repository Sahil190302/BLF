import 'dart:convert';
import 'dart:io';
import 'package:blf/app/services/app_session.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class HomeApi {
  static const String _url =
      "https://bhartiyacoders.com/WEBSITE/YASH/blf_app_akshay/api/index.php";

  static Future<Map<String, dynamic>> fetchUser() async {
    final token = AppSession.token;

    if (token == null) {
      throw Exception("Token not found");
    }

    final response = await http.post(
      Uri.parse(_url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "action": "fetch",
        "table": "user",
        "where": {"api_token": token},
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data["status"] == true) {
      return data["data"][0];
    } else {
      throw Exception("User not found");
    }
  }

 static Future<List<Map<String, dynamic>>> fetchTodayMeetingNotification({
  required String userId,
}) async {

  final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

  final response = await http.post(
    Uri.parse(_url),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "action": "fetch",
      "table": "notification",
      "where": {
        "user_id": userId,
        "notification_type": "once",
        "upload_by": "admin",
        "attend_status": ""
      },
      "where_lte": {                     // <= condition
        "notification_push_date": today
      }
    }),
  );

  final data = jsonDecode(response.body);

  if (response.statusCode == 200 && data["status"] == true) {
    return List<Map<String, dynamic>>.from(data["data"]);
  } else {
    return [];
  }
}

 static Future<bool> updateAttendance({
  required int sno,
  required String status,
  required String attend,
}) async {
  try {
    final response = await http.post(
      Uri.parse(_url),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "action": "update",
        "table": "notification",
        "data": {
          "attend_status": status,
          "attend_remark": attend
        },
        "where": {
          "sno": sno
        }
      }),
    );

    if (response.statusCode != 200) {
      return false;
    }

    final Map<String, dynamic> data = jsonDecode(response.body);

    if (data.containsKey("status") && data["status"] == true) {
      return true;
    }

    return false;
  } catch (e) {
    return false;
  }
}

  static Future<List<Map<String, dynamic>>> fetchUpcomingEvents({
    required String userId,
  }) async {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    final response = await http.post(
      Uri.parse(_url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "action": "fetchWithFilters",
        "table": "notification",
        "where": {"user_id": userId},
        "filters": {"notification_push_date_after": today},
        "order_by": {"field": "notification_push_date", "direction": "asc"},
        "pagination": {"limit": 10, "offset": 0},
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data["status"] == true) {
      return List<Map<String, dynamic>>.from(data["data"]);
    } else {
      return [];
    }
  }

  static Future<Map<String, dynamic>> fetchMonthlyDashboard({
    required String sno,
    required int periodMonths,
  }) async {
    final response = await http.post(
      Uri.parse(_url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "action": "user_dashboard_monthly",
        "sno": sno,
        "period_months": periodMonths,
        "date_field": "date",
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data["status"] == true) {
      return data;
    } else {
      throw Exception("Monthly dashboard data not found");
    }
  }

  static Future<Map<String, dynamic>> insertThankYou({
    required int userId,
    required double amount,
    required String businessCategory,
    required String referralType,
    required String description,
    required String date,
    required List<int> givenUserIds,
  }) async {
    final response = await http.post(
      Uri.parse(_url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "action": "insert_thankyou",
        "data": {
          "user_id": userId,
          "amount": amount.toStringAsFixed(2),
          "business_category": businessCategory,
          "referral_type": referralType,
          "description": description,
          "date": date,
          "given_user_id": givenUserIds,
          "status":1
        },
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data["status"] == true) {
      return data;
    } else {
      throw Exception("Failed to insert thank you");
    }
  }

  static Future<List<Map<String, dynamic>>> fetchAllUsers() async {
    final response = await http.post(
      Uri.parse(_url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"action": "fetch", "table": "user"}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data["status"] == true) {
      return List<Map<String, dynamic>>.from(data["data"]);
    } else {
      throw Exception("Users not found");
    }
  }

  static Future<Map<String, dynamic>> fetchMonthlyByMonth({
    required String sno,
    required String month,
  }) async {
    final response = await http.post(
      Uri.parse(_url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "action": "user_dashboard_monthly",
        "sno": sno,
        "month": month,
        "date_field": "date",
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data["status"] == true) {
      return data;
    } else {
      throw Exception("Monthly (by month) data not found");
    }
  }

  static Future<Map<String, dynamic>> fetchDashboard(String sno) async {
    final response = await http.post(
      Uri.parse(_url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"action": "user_dashboard", "sno": sno}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data["status"] == true) {
      return data;
    } else {
      throw Exception("Dashboard data not found");
    }
  }

  static Future<Map<String, dynamic>> insertMeeting({
    required int userId,
    required List<int> withUserIds,
    required String location,
    required DateTime meetingDate,
    required String initiatedBy,
    required String agenda,
    required String meetingSummary,
    required File? image,
  }) async {
    final formattedMeetingDate = DateFormat('yyyy-MM-dd').format(meetingDate);

    final currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    print("------ INSERT MEETING API ------");
    print("User ID: $userId");
    print("With Users: $withUserIds");
    print("Location: $location");
    print("Meeting Date: $formattedMeetingDate");
    print("Initiated By: $initiatedBy");
    print("Agenda: $agenda");
    print("Summary: $meetingSummary");
    print("Date Created: $currentDate");

    if (image != null) {
      print("Image Selected: ${image.path}");
      print("Image Exists: ${image.existsSync()}");
      print("Image Size: ${image.lengthSync()} bytes");
    } else {
      print("Image: NULL (no image selected)");
    }

    var request = http.MultipartRequest('POST', Uri.parse(_url));

    request.fields['action'] = "insert_meeting";

    request.fields['data[user_id]'] = userId.toString();
    for (int i = 0; i < withUserIds.length; i++) {
      request.fields['data[with_user_id][$i]'] = withUserIds[i].toString();
    }
    request.fields['data[location]'] = location;
    request.fields['data[meeting_date]'] = formattedMeetingDate;
    request.fields['data[initiated_by]'] = initiatedBy;
    request.fields['data[agenda]'] = agenda;
    request.fields['data[date]'] = currentDate;
    request.fields['data[meeting_summary]'] = meetingSummary;

    print("Request Fields:");
    request.fields.forEach((key, value) {
      print("$key : $value");
    });

    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath('image', image.path));
      print("Image attached to multipart request");
    }

    print("Sending request to: $_url");

    var response = await request.send();

    print("HTTP Status Code: ${response.statusCode}");

    var responseData = await response.stream.bytesToString();

    print("Raw API Response:");
    print(responseData);

    final data = jsonDecode(responseData);

    if (response.statusCode == 200 && data["status"] == true) {
      print("Meeting inserted successfully");
      return data;
    } else {
      print("API ERROR: ${data["message"]}");
      throw Exception(data["message"] ?? "Failed to schedule meeting");
    }
  }

  static Future<Map<String, dynamic>> insertReferral({
    required int userId,
    required List<int> referralUserIds,
    required String referralType,
    required String referralStatus,
    required String email,
    required String mobile,
    required String address,
    required String comment,
    required String referralHotRating,
  }) async {
    final currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    final response = await http.post(
      Uri.parse(_url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "action": "insert_referral",
        "data": {
          "user_id": userId,
          "referral_user_id": referralUserIds,
          "referral_type": referralType,
          "referral_status": referralStatus,
          "email": email,
          "mobile": mobile,
          "address": address,
          "comment": comment,
          "referral_hot_rating": referralHotRating,
          "date": currentDate,
        },
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data["status"] == true) {
      return data;
    } else {
      throw Exception("Failed to confirm referral");
    }
  }

  static Future<List<Map<String, dynamic>>> fetchVisitors({
    required String joinReferralId,
  }) async {
    print("---- FETCH VISITORS API ----");
    print("Join Referral ID Sent: $joinReferralId");

    final response = await http.post(
      Uri.parse(_url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "action": "fetch",
        "table": "visitor",
        "where": {"join_referral_id": joinReferralId},
      }),
    );

    print("Status Code: ${response.statusCode}");
    print("Raw Response: ${response.body}");

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data["status"] == true) {
      print("Visitors Count: ${data["data"].length}");
      return List<Map<String, dynamic>>.from(data["data"]);
    } else {
      print("Visitors API Failed");
      throw Exception("Visitors not found");
    }
  }
}
