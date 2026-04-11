import 'dart:async';
import 'package:get/get.dart';
import 'package:blf/app/services/app_session.dart';
import '../../../../routes/app_routes.dart';

class SplashController extends GetxController {

  @override
  void onInit() {
    super.onInit();
    startSplashTimer();
  }

  void startSplashTimer() {

    Timer(const Duration(seconds: 3), () {

      if (AppSession.isLoggedIn) {
        Get.offAllNamed(Routes.BOTTOM_NAV);
      } else {
        Get.offAllNamed(Routes.LOGIN);
      }

    });
  }
}