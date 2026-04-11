import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/app_loader.dart';
import '../../../../utils/app_snackbar.dart';
import '../../../../utils/app_validation.dart';
import '../../../services/api_exception.dart';
import '../../../services/repo/app_repo.dart';
import '../../bottombar/bottom_nav_page.dart';
import '../views/verifiy_otp_screen.dart';

class VerifiyOtpController extends GetxController {

  final List<TextEditingController> otpControllers =
  List.generate(4, (_) => TextEditingController());

  @override
  void onClose() {
    for (var controller in otpControllers) {
      controller.dispose();
    }
    super.onClose();
  }

  void verifyOtpApi() async {

    String otp = otpControllers.map((e) => e.text).join();

    if (!AppValidator.otp(otp)) return;

    try {
      AppLoader.show();

      await AuthRepo.verifyOtpRepo(otp);

      AppLoader.hide();
      AppSnackbar.success("OTP Verified Successfully");

    } on ApiException catch (e) {
      AppLoader.hide();
      AppSnackbar.error(e.message);
    } catch (e) {
      AppLoader.hide();
      AppSnackbar.error("Something went wrong");
    }
  }
}
