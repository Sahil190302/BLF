import 'package:blf/app/modules/Referral/referral_api.dart';
import 'package:get/get.dart';
import '../../services/home_api.dart';
import 'p2p_api.dart';

class P2PController extends GetxController {
  var isLoading = false.obs;
  var meetings = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadMeetings();
  }

 Future<void> loadMeetings() async {
  try {
    isLoading.value = true;

    final user = await HomeApi.fetchUser();
    final String sno = user["sno"].toString();

    final data = await P2PApi.fetchMeetings(userId: sno);

    // attach user names
    List<Map<String, dynamic>> enriched = [];

    for (var item in data) {
      final withUserId = item["with_user_id"].toString();

      try {
        final name =
            await ReferralApi.fetchUserNameBySno(withUserId);
        item["with_user_name"] = name;
      } catch (_) {
        item["with_user_name"] = "Unknown";
      }

      enriched.add(item);
    }

    meetings.assignAll(enriched);
  } catch (e) {
    Get.snackbar("Error", e.toString());
  } finally {
    isLoading.value = false;
  }
}
}