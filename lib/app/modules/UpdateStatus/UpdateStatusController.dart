  import 'package:flutter/cupertino.dart';
  import 'package:get/get.dart';

  class UpdateStatusController extends GetxController {
    var selectedDate = DateTime.now().obs;

     TextEditingController commentstextfiled = TextEditingController();
     // TextEditingController name = TextEditingController();
    TextEditingController nametextfiled = TextEditingController();


    var selectedStatus = ''.obs;

    List<String> statusList = [
      "Not contacted yet",
      "Contacted",
      "No response",
      "Got the business",
      "Did not get the business",
      "Not a good fit",
      "Confidential",
    ];

    void updateStatus() {

      Get.snackbar("Success", "Status Updated Successfully");
    }

    @override
    void onClose() {
      nametextfiled.dispose();
      commentstextfiled.dispose();
      super.onClose();
    }
  }
