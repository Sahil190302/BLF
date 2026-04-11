import 'package:get/get.dart';
import 'package:blf/app/modules/Testimonials_Quick/testi_api.dart';
import 'package:blf/app/services/home_api.dart';

class TestimonialQuickController extends GetxController {

  var selectedTab = 0.obs;

  var received = <Map<String, dynamic>>[].obs;
  var given = <Map<String, dynamic>>[].obs;
 var userNames = <String, String>{}.obs;

  String userId = "";

  @override
  void onInit() {
    super.onInit();
    initializeUser();
  }

  void changeTab(int index) {
    selectedTab.value = index;
  }

 Future<void> resolveUserNames(
    List<Map<String, dynamic>> list, String idKey) async {

  for (var item in list) {
    String id = item[idKey].toString();

    if (!userNames.containsKey(id)) {
      String name = await TestimonialApi.fetchUserName(id);
      userNames[id] = name;
    }
  }
}

Future<void> refreshTestimonials() async {
  await loadReceived();
  await loadGiven();
}

  // STEP 1 — FETCH LOGGED USER
  Future<void> initializeUser() async {

    print("----- FETCH USER START -----");

    final user = await HomeApi.fetchUser();

    userId = user["sno"].toString();

    print("Logged User SNO: $userId");

    await loadReceived();
    await loadGiven();
  }

  // STEP 2 — RECEIVED TESTIMONIALS
Future<void> loadReceived() async {

  received.value = await TestimonialApi.fetchReceived(userId);

  await resolveUserNames(received, "member_id");
}

  // STEP 3 — GIVEN TESTIMONIALS
 Future<void> loadGiven() async {

  given.value = await TestimonialApi.fetchGiven(userId);

  await resolveUserNames(given, "user_id");
}
}