import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class VisitorApiService {

  static const String url =
      "https://bhartiyacoders.com/WEBSITE/YASH/blf_app_akshay/api/index.php";

 static Future<Map<String, dynamic>> submitVisitor({
  required String name,
  required String email,
  required String mobile,
  required String businessName,
  required String businessCategory,
  required String businessWebsite,
  required String businessYear,
  required String businessAddress,
  required String isOtherGroupMember,
   required String referralCode,
  required File? paymentImage,
}) async {

  var request = http.MultipartRequest(
    'POST',
    Uri.parse(url),
  );

  request.fields['action'] = "insert";
  request.fields['table'] = "visitor";

 request.fields['data[name]'] = name;
request.fields['data[email]'] = email;
request.fields['data[mobile]'] = mobile;
request.fields['data[business_name]'] = businessName;
request.fields['data[business_category]'] = businessCategory;
request.fields['data[business_website]'] = businessWebsite;
request.fields['data[business_year]'] = businessYear;
request.fields['data[business_address]'] = businessAddress;
request.fields['data[koi_group_ke_member_ho]'] = isOtherGroupMember;
request.fields['data[join_referral_id]'] = referralCode;
request.fields['data[date]'] =
    DateTime.now().toString().split(" ").first;
request.fields['data[status]'] = "0";

  if (paymentImage != null) {
    request.files.add(
      await http.MultipartFile.fromPath(
        'payment_screenshot',
        paymentImage.path,
      ),
    );
  }

  var response = await request.send();
  var responseData = await response.stream.bytesToString();

  return jsonDecode(responseData);
}
}