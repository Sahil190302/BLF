import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../utils/app_loader.dart';
import '../../../utils/app_snackbar.dart';
import '../../services/app_session.dart';
import 'gallery_api.dart';

class GalleryController extends GetxController {

  final ImagePicker picker = ImagePicker();

  /// Selected file for upload
  Rx<File?> selectedFile = Rx<File?>(null);

  /// My gallery list
  RxList<Map<String, dynamic>> myGallery = <Map<String, dynamic>>[].obs;

  /// Other users gallery list
  RxList<Map<String, dynamic>> usersGallery = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadMyGallery();
    loadUsersGallery();
  }

  /// PICK FILE FROM GALLERY (IMAGE OR VIDEO)
  Future<void> pickFile() async {

    print("STEP 1 → Opening device gallery");

    final XFile? file = await picker.pickMedia();

    if (file != null) {
      selectedFile.value = File(file.path);
      print("STEP 2 → File selected → ${file.path}");
    } else {
      print("STEP 2 → No file selected");
    }
  }

  /// LOAD MY GALLERY
  void loadMyGallery() async {

    try {

      final userId = AppSession.userSno;

      print("STEP 3 → Loading MY gallery for user $userId");

      final data = await GalleryApi.fetchGallery(
        userId: userId!,
      );

      myGallery.value = data;

      print("STEP 4 → My gallery loaded → ${data.length} items");

    } catch (e) {

      print("ERROR → My Gallery fetch failed → $e");

    }
  }

  /// LOAD OTHER USERS GALLERY
  void loadUsersGallery() async {

    try {

      final userId = AppSession.userSno;

      print("STEP 5 → Loading USERS gallery excluding $userId");

      final data = await GalleryApi.fetchUsersGallery(
        userId: userId!,
      );

      usersGallery.value = data;

      print("STEP 6 → Users gallery loaded → ${data.length} items");

    } catch (e) {

      print("ERROR → Users Gallery fetch failed → $e");

    }
  }

  /// UPLOAD FILE TO GALLERY
  Future<void> submitGallery() async {

    try {

      if (selectedFile.value == null) {
        AppSnackbar.error("Please upload file");
        return;
      }

      AppLoader.show();

      final userId = AppSession.userSno;

      print("STEP 7 → Uploading gallery file");

      final response = await GalleryApi.insertGallery(
        userId: userId!,
        file: selectedFile.value!,
      );

      print("STEP 8 → Upload API response");
      print(response);

      AppLoader.hide();

      AppSnackbar.success("Gallery uploaded successfully");

      /// Refresh my gallery after upload
      loadMyGallery();

      /// clear selected file
      selectedFile.value = null;

    } catch (e) {

      print("ERROR → Upload failed → $e");

      AppLoader.hide();
      AppSnackbar.error(e.toString());
    }
  }
}