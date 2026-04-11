import 'package:get/get.dart';

class ReceivedRequestsController extends GetxController {
  final requests = <Map>[].obs;

  @override
  void onInit() {
    super.onInit();

    requests.assignAll([
      {
        "name": "Kanchan Lalwani",
        "date": "08/27/2024",
        "profession": "Construction",
        "chapter": " Titans",
        "message": "Hi, please share a testimonial for my services.",
        "image": "https://i.pravatar.cc/150?img=47",
      },
      {
        "name": "Mandeep Manchanda",
        "date": "06/07/2025",
        "profession": "Retail",
        "chapter": "HIGH FLYER",
        "message": "It will help my profile if you can give feedback.",
        "image": "https://i.pravatar.cc/150?img=12",
      },
      {
        "name": "Ravi Chhajer",
        "date": "02/04/2023",
        "profession": "Construction",
        "chapter": " Amber",
        "message": "Requesting testimonial for recent work.",
        "image": "https://i.pravatar.cc/150?img=18",
      },
    ]);
  }

  // ---------------- BUTTON ACTIONS ----------------
  void giveTestimonial(int index) {
    Get.snackbar("Accepted", "Testimonial request accepted");
    requests.removeAt(index);
  }

  void ignoreRequest(int index) {
    Get.snackbar("Ignored", "Request ignored");
    requests.removeAt(index);
  }

  void rejectRequest(int index) {
    Get.snackbar("Rejected", "Request rejected");
    requests.removeAt(index);
  }
}
