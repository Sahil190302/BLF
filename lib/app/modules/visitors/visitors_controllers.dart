import 'package:get/get.dart';
import '../../services/home_api.dart';
import '../../services/app_session.dart';

class VisitorsController extends GetxController {
  RxInt selectedTab = 0.obs;

  RxList<Map<String, dynamic>> visitors =
      <Map<String, dynamic>>[].obs;

  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadVisitors();
  }

 Future<void> loadVisitors() async {
  try {
    isLoading.value = true;

    print("----- LOAD VISITORS START -----");

    final user = await HomeApi.fetchUser();
    print("Fetched User: $user");

    final joinReferralId = user["referral_code"];
    print("Join Referral ID From User: $joinReferralId");

    if (joinReferralId == null || joinReferralId.toString().isEmpty) {
      print("Join Referral ID is NULL or EMPTY");
      visitors.clear();
      return;
    }

    final response =
        await HomeApi.fetchVisitors(joinReferralId: joinReferralId);

    print("Visitors API Response Length: ${response.length}");
    print("Visitors API Response Data: $response");

    visitors.value = response;

    print("Visitors Assigned To RxList: ${visitors.length}");
    print("----- LOAD VISITORS END -----");

  } catch (e, stack) {
    print("ERROR IN loadVisitors(): $e");
    print("STACK TRACE: $stack");
    visitors.clear();
  } finally {
    isLoading.value = false;
  }
}
}