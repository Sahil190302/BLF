import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/app_loader.dart';
import '../../../../utils/app_snackbar.dart';
import '../../../../utils/app_validation.dart';
import '../../../services/api_exception.dart';
import '../../../services/repo/app_repo.dart';
import '../../bottombar/bottom_nav_page.dart';
import '../views/verifiy_otp_screen.dart';

class ForgetPasswordController extends GetxController {
  final emailController = TextEditingController();

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }

  void forgetPasswordApi() async {

    if (!AppValidator.email(emailController.text)) return;

    try {
      AppLoader.show();

      await AuthRepo.forgetPassRepo(
        emailController.text,
      );

      AppLoader.hide(); // 🔥 hide first
      AppSnackbar.success("OTP Send Successful");
      Get.to(() => FillOtpView());

    } on ApiException catch (e) {
      AppLoader.hide(); // 🔥 hide first
      AppSnackbar.error(e.message);

    } catch (e) {
      AppLoader.hide(); // 🔥 hide first
      AppSnackbar.error("Something went wrong");
    }
  }
}
