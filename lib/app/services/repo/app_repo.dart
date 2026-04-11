
import 'package:blf/app/services/models/JoinFormModel.dart';
import 'package:blf/app/services/models/forget_password_model.dart';

import '../../modules/OneToOneMeeting/model/meeting_model.dart';
import '../../modules/outsidereferral/Controller/referral_model.dart';
import '../api_client.dart';
import '../api_exception.dart';
import '../api_urls.dart';
import '../models/user_model.dart';

class AuthRepo {
  // Login
    static Future<LoginModel?> loginRepo(String email, String pass) async {
      final response = await ApiClient.post({
        "action": ApiUrls.loginUrl,
        "email": email,
        "password": pass,
      });
      if (response["status"] == false) {
        throw ApiException(response["message"]);
      }
      return LoginModel.fromJson(response);
    }

  static Future<ForgetPasswordModel?> forgetPassRepo(String email) async {
    final response = await ApiClient.post({
      "action": ApiUrls.forgetPasswordUrl,
      "email": email.trim(),
    });

    if (response["status"] == false) {
      throw ApiException(response["message"]);
    }

    return ForgetPasswordModel.fromJson(response);
  }
  static Future<ForgetPasswordModel?> verifyOtpRepo(String otp) async {
    final response = await ApiClient.post({
      "action": ApiUrls.resetPasswordUrl,
      "token": 'reset-token-from-email',
      "otp": otp.trim(),
    });

    if (response["status"] == false) {
      throw ApiException(response["message"]);
    }

    return ForgetPasswordModel.fromJson(response);
  }
  static Future<ReferralModel?> insertReferralRepo({
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

    final response = await ApiClient.post(
      {
        "action": ApiUrls.insertReferralUrl,
        "data": {
          "user_id": userId,
          "referral_user_id": referralUserIds,
          "referral_type": referralType,
          "referral_status": referralStatus,
          "email": email.trim(),
          "mobile": mobile.trim(),
          "address": address.trim(),
          "comment": comment.trim(),
          "referral_hot_rating": referralHotRating,
        }
      },
      isAuthRequired: true, // if token required
    );

    if (response["status"] == false) {
      throw ApiException(response["message"]);
    }

    return ReferralModel.fromJson(response);
  }


  static Future<MeetingModel?> insertMeetingRepo({
    required int userId,
    required List<int> withUserIds,
    required String location,
    required DateTime meetingDate,
    required String agenda,
    required String meetingSummary,
    required bool setReminder,
  }) async {

    final response = await ApiClient.post(
      {
        "action": ApiUrls.insertMeetingUrl,
        "data": {
          "user_id": userId,
          "with_user_id": withUserIds,
          "location": location.trim(),
          "meeting_date":
          meetingDate.millisecondsSinceEpoch ~/ 1000, // ✅ UNIX timestamp
          "agenda": agenda.trim(),
          "meeting_summary": meetingSummary.trim(),
          "set_reminder": setReminder ? 1 : 0,
          "date": meetingDate.toString().split(" ").first,
        }
      },
      isAuthRequired: true,
    );

    if (response["status"] == false) {
      throw ApiException(response["message"]);
    }

    return MeetingModel.fromJson(response);
  }

  static Future<MeetingModel?> insertThankYouRepo({
    required int userId,
    required List<int> givenUserIds,
    required double amount,
    required String businessCategory,
    required String referralType,
    required String description,
    required DateTime date,
    required int status,
  }) async {

    final response = await ApiClient.post(
      {
        "action": ApiUrls.insertthankyouUrl,
        "data": {
          "user_id": userId,
          "given_user_id": givenUserIds,
          "amount": amount,
          "business_category": businessCategory.trim(),
          "referral_type": referralType.trim(),
          "description": description.trim(),
          "date": date.toString().split(" ").first,
          "status": status,
        }
      },
      isAuthRequired: true,
    );

    if (response["status"] == false) {
      throw ApiException(response["message"]);
    }

    return MeetingModel.fromJson(response);
  }

    static Future<JoinFormModel?> joinFormRepo({
      required String joinReferralId1,
      required String joinReferralId2,
      required String name,
      required DateTime dob,
      required String email,
      required String mobile,
      required String address1,
      required String businessName,
      required String businessCategory,
      required String businessRegistrationNo,
      required String businessAddress,
      required String businessWebsite,
      required String socialMediaLink,
      required String businessYear,
      required String otherGroupNameController,
      required String image,
      required String agree,
    }) async {

      final response = await ApiClient.post(
        {
          "action": ApiUrls.joinFormUrl,
          "data": {
            "name": name.trim(),
            "mobile": mobile.trim(),
            "email": email.trim(),
            "address1": address1.trim(),
            "business_name": businessName.trim(),
            "business_category": businessCategory.trim(),
            "business_year": businessYear.trim(),
            "business_registration_no": businessRegistrationNo.trim(),
            "dob": dob.toString().split(" ").first,
            "business_address": businessAddress.trim(),
            "business_website": businessWebsite.trim(),
            "social_media_link": socialMediaLink.trim(),
            "join_referral_id1": joinReferralId1.trim(),
            "join_referral_id2": joinReferralId2.trim(),
            "koi_group_ke_member_ho": otherGroupNameController.trim(),
            "password": "11123hdqw111",
            "terms_condition_agree": agree,
            "profile_image": image,

          }
        },
        isAuthRequired: false, // Registration usually doesn't need token
      );

      if (response["status"] == false) {
        throw ApiException(response["message"]);
      }

      return JoinFormModel.fromJson(response);
    }

    static Future<JoinFormModel?> addVisitorRepo({
      required String joinReferralId1,
      required String joinReferralId2,
      required String name,
      required DateTime dob,
      required String email,
      required String mobile,
      required String address1,
      required String businessName,
      required String businessCategory,
      required String businessRegistrationNo,
      required String businessAddress,
      required String businessWebsite,
      required String socialMediaLink,
      required String businessYear,
      required String otherGroupNameController,
      required String image,
      required String agree,
    }) async {

      final response = await ApiClient.post(
        {
          "action": ApiUrls.joinFormUrl,
          "data": {
            "name": name.trim(),
            "mobile": mobile.trim(),
            "email": email.trim(),
            "address1": address1.trim(),
            "business_name": businessName.trim(),
            "business_category": businessCategory.trim(),
            "business_year": businessYear.trim(),
            "business_registration_no": businessRegistrationNo.trim(),
            "dob": dob.toString().split(" ").first,
            "business_address": businessAddress.trim(),
            "business_website": businessWebsite.trim(),
            "social_media_link": socialMediaLink.trim(),
            "join_referral_id1": joinReferralId1.trim(),
            "join_referral_id2": joinReferralId2.trim(),
            "koi_group_ke_member_ho": otherGroupNameController.trim(),
            "password": "11123hdqw111",
            "terms_condition_agree": agree,
            "profile_image": image,

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
