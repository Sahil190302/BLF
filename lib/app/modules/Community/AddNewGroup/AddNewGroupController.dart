import 'package:get/get.dart';

class AddNewGroupController extends GetxController {
  var groupName = "".obs;
  var groupType = "".obs;
  var accessType = "".obs;
  var language = "".obs;
  var selectedConnections = 0.obs;
  var description = "".obs;

  // DROPDOWN DATA
  final List<String> groupTypeList = [
    "Open",
    "Invite Only",
    "Members Can Invite",
  ];

  final List<String> accessTypeList = [
    "Public",
    "Private",
    "Restricted",
  ];

  final List<String> languageList = [
    "Arabic",
    "Bosnian",
    "English",
    "Hindi",
    "Spanish",
    "French",
  ];

  void resetFields() {
    groupName.value = "";
    groupType.value = "";
    accessType.value = "";
    language.value = "";
    selectedConnections.value = 0;
    description.value = "";
  }

  void submitForm() {
    if (groupName.isEmpty) {
      Get.snackbar("Error", "Group name is required");
      return;
    }
    if (groupType.isEmpty) {
      Get.snackbar("Error", "Group type is required");
      return;
    }
    if (accessType.isEmpty) {
      Get.snackbar("Error", "Access type is required");
      return;
    }
    if (language.isEmpty) {
      Get.snackbar("Error", "Language is required");
      return;
    }
    if (description.isEmpty) {
      Get.snackbar("Error", "Description is required");
      return;
    }

    Get.snackbar("Success", "Group Created Successfully!");
  }
}
