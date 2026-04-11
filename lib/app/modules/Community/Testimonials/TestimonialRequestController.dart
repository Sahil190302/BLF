import 'package:get/get.dart';
import 'package:blf/app/modules/Community/Testimonials/testimonials_controller.dart';
import 'package:blf/app/modules/Community/Testimonials/testimonials_api.dart';

class TestimonialRequestController extends GetxController {
  final TestimonialsController mainController =
      Get.find<TestimonialsController>();

  RxList<Map<String, dynamic>> get requests => mainController.requests;

  /// ACCEPT → status = 1
  Future<void> giveTestimonial(int index) async {
    final int sno = requests[index]["sno"];

    final success = await TestimonialsApi.acceptTestimonial(sno);

    if (success) {
      await mainController.loadAllData();
    }
  }

  /// REJECT → delete record
  Future<void> rejectRequest(int index) async {
    final int sno = requests[index]["sno"];

    final success = await TestimonialsApi.rejectTestimonial(sno);

    if (success) {
      await mainController.loadAllData();
    }
  }

  void ignoreRequest(int index) {
    requests.removeAt(index);
  }
}
