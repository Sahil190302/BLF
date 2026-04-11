import 'package:blf/app/services/api_urls.dart';

import '../api_client.dart';
import '../api_exception.dart';
import '../models/JoinFormModel.dart';

class RepoModel{
  static Future<JoinFormModel?> joinFormModelRepo({
    required String joinReferralId1,
    required String joinReferralId2,
    required String name,
    required DateTime dob,
    required String email,
    required String password,
    required String mobile,
    required String address1,
    required String address2,
    required String city,
    required String state,
    required String pincode,
    required String businessName,
    required String businessCategory,
    required String businessRegistrationNo,
    required String businessAddress,
    required String businessWebsite,
    required String socialMediaLink,
    required String businessYear,
    required String previousJob,
    required String spouseChildren,
    required String pets,
    required String hobbies,
    required String cityResidence,
    required String cityYear,
    required String businessDesire,
    required String somethingAboutMe,
    required String keyToSuccess,
    required DateTime date,
    required String groupCreateLimit,
  }) async {

    final response = await ApiClient.post(
      {
        "action": ApiUrls.joinFormUrl,
        "data": {
          "join_referral_id1": joinReferralId1.trim(),
          "join_referral_id2": joinReferralId2.trim(),
          "name": name.trim(),
          "dob": dob.toString().split(" ").first,
          "email": email.trim(),
          "password": password.trim(),
          "mobile": mobile.trim(),
          "address1": address1.trim(),
          "address2": address2.trim(),
          "city": city.trim(),
          "state": state.trim(),
          "pincode": pincode.trim(),
          "profile_image": "",
          "business_name": businessName.trim(),
          "business_category": businessCategory.trim(),
          "business_registration_no": businessRegistrationNo.trim(),
          "business_address": businessAddress.trim(),
          "business_website": businessWebsite.trim(),
          "social_media_link": socialMediaLink.trim(),
          "business_year": businessYear.trim(),
          "previous_job": previousJob.trim(),
          "spouse_children": spouseChildren.trim(),
          "pets": pets.trim(),
          "hobbies": hobbies.trim(),
          "city_residence": cityResidence.trim(),
          "city_year": cityYear.trim(),
          "business_desire": businessDesire.trim(),
          "something_aboutme": somethingAboutMe.trim(),
          "keyto_success": keyToSuccess.trim(),
          "date": date.toString().split(" ").first,
          "group_create_limit": groupCreateLimit.trim(),
        }
      },
      isAuthRequired: false, // Registration usually doesn't need token
    );

    if (response["status"] == false) {
      throw ApiException(response["message"]);
    }

    return JoinFormModel.fromJson(response);
  }

}