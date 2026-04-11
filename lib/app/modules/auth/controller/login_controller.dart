import 'package:blf/app/services/app_session.dart';
import 'package:blf/app/services/auth_api.dart';
import 'package:blf/app/services/home_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/app_loader.dart';
import '../../../../utils/app_snackbar.dart';
import '../../../../utils/app_validation.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

Future<bool> loginUser() async {

  final email = emailController.text.trim();
  final password = passwordController.text.trim();

  if (!AppValidator.email(email)) return false;
  if (!AppValidator.password(password)) return false;

  try {

    AppLoader.show();

    final token = await AuthApi.login(email, password);

    AppSession.saveToken(token);

    final user = await HomeApi.fetchUser();

    AppSession.saveUserSno(user['sno'].toString());

    AppSession.setLoggedIn(true);

    /// SAVE EMAIL HERE
    final List<String> emails =
        (AppSession.get("saved_emails") ?? []).cast<String>();

    if (!emails.contains(email)) {
      emails.add(email);
      AppSession.set("saved_emails", emails);
    }

    print("Saved Sno → ${AppSession.userSno}");

    return true;

  } catch (e) {

    AppSnackbar.error("Invalid email or password");
    return false;

  } finally {

    AppLoader.hide();

  }
}
}