import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:blf/app/services/home_api.dart';
import 'profile_api.dart';

class ProfileController extends GetxController {

  var profileImage = "".obs;
  var name = "".obs;
  var category = "".obs;

  var activeStatus = "ACTIVE".obs;
  var dueDate = "".obs;
  var classification = "".obs;

  static const String imageBaseUrl =
      "https://bhartiyacoders.com/WEBSITE/YASH/blf_app_akshay/img/";

  int? userSno;
  Map<String, dynamic>? userData;

  final ImagePicker picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {

    final user = await HomeApi.fetchUser();

    userData = user;
    userSno = user["sno"];

    name.value = user["name"] ?? "";
    category.value = user["business_category"] ?? "";
    classification.value = user["business_category"] ?? "";
    dueDate.value = user["date"] ?? "";

    final image = user["profile_image"];

    if (image != null && image.toString().isNotEmpty) {
      profileImage.value = imageBaseUrl + image;
    } else {
      profileImage.value = "https://picsum.photos/200";
    }
  }

  Future<void> pickProfileImage() async {
    try {

      print("---- PROFILE IMAGE PICK START ----");

      final XFile? picked = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );

      if (picked == null) {
        print("Image selection cancelled");
        return;
      }

      final file = File(picked.path);

      print("Selected image path: ${file.path}");
      print("Image exists: ${file.existsSync()}");
      print("Image size(bytes): ${await file.length()}");
      print("User Sno: $userSno");

      /// show image immediately
      profileImage.value = file.path;

      /// upload
      final success = await ProfileApi.uploadProfileImage(
        sno: userSno!,
        imageFile: file,
      );

      print("Upload success: $success");

      if (success) {
        print("Refreshing profile...");
        await fetchUserProfile();
      }

      print("---- PROFILE IMAGE PICK END ----");

    } catch (e, stack) {
      print("PROFILE IMAGE ERROR: $e");
      print(stack);
    }
  }
}