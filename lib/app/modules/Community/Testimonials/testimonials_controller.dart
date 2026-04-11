import 'package:blf/app/modules/Community/Testimonials/testimonials_api.dart';
import 'package:get/get.dart';
import 'package:blf/app/services/home_api.dart';

class TestimonialsController extends GetxController {
  var selectedTab = 0.obs;

  var receivedCount = 0.obs;
  var givenCount = 0.obs;
  var requestCount = 0.obs;

  var received = <Map<String, dynamic>>[].obs;
  var given = <Map<String, dynamic>>[].obs;
  var requests = <Map<String, dynamic>>[].obs;
  

  String userSno = "";
  String userName = "";

  @override
  void onInit() {
    super.onInit();
    loadAllData();
  }

  Future<void> loadAllData() async {
    try {
      /// Get logged-in user
      final user = await HomeApi.fetchUser();
      userSno = user["sno"].toString();
      userName = user["name"] ?? "";

      await Future.wait([loadReceived(), loadGiven(), loadRequests()]);
    } catch (_) {
      received.clear();
      given.clear();
      requests.clear();
    }
  }

  Future<void> loadReceived() async {
  try {
    final data = await TestimonialsApi.fetchReceived(userSno);

    List<Map<String, dynamic>> tempList = [];

    for (var item in data) {
      final senderSno = item["user_id"].toString();

      final userData =
          await TestimonialsApi.fetchUserBySno(senderSno);

      tempList.add({
        "sno": item["sno"],
        "name": userData?["name"] ?? "Unknown",
        "date": item["date"] ?? "",
        "message": item["description"] ?? "",
        "amount": item["amount"] ?? 0,
        "image": userData?["profile_image"] != null
            ? "https://bhartiyacoders.com/WEBSITE/YASH/blf_app_akshay/${userData!["profile_image"]}"
            : "https://cdn-icons-png.flaticon.com/512/219/219983.png",
      });
    }

    received.value = tempList;
    receivedCount.value = tempList.length;
  } catch (_) {
    received.clear();
    receivedCount.value = 0;
  }
}

 Future<void> loadGiven() async {
  try {
    final data = await TestimonialsApi.fetchGiven(userSno);

    List<Map<String, dynamic>> tempList = [];

    for (var item in data) {
      final receiverSno = item["given_user_id"].toString();

      final userData =
          await TestimonialsApi.fetchUserBySno(receiverSno);

      tempList.add({
        "sno": item["sno"],
        "name": userData?["name"] ?? "Unknown",
        "date": item["date"] ?? "",
        "amount": item["amount"] ?? 0,
        "message": item["description"] ?? "",
        "image": userData?["profile_image"] != null
            ? "https://bhartiyacoders.com/WEBSITE/YASH/blf_app_akshay/${userData!["profile_image"]}"
            : "https://cdn-icons-png.flaticon.com/512/219/219983.png",
      });
    }

    given.value = tempList;
    givenCount.value = tempList.length;
  } catch (_) {
    given.clear();
    givenCount.value = 0;
  }
}

Future<void> loadRequests() async {
  try {
    final data = await TestimonialsApi.fetchRequests(userSno);

    List<Map<String, dynamic>> tempList = [];

    for (var item in data) {
      final senderSno = item["user_id"].toString();

      final userData =
          await TestimonialsApi.fetchUserBySno(senderSno);

      tempList.add({
        "sno": item["sno"],
        "name": userData?["name"] ?? "Unknown",
        "date": item["date"] ?? "",
        "amount": item["amount"] ?? 0,
        "message": item["description"] ?? "",
        "image": userData?["profile_image"] != null
            ? "https://bhartiyacoders.com/WEBSITE/YASH/blf_app_akshay/${userData!["profile_image"]}"
            : "https://cdn-icons-png.flaticon.com/512/219/219983.png",
      });
    }

    requests.value = tempList;
    requestCount.value = tempList.length;
  } catch (_) {
    requests.clear();
    requestCount.value = 0;
  }
}

  void changeTab(int index) {
    selectedTab.value = index;
  }
}
