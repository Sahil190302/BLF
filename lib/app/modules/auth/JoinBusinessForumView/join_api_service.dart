import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class JoinApiService {
  static const String url =
      "https://bhartiyacoders.com/WEBSITE/YASH/blf_app_akshay/api/index.php";



static Future<Map<String, dynamic>> submitJoinForm({
  required String referral1,
  required String referral2,
  required String name,
  required String email,
  required String mobile,
  required String businessName,
  required String businessCategory,
  required String registrationNo,
  required String businessAddress,
  required String website,
  required String socialLink,
  required String businessYear,
  required String isOtherGroupMember,
  required String termsAgree,
  required String yearlyFeeAgree,
  required File? profileImage,
}) async {

  var request = http.MultipartRequest(
    'POST',
    Uri.parse(url),
  );

  request.fields['action'] = "insert";
  request.fields['table'] = "join";

  request.fields['data[join_referral_id1]'] = referral1;
request.fields['data[join_referral_id2]'] = referral2;
request.fields['data[name]'] = name;
request.fields['data[email]'] = email;
request.fields['data[mobile]'] = mobile;
request.fields['data[business_name]'] = businessName;
request.fields['data[business_category]'] = businessCategory;
request.fields['data[business_registration_no]'] = registrationNo;
request.fields['data[business_address]'] = businessAddress;
request.fields['data[business_website]'] = website;
request.fields['data[social_media_link]'] = socialLink;
request.fields['data[business_year]'] = businessYear;
request.fields['data[koi_group_ke_member_ho]'] = isOtherGroupMember;
request.fields['data[terms_condition_agree]'] = termsAgree;
request.fields['data[meeting_fee_deposit_yearly_advance_agree]'] = yearlyFeeAgree;
request.fields['data[date]'] =
    DateTime.now().toString().split(" ").first;
request.fields['data[status]'] = "1";

  if (profileImage != null) {
    request.files.add(
      await http.MultipartFile.fromPath(
        'profile_image',   // must match backend expected key
        profileImage.path,
      ),
    );
  }

  var response = await request.send();
  var responseData = await response.stream.bytesToString();

  return jsonDecode(responseData);
}
}
