import 'package:get/get.dart';
import '../../services/home_api.dart';
import 'referral_api.dart';

class ReferralController extends GetxController {
  var isLoading = false.obs;
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

    final data =
        await ReferralApi.fetchReferrals(userId: userSno);

    List<Map<String, dynamic>> enriched = [];

    for (var item in data) {
      final referralUserId =
          item["referral_user_id"].toString();

      try {
        final name =
            await ReferralApi.fetchUserNameBySno(
                referralUserId);
        item["referral_user_name"] = name;
      } catch (_) {
        item["referral_user_name"] = "Unknown";
      }

      enriched.add(item);
    }

    referrals.assignAll(enriched);
  } catch (e) {
    Get.snackbar("Error", e.toString());
  } finally {
    isLoading.value = false;
  }
}
}