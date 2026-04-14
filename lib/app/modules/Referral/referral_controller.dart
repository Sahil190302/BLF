import 'package:get/get.dart';
import '../../services/home_api.dart';
import 'referral_api.dart';

class ReferralController extends GetxController {
  var isLoading = false.obs;
  var givenReferrals = <Map<String, dynamic>>[].obs;
var receivedReferrals = <Map<String, dynamic>>[].obs;
  var referrals = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadReferrals();
  }

Future<void> loadReferrals() async {
  try {
    isLoading.value = true;

    final user = await HomeApi.fetchUser();
    final String userSno = user["sno"].toString();

    final given = await ReferralApi.fetchReferralsByField(
      field: "user_id",
      value: userSno,
    );

    final received = await ReferralApi.fetchReferralsByField(
      field: "referral_user_id",
      value: userSno,
    );

    givenReferrals.assignAll(await _enrich(given));
    receivedReferrals.assignAll(await _enrich(received));

  } catch (e) {
    Get.snackbar("Error", e.toString());
  } finally {
    isLoading.value = false;
  }
}

Future<List<Map<String, dynamic>>> _enrich(
    List<Map<String, dynamic>> data) async {
  List<Map<String, dynamic>> enriched = [];

  for (var item in data) {
    final referralUserId = item["referral_user_id"].toString();

    try {
      final name =
          await ReferralApi.fetchUserNameBySno(referralUserId);
      item["referral_user_name"] = name;
    } catch (_) {
      item["referral_user_name"] = "Unknown";
    }

    enriched.add(item);
  }

  return enriched;
}
}